import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localstorage/localstorage.dart';

import '../utils.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isObscureText = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

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
        child: const Text('Registrarse',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
    );
  }

  Widget _buildCustomTextFormField({
    String? Function(String?)? validator,
    TextEditingController? controller,
    String? labelText,
    String? hintText,
    IconData? icon,
  }) {
    return SizedBox(
      width: 330,
      child: TextFormField(
        controller: controller,
        validator: validator,
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

  Future<void> _registerUser() async {
    final LocalStorage storage = LocalStorage('user');
    storage.setItem('username', _usernameController.text);
    storage.setItem('email', _emailController.text);
    storage.setItem('password', _passwordController.text);
    showSuccessDialog(context, 'Usuario registrado correctamente');
    await Future.delayed(const Duration(seconds: 2));
    GoRouter.of(context).go('/login');
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
              Container(
                width: MediaQuery.of(context).size.width / 3,
                height: MediaQuery.of(context).size.height / 1.3,
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
                    const Text('Registrarse',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 30),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildCustomTextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Por favor, ingrese su nombre de usuario';
                                }
                                return null;
                              },
                              controller: _usernameController,
                              labelText: 'Nombre de Usuario',
                              hintText: 'Ingrese su nombre de usuario',
                              icon: Icons.person),
                          const SizedBox(height: 30),
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
                          _buildButtonLogin(_registerUser),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    // ya tienes cuenta? Inicia sesión
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('¿Ya tienes una cuenta?'),
                        TextButton(
                          onPressed: () {
                            GoRouter.of(context).go('/login');
                          },
                          child: const Text('Inicia Sesión'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Image.asset(
                'assets/usability.png',
                width: MediaQuery.of(context).size.width / 3,
                height: MediaQuery.of(context).size.height / 1.5,
                fit: BoxFit.cover,
              ),
            ],
          )),
    ));
  }
}
