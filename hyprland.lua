-- Port dari hyprland.conf lama (HyDE) ke Lua untuk Hyprland 0.57+.
-- File .conf lama masih ada sebagai referensi, tapi sudah TIDAK dibaca Hyprland.

local home    = os.getenv("HOME")
local scrPath = home .. "/.local/share/bin"

local mainMod = "SUPER"
local term    = "kitty"
local editor  = "code"
local file    = "thunar"
local browser = "brave-origin"

-------------------
---- MONITORS ----
-------------------

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd(scrPath .. "/resetxdgportal.sh")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd(scrPath .. "/polkitkdeauth.sh")
    hl.exec_cmd("waybar")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("udiskie --no-automount --smart-tray")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("dunst")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd('sleep 2 && awww img "' .. home .. '/.config/hyde/themes/Frosted Glass/wallpapers/pantai.jpg"')
    hl.exec_cmd(scrPath .. "/batterynotify.sh")

    -- tema (dulu themes/common.conf + theme.conf + colors.conf)
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 20")
    local gs = "gsettings set org.gnome.desktop.interface "
    hl.exec_cmd(gs .. "cursor-theme 'Bibata-Modern-Ice'")
    hl.exec_cmd(gs .. "cursor-size 20")
    hl.exec_cmd(gs .. "font-name 'SF Pro Display 10'")
    hl.exec_cmd(gs .. "document-font-name 'SF Pro Text 10'")
    hl.exec_cmd(gs .. "monospace-font-name 'CaskaydiaCove Nerd Font Mono 9'")
    hl.exec_cmd(gs .. "font-antialiasing 'rgba'")
    hl.exec_cmd(gs .. "font-hinting 'full'")
    hl.exec_cmd(gs .. "icon-theme 'Tela-circle-blue'")
    hl.exec_cmd(gs .. "gtk-theme 'Wallbash-Gtk'")
    hl.exec_cmd(gs .. "color-scheme 'prefer-dark'")
end)

-------------
---- ENV ----
-------------

hl.env("PATH", os.getenv("PATH") .. ":" .. scrPath)
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("GDK_SCALE", "1")
-- env NVIDIA (nvidia.conf) sengaja tidak dibawa: driver nvidia diblacklist, render pakai Intel.

------------------------
---- LOOK AND FEEL ----
------------------------

local activeBorder   = { colors = { "rgba(D9D1BAff)", "rgba(524729ff)" }, angle = 45 }
local inactiveBorder = { colors = { "rgba(1C1D16ff)", "rgba(6F5B2Eff)" }, angle = 45 }

hl.config({
    general = {
        gaps_in = 4,
        gaps_out = 10,
        border_size = 0,
        col = { active_border = activeBorder, inactive_border = inactiveBorder },
        layout = "dwindle",
        resize_on_border = true,
    },

    group = {
        col = {
            border_active          = activeBorder,
            border_inactive        = { colors = { "rgba(1C1D16cc)", "rgba(6F5B2Ecc)" }, angle = 45 },
            border_locked_active   = { colors = { "rgba(0E0E0Dff)", "rgba(080809ff)" }, angle = 45 },
            border_locked_inactive = { colors = { "rgba(FFFFFFcc)", "rgba(FFFFFFcc)" }, angle = 45 },
        },
    },

    decoration = {
        rounding = 11,
        active_opacity = 0.8,
        inactive_opacity = 0.8,
        blur = {
            enabled = true,
            size = 5,
            passes = 3,
            new_optimizations = true,
            ignore_opacity = true,
            xray = false,
            noise = 0.02,
            contrast = 0.95,
            brightness = 0.85,
            vibrancy = 0.3,
            vibrancy_darkness = 0.1,
            special = false,
            popups = false,
            input_methods = false,
        },
    },

    animations = { enabled = true },

    input = {
        kb_layout = "us",
        follow_mouse = 1,
        touchpad = { natural_scroll = true },
        sensitivity = 0,
        force_no_accel = false,
    },

    gestures = { workspace_swipe_invert = true },

    dwindle = { preserve_split = true, smart_split = true },
    master = { new_status = "master" },

    misc = {
        vrr = 0,
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        force_default_wallpaper = 0,
    },

    xwayland = { force_zero_scaling = true },
})

hl.device({ name = "epic-mouse-v1", sensitivity = -0.8 })

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "vertical", action = "workspace" })

--------------------
---- ANIMATIONS ----
--------------------

