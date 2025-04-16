import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:golf_live_scoring/ui/gen/fonts.gen.dart';

abstract final class GolfTheme {

  static final defaultTheme = () {
    final colorExtension = ColorsExtension(
      accent1: Color(0xFF4281E8),
      accent2: Color(0xFF000034),
      background1: Color(0xFFF6F9FE),
      background2: Color(0xFFFFFFFF),
      background3: Color(0xFFE5F1FF),
      background4: Color(0xFFF5F9FE),
      textPrimary: Color(0xFF000034),
      textSecondary: Color(0xFF8E8EA8),
      textLabel: Color(0xFF6A6A8A),
      textInverted: Color(0xFFFFFFFF),
      textFooter: Color(0xDE000000),
      line: Color(0xFFCBCBDB),
    );

    final textStylesExtension = TextStylesExtension(
      title1: TextStyle(
        fontFamily: FontFamily.montserrat,
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: colorExtension.textPrimary,
      ),
      title2: TextStyle(
        fontFamily: FontFamily.montserrat,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: colorExtension.accent1,
        letterSpacing: 0.2,
      ),
      input: TextStyle(
        fontFamily: FontFamily.montserrat,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1,
        color: colorExtension.textPrimary,
      ),
      body1: TextStyle(
        fontFamily: FontFamily.montserrat,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: colorExtension.textPrimary,
      ),
      body2: TextStyle(
        fontFamily: FontFamily.montserrat,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: colorExtension.textSecondary,
      ),
      label: TextStyle(
        fontFamily: FontFamily.montserrat,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: colorExtension.textLabel,
      ),
      floatingLabel: TextStyle(
        fontFamily: FontFamily.montserrat,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: colorExtension.textLabel,
        letterSpacing: 0.15,
      ),
      footer: TextStyle(
        fontFamily: FontFamily.montserrat,
        fontSize: 14,
        fontWeight: FontWeight.w100,
        height: 1.41,
        color: colorExtension.textFooter,
        letterSpacing: 0.15,
      ),
      buttonDefault: TextStyle(
        fontFamily: FontFamily.montserrat,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        height: 1.25,
        color: colorExtension.textInverted,
      ),
    );

    return ThemeData(
      scaffoldBackgroundColor: colorExtension.background1,
      dividerColor: colorExtension.line,
      textSelectionTheme: TextSelectionThemeData(cursorColor: colorExtension.textPrimary),
      extensions: [
        textStylesExtension,
        colorExtension,
      ],
    );
  }.call();
}

class ColorsExtension extends ThemeExtension<ColorsExtension> with EquatableMixin {
  ColorsExtension({
    required this.accent1,
    required this.accent2,
    required this.background1,
    required this.background2,
    required this.background3,
    required this.background4,
    required this.textPrimary,
    required this.textSecondary,
    required this.textLabel,
    required this.textInverted,
    required this.textFooter,
    required this.line,
  });

  final Color accent1;
  final Color accent2;
  final Color background1;
  final Color background2;
  final Color background3;
  final Color background4;
  final Color textPrimary;
  final Color textSecondary;
  final Color textLabel;
  final Color textInverted;
  final Color textFooter;
  final Color line;

  @override
  ColorsExtension copyWith({
    final Color? accent1,
    final Color? accent2,
    final Color? background1,
    final Color? background2,
    final Color? background3,
    final Color? background4,
    final Color? textPrimary,
    final Color? textSecondary,
    final Color? textLabel,
    final Color? textInverted,
    final Color? textUnimportant,
    final Color? textFooter,
    final Color? line,
  }) {
    return ColorsExtension(
      accent1: accent1 ?? this.accent1,
      accent2: accent2 ?? this.accent2,
      background1: background1 ?? this.background1,
      background2: background2 ?? this.background2,
      background3: background3 ?? this.background3,
      background4: background4 ?? this.background4,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textLabel: textLabel ?? this.textLabel,
      textInverted: textInverted ?? this.textInverted,
      textFooter: textUnimportant ?? this.textFooter,
      line: line ?? this.line,
    );
  }

