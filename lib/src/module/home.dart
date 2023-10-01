import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show AsyncValueX, Consumer;

import '../ffi/concat/string_ffi.dart' show concatStringUsingRust;
import '../ffi/db/sled.dart';
import '../ffi/notification/notification.dart';
import '../ffi/stream/provider.dart' show rustEventProvider, startRustProvider;
import '../ffi/stream_to/stream.dart';
import '../ffi/sum/sum.dart' show printSomething, sumTwoNumbers;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              final start = DateTime.now();
              _time();
              log(DateTime.now().difference(start).toString());
            },
            child: const Text('Dart Loop'),
          ),
          const SizedBox(width: double.infinity, height: 10),
          ElevatedButton(
            onPressed: () {
              final start = DateTime.now();
              printSomething();
              log(DateTime.now().difference(start).toString());
            },
            child: const Text('Rust Loop'),
          ),
          const SizedBox(width: double.infinity, height: 10),
          ElevatedButton(
            onPressed: () {
              final sum = sumTwoNumbers(10.0, 30.0);
              log('Sum : $sum');
            },
            child: const Text('Calculate Sum'),
          ),
          const SizedBox(width: double.infinity, height: 10),
          ElevatedButton(
            onPressed: () {
              final profile = concatStringUsingRust('Remon Ahammad', 23);
              log('Profile : $profile');
            },
            child: const Text('Profile Concat in Rust code'),
          ),
          const SizedBox(width: double.infinity, height: 10),
          Consumer(builder: (context, state, __) {
            state.watch(startRustProvider);
            final eventData = state.watch(rustEventProvider);

            return eventData.when(
              error: (e, _) => Text(e.toString()),
              loading: () => const CircularProgressIndicator(),
              data: (data) => Text(String.fromCharCodes(data)),
            );
          }),
          ElevatedButton(
            onPressed: () async {
              startStreamTo();
            },
            child: const Text('Stream'),
          ),
          ElevatedButton(
            onPressed: () async {
              await openDb();
            },
            child: const Text('Open DB'),
          ),
        ],
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () async => await showNotification(
            'Rust Native Notification', 'Hello from Rust code'),
        onLongPress: () async => await showPersistentNotification(
            'Rust App',
            'Rust Native Persistent Notification',
            'Hello from Rust code',
            const Duration(milliseconds: 10000)),
        child: const Icon(Icons.notifications_on),
      ),
    );
  }

  _time() {
    int x = 0;
    for (int i = 0; i < 1000000000; i++) {
      x += i;
    }
    log('Sum : $x');
  }
}
