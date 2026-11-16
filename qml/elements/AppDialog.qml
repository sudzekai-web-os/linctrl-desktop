import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

Dialog {
    id: root

    property int preferredWidth: 420
    property bool busy: false
    property string acceptText: ""
    property string cancelText: ""
    property string description: ""

    anchors.centerIn: Overlay.overlay
    width: Math.min(preferredWidth, Overlay.overlay ? Math.max(0, Overlay.overlay.width - 24) : preferredWidth)
    modal: true
    dim: true
    focus: true
    padding: 16
    spacing: 8
    closePolicy: busy ? Popup.NoAutoClose : Popup.CloseOnEscape

    background: AppCard {}

    Overlay.modal: Rectangle { color: "#80000000" }

    header: AppText {
        visible: root.title !== ""
        text: root.title
        textFormat: Text.PlainText
        font.pixelSize: 20
        font.weight: Font.DemiBold
        topPadding: root.topPadding
        leftPadding: root.leftPadding
        rightPadding: root.rightPadding
    }

    contentItem: ColumnLayout {
        AppText {
            Layout.fillWidth: true
            text: root.description
            textFormat: Text.PlainText
        }
    }

    footer: Item {
        visible: root.acceptText !== "" || root.cancelText !== ""
        implicitHeight: root.acceptText !== "" || root.cancelText !== "" ? buttons.implicitHeight + root.bottomPadding : 0
        implicitWidth: buttons.implicitWidth + root.leftPadding + root.rightPadding

        RowLayout {
            id: buttons
            anchors.right: parent.right
            anchors.rightMargin: root.rightPadding

            DefaultButton {
                visible: root.cancelText !== ""
                text: root.cancelText
                enabled: !root.busy
                onClicked: root.reject()
            }
            DefaultButton {
                visible: root.acceptText !== ""
                text: root.acceptText
                primary: true
                enabled: !root.busy
                onClicked: root.accept()
            }
        }
    }
}
