class Question {
  final String id;
  final String text;
  final List<String> options;

  Question({required this.id, required this.text, required this.options});
}

const List<Question> formQuestions = [
  Question(
    id: "q1",
    text: "O local está limpo e organizado?",
    options: ["Sim", "Não", "Parcialmente"],
  ),
  Question(
    id: "q2",
    text: "Existem sinalizações de segurança adequadas?",
    options: ["Sim", "Não", "Parcialmente"],
  ),
  Question(
    id: "q3",
    text: "Os equipamentos estão em boas condições?",
    options: ["Sim", "Não", "Parcialmente"],
  ),
  Question(
    id: "q4",
    text: "Os colaboradores utilizam EPIs corretamente?",
    options: ["Sim", "Não", "Parcialmente"],
  ),
  Question(
    id: "q5",
    text: "Há extintores e saídas de emergência desobstruídos?",
    options: ["Sim", "Não", "Parcialmente"],
  ),
];
