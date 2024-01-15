import 'package:challenges/components/button.dart';
import 'package:challenges/components/column.dart';
import 'package:challenges/components/row.dart';
import 'package:flutter/material.dart';

class CustomDateRangePicker extends StatefulWidget {
  final DateTime customStartDate;
  final DateTime customEndDate;
  final bool isStartDate;
  final String startText;
  final String endText;
  final void Function(DateTimeRange selectedDateRange) onSelected;

  CustomDateRangePicker({
    Key? key,
    required this.onSelected,
    DateTime? customEndDate,
    DateTime? customStartDate,
    bool? isStartDate,
    String? startText,
    String? endText,
  })  : customStartDate = customStartDate ?? DateTime.now(),
        customEndDate =
            customEndDate ?? DateTime.now().add(const Duration(days: 7)),
        isStartDate = isStartDate ?? true,
        startText = startText ?? 'The start of the challenge:',
        endText = endText ?? 'The end of the challenge:',
        super(key: key);

  @override
  State<CustomDateRangePicker> createState() => _CustomDateRangePickerState();
}

class _CustomDateRangePickerState extends State<CustomDateRangePicker> {
  late DateTimeRange _dateRange;

  @override
  void didUpdateWidget(covariant CustomDateRangePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    _dateRange = DateTimeRange(
      start: widget.customStartDate,
      end: widget.customEndDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomColumn(children: [
      CustomRow(
        children: [
          widget.isStartDate
              ? CustomColumn(children: [
                  CustomColumn(
                    children: [
                      Text(widget.startText),
                      Text(_dateRange.start.toString().substring(0, 10)),
                    ],
                  ),
                  ElevatedButton(
                    child: const Text('Select Start Date'),
                    onPressed: () async {
                      final DateTime? pickerStart = await showDatePicker(
                        context: context,
                        initialDate: _dateRange.start,
                        firstDate: DateTime(1111),
                        lastDate:
                            _dateRange.end.subtract(const Duration(days: 1)),
                      );

                      if (pickerStart != null) {
                        setState(() {
                          _dateRange = DateTimeRange(
                            start: pickerStart,
                            end: _dateRange.end,
                          );
                        });
                      }
                    },
                  ),
                ])
              : const SizedBox.shrink(),
          CustomColumn(
            children: [
              CustomColumn(
                children: [
                  Text(widget.endText),
                  Text(_dateRange.end.toString().substring(0, 10)),
                ],
              ),
              ElevatedButton(
                child: const Text('Select End Date'),
                onPressed: () async {
                  final DateTime? pickerEnd = await showDatePicker(
                    context: context,
                    initialDate: _dateRange.end,
                    firstDate: _dateRange.start.add(const Duration(days: 1)),
                    lastDate: DateTime(2222),
                  );

                  if (pickerEnd != null) {
                    setState(() {
                      _dateRange = DateTimeRange(
                        start: _dateRange.start,
                        end: pickerEnd,
                      );
                    });
                  }
                },
              ),
            ],
          ),
        ],
      ),
      CustomButton(
          text: 'Save dates',
          size: ButtonSize.small,
          onPressed: () => widget.onSelected(_dateRange))
    ]);
  }
}
