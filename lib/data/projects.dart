/// Technical case study data for a project.
class CaseStudy {
  final String title;
  final String overview;
  final String problem;
  final String architecture;
  final List<(String heading, String explanation)> decisions;
  final String takeaways;

  const CaseStudy({
    required this.title,
    required this.overview,
    required this.problem,
    required this.architecture,
    required this.decisions,
    required this.takeaways,
  });
}

/// Project catalogue for the Qouver umbrella.
///
/// Facts verified 2026-09-03 from ~/Projects/* + live endpoints:
/// - SKYWARD live (skyward.qouver.com 200), Go simulation engine on the VPS.
/// - MAJADU's Go API live (api.qouver.com/majadu/healthz 200); client app is
///   community-maintained (framing per user decision, do not change).
/// - SDS MANAGEMENT live (sds.qouver.com 200); client (Bayer) not named on site.
/// - M-DEF retired, mdef.qouver.com no longer resolves (000); superseded by
///   Majadu's built-in ratings.
class Project {
  final String index;
  final String slug;
  final String name;
  final String category;
  final String tagline;
  final String description;
  final List<String> focus;
  final String status;
  final String stack;
  final String? url;
  final String urlLabel;
  final CaseStudy? caseStudy;

  const Project({
    required this.index,
    required this.slug,
    required this.name,
    required this.category,
    required this.tagline,
    required this.description,
    required this.focus,
    required this.status,
    required this.stack,
    this.url,
    this.urlLabel = 'VISIT',
    this.caseStudy,
  });
}

