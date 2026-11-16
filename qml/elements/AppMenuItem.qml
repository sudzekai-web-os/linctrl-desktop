import QtQuick
import QtQuick.Controls.Basic

MenuItem {
    id: control

    property bool selected: false

    implicitHeight: 36
    horizontalPadding: 12
    hoverEnabled: true

    contentItem: AppText {
        text: control.text
        wrapMode: Text.NoWrap
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
        color: !control.enabled ? Theme.palette.muted
            : control.selected ? Theme.palette.accent : Theme.palette.ink
    }

    background: Rectangle {
        radius: 6
        color: control.highlighted || control.hovered || control.down
            ? Theme.palette.background
            : control.selected ? Qt.tint(Theme.palette.surface, Qt.alpha(Theme.palette.accent, 0.10))
            : "transparent"
    }
}
