import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localstorage/localstorage.dart';

import '../utils.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isObscureText = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Widget _buildTextEmailOrUsername(
      {String? labelText, String? hintText, IconData? icon}) {
    return SizedBox(
      width: 330,
      child: TextFormField(
        controller: _emailController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Por favor, ingrese su correo electrónico';
          }
          // validate @ symbol and period
          if (!value.contains('@') || !value.contains('.')) {
            return 'Por favor, ingrese un correo electrónico válido';
          }
          return null;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          labelText: labelText,
          hintText: hintText,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }

  Widget _buildTextPassword(
      bool isPasswordVisible, Function togglePasswordVisibility,
      {String? labelText, String? hintText, IconData? icon}) {
    return SizedBox(
      width: 330,
      child: TextFormField(
        controller: _passwordController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Por favor, ingrese su contraseña';
          }
          return null;
        },
        obscureText: isPasswordVisible,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          labelText: labelText,
          hintText: hintText,
          prefixIcon: Icon(icon),
          suffixIcon: IconButton(
            icon: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              togglePasswordVisibility();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildButtonLogin(Function()? onPressed) {
    return SizedBox(
      width: 330,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            onPressed!();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Text('Iniciar Sesión',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
    );
  }

  Future<void> _login() async {
    // get the user's email and password from local storage
    final LocalStorage storage = LocalStorage('user');
    showLoadingDialog(context, 'Iniciando sesión');
    await storage.ready;
    final email = storage.getItem('email');
    final password = storage.getItem('password');
    Navigator.pop(context);
    if (_emailController.text == email &&
        _passwordController.text == password) {
      context.go('/home');
    } else {
      showErrorDialog(context, 'Correo electrónico o contraseña incorrectos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network('assets/login_page.png',
                  width: MediaQuery.of(context).size.width / 3),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                height: MediaQuery.of(context).size.height / 1.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Bienvenido a',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    Text('IA GEN FLUTTER',
                        style: TextStyle(
                            fontSize: 36,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 30),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildTextEmailOrUsername(
                              labelText: 'Correo Electrónico',
                              hintText: 'Ingrese su correo electrónico',
                              icon: Icons.email),
                          const SizedBox(height: 30),
                          _buildTextPassword(isObscureText, () {
                            setState(() {
                              isObscureText = !isObscureText;
                            });
                          },
                              labelText: 'Contraseña',
                              hintText: 'Ingrese su contraseña',
                              icon: Icons.lock),
                          const SizedBox(height: 30),
                          _buildButtonLogin(_login),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('¿No tienes una cuenta?'),
                        TextButton(
                          onPressed: () {
                            context.go('/register');
                          },
                          child: const Text('Regístrate'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )),
    ));
  }
}
