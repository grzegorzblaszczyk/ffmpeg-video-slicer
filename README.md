# Description

ffmpeg Video Slicer is a video slicer that uses ffmpeg and a file with timestamps to generate output files. You can also specify which audio stream to use in output files.

# Usage

```bash
./ffmpeg-video-slicer.sh -i [input_file] -s [slice_timestamps_file] -l [audio_lang_code] -o [output_file_pattern]
```

```bash
# Example:
./ffmpeg-video-slicer.sh -i input.mp4 -s scenes.txt -l eng -o output-scene%02d.mp4
```


