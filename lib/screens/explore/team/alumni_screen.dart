import 'package:flexible_scrollbar/flexible_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:zineapp2023/providers/dictionary/team_dict.dart';
import 'package:zineapp2023/screens/explore/team/alumni_tile.dart';

import 'package:zineapp2023/theme/color.dart';

class AlumniScreen extends StatefulWidget {
  final List<List<Team>> teamDict;
  const AlumniScreen({super.key, required this.teamDict});

  @override
  State<AlumniScreen> createState() => _AlumniScreenState();
}

class _AlumniScreenState extends State<AlumniScreen> {
  static const year = ["second", "third", "fourth"];
  late ScrollController _scrollController;
  List<double> offsets = [0.0];

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    ///Every Cards Aspect Ratio is filled, So the height of a card will be fixed and can be calculated
    ///at runtime according to the width. The height will be (Width/2)/AspectRatio.
    ///Need to calculate this only once, set to be recalculated when its dependency changes.

    var width = MediaQuery.of(context).size.width;
    for (int i = 0; i < widget.teamDict.length; i++) {
      offsets.add(offsets[i] +
          50 +
          (widget.teamDict[i].length / 2).ceil() * width * 5 / 8);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool pinn = true;
  @override
  Widget build(BuildContext context) {
    return FlexibleScrollbar(
      scrollLabelBuilder: (p0) {
        var year = 2025 -
            offsets.indexWhere((element) => _scrollController.offset < element);
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              year.toString(),
              style: const TextStyle(color: textColor),
            ),
          ),
        );
      },
      controller: _scrollController,
      child: CustomScrollView(controller: _scrollController, slivers: [
        for (int i = 0; i < widget.teamDict.length; i++)
          SliverStickyHeader(
            sticky: true,
            header: Container(
              height: 50,
              color: iconTile,
              child: Text(
                textAlign: TextAlign.center,
                (2024 - i).toString(),
                style: const TextStyle(color: textColor, fontSize: 30),
              ),
            ),
            sliver: SliverGrid.builder(
              itemCount: widget.teamDict[i].length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 2 / 2.5),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),

                  ///The following example shows how to navigate to different sections of the page, just by their index values
                  ///
                  // child: InkWell(
                  //   onTap: () => _scrollController.animateTo(
                  //       offsets.elementAt(2),
                  //       curve: Curves.easeInOut,
                  //       duration: Duration(milliseconds: 500)),
                  //   child: Placeholder(),
                  // ),
                  child: AlumniTile(
                    alumni: widget.teamDict[i][index],
                    year: year[i],
                  ),
                );
              },
            ),
          ),
      ]),
    );
  }
}
