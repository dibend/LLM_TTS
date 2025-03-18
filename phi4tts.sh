#!/bin/bash
set -euo pipefail

# Ensure a prompt was provided
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 \"your prompt text here\""
    exit 1
fi

OUTPUT_FILE="output.md"
PROCESSED_FILE="processed.txt"
FINAL_AUDIO="output.wav"

# Check if Festival is installed
if ! command -v festival >/dev/null 2>&1; then
    echo "⚠️ Festival TTS is not installed. Install it using: sudo apt install festival festvox-us-slt-hts"
    exit 1
fi

# Check if Ollama is installed
if ! command -v ollama >/dev/null 2>&1; then
    echo "⚠️ Ollama is not installed. Install it from https://ollama.ai/"
    exit 1
fi

# Check if Markdown is installed
if ! command -v markdown >/dev/null 2>&1; then
    echo "⚠️ Markdown is not installed. Install it using: sudo apt install markdown"
    exit 1
fi

echo "📝 Running Ollama... (This may take a while)"
# Run Ollama with the provided prompt; output is saved to $OUTPUT_FILE
ollama run phi4:14b "$1" > "$OUTPUT_FILE"

echo "📄 Processing Markdown and removing HTML tags..."
# Process the Markdown and strip out HTML tags
markdown "$OUTPUT_FILE" | sed -e 's/<[^>]*>//g' > "$PROCESSED_FILE"
echo "✅ Processed text saved."

echo "🎙️ Converting text to speech with Festival TTS..."

# Verify that we have valid processed text
if [ ! -s "$PROCESSED_FILE" ]; then
    echo "⚠️ No valid text to convert."
    exit 1
fi

# Read the processed text into a variable and use a here-string to feed it to text2wave
text=$(< "$PROCESSED_FILE")
text2wave -o "$FINAL_AUDIO" <<< "$text"

echo "✅ Final audio saved as $FINAL_AUDIO"
echo "🎧 Done! You can listen to your audio at: $FINAL_AUDIO"

