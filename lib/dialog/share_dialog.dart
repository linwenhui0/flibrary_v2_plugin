import 'package:flutter/material.dart';
import 'message_dialog.dart' show IndexedButtonWidgetBuilder;

class ShareDialog extends StatelessWidget {
  final Color backgroundColor;
  final Alignment alignment;

  final int crossAxisCount;
  final double childAspectRatio;
  final BorderRadius borderRadius;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double itemSpacing;

  const ShareDialog(
      {Key key,
      this.backgroundColor: Colors.white,
      this.alignment: Alignment.bottomCenter,
      this.itemSpacing: 0,
      this.crossAxisCount: 4,
      this.childAspectRatio: 1,
      this.itemCount,
      this.itemBuilder,
      this.borderRadius: BorderRadius.zero})
      : assert(itemBuilder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Align(
        alignment: this.alignment,
        child: DecoratedBox(
          decoration: BoxDecoration(color: backgroundColor),
          child: GridView.builder(
              physics: new NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: this.childAspectRatio,
                  crossAxisCount: this.crossAxisCount,
                  mainAxisSpacing: this.itemSpacing),
              shrinkWrap: true,
              itemCount: itemCount,
              itemBuilder: itemBuilder),
        ),
      ),
    );
  }
}
