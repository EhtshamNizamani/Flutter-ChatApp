class FormatError {
  String finalError(String message) {
    int indx = 0;

    for (int i = 0; i < message.length; i++) {
      if (message[i] == ']') {
        indx = i + 2;
      }
    }
    String newmsg = '';

    for (int i = indx; i < message.length; i++) {
      newmsg += message[i];
    }
    return newmsg;
  }
}
