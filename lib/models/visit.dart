class DocumentItem {
  final String id;
  final String name;
  final String url;
  final String type;
  final String mimeType;
  final int size;
  final DateTime? createdAt;

  DocumentItem({
    required this.id,
    required this.name,
    required this.url,
    required this.type,
    this.mimeType = 'application/octet-stream',
    this.size = 0,
    this.createdAt,
  });

  factory DocumentItem.fromJson(Map<String, dynamic> json) => DocumentItem(
    id: json['_id']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
    url: json['url']?.toString() ?? '',
    type: json['type']?.toString() ?? 'document',
    mimeType: json['mimeType']?.toString() ?? 'application/octet-stream',
    size: (json['size'] as num?)?.toInt() ?? 0,
    createdAt: json['createdAt'] == null ? null : DateTime.tryParse(json['createdAt'].toString()),
  );
}

class FactoryLocation {
  final String id;
  String name;
  String status;
  Map<String, String> answers;
  List<DocumentItem> documents;

  FactoryLocation({
    required this.id,
    required this.name,
    this.status = 'pendente',
    Map<String, String>? answers,
    List<DocumentItem>? documents,
  }) : answers = answers ?? {}, documents = documents ?? [];

  factory FactoryLocation.fromJson(Map<String, dynamic> json) {
    final rawAnswers = json['answers'];
    final answersJson = rawAnswers is Map ? rawAnswers : <dynamic, dynamic>{};
    return FactoryLocation(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pendente',
      answers: answersJson.map((k, v) => MapEntry(k.toString(), v.toString())),
      documents: (json['documents'] is List)
          ? (json['documents'] as List).map((e) => DocumentItem.fromJson(Map<String, dynamic>.from(e as Map))).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'status': status,
    'answers': answers,
  };
}

class Visit {
  final String id;
  int visitId;
  String factoryName;
  String factoryAddress;
  String factoryContact;
  String status;
  List<FactoryLocation> locations;

  Visit({
    required this.id,
    required this.visitId,
    required this.factoryName,
    this.factoryAddress = '',
    this.factoryContact = '',
    this.status = 'agendada',
    List<FactoryLocation>? locations,
  }) : locations = locations ?? [];

  factory Visit.fromJson(Map<String, dynamic> json) => Visit(
    id: json['_id']?.toString() ?? '',
    visitId: (json['visitId'] as num?)?.toInt() ?? 0,
    factoryName: json['factoryName']?.toString() ?? '',
    factoryAddress: json['factoryAddress']?.toString() ?? '',
    factoryContact: json['factoryContact']?.toString() ?? '',
    status: json['status']?.toString() ?? 'agendada',
    locations: (json['locations'] is List)
        ? (json['locations'] as List).map((e) => FactoryLocation.fromJson(Map<String, dynamic>.from(e as Map))).toList()
        : [],
  );

  Map<String, dynamic> toJson() => {
    'factoryName': factoryName,
    'factoryAddress': factoryAddress,
    'factoryContact': factoryContact,
  };

  bool get allLocationsDone => locations.isNotEmpty && locations.every((l) => l.status == 'concluido');
}
