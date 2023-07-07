#/bin/bash
set -e

if [ -z "$PRESET_NAME" ]; then
    echo "PRESET_NAME is undefined"
    exit 1
fi

if [ -z "$INPUT_FILE" ]; then
    echo "INPUT_FILE is undefined"
    exit 1
fi

if [ -z "$OUTPUT_FILE" ]; then
    echo "OUTPUT_FILE is undefined"
    exit 1
fi

git clone https://github.com/DHandspikerWade/handbrake-presets.git /storage/presets

HandBrakeCLI --preset-import-file  /storage/presets/*.json -Z "$PRESET_NAME" ${HANDBRAKE_ARGS:-""} -i "/input/$INPUT_FILE" -o /storage/transcoding


output_path=$(dirname "$OUTPUT_FILE")
echo "Creating: /output/$output_path"
mkdir -p /output/"$output_path"
echo "moving to: /output/$OUTPUT_FILE"
mv /storage/transcoding /output/"$OUTPUT_FILE"
echo Done