import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:flutter_expandable_table/flutter_expandable_table.dart';

const Color primaryColor = Color(0xFF1e2f36); //corner
const Color accentColor = Color(0xFF0d2026); //background
const TextStyle textStyle = TextStyle(color: Colors.white);
const TextStyle textStyleSubItems = TextStyle(color: Colors.grey);

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExpandableTable Example',
      theme: ThemeData(primarySwatch: Colors.grey),
      home: const MyHomePage(),
      scrollBehavior: AppCustomScrollBehavior(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class DefaultCellCard extends StatelessWidget {
  final Widget child;

  const DefaultCellCard({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      margin: const EdgeInsets.all(1),
      child: child,
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  _buildCell(String content, {CellBuilder? builder}) {
    return ExpandableTableCell(
      child: builder != null
          ? null
          : DefaultCellCard(
              child: Center(
                child: Text(
                  content,
                  style: textStyle,
                ),
              ),
            ),
      builder: builder,
    );
  }

  ExpandableTableCell _buildFirstRowCell() {
    return ExpandableTableCell(
      builder: (context, details) => Container(
        decoration: const BoxDecoration(
          color: Colors.red,
          border: Border(
            right: BorderSide(color: Colors.white),
            left: BorderSide(color: Colors.white),
            bottom: BorderSide(color: Colors.white),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 25.0,
              child: details.row?.children != null
                  ? AnimatedRotation(
                      duration: const Duration(milliseconds: 500),
                      turns: details.row?.childrenExpanded == true ? 0.25 : 0,
                      child: const Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Wrap(
                  spacing: 10.0,
                  children: [],
                ),
                const SizedBox(width: 3.0),
                Center(
                  child: PopupMenuButton(
                    child: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                    itemBuilder: (context) => [
                      const PopupMenuItem(child: Text("Panther1")),
                      const PopupMenuItem(child: Text("Panther2")),
                      const PopupMenuItem(child: Text("Panther3")),
                    ],
                  ),
                ),
                const SizedBox(width: 3.0),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static const int columnsCount = 20;
  static const int subColumnsCount = 2;
  int rowsCount = 6;
  static const int subRowsCount = 5;
  static const int totalColumns = columnsCount + subColumnsCount;

  List<ExpandableTableRow> _generateRows(int quantity, {int depth = 0}) {
    bool generateLegendRow = (depth == 0 || depth == 2);
    return List.generate(
      quantity,
      (rowIndex) => ExpandableTableRow(
        firstCell: _buildFirstRowCell(),
        children: ((rowIndex == 3 || rowIndex == 2) && depth < 3)
            ? _generateRows(subRowsCount, depth: depth + 1)
            : null,
        cells: List<ExpandableTableCell>.generate(
          totalColumns,
          (columnIndex) => _buildCell('Cell $rowIndex:$columnIndex'),
        ),
        // legend: generateLegendRow && (rowIndex == 3 || rowIndex == 2)
        //     ? const DefaultCellCard(
        //         child: Align(
        //           alignment: FractionalOffset.centerLeft,
        //           child: Padding(
        //             padding: EdgeInsets.only(left: 24.0),
        //             child: Text(
        //               'This is row legend',
        //               style: textStyle,
        //             ),
        //           ),
        //         ),
        //       )
        //     : null,
      ),
    );
  }

  ExpandableTable _buildExpandableTable() {
    //Creation header
    List<ExpandableTableHeader> subHeader = List.generate(
      subColumnsCount,
      (index) => ExpandableTableHeader(
        cell: _buildCell('Sub Column $index'),
      ),
    );

    //Creation header
    List<ExpandableTableHeader> headers = List.generate(
      columnsCount,
      (index) => ExpandableTableHeader(
        cell: _buildCell(
            '${index == 1 ? 'Expandable\nColumn' : 'Column'} $index'),
        children: index == 1 ? subHeader : null,
      ),
    );
    return ExpandableTable(
      summaryBelowFooter: false,
      summary: const Text(
        "Wow it works",
        style: TextStyle(color: Colors.black),
      ),
      footer: ElevatedButton(
          onPressed: () {
            setState(() {
              rowsCount = 20;
            });
          },
          child: const Text("Footer")),
      firstHeaderCell: _buildCell('Actions'),
      rows: _generateRows(rowsCount),
      headers: headers,
      defaultsRowHeight: 60,
      defaultsColumnWidth: 150,
      headerHeight: 45.0,
      firstColumnWidth: 60,
      // scrollShadowColor: accentColor,
      visibleScrollbar: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            '   Simple Table                    |                    Expandable Table'),
        centerTitle: true,
      ),
      // backgroundColor: accentColor,
      body: _buildExpandableTable(),
      // body: Container(
      //   color: accentColor,
      //   child: Row(
      //     children: [
      //       Expanded(
      //         child: Padding(
      //           padding: const EdgeInsets.all(20.0),
      //           child: _buildSimpleTable(),
      //         ),
      //       ),
      //       Expanded(
      //         child: Padding(
      //           padding: const EdgeInsets.all(20.0),
      //           child: _buildExpandableTable(),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}

class AppCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}
