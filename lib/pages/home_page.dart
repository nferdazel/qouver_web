import 'dart:convert';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../components/project_card.dart';
import '../components/q_mark.dart';
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
        QMark(size: '520', classes: 'hero__mark'),
        div(classes: 'hero__meta', [
          span(classes: 'label', [
            .text('Qouver — a home for systems and ideas'),
          ]),
        ]),
        h1(classes: 'display', [
          .text('Turning '),
          em([.text('overlooked')]),
          .text(' ideas into useful systems.'),
        ]),
        p(classes: 'lead hero__lead', [
          .text(
            'Qouver finds value where others don\'t look — in software, communities, data, and process — builds it into systems, and shares what it learns along the way.',
          ),
        ]),
        div(classes: 'hero__actions', [
          Link(
            to: '/projects',
            classes: 'link',
            child: .text('Explore the systems →'),
          ),
          Link(to: '/about', classes: 'link', child: .text('The philosophy →')),
        ]),
      ]),
      section(classes: 'strip section--tight', [
        div(classes: 'container strip__grid', [
          for (final (num, title, body) in [
            (
              '01',
              'Find value.',
              'Valuable opportunities often hide in places others skip — software, communities, data, process, knowledge.',
            ),
            (
              '02',
              'Build systems.',
              'Discovery is only the start. The point is to turn what is found into something useful, tested, and durable.',
            ),
            (
              '03',
              'Share knowledge.',
              'What is learned gets documented and shared — so the next system starts further along.',
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
          span(classes: 'section-head__index', [.text('01 / INDEX')]),
          h2(classes: 'h2', [.text('Projects under the umbrella')]),
        ]),
        div(classes: 'projects-grid', [
          for (final p in data.projects) ProjectCard(project: p),
        ]),
        div(classes: 'mt-3', [
          Link(
            to: '/projects',
            classes: 'link',
            child: .text('View all projects →'),
          ),
        ]),
      ]),
      section(classes: 'manifesto section', [
        div(classes: 'container', [
          p(classes: 'manifesto__quote', [
            .text('Qouver exists to discover '),
            em([.text('overlooked opportunities')]),
            .text(
              ', transform them into useful systems, and preserve the knowledge gained along the way.',
            ),
          ]),
          div(classes: 'manifesto__row', [
            span(classes: 'label label--dark', [.text('Working manifesto')]),
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
