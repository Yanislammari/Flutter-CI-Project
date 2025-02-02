import "package:ci_project/models/credit_card.dart";
import "package:ci_project/screens/add_card_screen.dart";
import "package:ci_project/screens/change_card_screen.dart";
import "package:ci_project/screens/delete_card_screen.dart";
import "package:ci_project/screens/login_screen.dart";
import "package:ci_project/screens/main_screen.dart";
import "package:ci_project/screens/register_screen.dart";
import "package:ci_project/screens/start_screen.dart";
import "package:ci_project/screens/transaction_history_screen.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if(kIsWeb) {
    await Firebase.initializeApp(options: const FirebaseOptions(
      apiKey: "AIzaSyB42_D1OlhA6f37-9rLiLV-7ncDtbfs8yQ",
      authDomain: "ci-project-d2875.firebaseapp.com",
      projectId: "ci-project-d2875",
      storageBucket: "ci-project-d2875.firebasestorage.app",
      messagingSenderId: "497518923896",
      appId: "1:497518923896:web:afe893f927e388211a1d8d",
      measurementId: "G-2YL0EGFJ69"
    ));
  }
  else {
    await Firebase.initializeApp();
  }

  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => const StartScreen(),
        "/login": (context) => const LoginScreen(),
        "/register": (context) => const RegisterScreen(),
        "/main": (context) => const MainScreen(),
        "/add-card": (context) => const AddCardScreen(),
        "/change-card": (context) => const ChangeCardScreen(),
        "/transactions-history": (context) => const TransactionHistoryScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == "/delete-card") {
          final args = settings.arguments as CreditCard?;
          return MaterialPageRoute(
            builder: (context) => DeleteCardScreen(currentCard: args),
          );
        }
        return null;
      },
    );
  }
}
