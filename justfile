BOARD_NAME := "nucleo_c562re"

# Run west from the workspace root (the parent of this repo).
[working-directory: ".."]
@west *args:
  uv run --project microhello west {{args}}

build: (west "build" "-b" BOARD_NAME "microhello/app" "-d" "build")

[working-directory: ".."]
@clean:
  rm -rf build

flash: build (west "flash" "-d" "build")

sdk: update (west "sdk" "install")

update: (west "update") (west "packages" "pip" "--install")

# Run once after cloning this repo into an empty workspace directory.
init: (west "init" "-l" "microhello")
