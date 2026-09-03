/// Project catalogue for the Qouver umbrella.
///
/// Facts verified 2026-09-03 from ~/Projects/* + live endpoints:
/// - SKYWARD live (skyward.qouver.com 200), Go simulation engine on the VPS.
/// - MAJADU's Go API live (api.qouver.com/majadu/healthz 200); client app is
///   community-maintained (framing per user decision, do not change).
/// - SDS MANAGEMENT live (sds.qouver.com 200); client (Bayer) not named on site.
/// - M-DEF retired — mdef.qouver.com no longer resolves (000); superseded by
///   Majadu's built-in ratings.
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
    tagline: 'Airline tycoon simulation.',
    description:
        'Run your own airline: build a fleet, open routes, and grow an economy that keeps moving while you\'re away. The whole world runs on a server-side simulation engine — your device just plays it — so everything stays fair and consistent. Live now at skyward.qouver.com.',
    focus: ['Simulation', 'Strategy', 'Systems design'],
    status: 'Live',
    stack: 'Flutter · Go · Postgres',
    url: 'https://skyward.qouver.com',
  ),
  Project(
    index: '02',
    name: 'Majadu Tools',
    category: 'Community systems',
    tagline: 'Systems that keep a community running.',
    description:
        'The backend that keeps a badminton community running: court scheduling, live scoring, tournaments, and skill ratings that carry across seasons. Qouver builds and operates the Go API behind it, in production today — the mobile app is community-maintained.',
    focus: ['Scheduling', 'Live scoring', 'Ratings', 'Community growth'],
    status: 'Backend',
    stack: 'Go · Postgres · OpenAPI',
    url: 'https://api.qouver.com/majadu',
    urlLabel: 'API',
  ),
  Project(
    index: '03',
    name: 'SDS Management',
    category: 'Compliance',
    tagline: 'Chemical safety data management.',
    description:
        'A compliance tool that keeps chemical safety data sheets current and auditable: versioned documents, hazard pictograms, and clean PDF exports. In production for a real workplace.',
    focus: ['Compliance', 'Documentation', 'Workflow'],
    status: 'Live',
    stack: 'Vue · Go · Postgres',
    url: 'https://sds.qouver.com',
  ),
  Project(
    index: '04',
    name: 'M-DEF',
    category: 'Analytics',
    tagline: 'Badminton analytics platform.',
    description:
        'A leaderboard and analytics platform built for a real badminton community — powered by a custom rating engine that weighed how convincingly you won and kept ratings honest when players went quiet. It ran in production with live rankings and seasonal standings; its ideas now live on inside Majadu.',
    focus: ['Ranking systems', 'Statistics', 'Community insights'],
    status: 'Archived',
    stack: 'Flutter · Supabase / Postgres',
  ),
];
