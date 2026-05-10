import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root

    property string pasteHost:     Plasmoid.configuration.pasteHost     || "http://192.168.1.10:8090"
    property int    ttlSeconds:    Plasmoid.configuration.ttlSeconds    || 604800
    property string pasteLanguage: Plasmoid.configuration.pasteLanguage || "plaintext"

    property bool   dropping:  false
    property bool   loading:   false
    property string statusMsg: ""
    property bool   isError:   false
    property string lastUrl:   ""

    toolTipMainText: "PasteDrop"
    toolTipSubText: {
        if (root.loading)  return "Creando paste...";
        if (root.lastUrl && !root.isError) return "✓ " + root.lastUrl;
        if (root.isError)  return "Error: " + root.statusMsg;
        return "Arrastrá texto o clic para pegar";
    }

    TextEdit { id: clipHelper; visible: false }

    function copyToClipboard(text) {
        clipHelper.text = text;
        clipHelper.selectAll();
        clipHelper.copy();
    }

    Timer {
        id: clearTimer
        interval: 4000
        onTriggered: { statusMsg = ""; isError = false; }
    }

    function createPaste(content) {
        if (!content || content.trim() === "") return;
        loading = true; statusMsg = ""; isError = false;
        var xhr = new XMLHttpRequest();
        xhr.open("POST", pasteHost + "/api/pastes", true);
        xhr.setRequestHeader("Content-Type", "application/json");
        xhr.onreadystatechange = function() {
            if (xhr.readyState !== XMLHttpRequest.DONE) return;
            loading = false;
            if (xhr.status === 201) {
                try {
                    var resp = JSON.parse(xhr.responseText);
                    lastUrl = pasteHost + "/p/" + resp.id;
                    copyToClipboard(lastUrl);
                    statusMsg = "ok"; isError = false;
                    clearTimer.restart();
                } catch(e) { statusMsg = "error"; isError = true; }
            } else { statusMsg = "error " + xhr.status; isError = true; }
        };
        xhr.send(JSON.stringify({
            content: content,
            language: pasteLanguage,
            ttl_seconds: ttlSeconds > 0 ? ttlSeconds : null
        }));
    }

    // ── Compact: ícono en el panel ────────────────────────────────────────────
    compactRepresentation: Item {
        DropArea {
            anchors.fill: parent
            onEntered: { root.dropping = true }
            onExited:  { root.dropping = false }
            onDropped: (drop) => {
                root.dropping = false;
                var text = drop.text || drop.urls.join("\n") || "";
                if (text.trim() !== "") {
                    drop.acceptProposedAction();
                    root.createPaste(text);
                }
            }
        }

        Kirigami.Icon {
            anchors.centerIn: parent
            width:  Math.min(parent.width, parent.height)
            height: width
            source: {
                if (root.isError)   return "dialog-error";
                if (root.statusMsg) return "dialog-ok-apply";
                if (root.dropping)  return "list-add";
                return "text-x-generic";
            }
            color: Kirigami.Theme.textColor
            opacity: root.dropping ? 0.7 : 1.0
            Behavior on opacity { NumberAnimation { duration: 120 } }

            RotationAnimator on rotation {
                running: root.loading
                from: 0; to: 360
                duration: 800
                loops: Animation.Infinite
            }
        }

        Rectangle {
            anchors.fill: parent
            color:   Kirigami.Theme.highlightColor
            opacity: root.dropping ? 0.3 : 0.0
            radius:  4
            Behavior on opacity { NumberAnimation { duration: 120 } }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                clipHelper.text = "";
                clipHelper.paste();
                var content = clipHelper.text;
                if (content && content.trim() !== "") {
                    root.createPaste(content);
                } else {
                    root.statusMsg = "vacío";
                    root.isError = true;
                    clearTimer.restart();
                }
            }
        }
    }

    // ── Full: popup mínimo al hacer clic en el ícono ──────────────────────────
    fullRepresentation: Rectangle {
        width:  300
        height: 80
        color:  Kirigami.Theme.backgroundColor
        radius: 6

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 6

            Kirigami.Icon {
                Layout.alignment: Qt.AlignHCenter
                width:  24; height: 24
                source: root.isError ? "dialog-error" : root.lastUrl ? "dialog-ok-apply" : "text-x-generic"
                color:  Kirigami.Theme.textColor
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: {
                    if (root.loading)  return "Creando paste...";
                    if (root.lastUrl && !root.isError) return root.lastUrl;
                    if (root.isError)  return "Error: " + root.statusMsg;
                    return "Arrastrá texto al ícono\no hacé clic para pegar";
                }
                color: root.isError ? "#ff6b6b" : Kirigami.Theme.textColor
                font.pixelSize: 11
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}
