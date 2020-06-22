import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lipify/main.dart';

import 'package:lipify/screens/sentence_structure_screen.dart';

void main() {
  testWidgets('Sentence Structure page smoke test',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(SentenceStructureScreen());

    final welcomeFinder = find.text('My sentence structure will be:');
    final adverbFinder = find.text('Adverb');
    final alphabetFinder = find.text('Alphabet');
    final colorsFinder = find.text('Colors');
    final commandsFinder = find.text('Commands');
    final numbersFinder = find.text('Numbers');
    final prepositionsFinder = find.text('Prepositions');

    expect(welcomeFinder, findsOneWidget);
    expect(adverbFinder, findsOneWidget);
    expect(alphabetFinder, findsOneWidget);
    expect(colorsFinder, findsOneWidget);
    expect(commandsFinder, findsOneWidget);
    expect(numbersFinder, findsOneWidget);
    expect(prepositionsFinder, findsOneWidget);
  });
}
