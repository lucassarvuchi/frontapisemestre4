import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_config.dart';
import '../models/visit.dart';

class ApiService {
  static String _cachedToken = '';

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _cachedToken = prefs.getString('token') ?? '';
  }

  static Future<String?> getToken() async {
    if (_cachedToken.isNotEmpty) return _cachedToken;
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Map<String, String> _headers({bool auth = false, bool multipart = false}) {
    final h = <String, String>{};
    if (!multipart) h['Content-Type'] = 'application/json';
    if (auth && _cachedToken.isNotEmpty) h['Authorization'] = 'Bearer $_cachedToken';
    return h;
  }

  static dynamic _json(http.Response res) {
    if (res.body.isEmpty) return {};
    try { return jsonDecode(res.body); } catch (_) { return {}; }
  }

  static Never _throw(http.Response res, [String fallback = 'Erro na API']) {
    final data = _json(res);
    throw Exception(data is Map && data['message'] != null ? data['message'].toString() : fallback);
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await http.post(Uri.parse('${ApiConfig.baseUrl}/auth/login'), headers: _headers(), body: jsonEncode({'email': email, 'password': password}));
    if (res.statusCode != 200) _throw(res, 'Erro ao fazer login');
    final data = Map<String, dynamic>.from(_json(res));
    _cachedToken = data['token'].toString();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', _cachedToken);
    return data;
  }

  static Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final res = await http.post(Uri.parse('${ApiConfig.baseUrl}/auth/register'), headers: _headers(), body: jsonEncode({'name': name, 'email': email, 'password': password}));
    if (res.statusCode != 201) _throw(res, 'Erro ao cadastrar usuário');
    final data = Map<String, dynamic>.from(_json(res));
    _cachedToken = data['token'].toString();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', _cachedToken);
    return data;
  }

  static Future<Map<String, dynamic>> me() async {
    final res = await http.get(Uri.parse('${ApiConfig.baseUrl}/auth/me'), headers: _headers(auth: true));
    if (res.statusCode != 200) _throw(res, 'Sessão inválida');
    return Map<String, dynamic>.from(_json(res));
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    _cachedToken = '';
  }

  static Future<List<Visit>> getVisits({String? search}) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/visits').replace(queryParameters: search?.trim().isNotEmpty == true ? {'search': search!.trim()} : null);
    final res = await http.get(uri, headers: _headers(auth: true));
    if (res.statusCode != 200) _throw(res, 'Erro ao carregar visitas');
    return (_json(res) as List).map((e) => Visit.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  static Future<Visit> getVisit(String id) async {
    final res = await http.get(Uri.parse('${ApiConfig.baseUrl}/visits/$id'), headers: _headers(auth: true));
    if (res.statusCode != 200) _throw(res, 'Erro ao carregar visita');
    return Visit.fromJson(Map<String, dynamic>.from(_json(res)));
  }

  static Future<Visit> createVisit(Visit visit) async {
    final res = await http.post(Uri.parse('${ApiConfig.baseUrl}/visits'), headers: _headers(auth: true), body: jsonEncode(visit.toJson()));
    if (res.statusCode != 201) _throw(res, 'Erro ao criar visita');
    return Visit.fromJson(Map<String, dynamic>.from(_json(res)));
  }

  static Future<Visit> updateVisit(String id, Visit visit) async {
    final res = await http.put(Uri.parse('${ApiConfig.baseUrl}/visits/$id'), headers: _headers(auth: true), body: jsonEncode(visit.toJson()));
    if (res.statusCode != 200) _throw(res, 'Erro ao salvar visita');
    return Visit.fromJson(Map<String, dynamic>.from(_json(res)));
  }

  static Future<FactoryLocation> addLocation(String visitId, String name) async {
    final res = await http.post(Uri.parse('${ApiConfig.baseUrl}/visits/$visitId/locations'), headers: _headers(auth: true), body: jsonEncode({'name': name}));
    if (res.statusCode != 201) _throw(res, 'Erro ao adicionar local');
    return FactoryLocation.fromJson(Map<String, dynamic>.from(_json(res)));
  }

  static Future<FactoryLocation> updateLocation(String visitId, FactoryLocation loc) async {
    final res = await http.put(Uri.parse('${ApiConfig.baseUrl}/visits/$visitId/locations/${loc.id}'), headers: _headers(auth: true), body: jsonEncode(loc.toJson()));
    if (res.statusCode != 200) _throw(res, 'Erro ao salvar local');
    return FactoryLocation.fromJson(Map<String, dynamic>.from(_json(res)));
  }

  static Future<void> deleteLocation(String visitId, String locId) async {
    final res = await http.delete(Uri.parse('${ApiConfig.baseUrl}/visits/$visitId/locations/$locId'), headers: _headers(auth: true));
    if (res.statusCode != 200) _throw(res, 'Erro ao excluir local');
  }

  static Future<DocumentItem> uploadDocument(String visitId, String locId, String filePath, String type) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/visits/$visitId/locations/$locId/documents');
    final req = http.MultipartRequest('POST', uri);
    req.headers.addAll(_headers(auth: true, multipart: true));
    req.fields['type'] = type;
    req.files.add(await http.MultipartFile.fromPath('file', filePath));
    final response = await req.send();
    final res = await http.Response.fromStream(response);
    if (res.statusCode != 201) _throw(res, 'Erro ao enviar arquivo');
    return DocumentItem.fromJson(Map<String, dynamic>.from(_json(res)));
  }

  static Future<void> deleteDocument(String visitId, String locId, String docId) async {
    final res = await http.delete(Uri.parse('${ApiConfig.baseUrl}/visits/$visitId/locations/$locId/documents/$docId'), headers: _headers(auth: true));
    if (res.statusCode != 200) _throw(res, 'Erro ao excluir anexo');
  }

  static Future<String> downloadFile(String url, String destination) async {
    final res = await http.get(Uri.parse(url), headers: _headers(auth: true));
    if (res.statusCode != 200) _throw(res, 'Erro ao baixar arquivo');
    await File(destination).writeAsBytes(res.bodyBytes);
    return destination;
  }
}
