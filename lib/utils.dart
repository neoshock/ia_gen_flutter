// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: inference_failure_on_function_invocation

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttering_phrases/fluttering_phrases.dart'
    as fluttering_phrases;
import 'package:lottie/lottie.dart';

import 'theme.dart';

String pluralize(String word, int count) {
  return count == 1 ? word : '${word}s';
}

// Función para mostrar un dialog de carga
void showLoadingDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        child: AlertDialog(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Lottie.asset('assets/animations/load_animation.json', width: 150),
              Container(
                margin: const EdgeInsets.only(left: 7),
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 21,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> showSuccessDialog(BuildContext context, String message) async {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.3, // Define el ancho aquí
          height:
              MediaQuery.sizeOf(context).height * 0.45, // Define la altura aquí
          child: AlertDialog(
            backgroundColor: Colors.white, // Color de fondo del AlertDialog
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Lottie.asset(
                  'assets/animations/success_animation.json',
                  width: 180,
                  repeat: false,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 7),
                  child: Text(
                    message,
                    style: const TextStyle(
                      fontSize: 21,
                      color: Colors.grey, // Cambia el color según necesites
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.3, // Define el ancho aquí
          height:
              MediaQuery.sizeOf(context).height * 0.45, // Define la altura aquí
          child: AlertDialog(
            backgroundColor: Colors.white, // Color de fondo del AlertDialog
            content: Column(
              children: <Widget>[
                Lottie.asset(
                  'assets/animations/warning_animation.json',
                  width: 180,
                  repeat: false,
                ),
                SizedBox(
                  child: Text(
                    message,
                    style: const TextStyle(
                      fontSize: 21,
                      color: Colors.grey, // Cambia el color según necesites
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

String correctEncodingIssues(String text) {
  // Mapeo de caracteres erróneos a sus equivalentes correctos
  Map<String, String> replacements = {
    'Ã¡': 'á', 'Ã©': 'é', 'Ã­': 'í', 'Ã³': 'ó', 'Ãº': 'ú',
    'Ã±': 'ñ', 'Ã': 'Á', 'Ã‰': 'É', 'Ã': 'Í', 'Ã“': 'Ó', 'Ãš': 'Ú',
    'Ã‘': 'Ñ', 'Â¿': '¿', 'Â¡': '¡',
    // Agrega más reemplazos según sea necesario
  };

  replacements.forEach((key, value) {
    text = text.replaceAll(key, value);
  });

  return text;
}

String formatIaResponse(String iaResponse) {
  final RegExp exp = RegExp(r'```dart\n([\s\S]*?)\n```');
  final RegExpMatch? match = exp.firstMatch(iaResponse);

  if (match != null) {
    String extractedCode = match.group(1)!;

    // Corregir problemas de codificación
    extractedCode = correctEncodingIssues(extractedCode);

    // Ajustes adicionales de formato si son necesarios
    extractedCode = extractedCode.replaceAllMapped(
        RegExp(r'^', multiLine: true), (match) => '  ');

    return extractedCode;
  } else {
    return '';
  }
}

String titleCase(String phrase) {
  return phrase.substring(0, 1).toUpperCase() + phrase.substring(1);
}

void unimplemented(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Unimplemented: $message')),
  );
}

String generateSnippetName() => fluttering_phrases.generate();

Image dartLogo({double? width}) {
  return Image.asset('assets/dart_logo_128.png',
      width: width ?? defaultIconSize);
}

Image flutterLogo({double? width}) {
  return Image.asset('assets/flutter_logo_192.png',
      width: width ?? defaultIconSize);
}

RelativeRect calculatePopupMenuPosition(
  BuildContext context, {
  bool growUpwards = false,
}) {
  final render = context.findRenderObject() as RenderBox;
  final size = render.size;
  final offset =
      render.localToGlobal(Offset(0, growUpwards ? -size.height : size.height));

  return RelativeRect.fromLTRB(
    offset.dx,
    offset.dy,
    offset.dx + size.width,
    offset.dy + size.height,
  );
}

bool hasFlutterWebMarker(String javaScript) {
  const marker1 = 'window.flutterConfiguration';
  if (javaScript.contains(marker1)) {
    return true;
  }

  // define('dartpad_main', ['dart_sdk', 'flutter_web']
  if (javaScript.contains("define('") && javaScript.contains("'flutter_web'")) {
    return true;
  }

  return false;
}

extension ColorExtension on Color {
  Color get lighter {
    final hsl = HSLColor.fromColor(this);
    return hsl.withLightness((hsl.lightness + 0.1).clamp(0.0, 1.0)).toColor();
  }

  Color get darker {
    final hsl = HSLColor.fromColor(this);
    return hsl.withLightness((hsl.lightness - 0.1).clamp(0.0, 1.0)).toColor();
  }
}

/// Support a stack of status messages.
///
/// Fires a notification when the top-most status changes.
class StatusController {
  final List<Message> messages = [];

  void showToast(
    String toastMessage, {
    Duration duration = const Duration(milliseconds: 1800),
  }) {
    final message = Message._(this, toastMessage);
    messages.add(message);

    // Create in a 'opening' state.
    _recalcStateValue();

    // Transition to a 'showing' state.
    Timer(animationDelay, () {
      _updateMessageState(message, MessageState.showing);
    });

    // Finally, start the 'closing' animation.
    Timer(duration, () => message.close());
  }

  Message showMessage({required String initialText, String? name}) {
    final message = Message._(this, initialText, name: name);
    messages.add(message);
    _recalcStateValue();
    return message;
  }

  final ValueNotifier<MessageStatus> _state =
      ValueNotifier(MessageStatus.empty);

  ValueListenable<MessageStatus> get state => _state;

  Message? getNamedMessage(String name) {
    return messages.firstWhereOrNull((message) {
      return message.name == name && message.state != MessageState.closing;
    });
  }

  void _recalcStateValue() {
    if (messages.isEmpty) {
      _state.value = MessageStatus.empty;
    } else {
      final value = messages.last;
      _state.value = MessageStatus(message: value.message, state: value.state);
    }
  }

  void _close(Message message) {
    _updateMessageState(message, MessageState.closing);

    Timer(animationDelay, () {
      messages.remove(message);
      _recalcStateValue();
    });
  }

  void _updateMessageState(Message message, MessageState state) {
    message._state = state;
    _recalcStateValue();
  }
}

class Message {
  final StatusController _parent;
  final String? name;

  String _message;
  MessageState _state = MessageState.opening;

  Message._(StatusController parent, String message, {this.name})
      : _parent = parent,
        _message = message;

  MessageState get state => _state;

  String get message => _message;

  void updateText(String newMessage) {
    _message = newMessage;
    _parent._recalcStateValue();
  }

  void close() => _parent._close(this);
}

class MessageStatus {
  static final MessageStatus empty =
      MessageStatus(message: '', state: MessageState.closing);

  final String message;
  final MessageState state;

  MessageStatus({required this.message, required this.state});

  @override
  bool operator ==(Object other) {
    if (other is! MessageStatus) return false;
    return message == other.message && state == other.state;
  }

  @override
  int get hashCode => message.hashCode;

  @override
  String toString() => '[$state] $message';
}

enum MessageState {
  opening,
  showing,
  closing;
}
