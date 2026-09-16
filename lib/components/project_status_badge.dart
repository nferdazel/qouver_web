import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../data/projects.dart';

/// The square status stamp for a project.
///
/// Shared by the catalogue row and the case study header so both render the
/// same stamp instead of each maintaining its own class logic.
class ProjectStatusBadge extends StatelessComponent {
  const ProjectStatusBadge({super.key, required this.status});

  final ProjectStatus status;

  @override
  Component build(BuildContext context) {
    final modifier = switch (status) {
      ProjectStatus.live => 'badge--live project-card__status--live',
      ProjectStatus.backend => 'badge--bronze',
      ProjectStatus.archived => 'project-card__status--archived',
    };

    return span(classes: 'badge project-card__status $modifier', [
      span(
        [],
        classes: status == ProjectStatus.live
            ? 'status-dot status-dot--live'
            : 'status-dot',
      ),
      .text(status.label),
    ]);
  }
}
