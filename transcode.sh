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

if [ -f "/output/$OUTPUT_FILE" ]; then
    echo "$OUTPUT_FILE already exists"
    exit 2
fi

# Allow presets to come from outside but still provide my usuals
if [ ! -d /storage/presets ]; then
    echo "INFO: No presets provided. Downloading Devin's presets."
    mkdir -p /storage/presets
    git clone --depth 1 https://github.com/DHandspikerWade/handbrake-presets.git /tmp/presets
    cp /tmp/presets/*.json /storage/presets/
    rm -rf /tmp/presets
fi

echo "INFO: Starting Handbrake"
HandBrakeCLI --preset-import-file  /storage/presets/*.json -Z "$PRESET_NAME" ${HANDBRAKE_ARGS:-""} -i "/input/$INPUT_FILE" -o /storage/transcoding


output_path=$(dirname "$OUTPUT_FILE")
echo "INFO: Creating /output/$output_path"
mkdir -p /output/"$output_path"
echo "INFO: Moving tempfile to /output/$OUTPUT_FILE"
mv /storage/transcoding /output/"$OUTPUT_FILE"