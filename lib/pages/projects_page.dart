import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

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
            'The systems under the Qouver umbrella: Skyward, M-DEF, Majadu Tools, and TAUG — simulation, analytics, community systems, and research.',
        path: '/projects',
      ),
      section(classes: 'page-head container', [
        div(classes: 'page-head__meta', [
          span(classes: 'label', [.text('Index')]),
        ]),
        h1(classes: 'page-title', [.text('Projects.')]),
        p(classes: 'lead mt-2', [
          .text(
            'The systems under the umbrella — some live, some in the ground. Each one started as something others overlooked.',
          ),
        ]),
      ]),
      section(classes: 'section container', [
        for (final project in data.projects)
          div(classes: 'project-row', [
            div(classes: 'project-row__head', [
              h2(classes: 'h3', [
                .text(project.name),
                span(classes: 'label', [.text(project.category)]),
              ]),
              span(classes: 'label', [.text(project.status)]),
            ]),
            p(classes: 'body mt-2', [.text(project.description)]),
            ul(classes: 'project-row__focus', [
              for (final f in project.focus) li([.text(f)]),
            ]),
            div(classes: 'project-row__foot', [
              span(classes: 'label', [.text(project.stack)]),
              if (project.url != null)
                a(
                  href: project.url!,
                  target: Target.blank,
                  attributes: {'rel': 'noopener'},
                  classes: 'link',
                  [.text('${project.urlLabel} →')],
                )
              else
                span(classes: 'label', [.text('No public link yet')]),
            ]),
          ]),
      ]),
    ]);
  }
}
