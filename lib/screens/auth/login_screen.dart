import 'package:flutter/material.dart';
import 'package:mood_tracker/screens/core/utils/ui_helpers.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscure1 = true;

  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final  auth = context.read<AuthProviders>();
    if(!_formKey.currentState!.validate()) return;
    await auth.signIn(_email.text.trim(), _pass.text);

    if(mounted) {
      if (auth.error != null) {
        showAppSnack(context, message: auth.error!);
      } else {
        showAppSnack(context, message: 'Logged in successfully', success: true);
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProviders>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text('Login',

          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        )
      ),
      body: SingleChildScrollView(
        child:  Padding(padding:  const EdgeInsets.fromLTRB(16, 24, 16, 100),
          child: Form(
            key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  SizedBox(height: 100,),
                  Center(
                    child: const _Header(
                        title: 'Welcome back',

                    ),
                  ),
                  const SizedBox(height: 24,),
               TextFormField(
              validator:  (value) => Validators.email(value),
              controller: _email,
              //focusNode: viewModel.emailFN,
              textInputAction: TextInputAction.next,

              decoration: InputDecoration(

                  labelText: 'Email',
                  labelStyle: const TextStyle(
                    color:  Colors.blue

                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color:Colors.blue, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius:  BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.blue, width: 1.5)
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
              ),
            ),


                  const SizedBox(height: 12,),
                  TextFormField(
                    obscureText: _obscure1,
                    validator:  (value) => Validators.password(value),
                    controller: _pass,
                    //focusNode: viewModel.emailFN,
                    textInputAction: TextInputAction.next,

                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => _obscure1 = !_obscure1),
                          icon: Icon(_obscure1 ? Icons.visibility : Icons.visibility_off),
                        ),

                        labelText: 'Password',
                        labelStyle: const TextStyle(
                            color:  Colors.blue

                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color:Colors.blue, width: 1.5),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.red, width: 1.5),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.red, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius:  BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.blue, width: 1.5)
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
                    ),
                  ),

                  SizedBox(height: 30,),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 20),

                child: SizedBox(
                  width: 350,
                  height: 50,


                  child:  auth.loading
                    ? const Center(
                    child: CircularProgressIndicator(color: Colors.blue,),
                  )
                 : ElevatedButton(
                      onPressed: () {
                        _submit();

                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18
                        ),
                      )
                  ),
                ) ,
              ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(
                          color: Colors.grey,

                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/signup');
                          },
                          child: Text('Sign up',
                            style: TextStyle(
                                color: Colors.blue
                            ),)
                      )
                    ],
                  )
                ],
              )
          ),
        )
      ),
    );
  }
}
class _Header extends StatelessWidget {
  final String title;
  const _Header({required this.title, });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: t.headlineMedium?.copyWith(fontWeight: FontWeight.w700, color: Colors.blue)),
        const SizedBox(height: 6),

      ],
    );
  }
}