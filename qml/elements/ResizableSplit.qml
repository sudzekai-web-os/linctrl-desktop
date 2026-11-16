import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Window

SplitView {
    id: root

    readonly property int maximumPanelWidth: Math.floor(Math.min(width, Screen.width) / 2)
    readonly property int minimumPanelWidth: Math.min(240, maximumPanelWidth)

    handle: Item {
        implicitWidth: 10

        Rectangle {
            anchors.centerIn: parent
            width: parent.SplitHandle.hovered || parent.SplitHandle.pressed ? 2 : 1
            height: parent.height
            color: Theme.palette.muted
            opacity: parent.SplitHandle.hovered || parent.SplitHandle.pressed ? 0.8 : 0.3
        }

        HoverHandler { cursorShape: Qt.SplitHCursor }
    }
}
