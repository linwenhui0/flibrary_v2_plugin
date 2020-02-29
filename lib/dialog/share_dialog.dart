import 'package:flutter/material.dart';
import 'package:flibrary_plugin/dialog/items_dialog.dart' show OnItemBuilder;

/// TODO 分享对话框
class ShareDialog extends StatelessWidget {
  final Color backgroundColor;

  final int crossAxisCount;
  final double childAspectRatio;
  final BorderRadius borderRadius;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  const ShareDialog(
      {Key key,
      this.backgroundColor: Colors.white,
      this.crossAxisCount: 4,
      this.childAspectRatio: 1,
      this.itemCount,
      this.itemBuilder,
      this.borderRadius: BorderRadius.zero})
      : assert(itemBuilder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
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
    );
  }
}

/// TODO 从底部显示分享对话框
class ShareBottomAnimationDialog extends StatefulWidget {
  final Color backgroundColor;

  final int crossAxisCount;
  final double childAspectRatio;
  final BorderRadius borderRadius;
  final int itemCount;
  final OnItemBuilder itemBuilder;
  final Duration animationRunTime;

  const ShareBottomAnimationDialog(
      {Key key,
      this.backgroundColor,
      this.crossAxisCount,
      this.childAspectRatio,
      this.borderRadius,
      this.itemCount,
      this.itemBuilder,
      this.animationRunTime: const Duration(milliseconds: 300)})
      : assert(itemBuilder != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ShareBottomAnimationState();
  }
}

class _ShareBottomAnimationState extends State<ShareBottomAnimationDialog>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: widget.animationRunTime);
    controller.addStatusListener(onExitAnimation);
    animation = createAnimation();
    controller.forward();
  }

  Animation createAnimation() {
    Animation enterAnimation =
        Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(controller);
    return enterAnimation;
  }

  void onExitAnimation(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller?.removeStatusListener(onExitAnimation);
    controller?.dispose();
    controller = null;
  }

  void onDismissDialog() {
    if (controller?.isAnimating != true) {
      controller?.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismissDialog,
      child: Material(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SlideTransition(
            position: animation,
            child: ShareDialog(
                backgroundColor: widget.backgroundColor,
                crossAxisCount: widget.crossAxisCount,
                childAspectRatio: widget.childAspectRatio,
                borderRadius: widget.borderRadius,
                itemCount: widget.itemCount,
                itemBuilder: (context, index) {
                  return widget.itemBuilder(context, index, onDismissDialog);
                }),
          ),
        ),
      ),
    );
  }
}
