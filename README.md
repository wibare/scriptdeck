# scriptdeck – Personal CLI Toolkit

**scriptdeck** is a growing collection of practical Bash scripts for everyday tasks on Linux. The focus is on simplicity, minimal dependencies, and compatibility with both Wayland and X11 environments. Designed primarily for Debian-based systems.

This project is under active development. More scripts will be added and refined over time.

---

## Scripts Overview

| Script             | Description                                       | Example Usage                          |
|--------------------|---------------------------------------------------|----------------------------------------|
| `copyfile.sh`      | Copy text file contents to clipboard              | `./copyfile.sh notes.txt`              |
| `copyimage.sh`     | Copy image file to clipboard                      | `./copyimage.sh logo.png`              |
| `resizeimg.sh`     | Resize image(s) with optional proportions         | `./resizeimg.sh cat.jpg 300 auto`      |
| `audio_convert.sh` | Convert audio files to another format             | `./audio_convert.sh song.wav mp3`      |
| `extract.sh`       | Extract compressed archives intelligently         | `./extract.sh archive.tar.gz`          |
| `fileinfo.sh`      | Show detailed file information                    | `./fileinfo.sh notes.txt`              |
| `links.sh`         | Save, tag, search, edit and open URLs in Markdown | `./links.sh add https://debian.org`    |


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

### `extract.sh`

```bash
sudo apt install file unzip p7zip-full unrar-free
```

### `fileinfo.sh`

```bash
sudo apt install coreutils file
```

### `links.sh`

```bash
# To open links in your default browser
sudo apt install xdg-utils
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

### `extract.sh`

Extract a `.tar.gz` archive:

```bash
./extract.sh project.tar.gz
```

Extract a `.zip` file:

```bash
./extract.sh backup.zip
```

Extract a `.7z` file:

```bash
./extract.sh music.7z
```
Extracted contents are saved in a new folder named after the archive, with a `_extracted` suffix.
For example, `project.tar.gz` will be extracted to `project_extracted/`.

### `fileinfo.sh`

Display detailed information about a file:

```bash
./fileinfo.sh notes.txt
```
If the file is a text file, it will also show line and word counts.
Output includes size, MIME type, encoding, permissions, timestamps, inode, hash values (MD5, SHA1, SHA256), and more.

### `links.sh`

Manage personal web bookmarks directly from the terminal:

```bash
./links.sh add https://github.com "My GitHub" --tags dev,code
./links.sh list
./links.sh search github
./links.sh edit 1
./links.sh delete 1
./links.sh open 1
```

For example, the command:

```bash
./links.sh add https://github.com "My GitHub" --tags dev,code
```
Will store the following entry in `~/.scriptdeck-links/links.md:`

```markdown
- [My GitHub](https://github.com) @dev @code
  Saved: 2025-07-01 22:43
```

You can then list saved links, search by keyword, edit or delete an entry, or open it in your default browser using its number.


## License

MIT License – Free to use, modify, and distribute.