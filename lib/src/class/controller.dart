// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:flutter_expandable_table/flutter_expandable_table.dart';

/// [ExpandableTableController] class.
class ExpandableTableController extends ChangeNotifier {
  late ExpandableTableCell _firstHeaderCell;

  /// [firstHeaderCell] is the top left cell, i.e. the first header cell.
  /// `required`
  ExpandableTableCell get firstHeaderCell => _firstHeaderCell;

  set firstHeaderCell(ExpandableTableCell value) {
    _firstHeaderCell = value;
    notifyListeners();
  }

  late List<ExpandableTableHeader> _headers;

  /// [headers] contains the list of all column headers,
  /// each one of these can contain a list of further headers,
  /// this allows you to create nested and expandable columns.
  /// Not to be used if the [controller] is used.
  /// `required`
  List<ExpandableTableHeader> get headers => _headers;

  set headers(List<ExpandableTableHeader> value) {
    _removeHeadersListener();
    _headers = value;
    _addHeadersListener();
    notifyListeners();
  }

  ///
  late List<ExpandableTableRow> tableRows;

  /// [rows] contains the list of all the rows of the table,
  /// each of these can contain a list of further rows,
  /// this allows you to create nested and expandable rows.
  /// Not to be used if the [controller] is used.
  /// `required`
  List<ExpandableTableRow> get rows => tableRows;

  late double _headerHeight;

  /// [headerHeight] is the height of each column header, i.e. the first row.
  /// `Default: 188`
  double get headerHeight => _headerHeight;

  set headerHeight(double value) {
    _headerHeight = value;
    notifyListeners();
  }

  late double _firstColumnWidth;

  /// [firstColumnWidth] determines first Column width size.
  ///
  /// Default: [200]
  double get firstColumnWidth => _firstColumnWidth;

  set firstColumnWidth(double value) {
    _firstColumnWidth = value;
    notifyListeners();
  }

  late double _defaultsColumnWidth;

  /// [defaultsColumnWidth] defines the default width of all columns,
  /// it is possible to redefine it for each individual column.
  /// Default: [120]
  double get defaultsColumnWidth => _defaultsColumnWidth;

  set defaultsColumnWidth(double value) {
    _defaultsColumnWidth = value;
    notifyListeners();
  }

  late double _defaultsRowHeight;

  /// [defaultsRowHeight] defines the default height of all rows,
  /// it is possible to redefine it for every single row.
  /// Default: [50]
  double get defaultsRowHeight => _defaultsRowHeight;

  set defaultsRowHeight(double value) {
    _defaultsRowHeight = value;
    notifyListeners();
  }

  bool _visibleScrollbar = false;

  /// [visibleScrollbar] determines visibility of scrollbar.
  ///
  /// Default: [false]
  bool get visibleScrollbar => _visibleScrollbar;

  set visibleScrollbar(bool value) {
    _visibleScrollbar = value;
    notifyListeners();
  }

  /// [duration] determines duration rendered animation of Rows/Columns expansion.
  ///
  /// Default: [500ms]
  final Duration duration;

  /// [curve] determines rendered curve animation of Rows/Columns expansion.
  ///
  /// Default: [Curves.fastOutSlowIn]
  final Curve curve;

  /// [scrollShadowDuration] determines duration rendered animation of shadows.
  ///
  /// Default: [500ms]
  final Duration scrollShadowDuration;

  /// [scrollShadowCurve] determines rendered curve animation of shadows.
  ///
  /// Default: [Curves.fastOutSlowIn]
  final Curve scrollShadowCurve;

  /// [scrollShadowColor] determines rendered color of shadows.
  ///
  /// Default: [Colors.transparent]
  final Color scrollShadowColor;

  /// [scrollShadowSize] determines size of shadows.
  ///
  /// Default: [10]
  final double scrollShadowSize;

  /// [footerHeight] for the height of footer widget
  final double? footerHeight;

  /// [footer] is the Widget at the bottom of the rows
  final Widget? footer;

  /// [summaryBelowFooter] place[summary] above or below [footer]
  final bool summaryBelowFooter;

  /// [summaryAlignment] alignment for summary widget [summary]
  final Alignment? summaryAlignment;

  /// [summaryPadding] padding for [summary] widget might be either right or left
  final double? summaryPadding;

  /// [summary] is the Widget at the bottom of the rows below or to footer
  final Widget? summary;

  set rows(List<ExpandableTableRow> value) {
    _removeRowsListener();
    tableRows = value;
    _addRowsListener();
    notifyListeners();
  }

