import 'package:flutter/material.dart';

class CustomBottomAppBar extends StatefulWidget {
  final FloatingActionButtonLocation fabLocation;
  final NotchedShape? shape;
  List<int> type = [0];

  CustomBottomAppBar({
    this.fabLocation = FloatingActionButtonLocation.centerDocked,
    this.shape = const AutomaticNotchedShape(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    this.type = const [0],
  });

  @override
  State<CustomBottomAppBar> createState() => _CustomBottomAppBarState();
}

class _CustomBottomAppBarState extends State<CustomBottomAppBar> {

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: widget.shape,
      color: Colors.blue,
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
          children: <Widget>[
            Ink(
              height: 40,
              width: 40,
              decoration: ShapeDecoration(
                color: widget.type[0] == 0 ? Colors.white : Colors.blue,
                shape: const CircleBorder(),
              ),
              child: IconButton(
                tooltip: 'Divididos',
                isSelected: widget.type[0] == 0,
                selectedIcon: const Icon(Icons.check, color: Colors.blue),
                icon: const Icon(Icons.check, color: Colors.white),
                onPressed: () {
                  setState(() {
                    widget.type[0] = 0;
                  });
                },
              ),
            ),
            Ink(
              height: 40,
              width: 40,
              decoration: ShapeDecoration(
                color: widget.type[0] == 1 ? Colors.white : Colors.blue,
                shape: const CircleBorder(),
              ),
              child: IconButton(
                tooltip: 'Divididos',
                isSelected: widget.type[0] == 1,
                selectedIcon: const Icon(Icons.arrow_upward, color: Colors.blue),
                icon: const Icon(Icons.arrow_upward, color: Colors.white),
                onPressed: () {
                  setState(() {
                    widget.type[0] = 1;
                  });
                },
              ),
            ),
            Ink(
              height: 40,
              width: 40,
              decoration: ShapeDecoration(
                color: widget.type[0] == 2 ? Colors.white : Colors.blue,
                shape: const CircleBorder(),
              ),
              child: IconButton(
                tooltip: 'Divididos',
                isSelected: widget.type[0] == 2,
                selectedIcon: const Icon(Icons.arrow_downward, color: Colors.blue),
                icon: const Icon(Icons.arrow_downward, color: Colors.white),
                onPressed: () {
                  setState(() {
                    widget.type[0] = 2;
                  });
                },
              ),
            ),
            Ink(
              height: 40,
              width: 40,
              decoration: ShapeDecoration(
                color: widget.type[0] == 3 ? Colors.white : Colors.blue,
                shape: const CircleBorder(),
              ),
              child: IconButton(
                tooltip: 'Divididos',
                isSelected: widget.type[0] == 3,
                selectedIcon: const Icon(Icons.group, color: Colors.blue),
                icon: const Icon(Icons.group, color: Colors.white),
                onPressed: () {
                  setState(() {
                    widget.type[0] = 3;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}