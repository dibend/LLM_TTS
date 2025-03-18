<h1>Steampunk Phi4 TTS</h1>

<p>
  Welcome to the <strong>Steampunk Phi4 TTS</strong> project. This project converts LLM responses to speech using a TTS pipeline.
</p>

<h2>Features</h2>
<ul>
  <li>LLM to TTS pipeline integration</li>
  <li>Works with Festival TTS, Ollama, and Phi4:14b</li>
  <li>Optional FastAPI web interface</li>
</ul>

<h2>Installation on Ubuntu 24.04 LTS</h2>
<ol>
  <li>
    Update your system:
    <pre><code>sudo apt update && sudo apt upgrade -y</code></pre>
  </li>
  <li>
    Install required packages:
    <pre><code>sudo apt install festival festvox-us-slt-hts markdown -y</code></pre>
  </li>
  <li>
    Install Ollama from <a href="https://ollama.ai/">Ollama's website</a>
  </li>
  <li>
    Clone the repository:
    <pre><code>git clone https://github.com/dibend/LLM_TTS.git
cd LLM_TTS</code></pre>
  </li>
  <li>
    Make the TTS script executable:
    <pre><code>chmod +x phi4tts.sh</code></pre>
  </li>
</ol>

<h2>Usage</h2>
<p>To run the TTS pipeline using the bash script:</p>
<pre><code>./phi4tts.sh "Your prompt text here"</code></pre>

<p>For the FastAPI web interface:</p>
<ol>
  <li>
    Install Python 3, FastAPI, and Uvicorn:
    <pre><code>sudo apt install python3 python3-pip -y
pip3 install fastapi uvicorn</code></pre>
  </li>
  <li>
    Run the server (assuming your server file is named <code>server.py</code>):
    <pre><code>uvicorn server:app --host 0.0.0.0 --port 8000</code></pre>
  </li>
  <li>
    Access the web interface at <a href="http://localhost:8000/">http://localhost:8000/</a>
  </li>
</ol>
