
import Quickshell
import Quickshell.Io
import QtQuick

ShellRoot {
    id: root

    property bool shown: false
    property int percent: 0
    property bool muted: false
    property real currentVolume: 0

    IpcHandler {
        target: "volume"

        function show(): void {
            volumeProcess.running = true
            root.shown = true
            hideTimer.restart()
        }
    }

    Process {
        id: volumeProcess

        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]

        stdout: StdioCollector {
            onStreamFinished: {
                let output = text.trim()
                let match = output.match(/[\d.]+/)

                if (match) {
                    root.currentVolume = parseFloat(match[0])
                    root.percent = Math.round(root.currentVolume * 100)
                    root.muted = output.includes("[MUTED]")
                }
            }
        }
    }

    Timer {
        id: hideTimer
        interval: 1800
        onTriggered: root.shown = false
    }

    PanelWindow {
        anchors {
            bottom: true
            left: true
            right: true
        }

        implicitHeight: 100
        color: "transparent"
        exclusiveZone: 0
        focusable: false
				mask: Region {}

        Rectangle {
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
                bottomMargin: 24
            }

            width: 280
            height: 76
            radius: 14
            color: "#1e1e2e"
            border.width: 1
            border.color: "#45475a"
            visible: root.shown

            Column {
                anchors {
                    fill: parent
                    leftMargin: 18
                    rightMargin: 18
                    topMargin: 12
                    bottomMargin: 12
                }

                spacing: 10

                Item {
                    width: parent.width
                    height: 24

                    Row {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 10


                        Text {
                            text: "Volume"
                            color: "#cdd6f4"
                            font.pixelSize: 15
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    Text {
                        text: root.muted ? "Muted" : root.percent + "%"
                        color: "#cdd6f4"
                        font.pixelSize: 15
                        font.bold: false
                        anchors.right: parent.right
                        anchors.rightMargin: 6
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 8
                    radius: 4
                    color: "#45475a"

                    Rectangle {
                        width: parent.width * (root.muted ? 0 : Math.min(root.percent, 100)) / 100
                        height: parent.height
                        radius: 4
                        color: "#cba6f7"

                        Behavior on width {
                            NumberAnimation { duration: 120 }
                        }
                    }
                }
            }
        }
    }
}


