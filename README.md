# scriptdeck – Personal CLI Toolkit

**scriptdeck** is a growing collection of practical Bash scripts for everyday tasks on Linux. The focus is on simplicity, minimal dependencies, and compatibility with both Wayland and X11 environments. Designed primarily for Debian-based systems.

This project is under active development. More scripts will be added and refined over time.

---

## Scripts Overview

| Script             | Description                               | Example Usage                          |
|--------------------|-------------------------------------------|----------------------------------------|
| `copyfile.sh`      | Copy text file contents to clipboard      | `./copyfile.sh notes.txt`              |
| `copyimage.sh`     | Copy image file to clipboard              | `./copyimage.sh logo.png`              |
| `resizeimg.sh`     | Resize image(s) with optional proportions | `./resizeimg.sh cat.jpg 300 auto`      |
| `audio_convert.sh` | Convert audio files to another format   | `./audio_convert.sh song.wav mp3`        |

---

## Dependencies (Debian)

The following packages must be installed for the scripts to function correctly.

### `copyfile.sh`

```bash
# For Wayland
sudo apt install wl-clipboard

# For X11
sudo apt install xclip
```

### `copyimage.sh`

```bash
sudo apt install file           # for MIME type detection
sudo apt install wl-clipboard   # for Wayland
sudo apt install xclip          # for X11
```

### `resizeimg.sh`

```bash
sudo apt install imagemagick
```

### `audio_convert.sh`

```bash
sudo apt install ffmpeg
```

---

## Examples

### `copyfile.sh`

Copy any text file to the clipboard:

```bash
./copyfile.sh todo.txt
```

### `copyimage.sh`

Copy an image to the clipboard:

```bash
./copyimage.sh banner.png
```

### `resizeimg.sh`

Resize a single image:

```bash
./resizeimg.sh avatar.jpg 200 200
```

Resize all images in a directory to height 300px (preserving width proportionally):

```bash
./resizeimg.sh ~/Pictures auto 300
```

All resized images are saved in a `resized/` folder inside the original directory.

### `audio_convert.sh`

Convert a single audio file:

```bash
./audio_convert.sh song.wav mp3
```
Convert all supported audio files in a folder:

```bash
./audio_convert.sh ./Music/ ogg
```
All converted files are saved in a `converted` folder inside the original directory.

Supported input formats include: `wav`, `mp3`, `ogg`, `flac`, `m4a`, `aac`.

## License

MIT License – Free to use, modify, and distribute.