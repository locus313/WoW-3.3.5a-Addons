## Description

<!-- What does this PR change and why? -->

## Addon(s) affected

<!-- e.g. HidingBar, SpellActivationOverlay, or "root config" -->

## Type of change

- [ ] Back-port (porting an addon from a newer WoW client)
- [ ] Bug fix in an existing back-ported addon
- [ ] New vanilla 3.3.5a addon added
- [ ] Release (version bump + tag)
- [ ] Repo/config change

## Checklist

### For all changes

- [ ] `.toc` files declare `## Interface: 30300`
- [ ] `## Version:` in `.toc` matches the version listed in root `README.md`
- [ ] No numeric FileDataIDs used in `SetTexture()` calls (use string paths)

### For back-ports and bug fixes

- [ ] `compat_335.lua` is listed **first** in the `.toc` file list
- [ ] Every shim in `compat_335.lua` is wrapped with `if not X then … end`
- [ ] `README.md` in the addon folder is updated (Files Changed table + per-fix sections)
- [ ] Tested in-game on a 3.3.5a server — no Lua errors

### For new addons

- [ ] Entry added to the correct table in root `README.md`
- [ ] Suite companion folders (e.g. `AddonName_Options`) also have `## Interface: 30300`

### For releases

- [ ] `## Version:` bumped in `<AddonName>/<AddonName>.toc` before the tag was pushed
- [ ] Tag format matches `AddonName-release`
