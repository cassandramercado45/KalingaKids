import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kalingakids/main.dart';
import 'package:kalingakids/services/app_state.dart';
import 'package:kalingakids/widgets/add_child_dialog.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'isLoggedIn': false,
      'userName': '',
      'userEmail': '',
      'childrenList': '[]',
      'selectedChildId': '',
    });
  });

  testWidgets('Clean Install Onboarding Walkthrough Test', (WidgetTester tester) async {
    final appState = AppState();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: const KalingaKidsApp(),
      ),
    );

    // Let initialization finish
    await tester.pump();
    
    // Settle splash screen timer and animation navigation to onboarding
    await tester.pumpAndSettle(const Duration(seconds: 4));
    
    // Settle onboarding slides
    expect(find.text('Subaybayan ang Timbang at Taas'), findsOneWidget);
  });

  testWidgets('AddChildDialog Widget Interaction Test', (WidgetTester tester) async {
    final appState = AppState();
    
    // Pump dialog directly inside a Navigator
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const AddChildDialog(),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    );

    // Open the dialog
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    // Verify dialog title
    expect(find.text('Magdagdag ng Anak'), findsOneWidget);

    // Fill Name
    final nameField = find.byType(TextFormField).at(0);
    await tester.enterText(nameField, 'Baby dela Cruz');

    // Fill Age
    final ageField = find.byType(TextFormField).at(1);
    await tester.enterText(ageField, '1 taon at 2 buwan');

    // Fill Height and Weight
    final heightField = find.byType(TextFormField).at(2);
    await tester.enterText(heightField, '85.5');

    final weightField = find.byType(TextFormField).at(3);
    await tester.enterText(weightField, '11.2');

    await tester.pumpAndSettle();

    // Verify cancel button exists
    expect(find.text('Kanselahin'), findsOneWidget);
  });

  test('AppState Add Child Test', () async {
    final appState = AppState();
    
    // Simulate AppState initialization
    await Future.delayed(const Duration(milliseconds: 100));

    expect(appState.children.length, 3);
    expect(appState.selectedChild != null, true);

    // Add a child
    await appState.addChild(
      'Juan dela Cruz',
      DateTime(2023, 10, 1),
      'Lalaki',
      'O+',
      90.0,
      12.5,
    );

    expect(appState.children.length, 4);
    expect(appState.children.last.name, 'Juan dela Cruz');
    expect(appState.children.last.gender, 'Lalaki');
    expect(appState.children.last.bloodType, 'O+');
    expect(appState.children.last.growthHistory.length, 1);
    expect(appState.children.last.growthHistory.first.height, 90.0);
    expect(appState.children.last.growthHistory.first.weight, 12.5);
  });
}