hl.curve("wind",   { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })
hl.curve("winIn",  { type = "bezier", points = { {0.1, 1.1},  {0.1, 1.1}  } })
hl.curve("winOut", { type = "bezier", points = { {0.3, -0.3}, {0, 1}      } })
hl.curve("liner",  { type = "bezier", points = { {1, 1},      {1, 1}      } })

hl.animation({ leaf = "windows",     enabled = true, speed = 6,  bezier = "wind",   style = "slide" })
hl.animation({ leaf = "windowsIn",   enabled = true, speed = 6,  bezier = "winIn",  style = "slide" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 5,  bezier = "winOut", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 5,  bezier = "wind",   style = "slide" })
hl.animation({ leaf = "border",      enabled = true, speed = 1,  bezier = "liner" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 30, bezier = "liner",  style = "loop" })
hl.animation({ leaf = "fade",        enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 5,  bezier = "wind" })

---------------------
---- KEYBINDINGS ----
---------------------

local bind = hl.bind
local function sh(cmd) return hl.dsp.exec_cmd(cmd) end
local function scr(cmd) return sh(scrPath .. "/" .. cmd) end
local function rofi(cmd) return sh("pkill -x rofi || " .. scrPath .. "/" .. cmd) end

-- Tutup window; Steam cuma disembunyikan (pengganti dontkillsteam.sh, sintaks hyprctl lama sudah mati)
local function closeWindow()
    local w = hl.get_active_window()
    if not w then return end
    if w.class == "Steam" then
        hl.exec_cmd("xdotool windowunmap $(xdotool getactivewindow)")
    else
        hl.dispatch(hl.dsp.window.close())
    end
end

-- Pin window, float dulu kalau masih tiled (pengganti windowpin.sh)
local function togglePin()
    local w = hl.get_active_window()
    if not w then return end
    if w.pinned then
        hl.dispatch(hl.dsp.window.pin({ action = "disable" }))
        hl.dispatch(hl.dsp.window.float({ action = "disable" }))
    else
        hl.dispatch(hl.dsp.window.float({ action = "enable" }))
        hl.dispatch(hl.dsp.window.pin({ action = "enable" }))
    end
end

local floatCenter = { float = true, center = true, size = "monitor_w*0.65 monitor_h*0.61" }

-- Window/Session
bind(mainMod .. " + Q", closeWindow)
bind("ALT + F4", closeWindow)
bind(mainMod .. " + Delete", hl.dsp.exit())
bind(mainMod .. " + W", hl.dsp.window.float({ action = "toggle" }))
bind(mainMod .. " + G", hl.dsp.group.toggle())
bind("ALT + Return", hl.dsp.window.fullscreen())
bind(mainMod .. " + L", sh("swaylock"))
bind(mainMod .. " + SHIFT + F", togglePin)
bind(mainMod .. " + BackSpace", scr("logoutlaunch.sh"))
bind("CTRL + ALT + W", sh("killall waybar || waybar"))

-- Aplikasi
bind(mainMod .. " + T", hl.dsp.exec_cmd(term, floatCenter))
bind(mainMod .. " + E", hl.dsp.exec_cmd(file, floatCenter))
bind(mainMod .. " + C", sh(editor))
bind(mainMod .. " + F", sh(browser))
bind("CTRL + SHIFT + Escape", scr("sysmonlaunch.sh"))

-- Rofi
bind(mainMod .. " + A", rofi("rofilaunch.sh d"))
bind(mainMod .. " + Tab", rofi("rofilaunch.sh w"))
bind(mainMod .. " + SHIFT + E", rofi("rofilaunch.sh f"))

-- Audio
bind("F10", scr("volumecontrol.sh -o m"), { locked = true })
bind("F11", scr("volumecontrol.sh -o d"), { locked = true, repeating = true })
bind("F12", scr("volumecontrol.sh -o i"), { locked = true, repeating = true })
bind("XF86AudioMute", scr("volumecontrol.sh -o m"), { locked = true })
bind("XF86AudioMicMute", scr("volumecontrol.sh -i m"), { locked = true })
bind("XF86AudioLowerVolume", scr("volumecontrol.sh -o d"), { locked = true, repeating = true })
bind("XF86AudioRaiseVolume", scr("volumecontrol.sh -o i"), { locked = true, repeating = true })

-- Media
bind("XF86AudioPlay", sh("playerctl play-pause"), { locked = true })
bind("XF86AudioPause", sh("playerctl play-pause"), { locked = true })
bind("XF86AudioNext", sh("playerctl next"), { locked = true })
bind("XF86AudioPrev", sh("playerctl previous"), { locked = true })

