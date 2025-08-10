import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../core/utils/ui_helpers.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();

  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    _confirm.dispose();
    super.dispose();
  }


  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProviders>();
    final ok = await auth.signUp(_email.text.trim(), _pass.text);

    if (!mounted) return;
    if (ok) {
      showAppSnack(context, message: 'Account created! You are logged in.', success: true);
     // Navigator.pop(context);
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      showAppSnack(context, message: auth.error ?? 'Signup failed');
    }
  }


  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProviders>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
          title: const
          Text('Create Account',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),
          ),
        centerTitle: true,

        bottom: auth.loading
          ? const PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: LinearProgressIndicator(minHeight: 4),
        )
            : null,
      ),

      body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
        child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 100,),
                Center(
                  child: const _Header(
                      title:  'Let’s get started',



                  ),
                ),

                const SizedBox(height: 24),

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
                  validator:  (value) => Validators.password(value),
                  controller: _pass,
                  obscureText: _obscure1,
                  //focusNode: viewModel.emailFN,
                  textInputAction: TextInputAction.next,

                  decoration: InputDecoration(

                      labelText: 'Password',
                      labelStyle: const TextStyle(
                          color:  Colors.blue

                      ),

                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _obscure1 = !_obscure1),
                        icon: Icon(_obscure1 ? Icons.visibility : Icons.visibility_off),
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

                const SizedBox(height: 12,),
                TextFormField(
                  validator:  (value) => Validators.confirmPassword(value, _pass.text),
                  controller: _confirm,
                  obscureText: _obscure2,
                  //focusNode: viewModel.emailFN,
                  textInputAction: TextInputAction.next,

                  decoration: InputDecoration(

                      labelText: 'Confirm Password',
                      labelStyle: const TextStyle(
                          color:  Colors.blue

                      ),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _obscure2 = !_obscure2),
                        icon: Icon(_obscure2 ? Icons.visibility : Icons.visibility_off),
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

                    child: ElevatedButton(
                        onPressed:   auth.loading ? null : _submit,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                          ),
                        ),
                        child:  Text(
                         // auth.loading ? 'Please wait…' : 'Sign up',
                          auth.loading ? 'Please wait…' : 'Sign up',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18
                          ),
                        )
                    ),
                  ) ,
                ),


                SizedBox(height: 10,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                        onPressed: (){

                            Navigator.pushReplacementNamed(context, '/login');

                        },
                        child: Text("Log in")
                    )
                  ],
                ),


              ],

            )
        ),
      ),

      ),


    );
  }
}
class _Header extends StatelessWidget {
  final String title;
  const _Header({required this.title,});

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