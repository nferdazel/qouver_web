import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// The Qouver Q monogram — a ring holding a single dot (the find, brought
/// home), its tail still tracing the prospector's sweep that led there.
class QMark extends StatelessComponent {
  const QMark({super.key, this.size = '32', this.classes});

  final String size;
  final String? classes;

  @override
  Component build(BuildContext context) {
    return svg(
      classes: classes,
      attributes: {
        'width': size,
        'height': size,
        'viewBox': '0 0 64 64',
        'fill': 'none',
        'aria-hidden': 'true',
      },
      const [
        circle(
          [],
          attributes: {
            'cx': '26',
            'cy': '26',
            'r': '18',
            'stroke': 'currentColor',
            'stroke-width': '6.5',
          },
        ),
        path(
          [],
          d: 'M37 37 C42 42, 47 47, 52 52',
          attributes: {
            'stroke': 'currentColor',
            'stroke-width': '6.5',
            'stroke-linecap': 'round',
          },
        ),
        circle(
          [],
          attributes: {'cx': '31', 'cy': '31', 'r': '5', 'fill': 'currentColor'},
        ),
      ],
    );
  }
}
