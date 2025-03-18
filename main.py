import os
import subprocess
import tempfile
import time
import shutil

from fastapi import FastAPI, Form, HTTPException
from fastapi.responses import FileResponse, HTMLResponse
from fastapi.staticfiles import StaticFiles

app = FastAPI()

# Mount static files from the "static" directory at /static
app.mount("/static", StaticFiles(directory="static"), name="static")

# Serve index.html at the root path "/"
@app.get("/", response_class=HTMLResponse)
def read_index():
    index_path = os.path.join("static", "index.html")
    if not os.path.exists(index_path):
        raise HTTPException(status_code=404, detail="Index file not found")
    with open(index_path, "r", encoding="utf-8") as f:
        return f.read()

@app.post("/tts")
def tts(prompt: str = Form(...)):
    """
    Receives a text prompt, creates a temporary working directory,
    and runs the TTS bash script (phi4tts.sh) with STDIN redirected.
    The script's output (output.wav) is polled for and then served.
    """
    # Create a temporary directory for this request
    temp_dir = tempfile.mkdtemp(prefix="tts_")
    script_path = "/home/aiw1/tts/phi4tts.sh"  # Adjust this path as needed

    try:
        # Run the TTS script with the provided prompt.
        # Redirect STDIN from DEVNULL to avoid issues when run under nohup.
        subprocess.run(
            [script_path, prompt],
            cwd=temp_dir,
            stdin=subprocess.DEVNULL,
            check=True
        )
    except subprocess.CalledProcessError as e:
        shutil.rmtree(temp_dir)
        raise HTTPException(status_code=500, detail=f"Error running script: {e}")

    final_audio = os.path.join(temp_dir, "output.wav")

    # Poll for the generated output file (timeout after 120 seconds)
    timeout = 120
    waited = 0
    while not os.path.exists(final_audio):
        time.sleep(1)
        waited += 1
        if waited > timeout:
            shutil.rmtree(temp_dir)
            raise HTTPException(status_code=500, detail="TTS processing timed out")

    # Return the audio file
    return FileResponse(final_audio, media_type="audio/wav", filename="output.wav")

