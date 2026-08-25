import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../seo.dart';

/// Rendered for unmatched routes (Router errorBuilder) and as the static
/// `/404.html` page generated at build time.
class NotFoundPage extends StatelessComponent {
  const NotFoundPage({super.key});

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      pageHead(
        title: 'Page not found — Qouver',
        description:
            'The page you are looking for does not exist. Back to the home of systems and ideas.',
        path: '/404',
      ),
      section(classes: 'page-head container', [
        div(classes: 'page-head__meta', [
          span(classes: 'label', [.text('Error 404')]),
        ]),
        h1(classes: 'page-title', [.text('Page not found.')]),
        p(classes: 'lead mt-2', [
          .text(
            'The page you are looking for does not exist — or was prospected away.',
          ),
        ]),
      ]),
      section(classes: 'section container', [
        Link(to: '/', classes: 'link', child: .text('Back to home →')),
      ]),
    ]);
  }
}
