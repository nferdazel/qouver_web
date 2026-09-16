import 'package:qouver_web/routes.dart';
import 'package:test/test.dart';

void main() {
  test('every static path is rooted', () {
    const paths = [
      Routes.home,
      Routes.projects,
      Routes.journal,
      Routes.about,
      Routes.contact,
      Routes.notFound,
    ];

    for (final path in paths) {
      expect(path, startsWith('/'));
    }
  });

  test('project paths build from the catalogue root', () {
    expect(Routes.project('skyward'), '/projects/skyward');
  });

  test('article paths build from the journal root', () {
    expect(
      Routes.article('zero-js-static-jaspr'),
      '/journal/zero-js-static-jaspr',
    );
  });
}
