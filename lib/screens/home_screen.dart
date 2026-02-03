import 'package:flutter/material.dart';

import 'widgets/custom_container.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.pets_rounded),
            SizedBox(width: 10),
            Text('Veterinaria'),
          ],
        ),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Image.asset(
                      'assets/icon/icono.png',
                      height: 180,
                      width: 350,
                    ),
                    Text(
                      'Patitas Felices',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/owner');
                      },
                      child: CustomContainer(
                        texto: 'Dueños',
                        icon: Icons.people_alt_rounded,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),

                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/pet');
                      },
                      child: CustomContainer(
                        texto: 'Mascotas',
                        icon: Icons.pets_rounded,
                        color: Colors.indigoAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/vaccine');
                      },
                      child: CustomContainer(
                        texto: 'Vacunas',
                        icon: Icons.vaccines,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/veterinarian');
                      },
                      child: CustomContainer(
                        texto: 'Veterinarios',
                        icon: Icons.people_alt_rounded,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
