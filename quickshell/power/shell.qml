import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
    id: root

    visible: false
    color: "transparent"

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    IpcHandler {
        target: "power"

        function show(): void {
            root.visible = true
        }

        function hide(): void {
            root.visible = false
        }
    }

    Process {
        id: powerAction
    }

    function restart(): void {
        root.visible = false
        powerAction.command = ["sh", "-c", "wineserver -k; systemctl reboot"]
        powerAction.running = true
    }

    function shutdown(): void {
        root.visible = false
        powerAction.command = ["sh", "-c", "wineserver -k; systemctl poweroff"]
        powerAction.running = true
    }

    function cancel(): void {
        root.visible = false
    }

    Item {
        anchors.fill: parent
        focus: true

        Keys.onPressed: event => {
            if (event.key === Qt.Key_R) {
                root.restart()
                event.accepted = true
            } else if (event.key === Qt.Key_S) {
                root.shutdown()
                event.accepted = true
            } else if (
                event.key === Qt.Key_C ||
                event.key === Qt.Key_Escape
            ) {
                root.cancel()
                event.accepted = true
            }
        }

        Rectangle {
            anchors.fill: parent
            color: "#99000000"

            MouseArea {
                anchors.fill: parent
                onClicked: root.cancel()
            }
        }

        Rectangle {
            id: dialog

            anchors.centerIn: parent
            width: 332
            height: 78
            radius: 12
            color: "#1e1e2e"
            border.color: "#45475a"
            border.width: 1

            Column {
                //anchors.fill: parent
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: 24
                spacing: 18


                Row {
                    spacing: 14

                    Repeater {
                        model: [
                            {
                                key: "R",
                                label: "Restart",
                                action: "restart",
                                color: "#f38ba8"
                            },
                            {
                                key: "S",
                                label: "Shut down",
                                action: "shutdown",
                                color: "#fab387"
                            },
                            {
                                key: "C",
                                label: "Cancel",
                                action: "cancel",
                                color: "#a6e3a1"
                            }
                        ]

                        delegate: Rectangle {
                            required property var modelData

                            width: 96
                            height: 58
                            radius: 8
                            color: "#313244"
                            border.color: modelData.color
                            border.width: 1

                            Column {
                                anchors.centerIn: parent
                                spacing: 3

                                Text {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: modelData.key
                                    color: modelData.color
                                    font.pixelSize: 18
                                    font.bold: true
                                }

                                Text {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: modelData.label
                                    color: "#cdd6f4"
                                    font.pixelSize: 11
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if (modelData.action === "restart")
                                        root.restart()
                                    else if (modelData.action === "shutdown")
                                        root.shutdown()
                                    else
                                        root.cancel()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
