// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

import '../model.dart';
import '../theme.dart';
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

  /// Whether the iframe ignores pointer events, for when gestures need to be
  /// handled by the Flutter app.
  final bool ignorePointer;

  ExecutionWidget({
    required this.appServices,
    this.ignorePointer = false,
    super.key,
  }) {
    _initViewFactory();
  }

  @override
  State<ExecutionWidget> createState() => _ExecutionWidgetState();
}

class _ExecutionWidgetState extends State<ExecutionWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    widget.appServices.executionService?.ignorePointer = widget.ignorePointer;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: theme.focusColor),
            borderRadius: BorderRadius.circular(45),
            color: theme.colorScheme.surface,
          ),
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(45),
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
        // create a iPhone frame
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(45),
            border: Border.all(color: Colors.black, width: 9),
          ),
        ),
        Positioned(
            top: 21,
            child: Container(
              width: 90,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(45),
                color: Colors.transparent,
              ),
            ))
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
