import 'dart:convert';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../components/project_card.dart';
import '../data/journal.dart';
import '../data/projects.dart' as data;
import '../seo.dart';

class HomePage extends StatelessComponent {
  const HomePage({super.key});

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      pageHead(
        title: 'Qouver — A home for systems and ideas',
        description:
            'Qouver finds overlooked opportunities, turns them into useful systems, and shares what it learns. A home for systems and ideas.',
        path: '/',
      ),
      script(
        attributes: {'type': 'application/ld+json'},
        content: jsonEncode([
          {
            '@context': 'https://schema.org',
            '@type': 'Organization',
            'name': 'Qouver',
            'url': siteUrl,
            'logo': '$siteUrl/assets/q-mark.svg',
            'email': 'hello@qouver.com',
            'description':
                'Qouver finds overlooked opportunities, turns them into useful systems, and shares what it learns. A home for systems and ideas.',
            'sameAs': [
              'https://github.com/qouver',
              'https://github.com/nferdazel',
            ],
          },
          {
            '@context': 'https://schema.org',
            '@type': 'WebSite',
            'name': 'Qouver',
            'url': siteUrl,
            'description':
                'A home for systems and ideas. Find value. Build systems. Share knowledge.',
          },
        ]),
      ),
      section(classes: 'hero container', [
        div(classes: 'hero__meta', [
          span(classes: 'label', [.text('SPEC // 01.0 — QOUVER.COM')]),
        ]),
        h1(classes: 'display', [
          .text('Built from what others '),
          em([.text('leave behind.')]),
        ]),
        p(classes: 'lead hero__lead', [
          .text(
            'Qouver builds systems from what others miss — software, communities, data, process. Each one tested, each one real.',
          ),
        ]),
        div(classes: 'hero__actions', [
          Link(
            to: '/projects',
            classes: 'link',
            child: .text('See the work →'),
          ),
          Link(to: '/journal', classes: 'link', child: .text('Read journal →')),
          Link(to: '/about', classes: 'link', child: .text('The philosophy →')),
        ]),
      ]),
      section(classes: 'strip section--tight', [
        div(classes: 'container strip__grid', [
          for (final (num, title, body) in [
            (
              'SPEC 01.0 // FIND VALUE',
              'Find value in plain sight.',
              'Valuable things often sit unindexed or overlooked — the gap in a community, the pattern in a dataset, the tool nobody bothered to build.',
            ),
            (
              'SPEC 02.0 // BUILD SYSTEMS',
              'Build real production systems.',
              'Not prototypes. Not pitch decks. Software running in production, handling real workload, and earning its place.',
            ),
            (
              'SPEC 03.0 // DOCUMENT ALL',
              'Document every lesson.',
              'What is built gets documented — architecture post-mortems and open technical essays so the next problem starts with context.',
            ),
          ])
            div(classes: 'strip__item', [
              div(classes: 'strip__num', [.text(num)]),
              h3([.text(title)]),
              p([.text(body)]),
            ]),
        ]),
      ]),
      section(classes: 'section container', [
        div(classes: 'section-head', [
          span(classes: 'section-head__index', [.text('SYSTEM INDEX // 01.0')]),
          h2(classes: 'h2', [.text('Production Systems')]),
        ]),
        div(classes: 'projects-grid', [
          for (final p in data.projects) ProjectCard(project: p),
        ]),
        div(classes: 'mt-3', [
          Link(to: '/projects', classes: 'link', child: .text('All Systems →')),
        ]),
      ]),
      section(classes: 'section container', [
        div(classes: 'section-head', [
          span(classes: 'section-head__index', [.text('DOCS // 02.0')]),
          h2(classes: 'h2', [.text('Recent Writing')]),
        ]),
        div(classes: 'journal-grid', [
          for (final article in journalArticles.take(2))
            Link(
              to: '/journal/${article.slug}',
              classes: 'journal-card',
              children: [
                div([
                  div(classes: 'journal-card__meta', [
                    span(classes: 'journal-card__tag', [
                      .text('DOC // ${article.category.toUpperCase()}'),
                    ]),
                  ]),
                  h2(classes: 'journal-card__title mt-2', [
                    .text(article.title),
                  ]),
                  p(classes: 'journal-card__summary mt-2', [
                    .text(article.summary),
                  ]),
                ]),
                div(classes: 'journal-card__foot', [
                  span([.text(article.date)]),
                  span([.text(article.readTime)]),
                ]),
              ],
            ),
        ]),
        div(classes: 'mt-3', [
          Link(to: '/journal', classes: 'link', child: .text('All Articles →')),
        ]),
      ]),
      section(classes: 'manifesto section', [
        div(classes: 'container', [
          p(classes: 'manifesto__quote', [
            .text('Find what others walk past. '),
            em([.text('Build something from it.')]),
            .text(' Leave notes for whoever comes next.'),
          ]),
          div(classes: 'manifesto__row', [
            span(classes: 'label label--dark', [
              .text('OPERATIONAL MANIFESTO'),
            ]),
            Link(
              to: '/about',
              classes: 'link link--dark',
              child: .text('Read the story →'),
            ),
          ]),
        ]),
      ]),
    ]);
  }
}
