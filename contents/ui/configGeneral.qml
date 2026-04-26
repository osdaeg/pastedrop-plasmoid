import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    id: configPage

    property alias cfg_pasteHost:     hostField.text
    property alias cfg_pasteLanguage: langField.text
    property var   cfg_ttlSeconds:    604800

    TextField {
        id: hostField
        Kirigami.FormData.label: "URL del servidor:"
        placeholderText: "http://192.168.88.100:8090"
        Layout.fillWidth: true
    }

    ComboBox {
        id: ttlCombo
        Kirigami.FormData.label: "Expiración predeterminada:"
        textRole: "text"
        valueRole: "value"
        model: [
            { text: "Nunca",    value: 0       },
            { text: "1 hora",   value: 3600    },
            { text: "6 horas",  value: 21600   },
            { text: "1 día",    value: 86400   },
            { text: "7 días",   value: 604800  },
            { text: "30 días",  value: 2592000 },
        ]
        Component.onCompleted: {
            for (var i = 0; i < model.length; i++) {
                if (model[i].value === cfg_ttlSeconds) {
                    currentIndex = i
                    break
                }
            }
        }
        onActivated: cfg_ttlSeconds = parseInt(currentValue)
    }

    // Campo oculto para guardar el lenguaje (alias directo al text del TextField)
    TextField {
        id: langField
        visible: false
    }

    ComboBox {
        id: langCombo
        Kirigami.FormData.label: "Lenguaje predeterminado:"
        textRole: "text"
        valueRole: "value"
        model: [
            { text: "plaintext",  value: "plaintext"  },
            { text: "python",     value: "python"     },
            { text: "bash",       value: "bash"       },
            { text: "javascript", value: "javascript" },
            { text: "json",       value: "json"       },
            { text: "yaml",       value: "yaml"       },
            { text: "markdown",   value: "markdown"   },
            { text: "sql",        value: "sql"        },
        ]
        Component.onCompleted: {
            for (var i = 0; i < model.length; i++) {
                if (model[i].value === cfg_pasteLanguage) {
                    currentIndex = i
                    break
                }
            }
        }
        onActivated: cfg_pasteLanguage = currentValue
    }
}
