# Advanced Trade Skill Window

An improved window for your tradeskills, back-ported to WoW 3.3.5a from the original v0.7.8.

## Files Changed

| File | Change type |
|---|---|
| `AdvancedTradeSkillWindow.toc` | Modified — interface version set to `30300` |
| `atsw.xml` | Modified — replaced `ChatFrameEditBox` with `ChatFrame1EditBox` |
| `atsw.lua` | Modified — replaced `ChatFrameEditBox` with `ChatFrame1EditBox` |

## Fixes

### `ChatFrameEditBox` is nil (`atsw.xml` and `atsw.lua`)

**Root cause:** `ChatFrameEditBox` does not exist as a global in the WoW 3.3.5a client. The correct global for the default chat frame's edit box in this client is `ChatFrame1EditBox`.

**Affected locations:**

`atsw.xml` — `ATSWTradeSkillLinkButton:OnClick` (the link button in the trade skill frame):

```lua
-- Before
if (not ChatEdit_InsertLink(link)) then
    ChatFrameEditBox:Show()
    ChatEdit_InsertLink(link)
end

-- After
if (not ChatEdit_InsertLink(link)) then
    ChatFrame1EditBox:Show()
    ChatEdit_InsertLink(link)
end
```

`atsw.lua` — skill listing row click handler, shift-click to insert reagent links:

```lua
-- Before
if(arg1=="LeftButton" and (ChatFrameEditBox:IsVisible() or WIM_EditBoxInFocus~=nil)) then

-- After
if(arg1=="LeftButton" and (ChatFrame1EditBox:IsVisible() or WIM_EditBoxInFocus~=nil)) then
```

`atsw.lua` — `ATSW_AddTradeSkillReagentLinksToChatFrame`, reads the active channel before sending chat messages:

```lua
-- Before
channel = ChatFrameEditBox:GetAttribute("chatType")
if channel=="WHISPER" then
    chatnumber = ChatFrameEditBox:GetAttribute("tellTarget")
elseif channel=="CHANNEL" then
    chatnumber = ChatFrameEditBox:GetAttribute("channelTarget")
end

-- After
channel = ChatFrame1EditBox:GetAttribute("chatType")
if channel=="WHISPER" then
    chatnumber = ChatFrame1EditBox:GetAttribute("tellTarget")
elseif channel=="CHANNEL" then
    chatnumber = ChatFrame1EditBox:GetAttribute("channelTarget")
end
```

## Bugs

To report bugs specific to the WotLK 3.3.5a version, please open an issue in this repository: <https://github.com/locus313/WoW-3.3.5a-Addons/issues>
