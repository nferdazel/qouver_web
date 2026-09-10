import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../data/journal.dart';
import '../seo.dart';

class JournalPage extends StatelessComponent {
  const JournalPage({super.key});

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      pageHead(
        title: 'Journal — Qouver',
        description:
            'Notes on systems, software craft, architecture, and independent building.',
        path: '/journal',
      ),
      section(classes: 'page-head container', [
        h1(classes: 'page-title', [.text('Journal')]),
        p(classes: 'lead mt-2', [
          .text(
            'Notes on software craft, architecture decisions, and systems design.',
          ),
        ]),
      ]),
      section(classes: 'section container', [
        div(classes: 'journal-list', [
          for (final articleItem in journalArticles)
            article(classes: 'journal-item', [
              h2(classes: 'journal-item__title', [
                Link(
                  to: '/journal/${articleItem.slug}',
                  child: .text('${articleItem.title} →'),
                ),
              ]),
              p(classes: 'journal-item__summary mt-2', [
                .text(articleItem.summary),
              ]),
              div(classes: 'journal-item__meta mt-3', [
                span([.text(articleItem.date)]),
                span(classes: 'journal-item__dot', [.text('·')]),
                span(classes: 'journal-item__category', [
                  .text(articleItem.category),
                ]),
                span(classes: 'journal-item__dot', [.text('·')]),
                span(classes: 'journal-item__time', [
                  .text(articleItem.readTime),
                ]),
              ]),
            ]),
        ]),
      ]),
    ]);
  }
}
