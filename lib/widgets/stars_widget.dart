//------/dart and flutter packages
import 'package:flutter/material.dart';

class StarsWidget extends StatelessWidget {
  final int stars;

  const StarsWidget({
    Key? key,
    required this.stars,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: ''.padLeft(5 - stars, '\u2605'),
        style: Theme.of(context).textTheme.caption?.copyWith(
              color: Colors.amber.withOpacity(0.4),
            ),
        children: <InlineSpan>[
          TextSpan(
            text: ''.padLeft(stars, '\u2605'),
            style: Theme.of(context)
                .textTheme
                .caption
                ?.copyWith(color: Colors.amber),
          ),
        ],
      ),
    );
  }
}
