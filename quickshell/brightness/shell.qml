
import Quickshell
import Quickshell.Io
import QtQuick

ShellRoot {
    id: root

    property bool shown: false
    property int percent: 0

    IpcHandler {
        target: "brightness"

        function show(): void {
            brightnessProcess.running = true
            root.shown = true
            hideTimer.restart()
        }
    }

    Process {
        id: brightnessProcess

        command: ["brightnessctl", "get"]

        stdout: StdioCollector {
            onStreamFinished: {
                let current = parseInt(text.trim())
                if (!isNaN(current)) {
                    maxProcess.running = true
                    root.currentBrightness = current
                }
            }
        }
    }

    property int currentBrightness: 0

    Process {
        id: maxProcess

        command: ["brightnessctl", "max"]

        stdout: StdioCollector {
            onStreamFinished: {
                let maximum = parseInt(text.trim())
                if (maximum > 0) {
                    root.percent = Math.round(
                        root.currentBrightness * 100 / maximum
                    )
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

                Row {
                    width: parent.width
                    spacing: 10

                    Text {
                        text: "☀"
                        color: "#f9e2af"
                        font.pixelSize: 21
                    }

                    Text {
                        text: "Brightness"
                        color: "#cdd6f4"
                        font.pixelSize: 15
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Item {
                        width: Math.max(0, parent.width - 174)
                        height: 1
                    }

                    Text {
                        text: root.percent + "%"
                        color: "#cdd6f4"
                        font.pixelSize: 15
                        font.bold: false
                        anchors.verticalCenter: parent.verticalCenter
												anchors.rightMargin: -20
                    }

                }

                Rectangle {
                    width: parent.width
                    height: 8
                    radius: 4
                    color: "#45475a"

                    Rectangle {
                        width: parent.width * root.percent / 100
                        height: parent.height
                        radius: 4
                        color: "#89b4fa"

                        Behavior on width {
                            NumberAnimation {
                                duration: 120
                            }
                        }
                    }
                }
            }

            Behavior on opacity {
                NumberAnimation { duration: 120 }
            }
        }
    }
}

