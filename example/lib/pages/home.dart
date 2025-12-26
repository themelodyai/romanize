import 'package:example/main.client.dart';
import 'package:example/main.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:romanize/romanize.dart';
import 'package:web/web.dart' as web;

class Home extends StatefulComponent {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _text = multiLanguagesText;
  late Future<List<RomanizedText>> _romanized = service.convert(_text);

  void _syncScroll(web.Event event, String otherId) {
    final source = event.target as web.HTMLElement;
    final other = web.document.getElementById(otherId) as web.HTMLElement?;
    if (other != null) {
      other.scrollTop = source.scrollTop;
    }
  }

  Color _getColorForLanguage(String languageCode) {
    switch (languageCode) {
      case 'korean':
        return Color('#3B82F6'); // Blue
      case 'japanese':
        return Color('#EF4444'); // Red
      case 'chinese':
        return Color('#F59E0B'); // Amber
      case 'arabic':
        return Color('#10B981'); // Green
      case 'hebrew':
        return Color('#EC4899'); // Pink
      case 'cyrillic':
        return Color('#8B5CF6'); // Purple
      default:
        return Color('#6B7280'); // Neutral Gray
    }
  }

  @override
  Component build(BuildContext context) {
    final textareaStyle = Styles(
      width: Unit.percent(100),
      height: Unit.vh(60),
      padding: Spacing.all(Unit.pixels(16)),
      boxSizing: BoxSizing.borderBox,
      border: Border.all(color: Color('#d1d5db')),
      radius: BorderRadius.circular(Unit.pixels(25)),
      outline: Outline.unset,
      shadow: BoxShadow(
        color: Color.rgba(0, 0, 0, 0.05),
        blur: Unit.pixels(2),
        offsetX: Unit.zero,
        offsetY: Unit.pixels(1),
      ),
      fontFamily: FontFamily('inherit'),
      fontSize: Unit.rem(1),
      lineHeight: Unit.rem(1.5),
      backgroundColor: Colors.white,
      raw: {
        'resize': 'none',
      },
    );

    final sectionStyle = Styles(
      display: Display.flex,
      height: Unit.percent(70),
      minWidth: Unit.pixels(200),
      flexDirection: FlexDirection.column,
      gap: Gap.all(Unit.pixels(12)),
      flex: Flex(grow: 1, shrink: 0, basis: Unit.pixels(200)),
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
            id: 'input-area',
            events: {
              'scroll': (e) => _syncScroll(e, 'output-area'),
            },
            placeholder: 'Type your text here...',
            onInput: (text) async {
              setState(() {
                _text = text;
                _romanized = service.convert(text);
              });
            },
            required: true,
            spellCheck: SpellCheck.isFalse,
            styles: textareaStyle.combine(
              Styles(raw: {'resize': 'none'}),
            ),
            [.text(_text)],
          ),
        ]),
        div(styles: sectionStyle, [
          h3(styles: labelStyle, [.text('Output')]),
          FutureBuilder<List<RomanizedText>>(
            future: _romanized,
            builder: (context, snapshot) {
              return div(
                id: 'output-area',
                events: {
                  'scroll': (e) => _syncScroll(e, 'input-area'),
                },
                styles: textareaStyle.combine(
                  Styles(
                    overflow: Overflow.auto,
                    whiteSpace: WhiteSpace.preWrap,
                    backgroundColor: Color('#f9fafb'),
                    raw: {
                      'word-break': 'break-word',
                    },
                  ),
                ),
                snapshot.hasData
                    ? snapshot.data!.map((item) {
                        return span(
                          styles: Styles(
                            color: _getColorForLanguage(item.language),
                            fontWeight: FontWeight.w500,
                          ),
                          [.text(item.romanizedText)],
                        );
                      }).toList()
                    : [
                        .text('Loading resources...'),
                      ],
              );
            },
          ),
        ]),
      ],
    );
  }
}
