import 'package:flutter/cupertino.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF006992),
        elevation:0.0,
        title: Text('Sign in to baby tracker'),
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(
                Icons.person,
              color: Colors.white,
            ),
            label: Text(
                'Register',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              widget.toggleView();
            }
          )
        ]
      ),
      body: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage('assets/tempBabyLogo.png'),
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
            )
        ),
        padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 20.0),
              _buildEmailField(),

              SizedBox(height: 20.0),
              _buildPasswordField(),

              SizedBox(height: 20.0),


              SizedBox(height:12.0),
              _buildSignInButton(),

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

  Widget _buildEmailField() {
    return TextFormField(
        decoration: InputDecoration(
          labelText: 'Email:',
        ),
        validator: (val) => val!.isEmpty ? 'Enter an email' : null,
        onChanged: (val) {
          setState(() => email = val);
        }
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
        decoration: InputDecoration(
          labelText: 'Password:',
        ),
        obscureText: true,
        validator: (val) => val!.length < 6 ? 'Enter a password' : null,
        onChanged: (val) {
          setState(() => password = val);
        }
    );
  }


  Widget _buildSignInButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(80, 50, 80, 0),
      child: ElevatedButton(
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
    );
  }

}
