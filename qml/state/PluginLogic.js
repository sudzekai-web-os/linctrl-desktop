.pragma library

function refresh(state, files, storage) {
    const result = files.scan()
    const flags = storage.read("plugins").enabled || {}
    state.items = Array.from(result.items, plugin => ({
        id: plugin.id, name: plugin.name, summary: plugin.summary, enabled: flags[plugin.id] === true
    }))
    state.error = result.error || ""
    state.changed()
}

function enabled(state, id) {
    return state.items.some(plugin => plugin.id === id && plugin.enabled)
}

function setEnabled(state, files, storage, id, value) {
    if (!state.items.some(plugin => plugin.id === id))
        return false
    const block = storage.read("plugins")
    const flags = Object.assign({}, block.enabled || {})
    flags[id] = value
    block.enabled = flags
    if (!storage.write("plugins", block)) {
        state.error = qsTr("Не удалось сохранить состояние плагина.")
        return false
    }
    refresh(state, files, storage)
    return true
}
