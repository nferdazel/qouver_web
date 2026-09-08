import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../data/projects.dart';

/// Card for a [Project] — displayed as a full-width list row on the homepage.
/// Links to the internal case study for the project.
class ProjectCard extends StatelessComponent {
  const ProjectCard({super.key, required this.project});

  final Project project;

  @override
  Component build(BuildContext context) {
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
        span(classes: 'project-card__visit', [.text('Case Study →')]),
      ]),
    ];

    return Link(
      to: '/projects/${project.slug}',
      classes: 'project-card',
      children: card,
    );
  }
}
