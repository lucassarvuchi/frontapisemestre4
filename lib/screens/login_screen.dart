import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'register_screen.dart';
import 'visit_list_screen.dart';

class LoginScreen extends StatefulWidget { const LoginScreen({super.key});
  @override State<LoginScreen> createState() => _LoginScreenState(); }

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController(); final _password = TextEditingController(); bool _loading=false; String? _error;
  @override void dispose(){_email.dispose();_password.dispose();super.dispose();}
  Future<void> _login() async {
    if(_email.text.trim().isEmpty || _password.text.isEmpty){setState(()=>_error='Informe e-mail e senha.');return;}
    setState(() { _loading = true; _error = null; });
    try { await ApiService.login(_email.text.trim(), _password.text); if(!mounted)return; Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>const VisitsListScreen())); }
    catch(e){if(mounted)setState(()=>_error=e.toString().replaceFirst('Exception: ',''));}
    finally{if(mounted)setState(()=>_loading=false);}
  }
  @override Widget build(BuildContext context)=>Scaffold(body:Center(child:SingleChildScrollView(padding:const EdgeInsets.all(24),child:ConstrainedBox(constraints:const BoxConstraints(maxWidth:400),child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
    const Icon(Icons.factory,size:64,color:Colors.blue),const SizedBox(height:12),
    const Text('Visitas Técnicas',textAlign:TextAlign.center,style:TextStyle(fontSize:28,fontWeight:FontWeight.bold)),
    const SizedBox(height:6),const Text('Gestão de visitas em campo',textAlign:TextAlign.center),const SizedBox(height:32),
    TextField(controller:_email,keyboardType:TextInputType.emailAddress,decoration:const InputDecoration(labelText:'E-mail',prefixIcon:Icon(Icons.email_outlined),border:OutlineInputBorder())),
    const SizedBox(height:16),TextField(controller:_password,obscureText:true,decoration:const InputDecoration(labelText:'Senha',prefixIcon:Icon(Icons.lock_outline),border:OutlineInputBorder())),
    if(_error!=null)Padding(padding:const EdgeInsets.only(top:12),child:Text(_error!,style:const TextStyle(color:Colors.red))),
    const SizedBox(height:24),ElevatedButton(onPressed:_loading?null:_login,style:ElevatedButton.styleFrom(padding:const EdgeInsets.symmetric(vertical:16)),child:_loading?const SizedBox(height:20,width:20,child:CircularProgressIndicator(strokeWidth:2)):const Text('Entrar')),
    TextButton(onPressed:_loading?null:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const RegisterScreen())),child:const Text('Criar uma conta')),
  ])))));
}
