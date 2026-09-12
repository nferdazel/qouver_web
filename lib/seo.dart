import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Site-wide SEO constants.
const siteName = 'Qouver';
const siteUrl = 'https://qouver.com';
const ogImageUrl = '$siteUrl/assets/og-image.webp';

/// Builds the per-page `<head>` metadata: title, meta description, canonical,
/// OpenGraph and Twitter card tags.
///
/// Rendered server-side into the static HTML. Crawlers and social previews
/// read it without any client-side JavaScript.
Component pageHead({
  required String title,
  required String description,
  required String path,
  String ogType = 'website',
}) {
  final url = '$siteUrl$path';
  return Document.head(
    title: title,
    meta: {'description': description},
    children: [
      link(rel: 'canonical', href: url),
      meta(attributes: {'property': 'og:type', 'content': ogType}),
      meta(attributes: {'property': 'og:site_name', 'content': siteName}),
      meta(attributes: {'property': 'og:title', 'content': title}),
      meta(attributes: {'property': 'og:description', 'content': description}),
      meta(attributes: {'property': 'og:url', 'content': url}),
      meta(attributes: {'property': 'og:image', 'content': ogImageUrl}),
      meta(
        attributes: {'name': 'twitter:card', 'content': 'summary_large_image'},
      ),
      meta(attributes: {'name': 'twitter:title', 'content': title}),
      meta(attributes: {'name': 'twitter:description', 'content': description}),
      meta(attributes: {'name': 'twitter:image', 'content': ogImageUrl}),
    ],
  );
}
