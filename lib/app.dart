import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import 'components/q_mark.dart';
import 'pages/about_page.dart';
import 'pages/contact_page.dart';
import 'pages/home_page.dart';
import 'pages/journal_detail_page.dart';
import 'pages/journal_page.dart';
import 'pages/not_found_page.dart';
import 'pages/project_detail_page.dart';
import 'pages/projects_page.dart';
import 'routes.dart';
import 'site.dart';

/// The main component of the application.
///
/// Uses multi-page routing: this component is only built on the server during
/// pre-rendering (static generation) and is not executed on the client.
/// Navigation between pages happens via real page loads through [Link].
class App extends StatelessComponent {
  const App({super.key});

  @override
  Component build(BuildContext context) {
    final path = context.url;
    return Component.fragment([
      a(classes: 'skip-link', href: '#main', [.text('Skip to content')]),
      header(classes: 'site-header', [
        div(classes: 'container site-header__inner', [
          Link(
            to: Routes.home,
            classes: 'brand',
            attributes: {'aria-label': 'Qouver, home'},
            children: [
              const QMark(size: '30', classes: 'brand__mark', accentDot: true),
              span(classes: 'brand__word', [.text('Qouver')]),
            ],
          ),
          nav(
            classes: 'nav',
            attributes: {'aria-label': 'Primary'},
            [
              _navLink('Projects', Routes.projects, path),
              _navLink('Journal', Routes.journal, path),
              _navLink('About', Routes.about, path),
              _navLink('Contact', Routes.contact, path),
            ],
          ),
        ]),
      ]),
      main_(id: 'main', [
        Router(
          errorBuilder: (context, state) => const NotFoundPage(),
          // Titles are owned by each page's `pageHead(...)` call, which renders
          // the `<title>` during static generation. `Route.title` is not used in
          // the output, so it is omitted to keep one source of truth.
          routes: [
            Route(
              path: Routes.home,
              builder: (context, state) => const HomePage(),
            ),
            Route(
              path: Routes.projects,
              builder: (context, state) => const ProjectsPage(),
            ),
            Route(
              path: Routes.project('skyward'),
              builder: (context, state) =>
                  const ProjectDetailPage(slug: 'skyward'),
            ),
            Route(
              path: Routes.project('majadu'),
              builder: (context, state) =>
                  const ProjectDetailPage(slug: 'majadu'),
            ),
            Route(
              path: Routes.project('sds'),
              builder: (context, state) => const ProjectDetailPage(slug: 'sds'),
            ),
            Route(
              path: Routes.project('mdef'),
              builder: (context, state) =>
                  const ProjectDetailPage(slug: 'mdef'),
            ),
            Route(
              path: Routes.journal,
              builder: (context, state) => const JournalPage(),
            ),
            Route(
              path: Routes.article('authoritative-go-simulations'),
              builder: (context, state) =>
                  const JournalDetailPage(slug: 'authoritative-go-simulations'),
            ),
            Route(
              path: Routes.article('zero-js-static-jaspr'),
              builder: (context, state) =>
                  const JournalDetailPage(slug: 'zero-js-static-jaspr'),
            ),
            Route(
              path: Routes.article('systems-prospector-manifesto'),
              builder: (context, state) =>
                  const JournalDetailPage(slug: 'systems-prospector-manifesto'),
            ),
            Route(
              path: Routes.about,
              builder: (context, state) => const AboutPage(),
            ),
            Route(
              path: Routes.contact,
              builder: (context, state) => const ContactPage(),
            ),
            // Generates the static /404.html that Caddy serves for missing paths.
            Route(
              path: Routes.notFound,
              builder: (context, state) => const NotFoundPage(),
            ),
          ],
        ),
      ]),
      const _SiteFooter(),
    ]);
  }
}

Component _navLink(String label, String path, String current) {
  final isActive =
      current == path || (path != '/' && current.startsWith('$path/'));
  return Link(
    to: path,
    classes: 'nav__link${isActive ? ' nav__link--active' : ''}',
    child: .text(label),
  );
}

class _SiteFooter extends StatelessComponent {
  const _SiteFooter();

  @override
  Component build(BuildContext context) {
    return footer(classes: 'site-footer', [
      div(classes: 'container', [
        div(classes: 'site-footer__top', [
          div([
            Link(
              to: Routes.home,
              classes: 'site-footer__brand',
              attributes: {'aria-label': 'Qouver, home'},
              children: [
                const QMark(
                  size: '28',
                  classes: 'brand__mark',
                  accentDot: true,
                ),
                span(classes: 'brand__word', [.text(siteName)]),
              ],
            ),
            p(classes: 'footer__tagline', [
              .text(
                'Built from what others leave behind. A home for systems and ideas.',
              ),
            ]),
          ]),
          div(classes: 'site-footer__nav', [
            div(classes: 'footer__col', [
              h4([.text('Index')]),
              ul([
                li([Link(to: Routes.projects, child: .text('Projects'))]),
                li([Link(to: Routes.journal, child: .text('Journal'))]),
                li([Link(to: Routes.about, child: .text('About'))]),
                li([Link(to: Routes.contact, child: .text('Contact'))]),
              ]),
            ]),
            div(classes: 'footer__col', [
              h4([.text('Contact')]),
              ul([
                li([
                  a(href: 'mailto:$contactEmail', [.text(contactEmail)]),
                ]),
                li([
                  a(
                    href: githubOrgUrl,
                    target: Target.blank,
                    attributes: {'rel': 'noopener'},
                    [.text('github.com/qouver')],
                  ),
                ]),
                li([
                  a(
                    href: githubMaintainerUrl,
                    target: Target.blank,
                    attributes: {'rel': 'noopener'},
                    [.text('github.com/nferdazel')],
                  ),
                ]),
              ]),
            ]),
          ]),
        ]),
        div(classes: 'site-footer__bottom', [
          span([.text('© 2026 Qouver')]),
          span([.text('Set in Fraunces & Archivo · Built with Jaspr')]),
          span([.text('qouver.com')]),
        ]),
      ]),
    ]);
  }
}
