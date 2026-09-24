import 'package:flutter/foundation.dart';
import '../models/visit.dart';
import '../services/api_service.dart';

class VisitProvider extends ChangeNotifier {
  List<Visit> visits = [];
  bool loading = false;
  String? error;

  Future<void> loadVisits({String? search}) async {
    loading = true; error = null; notifyListeners();
    try { visits = await ApiService.getVisits(search: search); }
    catch (e) { error = e.toString().replaceFirst('Exception: ', ''); }
    loading = false; notifyListeners();
  }

  Future<Visit?> createVisit(Visit visit) async {
    try { final created = await ApiService.createVisit(visit); await loadVisits(); return created; }
    catch (e) { error = e.toString().replaceFirst('Exception: ', ''); notifyListeners(); return null; }
  }

  Future<Visit?> updateVisit(Visit visit) async {
    try { final updated = await ApiService.updateVisit(visit.id, visit); await loadVisits(); return updated; }
    catch (e) { error = e.toString().replaceFirst('Exception: ', ''); notifyListeners(); return null; }
  }
}
