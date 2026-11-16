import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

AbstractButton {
    id: control
    required property string styleId
    required property string summary
    required property string label
    required property color previewBackground
    required property color previewInk
    required property color previewAccent
    property bool selected: Theme.activeStyle === styleId
    implicitHeight: Math.max(196, contentItem.implicitHeight + 2 * padding)
    padding: 16
    onClicked: Theme.select(styleId)
    Accessible.name: label
    Accessible.description: summary
    Accessible.role: Accessible.RadioButton
    Accessible.checkable: true
    Accessible.checked: selected
    background: Rectangle {
        radius: 12
        color: Theme.palette.surface
        border.width: control.selected || control.activeFocus ? 2 : 1
        border.color: control.selected || control.activeFocus ? Theme.palette.accent : Theme.palette.line
    }
    contentItem: ColumnLayout {
        spacing: 12
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 108
            color: control.previewBackground
            radius: 6
            Column {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 8
                Rectangle {
                    width: 34
                    height: 4
                    color: control.previewAccent
                }
                Text {
                    text: "LINCTRL"
                    color: control.previewInk
                    font.pixelSize: 26
                    font.bold: true
                }
                Rectangle {
                    width: parent.width * 0.75
                    height: 1
                    color: control.previewInk
                    opacity: 0.3
                }
                Row {
                    spacing: 5
                    Repeater {
                        model: 3
                        Rectangle {
                            width: 28
                            height: 16
                            radius: 8
                            color: control.previewInk
                            opacity: 0.15
                        }
                    }
                }
            }
        }
        RowLayout {
            AppText {
                text: control.label
                Layout.fillWidth: true
                font.weight: Font.DemiBold
            }
            AppText {
                text: control.selected ? "●" : "○"
                color: Theme.palette.accent
                font.pixelSize: 20
            }
        }
        AppText {
            Layout.fillWidth: true
            visible: control.summary.length > 0
            text: control.summary
            color: Theme.palette.muted
        }
    }
    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }
}
