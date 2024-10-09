import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(SalesApp());
}

class SalesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MESales',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(), // Display splash screen initially
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => HomePage(), // Navigate to HomePage after 3 seconds
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color for splash screen
      body: Center(
        child: Image.asset(
          'assets/Logo-RBG.png', // Replace 'splash.png' with your splash screen image
          width: MediaQuery.of(context).size.width * 0.7, // Adjust width as needed
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _consumerNumberController = TextEditingController();
  String _sectionName = '';
  String _divisionName = '';

  Future<void> _getInfo() async {
    String consumerNumber = _consumerNumberController.text;

    // Construct the URL to your PHP script
    String apiUrl = 'https://salesapp.sunsenz.com/get_info.php';

    // Make a POST request to your PHP script
    var response = await http.post(Uri.parse(apiUrl), body: {
      'consumer_number': consumerNumber,
    });

    if (response.statusCode == 200) {
      // Decode the response body
      Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        _sectionName = data['section_name'];
        _divisionName = data['division_name'];
      });
    } else {
      print('Error fetching data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF070578), // Set background color to #070578
        centerTitle: true, // Move title to center
        title: const Text(
          'Moopens Sales Mate',
          style: TextStyle(
            fontSize: 22, // Reduce title size
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7, // Adjust the width as needed
                  child: Image.asset(
                    'assets/logo-sunsenz.png', // Replace 'your_image.png' with the actual image asset path
                    fit: BoxFit.contain, // Ensure the image fits within the container
                  ),
                ),
                const SizedBox(height: 35),
                const Text(
                  'Customer\'s KSEB Section & Division Finder',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFA8180D),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _consumerNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Consumer Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _getInfo,
                  child: const Text('Get Info'),
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                ),
                const SizedBox(height: 20),
                _sectionName.isNotEmpty
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center, // Align horizontally in the center
                            crossAxisAlignment: CrossAxisAlignment.center, // Align vertically in the center
                            children: [
                              const Text(
                                'Section / Subdivision Name: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.black, // Change the color of the label to black
                                ),
                              ),
                              Text(
                                _sectionName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFF0da881), // Color of the data
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center, // Align horizontally in the center
                            crossAxisAlignment: CrossAxisAlignment.center, // Align vertically in the center
                            children: [
                              const Text(
                                'Division Name: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.black, // Change the color of the label to black
                                ),
                              ),
                              Text(
                                _divisionName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFFa80d3e), // Color of the data
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
