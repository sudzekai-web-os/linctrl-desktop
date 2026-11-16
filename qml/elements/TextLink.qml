import QtQuick
import QtQuick.Controls.Basic

AbstractButton {
    id: control

    implicitHeight: 28
    leftPadding: 0
    rightPadding: 0
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus
    Accessible.role: Accessible.Link

    contentItem: AppText {
        text: control.text
        color: control.hovered || control.activeFocus ? Theme.palette.accent : Theme.palette.ink
        font.underline: control.hovered || control.activeFocus
        wrapMode: Text.NoWrap
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
    }

    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }
}
