import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  )); 
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;
  int energyLevel = 100;
  final TextEditingController nameController = TextEditingController();
  Timer? hungerTimer;
  int winCounter = 0;

  Color _moodColor(double happinessLevel) {
    if (happinessLevel > 70) {
      return Colors.green;
    } else if (happinessLevel >= 30) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  String moodIndicator(int happinessLevel) {
    if (happinessLevel > 70) {
      return "Happy 😊";
    } else if (happinessLevel >= 30) {
      return "Neutral 😐";
    } else {
      return "Unhappy 😢";
    }
  }

  void _playWithPet() {
    setState(() {
      happinessLevel += 10;
      if (happinessLevel > 100) happinessLevel = 100;

      energyLevel -= 15;
      if (energyLevel < 0) energyLevel = 0;

      _updateHunger();
      checkWinLoss();
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel -= 10;
      if (hungerLevel < 0) hungerLevel = 0;

      energyLevel += 5;
      if (energyLevel > 100) energyLevel = 100;

      _updateHappiness();
      checkWinLoss();
    });
  }

  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel -= 20;
    } else {
      happinessLevel += 10;
    }
    if (happinessLevel > 100) happinessLevel = 100;
    if (happinessLevel < 0) happinessLevel = 0;
  }

  void _updateHunger() {
    hungerLevel += 5;
    if (hungerLevel > 100) hungerLevel = 100;
  }

  void checkWinLoss() {
    if (hungerLevel == 100 && happinessLevel <= 10) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Game Over"),
          content: Text("Your pet is too hungry and unhappy."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }

    if (happinessLevel > 80) {
      winCounter++;
      if (winCounter >= 6) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("You Win!"),
            content: Text("Your pet stayed very happy for 3 minutes."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Nice!"),
              ),
            ],
          ),
        );
      }
    } else {
      winCounter = 0;
    }
  }

  @override
  void initState() {
    super.initState();
    hungerTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      setState(() {
        hungerLevel += 5;
        if (hungerLevel > 100) hungerLevel = 100;
        checkWinLoss();
      });
    });
  }

  @override
  void dispose() {
    hungerTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Digital Pet")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Enter Pet Name",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  petName = nameController.text;
                });
              },
              child: Text("Set Name"),
            ),
            SizedBox(height: 20),
            Text(
              petName,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                _moodColor(happinessLevel.toDouble()),
                BlendMode.modulate,
              ),
              child: Image.asset(
                'assets/pet_image.png',
                height: 200,
              ),
            ),
            SizedBox(height: 20),
            Text("Happiness: $happinessLevel"),
            Text("Hunger: $hungerLevel"),
            Text("Energy: $energyLevel"),
            SizedBox(height: 5),
            LinearProgressIndicator(
              value: energyLevel / 100,
              minHeight: 12,
              backgroundColor: Colors.grey.shade300,
              color: Colors.blue,
            ),
            SizedBox(height: 10),
            Text(
              moodIndicator(happinessLevel),
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _playWithPet,
              child: Text("Play"),
            ),
            ElevatedButton(
              onPressed: _feedPet,
              child: Text("Feed"),
            ),
          ],
        ),
      ),
    );
  }
}