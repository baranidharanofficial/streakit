import 'package:flutter/material.dart';
import 'package:streakit/constants.dart';

class CustomGridView extends StatelessWidget {
  const CustomGridView({
    super.key,
    required this.crossAxisCount,
    required this.length,
    required this.widgetOfIndex,
    this.crossAxisSpacing = 0,
    this.mainAxisSpacing = 0,
    this.physics,
    this.shrinkWrap = false,
  });

  final int crossAxisCount;
  final int length;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final Widget Function(int index) widgetOfIndex;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: EdgeInsets.only(
        top: sizeConfig.large,
      ),
      itemCount: (length / crossAxisCount).ceil(),
      itemBuilder: (BuildContext context, int listIndex) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List<Widget>.generate(
            crossAxisCount,
            (int index) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right:
                        index < crossAxisCount - 1 ? crossAxisSpacing / 2 : 0,
                    left: index > 0 ? crossAxisSpacing / 2 : 0,
                    bottom: mainAxisSpacing,
                  ),
                  child: listIndex * crossAxisCount + index < length
                      ? widgetOfIndex(listIndex * crossAxisCount + index)
                      : const SizedBox(),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
