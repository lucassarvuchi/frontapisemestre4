import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'visit_list_screen.dart';

class RegisterScreen extends StatefulWidget { const RegisterScreen({super.key}); @override State<RegisterScreen> createState()=>_RegisterScreenState(); }
class _RegisterScreenState extends State<RegisterScreen>{
 final _name=TextEditingController(),_email=TextEditingController(),_password=TextEditingController(),_confirm=TextEditingController(); bool _loading=false; String? _error;
 @override void dispose(){_name.dispose();_email.dispose();_password.dispose();_confirm.dispose();super.dispose();}
 Future<void> _register() async {
  if(_name.text.trim().length<2){setState(()=>_error='Informe seu nome.');return;}
  if(_password.text.length<6){setState(()=>_error='A senha deve ter pelo menos 6 caracteres.');return;}
  if(_password.text!=_confirm.text){setState(()=>_error='As senhas não coincidem.');return;}
  setState(() { _loading = true; _error = null; });
  try{await ApiService.register(_name.text.trim(),_email.text.trim(),_password.text);if(!mounted)return;Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:(_)=>const VisitsListScreen()),(_)=>false);}
  catch(e){if(mounted)setState(()=>_error=e.toString().replaceFirst('Exception: ',''));}
  finally{if(mounted)setState(()=>_loading=false);}
 }
 @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Criar conta')),body:SingleChildScrollView(padding:const EdgeInsets.all(24),child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
  const SizedBox(height:24),const Icon(Icons.person_add_alt_1,size:64,color:Colors.blue),const SizedBox(height:24),
  TextField(controller:_name,decoration:const InputDecoration(labelText:'Nome',prefixIcon:Icon(Icons.person_outline),border:OutlineInputBorder())),const SizedBox(height:16),
  TextField(controller:_email,keyboardType:TextInputType.emailAddress,decoration:const InputDecoration(labelText:'E-mail',prefixIcon:Icon(Icons.email_outlined),border:OutlineInputBorder())),const SizedBox(height:16),
  TextField(controller:_password,obscureText:true,decoration:const InputDecoration(labelText:'Senha',prefixIcon:Icon(Icons.lock_outline),border:OutlineInputBorder())),const SizedBox(height:16),
  TextField(controller:_confirm,obscureText:true,decoration:const InputDecoration(labelText:'Confirmar senha',prefixIcon:Icon(Icons.lock_outline),border:OutlineInputBorder())),
  if(_error!=null)Padding(padding:const EdgeInsets.only(top:12),child:Text(_error!,style:const TextStyle(color:Colors.red))),const SizedBox(height:24),
  ElevatedButton(onPressed:_loading?null:_register,style:ElevatedButton.styleFrom(padding:const EdgeInsets.symmetric(vertical:16)),child:_loading?const SizedBox(height:20,width:20,child:CircularProgressIndicator(strokeWidth:2)):const Text('Cadastrar')),
 ])));
}
