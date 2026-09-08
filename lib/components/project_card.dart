import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../data/projects.dart';

/// Card for a [Project] — displayed as a full-width list row on the homepage.
/// A link when the project has a public URL, a static card otherwise.
class ProjectCard extends StatelessComponent {
  const ProjectCard({super.key, required this.project});

  final Project project;

  @override
  Component build(BuildContext context) {
    final url = project.url;
    final statusClass = switch (project.status) {
      'Live' => 'project-card__status project-card__status--live',
      'Archived' => 'project-card__status project-card__status--archived',
      _ => 'project-card__status',
    };

    final card = <Component>[
      div(classes: 'project-card__body', [
        div(classes: 'project-card__meta label', [
          .text('${project.index} — ${project.category}'),
        ]),
        h3(classes: 'project-card__name', [.text(project.name)]),
        p(classes: 'project-card__desc', [.text(project.tagline)]),
        span(classes: 'project-card__stack label', [.text(project.stack)]),
      ]),
      div(classes: 'project-card__side', [
        span(classes: statusClass, [.text(project.status)]),
        if (url != null)
          span(classes: 'project-card__visit', [.text('${project.urlLabel} →')]),
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
