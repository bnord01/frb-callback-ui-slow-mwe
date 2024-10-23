import 'package:flutter/material.dart';
import 'package:app/src/rust/api/simple.dart';
import 'package:app/src/rust/frb_generated.dart';

Future<void> main() async {
  await RustLib.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Draggable Boxes with Rust',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Drag a box around and keep at it for a while'),
        ),
        body: const DraggableBoxes(),
      ),
    );
  }
}

class DraggableBoxes extends StatelessWidget {
  final double _boxSize = 100;

  const DraggableBoxes({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DraggableBox(id: "blue", boxSize: _boxSize, color: Colors.blue),
        DraggableBox(
            id: "red",
            boxSize: _boxSize,
            color: Colors.red,
            initialX: 150,
            initialY: 150),
      ],
    );
  }
}

class DraggableBox extends StatefulWidget {
  final String id;
  final double boxSize;
  final Color color;
  final double initialX;
  final double initialY;

  const DraggableBox({
    super.key,
    required this.id,
    required this.boxSize,
    required this.color,
    this.initialX = 0,
    this.initialY = 0,
  });

  @override
  DraggableBoxState createState() => DraggableBoxState();
}

class DraggableBoxState extends State<DraggableBox> {
  late double _xPosition;
  late double _yPosition;
  double _dragX = 0;
  double _dragY = 0;

  @override
  void initState() {
    super.initState();
    _xPosition = widget.initialX;
    _yPosition = widget.initialY;
    observeBox(id: widget.id).listen((event) {
      setState(() {
        _xPosition = event.$1;
        _yPosition = event.$2;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _xPosition,
      top: _yPosition,
      child: GestureDetector(
        onPanUpdate: (details) {
          _dragX += details.delta.dx;
          _dragY += details.delta.dy;
          moveBox(id: widget.id, x: _dragX, y: _dragY);
        },
        onPanStart: (details) {
          _dragX = _xPosition;
          _dragY = _yPosition;
        },
        child: Container(
          width: widget.boxSize,
          height: widget.boxSize,
          color: widget.color,
        ),
      ),
    );
  }
}
