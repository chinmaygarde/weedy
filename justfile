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

CXX_FILES := "git ls-files -z --cached --others --exclude-standard '*.cc' '*.cpp' '*.h' '*.hpp'"

# Format C++ sources in place.
@format:
  {{CXX_FILES}} | xargs -0 uv run clang-format -i

# Fail if any C++ source isn't formatted.
@check-format:
  {{CXX_FILES}} | xargs -0 uv run clang-format --dry-run --Werror

# Open the board's serial console. Exit with Ctrl-].
@monitor port=`ls /dev/cu.usbmodem* 2>/dev/null | head -1`:
  uv run python -m serial.tools.miniterm --raw --quiet {{port}} 115200
