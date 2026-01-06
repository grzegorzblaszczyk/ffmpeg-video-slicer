#!/usr/bin/env bats

setup() {
  # Setup
  mkdir -p tmp
  cp fixtures/file_example_MP4_480-multi-audio.mp4 tmp/
  cp fixtures/scenes.txt tmp/
  cd tmp
}

teardown() {
  # Cleanup
  cd ..
  rm -rf tmp
}

@test "script slices video without errors" {
  run ../../ffmpeg-video-slicer.sh -i file_example_MP4_480-multi-audio.mp4 -s scenes.txt -l eng -o output-scene-%02d.mp4
  [ "$status" -eq 0 ]
  [ -f output-scene-01.mp4 ]
  [ -f output-scene-02.mp4 ]
}

@test "script handles missing input file" {
  run ../../ffmpeg-video-slicer.sh -i missing.mp4 -s scenes.txt -l eng -o output-scene-%02d.mp4
  [ "$status" -ne 0 ]
}

@test "script handles verbose flag " {
  run ../../ffmpeg-video-slicer.sh -i missing.mp4 -s scenes.txt -l eng -v yes -o output-scene-%02d.mp4
  [ "$status" -ne 0 ]
}

