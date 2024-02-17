import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

// Define a data model for the color palette
class ColorPalette {
  final List<Color> colors;
  bool isSelected;

  ColorPalette({required this.colors, this.isSelected = false});
}

class CustomPaletteSelector extends StatefulWidget {
  final Function(ColorPalette) onPaletteChanged;

  const CustomPaletteSelector({Key? key, required this.onPaletteChanged})
      : super(key: key);

  @override
  _CustomPaletteSelectorState createState() => _CustomPaletteSelectorState();
}

class _CustomPaletteSelectorState extends State<CustomPaletteSelector> {
  // A list of color palettes to select from
  List<ColorPalette> palettes = [
    ColorPalette(
      colors: [Colors.red, Colors.pink, Colors.blue, Colors.lightBlue],
      isSelected: false,
    ),
    ColorPalette(
      colors: [Colors.orange, Colors.redAccent, Colors.blueAccent, Colors.cyan],
      isSelected: false,
    ),
    ColorPalette(
      colors: [
        Colors.deepOrange,
        Colors.orangeAccent,
        Colors.blueGrey,
        Colors.indigo
      ],
      isSelected: false,
    ),
  ];

  // The customizable color palette
  ColorPalette customPalette = ColorPalette(
    colors: [Colors.red, Colors.pink, Colors.blue, Colors.lightBlue],
    isSelected: false,
  );

  // Function to call the widget's callback with the selected palette
  void _emitPaletteChange(ColorPalette palette) {
    widget.onPaletteChanged(palette);
  }

  // This function is called when a predefined palette is selected
  void _onPredefinedPaletteSelected(int index, bool? selected) {
    setState(() {
      // Set all palettes to not selected
      for (var palette in palettes) {
        palette.isSelected = false;
      }
      customPalette.isSelected = false; // Deselect custom palette
      palettes[index].isSelected = selected ?? false;
    });
    _emitPaletteChange(palettes[index]);
  }

  // This function is called when the custom palette is selected
  void _onCustomPaletteSelected(bool? selected) {
    setState(() {
      // Set all predefined palettes to not selected
      for (var palette in palettes) {
        palette.isSelected = false;
      }
      customPalette.isSelected = selected ?? false;
    });
    if (selected == true) {
      _emitPaletteChange(customPalette);
    }
  }

  // Function to open color picker and allow users to select a color
  void _changeColor(int colorIndex) {
    if (!customPalette.isSelected)
      return; // Don't allow change if palette is not selected

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selecciona un color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: customPalette.colors[colorIndex],
              onColorChanged: (Color color) {
                setState(() {
                  customPalette.colors[colorIndex] = color;
                });
                _emitPaletteChange(customPalette);
              },
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          ...palettes.asMap().entries.map((entry) {
            int index = entry.key;
            ColorPalette palette = entry.value;
            return CheckboxListTile(
              value: palette.isSelected,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              onChanged: (bool? selected) {
                _onPredefinedPaletteSelected(index, selected);
              },
              title: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: palette.isSelected
                      ? Colors.grey.withOpacity(0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: palette.colors.map((color) {
                    return Expanded(
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              secondary: const Icon(Icons.palette),
              controlAffinity: ListTileControlAffinity
                  .trailing, // positions the checkbox at the end
            );
          }).toList(),
          CheckboxListTile(
            value: customPalette.isSelected,
            onChanged: _onCustomPaletteSelected,
            title: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: customPalette.isSelected
                    ? Colors.grey.withOpacity(0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: customPalette.colors.asMap().entries.map((entry) {
                  final int colorIndex = entry.key;
                  final color = entry.value;
                  return Expanded(
                    child: InkWell(
                      onTap: () => _changeColor(colorIndex),
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            secondary: const Icon(Icons.palette),
            controlAffinity: ListTileControlAffinity.trailing,
          ),
        ]),
      ),
    );
  }
}
