import 'package:evry_app/product/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class FilterCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final ValueChanged<bool?> onChanged;

  const FilterCard({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.dynamicHeight(0.15),
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(
            color: Colors.grey[300]!,
            width: 2.0,
          ),
        ),
        color: Colors.white,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Icon(icon, color: Colors.redAccent),
            ),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                onChanged(!isSelected);
              },
              child: Container(
                width: context.dynamicWidth(0.08),
                height: context.dynamicHeight(0.08),
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
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
            ),
          ],
        ),
      ),
    );
  }
}
