import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _chat = TextEditingController();

  final Stream<QuerySnapshot> streamdata =
      FirebaseFirestore.instance.collection("chat").snapshots();

  ScrollController _scroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        title: Text("HomePage"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: streamdata,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print("somthin went wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final List<dynamic> storeData = [];
          snapshot.data!.docs.map((DocumentSnapshot document) {
            Map a = document.data() as Map<String, dynamic>;

            storeData.add(a);
          }).toList();

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scroll,
                  itemCount: storeData.length,
                  itemBuilder: (context, index) {
                    if (index == storeData.length) {
                      return Container(
                        height: 70,
                      );
                    }
                    final harshId = storeData[index]['harshId'];
                    final ruchitId = storeData[index]['ruchitId'];
                    final pradipId = storeData[index]['pradipId'];
                    final htime = storeData[index]['time'];
                    return Slidable(
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        extentRatio: .20,
                        children: [
                          SlidableAction(
                            onPressed: (context) async {
                              storeData != null
                                  ? await FirebaseFirestore.instance
                                      .collection('chat')
                                      .doc(storeData[index]['harshId'])
                                      .delete()
                                  : SizedBox();
                              storeData != null
                                  ? await FirebaseFirestore.instance
                                      .collection('chat')
                                      .doc(storeData[index]['pradipId'])
                                      .delete()
                                  : SizedBox();
                              storeData != null
                                  ? await FirebaseFirestore.instance
                                      .collection('chat')
                                      .doc(storeData[index]['ruchitId'])
                                      .delete()
                                  : SizedBox();
                            },
                            borderRadius: BorderRadius.circular(10),
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      // child: Align(
                      //   alignment: storeData[index]['harshId'] != null
                      //       ? Alignment.centerRight
                      //       : Alignment.centerLeft,
                      //   child: Padding(
                      //     padding: harshId != null
                      //         ? EdgeInsets.only(left: 50)
                      //         : EdgeInsets.only(right: 50),
                      //     child: Card(
                      //       shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(10)),
                      //       color: harshId != null
                      //           ? Colors.green[100]
                      //           : Colors.white,
                      //       margin: EdgeInsets.symmetric(
                      //           horizontal: 10, vertical: 3),
                      //       child: Padding(
                      //         padding:
                      //             const EdgeInsets.symmetric(horizontal: 10.0),
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             Text(
                      //               ruchitId != null
                      //                   ? 'Ruchit'
                      //                   : pradipId != null
                      //                       ? 'Pradip'
                      //                       :"Harsh",
                      //               style: TextStyle(
                      //                   fontSize: 15,
                      //                   color: ruchitId != null
                      //                       ? Colors.red
                      //                       : pradipId != null
                      //                           ? Colors.green
                      //                           : Colors.blue,
                      //                   fontWeight: FontWeight.bold),
                      //             ),
                      //             Wrap(
                      //               alignment: WrapAlignment.end,
                      //               children: [
                      //                 Text(
                      //                   storeData[index]['text'],
                      //                   style: TextStyle(fontSize: 14),
                      //                 ),
                      //                 SizedBox(
                      //                   width: 8,
                      //                 ),
                      //                 Column(
                      //                   children: [
                      //                     SizedBox(
                      //                       height: 5,
                      //                     ),
                      //                     Text(
                      //                       htime.toString(),
                      //                       style: TextStyle(
                      //                           fontSize: 12,
                      //                           color: Colors.grey),
                      //                     ),
                      //                   ],
                      //                 )
                      //               ],
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      child: Align(
                        alignment: harshId != null ? Alignment.centerRight:Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: harshId != null ?Colors.blue:Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                            storeData[index]['text'],
                                            style: TextStyle(fontSize: 14),
                                          ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _chat,
                          minLines: 1,
                          maxLines: 5,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                left: 25,
                                bottom: 10,
                                top: 10,
                              ),
                              filled: true,
                              hintText: "message",
                              fillColor: Colors.blueGrey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(350),
                              )),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      CircleAvatar(
                        radius: 25,
                        child: IconButton(
                          onPressed: () async {
                            if (_chat.text == "") {
                              print("isEmpty");
                            } else {
                              final id_DatTime = DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString();
                              final datTime =
                                  DateFormat("hh:mm a").format(DateTime.now());
                              _scroll.animateTo(
                                  _scroll.position.maxScrollExtent + 80,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.bounceOut);
                              await FirebaseFirestore.instance
                                  .collection('chat')
                                  .doc(id_DatTime)
                                  .set({
                                "text": _chat.text,
                                "harshId": id_DatTime,
                                "time": datTime
                              });
                              _chat.clear();
                            }
                          },
                          icon: Icon(Icons.send),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}



// showMenu(context: context, position: RelativeRect.fill, items: [
//                           PopupMenuItem(
//                                 onTap: ()async {
//                                   await FirebaseFirestore.instance
//                                       .collection('chat')
//                                       .doc(storeData[index]['id'])
//                                       .delete();
//                                 },
//                                 child: Row(
//                                   children: [
//                                     Icon(Icons.delete),
//                                     Text("Delete")
                                    
//                                   ],
//                                 ),
//                               ),
//                         ]);