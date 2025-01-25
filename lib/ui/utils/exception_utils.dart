abstract final class ExceptionUtils {
  static String? getText(Exception? exception) {
    if (exception == null) return null;
    //todo
    return exception.toString();
  }
}