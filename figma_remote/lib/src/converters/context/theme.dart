import 'package:figma_remote/src/helpers/naming.dart';
import 'package:rfw/rfw.dart';
import 'package:collection/collection.dart';

import 'context.dart';

class FigmaResourceTheme<T> {
  FigmaResourceTheme(this.name, this.context);

  final FigmaComponentContext context;

  final String name;

  final Map<String, T> _values = {};

  String create(T value, String name) {
    /// Normalized name
    final baseName = createFieldName(name);
    name = baseName;

    final existingValue = _values.entries.firstWhereOrNull(
      (resource) =>
          const DeepCollectionEquality().equals(resource.value, value),
    );

    if (existingValue != null) {
      return existingValue.key;
    }

    /// Create a new resource
    int index = 0;
    while (_values.containsKey(name)) {
      index++;
      name = '$baseName$index';
    }

    _values[name] = value;

    return name;
  }

  DynamicMap toMap() {
    return _values;
  }
}

class FigmaComponentTheme {
  FigmaComponentTheme(FigmaComponentContext context)
      : colors = FigmaResourceTheme<num>('color', context),
        spacing = FigmaResourceTheme<num>('spacing', context),
        textStyles = FigmaResourceTheme<DynamicMap>('textStyles', context);

  final FigmaResourceTheme<num> colors;
  final FigmaResourceTheme<num> spacing;
  final FigmaResourceTheme<DynamicMap> textStyles;

  DynamicMap toMap() {
    return {
      'colors': colors.toMap(),
      'spacing': spacing.toMap(),
      'textStyles': textStyles.toMap(),
    };
  }
}
