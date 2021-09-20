import 'package:figma_remote/src/converters/arguments/border_radius.dart';
import 'package:rfw/formats.dart';
import 'package:figma/figma.dart' as figma;

BlobNode wrapBackgroundBlurred(
  BlobNode node,
  List<figma.Effect>? effects,
  List<num>? rectangleCornerRadii,
) {
  if (effects == null) {
    return node;
  }

  final blurs = effects
      .where(
        (e) => e.type == figma.EffectType.backgroundBlur,
      )
      .toList();

  if (blurs.isEmpty) {
    return node;
  }

  for (var effect in effects) {
    node = ConstructorCall(
      'BackdropFilter',
      {
        'child': node,
        'filter': {
          'type': 'blur',
          'sigmaX': effect.radius,
          'sigmaY': effect.radius,
        }
      },
    );
  }

  final borderRadius = convertBorderRadius(rectangleCornerRadii);

  return ConstructorCall(
    'ClipRRect',
    {
      'borderRadius': borderRadius,
      'child': node,
    },
  );
}