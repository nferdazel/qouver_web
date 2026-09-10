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
        div(classes: 'hero-grid', [
          div(classes: 'hero-copy', [
            div(classes: 'hero__badge', [
              span(classes: 'badge badge--bronze', [
                span([], classes: 'status-dot status-dot--live'),
                .text('A HOME FOR SYSTEMS & IDEAS'),
              ]),
            ]),
            h1(classes: 'display', [
              .text('Built from what others '),
              em([.text('leave behind.')]),
            ]),
            p(classes: 'lead hero__lead', [
              .text(
                'Qouver uncovers overlooked opportunities, turns them into high-performance software systems, and publishes open technical lessons.',
              ),
            ]),
            div(classes: 'hero__actions', [
              Link(
                to: '/projects',
                classes: 'btn btn--primary',
                child: .text('Explore Systems →'),
              ),
              Link(
                to: '/journal',
                classes: 'btn btn--secondary',
                child: .text('Read Journal'),
              ),
              Link(
                to: '/about',
                classes: 'btn btn--ghost',
                child: .text('Our Philosophy'),
              ),
            ]),
          ]),

          // Hero Featured System Showcase Card
          div(classes: 'hero-showcase', [
            div(classes: 'hero-showcase__head', [
              span(classes: 'badge badge--bronze', [.text('FEATURED SYSTEM')]),
              span(classes: 'badge badge--live', [
                span([], classes: 'status-dot status-dot--live'),
                .text('LIVE'),
              ]),
            ]),
            div(classes: 'hero-showcase__title-row', [
              span(classes: 'hero-showcase__name', [.text('Skyward')]),
            ]),
            p(classes: 'hero-showcase__tagline', [
              .text(
                'Global airline tycoon simulation running on an authoritative Go tick engine backend.',
              ),
            ]),
            div(classes: 'hero-showcase__metrics', [
              div(classes: 'metric-item', [
                span(classes: 'metric-item__val', [.text('99.9%')]),
                span(classes: 'metric-item__lbl', [.text('Uptime')]),
              ]),
              div(classes: 'metric-item', [
                span(classes: 'metric-item__val', [.text('<15ms')]),
                span(classes: 'metric-item__lbl', [.text('Tick Latency')]),
              ]),
              div(classes: 'metric-item', [
                span(classes: 'metric-item__val', [.text('Go 1.22')]),
                span(classes: 'metric-item__lbl', [.text('Engine')]),
              ]),
            ]),
            div(classes: 'hero-showcase__foot', [
              div(classes: 'project-card__stack-list', [
                span(classes: 'stack-pill', [.text('Go')]),
                span(classes: 'stack-pill', [.text('Flutter')]),
                span(classes: 'stack-pill', [.text('Postgres')]),
              ]),
              Link(
                to: '/projects/skyward',
                classes: 'link-action',
                child: .text('View Case Study →'),
              ),
            ]),
          ]),
        ]),
      ]),

      // ---------- Philosophy / Approach Strip ----------
      section(classes: 'strip section--tight', [
        div(classes: 'container strip__grid', [
          for (final (num, title, body) in [
            (
              '01 / FIND VALUE',
              'Find value in plain sight',
              'Valuable opportunities often sit unindexed or overlooked — gaps in local community tools, compliance workflows, or simulation engines.',
            ),
            (
              '02 / BUILD SYSTEMS',
              'Build resilient production software',
              'Not throwaway demos. Systems engineered with high standards of performance and reliability to handle real workloads.',
            ),
            (
              '03 / SHARE KNOWLEDGE',
              'Document every lesson learned',
              'What is built gets documented — architecture decisions, post-mortems, and open technical essays for whoever comes next.',
            ),
          ])
            div(classes: 'strip__item', [
              span(classes: 'strip__num', [.text(num)]),
              h3([.text(title)]),
              p([.text(body)]),
            ]),
        ]),
      ]),

      // ---------- Production Systems Catalogue Grid ----------
      section(classes: 'section container', [
        div(classes: 'section-head', [
          span(classes: 'section-head__kicker', [.text('CATALOGUE')]),
          h2(classes: 'h2', [.text('Production Systems')]),
          p(classes: 'section-head__subtitle', [
            .text('Active software systems built and maintained by Qouver.'),
          ]),
        ]),
        div(classes: 'projects-grid', [
          for (final proj in data.projects) ProjectCard(project: proj),
        ]),
        div(classes: 'mt-4', [
          Link(
            to: '/projects',
            classes: 'btn btn--secondary',
            child: .text('View All Projects →'),
          ),
        ]),
      ]),

      // ---------- Technical Journal Grid ----------
      section(classes: 'section container', [
        div(classes: 'section-head', [
          span(classes: 'section-head__kicker', [.text('JOURNAL')]),
          h2(classes: 'h2', [.text('Recent Writing')]),
          p(classes: 'section-head__subtitle', [
            .text('Architecture notes, post-mortems, and software essays.'),
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
                    span(classes: 'badge', [.text(article.readTime)]),
                  ]),
                  h2(classes: 'journal-card__title', [.text(article.title)]),
                  p(classes: 'journal-card__summary', [.text(article.summary)]),
                ]),
                div(classes: 'journal-card__foot', [
                  span([.text(article.date)]),
                  span(classes: 'link-action', [.text('Read Article →')]),
                ]),
              ],
            ),
        ]),
        div(classes: 'mt-4', [
          Link(
            to: '/journal',
            classes: 'btn btn--secondary',
            child: .text('Read All Articles →'),
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
            span(classes: 'badge badge--bronze', [
              .text('OPERATIONAL MANIFESTO'),
            ]),
            Link(
              to: '/about',
              classes: 'link-action',
              child: .text('Read Our Story →'),
            ),
          ]),
        ]),
      ]),
    ]);
  }
}
