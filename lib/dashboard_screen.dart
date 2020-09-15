import 'dart:convert';

import 'package:iblood/recent_update_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'BottomSheetBD.dart';

class Temp extends StatefulWidget {
  @override
  _TempState createState() => _TempState();
}

class _TempState extends State<Temp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double bannerHeight, listHeight, listPaddingTop;
  double cardContainerHeight, cardContainerTopPadding;

  @override
  Widget build(BuildContext context) {
    bannerHeight = MediaQuery.of(context).size.height * .25;
    listHeight = MediaQuery.of(context).size.height * .75;
    cardContainerHeight = 200;
    cardContainerTopPadding = bannerHeight / 2;
    listPaddingTop = cardContainerHeight - (bannerHeight / 2);
    Future a = getProjectDetails();
    return Scaffold(
      body: Stack(
        children: <Widget>[
          new Column(
            children: <Widget>[
              topBanner(context),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey.shade300,
                  padding: new EdgeInsets.only(
                      top: listPaddingTop, right: 10.0, left: 10.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        verticalDirection: VerticalDirection.down,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text("Recent Updates",
                                style: TextStyle(
                                    color: Colors.black87, fontSize: 17.0)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  a = getProjectDetails();
                                });
                              },
                              child: Text("View All",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0)),
                            ),
                          )
                        ],
                      ),
                      Expanded(
                        child: FutureBuilder(
                          builder: (context, snap) {
                            print(snap.connectionState);
                            print(snap.data.length.runtimeType);
                            if (snap.connectionState ==
                                ConnectionState.waiting) {
                              print('project snapshot data is: ${snap.data}');
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: false,
                                itemCount: snap.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return RecentUpdateListWidget(
                                    receiverAge: snap.data[snap.data.length-index-1]['age'],
                                    receiverSex: snap.data[snap.data.length-index-1]['gender'],
                                    receiverName: snap.data[snap.data.length-index-1]['name'],
                                    bloodgroup: snap.data[snap.data.length-index-1]['bloodgroup'],
                                  );
                                });
                          },
                          future: a,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(top: 50.0, right: 20.0, left: 20.0),
              child: Text(
                "Blood Requests",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              )),
          Container(
            alignment: Alignment.topCenter,
            padding: new EdgeInsets.only(
                top: cardContainerTopPadding, right: 20.0, left: 20.0),
            child: Container(
              height: cardContainerHeight,
              width: MediaQuery.of(context).size.width,
              child: Container(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FloatingActionButton(
                        onPressed: () {
                          var sheetController = showBottomSheet(
                              context: context,
                              builder: (context) => BottomSheetBD());

                          sheetController.closed.then((value) {});
                        },
                      ),
                      SizedBox(
                        height: 60.0,
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future getProjectDetails() async {
    var result;
    var url =
        "https://unconcealed-carrier.000webhostapp.com/getdonationrequest.php";

    var res = await http.get(url);
    result = jsonDecode(res.body);
    return result;
  }

  Container topBanner(BuildContext context) {
    return Container(
      height: bannerHeight,
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        const Color.fromARGB(1000, 157, 37, 24),
        const Color.fromARGB(1000, 212, 47, 33),
      ])),
    );
  }
}
