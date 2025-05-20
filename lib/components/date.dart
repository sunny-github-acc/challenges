import 'package:challenges/components/column.dart';
import 'package:challenges/components/row.dart';
import 'package:challenges/components/text.dart';
import 'package:challenges/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomDateRangePicker extends StatelessWidget {
  final DateTimeRange dateRange;
  final String startText;
  final String endText;
  final void Function(DateTimeRange selectedDateRange) onSelected;

  const CustomDateRangePicker({
    Key? key,
    required this.dateRange,
    required this.onSelected,
    this.startText = 'The start of the challenge:',
    this.endText = 'The end of the challenge:',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomColumn(
      children: [
        CustomColumn(
          spacing: SpacingType.medium,
          children: [
            CustomColumn(
              spacing: SpacingType.small,
              children: [
                CustomRow(
                  spacing: SpacingType.small,
                  children: [
                    CustomText(text: startText),
                    CustomText(
                      text: dateRange.start.toString().substring(0, 10),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorMap['blue'],
                  ),
                  child: CustomText(
                    text: 'Update Start Date',
                    color: colorMap['white'],
                  ),
                  onPressed: () async {
                    final DateTime? pickerStart = await showDatePicker(
                      context: context,
                      initialDate: dateRange.start,
                      firstDate: DateTime(1111),
                      lastDate: dateRange.end.subtract(
                        const Duration(days: 1),
                      ),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: colorMap['blue']!,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (pickerStart != null) {
                      onSelected(
                        DateTimeRange(
                          start: pickerStart,
                          end: dateRange.end,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            CustomColumn(
              spacing: SpacingType.small,
              children: [
                CustomRow(
                  spacing: SpacingType.small,
                  children: [
                    CustomText(text: endText),
                    CustomText(text: dateRange.end.toString().substring(0, 10)),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorMap['blue'],
                  ),
                  child: CustomText(
                    text: 'Update End Date',
                    color: colorMap['white'],
                  ),
                  onPressed: () async {
                    final DateTime? pickerEnd = await showDatePicker(
                      context: context,
                      initialDate: dateRange.end,
                      firstDate: dateRange.start.add(
                        const Duration(days: 1),
                      ),
                      lastDate: DateTime(2222),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: colorMap['blue']!,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (pickerEnd != null) {
                      onSelected(
                        DateTimeRange(
                          start: dateRange.start,
                          end: pickerEnd,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
