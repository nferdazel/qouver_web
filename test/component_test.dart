import 'package:jaspr_test/server_test.dart';

import 'package:qouver_web/components/project_card.dart';
import 'package:qouver_web/components/q_mark.dart';
import 'package:qouver_web/data/projects.dart';
import 'package:qouver_web/pages/project_detail_page.dart';

void main() {
  testServer('ProjectCard renders an internal case study link', (tester) async {
    tester.pumpComponent(ProjectCard(project: projects.first));

    final res = await tester.request('/');

    expect(res.body, contains('<a'));
    expect(res.body, contains('href="/projects/skyward"'));
    expect(res.body, contains('Case Study'));
    expect(res.body, contains('project-card__status'));
  });

  testServer(
    'ProjectCard renders static metadata cleanly for synthetic project',
    (tester) async {
      // Synthetic project without URL (TAUG archived 2026-08-25, no longer in catalogue).
      const taug = Project(
        index: '04',
        slug: 'taug',
        name: 'TAUG',
        category: 'Research',
        tagline: 'Research workspace.',
        description: 'Archived.',
        focus: ['Research'],
        status: 'Archived',
        stack: 'TBD',
      );

      tester.pumpComponent(const ProjectCard(project: taug));

      final res = await tester.request('/');

      expect(res.body, contains('href="/projects/taug"'));
      expect(res.body, contains('Case Study'));
    },
  );

  testServer('QMark renders the monogram svg with the requested size', (
    tester,
  ) async {
    tester.pumpComponent(const QMark(size: '42', classes: 'hero__mark'));

    final res = await tester.request('/');

    expect(res.body, contains('<svg'));
    expect(res.body, contains('width="42"'));
    expect(res.body, contains('height="42"'));
    expect(res.body, contains('viewBox="0 0 64 64"'));
    expect(res.body, contains('cx="27"'));
    expect(res.body, contains('cy="27"'));
    expect(res.body, contains('class="hero__mark"'));
    expect(res.body, contains('aria-hidden="true"'));
  });

  testServer('ProjectDetailPage falls back for an unknown slug', (
    tester,
  ) async {
    tester.pumpComponent(const ProjectDetailPage(slug: 'does-not-exist'));

    final res = await tester.request('/');

    expect(res.body, contains('Case study not found'));
  });
}
