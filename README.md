# Visitas Técnicas

Aplicativo Flutter para registro de visitas técnicas em fábricas, integrado a uma API REST em Node.js + TypeScript + Express e MongoDB.

## Estrutura

- `lib/`: aplicativo Flutter/Dart
- `visitas-server/`: API REST Node.js/TypeScript

## 1. API

```bash
cd visitas-server
npm install
copy .env.example .env
npm run dev
```

No `.env`, configure o MongoDB. A API fica em `http://localhost:3000`.

Teste: `GET http://localhost:3000/api/health`.

## 2. Flutter

```bash
flutter pub get
flutter run
```

No emulador Android, o app usa `http://10.0.2.2:3000/api`.

Para celular físico, rode:

```bash
flutter run --dart-define=API_BASE_URL=http://IP_DO_PC:3000/api
```

O celular e o computador precisam estar na mesma rede e o firewall do Windows deve permitir a porta 3000.