const projects = <Project>[
  Project(
    index: '01',
    slug: 'skyward',
    name: 'Skyward',
    category: 'Simulation',
    tagline: 'Airline tycoon simulation.',
    description:
        'Run your own airline: build a fleet, open routes, and grow an economy that keeps moving while you\'re away. The whole world runs on a server-side simulation engine, so your device just plays it and everything stays fair and consistent. Live now at skyward.qouver.com.',
    focus: ['Simulation', 'Strategy', 'Systems design'],
    status: 'Live',
    stack: 'Flutter · Go · Postgres',
    url: 'https://skyward.qouver.com',
    caseStudy: CaseStudy(
      title: 'Server-Side Tick Simulation Engine & Authoritative State',
      overview:
          'Skyward is an airline management game where global economy, route calculations, fuel burn, and passenger demand operate continuously on a backend tick worker in Go.',
      problem:
          'Client-side calculated simulations suffer from device clock tampering, battery drain during offline calculation, and state divergence across mobile and desktop clients.',
      architecture:
          'An authoritative Go 1.22+ backend executes a scheduled world tick loop, persisting state in PostgreSQL 18. The Flutter client (Web & Desktop) acts as a pure, reactive viewer rendering streamed server snapshots.',
      decisions: [
        (
          'Zero client simulation logic',
          'The Flutter client contains no financial or flight trajectory formulas. All flight paths, fuel consumption, and market yields are calculated strictly on the backend.',
        ),
        (
          'Deterministic world tick loop',
          'World ticks execute at fixed server intervals. When a player logs in after days away, the backend processes past tick windows deterministically without melting client memory.',
        ),
        (
          'ACID transaction isolation',
          'All airline financial operations use strict PostgreSQL database transactions to prevent double-spending or route duplication under concurrent player actions.',
        ),
      ],
      takeaways:
          'Moving simulation authority entirely to Go backend workers guarantees 100% fair play, zero client-side cheat vectors, and instant synchronization between Web and Desktop clients.',
    ),
  ),
  Project(
    index: '02',
    slug: 'majadu',
    name: 'Majadu Tools',
    category: 'Community systems',
    tagline: 'Systems that keep a community running.',
    description:
        'The backend that keeps a badminton community running: court scheduling, live scoring, tournaments, and skill ratings that carry across seasons. Qouver builds and operates the Go API behind it, in production today. The mobile app is community-maintained.',
    focus: ['Scheduling', 'Live scoring', 'Ratings', 'Community growth'],
    status: 'Backend',
    stack: 'Go · Postgres · OpenAPI',
    url: 'https://api.qouver.com/majadu',
    urlLabel: 'API',
    caseStudy: CaseStudy(
      title: 'Glicko-1 Rating Engine & Frameworkless Go API',
      overview:
          'Majadu powers local sports session operations: balanced doubles matchups, live court scoring, tournament brackets, and cross-season skill rating tracking.',
      problem:
          'Casual sports sessions suffer from subjective player seeding, manual paper scorekeeping, and network drops during live matches in sports halls with weak cellular coverage.',
      architecture:
          'A monorepo with a React 19 PWA frontend and a zero-dependency Go 1.26 backend API using PostgreSQL 18 with schema-based multi-tenancy.',
      decisions: [
        (
          'Frameworkless Go backend',
          'Built using Go standard library net/http and pgx/v5. Sub-millisecond response times and instant cold starts inside rootless Podman containers.',
        ),
        (
          'Glicko-1 rating with confidence decay',
          'Replaced raw win/loss tallies with a custom Glicko-1 rating engine (Glicko-1-lite) that factors in victory margin and increases rating deviation when players skip seasons.',
        ),
        (
          'Schema-isolated multi-tenancy',
          'Community databases use PostgreSQL search paths per seasonal domain rather than row-level tenant IDs, simplifying backup and data isolation.',
        ),
      ],
      takeaways:
          'Standard-library Go code paired with a disciplined mathematical rating model delivers high production reliability with near-zero server resource usage.',
    ),
  ),
  Project(
    index: '03',
    slug: 'sds',
    name: 'SDS Management',
    category: 'Compliance',
    tagline: 'Chemical safety data management.',
    description:
        'A compliance tool that keeps chemical safety data sheets current and auditable: versioned documents, hazard pictograms, and clean PDF exports. In production for a real workplace.',
    focus: ['Compliance', 'Documentation', 'Workflow'],
    status: 'Live',
    stack: 'Vue · Go · Postgres',
    url: 'https://sds.qouver.com',
    caseStudy: CaseStudy(
      title: 'Audit-Ready Document Versioning & Server PDF Pipeline',
      overview:
          'Workplace compliance management system for chemical Safety Data Sheets (SDS/MSDS): versioned hazard documentation, pictogram matrix, and automated PDF export pipeline.',
      problem:
          'Industrial chemical compliance demands immutable document versioning, exact GHS hazard pictogram mapping, and immediate PDF availability for workplace safety audits.',
      architecture:
          'Vue 3 + TypeScript single-page application frontend paired with a Go REST API backend and a headless Chromium PDF rendering service running inside Podman containers.',
      decisions: [
        (
          'Headless Chromium PDF export',
          'Server-side Chromium rendering guarantees 100% pixel-identical PDF exports across all browsers and devices for safety inspection audits.',
        ),
        (
          'Immutable document versioning',
          'Updates to safety data sheets never overwrite existing records. Every safety revision increments an immutable version index with complete audit trails.',
        ),
        (
          'GHS Pictogram Matrix',
          'Chemical hazards map directly to GHS pictograms rendered as inline SVGs for instant visual identification during emergency chemical lookups.',
        ),
      ],
      takeaways:
          'Server-side document rendering guarantees regulatory compliance fidelity across all audit devices and print media.',
    ),
  ),
  Project(
    index: '04',
    slug: 'mdef',
    name: 'M-DEF',
    category: 'Analytics',
    tagline: 'Badminton analytics platform.',
    description:
        'A leaderboard and analytics platform built for a real badminton community, powered by a custom rating engine that weighed how convincingly you won and kept ratings honest when players went quiet. It ran in production with live rankings and seasonal standings; its ideas now live on inside Majadu.',
    focus: ['Ranking systems', 'Statistics', 'Community insights'],
    status: 'Archived',
    stack: 'Flutter · Supabase / Postgres',
    caseStudy: CaseStudy(
      title: 'Lessons from an Early Badminton Analytics Engine',
      overview:
          'An early leaderboard and analytics platform built for recreational badminton leagues, providing dynamic player ratings and match statistics before being superseded by Majadu.',
      problem:
          'Tracking player standings across unstructured recreational matches required a dynamic ranking model before backend APIs were unified.',
      architecture:
          'Flutter frontend client paired with Supabase / PostgreSQL backend, featuring a custom rating algorithm weighing win margins and inactivity decay.',
      decisions: [
        (
          'Inactivity decay penalty',
          'Rankings automatically decayed when players stopped competing, preventing inactive players from occupying top leaderboard positions indefinitely.',
        ),
        (
          'Retirement & algorithm migration',
          'When Majadu was established, M-DEF was retired and its core rating algorithms were extracted and rewritten in Go for Majadu API.',
        ),
      ],
      takeaways:
          'Retiring early standalone experiments in favor of unified backend APIs keeps system maintenance low while preserving core algorithm IP.',
    ),
  ),
];
