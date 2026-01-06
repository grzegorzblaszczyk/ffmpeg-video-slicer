#!/usr/bin/env bash

# Copyright Grzegorz Błaszczyk 2026

AWK=`which awk`
CAT=`which cat`
FFMPEG=`which ffmpeg`
TR=`which tr`
XARGS=`which xargs`

set -euo pipefail

function print_help() {
    echo "Usage:"
    echo "$0 -i [input_file] -s [slice_timestamps_file] -l [audio_lang_code] -o [output_file_pattern]"
    echo ""
    echo "Example:"
    echo "$0 -i input.mp4 -s scenes.txt -l eng -o output-scene%02d.mp4"
}

INPUT_FILE=""
SCENES_FILE=""
AUDIO_LANG=""
VERBOSE=""
OUTPUT_PATTERN=""

while getopts "i:s:l:o:v:h" opt; do
  case $opt in
    i) INPUT_FILE="$OPTARG" ;;
    s) SCENES_FILE="$OPTARG" ;;
    l) AUDIO_LANG="$OPTARG" ;;
    o) OUTPUT_PATTERN="$OPTARG" ;;
    v) VERBOSE="$OPTARG" ;;
    h) print_help; exit 0 ;;
    *) print_help; exit 1 ;;
  esac
done

if [[ -z "${INPUT_FILE}" || -z "${SCENES_FILE}" || -z "${OUTPUT_PATTERN}" ]]; then
  echo "Error: Missing required arguments"
  print_help
  exit 1
fi

if [[ ! -f "${INPUT_FILE}" ]]; then
  echo "Error: Input file '$INPUT_FILE' does not exist"
  exit 1
fi

if [[ ! -f "${SCENES_FILE}" ]]; then
  echo "Error: Scenes file '${SCENES_FILE}' does not exist"
  exit 1
fi

LANG_OPTIONS=""
LOG_LEVEL_OPTIONS=" -loglevel error"

if [[ "x${AUDIO_LANG}" != "x" ]]; then
  LANG_OPTIONS="-map 0:a:m:language:${AUDIO_LANG}"
else
  LANG_OPTIONS="-map 0:a:m:language:eng"
fi

if [[ -n "${VERBOSE}" ]]; then
  LOG_LEVEL_OPTIONS=" -loglevel warning"
fi

echo "$0 with params:"
echo "  Input file: ${INPUT_FILE}"
echo "  Scenes file: ${SCENES_FILE}"
echo "  Audio lang: ${AUDIO_LANG}"
echo "  Language options: ${LANG_OPTIONS}"
echo "  Verbose: ${VERBOSE}"
echo "  Output file pattern: ${OUTPUT_PATTERN}"

i=1

readarray scenes < ${SCENES_FILE}

echo "Loaded scenes:"
for scene in "${scenes[@]}"; do
  echo -n "  ${scene}"
done

for line in "${scenes[@]}"; do
  [[ -z "$line" ]] && continue

  SEGMENT_START=$(echo "$line" | ${AWK} '{print $1}')
  SEGMENT_END=$(echo "$line" | ${AWK} '{print $2}')

  SEGMENT_START="${SEGMENT_START//$'\r'/}"
  SEGMENT_END="${SEGMENT_END//$'\r'/}"

  [[ -z "${SEGMENT_START}" || -z "${SEGMENT_END}" ]] && continue  # skip incorrect lines (without end)
  printf -v N "%02d" $i

  echo "Start: ${SEGMENT_START}"
  echo "End: ${SEGMENT_END}"

  OUTPUT_FILE=$(printf "$OUTPUT_PATTERN" "$N")
  echo "Processing scene $N: ${SEGMENT_START} -> ${SEGMENT_END} -> $OUTPUT_FILE"

  ${FFMPEG} -i "${INPUT_FILE}" -ss "${SEGMENT_START}" -to "${SEGMENT_END}" -map 0:v ${LANG_OPTIONS} -c:v copy -c:a copy -reset_timestamps 1 ${LOG_LEVEL_OPTIONS} "${OUTPUT_FILE}"

  echo "Processed scene $N: ${SEGMENT_START} -> ${SEGMENT_END} -> OK"

	((i++))
done

echo "Done! Generated $((i-1)) files."

