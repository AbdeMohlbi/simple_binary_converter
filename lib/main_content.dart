import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'numeric_range.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum NumberBase {
  binary,
  decimal,
}

class _MyHomePageState extends State<MyHomePage> {
  NumberBase currentBase = NumberBase.decimal;
  String val = "";
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _controller,
              onChanged: (String value) {
                final int? f = int.tryParse(value);
                if (currentBase == NumberBase.decimal) {
                  setState(() {
                    val = f?.toRadixString(2) ?? "";
                  });
                } else {
                  num? v = int.tryParse(value, radix: 2);
                  setState(() {
                    val = v == null ? "" : v.toString();
                  });
                }
              },
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                currentBase == NumberBase.decimal
                    ? FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                    : FilteringTextInputFormatter.allow(RegExp(r'[0-1]')),
                NumericRangeTextInputFormatter(maxValue: 9223372036854775807),
              ],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Text(val),
          IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: val));
            },
            icon: const Icon(Icons.content_copy_rounded,
                size: 30, color: Colors.blue, applyTextScaling: true),
            tooltip: "copy to clip board",
          ),
          const Spacer(),
          Align(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("Decimal",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
                IconButton(
                  onPressed: () {
                    currentBase = switch (currentBase) {
                      NumberBase.binary => NumberBase.decimal,
                      NumberBase.decimal => NumberBase.binary
                    };
                    val = "";
                    _controller.text = "";
                    setState(() {});
                  },
                  icon: Icon(
                      currentBase == NumberBase.binary
                          ? Icons.arrow_circle_left_outlined
                          : Icons.arrow_circle_right_outlined,
                      size: 50),
                ),
                const Text("Binary",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
