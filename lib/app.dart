import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import 'components/q_mark.dart';
import 'pages/about_page.dart';
import 'pages/contact_page.dart';
import 'pages/home_page.dart';
import 'pages/not_found_page.dart';
import 'pages/projects_page.dart';

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
            to: '/',
            classes: 'brand',
            attributes: {'aria-label': 'Qouver — home'},
            children: [
              QMark(size: '30', classes: 'brand__mark'),
              span(classes: 'brand__word', [.text('Qouver')]),
            ],
          ),
          nav(
            classes: 'nav',
            attributes: {'aria-label': 'Primary'},
            [
              _navLink('Projects', '/projects', path),
              _navLink('About', '/about', path),
              _navLink('Contact', '/contact', path),
            ],
          ),
        ]),
      ]),
      main_(id: 'main', [
        Router(
          errorBuilder: (context, state) => const NotFoundPage(),
          routes: [
            Route(
              path: '/',
              title: 'Home',
              builder: (context, state) => const HomePage(),
            ),
            Route(
              path: '/projects',
              title: 'Projects',
              builder: (context, state) => const ProjectsPage(),
            ),
            Route(
              path: '/about',
              title: 'About',
              builder: (context, state) => const AboutPage(),
            ),
            Route(
              path: '/contact',
              title: 'Contact',
              builder: (context, state) => const ContactPage(),
            ),
            // Generates the static /404.html that Caddy serves for missing paths.
            Route(
              path: '/404.html',
              title: 'Page not found',
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
  return Link(
    to: path,
    classes: 'nav__link${current == path ? ' nav__link--active' : ''}',
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
              to: '/',
              classes: 'site-footer__brand',
              attributes: {'aria-label': 'Qouver — home'},
              children: [
                QMark(size: '28', classes: 'brand__mark'),
                span(classes: 'brand__word', [.text('Qouver')]),
              ],
            ),
            p(classes: 'footer__tagline', [
              .text(
                'A home for systems and ideas. Find value. Build systems. Share knowledge.',
              ),
            ]),
          ]),
          div(classes: 'footer__col', [
            h4([.text('Index')]),
            ul([
              li([Link(to: '/projects', child: .text('Projects'))]),
              li([Link(to: '/about', child: .text('About'))]),
              li([Link(to: '/contact', child: .text('Contact'))]),
            ]),
          ]),
          div(classes: 'footer__col', [
            h4([.text('Contact')]),
            ul([
              li([
                a(href: 'mailto:hello@qouver.com', [.text('hello@qouver.com')]),
              ]),
              li([
                a(
                  href: 'https://github.com/qouver',
                  target: Target.blank,
                  attributes: {'rel': 'noopener'},
                  [.text('github.com/qouver')],
                ),
              ]),
              li([
                a(
                  href: 'https://github.com/nferdazel',
                  target: Target.blank,
                  attributes: {'rel': 'noopener'},
                  [.text('github.com/nferdazel')],
                ),
              ]),
            ]),
          ]),
        ]),
        div(classes: 'site-footer__bottom', [
          span([.text('© 2026 Qouver')]),
          span([.text('Set in IBM Plex · Built with Jaspr')]),
          span([.text('qouver.com')]),
        ]),
      ]),
    ]);
  }
}
