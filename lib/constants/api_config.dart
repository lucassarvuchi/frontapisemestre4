class ApiConfig {
  // Android Emulator: 10.0.2.2 aponta para o computador host.
  // Em celular físico, troque pelo IP do computador na mesma rede.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000/api',
  );
}
