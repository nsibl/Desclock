# Desclock - A Desktop Clock Plasmoid

A simple KDE Plasma desktop clock widget built mostly with QML.

It displays:

- Current time
- Day of the week
- Current date

It also supports configurable appearance options such as font, color, font size, spacing, seconds, uppercase text, and 12/24-hour time.

## Project structure

```text
package/
├── metadata.json
└── contents/
    ├── config/
    │   ├── config.qml
    │   └── main.xml
    └── ui/
        ├── configGeneral.qml
        └── main.qml
