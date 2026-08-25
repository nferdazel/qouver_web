import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../data/projects.dart';

/// Card for a [Project] — a link when the project has a public URL,
/// a static card otherwise.
class ProjectCard extends StatelessComponent {
  const ProjectCard({super.key, required this.project});

  final Project project;

  @override
  Component build(BuildContext context) {
    final url = project.url;
    final card = <Component>[
      div(classes: 'project-card__meta', [
        span([.text('${project.index} — ${project.category}')]),
        span(classes: 'project-card__status', [.text(project.status)]),
      ]),
      h3(classes: 'project-card__name', [.text(project.name)]),
      p(classes: 'project-card__desc', [.text(project.description)]),
      div(classes: 'project-card__foot', [
        span(classes: 'project-card__stack', [.text(project.stack)]),
        if (url != null)
          span(classes: 'project-card__visit', [
            .text('${project.urlLabel} →'),
          ]),
      ]),
    ];

    return url != null
        ? a(
            href: url,
            target: Target.blank,
            attributes: {'rel': 'noopener'},
            classes: 'project-card',
            card,
          )
        : article(classes: 'project-card project-card--static', card);
  }
}
