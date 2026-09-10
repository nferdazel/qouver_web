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

      // ---------- Hero Section ----------
      section(classes: 'hero container', [
        div(classes: 'hero-inner', [
          h1(classes: 'display hero__display', [
            .text('Built from what others '),
            em([.text('leave behind.')]),
          ]),
          p(classes: 'lead hero__lead', [
            .text(
              'Qouver finds overlooked opportunities, turns them into useful systems, and shares what it learns. A home for systems and ideas.',
            ),
          ]),
          div(classes: 'hero__actions', [
            Link(
              to: '/projects',
              classes: 'btn btn--primary',
              child: .text('See the work →'),
            ),
            Link(
              to: '/journal',
              classes: 'btn btn--secondary',
              child: .text('Read journal →'),
            ),
          ]),
        ]),
      ]),

      // ---------- Philosophy / Approach Strip ----------
      section(classes: 'strip section--tight', [
        div(classes: 'container strip__grid', [
          for (final (num, title, body) in [
            (
              '01',
              'Find value in plain sight.',
              'Valuable things often sit unindexed or overlooked — the gap in a community, the pattern in a dataset, the tool nobody bothered to build.',
            ),
            (
              '02',
              'Build real production systems.',
              'Not prototypes. Not pitch decks. Software running in production, handling real workload, and earning its place.',
            ),
            (
              '03',
              'Document every lesson.',
              'What is built gets documented — architecture post-mortems and open technical essays so the next problem starts with context.',
            ),
          ])
            div(classes: 'strip__item', [
              span(classes: 'strip__num', [.text(num)]),
              h3([.text(title)]),
              p([.text(body)]),
            ]),
        ]),
      ]),

      // ---------- Production Systems Section ----------
      section(classes: 'section container', [
        div(classes: 'section-head', [
          h2(classes: 'h2', [.text('Production Systems')]),
          p(classes: 'section-head__subtitle', [
            .text('Active software systems built and operated by Qouver.'),
          ]),
        ]),
        div(classes: 'projects-grid', [
          for (final proj in data.projects) ProjectCard(project: proj),
        ]),
        div(classes: 'mt-4', [
          Link(
            to: '/projects',
            classes: 'btn btn--secondary',
            child: .text('All Systems →'),
          ),
        ]),
      ]),

      // ---------- Technical Journal Section ----------
      section(classes: 'section container', [
        div(classes: 'section-head', [
          h2(classes: 'h2', [.text('Recent Writing')]),
          p(classes: 'section-head__subtitle', [
            .text(
              'Reflections on systems design, software craft, and architecture.',
            ),
          ]),
        ]),
        div(classes: 'journal-grid', [
          for (final article in journalArticles.take(2))
            Link(
              to: '/journal/${article.slug}',
              classes: 'journal-card',
              children: [
                div([
                  div(classes: 'journal-card__meta', [
                    span(classes: 'journal-card__category', [
                      .text(article.category),
                    ]),
                    span(classes: 'journal-card__dot', [.text('·')]),
                    span(classes: 'journal-card__time', [
                      .text(article.readTime),
                    ]),
                  ]),
                  h3(classes: 'journal-card__title mt-1', [
                    .text(article.title),
                  ]),
                  p(classes: 'journal-card__summary mt-2', [
                    .text(article.summary),
                  ]),
                ]),
                div(classes: 'journal-card__foot', [
                  span(classes: 'journal-card__date', [.text(article.date)]),
                  span(classes: 'link-action', [.text('Read Article →')]),
                ]),
              ],
            ),
        ]),
        div(classes: 'mt-4', [
          Link(
            to: '/journal',
            classes: 'btn btn--secondary',
            child: .text('All Articles →'),
          ),
        ]),
      ]),

      // ---------- Operational Manifesto Section ----------
      section(classes: 'manifesto section', [
        div(classes: 'container', [
          p(classes: 'manifesto__quote', [
            .text('Find what others walk past. '),
            em([.text('Build something useful from it.')]),
            .text(' Leave notes for whoever comes next.'),
          ]),
          div(classes: 'manifesto__row', [
            span(classes: 'manifesto__lbl', [.text('Operational Manifesto')]),
            Link(
              to: '/about',
              classes: 'link-action link-action--light',
              child: .text('Read the story →'),
            ),
          ]),
        ]),
      ]),
    ]);
  }
}
