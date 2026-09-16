/// Route paths for the static site.
///
/// Single source of truth for internal links: a path is written once here and
/// referenced by name everywhere else, which keeps navigation, the router, and
/// the pages from drifting apart.
abstract final class Routes {
  static const home = '/';
  static const projects = '/projects';
  static const journal = '/journal';
  static const about = '/about';
  static const contact = '/contact';

  /// The pre-rendered artifact that Caddy serves for missing paths.
  static const notFound = '/404.html';

  /// Case study path for a project [slug].
  static String project(String slug) => '$projects/$slug';

  /// Journal article path for an article [slug].
  static String article(String slug) => '$journal/$slug';
}
