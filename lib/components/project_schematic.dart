import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Renders a clean architectural SVG vector schematic for each system.
class ProjectSchematic extends StatelessComponent {
  const ProjectSchematic({super.key, required this.slug});

  final String slug;

  @override
  Component build(BuildContext context) {
    return div(classes: 'project-schematic', [
      switch (slug) {
        'skyward' => _buildSkywardSchematic(),
        'majadu' => _buildMajaduSchematic(),
        'sds' => _buildSdsSchematic(),
        'mdef' => _buildMdefSchematic(),
        _ => _buildDefaultSchematic(),
      },
    ]);
  }

  Component _buildSkywardSchematic() {
    return svg(
      attributes: {
        'viewBox': '0 0 400 160',
        'fill': 'none',
        'stroke': 'currentColor',
      },
      classes: 'schematic-svg',
      [
        line(
          [],
          attributes: {
            'x1': '20',
            'y1': '140',
            'x2': '380',
            'y2': '140',
            'stroke-dasharray': '4 4',
            'opacity': '0.3',
          },
        ),
        line(
          [],
          attributes: {
            'x1': '20',
            'y1': '20',
            'x2': '20',
            'y2': '140',
            'stroke-dasharray': '4 4',
            'opacity': '0.3',
          },
        ),
        path(
          [],
          d: 'M 30 130 Q 150 20 370 70',
          attributes: {
            'stroke': 'var(--bronze)',
            'stroke-width': '2.5',
            'fill': 'none',
          },
        ),
        circle(
          [],
          attributes: {'cx': '30', 'cy': '130', 'r': '4', 'fill': 'var(--ink)'},
        ),
        circle(
          [],
          attributes: {
            'cx': '190',
            'cy': '52',
            'r': '5',
            'fill': 'var(--bronze)',
          },
        ),
        circle(
          [],
          attributes: {'cx': '370', 'cy': '70', 'r': '4', 'fill': 'var(--ink)'},
        ),
      ],
    );
  }

  Component _buildMajaduSchematic() {
    return svg(
      attributes: {
        'viewBox': '0 0 400 160',
        'fill': 'none',
        'stroke': 'currentColor',
      },
      classes: 'schematic-svg',
      [
        rect(
          [],
          attributes: {
            'x': '30',
            'y': '30',
            'width': '100',
            'height': '100',
            'stroke': 'var(--ink)',
            'stroke-width': '1.5',
            'rx': '4',
          },
        ),
        rect(
          [],
          attributes: {
            'x': '150',
            'y': '30',
            'width': '100',
            'height': '100',
            'stroke': 'var(--bronze)',
            'stroke-width': '2',
            'rx': '4',
          },
        ),
        rect(
          [],
          attributes: {
            'x': '270',
            'y': '30',
            'width': '100',
            'height': '100',
            'stroke': 'var(--ink)',
            'stroke-width': '1.5',
            'rx': '4',
          },
        ),
        line(
          [],
          attributes: {
            'x1': '130',
            'y1': '80',
            'x2': '150',
            'y2': '80',
            'stroke-width': '2',
            'stroke': 'var(--bronze)',
          },
        ),
        line(
          [],
          attributes: {
            'x1': '250',
            'y1': '80',
            'x2': '270',
            'y2': '80',
            'stroke-width': '2',
            'stroke': 'var(--bronze)',
          },
        ),
        circle(
          [],
          attributes: {
            'cx': '80',
            'cy': '80',
            'r': '16',
            'stroke': 'var(--ink-3)',
          },
        ),
        path(
          [],
          d: 'M 180 65 L 220 95 M 220 65 L 180 95',
          attributes: {'stroke': 'var(--bronze)', 'stroke-width': '2'},
        ),
      ],
    );
  }

  Component _buildSdsSchematic() {
    return svg(
      attributes: {
        'viewBox': '0 0 400 160',
        'fill': 'none',
        'stroke': 'currentColor',
      },
      classes: 'schematic-svg',
      [
        rect(
          [],
          attributes: {
            'x': '40',
            'y': '20',
            'width': '140',
            'height': '120',
            'stroke': 'var(--ink)',
            'stroke-width': '1.5',
            'rx': '2',
          },
        ),
        line(
          [],
          attributes: {
            'x1': '60',
            'y1': '45',
            'x2': '140',
            'y2': '45',
            'stroke-width': '2',
            'stroke': 'var(--bronze)',
          },
        ),
        line(
          [],
          attributes: {
            'x1': '60',
            'y1': '65',
            'x2': '160',
            'y2': '65',
            'stroke-width': '1.5',
            'stroke': 'var(--ink-3)',
          },
        ),
        line(
          [],
          attributes: {
            'x1': '60',
            'y1': '85',
            'x2': '130',
            'y2': '85',
            'stroke-width': '1.5',
            'stroke': 'var(--ink-3)',
          },
        ),
        path(
          [],
          d: 'M 180 80 L 240 80',
          attributes: {'stroke': 'var(--bronze)', 'stroke-width': '2'},
        ),
        rect(
          [],
          attributes: {
            'x': '240',
            'y': '40',
            'width': '120',
            'height': '80',
            'stroke': 'var(--bronze)',
            'stroke-width': '2',
            'rx': '4',
          },
        ),
      ],
    );
  }

  Component _buildMdefSchematic() {
    return svg(
      attributes: {
        'viewBox': '0 0 400 160',
        'fill': 'none',
        'stroke': 'currentColor',
      },
      classes: 'schematic-svg',
      [
        path(
          [],
          d: 'M 200 25 L 280 50 V 100 C 280 130 200 145 200 145 C 200 145 120 130 120 100 V 50 Z',
          attributes: {
            'stroke': 'var(--bronze)',
            'stroke-width': '2.5',
            'fill': 'none',
          },
        ),
        circle(
          [],
          attributes: {
            'cx': '200',
            'cy': '85',
            'r': '18',
            'stroke': 'var(--ink)',
            'stroke-width': '2',
          },
        ),
        line(
          [],
          attributes: {
            'x1': '50',
            'y1': '85',
            'x2': '120',
            'y2': '85',
            'stroke-dasharray': '4 4',
            'stroke': 'var(--ink-3)',
          },
        ),
        line(
          [],
          attributes: {
            'x1': '280',
            'y1': '85',
            'x2': '350',
            'y2': '85',
            'stroke-dasharray': '4 4',
            'stroke': 'var(--ink-3)',
          },
        ),
      ],
    );
  }

  Component _buildDefaultSchematic() {
    return svg(
      attributes: {
        'viewBox': '0 0 400 160',
        'fill': 'none',
        'stroke': 'currentColor',
      },
      classes: 'schematic-svg',
      [
        rect(
          [],
          attributes: {
            'x': '40',
            'y': '30',
            'width': '320',
            'height': '100',
            'stroke': 'var(--line)',
            'stroke-width': '1.5',
          },
        ),
      ],
    );
  }
}
