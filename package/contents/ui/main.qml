import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami

// Root object for the widget
PlasmoidItem {
    id: root

    // Set the default size
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

    // Determines format based on 12/24 hr
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

    // AM/PM only on 12 hr
    function shouldShowPeriodText() {
        if (plasmoid.configuration.use24Hour) {
            return false
        } else {
            return true
        }
    }

    // Return user selected font
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

    // Adds a dark outline only when the color channels are bright enough
    function outlineStyleForColor(textColor) {
        var red = textColor.r
        var green = textColor.g
        var blue = textColor.b

        if (red >= 0.80 &&
            green >= 0.80 &&
            blue >= 0.80) {
            return Text.Outline
        } else {
            return Text.Normal
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

        // Centers the components in vertical layout
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

                        style: root.outlineStyleForColor(
                            plasmoid.configuration.timeColor
                        )
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

                        style: root.outlineStyleForColor(
                            plasmoid.configuration.timeColor
                        )
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