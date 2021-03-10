import 'package:Chats/searchitem.dart';
import 'package:Chats/services/database.dart';
import 'package:Chats/userInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchbyusername = new TextEditingController();
  Database database = new Database();

  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  QuerySnapshot querySnapshot;

  makeSearch() {
    database.fetchUserFromDatabase(searchbyusername.text).then((value) {
      setState(() {
        querySnapshot = value;
      });
    });
  }

  Widget searchItems() {
    return querySnapshot == null
        ? Container()
        : ListView.builder(
            shrinkWrap: true,
            itemCount: querySnapshot.docs.length,
            itemBuilder: (context, index) {
              return SearchItem(
                  username: querySnapshot.docs[index].data()['uname'],
                  email: querySnapshot.docs[index].data()['email']);
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Chats',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.orange[200],
        bottomOpacity: 0.0,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.black,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(5, 12, 5, 12),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.orange[200],
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchbyusername,
                        decoration: InputDecoration(
                          hintText: 'Search by username',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (searchbyusername.text != UserInfo.userName) {
                          makeSearch();
                        } else {
                          _scaffoldkey.currentState.showSnackBar(SnackBar(
                            content: Text('You cannot message to yourself!!!', style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Raleway',
                              fontSize: 18
                            ),),
                            backgroundColor: Colors.orange[200],
                            duration: Duration(milliseconds: 2000),
                          ));
                        }
                      },
                      child: Container(
                          margin: EdgeInsets.only(right: 5, left: 5),
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border:
                                Border.all(width: 3, color: Colors.orange[200]),
                            color: Colors.black,
                          ),
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                          )),
                    )
                  ],
                ),
              ),
              Expanded(child: searchItems()),
            ],
          ),
        ),
      ),
    );
  }
}
