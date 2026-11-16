import QtQuick
import QtQuick.Controls.Basic

Button {
    id: control

    property bool primary: false
    property bool selected: false
    property bool navigation: false

    implicitHeight: 36
    implicitWidth: implicitContentWidth + 28
    horizontalPadding: 14
    hoverEnabled: true
    font.pixelSize: 13
    font.weight: Font.Medium

    contentItem: Text {
        text: control.text
        font: control.font
        horizontalAlignment: control.navigation ? Text.AlignLeft : Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: control.primary ? Theme.palette.onAccent : control.selected ? Theme.palette.accent : Theme.palette.ink
    }

    background: Rectangle {
        radius: 8
        color: {
            if (control.primary)
                return control.hovered ? Qt.darker(Theme.palette.accent, 1.12) : Theme.palette.accent;
            if (control.selected)
                return Qt.tint(Theme.palette.surface, Qt.alpha(Theme.palette.accent, 0.10));
            if (control.hovered || control.down)
                return Theme.palette.background;
            return control.navigation ? "transparent" : Theme.palette.surface;
        }
        border.width: control.activeFocus ? 2 : control.navigation ? 0 : 1
        border.color: control.activeFocus || control.primary ? Theme.palette.accent : Theme.palette.line
    }

    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }
}
