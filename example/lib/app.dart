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
        margin: Spacing.symmetric(horizontal: Unit.pixels(75)),
        flexDirection: FlexDirection.column,
        fontFamily: FontFamily.variable('Ink Free Regular'),
      ),
      classes: 'main',
      [
        h2(
          styles: Styles(
            width: Unit.percent(100),
            margin: Spacing.symmetric(vertical: .pixels(20)),
            flex: Flex.shrink(1),
            textAlign: TextAlign.center,
          ),
          [.text('Dart Romanize')],
        ),
        div(
          styles: Styles(flex: Flex.grow(1)),
          [
            const Home(),
          ],
        ),
      ],
    );
  }
}
