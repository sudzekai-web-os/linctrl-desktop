pragma Singleton
import QtQuick
import "ServerCatalogLogic.js" as Logic

QtObject {
    id: root

    property var items: DesktopStorage.read("servers").items || []

    function add(address, port, secure) {
        return Logic.add(root, DesktopNetwork, DesktopStorage, address, port, secure)
    }

    function contains(server) {
        return items.some(item => Logic.sameServer(item, server))
    }
}
