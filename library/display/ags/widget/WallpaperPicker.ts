import { Astal, Gtk, Gdk, App } from "astal/gtk3"
import { exec, execAsync } from "astal"
import { Variable } from "astal"

const WP_DIR = exec("bash -c 'echo $HOME/shure-wp'")

export default function WallpaperPicker(monitor: number) {
    const transition = Variable("fade")
    const selectedMonitor = Variable("all")

    const transitions = [
        "none", "fade", "left", "right", "top", "bottom", "wipe", "wave", "grow", "center", "any", "outer", "random"
    ]

    const getWallpapers = () => {
        try {
            return exec(`ls ${WP_DIR}`).split("\n").filter(f => f.match(/\.(jpg|jpeg|png|webp|gif)$/i))
        } catch (e) {
            return []
        }
    }

    const wallpapers = getWallpapers()

    return new Gtk.Window({
        name: `wallpaper-picker-${monitor}`,
        className: "WallpaperPicker",
        monitor: monitor,
        visible: false,
        keymode: Astal.Keymode.EXCLUSIVE,
        onKeyPressEvent: (self, event: Gdk.Event) => {
            if (event.get_keyval()[1] === Gdk.KEY_Escape) {
                self.hide()
            }
        },
        child: new Gtk.Box({
            vertical: true,
            spacing: 20,
            children: [
                new Gtk.Label({
                    className: "picker-title",
                    label: "Wallpaper Picker",
                }),
                new Gtk.Box({
                    className: "picker-controls",
                    spacing: 10,
                    children: [
                        new Gtk.Label({ label: "Transition:" }),
                        new Gtk.ComboBoxText({
                            active: 1,
                            onChanged: (self: Gtk.ComboBoxText) => transition.set(self.get_active_text() || "fade"),
                            setup: (self: Gtk.ComboBoxText) => transitions.forEach(t => self.append_text(t)),
                        }),
                        new Gtk.Label({ label: "Monitor:" }),
                        new Gtk.ComboBoxText({
                            active: 0,
                            onChanged: (self: Gtk.ComboBoxText) => selectedMonitor.set(self.get_active_text() || "all"),
                            setup: (self: Gtk.ComboBoxText) => {
                                self.append_text("all")
                                try {
                                    const monitors = JSON.parse(exec("hyprctl monitors -j"))
                                    monitors.forEach((m: any) => self.append_text(m.name))
                                } catch (e) {}
                            },
                        }),
                    ]
                }),
                new Gtk.ScrolledWindow({
                    className: "picker-scroll",
                    minContentHeight: 400,
                    minContentWidth: 600,
                    child: new Gtk.FlowBox({
                        className: "picker-grid",
                        minChildrenPerLine: 3,
                        maxChildrenPerLine: 6,
                        setup: (self: Gtk.FlowBox) => {
                            wallpapers.forEach((wp: string) => {
                                const path = `${WP_DIR}/${wp}`
                                const btn = new Gtk.Button({
                                    className: "wp-button",
                                    onClicked: () => {
                                        const m = selectedMonitor.get()
                                        const t = transition.get()
                                        const cmd = m === "all" 
                                            ? `swww img "${path}" --transition-type ${t}`
                                            : `swww img -o ${m} "${path}" --transition-type ${t}`
                                        execAsync(cmd)
                                    },
                                    child: new Gtk.Box({
                                        vertical: true,
                                        children: [
                                            new Gtk.Image({
                                                file: path,
                                                pixelSize: 150,
                                            }),
                                            new Gtk.Label({
                                                label: wp,
                                                maxWidthChars: 15,
                                                ellipsize: 3,
                                            })
                                        ]
                                    })
                                })
                                self.add(btn)
                            })
                        }
                    })
                }),
                new Gtk.Button({
                    className: "picker-close",
                    label: "Close",
                    onClicked: () => exec(`ags -t wallpaper-picker-${monitor}`),
                })
            ]
        })
    })
}
