# How to contribute to Reface

Thanks for showing interest in contributing to rbx-reface. This is mostly a solo developer project so any support is welcome!

## Setup

Tools are managed via [Rokit](https://github.com/rojo-rbx/rokit). Install Rokit first, then run:

```
rokit install
```

This installs [Rojo](https://rojo.space) and [Wally](https://wally.run) at the versions pinned in `rokit.toml`.

To build the package:

```
rojo build --output build/build.rbxm
```

## Working on the module

The code should be well typed, documented when needed (but as self-documenting as possible), and easy to modify. Don't be scared to break up small things into their own functions, tables, or even submodules (especially data).

A few conventions to follow:

- **Naming**: `camelCase` for functions and variables, `PascalCase` for type names.
- **Types**: all function parameters and return values should be typed. Shared types live in `typing.luau`.
- **String interpolation**: use backtick interpolation (`` `like {this}` ``) rather than `..` concatenation.
- **Errors**: use `warn()` with a `rbx-reface: ` prefix for non-fatal issues, rather than `error()` or `print()`.
- 
## Working on the face databases

The face databases (`faceByBundle.luau` and `faceByMesh.luau`) are generated - don't edit them by hand.

`scripts/faces.csv` is a plain list of face asset IDs. When a new face is added or the list changes, regenerate the databases by running:

```
uv run scripts/codegen.py
```

The script hits the Roblox catalog API to resolve each face ID to its bundle, then resolves the bundle to its head mesh asset. It writes the results directly into `src/faceByBundle.luau` and `src/faceByMesh.luau`. It includes retry logic for rate limits, but may still be slow if you're adding many faces at once.

Python 3.13+ is required. [uv](https://astral.sh/uv) handles the dependency (`requests`) automatically.

## Opening issues and pull requests

- For bugs, please include the relevant head or face asset ID.
- For larger changes (new features, restructuring), open an issue first so we can verify where we're at before you put in the work.
- For small fixes or database additions, a PR directly is fine.
