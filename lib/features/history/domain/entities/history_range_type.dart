/// Time period resolution for History analysis
enum HistoryRangeType {
  day,
  week,
  month;

  bool get isDay => this == HistoryRangeType.day;
  bool get isWeek => this == HistoryRangeType.week;
  bool get isMonth => this == HistoryRangeType.month;
}
