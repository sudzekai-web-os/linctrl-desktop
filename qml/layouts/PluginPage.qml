import QtQuick

Item {
    id: root

    required property string pluginId
    clip: true

    readonly property var page: pluginId && Plugins.enabledItems.some(plugin => plugin.id === pluginId)
        ? PluginFiles.load(pluginId) : ({})

    Loader {
        id: loader
        anchors.fill: parent
        source: root.page.entry || ""
    }

    AppText {
        anchors.centerIn: parent
        visible: root.visible && (loader.status === Loader.Error || loader.status === Loader.Null)
        text: root.page.error || qsTr("Не удалось открыть страницу плагина.")
    }
}
