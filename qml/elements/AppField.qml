import QtQuick
import QtQuick.Controls.Basic

TextField {
    id: control
    implicitHeight: 40
    padding: 10
    color: Theme.palette.ink
    placeholderTextColor: Theme.palette.muted
    selectionColor: Theme.palette.accent
    selectedTextColor: Theme.palette.onAccent

    background: Rectangle {
        radius: 8
        color: Theme.palette.surface
        border.color: control.activeFocus ? Theme.palette.accent : Theme.palette.line
    }
}
