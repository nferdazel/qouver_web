/// Site-wide identity and contact details.
///
/// Single source of truth: the document head, the footer, the contact page,
/// and the structured data all read from these constants.
const siteName = 'Qouver';
const siteUrl = 'https://qouver.com';
const ogImageUrl = '$siteUrl/assets/og-image.webp';

/// Tagline appended to the site name in titles.
const siteTagline = 'A home for systems and ideas';

/// Default description for a page that does not supply its own.
const siteDescription =
    'Qouver finds overlooked opportunities, turns them into useful systems, '
    'and shares what it learns. $siteTagline.';

/// Public contact address shown on the contact page and in structured data.
const contactEmail = 'hello@qouver.com';

/// Project organisation on GitHub.
const githubOrgUrl = 'https://github.com/qouver';

/// Maintainer profile on GitHub.
const githubMaintainerUrl = 'https://github.com/nferdazel';
