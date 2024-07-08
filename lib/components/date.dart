import 'package:challenges/components/column.dart';
import 'package:challenges/components/row.dart';
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
        CustomRow(
          children: [
            CustomColumn(
              children: [
                CustomColumn(
                  children: [
                    Text(startText),
                    Text(dateRange.start.toString().substring(0, 10)),
                  ],
                ),
                ElevatedButton(
                  child: const Text('Select Start Date'),
                  onPressed: () async {
                    final DateTime? pickerStart = await showDatePicker(
                      context: context,
                      initialDate: dateRange.start,
                      firstDate: DateTime(1111),
                      lastDate: dateRange.end.subtract(const Duration(days: 1)),
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
              children: [
                CustomColumn(
                  children: [
                    Text(endText),
                    Text(dateRange.end.toString().substring(0, 10)),
                  ],
                ),
                ElevatedButton(
                  child: const Text('Select End Date'),
                  onPressed: () async {
                    final DateTime? pickerEnd = await showDatePicker(
                      context: context,
                      initialDate: dateRange.end,
                      firstDate: dateRange.start.add(const Duration(days: 1)),
                      lastDate: DateTime(2222),
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
