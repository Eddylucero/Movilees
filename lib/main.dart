import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/owner/owner_form_screen.dart';
import 'screens/owner/owner_screen.dart';
import 'screens/pet/pet_form_screen.dart';
import 'screens/pet/pet_screen.dart';
import 'screens/vaccine/vaccine_form_screen.dart';
import 'screens/vaccine/vaccine_screen.dart';
import 'screens/veterinarian/veterinarian_form_screen.dart';
import 'screens/veterinarian/veterinarian_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/owner': (context) => const OwnerScreen(),
        '/owner/form': (context) => const OwnerFormScreen(),
        '/pet': (context) => const PetScreen(),
        '/pet/form': (context) => const PetFormScreen(),
        '/vaccine': (context) => const VaccineScreen(),
        '/vaccine/form': (context) => const VaccineFormScreen(),
        '/veterinarian': (context) => const VeterinarianScreen(),
        '/veterinarian/form': (context) => const VeterinarianFormScreen(),
      },
    );
  }
}
