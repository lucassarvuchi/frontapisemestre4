class Question {
  final String id;
  final String text;
  final List<String> options;

  Question({
    required this.id,
    required this.text,
    required this.options,
  });
}

// PERGUNTAS DO FORMULÁRIO
final List<Question> formQuestions = [
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

// PERGUNTAS DE ESTRUTURAS
final List<Question> structureQuestions = [
  Question(
    id: "structure_period",
    text: "Período de medição de Luz",
    options: [
      "Matutino",
      "Vespertino",
      "Noturno",
    ],
  ),
  Question(
    id: "structure_weather",
    text: "Condições meteorológicas",
    options: [
      "Ensolarado",
      "Nublado",
      "Não aplicável",
    ],
  ),
  Question(
    id: "structure_luminosity",
    text: "Situação de Luminosidade",
    options: [
      "Adequado (100% dos pontos acima de 200 lux)",
      "Parcialmente Adequado (pontos acima de 200 lux entre 50% e 99%)",
      "Inadequado (50% dos pontos abaixo de 200 lux)",
    ],
  ),
];

// IDENTIFICADOR DOS COMENTÁRIOS DE ESTRUTURAS
const String structureCommentsId = "structure_comments";