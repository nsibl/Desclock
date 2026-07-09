import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root

    width: 500
    height: 250

    preferredRepresentation: fullRepresentation
    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground

    property date currentDateTime: new Date()

    FontLoader {
        id: pressStartFont

        source: Qt.resolvedUrl(
            "../fonts/PressStart2P-Regular.ttf"
        )
    }

    function timeFormat() {
        if (plasmoid.configuration.use24Hour) {
            if (plasmoid.configuration.showSeconds) {
                return "HH:mm:ss"
            } else {
                return "HH:mm"
            }
        } else {
            if (plasmoid.configuration.showSeconds) {
                return "h:mm:ss"
            } else {
                return "h:mm"
            }
        }
    }

    function shouldShowPeriodText() {
        if (plasmoid.configuration.use24Hour) {
            return false
        } else {
            return true
        }
    }

    function selectedFontFamily() {
        var configuredFont = plasmoid.configuration.fontFamily

        if (configuredFont.length > 0) {
            return configuredFont
        }

        if (pressStartFont.status === FontLoader.Ready) {
            return pressStartFont.name
        } else {
            return "Noto Sans"
        }
    }

    function maybeUppercase(value) {
        if (plasmoid.configuration.uppercaseLabels) {
            return value.toUpperCase()
        } else {
            return value
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            root.currentDateTime = new Date()
        }
    }

    fullRepresentation: Item {
        anchors.fill: parent

        ColumnLayout {
            anchors.centerIn: parent

            width: parent.width
            spacing: plasmoid.configuration.lineSpacing

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: timeRow.implicitHeight

                RowLayout {
                    id: timeRow

                    anchors.horizontalCenter: parent.horizontalCenter

                    spacing: 4

                    Text {
                        text: Qt.formatTime(
                            root.currentDateTime,
                            root.timeFormat()
                        )

                        color: plasmoid.configuration.timeColor

                        style: Text.Outline
                        styleColor: "#80000000"

                        font.family: root.selectedFontFamily()
                        font.pointSize:
                            plasmoid.configuration.timeFontSize
                        font.bold: true
                        font.letterSpacing:
                            plasmoid.configuration.letterSpacing
                    }

                    Text {
                        text: Qt.formatTime(
                            root.currentDateTime,
                            "AP"
                        )

                        visible: root.shouldShowPeriodText()

                        color: plasmoid.configuration.timeColor

                        style: Text.Outline
                        styleColor: "#80000000"

                        font.family: root.selectedFontFamily()
                        font.pointSize: Math.round(
                            plasmoid.configuration.timeFontSize * 0.72
                        )
                        font.bold: true
                        font.letterSpacing: 1

                        Layout.alignment: Qt.AlignBottom
                    }
                }
            }

            Text {
                Layout.fillWidth: true

                text: root.maybeUppercase(
                    Qt.formatDate(
                        root.currentDateTime,
                        "dddd"
                    )
                )

                horizontalAlignment: Text.AlignHCenter

                color: plasmoid.configuration.secondaryColor

                font.family: root.selectedFontFamily()
                font.pointSize:
                    plasmoid.configuration.secondaryFontSize
                font.bold: false
                font.letterSpacing:
                    plasmoid.configuration.letterSpacing + 2
            }

            Text {
                Layout.fillWidth: true

                text: root.maybeUppercase(
                    Qt.formatDate(
                        root.currentDateTime,
                        "MMMM d, yyyy"
                    )
                )

                horizontalAlignment: Text.AlignHCenter

                color: plasmoid.configuration.secondaryColor

                font.family: root.selectedFontFamily()
                font.pointSize: Math.max(
                    8,
                    plasmoid.configuration.secondaryFontSize - 3
                )
                font.bold: false
                font.letterSpacing:
                    plasmoid.configuration.letterSpacing
            }
        }
    }
}