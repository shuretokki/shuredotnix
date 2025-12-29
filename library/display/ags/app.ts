import { App } from "astal/gtk3"
import Bar from "./widget/Bar"
import WallpaperPicker from "./widget/WallpaperPicker"
import style from "./style.scss"

App.start({
    instanceName: "ags",
    css: style,
    requestHandler(request: string, res: (response: any) => void) {
        res("ok")
    },
    main() {
        App.get_monitors().map(Bar)
        App.get_monitors().map(WallpaperPicker)
    },
})
