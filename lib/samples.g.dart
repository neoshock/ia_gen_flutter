// Copyright 2023 the Dart project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

// This file has been automatically generated - please do not edit it manually.

import 'package:collection/collection.dart';

import 'utils.dart';

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
    _solicitudBecas,
  ];

  static final getSampleSource = {
    'fibonacci': _fibonacci.source,
    'hello-world': _helloWorld.source,
    'login': _counter.source,
    'simple-dashboard': _sunflower.source,
    'scholarship-application-form': _solicitudBecas.source,
  };

  static final Map<String, List<Sample>> categories = {
    'Flutter': [
      _counter,
      _sunflower,
      _solicitudBecas,
    ],
  };

  static Sample? getById(String? id) => all.firstWhereOrNull((s) => s.id == id);

  static String getDefault({required String type}) => _defaults[type]!;
}

Map<String, String> _defaults = {
  'dart': formatIaResponse(""),
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
  name: 'Formulario de Registro',
  id: 'registro-formulario',
  source: r'''
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Media Inspired Registration Form',
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF99a4e7),
          secondary: Color(0xFF6775b2),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blue[800], // Facebook button color
        ),
      ),
      home: const SocialMediaRegistrationForm(),
    );
  }
}

class SocialMediaRegistrationForm extends StatelessWidget {
  const SocialMediaRegistrationForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(height: 100),
            const Text(
              'Registrarse',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            _buildTextField(context, 'Nombres', Icons.person),
            const SizedBox(height: 20),
            _buildTextField(context, 'Correo Electronico', Icons.email),
            const SizedBox(height: 20),
            _buildTextField(context, 'Contraseña', Icons.lock,
                isPassword: true),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  // Registration logic
                },
                child:
                    const Text('Registrarse', style: TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(height: 30),
            // or line
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 1,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text('O', style: TextStyle(fontSize: 16)),
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            TextButton.icon(
              // Use pre-built social icons for ease, such as FontAwesomeIcons when using third-party packages
              icon: const Icon(Icons.facebook, color: Colors.blue),
              label: const Text('Registrarse con Facebook'),
              onPressed: () {
                // Sign up with Facebook logic
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context, String label, IconData icon,
      {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary, width: 2),
        ),
      ),
    );
  }
}
''',
);

final _sunflower = Sample(
  category: 'Flutter',
  name: 'Formulario de Concurso de Fotografía',
  id: 'photography-contest-form',
  source: r'''
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Concurso de Fotografía',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white70,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20.0),
          ),
        ),
        scaffoldBackgroundColor: Colors.white,
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 5,
          margin: const EdgeInsets.all(8),
        ),
      ),
      home: const PhotographyContestForm(),
    );
  }
}

class PhotographyContestForm extends StatefulWidget {
  const PhotographyContestForm({Key? key}) : super(key: key);

  @override
  _PhotographyContestFormState createState() => _PhotographyContestFormState();
}

class _PhotographyContestFormState extends State<PhotographyContestForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _photoUrlController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isPhotoValid = false;

  @override
  void dispose() {
    _nameController.dispose();
    _photoUrlController.dispose();
    super.dispose();
  }

  void _validatePhoto(String value) {
    // Simulate a photo validation
    setState(() {
      _isPhotoValid = Uri.tryParse(value)?.hasAbsolutePath ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registro - Concurso de Fotografía',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre Completo',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, introduce tu nombre completo.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _photoUrlController,
                      decoration: const InputDecoration(
                        labelText: 'URL de la Foto',
                        prefixIcon: Icon(Icons.link),
                      ),
                      onChanged: _validatePhoto,
                      validator: (value) {
                        if (!_isPhotoValid) {
                          return 'Por favor, introduce una URL válida.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Submit the form
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Formulario Enviado'),
                              ),
                            );
                          }
                        },
                        child: const Text('Registrarse'),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // ...Other form fields or widgets
          ],
        ),
      ),
    );
  }
}
''',
);

final _solicitudBecas = Sample(
  category: 'Flutter',
  name: 'Formulario de Solicitud de Becas',
  id: 'scholarship-application-form',
  source: r'''
import 'package:flutter/material.dart';

const Map<String, Color> colorPalette = {
  'primary': Color(0xFFa8e6cf), // Light Green
  'secondary': Color(0xFFdcedc1), // Light Green Accent
  'accent': Color(0xFFffaaa5), // Soft Red
  'background': Color(0xFFffd3b6), // Light Orange
};

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solicitud de Beca',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: colorPalette['primary']!,
          secondary: colorPalette['secondary']!,
          surface: colorPalette['accent']!,
          background: colorPalette['background']!,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
        ),
      ),
      home: const ScholarshipApplicationForm(),
    );
  }
}

class ScholarshipApplicationForm extends StatefulWidget {
  const ScholarshipApplicationForm({Key? key}) : super(key: key);

  @override
  _ScholarshipApplicationFormState createState() => _ScholarshipApplicationFormState();
}

class _ScholarshipApplicationFormState extends State<ScholarshipApplicationForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  final TextEditingController _essayController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isGradeValid(String grade) {
    // Add your validation logic here for grades
    return true; // dummy return
  }

  bool _isEssayValid(String essay) {
    // Add your validation logic here for personal essay
    return true; // dummy return
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario de Solicitud de Beca'),
        backgroundColor: colorPalette['primary'],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre Completo',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu nombre completo.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _gradeController,
                decoration: const InputDecoration(
                  labelText: 'Calificación Promedio',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (!_isGradeValid(value ?? '')) {
                    return 'Introduce una calificación válida.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _essayController,
                decoration: const InputDecoration(
                  labelText: 'Ensayo Personal',
                ),
                maxLines: 5,
                validator: (value) {
                  if (!_isEssayValid(value ?? '')) {
                    return 'Introduce un ensayo válido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              // file bottom
              Row(
                children: [
                  Icon(
                    Icons.attach_file,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Adjuntar Archivo',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              CustomElevatedButton(
                text: 'Enviar',
                color: Theme.of(context).colorScheme.primary,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {}
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _gradeController.dispose();
    _essayController.dispose();
    super.dispose();
  }
}

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const CustomElevatedButton({
    Key? key,
    required this.text,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: color,
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
''',
);
