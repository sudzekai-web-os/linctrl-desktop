import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

ApplicationWindow {
    id: root

    readonly property bool customFrame: Qt.platform.os === "windows"

    width: 1180
    height: 800
    minimumWidth: 820
    minimumHeight: 620
    visible: true
    title: "LinCtrl"
    color: Theme.palette.background

    Component.onCompleted: StartupFlow.initialize()
    flags: {
        if (customFrame)
            return Qt.Window | Qt.FramelessWindowHint
        if (Qt.platform.os === "osx")
            return Qt.Window | Qt.WindowFullscreenButtonHint

        return Qt.Window
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        TitleBar {
            visible: root.customFrame
            window: root
            Layout.fillWidth: true
            Layout.preferredHeight: 35
        }
        Loader {
            Layout.fillWidth: true
            Layout.fillHeight: true
            sourceComponent: StartupFlow.stage === StartupFlow.Workspace ? workspace : startup
        }
    }
    Loader {
        active: root.customFrame && !WindowChrome.active
        anchors.fill: parent
        z: 1
        sourceComponent: WindowResizeArea { window: root }
    }

    Component { id: workspace; MainLayout {} }
    Component { id: startup; StartupPage {} }
}