  ///
  void updateValues({
    required ExpandableTableCell firstHeaderCell,
    required List<ExpandableTableHeader> headers,
    required List<ExpandableTableRow> rows,
    double headerHeight = 188,
    double firstColumnWidth = 200,
    double defaultsColumnWidth = 120,
    double defaultsRowHeight = 50,
  }) {
    _firstHeaderCell = firstHeaderCell;
    _headerHeight = headerHeight;
    _firstColumnWidth = firstColumnWidth;
    _defaultsColumnWidth = defaultsColumnWidth;
    _defaultsRowHeight = defaultsRowHeight;
    _headers = headers;
    tableRows = rows;
    _addHeadersListener();
    _addRowsListener();
    notifyListeners();
  }

  /// [ExpandableTableController] class constructor.
  ExpandableTableController({
    required ExpandableTableCell firstHeaderCell,
    required List<ExpandableTableHeader> headers,
    required List<ExpandableTableRow> rows,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.fastOutSlowIn,
    this.scrollShadowDuration = const Duration(milliseconds: 500),
    this.scrollShadowCurve = Curves.fastOutSlowIn,
    this.scrollShadowColor = Colors.transparent,
    this.scrollShadowSize = 10,
    this.footerHeight = 45.0,
    this.footer,
    this.summaryBelowFooter = true,
    this.summaryAlignment,
    this.summaryPadding,
    this.summary,
    double headerHeight = 188,
    double firstColumnWidth = 200,
    double defaultsColumnWidth = 120,
    double defaultsRowHeight = 50,
  }) {
    _firstHeaderCell = firstHeaderCell;
    _headerHeight = headerHeight;
    _firstColumnWidth = firstColumnWidth;
    _defaultsColumnWidth = defaultsColumnWidth;
    _defaultsRowHeight = defaultsRowHeight;
    _headers = headers;
    tableRows = rows;

    /// todo: define local variable for Footer and its related variables
    /// todo: define local variable for Summary and its related variables
    /// todo: to handle the controller declaration of variable also
    ///
    _addHeadersListener();
    _addRowsListener();
  }

  void _addHeadersListener() {
    for (var i = 0; i < _headers.length; i++) {
      _headers[i].addListener(_listener);
      _headers[i].index = i;
    }
  }

  void _removeHeadersListener() {
    for (var header in _headers) {
      header.removeListener(_listener);
    }
  }

  void _addRowsListener() {
    for (var i = 0; i < tableRows.length; i++) {
      tableRows[i].addListener(_listener);
      tableRows[i].index = i;
    }
  }

  void _removeRowsListener() {
    for (var row in tableRows) {
      row.removeListener(_listener);
    }
  }

  @override
  void dispose() {
    _removeHeadersListener();
    _removeRowsListener();
    super.dispose();
  }

  _listener() => notifyListeners();

  /// [allHeaders] returns all table headers, visible and not, including nested ones.
  List<ExpandableTableHeader> get allHeaders => _getAllHeaders(headers);

  /// [visibleHeaders] returns all visible table headers, including nested ones.
  List<ExpandableTableHeader> get visibleHeaders =>
      allHeaders.where((element) => element.visible).toList();

  /// [visibleHeadersWidth] returns the overall width of all visible table headers, including nested ones
  double get visibleHeadersWidth => visibleHeaders
      .map<double>((e) => e.width ?? defaultsColumnWidth)
      .fold(0, (a, b) => a + b);

  List<ExpandableTableHeader> _getAllHeaders(
      List<ExpandableTableHeader> headers) {
    List<ExpandableTableHeader> cells = [];
    for (var header in headers) {
      cells.add(header);
      if (header.children != null) {
        cells.addAll(_getAllHeaders(header.children!));
      }
    }
    return cells;
  }

  /// [allRows] returns all table rows, visible and not, including nested ones.
  List<ExpandableTableRow> get allRows => _getAllRows(rows);

  /// [visibleRows] returns all visible table rows, including nested ones.
  List<ExpandableTableRow> get visibleRows =>
      allRows.where((element) => element.visible).toList();

  /// [visibleHeadersWidth] returns the overall width of all visible table rows, including nested ones
  double get visibleRowsHeight => visibleRows
      .map<double>((e) => e.height ?? defaultsRowHeight)
      .fold(0, (a, b) => a + b);

  List<ExpandableTableRow> _getAllRows(List<ExpandableTableRow> rows) {
    List<ExpandableTableRow> rowsTmp = [];
    for (var row in rows) {
      rowsTmp.add(row);
      if (row.children != null) {
        rowsTmp.addAll(_getAllRows(row.children!));
      }
    }
    return rowsTmp;
  }
}
