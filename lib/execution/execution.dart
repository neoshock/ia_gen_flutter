// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

import '../model.dart';
import 'frame.dart';

final Key _elementViewKey = UniqueKey();

const String _viewType = 'dartpad-execution';
final Expando _expando = Expando(_viewType);

bool _viewFactoryInited = false;

void _initViewFactory() {
  if (_viewFactoryInited) return;

  _viewFactoryInited = true;

  ui_web.platformViewRegistry.registerViewFactory(_viewType, _iFrameFactory);
}

html.Element _iFrameFactory(int viewId) {
  // 'allow-popups' allows plugins like url_launcher to open popups.
  final frame = html.IFrameElement()
    ..sandbox!.add('allow-scripts')
    ..sandbox!.add('allow-popups')
    ..src = 'frame.html'
    ..style.border = 'none'
    ..style.width = '100%'
    ..style.height = '100%';

  final executionService = ExecutionServiceImpl(frame);

  _expando[frame] = executionService;

  return frame;
}

class ExecutionWidget extends StatefulWidget {
  final AppServices appServices;
  final String selectedPreviewMode; // Agrega esto
  final bool ignorePointer;

  ExecutionWidget({
    required this.appServices,
    this.ignorePointer = false,
    this.selectedPreviewMode = '',
    super.key,
  }) {
    _initViewFactory();
  }

  @override
  State<ExecutionWidget> createState() => _ExecutionWidgetState();
}

class _ExecutionWidgetState extends State<ExecutionWidget> {
  String selectedPreviewMode = 'iPhone 12';

  List<Widget> buildIPhone12Frame() {
    return [
      Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(45),
          border: Border.all(color: Colors.black, width: 9),
        ),
      ),
      Positioned(
        top: 0,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
            color: Colors.black,
          ),
          width: MediaQuery.of(context).size.width * 0.1,
          height: MediaQuery.of(context).size.height * 0.04,
        ),
      ),
    ];
  }

  List<Widget> buildIPhone14Frame() {
    return [
      Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(45),
          border: Border.all(color: Colors.black, width: 9),
        ),
      ),
      Positioned(
        top: 15,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Colors.black,
          ),
          width: MediaQuery.of(context).size.width * 0.07,
          height: MediaQuery.of(context).size.height * 0.04,
        ),
      ),
    ];
  }

  List<Widget> buildPixel5Frame() {
    return [
      Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.black, width: 9),
        ),
      ),
    ];
  }

  List<Widget> buildDefaultFrame() {
    return [
      Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(45),
          border: Border.all(color: Colors.black, width: 9),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    widget.appServices.executionService?.ignorePointer = widget.ignorePointer;
    List<Widget> frameWidgets;
    switch (widget.selectedPreviewMode) {
      case 'iOS - iPhone 12':
        frameWidgets = buildIPhone12Frame();
        break;
      case 'iOS - iPhone 14':
        frameWidgets = buildIPhone14Frame();
        break;
      case 'Android - Pixel 5':
        frameWidgets = buildPixel5Frame();
        break;
      default:
        frameWidgets = buildDefaultFrame(); // o cualquier frame por defecto
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: theme.focusColor),
            borderRadius: BorderRadius.circular(
                widget.selectedPreviewMode == 'Android - Pixel 5' ? 30 : 45),
            color: theme.colorScheme.surface,
          ),
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
                widget.selectedPreviewMode == 'Android - Pixel 5' ? 15 : 30),
            child: HtmlElementView(
              key: _elementViewKey,
              viewType: _viewType,
              onPlatformViewCreated: (int id) {
                final frame =
                    ui_web.platformViewRegistry.getViewById(id) as html.Element;
                final executionService = _expando[frame] as ExecutionService;
                widget.appServices.registerExecutionService(executionService);
              },
            ),
          ),
        ),
        ...frameWidgets
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();

    // Unregister the execution service.
    widget.appServices.registerExecutionService(null);
  }
}
