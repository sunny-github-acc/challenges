import 'package:challenges/components/app_bar.dart';
import 'package:challenges/components/button.dart';
import 'package:challenges/components/column.dart';
import 'package:challenges/components/date.dart';
import 'package:challenges/components/editable_options.dart';
import 'package:challenges/components/editable_text.dart';
import 'package:challenges/components/modal.dart';
import 'package:challenges/components/text.dart';
import 'package:challenges/logic/bloc/collection/collection_bloc.dart';
import 'package:challenges/logic/bloc/collection/collection_events.dart';
import 'package:challenges/logic/bloc/collection/collection_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateChallenge extends StatelessWidget {
  const UpdateChallenge({super.key});

  _save(BuildContext context, String type, dynamic input) async {
    Map<String, dynamic> updatedCollection = {
      type: input,
      'createdAt': DateTime.now()
    };

    BlocProvider.of<CollectionBloc>(context).add(
      CollectionEventUpdateCollection(
        collection: updatedCollection,
      ),
    );
  }

  _saveDate(BuildContext context, DateTimeRange input) async {
    Map<String, dynamic> updatedCollection = {
      'startDate': input.start,
      'endDate': input.end,
      'isUnlimited': false
    };

    BlocProvider.of<CollectionBloc>(context).add(
      CollectionEventUpdateCollection(
        collection: updatedCollection,
      ),
    );
  }

  _delete(BuildContext context, String id) async {
    BlocProvider.of<CollectionBloc>(context).add(
      CollectionEventDeleteCollection(
        collectionId: id,
      ),
    );

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: BlocBuilder<CollectionBloc, CollectionState>(
          builder: (context, state) {
            if (state.success != null) {
              SchedulerBinding.instance.addPostFrameCallback(
                (_) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.success!),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              );
            }

            if (state.collection.isEmpty) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            Map<String, dynamic> collection = state.collection;
            dynamic startDateDynamic = collection['startDate'];
            dynamic endDateDynamic = collection['endDate'];
            dynamic startDate = startDateDynamic is Timestamp
                ? startDateDynamic.toDate()
                : startDateDynamic;
            dynamic endDate = endDateDynamic is Timestamp
                ? endDateDynamic.toDate()
                : endDateDynamic;

            if (state.error != null) {
              SchedulerBinding.instance.addPostFrameCallback(
                (_) {
                  Modal.show(
                    context,
                    state.error!.dialogTitle,
                    state.error!.dialogText,
                  );
                },
              );
            }

            return CustomColumn(
              children: [
                const TextCustom(
                  text: 'Title',
                  fontWeight: FontWeight.bold,
                ),
                EditableTextWidget(
                  text: collection['title'],
                  isTextRequired: true,
                  onSave: (input) => _save(context, 'title', input),
                ),
                const TextCustom(
                  text: 'Description',
                  fontWeight: FontWeight.bold,
                ),
                EditableTextWidget(
                  text: collection['description'],
                  onSave: (input) => _save(context, 'description', input),
                ),
                const TextCustom(
                  text: 'Period',
                  fontWeight: FontWeight.bold,
                ),
                if (!collection['isUnlimited'])
                  CustomDateRangePicker(
                    dateRange: DateTimeRange(
                      start: startDate,
                      end: endDate,
                    ),
                    onSelected: (date) {
                      _saveDate(context, date);
                    },
                  )
                else
                  CustomColumn(
                    children: [
                      const TextCustom(text: 'Unlimited'),
                      CustomButton(
                        onPressed: () => _save(context, 'isUnlimited', false),
                        text: 'Set custom period',
                        size: ButtonSize.small,
                        type: ButtonType.primary,
                      )
                    ],
                  ),
                if (!collection['isUnlimited'])
                  CustomButton(
                    onPressed: () => _save(context, 'isUnlimited', true),
                    text: 'Set period to infinite',
                    size: ButtonSize.small,
                    type: ButtonType.primary,
                  ),
                const TextCustom(
                  text: 'Consequence',
                  fontWeight: FontWeight.bold,
                ),
                EditableTextWidget(
                  text: collection['consequence'],
                  onSave: (input) => _save(context, 'consequence', input),
                ),
                const TextCustom(
                  text: 'Visibility',
                  fontWeight: FontWeight.bold,
                ),
                EditableOptionsWidget(
                  option: collection['visibility'],
                  options: const ['Public', 'Private'],
                  onSave: (input) => _save(context, 'visibility', input),
                ),
                BlocBuilder<CollectionBloc, CollectionState>(
                  builder: (context, state) {
                    return CustomButton(
                      onPressed: () => _delete(context, state.collection['id']),
                      text: 'DELETE CHALLENGE FOR EVER',
                      size: ButtonSize.small,
                      type: ButtonType.primary,
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
