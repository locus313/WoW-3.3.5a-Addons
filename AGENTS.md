# AGENTS.md

## Project Overview

A curated collection of World of Warcraft addons for the **3.3.5a (WotLK) client** (interface version `30300`, Lua 5.1). The repo includes vanilla 3.3.5a addons and addons **back-ported** from newer WoW clients. Back-porting replaces modern post-WotLK APIs with their 3.3.5a equivalents.

**Hard constraint:** Every `.toc` file must declare `## Interface: 30300`. Any other value breaks the addon for the target client.

---

## Repository Structure

The root contains ~100 addon folders, each self-contained. Suite addons share a naming prefix (e.g., `HidingBar` + `HidingBar_Options`).

```
<AddonName>/
├── <AddonName>.toc       # TOC manifest — interface version, ordered file list
├── compat_335.lua        # (back-ported addons only) shim file — listed FIRST in TOC
├── <AddonName>.lua       # Primary Lua entry point
├── *.lua                 # Additional Lua modules
├── *.xml                 # Frame/widget XML definitions (optional)
└── README.md             # (back-ported addons) documents every change made
```

Notable root-level paths:

| Path | Purpose |
|------|---------|
| `.github/workflows/release-addon.yml` | Only CI workflow — tag-triggered addon release |
| `.github/copilot-instructions.md` | Copilot conventions: Lua patterns, back-porting guide, API shim table |
| `.github/instructions/` | Scoped instruction files (Markdown, agent skills) |
| `.github/agents/` | Custom Copilot agents |
| `.github/skills/` | 18 installed Copilot skills |
| `README.md` | Master addon index with version tables |

---

## Tech Stack

| Layer | Detail |
|-------|--------|
| Language | Lua 5.1 (WoW scripting environment) |
| Markup | XML (frame definitions), TOC (addon manifests) |
| Build toolchain | **None** — no compiler, bundler, or package manager |
| Testing | **None** — no test framework; validation is manual in-game |
| Runtime | World of Warcraft 3.3.5a client (interface `30300`) |

---

## Build & Run

There is no build step. To install:

1. Copy the addon folder(s) into `World of Warcraft\Interface\AddOns\`
2. Launch WoW and enable the addon on the character select screen

Suite addons (Bagnon, DBM, Titan Panel, Auctioneer, ElvUI, etc.) require **all** their component folders to be present together.

---

## Testing

No automated tests exist. Validate changes manually in-game on a 3.3.5a server:

1. Copy the modified addon folder into `Interface\AddOns\`
2. `/reload` or restart the client
3. Exercise the affected feature
4. Check the Lua error log: enable `!Swatter` or `/script UIErrorsFrame:Show()`

---

## Key Patterns and Conventions

### TOC manifest format

Every `.toc` must include:

```
## Interface: 30300
## Version: X.Y.Z
## Title: <DisplayName>
```

Back-ported addons list `compat_335.lua` as the **first file entry** so all shims are in place before any addon code runs.

### Back-porting pattern

1. Set `## Interface: 30300` in all `.toc` files
2. Create `compat_335.lua` in the primary addon folder; list it first in the TOC
3. Wrap every shim with `if not X then … end` — never overwrite real server APIs
4. Write `README.md` with: Files Changed table, per-fix sections (root cause / before / after / why), Known Issues section

### Shim guard convention

```lua
if not C_Timer then
  C_Timer = {}
  function C_Timer.After(delay, callback)
    -- implement via OnUpdate driver
  end
end
```

### Texture rules

- **Never use numeric FileDataIDs** in `SetTexture()` — renders as a solid red block on 3.3.5a
- **Never use atlas names** (strings with no `/` or `\`) — also renders red
- Always use explicit string paths: `"Interface\\Minimap\\MiniMap-TrackingBorder"`

### Version management

- `## Version:` in the `.toc` is the **single source of truth** for the release version
- Do **not** bump `## Version:` when making back-port fixes — only bump for an intentional release
- Release tag format: `AddonName-release` (e.g. `HidingBar-release`)

---

## CI/CD

**Release workflow** (`.github/workflows/release-addon.yml`):

- **Trigger:** push a git tag matching `*-release`
- **Reads:** `## Version:` from `<AddonName>/<AddonName>.toc`
- **Packages:** all root folders starting with `<AddonName>` into a zip
- **Publishes:** a GitHub Release with the zip attached

No build or test CI exists — only the release workflow.

---

## Adding a New Back-ported Addon (full registration chain)

1. Copy addon folder(s) into the repo root
2. Set `## Interface: 30300` in **every** `.toc` file in the addon
3. Create `compat_335.lua` in the primary folder; add it as the **first line** of the TOC file list
4. Add guarded shims for every post-3.3.5a API used (see `copilot-instructions.md` API table)
5. Write `<AddonName>/README.md` — Files Changed table + per-fix sections + Known Issues
6. Add an entry to the correct table in root `README.md` with version and description
7. Push tag `<AddonName>-release` to publish the release

---

## Common Pitfalls

- `getmetatable(frame).__index` is a **C function** in 3.3.5a — not a Lua table — method injection at startup silently fails
- `xpcall(f, handler, arg1, ...)` ignores extra args in Lua 5.1 — wrap in a closure: `xpcall(function() f(arg1) end, handler)`
- `COMBAT_LOG_EVENT_UNFILTERED` payload is passed as handler arguments directly — not via `CombatLogGetCurrentEventInfo`
- `RegisterAddonMessagePrefix` does not exist in 3.3.5a — remove the call entirely
- `UNIT_SPELLCAST_SUCCEEDED` signature is `(unit, spellName, rank, target)` — not modern GUIDs
- Do not attach `SetScript("OnClick")` to a `SecureActionButtonTemplate` button — use a separate non-secure button
- `MaskTexture` XML element does not exist — replace with `<Texture hidden="true">`
- `clipChildren="true"` XML attribute is not recognised — remove it and guard in Lua with `if btn.SetClipsChildren then`
