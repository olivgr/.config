import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.Pipewire
import QtQuick

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 30
            color: "transparent"

            Rectangle {
                anchors.fill: parent
                color: "#19191c"
                opacity: 1.0

                // ─────────────────────────────────────────
                // Workspaces
                // ─────────────────────────────────────────

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

                            property int workspaceId: index + 1

                            property var workspace:
                                Hyprland.workspaces.values.find(
                                    w => w.id === workspaceId
                                )

                            property bool focused:
                                Hyprland.focusedWorkspace?.id === workspaceId

                            property bool occupied:
                                workspace !== undefined

                            width: 24
                            height: 24

                            // Selected workspace: small square
                            Rectangle {
                                anchors.centerIn: parent

                                width: focused ? 14 : 0
                                height: focused ? 14 : 0

                                radius: 3

                                color: "#ffa85b"
                                //color: "#b01717"

                                opacity: 0.9
                            }

                            // Unselected workspace: number
                            Text {
                                anchors.centerIn: parent

                                visible: !focused

                                text: workspaceId

                                color:
                                    occupied
                                        ? "#bbbbbb"
                                        : "#66666d"

                                font.family: "Inter"
                                font.pixelSize: 14
                                font.weight: Font.Medium
                            }

                            MouseArea {
                                anchors.fill: parent

                                cursorShape:
                                    Qt.PointingHandCursor

                                onClicked: {
                                    Hyprland.dispatch(
                                        "hl.dsp.focus({ workspace = \"" +
                                        workspaceId +
                                        "\" })"
                                    )
                                }
                            }
                        }
                    }
                }

                // ─────────────────────────────────────────
                // Clock
                // ─────────────────────────────────────────

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

                        onTriggered:
                            clock.now = new Date()
                    }

                    Text {
                        anchors.fill: parent

                        text:
                            Qt.formatDate(
                                clock.now,
                                "ddd d MMM"
                            ) +
                            " " +
                            Qt.formatTime(
                                clock.now,
                                "HH:mm"
                            )

                        color: "#bbbbbb"

                        font.family: "Inter"
                        font.pixelSize: 14
                        font.weight: Font.Medium

                        horizontalAlignment:
                            Text.AlignRight

                        verticalAlignment:
                            Text.AlignVCenter
                    }

                    MouseArea {
                        anchors.fill: parent

                        cursorShape:
                            Qt.PointingHandCursor
                    }
                }

                // ─────────────────────────────────────────
                // Audio
                // ─────────────────────────────────────────

                Item {
                    id: audio

                    anchors {
                        right: parent.right
                        rightMargin: 10
                        verticalCenter: parent.verticalCenter
                    }

                    width: 160
                    height: 24

                    Text {
                        anchors.fill: parent

                        property string sinkName: {
                            let sink =
                                Pipewire.defaultAudioSink

                            if (!sink)
                                return "No Audio"

                            return sink.description
                        }

                        text: sinkName

                        color:
                            sinkName === "ULN-8 Pro"
                                ? "#a6e3a1"
                                : "#cccccc"

                        font.family: "Inter"
                        font.pixelSize: 14
                        font.weight: Font.Medium

                        horizontalAlignment:
                            Text.AlignRight

                        verticalAlignment:
                            Text.AlignVCenter

                        elide:
                            Text.ElideLeft
                    }

                    MouseArea {
                        anchors.fill: parent

                        cursorShape:
                            Qt.PointingHandCursor

                        onClicked: {
                            if (pavucontrol.running)
                                pavucontrol.running = false
                            else
                                pavucontrol.running = true
                        }
                    }

                    Process {
                        id: pavucontrol

                        command: [
                            "pavucontrol"
                        ]
                    }
                }
            }
        }
    }
}
