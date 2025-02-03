import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ci_project/screens/start_screen.dart';
import 'package:ci_project/screens/login_screen.dart';
import 'package:ci_project/screens/register_screen.dart';  // Assurez-vous que RegisterScreen est bien importé

void main() {
  testWidgets("Navigation depuis StartScreen vers LoginScreen, retour et navigation vers RegisterScreen", (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: const StartScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
    ));

    expect(find.byKey(const Key('sign_in_button')), findsOneWidget);

    await tester.tap(find.byKey(const Key('sign_in_button')));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);

    Navigator.pop(tester.element(find.byType(LoginScreen)));
    await tester.pumpAndSettle();

    expect(find.byType(StartScreen), findsOneWidget);

    expect(find.byKey(const Key('sign_up_button')), findsOneWidget);

    await tester.tap(find.byKey(const Key('sign_up_button')));
    await tester.pumpAndSettle();

    expect(find.byType(RegisterScreen), findsOneWidget);
  });
}
