import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:romanize/romanize.dart';

class Home extends StatefulComponent {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _text = '안녕하세요, 만나서 반갑습니다.';

  String get _romanized => TextRomanizer.romanize(_text);

  @override
  Component build(BuildContext context) {
    return div(
      styles: Styles(
        display: Display.flex,
        padding: Spacing.all(Unit.pixels(20)),
        flexDirection: FlexDirection.row,
        alignItems: AlignItems.start,
        gap: Gap(row: Unit.pixels(60), column: Unit.pixels(60)),
      ),
      [
        div(styles: Styles(flex: Flex.basis(Unit.percent(50))), [
          h3([.text('Input')]),
          textarea(
            placeholder: 'Type your text here...',
            onInput: (text) => setState(() => _text = text),
            rows: 15,
            required: true,
            spellCheck: SpellCheck.isFalse,
            styles: Styles(
              width: Unit.percent(100),
              height: Unit.percent(100),
              flex: Flex.grow(1),
              raw: {'resize': 'none'},
            ),
            [.text(_text)],
          ),
        ]),
        div(styles: Styles(flex: Flex.basis(Unit.percent(50))), [
          h3(styles: Styles(textAlign: TextAlign.left), [.text('Output')]),
          textarea(
            placeholder: 'Type your text here...',
            onInput: (text) => setState(() => _text = text),
            rows: 15,
            readonly: true,
            required: true,
            spellCheck: SpellCheck.isFalse,
            styles: Styles(
              width: Unit.percent(100),
              height: Unit.percent(100),
              flex: Flex.grow(1),
              raw: {'resize': 'none'},
            ),
            [.text(_romanized)],
          ),
          // p(styles: Styles(whiteSpace: WhiteSpace.preWrap), [.text(_romanized)]),
        ]),
      ],
    );
  }
}
