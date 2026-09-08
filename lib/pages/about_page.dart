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
            'Qouver is not a startup, not a consultancy, not an AI company. It is a home for systems and ideas — built and maintained by one person.',
          ),
        ]),
      ]),
      section(classes: 'section container', [
        div(classes: 'editorial', [
          div(classes: 'editorial__label', [.text('01 / Origin')]),
          div([
            h2(classes: 'h3', [.text('Quousever → Qouver')]),
            p(classes: 'body mt-2', [
              .text('The name started as random generator output: '),
              strong([.text('Quousever')]),
              .text('. Rather than discard it, it was refined into '),
              strong([.text('Qouver')]),
              .text('. That process — finding latent value and shaping it into something worth keeping — is the whole philosophy.'),
            ]),
            p(classes: 'body', [
              .text(
                'The archetype behind it is not "founder". It\'s closer to a prospector: someone who finds what others miss, sees the pattern, identifies the gap, builds the solution, and documents what was learned.',
              ),
            ]),
          ]),
        ]),
        div(classes: 'editorial mt-3', [
          div(classes: 'editorial__label', [.text('02 / Philosophy')]),
          div([
            h2(classes: 'h3', [
              .text('Find value. Build systems. Document everything.'),
            ]),
            p(classes: 'body mt-2', [
              .text(
                'Valuable things hide in software, communities, data, and process. The goal is not to discover them — it is to turn them into systems that work in production and stand up over time.',
              ),
            ]),
            p(classes: 'body', [
              .text(
                'Systems are built because they are worth building. That\'s the only bar.',
              ),
            ]),
          ]),
        ]),
        div(classes: 'editorial mt-3', [
          div(classes: 'editorial__label', [.text('03 / Boundaries')]),
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
          div(classes: 'editorial__label', [.text('04 / Who’s behind')]),
          div([
            h2(classes: 'h3', [.text('One person.')]),
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
                ' on GitHub — a systems-minded builder who works in public. No team, no pitch deck — just experiments worth doing.',
              ),
            ]),
          ]),
        ]),
        div(classes: 'editorial mt-3', [
          div(classes: 'editorial__label', [.text('05 / Vision')]),
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
            .text('Something has value that others miss. '),
            em([
              .text(
                'Find it, understand it, build something from it, and write down what you learned.',
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
