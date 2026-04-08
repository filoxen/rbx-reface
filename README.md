# rbx-reface

<p align="center">
  <img src="https://github.com/filoxen/rbx-reface/blob/main/.github/assets/refaceiconv2.png" width=200 />
</p>


Restore classic decal faces following the Dynamic Head Migration.

Characters wearing a dynamic head that was migrated from a classic face will have their head replaced with the appropriate classic mesh and face. Dynamic heads that were never associated with a classic face are left untouched.

## Installation

Install via [Wally](https://wally.run):

```toml
[server-dependencies]
reface = "secret-rare/rbx-reface@1.0.0"
```

Alternatively, download the `.rbxm` file from the [Releases](https://github.com/filoxen/rbx-reface/releases) tab and insert it into your place.

## Usage

Call `reface.init()` once from a server `Script`. It will handle all current and future players automatically.

```lua
local reface = require(game.ServerScriptService.Packages.reface)

reface.init()
```

## Acknowledgements

[Dawgra/Facial-Unification](https://github.com/Dawgra/Facial-Unification) was the repo that inspired the creation of this one - it served as a design inspiration for this module.

[synpixel/roblox-classic-faces](https://github.com/synpixel/roblox-classic-faces) was a great resource to get a full list of Classic Faces.
