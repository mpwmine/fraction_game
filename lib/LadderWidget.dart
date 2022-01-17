import 'package:flutter/material.dart';
import 'dart:math' as Math;

class LadderWidget extends StatefulWidget {
  int displayRungs;
  int pos;
  int? combo;
  LadderRung Function(BuildContext context, int value) rungBuilder;

  LadderWidget({this.displayRungs=8, this.pos=0, required this.rungBuilder, this.combo});

  @override
  _LadderWidgetState createState() => _LadderWidgetState();
}

class _LadderWidgetState extends State<LadderWidget> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  int animation_start = 0;

  @override
  void initState() {
      super.initState();
      animation_start = widget.pos;
      controller = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
      animation = controller.drive( CurveTween(curve: Curves.ease))
          ..addListener(() {
            setState(() {

            });
          });
      //controller.forward();
  }

  @override
  void didUpdateWidget(covariant LadderWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if(oldWidget.pos != widget.pos) {
      animation_start = oldWidget.pos;
      controller.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        final rungHeight = box.maxHeight / widget.displayRungs;
        final pos = animation_start + ((widget.pos - animation_start) * animation.value).truncate();
        final v = (animation.value * (widget.pos - animation_start)) % 1.0;
        return Stack(
            children: [
              Positioned(
                top: -(rungHeight * (1.0-v)),
                left: 0.0,
                child: SizedBox(
                  height: rungHeight * (widget.displayRungs + 1),
                  width: box.maxWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      for(int i=widget.displayRungs; i>=0; i--)
                        Expanded(child: widget.rungBuilder(context, _posMap(i+pos))),
                      for(var i=0; i < ((pos<0)?-pos:0); i++)
                        Expanded(child: Container()),
                    ],
                  ),
                ),
              ),
              Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  child: SizedBox(
                    height: rungHeight,
                    width: box.maxWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Transform.translate(
                              offset: Offset(-20.0,0),
                              child: Icon(Icons.chevron_right, color: Colors.red, size: 60.0,),
                            ),
                            Transform.translate(
                              offset: Offset(20.0,0),
                              child: Icon(Icons.chevron_left, color: Colors.red, size: 60.0,),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
              ),
              if(widget.combo != null)
                Positioned(
                    bottom: rungHeight * (widget.combo??1 - 1),
                    left: 0.0,
                    child: SizedBox(
                      height: rungHeight,
                      width: box.maxWidth,
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Colors.green,
                              width: 8.0
                            )
                          )
                        ),
                      ),
                    )
                ),

            ],
          );

      }
    );
  }

  int _posMap(int pos) {
    return pos > 0 ? Math.pow( 10, ((pos-1)/9).floor()+1).floor() * [25, 50, 75, 100, 125, 150, 175, 200, 225][(pos-1)%9] : 0;
  }
}

class LadderRung extends StatelessWidget {
  int label;

  LadderRung(this.label);


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: const BoxDecoration(
        border:  Border.symmetric(
          vertical:  BorderSide(
            color: Colors.white,
            width: 7.0,
          ),
          horizontal:  BorderSide(
            color: Colors.white,
          ),
        )
      ),
      child: Center(
        child: Text( label.toString(), style: theme.textTheme.headline5, ),
      ),
    );
  }


}
