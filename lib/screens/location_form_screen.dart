import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/questions.dart';
import '../models/visit.dart';
import '../services/api_service.dart';

class LocationFormScreen extends StatefulWidget {
  final String visitId;
  final FactoryLocation location;

  const LocationFormScreen({
    super.key,
    required this.visitId,
    required this.location,
  });

  @override
  State<LocationFormScreen> createState() => _LocationFormScreenState();
}

class _LocationFormScreenState extends State<LocationFormScreen> {
  late FactoryLocation _loc;
  final Map<String, String> _answers = {};
  bool _saving = false;
  bool _uploading = false;
  int _selectedIndex = 0;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loc = widget.location;
    _answers.addAll(_loc.answers);
  }

  Future<void> _save() async {
    setState(() => _saving = true);

    final allQuestions = [...formQuestions, ...structureQuestions];
    final allAnswered = allQuestions.every(
          (question) => _answers[question.id]?.isNotEmpty == true,
    );

    _loc.answers = Map<String, String>.from(_answers);
    _loc.status = allAnswered ? 'concluido' : 'pendente';

    try {
      _loc = await ApiService.updateLocation(widget.visitId, _loc);
      if (!mounted) return;
      Navigator.pop(context, _loc);
    } catch (e) {
      if (mounted) {
        _snack(e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  Future<void> _pickPhoto({bool camera = false}) async {
    final img = await _picker.pickImage(
      source: camera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 85,
    );

    if (img != null) {
      await _upload(img.path, 'photo');
    }
  }

  Future<void> _pickDocument() async {
    final result = await FilePicker.platform.pickFiles(withData: false);
    final path = result?.files.single.path;

    if (path != null) {
      await _upload(path, 'document');
    }
  }

  Future<void> _upload(String path, String type) async {
    setState(() => _uploading = true);

    try {
      final doc = await ApiService.uploadDocument(
        widget.visitId,
        _loc.id,
        path,
        type,
      );

      if (!mounted) return;
      setState(() => _loc.documents.add(doc));
      _snack('Anexo salvo no MongoDB.');
    } catch (e) {
      if (mounted) {
        _snack(e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) {
        setState(() => _uploading = false);
      }
    }
  }

  Future<void> _deleteDoc(DocumentItem doc) async {
    try {
      await ApiService.deleteDocument(widget.visitId, _loc.id, doc.id);
      if (!mounted) return;
      setState(() {
        _loc.documents.removeWhere((item) => item.id == doc.id);
      });
    } catch (e) {
      if (mounted) {
        _snack(e.toString().replaceFirst('Exception: ', ''));
      }
    }
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_loc.name)),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _questionList(formQuestions),
          _structures(),
          _attachments(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saving || _uploading ? null : _save,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _saving
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text('Salvar formulário'),
                ),
              ),
            ),
            BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) => setState(() => _selectedIndex = index),
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.assignment),
                  label: 'Formulário',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.domain),
                  label: 'Estruturas',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.attach_file),
                  label: 'Anexos',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _structures() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...structureQuestions.asMap().entries.map((entry) {
          final index = entry.key;
          final question = entry.value;
          return _questionCard(index + 1, question);
        }),
        Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              initialValue: _answers[structureCommentsId] ?? '',
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Comentários sobre estruturas',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _answers[structureCommentsId] = value;
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _questionList(List<Question> questions) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...questions.asMap().entries.map((entry) {
          final index = entry.key;
          final question = entry.value;
          return _questionCard(index + 1, question);
        }),
      ],
    );
  }

  Widget _questionCard(int number, Question question) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$number. ${question.text}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...question.options.map(
                  (option) => RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: _answers[question.id],
                dense: true,
                contentPadding: EdgeInsets.zero,
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _answers[question.id] = value);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _attachments() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: _uploading ? null : () => _pickPhoto(camera: true),
                icon: const Icon(Icons.photo_camera),
                label: const Text('Câmera'),
              ),
              OutlinedButton.icon(
                onPressed: _uploading ? null : () => _pickPhoto(),
                icon: const Icon(Icons.photo),
                label: const Text('Galeria'),
              ),
              OutlinedButton.icon(
                onPressed: _uploading ? null : _pickDocument,
                icon: const Icon(Icons.upload_file),
                label: const Text('Documento'),
              ),
            ],
          ),
        ),
        if (_uploading) const LinearProgressIndicator(),
        Expanded(
          child: _loc.documents.isEmpty
              ? const Center(child: Text('Nenhum anexo adicionado'))
              : ListView.builder(
            itemCount: _loc.documents.length,
            itemBuilder: (_, index) {
              final document = _loc.documents[index];

              return ListTile(
                leading: Icon(
                  document.type == 'photo'
                      ? Icons.photo
                      : Icons.description,
                  color: Colors.blue,
                ),
                title: Text(
                  document.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  document.type == 'photo' ? 'Foto' : 'Documento',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _deleteDoc(document),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
