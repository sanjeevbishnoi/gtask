import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gtask/models/failure.dart';
import 'package:gtask/models/status.dart';
import 'package:gtask/pages/components/pick_image.dart';
import 'package:gtask/pages/home_page.dart';
import 'package:gtask/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Uint8List? _file;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
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
    _nameController.dispose();
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
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Sign Up With Email',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  ImagePickerW(
                    onFileSelected: (Uint8List file) {
                      setState(() {
                        _file = file;
                      });
                    },
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextFormField(
                        controller: _nameController,
                        style: Theme.of(context).textTheme.bodySmall,
                        validator: (value) =>
                            value!.isEmpty ? 'Name is required' : null,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            labelText: 'Name',
                            border: const OutlineInputBorder()),
                      )),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextFormField(
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
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      obscureText: _isVisible,
                      controller: _passwordController,
                      maxLength: 12,
                      style: Theme.of(context).textTheme.bodySmall,
                      validator: (value) => value!.length < 6
                          ? 'Password must be greater than 6 charcters'
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
                  authProvider.status == Status.authenticating
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton(
                          child: Text(
                            'Sign Up',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();
                              print(_nameController.text);
                              print(_emailController.text);
                              print(_passwordController.text);

                              try {
                                await authProvider.signUp(
                                  name: _nameController.text,
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  file: _file,
                                );
                                if (mounted) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => const HomePage()),
                                    (Route<dynamic> route) => false,
                                  );
                                }
                              } on Failure catch (e, _) {
                                Fluttertoast.showToast(msg: e.message);
                              }
                            }
                          }),
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Text(
                      'Already Have Account',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Login',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
