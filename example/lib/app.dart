import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'pages/home.dart';

class App extends StatelessComponent {
  const App({super.key});

  @override
  Component build(BuildContext context) {
    return div(
      styles: Styles(
        display: Display.flex,
        minHeight: Unit.vh(100),
        flexDirection: FlexDirection.column,
        color: Color('#111827'),
        fontFamily: FontFamily('Inter, system-ui, sans-serif'),
        backgroundColor: Color('#f9fafb'),
      ),
      classes: 'main',
      [
        header(
          styles: Styles(
            padding: Spacing.symmetric(vertical: Unit.pixels(16)),
            textAlign: TextAlign.center,
          ),
          [
            h1(
              styles: Styles(
                margin: Spacing.zero,
                color: Color('#111827'),
                fontSize: Unit.rem(2),
                fontWeight: FontWeight.w700,
              ),
              [
                .text('Dart Romanize'),
                p(
                  styles: Styles(
                    margin: Spacing.only(top: Unit.pixels(8)),
                    color: Color('#6b7280'),
                    fontSize: Unit.rem(1),
                  ),
                  [.text('Convert text to Romanized form instantly')],
                ),
              ],
            ),
          ],
        ),
        div(
          styles: Styles(
            width: Unit.percent(100),
            maxWidth: Unit.pixels(1200),
            padding: Spacing.all(Unit.pixels(32)),
            margin: Spacing.symmetric(horizontal: Unit.auto),
            flex: Flex.grow(1),
          ),
          [const Home()],
        ),
        footer(
          styles: Styles(
            padding: Spacing.all(Unit.pixels(16)),
            border: Border.only(top: BorderSide(color: Color('#e5e7eb'))),
            color: Colors.black.withOpacity(0.6),
            textAlign: TextAlign.center,
            fontSize: Unit.rem(0.875),
            backgroundColor: Colors.white,
          ),
          [.text('Built with Jaspr & Romanize')],
        ),
      ],
    );
  }
}
