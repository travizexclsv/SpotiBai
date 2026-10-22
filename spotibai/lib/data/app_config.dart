/// Small switchboard for prototype-wide options.
class AppConfig {
  AppConfig._();

  /// When true, cover art is loaded from picsum.photos (cached with
  /// cached_network_image) and tinted with each album's colour.
  /// When false – or when the device is offline – the app shows its
  /// generated gradient covers instead, so it always looks complete.
  static const bool useNetworkImages = true;
}
