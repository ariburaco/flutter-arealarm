import 'package:flutter/material.dart';
import 'package:flutter_template/core/base/extension/context_extension.dart';
import 'package:flutter_template/view/utils/provider/alarm_provider.dart';
import 'package:provider/provider.dart';

Positioned buildFocusSwitch(BuildContext context) {
  return Positioned(
    top: 12,
    left: 12,
    child: Container(
      width: 110,
      height: 50,
      decoration: BoxDecoration(
        color: context.colors.background.withOpacity(0.5),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(1, 2), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Focus",
            style: context.textTheme.subtitle1,
          ),
          Switch(
              splashRadius: 20,
              value: Provider.of<AlarmProvider>(context, listen: false)
                  .getFocusMode,
              onChanged: (bool val) {
                Provider.of<AlarmProvider>(context, listen: false)
                    .changeFocus(val);
              }),
        ],
      ),
    ),
  );
}
