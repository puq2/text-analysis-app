import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class APIService {
  Future<List> postRequest (data) async {
    var url ='https://api.monkeylearn.com/v3/classifiers/cl_pi3C7JiL/classify/';
    var url2 ='https://api.monkeylearn.com/v3/classifiers/cl_o46qggZq/classify/';
    var body = jsonEncode(<String, List>{
      'data': [data],
    });
    print(body);
    final response = await http.post(
      url,
      headers: {
      'Authorization': 'Token b5ba7e42bfaafc31bb3b46c9a6758b90261a5b50',
      'Content-Type': 'application/json',
      },
      body: body,
    );
    final response2 = await http.post(
      url2,
      headers: {
      'Authorization': 'Token b5ba7e42bfaafc31bb3b46c9a6758b90261a5b50',
      'Content-Type': 'application/json',
      },
      body: body,
    );
    print(response.statusCode);
    print(response);
    if (response.statusCode == 200) {
      print('success' + response.body);
      final splitted = response.body.split('tag_name":"');
      final splitted_2 = (splitted[1].split('","tag_id'))[0];
      print(response2.body);
      final split = response2.body.split('tag_name":"');
      final split_2 = (split[1].split('","tag_id'))[0];
      print(splitted_2);
      print(split_2);
      return ([splitted_2,split_2]);
    } else {
      print("Failed");
      throw Exception('Failed to load json data');
    }
  }
}

class SentAna {
  final String emotions;

  SentAna({this.emotions});

  factory SentAna.fromJson(Map<List, List> json) {
    return SentAna(emotions: json['emotions_detected'][0]);
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  final myController = TextEditingController();

  APIService apiService = APIService();
  Future<List<dynamic>> analysis;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.004, 1],
            colors: [
              Color.fromARGB(255, 109, 109, 109),
              Color.fromARGB(255, 59, 59, 59),
            ],
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.all(
                  30,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Text Analysis',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 28),
                    ),
                    SizedBox(height: 30),
                   Container(
                      height: 50,
                      child: Image.asset('assets/text.png'),
                    ),
                    SizedBox(height: 40),
                    Container(
                      child: Center(
                        child: _loading
                            ? Container(
                                width: 300,
                                child: Column(
                                  children: <Widget>[
                                    TextField(
                                      controller: myController,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      decoration: InputDecoration(
                                          labelStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 21,
                                          ),
                                          labelText: 'Enter text: '),
                                    ),
                                    SizedBox(height: 30),
                                  ],
                                ))
                            : Container(),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                // _loading = false;
                                print(myController.text);
                                analysis = apiService
                                    .postRequest(myController.text);
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width - 180,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 17),
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 83, 177, 40),
                                  borderRadius: BorderRadius.circular(6)),
                              child: Text(
                                'Analyze Text',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          FutureBuilder<List<dynamic>>(
                            future: analysis,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  print(snapshot.data);
                                  return Text(
                                    'Sentiment is: ' + snapshot.data[0]+'\n Topic is: ' + snapshot.data[1],
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 29,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text('${snapshot.error}');
                                }
                                return CircularProgressIndicator();
                              })
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
