import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../data/projects.dart';

/// Clean modern project card for the Qouver systems catalogue.
class ProjectCard extends StatelessComponent {
  const ProjectCard({super.key, required this.project});

  final Project project;

  @override
  Component build(BuildContext context) {
    final isLive = project.status == 'Live';
    final isBackend = project.status == 'Backend';

    final statusBadgeClass = isLive
        ? 'badge badge--live project-card__status project-card__status--live'
        : isBackend
        ? 'badge badge--bronze project-card__status'
        : 'badge project-card__status project-card__status--archived';

    final stackItems = project.stack
        .split('·')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty);

    return article(classes: 'project-card', [
      div(classes: 'project-card__head', [
        span(classes: 'project-card__category', [
          .text(project.category.toUpperCase()),
        ]),
        span(classes: statusBadgeClass, [
          span(
            [],
            classes: isLive ? 'status-dot status-dot--live' : 'status-dot',
          ),
          .text(project.status),
        ]),
      ]),
      div([
        h3(classes: 'project-card__name', [
          Link(
            to: '/projects/${project.slug}',
            child: .text('${project.name} →'),
          ),
        ]),
        p(classes: 'project-card__desc', [.text(project.description)]),
        div(classes: 'project-card__stack-list', [
          for (final item in stackItems)
            span(classes: 'stack-pill', [.text(item)]),
        ]),
      ]),
      div(classes: 'project-card__foot', [
        Link(
          to: '/projects/${project.slug}',
          classes: 'link-action',
          child: .text('Case Study →'),
        ),
        if (project.url != null)
          a(
            href: project.url!,
            target: Target.blank,
            attributes: {'rel': 'noopener'},
            classes: 'btn btn--ghost',
            [.text('${project.urlLabel} ↗')],
          ),
      ]),
    ]);
  }
}
