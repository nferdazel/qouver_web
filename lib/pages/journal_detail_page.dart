import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../data/journal.dart';
import '../routes.dart';
import '../seo.dart';
import 'not_found_page.dart';

class JournalDetailPage extends StatelessComponent {
  const JournalDetailPage({super.key, required this.slug});

  final String slug;

  @override
  Component build(BuildContext context) {
    final article = journalArticles
        .where((art) => art.slug == slug)
        .firstOrNull;

    if (article == null) {
      return const NotFoundPage();
    }

    return Component.fragment([
      pageHead(
        title: '${article.title} · Journal · Qouver',
        description: article.summary,
        path: Routes.article(slug),
        ogType: 'article',
      ),
      section(classes: 'container article-reader', [
        div(classes: 'article-reader__header', [
          Link(
            to: Routes.journal,
            classes: 'link link--dim',
            child: .text('← Back to Journal'),
          ),
          div(classes: 'article-reader__meta mt-3', [
            span(classes: 'journal-card__category', [.text(article.category)]),
            span(classes: 'label', [.text(article.date)]),
            span(classes: 'label', [.text('·')]),
            span(classes: 'label', [.text(article.readTime)]),
          ]),
          h1(classes: 'article-reader__title mt-2', [.text(article.title)]),
        ]),
        div(classes: 'article-reader__body', [
          for (final pText in article.paragraphs) p([.text(pText)]),
          if (article.quote != null)
            blockquote([
              p([.text('“${article.quote!}”')]),
            ]),
          if (article.codeSnippet != null)
            pre([
              code([.text(article.codeSnippet!)]),
            ]),
        ]),
        // The rule is its own element. It used to be a wrapper around the link
        // below, but .divider sets a 2px ink background, so putting a child in
        // it painted ink-on-ink and the link measured 1:1, i.e. invisible.
        div(classes: 'divider mt-3', []),
        div(classes: 'pt-3', [
          Link(
            to: Routes.journal,
            classes: 'link link--dim',
            child: .text('← Back to all articles'),
          ),
        ]),
      ]),
    ]);
  }
}
