import 'package:flutter/material.dart';
import 'package:shop/providers/counter.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  @override
  Widget build(BuildContext context) {
    CounterProvider counterProvider = CounterProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exemplo Contador'),
      ),
      body: Row(
        children: <Widget>[
          IconButton(
            onPressed: () => setState(counterProvider.myState.decrement),
            icon: const Icon(Icons.remove),
          ),
          Text(counterProvider.myState.value.toString()),
          IconButton(
            onPressed: () => setState(counterProvider.myState.increment),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
