import 'package:flutter/material.dart';

abstract class ICounterState {
  // late int value;
  void increment();
  void decrement();
  bool diff(CounterSate other);
}

class CounterSate implements ICounterState {
  int _value = 0;

  @override
  void increment() => _value++;

  @override
  void decrement() => _value == 0 ? 0 : _value--;

  int get value => _value;

  @override
  bool diff(CounterSate old) => old._value != _value;
}

class CounterProvider extends InheritedWidget {
  final CounterSate myState = CounterSate();
  /*
    Pode ser escrito de forma resumida tbm: 
    const CounterProvider({super.key, required super.child});
  */
  CounterProvider({super.key, required Widget child}) : super(child: child);

  static CounterProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CounterProvider>()!;
  }

  @override
  bool updateShouldNotify(covariant CounterProvider oldWidget) {
    return oldWidget.myState.diff(myState);
  }
}
