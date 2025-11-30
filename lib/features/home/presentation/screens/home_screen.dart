import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        // title: TextField(),
        title: Row(
          children: [
            // ElevatedButton(onPressed: (){
            //   Navigator.pushNamed(context, '/search');
            // },
            //     child: const Text("Search"))

            //using icon button to navigate to search screen
            // icon button is a button with an icon
            IconButton(
              // here we are using search icon
              //search icon is available from Icons.search
              icon: const Icon(Icons.search),
              onPressed: (){
                //using on Pressed to navigate to search screen
                //when we press the button
                Navigator.pushNamed(context, '/search');
              },
            )
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('This is the Home Screen.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/article');
              },
              child: const Text('Go to Article Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
