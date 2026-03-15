# findgo

`findgo.sh` searches recursively from the current directory for the first file or directory with the given name.

If it finds:
- a directory, it changes into that directory
- a file, it changes into the file's parent directory

## Install

1. Put `findgo.sh` somewhere permanent, for example:

   ```bash
   mkdir -p ~/.local/bin
   cp /home/lawrence/repos/findgo/findgo.sh ~/.local/bin/findgo.sh
   chmod +x ~/.local/bin/findgo.sh
   ```

2. Add this function to your `~/.bashrc`:

   ```bash
   findgo() {
       source <~/.local/bin>/findgo.sh "$1"
   }
   ```

3. Reload Bash:

   ```bash
   source ~/.bashrc
   ```

## Usage

Run it from the directory where you want the recursive search to start:

```bash
findgo target_name
```

Examples:

```bash
findgo package.json
findgo src
```

## Notes

- The script must be sourced, directly or through a shell function, because `cd` must run in your current shell.
- If you execute the script normally, it can only print the matching directory. It cannot change your shell's current directory.