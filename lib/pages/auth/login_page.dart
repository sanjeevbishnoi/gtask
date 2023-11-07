import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gtask/models/failure.dart';
import 'package:gtask/models/status.dart';
import 'package:gtask/pages/auth/register_page.dart';
import 'package:gtask/pages/home_page.dart';
import 'package:gtask/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _buildForm(context),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildForm(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Login With Email',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: Theme.of(context).textTheme.bodySmall,
                    validator: (value) =>
                        value!.isEmpty ? 'Email is required' : null,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        labelText: 'Email',
                        border: const OutlineInputBorder()),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: TextFormField(
                      obscureText: _isVisible,
                      maxLength: 12,
                      controller: _passwordController,
                      style: Theme.of(context).textTheme.bodySmall,
                      validator: (value) => value!.trim().isEmpty
                          ? 'Please enter password'
                          : null,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        labelText: 'Password',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(_isVisible
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () => setState(() {
                            _isVisible = !_isVisible;
                          }),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.00),
                    child: Text(
                      'Forgot Password?',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  authProvider.status == Status.authenticating
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton(
                          child: Text(
                            'Login',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();

                              try {
                                await authProvider.signIn(
                                    email: _emailController.text,
                                    password: _passwordController.text);
                                if (mounted) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HomePage(),
                                    ),
                                  );
                                }
                              } on Failure catch (e, _) {
                                Fluttertoast.showToast(msg: e.message);
                              }
                            }
                          }),
                  Padding(
                    padding: const EdgeInsets.only(top: 48),
                    child: Center(
                        child: Text(
                      "Don't have an account",
                      style: Theme.of(context).textTheme.bodyMedium,
                    )),
                  ),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Sign Up',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
