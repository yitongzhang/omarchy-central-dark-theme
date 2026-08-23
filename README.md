# Central Dark

A neutral-grey Omarchy theme. The greys are pure (dark side of the Central
scale); the accents are the Tokyo Night family. It is one half of a pair —
its counterpart is **[Central Light](https://github.com/yitongzhang/omarchy-central-light-theme)** —
and the two are designed to be swapped at sunrise and sunset by
[omarchy-theme-mode](https://github.com/yitongzhang/omarchy-theme-mode).

![preview](preview.png)

## Install

```bash
omarchy theme install https://github.com/yitongzhang/omarchy-central-dark-theme.git
```

For the pair plus automatic day/night switching and a bar toggle, install
[omarchy-theme-mode](https://github.com/yitongzhang/omarchy-theme-mode) instead —
it pulls both themes in.

## What's in here, and what deliberately isn't

```
colors.toml        the palette, plus mode and the Hyprland border gradients
shell.bar.toml     [bar] section override for the generated shell.toml
shell.menu.toml    [menu] section override — hairline card borders
icons.theme        Yaru-blue-dark (the dark-UI variant — light symbolic glyphs)
partner.theme      central-light — read by omarchy-theme-mode to find the other half
backgrounds/       one wallpaper
preview.png        rendered by ./make-preview.sh from colors.toml
```

There is **no** `alacritty.toml`, `neovim.lua`, `vscode.json`, `btop.theme`,
`hyprland.lua`, `ghostty.conf`, `shell.toml` or friends, and that is the point.

`omarchy-theme-set-templates` renders every one of those from
`$OMARCHY_PATH/default/themed/*.tpl` using this `colors.toml` — but it skips
any file the theme already ships. A checked-in `vscode.json` would therefore
be frozen at whatever Omarchy's template looked like the day it was copied,
and would never pick up a fix or a newly supported app again.

So the rule for this theme is: **express it in `colors.toml` if it can
possibly be expressed there.** Two things that look like they need a static
file but don't:

- **Window borders.** `hyprland_active_border` / `hyprland_inactive_border`
  in `colors.toml` feed both `hyprland.lua.tpl` and the shell's
  popup/menu/notification/lock borders. No `hyprland.lua` needed.
- **Bar and menu chrome.** A `shell.<section>.toml` file patches just that
  section into the generated `shell.toml`; every other key still comes from
  upstream's template.

## Regenerating the preview

```bash
./make-preview.sh . "Central Dark"
```

## License

MIT
