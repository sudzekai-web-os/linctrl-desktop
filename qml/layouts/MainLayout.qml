import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

Item {
    id: root
    objectName: "mainLayout"

    property string page: "home"

    function navigate(page) { root.page = page }

    readonly property bool pluginPage: root.page.startsWith("plugin:")
    readonly property string pluginId: pluginPage ? root.page.substring(7) : ""
    readonly property var pages: ({
        home: homePage,
        settings: settingsPage,
        plugins: pluginsPage,
        profile: profilePage
    })

    Component { id: homePage; HomePage { onOpenPage: page => root.navigate(page) } }
    Component { id: settingsPage; SettingsPage {} }
    Component { id: pluginsPage; PluginsPage {} }
    Component { id: profilePage; ProfilePage {} }

    Connections {
        target: Plugins
        function onChanged() {
            if (root.pluginPage && !Plugins.enabledItems.some(plugin => plugin.id === root.pluginId))
                root.navigate("plugins")
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        WorkspaceSidebar {
            visible: root.page !== "home"
            Layout.preferredWidth: root.width < 920 ? 176 : 232
            Layout.fillHeight: true
            page: root.page
            onOpenPage: page => root.navigate(page)
        }

        Rectangle {
            visible: root.page !== "home"
            Layout.fillHeight: true
            implicitWidth: 1
            color: Theme.palette.line
        }

        Loader {
            visible: !root.pluginPage
            Layout.fillWidth: true
            Layout.fillHeight: true
            sourceComponent: root.pluginPage ? null : root.pages[root.page]
        }

        PluginPage {
            visible: root.pluginPage
            Layout.fillWidth: true
            Layout.fillHeight: true
            pluginId: root.pluginId
        }
    }
}
