import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.kquickcontrols as KQControls

// This is the main layout for the settings page
Kirigami.FormLayout {
    id: page

    // Define properties here
    property alias cfg_timeColor: timeColorButton.color
    property alias cfg_secondaryColor: secondaryColorButton.color
    property string cfg_fontFamily
    property alias cfg_timeFontSize: timeFontSizeBox.value
    property alias cfg_secondaryFontSize: secondaryFontSizeBox.value
    property alias cfg_showSeconds: showSecondsBox.checked
    property alias cfg_use24Hour: use24HourBox.checked
    property alias cfg_uppercaseLabels: uppercaseLabelsBox.checked
    property alias cfg_letterSpacing: letterSpacingBox.value
    property alias cfg_lineSpacing: lineSpacingBox.value

    // Loads the default font I included
    FontLoader {
        id: pressStartFont

        source: Qt.resolvedUrl(
            "../fonts/PressStart2P-Regular.ttf"
        )

        // Rebuild the font selector after font finishes loading or if fails to load
        onStatusChanged: {
            if (status === FontLoader.Ready) {
                page.initializeFontSelector()
            }

            if (status === FontLoader.Error) {
                page.initializeFontSelector()
            }
        }
    }

    // Store included and user installed fonts
    ListModel {
        id: availableFonts
    }

    // Builds font list for dropdown in settings
    function populateFontList() {
        availableFonts.clear()

        if (pressStartFont.status === FontLoader.Ready) {
            availableFonts.append({
                fontName: pressStartFont.name
            })
        }

        var systemFonts = Qt.fontFamilies()

        // Add installed fonts and avoid duplicates
        for (var i = 0; i < systemFonts.length; i++) {
            var currentFont = systemFonts[i]
            var shouldAddFont = true

            if (pressStartFont.status === FontLoader.Ready) {
                if (currentFont === pressStartFont.name) {
                    shouldAddFont = false
                }
            }

            if (shouldAddFont) {
                availableFonts.append({
                    fontName: currentFont
                })
            }
        }
    }

    // Selects user's previously selected font, if unavailable fall back to one of these two
    function selectSavedFont() {
        var selectedIndex = -1

        if (page.cfg_fontFamily.length > 0) {
            selectedIndex = fontFamilyBox.find(
                page.cfg_fontFamily
            )
        }

        if (selectedIndex < 0) {
            if (pressStartFont.status === FontLoader.Ready) {
                selectedIndex = fontFamilyBox.find(
                    pressStartFont.name
                )
            }
        }

        if (selectedIndex < 0) {
            selectedIndex = fontFamilyBox.find(
                "Noto Sans"
            )
        }

        if (selectedIndex < 0) {
            selectedIndex = 0
        }

        fontFamilyBox.currentIndex = selectedIndex
    }

    // Wait for font to load then create list/select saved font
    function initializeFontSelector() {
        if (pressStartFont.status === FontLoader.Loading) {
            return
        }

        page.populateFontList()
        page.selectSavedFont()
    }

    Component.onCompleted: {
        page.initializeFontSelector()
    }

    KQControls.ColorButton {
        id: timeColorButton

        Kirigami.FormData.label: i18n("Time color:")
        showAlphaChannel: true
    }

    KQControls.ColorButton {
        id: secondaryColorButton

        Kirigami.FormData.label: i18n("Day/date color:")
        showAlphaChannel: true
    }

    QQC2.ComboBox {
        id: fontFamilyBox

        Kirigami.FormData.label: i18n("Font family:")

        // Use the custom font list
        model: availableFonts
        textRole: "fontName"

        // How the entries look in the dropdown
        delegate: QQC2.ItemDelegate {
            required property int index
            required property string fontName

            width: fontFamilyBox.width
            height: Kirigami.Units.gridUnit * 2

            text: fontName

            font.family: fontName
            font.pointSize: 12

            highlighted: fontFamilyBox.highlightedIndex === index
        }

        onActivated: function(index) {
            page.cfg_fontFamily = fontFamilyBox.textAt(index)
        }
    }

    // Font preview
    Text {
        text: i18n("Try out fonts here")

        font.family: fontFamilyBox.currentText
        font.pointSize: 14

        color: Kirigami.Theme.textColor
    }

    QQC2.SpinBox {
        id: timeFontSizeBox

        Kirigami.FormData.label: i18n("Time font size:")

        from: 16
        to: 96
    }

    QQC2.SpinBox {
        id: secondaryFontSizeBox

        Kirigami.FormData.label: i18n("Day/date font size:")

        from: 8
        to: 48
    }

    QQC2.SpinBox {
        id: letterSpacingBox

        Kirigami.FormData.label: i18n("Letter spacing:")

        from: 0
        to: 12
    }

    QQC2.SpinBox {
        id: lineSpacingBox

        Kirigami.FormData.label: i18n("Line spacing:")

        from: 0
        to: 30
    }

    QQC2.CheckBox {
        id: showSecondsBox

        text: i18n("Show seconds")
    }

    QQC2.CheckBox {
        id: use24HourBox

        text: i18n("Use 24-hour time")
    }

    QQC2.CheckBox {
        id: uppercaseLabelsBox

        text: i18n("Uppercase day and date")
    }
}