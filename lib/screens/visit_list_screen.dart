import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/visit.dart';
import '../providers/visit_provider.dart';
import '../services/api_service.dart';
import '../widgets/status_badge.dart';
import 'login_screen.dart';
import 'visit_detail_screen.dart';

class VisitsListScreen extends StatefulWidget { const VisitsListScreen({super.key}); @override State<VisitsListScreen> createState()=>_VisitsListScreenState(); }
class _VisitsListScreenState extends State<VisitsListScreen>{
 final _search=TextEditingController(); Timer? _timer;
 @override void initState(){super.initState();WidgetsBinding.instance.addPostFrameCallback((_)=>context.read<VisitProvider>().loadVisits());}
 @override void dispose(){_timer?.cancel();_search.dispose();super.dispose();}
 void _searchVisits(String value){_timer?.cancel();_timer=Timer(const Duration(milliseconds:350),()=>context.read<VisitProvider>().loadVisits(search:value));}
 Future<void> _open(Visit? visit) async {await Navigator.push(context,MaterialPageRoute(builder:(_)=>VisitDetailScreen(visit:visit)));if(mounted)context.read<VisitProvider>().loadVisits(search:_search.text);}
 @override Widget build(BuildContext context){final p=context.watch<VisitProvider>();return Scaffold(
  appBar:AppBar(title:const Text('Minhas visitas'),actions:[IconButton(tooltip:'Sair',icon:const Icon(Icons.logout),onPressed:()async{await ApiService.logout();if(!mounted)return;Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:(_)=>const LoginScreen()),(_)=>false);})]),
  body:Column(children:[Padding(padding:const EdgeInsets.all(16),child:TextField(controller:_search,onChanged:_searchVisits,decoration:InputDecoration(hintText:'Pesquisar por ID ou fábrica',prefixIcon:const Icon(Icons.search),suffixIcon:_search.text.isEmpty?null:IconButton(icon:const Icon(Icons.clear),onPressed:(){_search.clear();setState((){});p.loadVisits();}),border:const OutlineInputBorder()))),
  if(p.error!=null)Padding(padding:const EdgeInsets.symmetric(horizontal:16),child:Text(p.error!,style:const TextStyle(color:Colors.red))),
  Expanded(child:p.loading?const Center(child:CircularProgressIndicator()):p.visits.isEmpty?const Center(child:Text('Nenhuma visita encontrada')):RefreshIndicator(onRefresh:()=>p.loadVisits(search:_search.text),child:ListView.builder(padding:const EdgeInsets.only(bottom:100),itemCount:p.visits.length,itemBuilder:(_,i)=>_VisitTile(visit:p.visits[i],onTap:()=>_open(p.visits[i])))))
 ]),floatingActionButton:FloatingActionButton.extended(onPressed:()=>_open(null),icon:const Icon(Icons.add),label:const Text('Nova visita')));}
}
class _VisitTile extends StatelessWidget{final Visit visit;final VoidCallback onTap;const _VisitTile({required this.visit,required this.onTap});@override Widget build(BuildContext context)=>Card(margin:const EdgeInsets.symmetric(horizontal:16,vertical:6),child:ListTile(onTap:onTap,leading:CircleAvatar(child:Text('${visit.visitId}')),title:Text(visit.factoryName),subtitle:Text('${visit.locations.length} local(is) • Visita #${visit.visitId}'),trailing:StatusBadge(status:visit.status)));}
