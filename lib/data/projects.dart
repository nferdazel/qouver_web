/// Project catalogue for the Qouver umbrella.
///
/// Facts verified 2026-08-15: SKYWARD and MDEF are live at their
/// subdomains; MAJADU's Go API is live at api.qouver.com.
class Project {
  final String index;
  final String name;
  final String category;
  final String tagline;
  final String description;
  final List<String> focus;
  final String status;
  final String stack;
  final String? url;
  final String urlLabel;

  const Project({
    required this.index,
    required this.name,
    required this.category,
    required this.tagline,
    required this.description,
    required this.focus,
    required this.status,
    required this.stack,
    this.url,
    this.urlLabel = 'VISIT',
  });
}

const projects = <Project>[
  Project(
    index: '01',
    name: 'Skyward',
    category: 'Simulation',
    tagline: 'Airline simulation platform.',
    description:
        'An airline-tycoon simulation where the backend owns the world: authoritative economy, fleet, routes, and a live season clock. Every action is validated server-side — the client only commands.',
    focus: ['Simulation', 'Systems design', 'Strategy'],
    status: 'Live',
    stack: 'Flutter · Supabase / Postgres',
    url: 'https://skyward.qouver.com',
  ),
  Project(
    index: '02',
    name: 'M-DEF',
    category: 'Analytics',
    tagline: 'Badminton analytics platform.',
    description:
        'A leaderboard and analytics platform for a badminton community, built on the MAJADU Dynamic-Elo Framework — a custom rating engine with margin-of-victory weighting and inactivity decay. In production use — live rankings, match logs, and seasonal standings for a real community.',
    focus: ['Statistics', 'Ranking systems', 'Community insights'],
    status: 'Live',
    stack: 'Flutter · Supabase / Postgres',
    url: 'https://mdef.qouver.com',
  ),
  Project(
    index: '03',
    name: 'Majadu Tools',
    category: 'Community systems',
    tagline: 'Systems that keep a community running.',
    description:
        'Scheduling, session and ranking systems for a badminton community. Qouver builds and operates the Go API behind them — REST with optimistic concurrency, OpenAPI contracts, and a Postgres backend. The client app is community-maintained.',
    focus: ['Operations', 'Scheduling', 'Rankings', 'Community growth'],
    status: 'Backend',
    stack: 'Go · Postgres · OpenAPI',
    url: 'https://api.qouver.com/majadu',
    urlLabel: 'API',
  ),
];