-- Brightness
bind("XF86MonBrightnessUp", scr("brightnesscontrol.sh i"), { locked = true, repeating = true })
bind("XF86MonBrightnessDown", scr("brightnesscontrol.sh d"), { locked = true, repeating = true })

-- Group
bind(mainMod .. " + CTRL + H", hl.dsp.group.prev())
bind(mainMod .. " + CTRL + L", hl.dsp.group.next())

-- Screenshot
bind(mainMod .. " + P", scr("screenshot.sh s"))
bind(mainMod .. " + CTRL + P", scr("screenshot.sh sf"))
bind(mainMod .. " + ALT + P", scr("screenshot.sh m"))
bind("Print", scr("screenshot.sh p"))

-- Custom scripts
bind(mainMod .. " + ALT + G", scr("gamemode.sh"))
bind(mainMod .. " + ALT + Right", scr("swwwallpaper.sh -n"))
bind(mainMod .. " + ALT + Left", scr("swwwallpaper.sh -p"))
bind(mainMod .. " + ALT + Up", scr("wbarconfgen.sh n"))
bind(mainMod .. " + ALT + Down", scr("wbarconfgen.sh p"))
bind(mainMod .. " + SHIFT + R", rofi("wallbashtoggle.sh -m"))
bind(mainMod .. " + SHIFT + T", rofi("themeselect.sh"))
bind(mainMod .. " + SHIFT + A", rofi("rofiselect.sh"))
bind(mainMod .. " + SHIFT + W", rofi("swwwallselect.sh"))
bind(mainMod .. " + V", rofi("cliphist.sh c"))
bind(mainMod .. " + K", scr("keyboardswitch.sh"))

-- Fokus & pindah window
local dirs = { Left = "left", Right = "right", Up = "up", Down = "down" }
for key, dir in pairs(dirs) do
    bind(mainMod .. " + " .. key, hl.dsp.focus({ direction = dir }))
    bind(mainMod .. " + SHIFT + CTRL + " .. key, hl.dsp.window.move({ direction = dir }))
end
bind("ALT + Tab", hl.dsp.focus({ direction = "down" }))

-- Resize
bind(mainMod .. " + SHIFT + Right", hl.dsp.window.resize({ x = 30,  y = 0,   relative = true }), { repeating = true })
bind(mainMod .. " + SHIFT + Left",  hl.dsp.window.resize({ x = -30, y = 0,   relative = true }), { repeating = true })
bind(mainMod .. " + SHIFT + Up",    hl.dsp.window.resize({ x = 0,   y = -30, relative = true }), { repeating = true })
bind(mainMod .. " + SHIFT + Down",  hl.dsp.window.resize({ x = 0,   y = 30,  relative = true }), { repeating = true })

-- Workspace 1-10
for i = 1, 10 do
    local key = tostring(i % 10)
    bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
    bind(mainMod .. " + ALT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

bind(mainMod .. " + CTRL + Right", hl.dsp.focus({ workspace = "r+1" }))
bind(mainMod .. " + CTRL + Left", hl.dsp.focus({ workspace = "r-1" }))
bind(mainMod .. " + CTRL + Down", hl.dsp.focus({ workspace = "empty" }))
bind(mainMod .. " + CTRL + ALT + Right", hl.dsp.window.move({ workspace = "r+1" }))
bind(mainMod .. " + CTRL + ALT + Left", hl.dsp.window.move({ workspace = "r-1" }))
bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Drag/resize pakai mouse atau Z/X
bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
bind(mainMod .. " + Z", hl.dsp.window.drag(), { mouse = true })
bind(mainMod .. " + X", hl.dsp.window.resize(), { mouse = true })

-- Scratchpad
bind(mainMod .. " + ALT + S", hl.dsp.window.move({ workspace = "special:special", follow = false }))
bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("special"))

bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

----------------------
---- WINDOW RULES ----
----------------------

