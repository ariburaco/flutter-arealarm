import 'package:flutter/material.dart';
import '../../../core/base/extension/context_extension.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerText extends StatelessWidget {
  const ShimmerText({
    Key? key,
    required this.text,
    required this.duration,
    this.fontSize,
    this.textStyle,
  }) : super(key: key);

  final String text;
  final int duration;
  final double? fontSize;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Shimmer.fromColors(
        period: Duration(milliseconds: duration),
        baseColor: context.colors.primary,
        highlightColor: context.colors.secondary,
        child: Container(
          child: Text(
            text,
            style: textStyle == null
                ? TextStyle(
                    color: context.colors.primary,
                    fontSize: fontSize,
                  )
                : textStyle,
          ),
        ),
      ),
    );
  }
}
