import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/visit_provider.dart';
import 'screens/login_screen.dart';
import 'screens/visit_list_screen.dart';
import 'services/api_service.dart';

Future<void> main() async { WidgetsFlutterBinding.ensureInitialized(); await ApiService.init(); runApp(const MyApp()); }
class MyApp extends StatelessWidget { const MyApp({super.key}); @override Widget build(BuildContext context)=>MultiProvider(providers:[ChangeNotifierProvider(create:(_)=>VisitProvider())],child:MaterialApp(title:'Visitas Técnicas',debugShowCheckedModeBanner:false,theme:ThemeData(colorScheme:ColorScheme.fromSeed(seedColor:const Color(0xFF1976D2)),useMaterial3:true,inputDecorationTheme:const InputDecorationTheme(border:OutlineInputBorder()),scaffoldBackgroundColor:Color(0xFFF6F8FA)),home:FutureBuilder<String?>(future:ApiService.getToken(),builder:(_,s){if(s.connectionState==ConnectionState.waiting)return const Scaffold(body:Center(child:CircularProgressIndicator()));return s.data?.isNotEmpty==true?const VisitsListScreen():const LoginScreen();}))); }
