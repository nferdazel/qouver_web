/// The entrypoint for the **server** environment.
///
/// The [main] method is executed on the server during static generation
/// (`jaspr build`). To run code on the client, check the `main.client.dart` file.
library;

import 'dart:io' show Platform;

import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import 'app.dart';

// This file is generated automatically by Jaspr, do not remove or edit.
// ignore: uri_has_not_been_generated
import 'main.server.options.dart';

/// The Umami tracking script URL, from the `UMAMI_SCRIPT_URL` env var.
///
/// Only present when analytics is explicitly enabled at build time — the site
/// ships zero-JavaScript by default.
final String? umamiScriptUrl = Platform.environment['UMAMI_SCRIPT_URL'];

/// The Umami website id, from the `UMAMI_WEBSITE_ID` env var.
final String? umamiWebsiteId = Platform.environment['UMAMI_WEBSITE_ID'];

void main() {
  // Initializes the server environment with the generated default options.
  Jaspr.initializeApp(options: defaultServerOptions);

  // [Document] renders the root document structure (<html>, <head> and <body>)
  // with the provided parameters and components.
  runApp(
    Document(
      title: 'Qouver — A home for systems and ideas',
      lang: 'en',
      meta: {
        'description':
            'Qouver finds overlooked opportunities, turns them into useful systems, and shares what it learns. A home for systems and ideas.',
        'theme-color': '#16130D',
      },
      head: [
        link(rel: 'icon', type: 'image/svg+xml', href: 'assets/q-mark.svg'),
        link(
          rel: 'apple-touch-icon',
          href: 'assets/icons/apple-touch-icon.png',
        ),
        link(rel: 'manifest', href: 'site.webmanifest'),
        link(
          rel: 'preload',
          href: 'fonts/ibm-plex-sans-var.woff2',
          as: 'font',
          type: 'font/woff2',
          attributes: {'crossorigin': ''},
        ),
        link(
          rel: 'preload',
          href: 'fonts/ibm-plex-mono-400.woff2',
          as: 'font',
          type: 'font/woff2',
          attributes: {'crossorigin': ''},
        ),
        link(rel: 'stylesheet', href: 'fonts.css'),
        link(rel: 'stylesheet', href: 'styles.css'),
        // Umami analytics (self-hosted). Injected only when configured via env
        // during build — by default the site ships with zero JavaScript.
        //   UMAMI_SCRIPT_URL=https://analytics.qouver.com/script.js \
        //   UMAMI_WEBSITE_ID=<id> ./scripts/build.sh
        if (umamiScriptUrl case final url?)
          script(
            src: url,
            defer: true,
            attributes: {'data-website-id': umamiWebsiteId ?? ''},
          ),
      ],
      body: App(),
    ),
  );
}
