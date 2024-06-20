import 'package:flutter/material.dart';

const double _datePickerHeaderLandscapeWidth = 140.0;
const double _datePickerHeaderPortraitHeight = 120.0;
const double _headerPaddingLandscape = 16.0;

class PDatePickerHeader extends StatelessWidget {
  /// Creates a header for use in a date picker dialog.
  const PDatePickerHeader({
    Key? key,
    required this.helpText,
    required this.titleText,
    this.titleSemanticsLabel,
    required this.titleStyle,
    required this.orientation,
    this.isShort = false,
    required this.icon,
    required this.iconTooltip,
    required this.onIconPressed,
  }) : super(key: key);

  final String helpText;
  final String titleText;
  final String? titleSemanticsLabel;
  final TextStyle? titleStyle;
  final Orientation orientation;
  final bool isShort;
  final IconData? icon;
  final String? iconTooltip;
  final VoidCallback onIconPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    final bool isDark = colorScheme.brightness == Brightness.dark;
    final Color onPrimarySurfaceColor = !isDark ? colorScheme.onSurface : colorScheme.onPrimary;

    final TextStyle? helpStyle = textTheme.labelMedium?.copyWith(
      color: colorScheme.onSurface.withOpacity(0.38),
      fontWeight: FontWeight.w500,
      fontFamily: 'SansFaNum',
    );

    final Text help = Text(
      helpText,
      style: helpStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
    final Widget title = orientation == Orientation.portrait
        ? Text(
            titleText,
            semanticsLabel: titleSemanticsLabel ?? titleText,
            style: titleStyle,
            softWrap: true,
            maxLines: (isShort || orientation == Orientation.portrait) ? 1 : 2,
            overflow: TextOverflow.ellipsis,
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titleText.split(' ')[0],
                semanticsLabel: titleSemanticsLabel ?? titleText,
                style: titleStyle,
                softWrap: true,
                maxLines: (isShort || orientation == Orientation.portrait) ? 1 : 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                titleText.split(' ')[1] + ' ' + titleText.split(' ')[2],
                semanticsLabel: titleSemanticsLabel ?? titleText,
                style: titleStyle,
                softWrap: true,
                maxLines: (isShort || orientation == Orientation.portrait) ? 1 : 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          );
    final IconButton icon = IconButton(
      icon: Icon(this.icon),
      color: onPrimarySurfaceColor,
      tooltip: iconTooltip,
      onPressed: onIconPressed,
    );

    switch (orientation) {
      case Orientation.portrait:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: _datePickerHeaderPortraitHeight,
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 24, end: 12),
                    child: Flexible(child: help),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 24, end: 12),
                    child: Row(
                      children: <Widget>[
                        Expanded(child: title),
                        icon,
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 1.5,
                    color: colorScheme.onSurface.withOpacity(0.2),
                  ),
                ],
              ),
            ),
          ],
        );
      case Orientation.landscape:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: _datePickerHeaderLandscapeWidth,
              color: Colors.transparent,
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: _headerPaddingLandscape,
                        ),
                        child: help,
                      ),
                      SizedBox(height: isShort ? 16 : 56),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: _headerPaddingLandscape,
                        ),
                        child: title,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: 1.5,
                    color: colorScheme.onSurface.withOpacity(0.2),
                  ),
                ],
              ),
            ),
          ],
        );
    }
  }
}
