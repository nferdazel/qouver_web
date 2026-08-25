import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../seo.dart';

class AboutPage extends StatelessComponent {
  const AboutPage({super.key});

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      pageHead(
        title: 'About — Qouver',
        description:
            'Qouver is a home for systems and ideas. The story of the name, the Systems Prospector archetype, and the philosophy behind the umbrella.',
        path: '/about',
      ),
      section(classes: 'page-head container', [
        div(classes: 'page-head__meta', [
          span(classes: 'label', [.text('About')]),
        ]),
        h1(classes: 'page-title', [
          .text(
            'A name that came from nowhere — and was kept because it was worth keeping.',
          ),
        ]),
        p(classes: 'lead mt-2', [
          .text(
            'Qouver is not a startup, not an AI company, not a software house. It is a home for systems and ideas.',
          ),
        ]),
      ]),
      section(classes: 'section container', [
        div(classes: 'editorial', [
          div(classes: 'editorial__label', [.text('01 / Origin')]),
          div([
            h2(classes: 'h3', [.text('Quousever → Qouver')]),
            p(classes: 'body mt-2', [
              .text(
                'The name began as the output of a random username generator: ',
              ),
              strong([.text('Quousever')]),
              .text(
                '. Rather than discarding it, it was refined, simplified, and evolved into ',
              ),
              strong([.text('Qouver')]),
              .text('.'),
            ]),
            p(classes: 'body', [
              .text(
                'That process is the philosophy itself — finding value where others might not look, and shaping it into something worth keeping.',
              ),
            ]),
          ]),
        ]),
        div(classes: 'editorial mt-3', [
          div(classes: 'editorial__label', [.text('02 / Archetype')]),
          div([
            h2(classes: 'h3', [.text('The Systems Prospector')]),
            p(classes: 'body mt-2', [
              .text(
                'The archetype behind Qouver is not "founder". It is closer to a prospector — one who:',
              ),
            ]),
            ul(classes: 'project-row__focus', [
              li([.text('Finds hidden opportunities')]),
              li([.text('Sees patterns others ignore')]),
              li([.text('Identifies gaps in existing systems')]),
              li([.text('Builds solutions around those gaps')]),
              li([.text('Documents and shares what is learned')]),
            ]),
          ]),
        ]),
        div(classes: 'editorial mt-3', [
          div(classes: 'editorial__label', [.text('03 / Philosophy')]),
          div([
            h2(classes: 'h3', [
              .text('Find value. Build systems. Share knowledge.'),
            ]),
            p(classes: 'body mt-2', [
              .text(
                'Valuable opportunities hide in software, communities, data, processes, and knowledge. The goal is not merely to discover them — it is to transform them into useful systems.',
              ),
            ]),
            p(classes: 'body', [
              .text(
                'Systems are built not because they are profitable, but because they are interesting, useful, and worth exploring.',
              ),
            ]),
          ]),
        ]),
        div(classes: 'editorial mt-3', [
          div(classes: 'editorial__label', [.text('04 / Boundaries')]),
          div([
            div(classes: 'compare', [
              div(classes: 'compare__col compare__col--is', [
                h3([.text('Qouver is')]),
                ul([
                  li([.text('A home for systems and ideas')]),
                  li([.text('A headquarters for experiments')]),
                  li([.text('An independent collection of projects')]),
                  li([
                    .text(
                      'Open to research, software, communities, and simulations',
                    ),
                  ]),
                ]),
              ]),
              div(classes: 'compare__col', [
                h3([.text('Qouver is not')]),
                ul([
                  li([.text('Tied to a single industry')]),
                  li([.text('An AI-only company')]),
                  li([.text('A badminton organization')]),
                  li([.text('A software consultancy')]),
                  li([.text('A startup limited to one product')]),
                ]),
              ]),
            ]),
          ]),
        ]),
        div(classes: 'editorial mt-3', [
          div(classes: 'editorial__label', [.text('05 / Who’s behind')]),
          div([
            h2(classes: 'h3', [.text('A solo prospector')]),
            p(classes: 'body mt-2', [
              .text('Qouver is built and maintained by '),
              strong([.text('sachiel')]),
              .text(' — '),
              a(
                href: 'https://github.com/nferdazel',
                target: Target.blank,
                attributes: {'rel': 'noopener'},
                [.text('nferdazel')],
              ),
              .text(
                ' on GitHub — a systems-minded builder iterating in public. No team, no pitch deck — just experiments that are interesting, useful, and worth sharing.',
              ),
            ]),
            p(classes: 'body', [
              .text('Photo coming soon — for now the work speaks.'),
            ]),
          ]),
        ]),
        div(classes: 'editorial mt-3', [
          div(classes: 'editorial__label', [.text('06 / Vision')]),
          div([
            h2(classes: 'h3', [
              .text('An enduring home for systems and ideas'),
            ]),
            p(classes: 'body mt-2', [
              .text(
                'A place where communities can grow, knowledge can accumulate, experiments can evolve, and software can mature — regardless of how any individual project succeeds or fails.',
              ),
            ]),
            p(classes: 'body', [
              .text('Projects may come and go. Qouver remains.'),
            ]),
          ]),
        ]),
      ]),
      section(classes: 'manifesto section', [
        div(classes: 'container', [
          p(classes: 'manifesto__quote', [
            .text('If something contains hidden value that others overlook — '),
            em([
              .text(
                'find it, understand it, improve it, turn it into a system, and share what you learn.',
              ),
            ]),
          ]),
          div(classes: 'manifesto__row', [
            span(classes: 'label label--dark', [.text('Guiding principle')]),
            Link(
              to: '/contact',
              classes: 'link link--dark',
              child: .text('Get in touch →'),
            ),
          ]),
        ]),
      ]),
    ]);
  }
}
