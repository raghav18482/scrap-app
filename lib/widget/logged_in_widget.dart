import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scrap_app/provider/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class LoggedInWidget extends StatefulWidget {
  @override
  _MianScreenState createState() => _MianScreenState();
}

class _MianScreenState extends State<LoggedInWidget> {
  int _itemCount = 0;

  var jsonResponse;

  String _Query;
 // https://git.heroku.com/flupyscraping.git:5000/?query=$query
// http://172.16.15.33:5000/?query=$query"
  Future<void> getQuotes(query) async {
    String url = "http://172.16.15.33:5000/?query=$query";
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        jsonResponse = convert.jsonDecode(response.body); //decode json file
        _itemCount =
            jsonResponse.length; //if json have 20 quotes then length is 20
      });
//      jsonResponse[0]["author"]; = author name
//      jsonResponse[0]["quote"]; = quotes text
      print("Number of quotes found : $_itemCount.");
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text('You are going to exit the application!!'),
            actions: <Widget>[
              FlatButton(
                child: Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('YES'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey[800],
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                color: Colors.blueGrey[700],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Logged In',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    CircleAvatar(
                      maxRadius: 25,
                      backgroundImage: NetworkImage(user.photoURL),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Name: ' + user.displayName,
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Email: ' + user.email,
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    RaisedButton(
                      color: Colors.white30,
                      onPressed: () {
                        final provider = Provider.of<GoogleSignInProvider>(
                            context,
                            listen: false);
                        provider.logout();
                      },
                      child: Text('Logout'),
                    )
                  ],
                ),
              ),
              Container(
                height: _itemCount == 0 ? 65 : 550,
                child: _itemCount == 0
                    ? Text("Welcome",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 40))
                    : ListView.builder(
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                                color: Colors.white30,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            padding:
                                EdgeInsets.only(left: 20, right: 20, top: 10),
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  jsonResponse[index]["quote"], //quote
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  jsonResponse[index]["author"], //author name
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: _itemCount,
                      ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: MediaQuery.of(context).size.height / 1.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: "search quote here",
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white))),
                      onChanged: (value) {
                        _Query = value;
                        print(value);
                      },
                    ),
                    SizedBox(height: 70),
                    ButtonTheme(
                      minWidth: 100,
                      child: RaisedButton(
                        child: Text(
                          "get quotes",
                          style: TextStyle(color: Colors.black),
                        ),
                        color: Colors.white30,
                        onPressed: () {
                          getQuotes(_Query);
                          setState(() {
                            _itemCount = 0;
                          });
                        },
                      ),
                    )
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

//class LoggedInWidget extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    final user = FirebaseAuth.instance.currentUser;
//
//    return Container(
//      alignment: Alignment.center,
//      color: Colors.blueGrey.shade900,
//      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.center,
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: [
//          Text(
//            'Logged In',
//            style: TextStyle(color: Colors.white),
//          ),
//          SizedBox(height: 8),
//          CircleAvatar(
//            maxRadius: 25,
//            backgroundImage: NetworkImage(user.photoURL),
//          ),
//          SizedBox(height: 8),
//          Text(
//            'Name: ' + user.displayName,
//            style: TextStyle(color: Colors.white),
//          ),
//          SizedBox(height: 8),
//          Text(
//            'Email: ' + user.email,
//            style: TextStyle(color: Colors.white),
//          ),
//          SizedBox(height: 8),
//          ElevatedButton(
//            onPressed: () {
//              final provider =
//                  Provider.of<GoogleSignInProvider>(context, listen: false);
//              provider.logout();
//            },
//            child: Text('Logout'),
//          )
//        ],
//      ),
//    );
//  }
//}
