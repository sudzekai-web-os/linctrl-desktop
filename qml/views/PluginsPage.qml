import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

ScrollView {
    id: root
    clip: true
    contentWidth: availableWidth

    ColumnLayout {
        width: root.availableWidth
        spacing: 16

        RowLayout {
            Layout.fillWidth: true
            Layout.margins: 24
            Layout.bottomMargin: 0
            SectionHeading {
                Layout.fillWidth: true
                title: "Плагины"
            }
            DefaultButton {
                text: "Обновить список"
                onClicked: Plugins.refresh()
            }
        }

        AppField {
            Layout.fillWidth: true
            Layout.leftMargin: 24
            Layout.rightMargin: 24
            readOnly: true
            selectByMouse: true
            text: Plugins.directory
        }

        AppText {
            Layout.fillWidth: true
            Layout.leftMargin: 24
            Layout.rightMargin: 24
            visible: text.length > 0
            text: Plugins.error
            color: Theme.palette.accent
        }

        AppText {
            Layout.leftMargin: 24
            visible: Plugins.items.length === 0
            text: "Поместите папку .linctrl в каталог плагинов."
            color: Theme.palette.muted
        }

        Repeater {
            model: Plugins.items

            AppCard {
                required property var modelData
                Layout.fillWidth: true
                Layout.leftMargin: 24
                Layout.rightMargin: 24
                implicitHeight: row.implicitHeight + 32

                RowLayout {
                    id: row
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 16

                    ColumnLayout {
                        Layout.fillWidth: true
                        AppText {
                            Layout.fillWidth: true
                            text: modelData.name
                            font.weight: Font.DemiBold
                        }
                        AppText {
                            Layout.fillWidth: true
                            visible: text.length > 0
                            text: modelData.summary
                            color: Theme.palette.muted
                        }
                    }

                    DefaultButton {
                        text: modelData.enabled ? "Выключить" : "Включить"
                        onClicked: Plugins.setEnabled(modelData.id, !modelData.enabled)
                    }
                }
            }
        }

        Item { implicitHeight: 8 }
    }
}
