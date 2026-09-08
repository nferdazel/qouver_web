import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../data/projects.dart';

/// Card for a [Project] — displayed in a 2-column grid on the homepage.
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

    return article(classes: 'project-card', [
      div(classes: 'project-card__head', [
        span(classes: 'project-card__meta label', [
          .text('${project.index} — ${project.category}'),
        ]),
        span(classes: statusClass, [.text(project.status)]),
      ]),
      div(classes: 'project-card__body', [
        h3(classes: 'project-card__name', [
          Link(to: '/projects/${project.slug}', child: .text(project.name)),
        ]),
        p(classes: 'project-card__desc', [.text(project.description)]),
      ]),
      div(classes: 'project-card__foot', [
        span(classes: 'project-card__stack label', [.text(project.stack)]),
        div(classes: 'project-card__actions', [
          Link(
            to: '/projects/${project.slug}',
            classes: 'link',
            child: .text('Case Study →'),
          ),
          if (project.url != null)
            a(
              href: project.url!,
              target: Target.blank,
              attributes: {'rel': 'noopener'},
              classes: 'link link--dim',
              [.text('${project.urlLabel} ↗')],
            ),
        ]),
      ]),
    ]);
  }
}
