import 'dart:convert';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../components/project_card.dart';
import '../components/q_mark.dart';
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
        div(classes: 'hero-grid', [
          div(classes: 'hero-copy', [
            div(classes: 'section-marker', [
              span([.text('01 /')]),
              .text(' QOUVER / SYSTEM HOME'),
            ]),
            h1(classes: 'display hero__display', [
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
              Link(
                to: '/journal',
                classes: 'link',
                child: .text('Read journal →'),
              ),
              Link(
                to: '/about',
                classes: 'link',
                child: .text('The philosophy →'),
              ),
            ]),
          ]),
          figure(classes: 'hero-figure', [
            div(classes: 'hero-figure__head', [
              span([.text('SYSTEM / MONOGRAM')]),
              span([.text('01.0')]),
            ]),
            div(classes: 'hero-figure__body', [
              const QMark(size: '56', classes: 'brand__mark'),
            ]),
            figcaption(classes: 'hero-figure__foot', [
              span([.text('STATUS / PRODUCTION READY')]),
              span([.text('QOUVER.COM')]),
            ]),
          ]),
        ]),
      ]),
      section(classes: 'strip section', [
        div(classes: 'container principle-split', [
          div(classes: 'principle-intro', [
            div(classes: 'section-marker', [
              span([.text('02 /')]),
              .text(' PHILOSOPHY'),
            ]),
            h2(classes: 'h2', [
              .text('Turning overlooked gaps into working production systems.'),
            ]),
            p(classes: 'body body--dark mt-2', [
              .text(
                'Valuable opportunities often sit in plain sight — broken tools, unindexed data, or clumsy workflows. Qouver designs focused software solutions and leaves full notes for whoever comes next.',
              ),
            ]),
          ]),
          ol(classes: 'principle-line', [
            li(classes: 'principle-step', [
              div(classes: 'principle-step__num', [.text('1.0 / FIND VALUE')]),
              h3(classes: 'principle-step__title', [
                .text('Find what others walk past'),
              ]),
              p(classes: 'principle-step__desc', [
                .text(
                  'The gap in a community, the pattern in a dataset, the tool nobody bothered to build.',
                ),
              ]),
            ]),
            li(classes: 'principle-step', [
              div(classes: 'principle-step__num', [
                .text('2.0 / BUILD SYSTEMS'),
              ]),
              h3(classes: 'principle-step__title', [
                .text('Build real systems'),
              ]),
              p(classes: 'principle-step__desc', [
                .text(
                  'Not prototypes or pitch decks. Software running in production, handling real workload.',
                ),
              ]),
            ]),
            li(classes: 'principle-step', [
              div(classes: 'principle-step__num', [
                .text('3.0 / SHARE KNOWLEDGE'),
              ]),
              h3(classes: 'principle-step__title', [
                .text('Document everything'),
              ]),
              p(classes: 'principle-step__desc', [
                .text(
                  'What is built gets documented — architecture post-mortems and open technical essays.',
                ),
              ]),
            ]),
          ]),
        ]),
      ]),
      section(classes: 'section container', [
        div(classes: 'section-marker', [
          span([.text('03 /')]),
          .text(' CAPABILITY REGISTER'),
        ]),
        div(classes: 'section-head', [
          h2(classes: 'h2', [
            .text('Architectural domains & focused capabilities.'),
          ]),
        ]),
        div(classes: 'capability-register', [
          div(classes: 'capability-row', [
            div(classes: 'capability-row__label', [.text('SOFTWARE & TOOLS')]),
            div(classes: 'capability-row__body', [
              h3([.text('Web Applications & Custom Engineering')]),
              p([
                .text(
                  'Fast, static-first web systems, browser extensions, and standalone tools (Skyward, Majadu Tools).',
                ),
              ]),
            ]),
          ]),
          div(classes: 'capability-row', [
            div(classes: 'capability-row__label', [
              .text('DATA & INTELLIGENCE'),
            ]),
            div(classes: 'capability-row__body', [
              h3([.text('Structured Data & Process Management')]),
              p([
                .text(
                  'Automated parsing, safety data sheet compliance, and enterprise information systems (SDS Management).',
                ),
              ]),
            ]),
          ]),
          div(classes: 'capability-row', [
            div(classes: 'capability-row__label', [.text('INFRASTRUCTURE')]),
            div(classes: 'capability-row__body', [
              h3([.text('Security & Operational Systems')]),
              p([
                .text(
                  'Containerized deployments, network security layers, and resilient hosting setups (M-DEF).',
                ),
              ]),
            ]),
          ]),
          div(classes: 'capability-row', [
            div(classes: 'capability-row__label', [.text('TECHNICAL WRITING')]),
            div(classes: 'capability-row__body', [
              h3([.text('Architecture Post-Mortems & Essays')]),
              p([
                .text(
                  'In-depth technical writeups on Dart/Jaspr web migration, software craftsmanship, and system design.',
                ),
              ]),
            ]),
          ]),
        ]),
      ]),
      section(classes: 'section container', [
        div(classes: 'section-marker', [
          span([.text('04 /')]),
          .text(' PROJECT CATALOGUE'),
        ]),
        div(classes: 'section-head', [
          h2(classes: 'h2', [.text('Selected Systems')]),
        ]),
        div(classes: 'projects-grid', [
          for (final p in data.projects) ProjectCard(project: p),
        ]),
        div(classes: 'mt-3', [
          Link(
            to: '/projects',
            classes: 'link',
            child: .text('All projects →'),
          ),
        ]),
      ]),
      section(classes: 'section container', [
        div(classes: 'section-marker', [
          span([.text('05 /')]),
          .text(' TECHNICAL ESSAYS'),
        ]),
        div(classes: 'section-head section-head--flip', [
          h2(classes: 'h2', [.text('Recent Writing')]),
          p(classes: 'body', [
            .text('Notes from building, migrating, and maintaining software.'),
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
                    span(classes: 'journal-card__tag', [
                      .text(article.category),
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
          Link(to: '/journal', classes: 'link', child: .text('All articles →')),
        ]),
      ]),
      section(classes: 'contact-band section', [
        div(classes: 'container contact-band__grid', [
          div(classes: 'manifesto__left', [
            div(classes: 'section-marker', [
              span([.text('06 /')]),
              .text(' MANIFESTO'),
            ]),
            p(classes: 'manifesto__quote', [
              .text('Find what others walk past. '),
              em([.text('Build something from it.')]),
              .text(' Leave notes for whoever comes next.'),
            ]),
          ]),
          div(classes: 'manifesto__right', [
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
      ]),
    ]);
  }
}
