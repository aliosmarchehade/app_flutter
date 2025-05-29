class ValidadorItem {
  static bool ehValido(String texto) {
    return !RegExp(r'^\d+$').hasMatch(texto); //^\d+$ verifica se o texto não é só numeros
  }
}