import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// The Qouver Q monogram: an optically balanced geometric ring holding a single
/// focal dot (the find, brought home), its sweeping arc tail tracing the prospector's sweep.
class QMark extends StatelessComponent {
  const QMark({
    super.key,
    this.size = '32',
    this.classes,
    this.accentDot = false,
  });

  final String size;
  final String? classes;
  final bool accentDot;

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
      [
        circle(
          [],
          classes: 'q-mark__ring',
          attributes: {
            'cx': '27',
            'cy': '27',
            'r': '17.5',
            'stroke': 'currentColor',
            'stroke-width': '4.5',
          },
        ),
        path(
          [],
          d: 'M 37.5 37.5 C 44 44, 49 48, 54 51.5',
          classes: 'q-mark__tail',
          attributes: {
            'stroke': 'currentColor',
            'stroke-width': '4.5',
            'stroke-linecap': 'round',
          },
        ),
        circle(
          [],
          classes: accentDot
              ? 'q-mark__dot q-mark__dot--accent'
              : 'q-mark__dot',
          attributes: {
            'cx': '27',
            'cy': '27',
            'r': '4.2',
            'fill': 'currentColor',
          },
        ),
      ],
    );
  }
}
