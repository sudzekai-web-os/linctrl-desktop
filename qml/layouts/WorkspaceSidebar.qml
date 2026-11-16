import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

Rectangle {
    id: root
    required property string page
    signal openPage(string page)
    color: Theme.palette.surface

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 4

        ScrollView {
            id: sidebar
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            contentWidth: availableWidth

            ColumnLayout {
                width: sidebar.availableWidth
                spacing: 4

                AppText {
                    Layout.fillWidth: true
                    Layout.margins: 8
                    text: "РАБОЧЕЕ ПРОСТРАНСТВО"
                    font.pixelSize: 11
                    font.weight: Font.DemiBold
                    color: Theme.palette.muted
                }

                Repeater {
                    model: [{ page: "home", label: "Главная" },
                            { page: "settings", label: "Настройки" },
                            { page: "plugins", label: "Плагины" }]
                    DefaultButton {
                        required property var modelData
                        Layout.fillWidth: true
                        navigation: true
                        text: modelData.label
                        selected: root.page === modelData.page
                        onClicked: root.openPage(modelData.page)
                    }
                }

                AppText {
                    Layout.margins: 8
                    text: "ПЛАГИНЫ"
                    font.pixelSize: 11
                    font.weight: Font.DemiBold
                    color: Theme.palette.muted
                }

                Repeater {
                    model: Plugins.enabledItems
                    DefaultButton {
                        required property var modelData
                        readonly property string page: "plugin:" + modelData.id
                        Layout.fillWidth: true
                        navigation: true
                        text: modelData.name
                        selected: root.page === page
                        onClicked: root.openPage(page)
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.topMargin: 8
            implicitHeight: 1
            color: Theme.palette.line
        }

        TextLink {
            id: serverLink
            Layout.fillWidth: true
            Layout.leftMargin: 8
            Layout.rightMargin: 8
            text: StartupFlow.endpoint || "Без сервера"
            Accessible.description: "Адрес сервера и действия подключения"
            onClicked: serverMenu.popup(serverLink, 0, -serverMenu.implicitHeight)

            Menu {
                id: serverMenu
                width: 184
                padding: 4
                background: AppCard { radius: 8 }

                AppMenuItem {
                    text: "Отключиться"
                    enabled: StartupFlow.endpoint.length > 0
                    onTriggered: StartupFlow.disconnectServer()
                }
                AppMenuItem {
                    text: "Сменить сервер"
                    onTriggered: StartupFlow.switchServer()
                }
            }
        }

        TextLink {
            Layout.fillWidth: true
            Layout.leftMargin: 8
            Layout.rightMargin: 8
            text: AccountSession.name
            Accessible.description: "Открыть профиль"
            onClicked: root.openPage("profile")
        }

        AppText {
            Layout.fillWidth: true
            visible: text.length > 0
            text: StartupFlow.message
            color: Theme.palette.accent
        }
    }
}