  @override
  ThemeExtension<ColorsExtension> lerp(ColorsExtension? other, double t) {
    return ColorsExtension(
      accent1: Color.lerp(accent1, other?.accent1, t) ?? accent1,
      accent2: Color.lerp(accent2, other?.accent2, t) ?? accent2,
      background1: Color.lerp(background1, other?.background1, t) ?? background1,
      background2: Color.lerp(background2, other?.background2, t) ?? background2,
      background3: Color.lerp(background3, other?.background3, t) ?? background3,
      background4: Color.lerp(background4, other?.background4, t) ?? background4,
      textPrimary: Color.lerp(textPrimary, other?.textPrimary, t) ?? textPrimary,
      textSecondary: Color.lerp(textSecondary, other?.textSecondary, t) ?? textSecondary,
      textLabel: Color.lerp(textLabel, other?.textLabel, t) ?? textLabel,
      textInverted: Color.lerp(textInverted, other?.textInverted, t) ?? textInverted,
      textFooter: Color.lerp(textFooter, other?.textFooter, t) ?? textFooter,
      line: Color.lerp(line, other?.line, t) ?? line,
    );
  }

  @override
  List<Object?> get props => [
        accent1,
        accent2,
        background1,
        background2,
        background3,
        background4,
        textPrimary,
        textSecondary,
        textLabel,
        textInverted,
        textFooter,
        line,
      ];
}

class TextStylesExtension extends ThemeExtension<TextStylesExtension> with EquatableMixin {
  TextStylesExtension({
    required this.title1,
    required this.title2,
    required this.input,
    required this.body1,
    required this.body2,
    required this.label,
    required this.floatingLabel,
    required this.footer,
    required this.buttonDefault,
  });

  /// 22 w700 textPrimary
  final TextStyle title1;

  /// 20 w700 1.2 accent1 0.2
  final TextStyle title2;

  /// 16 w500 1 textPrimary
  final TextStyle input;

  /// 14 w700 textSecondary
  final TextStyle body1;

  /// 14 w500 textSecondary
  final TextStyle body2;

  /// 16 w500 textLabel
  final TextStyle label;

  /// 12 w500 textLabel 0.15
  final TextStyle floatingLabel;

  /// 14 w100 1.41 textFooter 0.15
  final TextStyle footer;

  /// 16 w700 1.25 textInverted
  final TextStyle buttonDefault;

  @override
  TextStylesExtension copyWith({
    final TextStyle? title1,
    final TextStyle? title2,
    final TextStyle? input,
    final TextStyle? body1,
    final TextStyle? body2,
    final TextStyle? label,
    final TextStyle? floatingLabel,
    final TextStyle? footer,
    final TextStyle? buttonDefault,
  }) {
    return TextStylesExtension(
      title1: title1 ?? this.title1,
      title2: title2 ?? this.title2,
      input: input ?? this.input,
      body1: body1 ?? this.body1,
      body2: body2 ?? this.body2,
      label: label ?? this.label,
      floatingLabel: floatingLabel ?? this.floatingLabel,
      footer: footer ?? this.footer,
      buttonDefault: buttonDefault ?? this.buttonDefault,
    );
  }

  @override
  ThemeExtension<TextStylesExtension> lerp(TextStylesExtension? other, double t) {
    return TextStylesExtension(
      title1: TextStyle.lerp(title1, other?.title1, t) ?? title1,
      title2: TextStyle.lerp(title2, other?.title2, t) ?? title2,
      input: TextStyle.lerp(input, other?.input, t) ?? input,
      body1: TextStyle.lerp(body1, other?.body1, t) ?? body1,
      body2: TextStyle.lerp(body2, other?.body2, t) ?? body2,
      label: TextStyle.lerp(label, other?.label, t) ?? label,
      floatingLabel: TextStyle.lerp(floatingLabel, other?.floatingLabel, t) ?? floatingLabel,
      footer: TextStyle.lerp(footer, other?.footer, t) ?? footer,
      buttonDefault: TextStyle.lerp(buttonDefault, other?.buttonDefault, t) ?? buttonDefault,
    );
  }

  @override
  List<Object?> get props => [
        title1,
        title2,
        input,
        body1,
        body2,
        label,
        floatingLabel,
        footer,
        buttonDefault,
      ];
}
