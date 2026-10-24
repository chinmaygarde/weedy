# microhello

Zephyr application for the `nucleo_c562re`. This repo is the west manifest; it
pins Zephyr in `west.yml` and lives inside a west workspace:

```
workspace/
├── microhello/   ← this repo
├── zephyr/       ← fetched by west
└── modules/      ← fetched by west
```

## Setup

```sh
mkdir workspace && cd workspace
git clone <this repo> microhello
cd microhello
just init
just sdk
```

## Build & flash

```sh
just build
just flash
```

Build output goes to `workspace/build`.
