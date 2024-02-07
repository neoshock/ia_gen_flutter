// Copyright 2023 the Dart project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

// This file has been automatically generated - please do not edit it manually.

import 'package:collection/collection.dart';

class Sample {
  final String category;
  final String name;
  final String id;
  final String source;

  Sample({
    required this.category,
    required this.name,
    required this.id,
    required this.source,
  });

  bool get isDart => category == 'Dart';

  @override
  String toString() => '[$category] $name ($id)';
}

class Samples {
  static final List<Sample> all = [
    _fibonacci,
    _helloWorld,
    _counter,
    _sunflower,
  ];

  static final Map<String, List<Sample>> categories = {
    'Flutter': [
      _counter,
      _sunflower,
    ],
  };

  static Sample? getById(String? id) => all.firstWhereOrNull((s) => s.id == id);

  static String getDefault({required String type}) => _defaults[type]!;
}

Map<String, String> _defaults = {
  'dart': r'''
void main() {
  for (int i = 0; i < 10; i++) {
    print('hello ${i + 1}');
  }
}
''',
  'flutter': r'''
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text('Hello, World!'),
        ),
      ),
    );
  }
}
''',
};

final _fibonacci = Sample(
  category: 'Dart',
  name: 'Fibonacci',
  id: 'fibonacci',
  source: r'''
// Copyright 2015 the Dart project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

void main() {
  const i = 20;

  print('fibonacci($i) = ${fibonacci(i)}');
}

/// Computes the nth Fibonacci number.
int fibonacci(int n) {
  return n < 2 ? n : (fibonacci(n - 1) + fibonacci(n - 2));
}
''',
);

final _helloWorld = Sample(
  category: 'Dart',
  name: 'Hello world',
  id: 'hello-world',
  source: r'''
// Copyright 2015 the Dart project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

void main() {
  for (var i = 0; i < 10; i++) {
    print('hello ${i + 1}');
  }
}
''',
);

final _counter = Sample(
  category: 'Flutter',
  name: 'Login',
  id: 'login',
  source: r'''
    import 'package:flutter/material.dart';

    void main() {
      runApp(const MyApp());
    }

    class MyApp extends StatelessWidget {
      const MyApp({Key? key}) : super(key: key);

      @override
      Widget build(BuildContext context) {
        return const MaterialApp(
          home: MainLogin(),
        );
      }
    }

    class MainLogin extends StatelessWidget {
      const MainLogin({Key? key}) : super(key: key);

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          body: Stack(
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            'https://i.pinimg.com/originals/c2/47/e9/c247e913a0214313045a8a5c39f8522b.jpg'))),
              ),
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const CircleAvatar(
                        radius: 58.0,
                        child: Text('Travel'),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            hintStyle: TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.black45,
                            hintText: 'Username'),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            filled: true,
                            prefixIcon: Icon(Icons.lock, color: Colors.white),
                            hintStyle: TextStyle(color: Colors.white),
                            fillColor: Colors.black45,
                            hintText: 'Password'),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      FlatButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot your Password?',
                            style: TextStyle(color: Colors.white),
                          )),
                      const SizedBox(
                        height: 15.0,
                      ),
                      RaisedButton(
                        onPressed: () {},
                        color: Colors.redAccent,
                        textColor: Colors.white,
                        child: const Padding(
                            padding: EdgeInsets.all(15.0), child: Text('LOGIN')),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      RaisedButton(
                        onPressed: () {},
                        color: Colors.grey,
                        textColor: Colors.white,
                        child: const Padding(
                            padding: EdgeInsets.all(15.0), child: Text('REGISTER')),
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      const Row(
                        children: <Widget>[
                          Expanded(
                            child: Divider(
                              color: Colors.white,
                              height: 8.0,
                            ),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            'OR',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.white,
                              height: 8.0,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }

    class FlatButton extends StatelessWidget {
      final VoidCallback onPressed;
      final Widget child;

      const FlatButton({Key? key, required this.onPressed, required this.child})
          : super(key: key);

      @override
      Widget build(BuildContext context) {
        return SizedBox(
          height: 50.0,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0))),
            child: child,
          ),
        );
      }
    }

    class RaisedButton extends StatelessWidget {
      final VoidCallback onPressed;
      final Widget child;
      final Color color;
      final Color textColor;

      const RaisedButton(
          {Key? key,
          required this.onPressed,
          required this.child,
          required this.color,
          required this.textColor})
          : super(key: key);

      @override
      Widget build(BuildContext context) {
        return SizedBox(
          height: 50.0,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0))),
            child: child,
          ),
        );
      }
    }
''',
);

