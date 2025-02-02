import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ci_project/screens/start_screen.dart';
import 'package:ci_project/screens/login_screen.dart';
import 'package:ci_project/screens/register_screen.dart';  // Assurez-vous que RegisterScreen est bien importé

void main() {
  testWidgets("Navigation depuis StartScreen vers LoginScreen, retour et navigation vers RegisterScreen", (tester) async {
    // 1. Charger StartScreen dans un MaterialApp avec des routes pour /login et /register
    await tester.pumpWidget(MaterialApp(
      home: const StartScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
    ));

    // 2. Vérifier que le bouton "Sign In" est bien affiché
    expect(find.byKey(const Key('sign_in_button')), findsOneWidget);

    // 3. Appuyer sur le bouton "Sign In" pour naviguer vers LoginScreen
    await tester.tap(find.byKey(const Key('sign_in_button')));
    await tester.pumpAndSettle();

    // 4. Vérifier que LoginScreen est bien affiché
    expect(find.byType(LoginScreen), findsOneWidget);

    // 5. Simuler le retour à StartScreen en utilisant Navigator.pop
    Navigator.pop(tester.element(find.byType(LoginScreen)));
    await tester.pumpAndSettle();

    // 6. Vérifier que nous sommes revenus à StartScreen
    expect(find.byType(StartScreen), findsOneWidget);

    // 7. Vérifier que le bouton "Sign Up" est bien affiché sur StartScreen
    expect(find.byKey(const Key('sign_up_button')), findsOneWidget);

    // 8. Appuyer sur le bouton "Sign Up" pour naviguer vers RegisterScreen
    await tester.tap(find.byKey(const Key('sign_up_button')));
    await tester.pumpAndSettle();

    // 9. Vérifier que RegisterScreen est bien affiché
    expect(find.byType(RegisterScreen), findsOneWidget);
  });
}
