import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../data/projects.dart';
import '../routes.dart';
import 'project_status_badge.dart';

/// One project in the catalogue, rendered as a full-width dossier row:
/// index numeral, name, meta, description, stack, and links.
class ProjectCard extends StatelessComponent {
  const ProjectCard({super.key, required this.project});

  final Project project;

  @override
  Component build(BuildContext context) {
    return article(classes: 'project-card', [
      span(classes: 'project-card__index', [.text(project.index)]),
      div(classes: 'project-card__body', [
        div(classes: 'project-card__head', [
          span(classes: 'project-card__category', [
            .text(project.category.toUpperCase()),
          ]),
          ProjectStatusBadge(status: project.status),
        ]),
        h3(classes: 'project-card__name', [
          Link(to: Routes.project(project.slug), child: .text(project.name)),
        ]),
        p(classes: 'project-card__desc', [.text(project.description)]),
        div(classes: 'project-card__stack-list', [
          for (final item in project.stackItems)
            span(classes: 'stack-pill', [.text(item)]),
        ]),
      ]),
      div(classes: 'project-card__foot', [
        Link(
          to: Routes.project(project.slug),
          classes: 'link-action',
          child: .text('Case Study'),
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
