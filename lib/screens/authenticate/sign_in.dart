import 'package:flutter/material.dart';
import 'package:baby_tracker/screens/services/auth.dart';


class SignIn extends StatefulWidget {
  //const SignIn({Key? key}) : super(key: key);
  final Function toggleView;
  SignIn({ required this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  //text field stage
  String email = '';
  String password = '';
  String error = '';

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: AppBar(
        backgroundColor: Colors.yellow[400],
        elevation:0.0,
        title: Text('Sign in to baby tracker'),
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person),
            label: Text('Register'),
            onPressed: () {
              widget.toggleView();
            }
          )
        ]
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
              validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  setState(() => email = val);
                }
              ),
              SizedBox(height: 20.0),
              TextFormField(
                  obscureText: true,
                  validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                  onChanged: (val) {
                    setState(() => password = val);
              }
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                child: Text('Sign in'),
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all(Colors.pink[400]),
                  textStyle: MaterialStateProperty.all(
                    TextStyle(color: Colors.white))),
                    onPressed:() async {
                      if (_formKey.currentState!.validate())
                      {
                        dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                        if(result == null)
                        {
                          setState(() => error = 'could not sign in with those credentials');
                        }
                      }
                    },
              ),
              SizedBox(height:12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              )

            ],
          ),
        ),
      ),
    );
  }
}
