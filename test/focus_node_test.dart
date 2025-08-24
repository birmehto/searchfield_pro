import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:searchfield/searchfield.dart';

void main() {
  group('SearchField Focus Node Tests', () {
    testWidgets('should properly manage internal focus node lifecycle',
        (WidgetTester tester) async {
      final suggestions = ['Apple', 'Banana', 'Cherry']
          .map((e) => SearchFieldListItem<String>(e))
          .toList();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchField<String>(
              suggestions: suggestions,
            ),
          ),
        ),
      );

      // Verify widget builds without errors
      expect(find.byType(SearchField<String>), findsOneWidget);
    });

    testWidgets('should properly manage external focus node',
        (WidgetTester tester) async {
      final focusNode = FocusNode();
      final suggestions = ['Apple', 'Banana', 'Cherry']
          .map((e) => SearchFieldListItem<String>(e))
          .toList();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchField<String>(
              focusNode: focusNode,
              suggestions: suggestions,
            ),
          ),
        ),
      );

      // Verify widget builds without errors
      expect(find.byType(SearchField<String>), findsOneWidget);

      // Clean up external focus node
      focusNode.dispose();
    });

    testWidgets('should handle focus node changes in didUpdateWidget',
        (WidgetTester tester) async {
      final focusNode1 = FocusNode();
      final focusNode2 = FocusNode();
      final suggestions = ['Apple', 'Banana', 'Cherry']
          .map((e) => SearchFieldListItem<String>(e))
          .toList();

      // Build with first focus node
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchField<String>(
              focusNode: focusNode1,
              suggestions: suggestions,
            ),
          ),
        ),
      );

      // Update with second focus node
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchField<String>(
              focusNode: focusNode2,
              suggestions: suggestions,
            ),
          ),
        ),
      );

      // Verify widget still works after focus node change
      expect(find.byType(SearchField<String>), findsOneWidget);

      // Clean up external focus nodes
      focusNode1.dispose();
      focusNode2.dispose();
    });

    testWidgets('should handle controller changes properly',
        (WidgetTester tester) async {
      final controller1 = TextEditingController();
      final controller2 = TextEditingController();
      final suggestions = ['Apple', 'Banana', 'Cherry']
          .map((e) => SearchFieldListItem<String>(e))
          .toList();

      // Build with first controller
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchField<String>(
              controller: controller1,
              suggestions: suggestions,
            ),
          ),
        ),
      );

      // Update with second controller
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchField<String>(
              controller: controller2,
              suggestions: suggestions,
            ),
          ),
        ),
      );

      // Verify widget still works after controller change
      expect(find.byType(SearchField<String>), findsOneWidget);

      // Clean up external controllers
      controller1.dispose();
      controller2.dispose();
    });
  });
}
