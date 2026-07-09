# findgo

`findgo` is a small Bash helper that searches recursively from the current directory for the first file or directory whose basename matches a target name exactly.

When it finds a match:

- If the match is a directory, it changes into that directory.
- If the match is a file, it changes into the file's parent directory.
- It reports how many directories and files were traversed before the match was found.

## Features

- Exact basename matching for files and directories, with a substring fallback so targets like "admin" can match names such as "linux-admin.md"
- Works when sourced directly or through a shell function
- Shows traversal counts for the successful match
- Summarizes permission-denied traversal failures as a count
- Includes `--help` and `--version`
- Safe handling for spaces and shell-sensitive characters in paths

## Requirements

- Bash
- `find` from a standard Unix-like environment

## Installation

The preferred installation method is to clone this repository into `~/repos/findgo`, then expose it through a shell function so it can change the current shell's directory.

```bash
mkdir -p ~/repos
git clone https://github.com/llagerlof/findgo ~/repos/findgo
chmod +x ~/repos/findgo/findgo
```

Add this function to your `~/.bashrc`, `~/.bash_profile`, or equivalent Bash startup file:

```bash
findgo() {
    source ~/repos/findgo/findgo "$@"
}
```

Reload your shell configuration:

```bash
source ~/.bashrc
```

If you prefer a standalone script install instead of keeping the repository checkout, you can copy the script to a permanent location and source it from there:

```bash
mkdir -p ~/.local/bin
cp ./findgo ~/.local/bin/findgo
chmod +x ~/.local/bin/findgo
```

Add this function to your `~/.bashrc`, `~/.bash_profile`, or equivalent Bash startup file:

```bash
findgo() {
    source ~/.local/bin/findgo "$@"
}
```

## Usage

Run `findgo` from the directory where you want the recursive search to start:

```bash
findgo <name>
```

Examples:

```bash
findgo package.json
findgo src
findgo README.md
```

Help and version:

```bash
findgo --help
findgo --version
```

## Example Output

```text
$ findgo package.json
Traversed 3 directories and 8 files before the match.
Changed directory to: /home/user/project/app
```

If you run the script directly instead of sourcing it, it will still search and report the match, but it cannot change the current shell directory:

```text
$ ./findgo package.json
Traversed 3 directories and 8 files before the match.
Found in: ./app
Run this script with: source ./findgo package.json
```

## Notes

- The search is based on the basename only, not a relative path.
- If no exact basename match exists, a substring match against the basename is also accepted.
- Names containing `/` are rejected because the script matches a single file or directory name.
- Search order follows the order produced by `find`, so the first match is the first one encountered during traversal.
- Permission-denied traversal failures are suppressed during the search and reported as a final count instead.
- If no match is found, the script exits with a non-zero status.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE).
