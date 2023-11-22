import 'package:flutter/material.dart';

class CustomDateRangePicker extends StatefulWidget {
  final DateTimeRange? initialDateRange;
  final DateTime? firstDate;
  final DateTime lastDate;
  final void Function(DateTimeRange? selectedDateRange) onSelected;
  final bool isStartDate;
  final String endDateText;
  final String selectedDateRangeText;

  const CustomDateRangePicker({
    Key? key,
    this.initialDateRange,
    this.isStartDate = true,
    this.endDateText = '',
    this.selectedDateRangeText = 'The end of the challenge:',
    this.firstDate,
    required this.lastDate,
    required this.onSelected,
  }) : super(key: key);

  @override
  State<CustomDateRangePicker> createState() => _CustomDateRangePickerState();
}

class _CustomDateRangePickerState extends State<CustomDateRangePicker> {
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    _selectedDateRange = widget.initialDateRange ??
        DateTimeRange(
          start: DateTime.now(),
          end: DateTime.now().add(const Duration(days: 7)),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        widget.isStartDate
            ? Row(
                children: [
                  const Text('Start Date:'),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? selectedStartDate = await showDatePicker(
                        context: context,
                        initialDate:
                            _selectedDateRange?.start ?? DateTime.now(),
                        firstDate: DateTime(1111),
                        lastDate: DateTime(2222),
                      );

                      if (selectedStartDate != null) {
                        setState(() {
                          _selectedDateRange = DateTimeRange(
                            start: selectedStartDate,
                            end: _selectedDateRange?.end ?? selectedStartDate,
                          );
                        });
                      }
                    },
                    child: const Text('Select Start Date'),
                  ),
                ],
              )
            : const SizedBox.shrink(),
        const SizedBox(height: 10),
        Row(
          children: [
            Text(widget.endDateText),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () async {
                final DateTime? selectedEndDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDateRange?.end ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2222),
                );

                if (selectedEndDate != null) {
                  setState(() {
                    _selectedDateRange = DateTimeRange(
                      start: _selectedDateRange?.start ?? DateTime.now(),
                      end: selectedEndDate,
                    );

                    widget.onSelected(_selectedDateRange);
                  });
                }
              },
              child: const Text('Select End Date'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.topLeft,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.selectedDateRangeText),
              Text(_selectedDateRange?.end.toString() ??
                  'No Date Range Selected'),
            ],
          ),
        )
      ],
    );
  }
}
