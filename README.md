# MSVC command line wrapper

A wrapper using Batch file to allow the direct and easier use of the MSVC compilation commands (`cl` and `rc`) in the command line.

Put the batch files somewhere on your computer and add the directory to PATH environment variables, and then you can use the `cl` and `rc` command easily (just as easily as using gcc:

```bash
cl your_source_file.c
```

for either console or windows programs).

---

Features:

- Auto set the platform toolset directories for MSVC.
  - Here I'm using the directories of v141_xp toolset, x86 platform. You can modify them to the directories of your desired version (directories are taken from VS -> Project Properties -> VC++ Directories).
  - A x64 platform version of the commands (as `cl-x64` and `rc-x64`) is also provided.
- Auto define macros `_UNICODE`, `UNICODE` for wide character support.
- Auto link common Windows libraries.
- Auto detect subsystem (console or windows).
