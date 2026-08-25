import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// The Qouver Q monogram — a ring with a tail ending in a dot:
/// the find at the end of the prospector's sweep.
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
          attributes: {
            'cx': '54',
            'cy': '54',
            'r': '5',
            'fill': 'currentColor',
          },
        ),
      ],
    );
  }
}
