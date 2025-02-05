import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: DigitalPetApp(),
      ),
    );
  }
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp>
    with SingleTickerProviderStateMixin, RestorationMixin {
  late TabController _tabController;
  final RestorableInt tabIndex = RestorableInt(0);
  int happiness = 50;
  int hunger = 50;

  @override
  String get restorationId => 'digital_pet_app';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(tabIndex, 'tab_index');
    _tabController.index = tabIndex.value;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
    _tabController.addListener(() {
      setState(() {
        tabIndex.value = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    tabIndex.dispose();
    super.dispose();
  }

  void feedPet() {
    setState(() {
      hunger = (hunger - 10).clamp(0, 100);
      happiness = (happiness + 5).clamp(0, 100);
    });
  }

  void playWithPet() {
    setState(() {
      happiness = (happiness + 10).clamp(0, 100);
      hunger = (hunger + 5).clamp(0, 100);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabs = ['Home', 'Kitchen🍽️', 'Backyard🌳'];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Digital Pet'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: false,
          tabs: [
            for (final tab in tabs) Tab(text: tab),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/pet-background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/pet.png', height: 150),
                  Text('Happiness: $happiness%',
                      style: TextStyle(fontSize: 20)),
                  Text('Hunger: $hunger%', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/feed_background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: ElevatedButton(
                onPressed: feedPet,
                child: Text('Feed Pet'),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/play_background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: ElevatedButton(
                onPressed: playWithPet,
                child: Text('Play with Pet'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
