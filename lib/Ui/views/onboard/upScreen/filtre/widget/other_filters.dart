import 'package:evry_app/product/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class OtherFilters extends StatelessWidget {
  final bool otherFilter1Selected;
  final bool otherFilter2Selected;
  final bool otherFilter3Selected;
  final bool otherFilter4Selected;
  final void Function(String, bool?) onFilterChanged;

  const OtherFilters({
    required this.otherFilter1Selected,
    required this.otherFilter2Selected,
    required this.otherFilter3Selected,
    required this.otherFilter4Selected,
    required this.onFilterChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilterOption(
          title: 'Uygun Soketler',
          isSelected: otherFilter1Selected,
          onChanged: (value) {
            onFilterChanged('Uygun Soketler', value);
          },
        ),
        FilterOption(
          title: 'Ultra Hızlı (HPC) İstasyonlar',
          isSelected: otherFilter2Selected,
          onChanged: (value) {
            onFilterChanged('Ultra Hızlı (HPC) İstasyonlar', value);
          },
        ),
        FilterOption(
          title: 'Yüksek Hızlı (DC) İstasyonlar',
          isSelected: otherFilter3Selected,
          onChanged: (value) {
            onFilterChanged('Yüksek Hızlı (DC) İstasyonlar', value);
          },
        ),
        FilterOption(
          title: 'Halka Açık İstasyonlar',
          isSelected: otherFilter4Selected,
          onChanged: (value) {
            onFilterChanged('Halka Açık İstasyonlar', value);
          },
        ),
      ],
    );
  }
}

class FilterOption extends StatelessWidget {
  final String title;
  final bool isSelected;
  final ValueChanged<bool?> onChanged;

  const FilterOption({
    required this.title,
    required this.isSelected,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!isSelected);
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
          border: Border.all(
            color: Colors.grey[300]!,
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              width: context.dynamicWidth(0.08),
              height: context.dynamicHeight(0.05),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.red : Colors.transparent,
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 2.0,
                ),
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
