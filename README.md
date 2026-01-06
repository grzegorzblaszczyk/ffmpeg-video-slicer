![ffmpeg-video-slicer-demo](https://github.com/user-attachments/assets/58ebda53-39ba-4410-a278-b93c39c525c2)

# Description

🎬 FFmpeg Video Slicer

**ffmpeg-video-slicer** is a lightweight CLI tool powered by ffmpeg that splits videos into scenes based on a list of timestamps and allows selecting a specific audio track by language code.

➡️ Perfect for automatically cutting long recordings, scene series, educational materials, or batch video processing.

## 🚀 Features

* ✂️ Splits videos into multiple clips using ffmpeg and a timestamp specification file
* 🎧 Select audio track by language code (e.g., eng / pol / fra ...)
* 📁 Generates files with a customizable naming pattern
* 🐚 Simple shell script for quick execution

## 📦 Requirements

This tool requires:

1. ffmpeg — installed and available in your $PATH

ffmpeg is a powerful audio/video processing tool (conversion, cutting, mux/demux) — it acts as the backend for our slicer. (ffmpeg.org)

## 💡 Installation

1. Clone the repository:

```bash
git clone https://github.com/grzegorzblaszczyk/ffmpeg-video-slicer.git
cd ffmpeg-video-slicer
```

2. Make sure ffmpeg is installed:

```bash
ffmpeg -version
```

3. Make the script executable:

```bash
chmod +x ffmpeg-video-slicer.sh
```

# 🧠 Usage

Example:

```bash
./ffmpeg-video-slicer.sh \
  -i input.mp4 \
  -s scenes.txt \
  -l eng \
  -o output%02d.mp4
```

where

| Parameter | Description                          |
| --------- | ------------------------------------ |
| `-i`      | Input video file                     |
| `-s`      | File containing a list of timestamps |
| `-l`      | Audio language code to select        |
| `-o`      | Output filename pattern              |
| `-v`      | Verbose stdout                       |

## 📄 Example Timestamp File

```txt
00:00:00 00:02:13
00:02:15 00:05:07
00:05:10 00:08:45
```

# 📌 Why This Tool?

When working with large video materials, you often need to cut scenes precisely by time or automatically split a video into logical segments without manual editing.
This tool:

* automates the process,
* leverages ffmpeg's power,
* allows audio track selection by language,
* is super-lightweight and ready to integrate into other scripts

# 🧪 Testing

This project includes automated tests for the Bash scripts.

## Requirements

Make sure you have:

* bash ≥ 4
* ffmpeg
* bats-core (Bash Automated Testing System)

Install bats-core on macOS:

```bash
brew install bats-core
```

On Debian/Ubuntu:
```bash
sudo apt install bats
```

## Running tests

From the project root:

```bash
cd tests
bats test_ffmpeg_video_slicer.bats
```

## Test structure
```lua
tests/
├── test_ffmpeg_video_slicer.bats
├── fixtures/
│   └── [MP4 and MP3 sample files]
└── tmp/
````

## What is tested

Tests verify that:

* video segments are generated correctly
* output files exist
* ffmpeg commands return exit code 0
* invalid input is handled properly

# 👍 Support & Contribute

Want to help? Feel free to:

* ✏️ Improve the documentation
* 🐛 Report bugs
* 💡 Add new features

Pull requests and issues are always welcome! ❤️

# 📝 License

This project is licensed under the MIT License.
