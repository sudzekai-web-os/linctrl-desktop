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
            title: "Профиль"
        }

        AppCard {
            Layout.fillWidth: true
            Layout.leftMargin: 24
            Layout.rightMargin: 24
            implicitHeight: fields.implicitHeight + 32

            ColumnLayout {
                id: fields
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12

                AppText {
                    text: AccountSession.name
                    font.pixelSize: 18
                    font.weight: Font.DemiBold
                }
                AppText {
                    text: AccountSession.role
                    color: Theme.palette.muted
                }
                AppText { text: "Сервер" }
                AppText {
                    Layout.fillWidth: true
                    text: StartupFlow.endpoint || "Без сервера"
                    color: Theme.palette.muted
                }
                RowLayout {
                    DefaultButton {
                        text: "Изменить пароль"
                        onClicked: passwordDialog.open()
                    }
                }
            }
        }
    }

    AppDialog {
        id: passwordDialog
        title: "Изменить пароль"
        acceptText: "ОК"
        description: "Смена пароля пока недоступна."
    }
}
