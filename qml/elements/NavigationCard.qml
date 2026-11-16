import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

AbstractButton {
    id: control

    required property string description

    implicitHeight: Math.max(144, contentItem.implicitHeight + topPadding + bottomPadding)
    padding: 20
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus
    Accessible.description: description

    background: AppCard {
        color: control.hovered || control.down ? Theme.palette.background : Theme.palette.surface
        border.color: control.activeFocus || control.hovered ? Theme.palette.accent : Theme.palette.line
    }

    contentItem: ColumnLayout {
        spacing: 8

        AppText {
            Layout.fillWidth: true
            text: control.text
            font.pixelSize: 18
            font.weight: Font.DemiBold
        }

        AppText {
            Layout.fillWidth: true
            text: control.description
            visible: text.length > 0
            color: Theme.palette.muted
        }

        Item { Layout.fillHeight: true }
    }

    HoverHandler { cursorShape: Qt.PointingHandCursor }
}
