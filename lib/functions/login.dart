//  import 'package:firebase_auth/firebase_auth.dart';

// void dsdwew (String email, String password, bool loading,) async{
//          try {
//                 await FirebaseAuth.instance.createUserWithEmailAndPassword(
//                   email: email,
//                   password: password,
//                 );
//                 // set load state to false
//                 setState(() {
//                   loading = false;
//                 });
//                 if (context.mounted) {
//                   Navigator.of(
//                     context,
//                   ).pushNamedAndRemoveUntil('/notes/', (_) => false);
//                 }
//               } on FirebaseAuthException catch (e) {
//                 // set load state to false
//                 setState(() {
//                   loading = false;
//                 });
//                 if (e.code == 'weak-password') {
//                   devtools.log("Weak Password");
//                 } else if (e.code == 'email-already-in-use') {
//                   devtools.log('User already Exist');
//                 } else if (e.code == 'invalid-email') {
//                   devtools.log('Invalid Email format');
//                 }
//               }
//  }