final _sunflower = Sample(
  category: 'Flutter',
  name: 'SimpleDashboard',
  id: 'simple-dashboard',
  source: r'''
    import 'package:flutter/material.dart';
    import 'dart:math' as math;

    void main() {
      runApp(const MyApp());
    }

    class MyApp extends StatelessWidget {
      const MyApp({super.key});

      @override
      Widget build(BuildContext context) {
        return const MaterialApp(
          home: Dashboard(),
        );
      }
    }

    class Dashboard extends StatelessWidget {
      const Dashboard({super.key});

      @override
      Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
              title: const Text('Dashboard'),
            ),
            body: const SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CardWidget(
                      title: 'Total Users',
                      value: '100',
                      icon: Icons.people,
                      color: Colors.blue,
                    ),
                    SizedBox(height: 16.0),
                    ChartWidget(),
                    SizedBox(height: 16.0),
                    LineChartWidget(),
                    SizedBox(height: 16.0),
                    CircularProgressWidget(),
                  ],
                ),
              ),
            ));
      }
    }

    class CardWidget extends StatelessWidget {
      final String title;
      final String value;
      final IconData icon;
      final Color color;

      const CardWidget({
        super.key,
        required this.title,
        required this.value,
        required this.icon,
        required this.color,
      });

      @override
      Widget build(BuildContext context) {
        return Card(
          color: color,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  size: 40.0,
                  color: Colors.white,
                ),
                const SizedBox(height: 8.0),
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 18.0),
                ),
                const SizedBox(height: 8.0),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    class ChartWidget extends StatelessWidget {
      const ChartWidget({super.key});

      @override
      Widget build(BuildContext context) {
        return Container(
          height: 240,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Sales Bar Chart',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BarWidget(label: 'Jan', value: 50),
                    BarWidget(label: 'Feb', value: 80),
                    BarWidget(label: 'Mar', value: 120),
                    BarWidget(label: 'Apr', value: 90),
                    BarWidget(label: 'May', value: 110),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    }

    class LineChartWidget extends StatelessWidget {
      const LineChartWidget({super.key});

      @override
      Widget build(BuildContext context) {
        return Container(
          height: 240,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Sales Line Chart',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12.0),
                LineWidget(),
              ],
            ),
          ),
        );
      }
    }

    class BarWidget extends StatelessWidget {
      final String label;
      final double value;

      const BarWidget({super.key, required this.label, required this.value});

      @override
      Widget build(BuildContext context) {
        return Column(
          children: [
            Text(label),
            const SizedBox(height: 8.0),
            Container(
              width: 20.0,
              height: value,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ],
        );
      }
    }

    class LineWidget extends StatelessWidget {
      const LineWidget({super.key});

      @override
      Widget build(BuildContext context) {
        return Container(
          width: double.infinity,
          height: 150.0,
          child: CustomPaint(
            painter: LinePainter(),
          ),
        );
      }
    }

    class LinePainter extends CustomPainter {
      @override
      void paint(Canvas canvas, Size size) {
        final Paint paint = Paint()
          ..color = Colors.green
          ..strokeWidth = 4.0
          ..strokeCap = StrokeCap.round;

        final double startX = 20.0;
        final double endX = size.width - 20.0;
        final double startY = size.height - 20.0;
        final double endY = 20.0;

        canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
      }

      @override
      bool shouldRepaint(CustomPainter oldDelegate) {
        return false;
      }
    }

    class CircularProgressWidget extends StatelessWidget {
      const CircularProgressWidget({Key? key}) : super(key: key);

      @override
      Widget build(BuildContext context) {
        return Container(
          height: 240,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Custom Circular Indicator',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomCircularProgress(),
                    SizedBox(width: 15.0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _LegendItem(color: Colors.blue, text: 'Total'),
                        SizedBox(height: 15.0),
                        _LegendItem(color: Colors.green, text: 'Completed'),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }
    }

    class CustomCircularProgress extends StatelessWidget {
      const CustomCircularProgress({Key? key}) : super(key: key);

      @override
      Widget build(BuildContext context) {
        return SizedBox(
          height: 120.0,
          width: 120.0,
          child: CustomPaint(
            painter: CircularProgressPainter(),
          ),
        );
      }
    }

    class CircularProgressPainter extends CustomPainter {
      @override
      void paint(Canvas canvas, Size size) {
        final Paint paint = Paint()
          ..color = Colors.blue
          ..strokeWidth = 24.0
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

        final double radius = size.width * 0.45;

        canvas.drawCircle(Offset(radius, radius), radius, paint);
        canvas.drawArc(
          Rect.fromCircle(center: Offset(radius, radius), radius: radius),
          math.pi / 2,
          math.pi * 1.5,
          false,
          paint..color = Colors.green,
        );
      }

      @override
      bool shouldRepaint(CustomPainter oldDelegate) {
        return false;
      }
    }

    class _LegendItem extends StatelessWidget {
      final Color color;
      final String text;

      const _LegendItem({Key? key, required this.color, required this.text})
          : super(key: key);

      @override
      Widget build(BuildContext context) {
        return Row(
          children: [
            Container(
              width: 15.0,
              height: 15.0,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            const SizedBox(width: 8.0),
            Text(text),
          ],
        );
      }
    }
''',
);
