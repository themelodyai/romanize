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
    final textareaStyle = Styles(
      width: Unit.percent(100),
      height: Unit.pixels(300),
      padding: Spacing.all(Unit.pixels(16)),
      boxSizing: BoxSizing.borderBox,
      border: Border.all(color: Color('#d1d5db')),
      radius: BorderRadius.circular(Unit.pixels(25)),
      outline: Outline.unset,
      // fontFamily: FontFamily.monospace,
      shadow: BoxShadow(
        color: Color.rgba(0, 0, 0, 0.05),
        blur: Unit.pixels(2),
        offsetX: Unit.zero,
        offsetY: Unit.pixels(1),
      ),
      // resize: Resize.none,
      fontSize: Unit.rem(1),
      backgroundColor: Colors.white,
      raw: {
        'resize': 'none',
      },
    );

    final sectionStyle = Styles(
      display: Display.flex,
      // flexBasis: FlexBasis(Unit.pixels(400)),
      flexDirection: FlexDirection.column,
      gap: Gap.all(Unit.pixels(12)),
      flex: Flex.grow(1),
    );

    final labelStyle = Styles(
      margin: Spacing.zero,
      color: Color('#374151'),
      fontSize: Unit.rem(1.125),
      fontWeight: FontWeight.w600,
    );

    return div(
      styles: Styles(
        display: Display.flex,
        width: Unit.percent(100),
        flexWrap: FlexWrap.wrap,
        gap: Gap.all(Unit.pixels(32)),
      ),
      [
        div(styles: sectionStyle, [
          h3(styles: labelStyle, [.text('Input')]),
          textarea(
            placeholder: 'Type your text here...',
            onInput: (text) => setState(() => _text = text),
            rows: 15,
            required: true,
            spellCheck: SpellCheck.isFalse,
            styles: textareaStyle,
            [.text(_text)],
          ),
        ]),
        div(styles: sectionStyle, [
          h3(styles: labelStyle, [.text('Output')]),
          textarea(
            placeholder: 'Type your text here...',
            // onInput: (text) => setState(() => _text = text), // Readonly, no input needed
            rows: 15,
            readonly: true,
            spellCheck: SpellCheck.isFalse,
            styles: textareaStyle.combine(
              Styles(
                color: Color('#4b5563'),
                backgroundColor: Color('#f9fafb'),
              ),
            ),
            [.text(_romanized)],
          ),
          // p(styles: Styles(whiteSpace: WhiteSpace.preWrap), [.text(_romanized)]),
        ]),
      ],
    );
  }
}
