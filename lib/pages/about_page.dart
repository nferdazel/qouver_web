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
            'Qouver is a home for systems and ideas. Independent software craft, production principles, and open documentation.',
        path: '/about',
      ),
      section(classes: 'page-head container', [
        h1(classes: 'page-title', [.text('About Qouver')]),
        p(classes: 'lead mt-2', [
          .text(
            'Qouver is an umbrella home for software systems, tools, and technical experiments — designed and maintained with disciplined software craft.',
          ),
        ]),
      ]),
      section(classes: 'section container', [
        div(classes: 'editorial', [
          div(classes: 'editorial__label', [.text('01 / Builder')]),
          div([
            h2(classes: 'h3', [.text('One craftsman working in public')]),
            p(classes: 'body mt-2', [
              .text('Qouver is built and maintained by '),
              strong([.text('Sachiel')]),
              .text(' — '),
              a(
                href: 'https://github.com/nferdazel',
                target: Target.blank,
                attributes: {'rel': 'noopener'},
                [.text('@nferdazel')],
              ),
              .text(
                ' on GitHub. An independent systems builder focusing on tools that solve real problems.',
              ),
            ]),
            p(classes: 'body', [
              .text(
                'No pitch decks, no corporate bloat — just software designed with high standards of reliability, performance, and maintainability.',
              ),
            ]),
          ]),
        ]),
        div(classes: 'editorial mt-3', [
          div(classes: 'editorial__label', [.text('02 / Principles')]),
          div([
            h2(classes: 'h3', [.text('Production Readiness > Prototype Hype')]),
            p(classes: 'body mt-2', [
              .text(
                'We do not build disposable demos. Systems are engineered to run continuously in production, handle real user workloads, and earn their place.',
              ),
            ]),
            h2(classes: 'h3 mt-3', [
              .text('Authoritative Engines & Static-First Web'),
            ]),
            p(classes: 'body mt-2', [
              .text(
                'Business logic and calculations belong on deterministic backend servers. The web tier stays zero-JS, static, and lightning fast.',
              ),
            ]),
            h2(classes: 'h3 mt-3', [
              .text('Document Everything & Share Knowledge'),
            ]),
            p(classes: 'body mt-2', [
              .text(
                'Every trade-off, architecture decision, and lesson learned is written down — so the next problem starts with clarity rather than a blank page.',
              ),
            ]),
          ]),
        ]),
        div(classes: 'editorial mt-3', [
          div(classes: 'editorial__label', [.text('03 / Stack')]),
          div([
            h2(classes: 'h3', [.text('Production Infrastructure')]),
            p(classes: 'body mt-2', [
              .text(
                'Built with standard-library Go, PostgreSQL, Flutter, and Jaspr. Deployed using rootless Podman containers behind Caddy TLS on independent Linux VPS host.',
              ),
            ]),
          ]),
        ]),
      ]),
      section(classes: 'manifesto section', [
        div(classes: 'container', [
          p(classes: 'manifesto__quote', [
            .text('Find value in what others walk past. '),
            em([
              .text(
                'Build useful systems from it, and write down what you learned.',
              ),
            ]),
          ]),
          div(classes: 'manifesto__row', [
            span(classes: 'manifesto__lbl', [.text('Guiding principle')]),
            Link(
              to: '/contact',
              classes: 'link-action link-action--light',
              child: .text('Get in touch →'),
            ),
          ]),
        ]),
      ]),
    ]);
  }
}
