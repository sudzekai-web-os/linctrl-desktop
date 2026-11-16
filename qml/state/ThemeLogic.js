.pragma library

const builtin = ":/qt/qml/linctrl/styles/"

function initialize(state, storage, files) {
    const sources = files.sources()
    const styles = []
    for (const candidate of sources.styles)
        addStyle(styles, files, candidate.id, candidate.document)

    let fallback = builtin + "corporate-" + sources.mode + ".json"
    if (sources.legacyPath) {
        for (const variant of ["light", "dark"]) {
            const id = sources.legacyPath + "#" + variant
            const document = { name: sources.legacyName + " / " + variant,
                summary: qsTr("Палитра из предыдущей версии."), colors: sources.legacy[variant] }
            if (addStyle(styles, files, id, document) && variant === sources.mode)
                fallback = id
        }
    }

    state.styles = styles
    state.active = styles[0] || {}
    const saved = storage.read("appearance").style || sources.legacySelection || fallback
    select(state, storage, saved)
}

function addStyle(styles, files, id, document) {
    if (!document || typeof document.name !== "string" || !document.name.trim()
        || typeof document.summary !== "string" || !document.colors)
        return false

    const colors = {}
    for (const key of ["background", "surface", "ink", "muted", "line", "accent", "onAccent"]) {
        const value = document.colors[key]
        if (typeof value !== "string" || !files.validColor(value))
            return false
        colors[key] = value
    }

    const style = { id: id, name: document.name.trim(), summary: document.summary, colors: colors }
    const index = styles.findIndex(candidate => candidate.id === id)
    if (index < 0)
        styles.push(style)
    else
        styles[index] = style
    return true
}

function select(state, storage, id) {
    const style = state.styles.find(candidate => candidate.id === id)
    if (!style)
        return
    state.active = style
    if (!storage.write("appearance", { style: id }))
        console.warn("Cannot save appearance settings")
}
