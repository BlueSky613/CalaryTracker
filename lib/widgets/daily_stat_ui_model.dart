var defaultDailyStat = DailyStatUiModel(
  day: 'day',
  stat: '',
  isToday: false,
  isSelected: false,
  dayPosition: 1,
);

class DailyStatUiModel {
  String day;
  String stat;
  bool isToday;
  bool isSelected;
  int dayPosition;

  DailyStatUiModel(
      {required this.day,
      required this.stat,
      required this.isToday,
      required this.isSelected,
      required this.dayPosition});

  DailyStatUiModel copyWith(
          {String? day,
            String? stat,
          bool? isToday,
          bool? isSelected,
          int? dayPosition}) =>
      DailyStatUiModel(
          day: day ?? this.day,
          stat: stat ?? this.stat,
          isToday: isToday ?? this.isToday,
          isSelected: isSelected ?? this.isSelected,
          dayPosition: dayPosition ?? this.dayPosition);
}
