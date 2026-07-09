import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
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

    // Loads the bundled Libre Baskerville variable font.
    FontLoader {
        id: libreBaskervilleFont

        source: Qt.resolvedUrl(
            "../fonts/LibreBaskerville-VariableFont_wght.ttf"
        )
    }

    // Adds a leading zero to values below 10.
    function twoDigitNumber(value) {
        if (value < 10) {
            return "0" + value
        } else {
            return value.toString()
        }
    }

    // Builds the displayed time based on the user's settings.
    function formattedTime() {
        var hours = root.currentDateTime.getHours()
        var minutes = root.currentDateTime.getMinutes()
        var seconds = root.currentDateTime.getSeconds()
        var displayedTime = ""

        if (plasmoid.configuration.use24Hour) {
            displayedTime =
                root.twoDigitNumber(hours)
                + ":"
                + root.twoDigitNumber(minutes)
        } else {
            if (hours === 0) {
                hours = 12
            } else {
                if (hours > 12) {
                    hours = hours - 12
                }
            }

            displayedTime =
                hours.toString()
                + ":"
                + root.twoDigitNumber(minutes)
        }

        if (plasmoid.configuration.showSeconds) {
            displayedTime =
                displayedTime
                + ":"
                + root.twoDigitNumber(seconds)
        }

        return displayedTime
    }
    // AM/PM only on 12 hr
    function shouldShowPeriodText() {
        if (plasmoid.configuration.use24Hour) {
            return false
        } else {
            return true
        }
    }

    // Returns the font selected by the user.
    // Libre Baskerville is used when no font has been selected.
    function selectedFontFamily() {
        var configuredFont = plasmoid.configuration.fontFamily

        if (configuredFont.length > 0) {
            return configuredFont
        }

        if (libreBaskervilleFont.status === FontLoader.Ready) {
            return libreBaskervilleFont.name
        } else {
            return "Noto Serif"
        }
    }

    // Convert day and date to uppercase when selected
    function maybeUppercase(value) {
        if (plasmoid.configuration.uppercaseLabels) {
            return value.toUpperCase()
        } else {
            return value
        }
    }

    // Adds a dark outline only when the color channels are bright enough, and when not glowing
    function outlineStyleForColor(textColor) {
        if (plasmoid.configuration.glowEnabled) {
            return Text.Normal
        }

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

    // Converts 10-100 config value for glowing into 0.0-1.0 range used by MultiEffect
    function glowBlurAmount() {
        return plasmoid.configuration.glowStrength / 100.0
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
                        id: timeText
                        text: root.formattedTime()

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

                        layer.enabled: plasmoid.configuration.glowEnabled

                        layer.effect: MultiEffect {
                            shadowEnabled: true

                            // Match the glow to the selected time color.
                            shadowColor: timeText.color

                            shadowBlur: root.glowBlurAmount()
                            shadowOpacity: 0.9

                            // Zero offsets make this look like a glow
                            shadowHorizontalOffset: 0
                            shadowVerticalOffset: 0

                            blurMax: 32
                        }
                    }

                    Text {
                        id: periodText
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

                        layer.enabled: plasmoid.configuration.glowEnabled

                        layer.effect: MultiEffect {
                            shadowEnabled: true
                            shadowColor: periodText.color

                            shadowBlur: root.glowBlurAmount()
                            shadowOpacity: 0.9

                            shadowHorizontalOffset: 0
                            shadowVerticalOffset: 0

                            blurMax: 32
                        }
                    }
                }
            }

            Text {
                id: dayText
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

                layer.enabled: plasmoid.configuration.glowEnabled

                layer.effect: MultiEffect {
                    shadowEnabled: true
                    shadowColor: dayText.color

                    shadowBlur: root.glowBlurAmount()
                    shadowOpacity: 0.8

                    shadowHorizontalOffset: 0
                    shadowVerticalOffset: 0

                    blurMax: 32
                }
            }

            Text {
                id: dateText
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

                layer.enabled: plasmoid.configuration.glowEnabled

                layer.effect: MultiEffect {
                    shadowEnabled: true
                    shadowColor: dateText.color

                    shadowBlur: root.glowBlurAmount()
                    shadowOpacity: 0.7

                    shadowHorizontalOffset: 0
                    shadowVerticalOffset: 0

                    blurMax: 32
                }
            }
        }
    }
}