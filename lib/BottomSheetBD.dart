import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class BottomSheetBD extends StatefulWidget {
  @override
  _BottomSheetBDState createState() => _BottomSheetBDState();
}

class _BottomSheetBDState extends State<BottomSheetBD> {
  String name, contact, age, gender = "M",bloodgroup;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            height: 400,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 10, color: Colors.grey[300], spreadRadius: 5)
                ]),
            child: Column(
              children: <Widget>[
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    decoration: InputDecoration.collapsed(hintText: "Name"),
                    onChanged: (val){
                      this.name=val;
                    },
                  ),
                ),
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    decoration: InputDecoration.collapsed(hintText: "Contact"),
                    onChanged: (val){
                      this.contact=val;
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(child:  Container(
                      height: 50,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        decoration: InputDecoration.collapsed(hintText: "Age"),
                        onChanged: (val){
                          this.age=val;
                        },
                      ),
                    ),),
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          gender = "M";
                        });
                      },
                      child: Text("M"),
                      color: gender == "M" ? Colors.blue : Colors.grey,
                    ),
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          gender = "F";
                        });
                      },
                      child: Text("F"),
                      color: gender == "F" ? Colors.blue : Colors.grey,
                    ),
                  ],
                ),
                SubmitBDB(map: {
                  "name":name,
                  "contact":contact,
                  "age":age,
                  "gender":gender,
                  "bloodgroup":"A"
                },)
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SubmitBDB extends StatefulWidget {
  var map;
  SubmitBDB ({ Key key, this.map }): super(key: key);

  @override
  _SubmitBDBState createState() => _SubmitBDBState();
}

class _SubmitBDBState extends State<SubmitBDB> {
  var result="false";
  bool checkingFlight = false;
  bool success = false;
  String btnText="Submit";
  @override
  Widget build(BuildContext context) {
    return !checkingFlight
        ? MaterialButton(
            color: Colors.grey[800],
            onPressed: () async {
              setState(() {
                checkingFlight = true;
              });
              print(widget.map);


              try{
                var url =
                    "https://unconcealed-carrier.000webhostapp.com/donationrequest.php";
                var res = await http.post(url, body: widget.map);
                result = jsonDecode(res.body);
              }catch(e){
                print(e);
              }
              if (result=="true"){

                setState(() {
                  success = true;
                });
                Navigator.pop(context);
              }else{
                setState(() {
                  checkingFlight=false;
                  btnText="error";
                });
              }

            },
            child: Text(
              btnText,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        : !success
            ? CircularProgressIndicator()
            : Icon(
                Icons.check,
                color: Colors.green,
              );
  }
}
