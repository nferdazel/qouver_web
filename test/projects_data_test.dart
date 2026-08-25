import 'package:test/test.dart';

import 'package:qouver_web/data/projects.dart';

void main() {
  test('project indexes are unique and sequential', () {
    expect(projects.map((p) => p.index).toList(), ['01', '02', '03', '04']);
  });

  test('project names are unique', () {
    expect(projects.map((p) => p.name).toSet().length, projects.length);
  });

  test('urls are absolute https when present', () {
    for (final p in projects) {
      if (p.url case final url?) {
        expect(url, startsWith('https://'), reason: '${p.name} url');
      }
    }
  });

  test('focus, stack and tagline are non-empty', () {
    for (final p in projects) {
      expect(p.focus, isNotEmpty, reason: '${p.name} focus');
      expect(p.stack, isNotEmpty, reason: '${p.name} stack');
      expect(p.tagline, isNotEmpty, reason: '${p.name} tagline');
    }
  });

  test('projects with a URL have a non-empty urlLabel', () {
    for (final p in projects) {
      if (p.url != null) {
        expect(p.urlLabel, isNotEmpty, reason: '${p.name} urlLabel');
      }
    }
  });
}
