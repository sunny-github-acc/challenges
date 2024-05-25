import 'dart:async';

import 'package:challenges/services/auth/auth.dart';
import 'package:challenges/services/cloud/cloud.dart';
import 'package:flutter/material.dart';

import 'package:challenges/components/app_bar.dart';
import 'package:challenges/components/container_gradient.dart';
import 'package:challenges/components/text.dart';
import 'package:challenges/components/switch.dart';
import 'package:challenges/components/column.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _Menu();
}

class _Menu extends State<Menu> {
  Map<String, dynamic> switchValues = {
    'isGlobal': false,
    'isCompleted': false,
    'isUnlimited': false,
  };
  Map<String, dynamic> stateDocument = {};
  Map<String, bool> isBlocked = {
    'isGlobal': false,
    'isCompleted': false,
    'isUnlimited': false,
  };
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    initValues(context);
  }

  void initValues(context) async {
    setState(() {
      isLoading = true;
    });

    final user = AuthService().getUser();
    final document = await CloudService().getDocument('users', user['uid']);
    final data = document?.data();

    if (data != null) {
      setState(() {
        switchValues = {
          'isGlobal': data['isGlobal'],
          'isCompleted': data['isCompleted'],
          'isUnlimited': data['isUnlimited'],
        };
        stateDocument = data;
        isLoading = false;
      });
    }
  }

  void setValues() async {
    Map updatedDocument = stateDocument..addAll(switchValues);
    await CloudService().setCollection('users', updatedDocument,
        customDocumentId: updatedDocument['uid']);
  }

  void _debounce(
      Function(String, bool) switchFunction, String key, bool value) {
    if (!isBlocked[key]!) {
      switchFunction(key, value);

      isBlocked[key] = true;

      Timer(const Duration(milliseconds: 500), () {
        setState(() {
          isBlocked[key] = false;
        });
      });
    }
  }

  void toggleSwitch(String key, bool value) {
    Map<String, bool> newValues = Map.from(switchValues)..[key] = value;

    setState(() {
      switchValues = newValues;
    });
    setValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(
          title: 'Menu',
        ),
        body: SingleChildScrollView(
          child: ContainerGradient(
            padding: 8,
            child: CustomColumn(
              children: [
                const TextCustom(text: 'Filter by:'),
                if (isLoading)
                  const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      semanticsLabel: 'Circular progress indicator',
                    ),
                  ),
                if (!isLoading)
                  CustomColumn(
                    children: [
                      SwitchCustom(
                        value: switchValues['isGlobal']!,
                        onChanged: (value) =>
                            _debounce(toggleSwitch, 'isGlobal', value),
                      ),
                      SwitchCustom(
                        value: switchValues['isCompleted']!,
                        onChanged: (value) =>
                            _debounce(toggleSwitch, 'isCompleted', value),
                      ),
                      SwitchCustom(
                        value: switchValues['isUnlimited']!,
                        onChanged: (value) =>
                            _debounce(toggleSwitch, 'isUnlimited', value),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ));
  }
}
