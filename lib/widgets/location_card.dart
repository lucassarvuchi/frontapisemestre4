import 'package:flutter/material.dart';
import '../models/visit.dart';
import 'status_badge.dart';

class LocationCard extends StatelessWidget {
  final FactoryLocation location;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const LocationCard({
    super.key,
    required this.location,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: const Icon(Icons.domain, color: Colors.blue),
        ),
        title: Text(location.name),
        subtitle: Text(
          '${location.documents.length} anexo(s) • '
              '${location.answers.length} questão(ões) respondida(s)',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            StatusBadge(status: location.status),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') onEdit();
                if (value == 'delete') onDelete();
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('Editar')),
                PopupMenuItem(value: 'delete', child: Text('Excluir')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
