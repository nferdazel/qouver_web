import 'package:jaspr_test/server_test.dart';

import 'package:qouver_web/app.dart';
import 'package:qouver_web/pages/not_found_page.dart';

void main() {
  testServer('renders the home page with hero content', (tester) async {
    tester.pumpComponent(const App());

    final res = await tester.request('/');

    expect(res.statusCode, 200);
    expect(res.body, contains('Built from what others'));
    expect(res.body, contains('qouver.com'));
  });

  testServer('renders every route with its SEO title', (tester) async {
    tester.pumpComponent(const App());

    final routes = {
      '/': 'Qouver · A home for systems and ideas',
      '/projects': 'Projects · Qouver',
      '/projects/skyward': 'Skyward · Technical Case Study · Qouver',
      '/projects/majadu': 'Majadu Tools · Technical Case Study · Qouver',
      '/projects/sds': 'SDS Management · Technical Case Study · Qouver',
      '/projects/mdef': 'M-DEF · Technical Case Study · Qouver',
      '/journal': 'Journal · Qouver',
      '/journal/authoritative-go-simulations':
          'Authoritative World Tick Simulation Engines in Go · Journal · Qouver',
      '/journal/zero-js-static-jaspr':
          'Zero-JS Static Web: Why We Rebuilt Qouver with Jaspr · Journal · Qouver',
      '/journal/systems-prospector-manifesto':
          'The Systems Prospector: Finding Latent Value in Latent Problems · Journal · Qouver',
      '/about': 'About · Qouver',
      '/contact': 'Contact · Qouver',
    };

    for (final entry in routes.entries) {
      final res = await tester.request(entry.key);
      expect(res.statusCode, 200, reason: 'route ${entry.key} should be 200');
      expect(
        res.document?.querySelector('title')?.text,
        entry.value,
        reason: 'title for ${entry.key}',
      );
    }
  });

  testServer('marks the active nav link per route', (tester) async {
    tester.pumpComponent(const App());

    final res = await tester.request('/about');

    expect(res.body, contains('nav__link nav__link--active'));
    // The active class appears exactly once per page.
    expect('nav__link nav__link--active'.allMatches(res.body).length, 1);
  });

  testServer('renders project catalogue rows on the projects page', (
    tester,
  ) async {
    tester.pumpComponent(const App());

    final res = await tester.request('/projects');

    expect(res.body, contains('Skyward'));
    expect(res.body, contains('Majadu Tools'));
    expect(res.body, contains('SDS Management'));
    expect(res.body, contains('M-DEF'));
    expect(res.body, isNot(contains('TAUG')));
  });

  testServer('renders the not-found page for an unknown route', (tester) async {
    tester.pumpComponent(const App());

    final res = await tester.request('/journal/does-not-exist');

    expect(res.body, contains('Page not found'));
  });

  testServer('NotFoundPage carries its own SEO title', (tester) async {
    tester.pumpComponent(const NotFoundPage());

    final res = await tester.request('/');

    expect(res.body, contains('Page not found.'));
    expect(
      res.document?.querySelector('title')?.text,
      'Page not found · Qouver',
    );
  });
}
