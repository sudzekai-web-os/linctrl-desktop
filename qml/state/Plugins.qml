pragma Singleton
import QtQuick
import "PluginLogic.js" as Logic

QtObject {
    id: root
    property var items: []
    readonly property var enabledItems: items.filter(plugin => plugin.enabled)
    readonly property string directory: PluginFiles.directory
    readonly property string appDataDirectory: PluginFiles.appDataDirectory
    property string error: ""

    signal changed()

    function refresh() { Logic.refresh(root, PluginFiles, DesktopStorage) }
    function setEnabled(id, enabled) { return Logic.setEnabled(root, PluginFiles, DesktopStorage, id, enabled) }
    function entry(id) {
        if (!Logic.enabled(root, id))
            return ""
        const result = PluginFiles.load(id)
        if (result.error)
            root.error = result.error
        return result.entry || ""
    }
    function readText(id, path) { return Logic.enabled(root, id) ? PluginFiles.readText(id, path) : "" }
    function writeText(id, path, text) { return Logic.enabled(root, id) && PluginFiles.writeText(id, path, text) }

    Component.onCompleted: refresh()
}
