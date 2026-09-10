import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/project_card.dart';
import '../data/projects.dart' as data;
import '../seo.dart';

class ProjectsPage extends StatelessComponent {
  const ProjectsPage({super.key});

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      pageHead(
        title: 'Projects — Qouver',
        description:
            'The systems under the Qouver umbrella: Skyward, Majadu Tools, and SDS Management — simulation, community systems, and compliance tools.',
        path: '/projects',
      ),
      section(classes: 'page-head container', [
        div(classes: 'page-head__meta', [
          span(classes: 'badge badge--bronze', [.text('CATALOGUE')]),
        ]),
        h1(classes: 'page-title', [.text('Production Systems')]),
        p(classes: 'lead mt-2', [
          .text(
            'Live, in production, or archived — each one earned its place. Built to solve real problems with disciplined software craft.',
          ),
        ]),
      ]),
      section(classes: 'section container', [
        div(classes: 'projects-grid', [
          for (final project in data.projects) ProjectCard(project: project),
        ]),
      ]),
    ]);
  }
}
