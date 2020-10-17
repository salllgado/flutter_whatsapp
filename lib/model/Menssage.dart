class Menssage {
  String _userId;
  String _menssage;
  String _urlImage;

  // Define o tipo da mensagem
  String _menssageType;

  Menssage(this._userId, this._menssage, this._urlImage, this._menssageType);

  set(String userId, String menssage, String urlImage, String menssageType) {
    this._userId = userId;
    this._menssage = menssage;
    this._urlImage = urlImage;
    this._menssageType = menssageType;
  }

  String get userId => _userId;
  String get menssage => _menssage;
  String get urlImage => _urlImage;
  String get messageType => _menssageType;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "idUsuario": this._userId,
      "mensagem": this._menssage,
      "urlImagem": this._urlImage,
      "tipoMensagem": this._menssageType,
    };
    return map;
  }
}
