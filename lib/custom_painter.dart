import 'dart:ui';

import 'package:flutter/material.dart';

class CustomPainterClass extends StatefulWidget {
  const CustomPainterClass({Key? key}) : super(key: key);

  @override
  State<CustomPainterClass> createState() => _CustomPainterClassState();
}

class _CustomPainterClassState extends State<CustomPainterClass>
    with SingleTickerProviderStateMixin {
  double _progress = 0.0;
  Animation<double>? animation;
  AnimationController? controller;
  double offset = 100;
  List<NodesFromServer> nodes = [
    NodesFromServer(1, "Node1"),
    NodesFromServer(2, "Node2"),
    NodesFromServer(3, "Node3"),
    NodesFromServer(4, "Node4"),
    NodesFromServer(5, "Node5"),
    NodesFromServer(6, "Node1"),
    NodesFromServer(7, "Node2"),
    NodesFromServer(8, "Node3"),
    NodesFromServer(9, "Node4"),
    NodesFromServer(10, "Node5"),
  ];

  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller!)
      ..addListener(() {
        setState(() {
          _progress = animation!.value;
        });
      });
    controller!.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  double width = constraints.maxWidth;
                  List<Nodes> nodesList = [];
                  for (int i = 0; i < nodes.length; i++) {
                    int secId = (i/5).floor();
                    if (i % 5 < 3) {
                      nodesList.add(Nodes(
                          Offset(width / 4 * ((i % 5) + 1), secId * 200 + 100),
                          30,
                          nodes[i]));
                    } else {
                      nodesList.add(Nodes(
                          Offset(width - (width / 3 * ((i%5)-2)), secId * 200 + 200),
                          30,
                          nodes[i]));
                    }
                  }
                  return GestureDetector(
                    onTapDown: (object) {
                      print(object.globalPosition);
                    },
                    child: CustomPaint(
                      painter: TestPathPainter1(_progress, nodesList,nodesList[0],nodesList[1]),
                      size: Size(width, height),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Nodes {
  final Offset offset;
  final double radius;
  final NodesFromServer nodes;

  Nodes(this.offset, this.radius, this.nodes);
}

class NodesFromServer {
  final int nodeId;
  final String string;

  NodesFromServer(this.nodeId, this.string);
}

class TestPathPainter1 extends CustomPainter {
  final double _progress;
  final List<Nodes> nodes;
  final Nodes node1;
  final Nodes node2;

  TestPathPainter1(this._progress, this.nodes, this.node1, this.node2);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x4c73918a);


    for(int i=1;i<nodes.length;i++){
      if(nodes[i-1].offset.dy != nodes[i].offset.dy) {
        Path path = Path();
        path.moveTo(nodes[i-1].offset.dx, nodes[i-1].offset.dy);

        if(nodes[i].offset.dx > size.width/2){
          path.quadraticBezierTo(nodes[i-1].offset.dx + 100, nodes[i-1].offset.dy+100, nodes[i].offset.dx, nodes[i].offset.dy);
          canvas.drawPath(path, paint..color = const Color(0x4c73918a)..style = PaintingStyle.stroke);
        }else{
          path.quadraticBezierTo(nodes[i-1].offset.dx - 100, nodes[i-1].offset.dy, nodes[i].offset.dx, nodes[i].offset.dy);
          canvas.drawPath(path, paint..color = const Color(0x4c73918a)..style = PaintingStyle.stroke);
        }
      }
      else{
        canvas.drawLine(nodes[i - 1].offset, nodes[i].offset, paint..color = const Color(0x4c73918a)..strokeWidth = 5);
      }
    }

    if(node1.offset.dx > size.width/2 && node1.offset.dy < node2.offset.dy){
      Path path = Path();
      Path n = Path();
      path.moveTo(node1.offset.dx, node1.offset.dy);

      path.quadraticBezierTo(node1.offset.dx + 100, node1.offset.dy+100, node2.offset.dx, node2.offset.dy);
      canvas.drawPath(path, paint..color = Colors.transparent..style = PaintingStyle.stroke);

      n.moveTo(node1.offset.dx, node1.offset.dy);
      n.quadraticBezierTo(node1.offset.dx +100, node1.offset.dy +100,calculate(_progress, path).dx, calculate(_progress, path).dy);
      canvas.drawPath(n, paint..color = Colors.red..style = PaintingStyle.stroke);
    }
    else if(node1.offset.dx > node2.offset.dx && node1.offset.dy < node2.offset.dy){
      Path path = Path();
      Path n = Path();
      path.moveTo(node1.offset.dx, node1.offset.dy);

      path.quadraticBezierTo(node1.offset.dx - 100, node1.offset.dy, node2.offset.dx, node2.offset.dy);
      canvas.drawPath(path, paint..color = Colors.transparent..style = PaintingStyle.stroke);

      n.moveTo(node1.offset.dx, node1.offset.dy);
      n.quadraticBezierTo(node1.offset.dx -100, node1.offset.dy,calculate(_progress, path).dx, calculate(_progress, path).dy);
      canvas.drawPath(n, paint..color = const Color(0xbe009f78)..style = PaintingStyle.stroke);
    }
    else{
      canvas.drawLine(node1.offset, getProgressLine(node1.offset, node2.offset, _progress),Paint()
        ..strokeWidth = 4.0
        ..color = const Color(0xff009f78)..style = PaintingStyle.stroke);
    }

    for (Nodes n in nodes) {
      var path = Path();
      var path1 = Path();
      var myPaint = Paint();
      var center = Offset(n.offset.dx, n.offset.dy);

      myPaint.color = const Color(0xff009f78);
      path.addOval(Rect.fromCircle(center: center, radius: 20.0));
      path1.addOval(Rect.fromCircle(center: center, radius: 28.0));
      canvas.drawShadow(path1, const Color(0xff009f78), 4, true);
      canvas.drawPath(path, myPaint);
    }

  }

  @override
  bool shouldRepaint(TestPathPainter1 oldDelegate) {
    return oldDelegate._progress != _progress;
  }
}


Offset calculate(double value,path) {
  PathMetrics pathMetrics = path!.computeMetrics();
  PathMetric pathMetric = pathMetrics.elementAt(0);
  value = pathMetric.length * value;
  Tangent? pos = pathMetric.getTangentForOffset(value);
  return pos!.position;
}

Offset getProgressLine(Offset node1,Offset node2,double progress){
  return Offset(((1-progress)*node1.dx + progress*node2.dx), ((1-progress)*node1.dy + progress*node2.dy));
}