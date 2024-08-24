class SocialMediaLink {
  final int? index;
  final String name;
  final String? appUrl;
  final String? webUrl;
  final String? icon;

  SocialMediaLink({
    required this.name,
    this.index,
    this.appUrl,
    this.webUrl,
    this.icon
  });
}