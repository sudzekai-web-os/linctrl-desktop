import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: root

    property string title: ""
    property string description: ""

    spacing: 4

    AppText {
        Layout.fillWidth: true
        text: root.title
        font.pixelSize: 24
        font.weight: Font.DemiBold
    }

    AppText {
        Layout.fillWidth: true
        visible: root.description.length > 0
        text: root.description
        color: Theme.palette.muted
    }
}
