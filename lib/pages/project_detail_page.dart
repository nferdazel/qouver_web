import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../data/projects.dart' as data;
import '../seo.dart';

/// Renders a static technical case study page for a specific project.
class ProjectDetailPage extends StatelessComponent {
  const ProjectDetailPage({super.key, required this.slug});

  final String slug;

  @override
  Component build(BuildContext context) {
    final project = data.projects
        .where((proj) => proj.slug == slug)
        .firstOrNull;

    if (project == null || project.caseStudy == null) {
      return section(classes: 'page-head container', [
        h1(classes: 'page-title', [.text('Case study not found.')]),
        div(classes: 'mt-3', [
          Link(
            to: '/projects',
            classes: 'link',
            child: .text('← All projects'),
          ),
        ]),
      ]);
    }

    final cs = project.caseStudy!;
    final statusClass = switch (project.status) {
      'Live' =>
        'badge badge--live project-card__status project-card__status--live',
      'Archived' => 'badge project-card__status project-card__status--archived',
      _ => 'badge project-card__status',
    };

    return Component.fragment([
      pageHead(
        title: '${project.name} · Technical Case Study · Qouver',
        description: cs.overview,
        path: '/projects/${project.slug}',
      ),
      section(classes: 'page-head container', [
        div(classes: 'page-head__meta', [
          Link(to: '/projects', classes: 'link', child: .text('← Projects')),
          span(classes: 'label', [.text('Case Study')]),
        ]),
        h1(classes: 'page-title', [.text(project.name)]),
        p(classes: 'lead mt-2', [.text(cs.title)]),
        div(classes: 'project-detail__meta-bar mt-3', [
          div(classes: 'project-detail__meta-item', [
            span(classes: 'label', [.text('Category')]),
            span(classes: 'project-detail__meta-val', [
              .text(project.category),
            ]),
          ]),
          div(classes: 'project-detail__meta-item', [
            span(classes: 'label', [.text('Status')]),
            span(classes: statusClass, [.text(project.status)]),
          ]),
          div(classes: 'project-detail__meta-item', [
            span(classes: 'label', [.text('Stack')]),
            span(classes: 'project-detail__meta-val', [.text(project.stack)]),
          ]),
          if (project.url != null)
            div(classes: 'project-detail__meta-item', [
              span(classes: 'label', [.text('Live Site')]),
              a(
                href: project.url!,
                target: Target.blank,
                attributes: {'rel': 'noopener'},
                classes: 'link',
                [.text('${project.urlLabel} ↗')],
              ),
            ]),
        ]),
      ]),
      section(classes: 'section container', [
        div(classes: 'editorial', [
          div(classes: 'editorial__label', [.text('01 / Context')]),
          div([
            h2(classes: 'h3', [.text('Overview & Problem')]),
            p(classes: 'body mt-2', [.text(cs.overview)]),
            p(classes: 'body', [.text(cs.problem)]),
          ]),
        ]),
        div(classes: 'editorial mt-3', [
          div(classes: 'editorial__label', [.text('02 / System')]),
          div([
            h2(classes: 'h3', [.text('Architecture')]),
            p(classes: 'body mt-2', [.text(cs.architecture)]),
          ]),
        ]),
        div(classes: 'editorial mt-3', [
          div(classes: 'editorial__label', [.text('03 / Decisions')]),
          div([
            h2(classes: 'h3', [.text('Engineering Trade-offs')]),
            div(classes: 'case-decisions mt-2', [
              for (final (idx, item) in cs.decisions.indexed)
                div(classes: 'case-decision-item', [
                  div(classes: 'case-decision-item__num label', [
                    .text('0${idx + 1}'),
                  ]),
                  h3(classes: 'case-decision-item__title', [.text(item.$1)]),
                  p(classes: 'body', [.text(item.$2)]),
                ]),
            ]),
          ]),
        ]),
        div(classes: 'editorial mt-3', [
          div(classes: 'editorial__label', [.text('04 / Outcome')]),
          div([
            h2(classes: 'h3', [.text('Key Takeaway')]),
            p(classes: 'body mt-2', [.text(cs.takeaways)]),
          ]),
        ]),
      ]),
      section(classes: 'manifesto section', [
        div(classes: 'container', [
          p(classes: 'manifesto__quote', [
            .text('Explore more systems in the '),
            em([.text('Qouver umbrella.')]),
          ]),
          div(classes: 'manifesto__row', [
            Link(
              to: '/projects',
              classes: 'link link--dark',
              child: .text('← Back to all projects'),
            ),
            if (project.url != null)
              a(
                href: project.url!,
                target: Target.blank,
                attributes: {'rel': 'noopener'},
                classes: 'link link--dark',
                [.text('Visit ${project.name} ↗')],
              ),
          ]),
        ]),
      ]),
    ]);
  }
}
