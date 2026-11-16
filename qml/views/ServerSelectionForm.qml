import QtQuick
import QtQuick.Layouts

ColumnLayout {
    spacing: 12

    AppComboBox {
        id: server
        Layout.fillWidth: true
        model: ServerCatalog.items
        textRole: "endpoint"
        displayText: count ? currentText : "Серверы не добавлены"
        enabled: count > 0
    }

    DefaultButton {
        Layout.fillWidth: true
        primary: true
        enabled: server.currentIndex >= 0
        text: "Подключиться"
        onClicked: StartupFlow.chooseServer(ServerCatalog.items[server.currentIndex])
    }

    DefaultButton {
        Layout.fillWidth: true
        text: "Добавить сервер"
        onClicked: addServerDialog.open()
    }

    AddServerDialog {
        id: addServerDialog
        onServerAdded: server.currentIndex = server.count - 1
    }

    DefaultButton {
        Layout.fillWidth: true
        Layout.topMargin: 8
        text: "Продолжить без сервера"
        onClicked: StartupFlow.enterWorkspace()
    }
}
