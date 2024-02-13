import 'package:flutter/material.dart';

class CustomDropdownButton extends StatelessWidget {
  final List<String> models;
  final String? selectedModel;
  final void Function(String?)? onChanged;

  const CustomDropdownButton(
      {Key? key,
      required this.models,
      required this.onChanged,
      this.selectedModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedModel == null
              ? null
              : models.contains(selectedModel)
                  ? selectedModel
                  : null,
          icon: const Icon(Icons.arrow_drop_down),
          isExpanded: true,
          hint: const Text('Selecciona un país'),
          items: models.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              key: Key(option),
              child: Row(
                children: [
                  Text(option),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
