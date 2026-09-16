import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../seo.dart';
import '../site.dart';

class ContactPage extends StatelessComponent {
  const ContactPage({super.key});

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      pageHead(
        title: 'Contact · Qouver',
        description:
            'Get in touch with Qouver, a home for systems and ideas. hello@qouver.com, github.com/qouver.',
        path: '/contact',
      ),
      section(classes: 'page-head container', [
        h1(classes: 'page-title', [.text('Contact')]),
        p(classes: 'lead mt-2', [
          .text(
            'Questions, a project idea, or just something worth talking about: direct is fine.',
          ),
        ]),
      ]),
      section(classes: 'manifesto section', [
        div(classes: 'container', [
          div(classes: 'contact-list', [
            div(classes: 'contact-row', [
              span(classes: 'contact-row__label', [.text('Email')]),
              a(classes: 'contact-row__value', href: 'mailto:$contactEmail', [
                .text(contactEmail),
              ]),
              span(classes: 'contact-row__note', [
                .text('Replies within a day or two'),
              ]),
            ]),
            div(classes: 'contact-row', [
              span(classes: 'contact-row__label', [.text('GitHub (org)')]),
              a(
                classes: 'contact-row__value',
                href: githubOrgUrl,
                target: Target.blank,
                attributes: {'rel': 'noopener'},
                [.text('github.com/qouver')],
              ),
            ]),
            div(classes: 'contact-row', [
              span(classes: 'contact-row__label', [
                .text('GitHub (maintainer)'),
              ]),
              a(
                classes: 'contact-row__value',
                href: githubMaintainerUrl,
                target: Target.blank,
                attributes: {'rel': 'noopener'},
                [.text('github.com/nferdazel')],
              ),
            ]),
          ]),
        ]),
      ]),
    ]);
  }
}
