import 'package:flutter/material.dart';
import 'package:baby_tracker/screens/services/auth.dart';



class Register extends StatefulWidget {
  //const Register({Key? key}) : super(key: key);

  // toggleView is used to enable going between sign_in and register screen
  final Function toggleView;
  Register({required this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  //text field stage
  String email = '';
  String password = '';
  String confirmPassword = '';
  String name = '';
  String error = '';

  //uses regex to validate password.  At least 8 char long, 1 upper, 1 lower, and 1 number
  bool validatePassword(String value) {
    String pattern = r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF006992),
        elevation:0.0,
        title: Text('Sign up to baby tracker'),
          actions: <Widget>[
            TextButton.icon(
                icon: Icon(
                    Icons.person,
                    color: Colors.white,
                ),
                label: Text(
                    'Sign in',
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
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              _buildNameField(),

              SizedBox(height: 20.0),
              _buildEmailField(),

              SizedBox(height: 20.0),
              _buildPasswordField(),

              SizedBox(height: 20.0),
              _buildConfirmPassword(),

              _buildRegisterButton(),
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


  Widget _buildNameField() {
    return TextFormField(
        decoration: InputDecoration(
          labelText: 'Name:',
        ),
        validator: (val) => val!.isEmpty ? 'Enter a name' : null,
        onChanged: (val) {
          setState(() => name = val);
        }
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
    return  TextFormField(
        decoration: InputDecoration(
          labelText: 'Password',
          helperText: '8 char long: 1 upper, 1 lower, 1 number',
        ),
        obscureText: true,
        validator: (val) {
          if (!validatePassword(val!)) {
            return 'Enter password that has at least:\n 8 char, 1 upper, 1 lower, 1 number';
          } else
            return null;
        },
        onChanged: (val) {
          setState(() => password = val);
        }
    );
  }

  Widget _buildConfirmPassword() {
    return  TextFormField(
        decoration: InputDecoration(
            labelText: 'Confirm Password'
        ),
        obscureText: true,
        validator: (val) {
          if(password != confirmPassword) {
            return "Password does not match, please try again";
          }else
            return null;
        },
        onChanged: (val) {
          setState(() => confirmPassword = val);
        }
    );
  }


  Widget _buildRegisterButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(80, 50, 80, 0),
      child: ElevatedButton(
        child: Text('Register'),
        style: ButtonStyle(
            backgroundColor:
            MaterialStateProperty.all(Colors.pink[400]),
            textStyle: MaterialStateProperty.all(
                TextStyle(color: Colors.white))),
        onPressed:() async {
          if (_formKey.currentState!.validate())
          {
            dynamic result = await _auth.registerWithEmailAndPassword(email, password, name);
            if(result == null)
            {
              setState(() => error = 'please supply a valid email');
            }
          }
        },
      ),
    );
  }

}