local opacity = {
    ["^(firefox)$"] = "0.90 0.90", ["^(Brave-browser)$"] = "0.90 0.90",
    ["^(code-oss)$"] = "0.90 0.90", ["^(Code)$"] = "0.90 0.90",
    ["^(code-url-handler)$"] = "0.80 0.80", ["^(code-insiders-url-handler)$"] = "0.80 0.80",
    ["^(kitty)$"] = "0.85 0.85", ["^(org.kde.dolphin)$"] = "0.80 0.80", ["^(thunar)$"] = "0.80 0.80",
    ["^(org.kde.ark)$"] = "0.80 0.80", ["^(nwg-look)$"] = "0.80 0.80", ["^(qt5ct)$"] = "0.80 0.80",
    ["^(qt6ct)$"] = "0.80 0.80", ["^(kvantummanager)$"] = "0.80 0.80",
    ["^(org.pulseaudio.pavucontrol)$"] = "0.80 0.70", ["^(blueman-manager)$"] = "0.80 0.70",
    ["^(nm-applet)$"] = "0.80 0.70", ["^(nm-connection-editor)$"] = "0.80 0.70",
    ["^(org.kde.polkit-kde-authentication-agent-1)$"] = "0.80 0.70",
    ["^(polkit-gnome-authentication-agent-1)$"] = "0.80 0.70",
    ["^(org.freedesktop.impl.portal.desktop.gtk)$"] = "0.80 0.70",
    ["^(org.freedesktop.impl.portal.desktop.hyprland)$"] = "0.80 0.70",
    ["^([Ss]team)$"] = "0.70 0.70", ["^(steamwebhelper)$"] = "0.70 0.70", ["^(Spotify)$"] = "0.80 0.80",
    ["^(com.github.rafostar.Clapper)$"] = "0.90 0.90", ["^(com.github.tchx84.Flatseal)$"] = "0.80 0.80",
    ["^(hu.kramo.Cartridges)$"] = "0.80 0.80", ["^(com.obsproject.Studio)$"] = "0.80 0.80",
    ["^(gnome-boxes)$"] = "0.80 0.80", ["^(discord)$"] = "0.80 0.80", ["^(WebCord)$"] = "0.80 0.80",
    ["^(ArmCord)$"] = "0.80 0.80", ["^(app.drey.Warp)$"] = "0.80 0.80",
    ["^(net.davidotek.pupgui2)$"] = "0.80 0.80", ["^(yad)$"] = "0.80 0.80", ["^(Signal)$"] = "0.80 0.80",
    ["^(io.github.alainm23.planify)$"] = "0.80 0.80", ["^(io.gitlab.theevilskeleton.Upscaler)$"] = "0.80 0.80",
    ["^(com.github.unrud.VideoDownloader)$"] = "0.80 0.80", ["^(io.gitlab.adhami3310.Impression)$"] = "0.80 0.80",
    ["^(io.missioncenter.MissionCenter)$"] = "0.80 0.80", ["^(io.github.flattool.Warehouse)$"] = "0.80 0.80",
}
for class, value in pairs(opacity) do
    hl.window_rule({ match = { class = class }, opacity = value })
end
hl.window_rule({ match = { initial_title = "^(Spotify Free)$" }, opacity = "0.70 0.70" })

local floatClasses = {
    "vlc", "kvantummanager", "qt5ct", "qt6ct", "nwg-look", "org.kde.ark", "org.pulseaudio.pavucontrol",
    "blueman-manager", "nm-applet", "nm-connection-editor", "org.kde.polkit-kde-authentication-agent-1",
    "Signal", "com.github.rafostar.Clapper", "app.drey.Warp", "net.davidotek.pupgui2", "yad", "eog",
    "io.github.alainm23.planify", "io.gitlab.theevilskeleton.Upscaler", "com.github.unrud.VideoDownloader",
    "io.gitlab.adhami3310.Impression", "io.missioncenter.MissionCenter",
}
for _, class in ipairs(floatClasses) do
    hl.window_rule({ match = { class = "^(" .. class .. ")$" }, float = true })
end

local floatTitles = {
    { "org.kde.dolphin", "Progress Dialog — Dolphin" }, { "thunar", "Progress Dialog — Thunar" },
    { "org.kde.dolphin", "Copying — Dolphin" }, { "thunar", "Copying — Thunar" },
    { "firefox", "Picture-in-Picture" }, { "firefox", "Library" },
    { "kitty", "top" }, { "kitty", "btop" }, { "kitty", "htop" },
}
for _, ct in ipairs(floatTitles) do
    hl.window_rule({ match = { class = "^(" .. ct[1] .. ")$", title = "^(" .. ct[2] .. ")$" }, float = true })
end

hl.window_rule({
    name = "scrcpy",
    match = { class = "^(scrcpy)$" },
    float = true,
    size = "320 725",
    move = "monitor_w-330 36",
    no_anim = true,
    border_size = 0,
})

---------------------
---- LAYER RULES ----
---------------------

hl.layer_rule({ match = { namespace = "^(waybar)$" }, blur = true })
for _, ns in ipairs({ "rofi", "notifications", "swaync-notification-window", "swaync-control-center" }) do
    hl.layer_rule({ match = { namespace = ns }, blur = true, ignore_alpha = 0 })
end
hl.layer_rule({ match = { namespace = "logout_dialog" }, blur = true })
