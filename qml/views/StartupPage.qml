import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

ScrollView {
    id: root
    clip: true
    contentWidth: availableWidth

    ColumnLayout {
        width: root.availableWidth
        spacing: 0

        AppCard {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 48
            Layout.bottomMargin: 32
            Layout.preferredWidth: Math.min(496, root.availableWidth - 48)
            implicitHeight: form.implicitHeight + 48

            ColumnLayout {
                id: form
                anchors.fill: parent
                anchors.margins: 24
                spacing: 16

                SectionHeading {
                    Layout.fillWidth: true
                    title: StartupFlow.stage === StartupFlow.SignIn ? "Вход" : "Выбор сервера"
                    description: StartupFlow.stage === StartupFlow.SignIn ? StartupFlow.endpoint : ""
                }

                Loader {
                    Layout.fillWidth: true
                    sourceComponent: StartupFlow.stage === StartupFlow.SignIn ? signInForm : serverForm
                }

                AppText {
                    Layout.fillWidth: true
                    visible: text.length > 0
                    text: SignInState.message || StartupFlow.message
                    color: Theme.palette.accent
                }
            }
        }
    }

    Component { id: serverForm; ServerSelectionForm {} }
    Component { id: signInForm; SignInForm {} }
}
