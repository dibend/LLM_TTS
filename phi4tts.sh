#!/bin/bash

OUTPUT_FILE="output.md"
PROCESSED_FILE="processed.txt"
FINAL_AUDIO="output.wav"

# Check if Festival is installed
if ! command -v festival &> /dev/null; then
    echo "⚠️ Festival TTS is not installed. Install it using: sudo apt install festival festvox-us-slt-hts"
    exit 1
fi

# Check if Ollama is installed
if ! command -v ollama &> /dev/null; then
    echo "⚠️ Ollama is not installed. Install it from https://ollama.ai/"
    exit 1
fi

# Check if Markdown is installed
if ! command -v markdown &> /dev/null; then
    echo "⚠️ Markdown is not installed. Install it using: sudo apt install markdown"
    exit 1
fi

echo "📝 Running Ollama... (This may take a while)"
ollama run phi4:14b "$1" > "$OUTPUT_FILE"

echo "📄 Processing Markdown and removing HTML tags..."
markdown "$OUTPUT_FILE" | sed -e 's/<[^>]*>//g' > "$PROCESSED_FILE"
echo "✅ Processed text saved."

echo "🎙️ Converting text to speech with Festival TTS..."

if [ ! -s "$PROCESSED_FILE" ]; then
    echo "⚠️ No valid text to convert."
    exit 1
fi

# Use Festival to generate speech
text=$(cat "$PROCESSED_FILE")
echo "$text" | text2wave -o "$FINAL_AUDIO"

echo "✅ Final audio saved as $FINAL_AUDIO"
echo "🎧 Done! You can listen to your audio at: $FINAL_AUDIO"
