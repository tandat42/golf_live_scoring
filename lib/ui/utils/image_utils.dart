abstract final class ImageUtils {
  static String? getFlagUrl(String? countryCode) {
    if (countryCode == null) return null;
    return 'https://flagsapi.com/${countryCode.toUpperCase()}/flat/64.png';
  }
}
