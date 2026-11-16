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

        SectionHeading {
            Layout.fillWidth: true
            Layout.margins: 24
            Layout.bottomMargin: 0
            title: "Настройки"
            description: "Оформление"
        }

        GridLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 24
            Layout.rightMargin: 24
            columns: width >= 560 ? 2 : 1
            rowSpacing: 16
            columnSpacing: 16

            Repeater {
                model: Theme.styles

                ThemeOption {
                    required property var modelData
                    Layout.fillWidth: true
                    styleId: modelData.id
                    label: modelData.name
                    summary: modelData.summary
                    previewBackground: modelData.colors.background
                    previewInk: modelData.colors.ink
                    previewAccent: modelData.colors.accent
                }
            }
        }

        Item { implicitHeight: 8 }
    }
}
