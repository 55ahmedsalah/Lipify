import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lipify/main.dart';
import 'package:lipify/screens/home_screen.dart';

void main() {
  testWidgets('Home page smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(RestartWidget());

    final welcomeFinder = find.text('Welcome to Lipify');
    final assistantFinder = find.text('Your Lip Reading Assistant');

    expect(welcomeFinder, findsOneWidget);
    expect(assistantFinder, findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // final sentenceFinder = find.text('My sentence structure will be:');
//    final adverbFinder = find.text('Adverb');
//    final alphabetFinder = find.text('Alphabet');
//    final colorsFinder = find.text('Colors');
//    final commandsFinder = find.text('Commands');
//    final numbersFinder = find.text('Numbers');
//    final prepositionsFinder = find.text('Prepositions');
//
//    // expect(sentenceFinder, findsOneWidget);
//    expect(adverbFinder, findsOneWidget);
//    expect(alphabetFinder, findsOneWidget);
//    expect(colorsFinder, findsOneWidget);
//    expect(commandsFinder, findsOneWidget);
//    expect(numbersFinder, findsOneWidget);
//    expect(prepositionsFinder, findsOneWidget);
  });
}
