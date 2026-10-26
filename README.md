# weedy

Zephyr application for the `nucleo_c562re`. This repo is the west manifest; it
pins Zephyr in `west.yml` and lives inside a west workspace:

```
workspace/
├── weedy/   ← this repo
├── zephyr/       ← fetched by west
└── modules/      ← fetched by west
```

## Setup

```sh
mkdir workspace && cd workspace
git clone https://github.com/chinmaygarde/weedy.git
cd weedy
just init
just sdk
```

## Build & flash

```sh
just build
just flash
```

Build output goes to `workspace/build`.

## Editor setup

`.clangd` points clangd at `workspace/build/compile_commands.json` (run
`just build` first). clangd also needs
`--query-driver='**/arm-zephyr-eabi-*'` to find the Zephyr SDK's C++ standard
library headers; `weedy.sublime-project` sets this for Sublime Text's
LSP-clangd.
