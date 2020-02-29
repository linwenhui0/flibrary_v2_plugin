import 'package:flibrary_plugin/model/menu.dart';
import 'package:flutter/material.dart';
import 'message_dialog.dart' show IndexedButtonDivideWidgetBuilder;

typedef OnItemBuilder = Widget Function(
    BuildContext context, int index, VoidCallback dialog);

class ItemDialog extends StatelessWidget {
  final TitleMenu titleMenu;
  final Color titleDividerColor;

  final double cancelMarginTop;
  final TitleMenu cancelMenu;

  final double borderRadius;
  final Color backgroundColor;
  final int itemCount;
  final OnItemBuilder itemBuilder;
  final IndexedButtonDivideWidgetBuilder itemDividerBuilder;
  final VoidCallback onCloseDialog;

  const ItemDialog(
      {Key key,
      this.titleMenu: const TitleMenu(),
      this.titleDividerColor: Colors.grey,
      this.cancelMarginTop: 8,
      this.cancelMenu: const TitleMenu(),
      this.borderRadius: 8,
      this.backgroundColor: Colors.white,
      this.itemCount: 3,
      this.itemBuilder,
      this.itemDividerBuilder,
      this.onCloseDialog})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Offstage(
        child: buildTitle(),
        offstage: !titleMenu.showTitle,
      ),
      Divider(
        height: 1,
        thickness: 1,
        color: titleDividerColor,
      ),
    ];

    for (int index = 0; index < itemCount; index++) {
      children.add(itemBuilder(context, index, onCloseDialog));
      if (index != itemCount - 1) {
        children.add(itemDividerBuilder(context, index));
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(borderRadius)),
          child: Column(
            children: children,
            mainAxisSize: MainAxisSize.min,
          ),
        ),
        Offstage(
          child: Padding(
            padding: EdgeInsets.only(top: cancelMarginTop),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: buildCancel(context),
            ),
          ),
          offstage: !cancelMenu.showTitle,
        ),
      ],
    );
  }

  Widget buildTitle() {
    return titleMenu.widget ??
        GestureDetector(
          child: SizedBox(
            height: titleMenu.height,
            child: DecoratedBox(
              decoration: BoxDecoration(color: titleMenu.titleBackground),
              child: Center(
                child: Text(
                  titleMenu.title,
                  maxLines: 1,
                  style: titleMenu.titleTextStyle,
                ),
              ),
            ),
          ),
          onTap: () {},
        );
  }

  Widget buildCancel(BuildContext context) {
    return cancelMenu.widget ??
        InkWell(
          onTap: onCloseDialog,
          child: SizedBox(
            height: cancelMenu.height,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: cancelMenu.titleBackground,
              ),
              child: Center(
                child: Text(
                  cancelMenu.title,
                  maxLines: 1,
                  style: cancelMenu.titleTextStyle,
                ),
              ),
            ),
          ),
        );
  }
}

class ItemBottomAnimationDialog extends StatefulWidget {
  final TitleMenu titleMenu;
  final Color titleDividerColor;

  final double cancelMarginTop;
  final TitleMenu cancelMenu;

  final EdgeInsets margin;
  final double borderRadius;
  final Color backgroundColor;
  final int itemCount;
  final OnItemBuilder itemBuilder;
  final IndexedButtonDivideWidgetBuilder itemDividerBuilder;
  final Duration animationRunTime;

  const ItemBottomAnimationDialog(
      {Key key,
      this.titleMenu: const TitleMenu(),
      this.titleDividerColor: Colors.white,
      this.cancelMarginTop: 0,
      this.cancelMenu: const TitleMenu(),
      this.margin: EdgeInsets.zero,
      this.borderRadius: 8,
      this.backgroundColor: Colors.white,
      this.itemCount: 3,
      this.itemBuilder,
      this.itemDividerBuilder,
      this.animationRunTime: const Duration(milliseconds: 300)})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ItemBottomAnimationState();
  }
}

class _ItemBottomAnimationState extends State<ItemBottomAnimationDialog>
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

  void onCloseDialog() {
    if (controller?.isAnimating != true) {
      controller?.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCloseDialog,
      child: Material(
        child: Padding(
          padding: widget.margin,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: animation,
              child: ItemDialog(
                  titleMenu: widget.titleMenu,
                  titleDividerColor: widget.titleDividerColor,
                  cancelMarginTop: widget.cancelMarginTop,
                  cancelMenu: widget.cancelMenu,
                  borderRadius: widget.borderRadius,
                  backgroundColor: widget.backgroundColor,
                  itemCount: widget.itemCount,
                  itemBuilder: widget.itemBuilder,
                  itemDividerBuilder: widget.itemDividerBuilder,
                  onCloseDialog: onCloseDialog),
            ),
          ),
        ),
        color: Colors.transparent,
      ),
    );
  }
}
