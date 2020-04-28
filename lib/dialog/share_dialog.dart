import 'package:flutter/material.dart';

/// TODO 分享对话框
class ShareDialog extends StatelessWidget {
  final Color backgroundColor;

  final int crossAxisCount;
  final double childAspectRatio;
  final BorderRadius borderRadius;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final Alignment alignment;

  const ShareDialog(
      {Key key,
      this.backgroundColor: Colors.white,
      this.crossAxisCount: 4,
      this.childAspectRatio: 1,
      this.itemCount,
      this.itemBuilder,
      this.alignment: Alignment.topCenter,
      this.borderRadius: BorderRadius.zero})
      : assert(itemBuilder != null),
        assert(alignment != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: DecoratedBox(
        decoration: BoxDecoration(color: backgroundColor),
        child: GridView.builder(
            physics: new NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: this.childAspectRatio,
                crossAxisCount: this.crossAxisCount,
                mainAxisSpacing: 0),
            shrinkWrap: true,
            itemCount: itemCount,
            itemBuilder: itemBuilder),
      ),
    );
  }
}
