pragma Singleton
import QtQuick
import "ThemeLogic.js" as Logic

QtObject {
    id: root
    property var styles: []
    property var active: ({})
    readonly property var palette: active.colors || ({})
    readonly property string activeStyle: active.id || ""

    function select(id) { Logic.select(root, DesktopStorage, id) }

    Component.onCompleted: Logic.initialize(root, DesktopStorage, ThemeFiles)
}
