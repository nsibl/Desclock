<div align="center">

<img src="assets/logo.png" alt="DesClock logo" width="140">

# DesClock

A clean and customizable desktop clock widget for KDE Plasma 6.

<img src="assets/main.png" alt="DesClock running on the KDE Plasma desktop" width="900">
<br>
<br>
<img src="assets/custom.png" alt="Customized DesClock running on the KDE Plasma desktop" width="900">
<br>
<br>
<img src="assets/settings.png" alt="DesClock configuration settings" width="900">
</div>

## Requirements

- KDE Plasma 6
- Qt 6
- `kpackagetool6`

## Installation

### Install from the KDE Store

DesClock is available through the KDE Store: https://store.kde.org/p/2365101/

1. Right-click an empty area of the KDE Plasma desktop.
2. Select **Add Widgets**.
3. Select **Get New Widgets** → **Download New Plasma Widgets**.
4. Search for **DesClock**.
5. Select **Install**.
6. Drag DesClock from the widget list onto your desktop.

You can also download the `.plasmoid` package directly from the KDE Store and install it using **Install Widget From Local File**.


### Install from source

Clone the repository:

```bash
git clone https://github.com/nsibl/desclock-plasmoid.git
cd desclock-plasmoid
```

Install the widget:

```bash
kpackagetool6 -t Plasma/Applet -i package
```

Then add DesClock to the desktop:

1. Right-click an empty area of the KDE Plasma desktop.
2. Select **Enter Edit Mode**.
3. Select **Add Widgets**.
4. Search for **DesClock**.
5. Drag the widget onto the desktop.
6. Move and resize it as desired.
7. Exit Edit Mode.

## Updating

Pull the latest changes:

```bash
git pull
```

Update the installed widget:

```bash
kpackagetool6 -t Plasma/Applet -u package
```

If changes do not appear immediately, log out and back in.

## Usage

Right-click DesClock and select **Configure DesClock** to customize:

- Time color
- Day and date color
- Font family
- Time font size
- Day and date font size
- Letter spacing
- Line spacing
- 12-hour or 24-hour time
- Show or hide seconds
- Uppercase day and date
- Text glow effect
- Glow strength

### Moving and resizing

Plasma manages widget positioning.

To move or resize DesClock:

1. Right-click the desktop.
2. Select **Enter Edit Mode**.
3. Hover over DesClock.
4. Drag or resize the widget.
5. Exit Edit Mode.

### Using additional fonts

DesClock includes Libre Baskerville and also supports fonts installed on your system.

The easiest way to install a font is:

1. Download a `.ttf` or `.otf` font file.
2. Open the font file from Dolphin.
3. Select **Install**.
4. Choose **Personal Use** if prompted.

You can also install a font manually by copying it into:

```text
~/.local/share/fonts/
```

Then refresh the system font cache:

```bash
fc-cache -f
```

Because DesClock runs inside Plasma, newly installed fonts may not appear until Plasma Shell is restarted.

Restart Plasma Shell with:

```bash
systemctl --user restart plasma-plasmashell.service
```

Your desktop panel and widgets may briefly disappear while Plasma reloads. Open DesClock's settings again and check the font list.

If the font still does not appear, log out and back in.

> The name shown in DesClock may differ from the font filename. For example, `Montserrat-VariableFont_wght.ttf` may appear simply as **Montserrat**.


## License

DesClock is licensed under the [GNU General Public License v3.0](LICENSE).

The bundled Libre Baskerville font is licensed separately under the SIL Open Font License. Its license is included in:

```text
package/contents/fonts/OFL.txt
```

## Credits

Created by Noah Sibley.

Built with KDE Plasma 6, QML, Qt Quick, and Kirigami.
