import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

ScrollView {
    id: root
    signal openPage(string page)
    clip: true
    contentWidth: availableWidth

    ColumnLayout {
        width: root.availableWidth
        spacing: 16

        SectionHeading {
            Layout.fillWidth: true
            Layout.margins: 24
            Layout.bottomMargin: 0
            title: "Главная"
        }

        GridLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 24
            Layout.rightMargin: 24
            columns: width >= 760 ? 3 : width >= 500 ? 2 : 1
            rowSpacing: 16
            columnSpacing: 16
            uniformCellWidths: true
            uniformCellHeights: true

            NavigationCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                text: "Настройки"
                description: "Выбрать стиль оформления и посмотреть палитры."
                onClicked: root.openPage("settings")
            }
            NavigationCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                text: "Плагины"
                description: "Посмотреть установленные расширения и управлять ими."
                onClicked: root.openPage("plugins")
            }
            NavigationCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                text: "Профиль"
                description: "Посмотреть имя, роль и адрес подключённого сервера."
                onClicked: root.openPage("profile")
            }
        }

        AppText {
            Layout.leftMargin: 24
            Layout.topMargin: 8
            visible: Plugins.enabledItems.length > 0
            text: "ПЛАГИНЫ"
            font.weight: Font.DemiBold
        }

        GridLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 24
            Layout.rightMargin: 24
            Layout.bottomMargin: 24
            visible: Plugins.enabledItems.length > 0
            columns: width >= 760 ? 3 : width >= 500 ? 2 : 1
            rowSpacing: 16
            columnSpacing: 16
            uniformCellWidths: true
            uniformCellHeights: true

            Repeater {
                model: Plugins.enabledItems
                NavigationCard {
                    required property var modelData
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    text: modelData.name
                    description: modelData.summary
                    onClicked: root.openPage("plugin:" + modelData.id)
                }
            }
        }
    }
}
