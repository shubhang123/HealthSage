import 'package:authapp/auth/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 40,
              ),
              Center(
                child: Image.asset(
                  'assets/logo.png',
                  height: 50,
                ),
              ),
              const SizedBox(
                height: 400,
              ),
              Text(
                'Welcome,',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              Text(
                'To your Personalised Health Assistant!',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  fontSize: 35,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                minWidth: double.infinity,
                height: 60,
                color: const Color(0xFF386cf1),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const AuthScreen())));
                },
                child: Text(
                  'Get Started',
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.w900,
                    fontSize: 25,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
