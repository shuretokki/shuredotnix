import { Astal, Gtk, Gdk } from "ags/gtk3"
import app from "ags/gtk3/app"
import Hyprland from "gi://AstalHyprland"
import Mpris from "gi://AstalMpris"
import Network from "gi://AstalNetwork"
import Wp from "gi://AstalWp"
import Battery from "gi://AstalBattery"
import { createBinding, onCleanup } from "ags"
import { createPoll } from "ags/time"
import GLib from "gi://GLib"

function Workspaces() {
    const hypr = Hyprland.get_default()

    return <box class="Workspaces">
        {Array.from({ length: 5 }, (_, i) => i + 1).map(id => (
            <button
                class="workspace-button"
                onClicked={() => hypr.dispatch("workspace", `${id}`)}
                $={(self) => {
                    const update = () => {
                        self.toggleClassName("active", hypr.focusedWorkspace.id === id)
                        self.toggleClassName("occupied", (hypr.get_workspace(id)?.get_clients().length || 0) > 0)
                    }
                    const id1 = hypr.connect("notify::focused-workspace", update)
                    const id2 = hypr.connect("client-added", update)
                    const id3 = hypr.connect("client-removed", update)
                    onCleanup(() => {
                        hypr.disconnect(id1)
                        hypr.disconnect(id2)
                        hypr.disconnect(id3)
                    })
                    update()
                }}>
                <label label={`${id}`} />
            </button>
        ))}
    </box>
}

function Media() {
    const mpris = Mpris.get_default()

    return <box class="Media"
        $={(self) => {
            const update = () => {
                const player = mpris.get_players()[0]
                if (player) {
                    self.visible = true
                    self.children = [
                        <label
                            label={createBinding(player, "title")((t) => `${t} - ${player.artist}`)}
                            maxWidthChars={30}
                            ellipsize={3}
                        />
                    ]
                } else {
                    self.visible = false
                }
            }
            const id1 = mpris.connect("player-added", update)
            const id2 = mpris.connect("player-removed", update)
            onCleanup(() => {
                mpris.disconnect(id1)
                mpris.disconnect(id2)
            })
            update()
        }}
    />
}

function SysTray() {
    const network = Network.get_default()
    const audio = Wp.get_default()?.audio
    const battery = Battery.get_default()
    const time = createPoll("", 1000, () => GLib.DateTime.new_now_local().format("%H:%M")!)

    return <box class="SysTray" spacing={10}>
        <label
            $={(self) => {
                const update = () => {
                    if (network.wifi) {
                        self.label = network.wifi.ssid ? "" : "󰖪"
                    } else {
                        self.label = "󰈀"
                    }
                }
                const id = network.connect("notify::wifi", update)
                onCleanup(() => network.disconnect(id))
                update()
            }}
        />
        <label
            $={(self) => {
                const update = () => {
                    if (audio?.defaultSpeaker) {
                        const vol = Math.round(audio.defaultSpeaker.volume * 100)
                        self.label = audio.defaultSpeaker.mute ? "󰝟" : `󰕾 ${vol}%`
                    }
                }
                if (audio) {
                    const id = audio.connect("notify::default-speaker", update)
                    onCleanup(() => audio.disconnect(id))
                }
                update()
            }}
        />
        <label
            $={(self) => {
                const update = () => {
                    self.label = battery.charging ? "󰂄" : "󰁹"
                    self.tooltipText = `${Math.round(battery.percentage * 100)}%`
                }
                const id1 = battery.connect("notify::percentage", update)
                const id2 = battery.connect("notify::charging", update)
                onCleanup(() => {
                    battery.disconnect(id1)
                    battery.disconnect(id2)
                })
                update()
            }}
        />
        <label class="Clock" label={time} />
    </box>
}

export default function Bar(monitor: number) {
    return <window
        name={`bar-${monitor}`}
        class="Bar"
        monitor={monitor}
        application={app}
        anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.LEFT | Astal.WindowAnchor.RIGHT}
        exclusivity={Astal.Exclusivity.EXCLUSIVE}>
        <centerbox
            startWidget={Workspaces()}
            centerWidget={Media()}
            endWidget={SysTray()}
        />
    </window>
}
