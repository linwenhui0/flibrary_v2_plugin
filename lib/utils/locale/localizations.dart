import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flibrary_plugin/utils/Print.dart';

class _ZHCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  // 支持的语言列表
  static final List<String> supportedLanguages = ['en', 'zh'];

  const _ZHCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      supportedLanguages.contains(locale.languageCode);

  @override
  Future<CupertinoLocalizations> load(Locale locale) {
    if (locale.languageCode == "zh") {
      Print().printNative("load zh");
      return ZHCupertinoLocalizations.load(locale);
    } else {
      Print().printNative("load zh");
      return DefaultCupertinoLocalizations.load(locale);
    }
  }

  @override
  bool shouldReload(LocalizationsDelegate<CupertinoLocalizations> old) => false;
}

class ZHCupertinoLocalizations implements CupertinoLocalizations {
  const ZHCupertinoLocalizations();

  static const List<String> _shortWeekdays = <String>[
    '周一',
    '周二',
    '周三',
    '周四',
    '周五',
    '周六',
    '周日',
  ];

  static const List<String> _shortMonths = <String>[
    '一月',
    '二月',
    '三月',
    '四月',
    '五月',
    '六月',
    '七月',
    '八月',
    '九月',
    '十月',
    '十一月',
    '十二月',
  ];

  static const List<String> _months = <String>[
    '一月',
    '二月',
    '三月',
    '四月',
    '五月',
    '六月',
    '七月',
    '八月',
    '九月',
    '十月',
    '十一月',
    '十二月',
  ];

  @override
  String get alertDialogLabel => "警告";

  @override
  String get anteMeridiemAbbreviation => "上午";

  @override
  String get copyButtonLabel => "复制";

  @override
  String get cutButtonLabel => "剪切";

  @override
  DatePickerDateOrder get datePickerDateOrder => DatePickerDateOrder.mdy;

  @override
  DatePickerDateTimeOrder get datePickerDateTimeOrder =>
      DatePickerDateTimeOrder.date_time_dayPeriod;

  @override
  String datePickerDayOfMonth(int dayIndex) {
    return dayIndex.toString();
  }

  @override
  String datePickerHour(int hour) {
    return hour.toString();
  }

  @override
  String datePickerHourSemanticsLabel(int hour) {
    return hour.toString() + " 点";
  }

  @override
  String datePickerMediumDate(DateTime date) {
    return '${_shortWeekdays[date.weekday - DateTime.monday]} '
        '${_shortMonths[date.month - DateTime.january]} '
        '${date.day.toString().padRight(2)}';
  }

  @override
  String datePickerMinute(int minute) {
    return minute.toString().padLeft(2, '0');
  }

  @override
  String datePickerMinuteSemanticsLabel(int minute) {
    return '$minute 分钟';
  }

  @override
  String datePickerMonth(int monthIndex) {
    return _months[monthIndex - 1];
  }

  @override
  String datePickerYear(int yearIndex) {
    return yearIndex.toString();
  }

  @override
  String get pasteButtonLabel => "粘贴";

  @override
  String get postMeridiemAbbreviation => "下午";

  @override
  String get selectAllButtonLabel => "全选";

  @override
  String timerPickerHour(int hour) {
    return hour.toString();
  }

  @override
  String timerPickerHourLabel(int hour) {
    return '$hour 点';
  }

  @override
  String timerPickerMinute(int minute) {
    return minute.toString();
  }

  @override
  String timerPickerMinuteLabel(int minute) {
    return "$minute 分";
  }

  @override
  String timerPickerSecond(int second) {
    return second.toString();
  }

  @override
  String timerPickerSecondLabel(int second) {
    return "$second 秒";
  }

  /// Creates an object that provides US English resource values for the
  /// cupertino library widgets.
  ///
  /// The [locale] parameter is ignored.
  ///
  /// This method is typically used to create a [LocalizationsDelegate].
  static Future<CupertinoLocalizations> load(Locale locale) {
    return SynchronousFuture<CupertinoLocalizations>(
        const ZHCupertinoLocalizations());
  }

  /// A [LocalizationsDelegate] that uses [DefaultCupertinoLocalizations.load]
  /// to create an instance of this class.
  static const LocalizationsDelegate<CupertinoLocalizations> delegate =
      _ZHCupertinoLocalizationsDelegate();

  @override
  // TODO: implement todayLabel
  String get todayLabel => "今天";
}
