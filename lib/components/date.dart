// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class CustomDateRangePicker extends StatefulWidget {
  final DateTime customEndDate;
  final bool isStartDate;
  final String selectedDateRangeText;
  final void Function(DateTimeRange selectedDateRange) onSelected;

  CustomDateRangePicker({
    Key? key,
    required this.onSelected,
    DateTime? customEndDate,
    bool? isStartDate,
    String? selectedDateRangeText = 'The end of the challenge:',
  })  : customEndDate =
            customEndDate ?? DateTime.now().add(const Duration(days: 7)),
        isStartDate = isStartDate ?? false,
        selectedDateRangeText =
            selectedDateRangeText ?? 'The end of the challenge:',
        super(key: key);

  @override
  State<CustomDateRangePicker> createState() => _CustomDateRangePickerState();
}

class _CustomDateRangePickerState extends State<CustomDateRangePicker> {
  late DateTimeRange _selectedDateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 7)),
  );
  // late DateTime lastDate = widget.lastDate;
  late String formattedEndDate = '';

  @override
  void didUpdateWidget(covariant CustomDateRangePicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    // if (widget.lastDate != oldWidget.lastDate) {
    //   setState(() {
    //     lastDate = widget.lastDate;
    //   });
    // }
  }

  @override
  void initState() {
    super.initState();
    initAsync();
  }

  Future<void> initAsync() async {
    // if (widget.initialDateRange != null) {
    //   _selectedDateRange = widget.initialDateRange!;
    // } else {
    //   _selectedDateRange = DateTimeRange(
    //     start: DateTime.now(),
    //     end: DateTime.now().add(const Duration(days: 7)),
    //   );
    // }
    // formattedEndDate = _selectedDateRange.end.toString();

    // print(widget.initialDateRange);
    // print(widget.initialDateRange);
    // print(widget.initialDateRange);
    // print(widget.initialDateRange);
    // print(widget.initialDateRange);
    // print(formattedEndDate);
    // print(formattedEndDate);
    // print(formattedEndDate);
    // print(formattedEndDate);
    // print(formattedEndDate);
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
                        initialDate: _selectedDateRange.start,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2222),
                      );

                      if (selectedStartDate != null) {
                        setState(() {
                          _selectedDateRange = DateTimeRange(
                            start: selectedStartDate,
                            end: _selectedDateRange.end,
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
            ElevatedButton(
              onPressed: () async {
                final DateTime? selectedEndDate = await showDatePicker(
                  context: context,
                  initialDate: widget.customEndDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2222),
                );

                print(selectedEndDate);
                print(selectedEndDate);
                print(selectedEndDate);
                print(selectedEndDate);
                print(selectedEndDate);
                if (selectedEndDate != null) {
                  setState(() {
                    _selectedDateRange = DateTimeRange(
                      start: _selectedDateRange.start,
                      end: selectedEndDate.isAfter(_selectedDateRange.start)
                          ? selectedEndDate
                          : _selectedDateRange.start
                              .add(const Duration(hours: 1)),
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
              Text(widget.customEndDate.toString().substring(0, 16)),
              Text(formattedEndDate),
            ],
          ),
        )
      ],
    );
  }
}
