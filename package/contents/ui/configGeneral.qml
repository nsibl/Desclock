import QtQuick
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.kquickcontrols as KQControls

Kirigami.FormLayout {
    id: page

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

    KQControls.ColorButton {
        id: timeColorButton
        Kirigami.FormData.label: i18n("Time Color:")
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

        model: Qt.fontFamilies()

        delegate: QQC2.ItemDelegate {
            height: Kirigami.Units.gridUnit * 2
            width: fontFamilyBox.width
            text: modelData
            font.family: modelData
            font.pointSize: 12

            highlighted: fontFamilyBox.highlightedIndex === index
        }

        Component.onCompleted: {
            var selectedIndex = fontFamilyBox.find(page.cfg_fontFamily)

            if (selectedIndex < 0) {
                selectedIndex = fontFamilyBox.find("Noto Sans")
            }

            if (selectedIndex < 0) {
                selectedIndex = 0;
            }

            fontFamilyBox.currentIndex = selectedIndex
        }

        onActivated: function(index) {
            page.cfg_fontFamily = fontFamilyBox.textAt(index)
        }
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
        Kirigami.FormData.label: i18n("Line Spacing:")
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