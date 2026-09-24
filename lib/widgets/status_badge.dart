import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    String label;
    switch (status) {
      case 'concluida':
      case 'concluido':
        color = Colors.green;
        icon = Icons.check_circle;
        label = 'Concluída';
        break;
      case 'em_andamento':
        color = Colors.orange;
        icon = Icons.play_circle;
        label = 'Em andamento';
        break;
      case 'agendada':
        color = Colors.blue;
        icon = Icons.event;
        label = 'Agendada';
        break;
      default:
        color = Colors.grey;
        icon = Icons.hourglass_empty;
        label = 'Pendente';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
