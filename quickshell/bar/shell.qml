
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import QtQuick

Scope {
    id: root

    property var monitorData: ({ monitors: [] })
    property bool barVisible: true

    // ─────────────────────────────────────────
    // Quickshell IPC: toggle bar visibility
    // ─────────────────────────────────────────

    IpcHandler {
        target: "bar"

        function toggle(): void {
            root.barVisible = !root.barVisible
        }

        function show(): void {
            root.barVisible = true
        }

        function hide(): void {
            root.barVisible = false
        }
    }

    // ─────────────────────────────────────────
    // MangoWC IPC: persistent event-driven watch
    // ─────────────────────────────────────────

    Process {
        id: monitorWatcher

        command: ["mmsg", "watch", "all-monitors"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                try {
                    root.monitorData = JSON.parse(data)
                } catch (e) {
                    console.warn("Mango IPC JSON error:", e)
                }
            }
        }

        onExited: {
            restartTimer.start()
        }
    }

    Timer {
        id: restartTimer
        interval: 1000
        repeat: false

        onTriggered: monitorWatcher.running = true
    }

    // ─────────────────────────────────────────
    // Panels
    // ─────────────────────────────────────────

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: panelRoot

            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 30
            color: "transparent"
            visible: root.barVisible

            property var mangoMonitor: {
                const monitors = root.monitorData.monitors || []

                return monitors.find(
                    m => m.name === panelRoot.screen.name
                ) || null
            }

            Rectangle {
                anchors.fill: parent
                color: "#19191c"

                // ─────────────────────────────
                // Workspaces / Mango tags
                // ─────────────────────────────

                Row {
                    anchors {
                        left: parent.left
                        leftMargin: 10
                        verticalCenter: parent.verticalCenter
                    }

                    spacing: 2

                    Repeater {
                        model: 5

                        Item {
                            required property int index

                            readonly property int workspaceId: index + 1

                            readonly property var tag: {
                                const tags =
                                    panelRoot.mangoMonitor?.tags || []

                                return tags.find(
                                    t => t.index === workspaceId
                                ) || null
                            }

                            readonly property bool focused:
                                tag?.is_active ?? false

                            readonly property bool occupied:
                                (tag?.client_count ?? 0) > 0

                            width: 24
                            height: 24

                            // Active tag: orange square
                            Rectangle {
                                anchors.centerIn: parent

                                width: focused ? 14 : 0
                                height: focused ? 14 : 0

                                radius: 3
                                color: "#ffa85b"
                                opacity: 0.9
                            }

                            // Inactive tag: number
                            Text {
                                anchors.centerIn: parent
                                visible: !focused

                                text: workspaceId

                                color: occupied
                                    ? "#bbbbbb"
                                    : "#66666d"

                                font.family: "Inter"
                                font.pixelSize: 14
                                font.weight: Font.Medium
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor

                                onClicked: {
                                    tagSwitcher.command = [
                                        "mmsg",
                                        "dispatch",
                                        "view," + workspaceId
                                    ]

                                    tagSwitcher.running = true
                                }
                            }
                        }
                    }
                }

                // ─────────────────────────────────
                // Clock
                // ─────────────────────────────────

                Item {
                    id: clock

                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        verticalCenter: parent.verticalCenter
                    }

                    width: 150
                    height: 24

                    property date now: new Date()

                    Timer {
                        interval: 1000
                        running: true
                        repeat: true

                        onTriggered: clock.now = new Date()
                    }

                    Text {
                        anchors.fill: parent

                        text:
                            Qt.formatDate(clock.now, "ddd d MMM")
                            + " "
                            + Qt.formatTime(clock.now, "HH:mm")

                        color: "#bbbbbb"

                        font.family: "Inter"
                        font.pixelSize: 14
                        font.weight: Font.Medium

                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                // ─────────────────────────────────
                // Default audio sink
                // ─────────────────────────────────

                Item {
                    id: audio

                    anchors {
                        right: parent.right
                        rightMargin: 10
                        verticalCenter: parent.verticalCenter
                    }

                    width: 200
                    height: 24

                    Text {
                        id: audioLabel

                        anchors.fill: parent

                        property string sinkName: {
                            const sink = Pipewire.defaultAudioSink

                            return sink
                                ? sink.description
                                : "No Audio"
                        }

                        text: sinkName

                        color: sinkName === "ULN-8 Pro"
                            ? "#a6e3a1"
                            : "#cccccc"

                        font.family: "Inter"
                        font.pixelSize: 14
                        font.weight: Font.Medium

                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideLeft
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            if (!pavucontrol.running)
                                pavucontrol.running = true
                        }
                    }
                }
            }
        }
    }

    // ─────────────────────────────────────────
    // On-demand commands
    // ─────────────────────────────────────────

    Process {
        id: tagSwitcher
    }

    Process {
        id: pavucontrol
        command: ["pavucontrol"]
    }
}
