import 'package:flutter/material.dart';
import '../../base/extension/context_extension.dart';

class IconNormal extends StatelessWidget {
  const IconNormal({
    Key? key,
    required this.icon,
  }) : super(key: key);

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: context.colors.primaryVariant);
  }
}
