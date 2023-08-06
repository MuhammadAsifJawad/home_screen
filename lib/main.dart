import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = true;
  bool hideNext = false;
  List<dynamic> data = [];
  Future<void> getData(int pageNo) async {
    setState(() {
      isLoading = true;
    });
    final response =
        await http.get(Uri.parse('https://reqres.in/api/users?page=$pageNo'));
    if (response.statusCode == 200 && pageNo == 1) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        data = jsonResponse['data'];
        print('successfull get data!!!');
        isLoading = false;
      });
    } else if (response.statusCode == 200 && pageNo == 2) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        data += jsonResponse['data'];
        isLoading = false;
        hideNext = true;
        print(data);
      });
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData(1);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 70,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(80.0),
                  bottomRight: Radius.circular(80.0),
                ),
              ),
              child: Container(
                alignment: Alignment.center,
                child: const Text(
                  'Home Screen',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20, // Number of columns in the grid
                        ),
                        itemCount: data.length, // Number of items in the grid
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 4,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  30.0), // Adjust the radius as needed
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        Image.network(data[index]['avatar'])
                                            .image,
                                    radius: 30.0,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                      'Name: ${data[index]['first_name']} ${data[index]['last_name']}'),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
            Container(
              alignment: Alignment.center,
              child: Visibility(
                visible: !hideNext,
                child: TextButton(
                  onPressed: () {
                    getData(2);
                  },
                  child: const Text(
                    'Next>>',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
