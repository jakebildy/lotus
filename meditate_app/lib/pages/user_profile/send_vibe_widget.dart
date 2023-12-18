import 'package:flutter/material.dart';

class SendVibeWidget extends StatefulWidget {
  const SendVibeWidget({super.key});

  @override
  State<SendVibeWidget> createState() => _SendVibeWidgetState();
}

class _SendVibeWidgetState extends State<SendVibeWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                "Send them an emoji",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Vibe(
                  vibe: '🔥',
                ),
                Vibe(
                  vibe: '💜',
                ),
                Vibe(
                  vibe: '❤️',
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Vibe(
                  vibe: '👉',
                ),
                Vibe(
                  vibe: '👋',
                ),
                Vibe(
                  vibe: '🙌',
                )
              ],
            ),
          ],
        )));
  }
}

class Vibe extends StatefulWidget {
  final String vibe;
  const Vibe({Key? key, required this.vibe}) : super(key: key);

  @override
  _VibeState createState() => _VibeState();
}

class _VibeState extends State<Vibe> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isPressed = true;
          });
        },
        child: Container(
          width: 100,
          decoration: BoxDecoration(
            color:
                !_isPressed ? Color.fromARGB(255, 46, 48, 59) : Colors.black12,
            border: Border.all(
              color: !_isPressed
                  ? Color.fromARGB(255, 81, 80, 107)
                  : Colors.white24,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Column(
              children: [
                Opacity(
                  opacity: !_isPressed ? 1 : 0.5,
                  child: Text(
                    widget.vibe,
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
                Text(_isPressed ? "Sent" : "Send",
                    style: TextStyle(
                        color: !_isPressed ? Colors.white : Colors.grey))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
