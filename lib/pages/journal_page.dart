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
            'Notes on software craft, architecture decisions, and building systems.',
          ),
        ]),
      ]),
      section(classes: 'section container', [
        div(classes: 'journal-grid', [
          for (final article in journalArticles)
            Link(
              to: '/journal/${article.slug}',
              classes: 'journal-card',
              children: [
                div([
                  div(classes: 'journal-card__meta', [
                    span([.text(article.date)]),
                    span(classes: 'journal-card__dot', [.text('·')]),
                    span(classes: 'journal-card__category', [
                      .text(article.category),
                    ]),
                    span(classes: 'journal-card__dot', [.text('·')]),
                    span(classes: 'journal-card__time', [
                      .text(article.readTime),
                    ]),
                  ]),
                  h3(classes: 'journal-card__title', [.text(article.title)]),
                  p(classes: 'journal-card__summary', [.text(article.summary)]),
                ]),
                div(classes: 'journal-card__foot', [
                  span(classes: 'link-action', [.text('Read Article →')]),
                ]),
              ],
            ),
        ]),
      ]),
    ]);
  }
}
