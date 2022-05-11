import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sampleproject/Auth.dart';
import 'package:sampleproject/TextformFaild.dart';
import 'package:sampleproject/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'flaotaingButtonScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences a1 = await SharedPreferences.getInstance();
  var fetch1 = a1.getString('key');
  var fetch2 = a1.getBool('fetch');
  Auth s1 = new Auth();
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider<Auth>(
            create: (_) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, apiUser>(
            create: (_) => apiUser(addNewUser: []),
            update: (ctx, value, _) => apiUser(
              addNewUser: _!.addNewUser,
              authToken: value.token,
            ),
          ),
        ],
        child: Consumer<Auth>(
          builder: (context, value, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.orange,
              scaffoldBackgroundColor: Colors.orange[50],
            ),
            home: fetch2 == true
                ? homePage(
                    keyItem: fetch1 as String,
                  )
                : textFormFail(),
          ),
        )),
  );
}

class homePage extends StatefulWidget {
  String keyItem;
  homePage({required this.keyItem});
  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  bool isLoading = true;
  // shardeInf() async {
  //   SharedPreferences s1 = await SharedPreferences.getInstance();
  //   var x = Provider.of<Auth>(context, listen: false).addIdUser;
  //   setState(() {
  //     s1.setBool('fetchkey', false);

  //     Future.delayed(Duration(seconds: 2));
  //     x.isEmpty ? s1.setString('key', '') : s1.setString('key', '${x[0].id}');
  //     print('================ ${s1.getString('key')}');
  //   });
  // }

  @override
  void initState() {
    ////
    ////
    ///fetchData() يتم هناا استدعاء البيانات من
    ///
    // Provider.of<apiUser>(context, listen: false).fetchData().then((_) {
    //   setState(() {
    //     isLoading = false;
    //   });

    //   ///isLoading = false  اذا تم الاارجاع بشكل صحيح يرجع قيمة ال
    // });
    // setState(() {
    //   shardeInf();
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var newUser = Provider.of<apiUser>(context, listen: true).addNewUser;

    ///
    ////هناا يتم ارجاع ليست يلي ضفناها اول شي
    ///
    var x = Provider.of<Auth>(context, listen: false).addIdUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home Page',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.white,
                ),
              ),
              onPressed: () async {
                SharedPreferences s1 = await SharedPreferences.getInstance();
                s1.setBool('fetch', false);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => textFormFail()),
                  ),
                );
                print('==============   ${s1.getBool('fetch')}');
                print('object');
              },
              child: Text(
                'SIGN OUT',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   label: Text('new user'),
      //   icon: Icon(Icons.add),
      //   onPressed: (() {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: ((context) => floatingButton()),
      //       ),
      //     );
      //   }),
      // ),
      body: !(widget.keyItem.isEmpty)
          ? StreamBuilder<QuerySnapshot>(
              builder: ((context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                List<DocumentSnapshot> s1 = snapshot.data!.docs;

                if (snapshot.hasData) {
                  return !(s1.isEmpty)
                      ? Center(
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              width: 350,
                              height: 500,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                //(s1[0] as dynamic)['email']
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 110,
                                    backgroundColor: Colors.orange[100],
                                    child: FutureBuilder(
                                      future:
                                          Future.delayed(Duration(seconds: 1)),
                                      builder: (context, snapshot) {
                                        return snapshot.connectionState !=
                                                ConnectionState.waiting
                                            ? ClipOval(
                                                child: (s1[0].data()
                                                                as dynamic)[
                                                            'image_url'] !=
                                                        ''
                                                    ? Image.network(
                                                        (s1[0].data()
                                                                as dynamic)[
                                                            'image_url'],
                                                        fit: BoxFit.cover,
                                                        width: 200,
                                                        height: 200,
                                                      )
                                                    : Icon(
                                                        FontAwesomeIcons.user,
                                                        size: 60,
                                                      ),
                                              )
                                            : CircularProgressIndicator();
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    '${(s1[0] as dynamic)['userName']}',
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '${(s1[0] as dynamic)['email']}',
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '${(s1[0] as dynamic)['password']}',
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Center(child: CircularProgressIndicator());
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
              stream: FirebaseFirestore.instance
                  .collection('newAccount/${widget.keyItem}/message')
                  .snapshots(),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),

      // isLoading
      //     ? Center(
      //         child: CircularProgressIndicator(),
      //       )
      //     : newUser.isEmpty
      //         ? RefreshIndicator(
      //             onRefresh: () async =>
      //                 await Provider.of<apiUser>(context, listen: false)
      //                     .fetchData(),
      //             child: ListView(
      //               children: [
      //                 SizedBox(
      //                   height: 600,
      //                   child: Container(
      //                     alignment: Alignment.center,
      //                     child: Text(
      //                       'there are no items',
      //                       style: TextStyle(fontSize: 25),
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ))
      //         : isLoading
      //             ? Center(child: CircularProgressIndicator())

      //             /// دالة ل عمل ريفريش للصفحة تكتب بهذا الشكل
      //             ////RefreshIndicator(
      //             /// onRefresh : fetchData(),
      //             /// child : ListVie.builder()
      //             /// )
      //             ////
      //             : RefreshIndicator(
      //                 onRefresh: () async =>
      //                     await Provider.of<apiUser>(context, listen: false)
      //                         .fetchData(),
      //                 child: ListView.builder(
      //                   // physics: BouncingScrollPhysics(),
      //                   itemCount: newUser.length,
      //                   itemBuilder: (context, index) {
      //                     return CardInf(newUser[index].fullName,
      //                         newUser[index].password, newUser[index].id);
      //                   },
      //                 ),
      //               ),
    );
  }

  Widget CardInf(String name, String pass, String id) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        title: Text(
          '$name',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Container(
          padding: EdgeInsets.all(5),
          child: Text(
            '$pass',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
        trailing: Container(
            margin: EdgeInsets.all(5),
            child: CircleAvatar(
              backgroundColor: Colors.orange,
              radius: 30,
              child: InkWell(
                onTap: (() {
                  var deleterItem = Provider.of<apiUser>(context, listen: false)
                      .deleteData(id)

                      /// هنا حذف البيانات
                      .then((_) {
                    // عند الحذف يتم فتح الصفحة مرة اخرى
                    Provider.of<apiUser>(context, listen: false).fetchData();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => homePage(
                                  keyItem: '',
                                ))));
                  });
                  print('delleted');
                }),
                child: Icon(
                  Icons.delete,
                  color: Colors.black,
                ),
              ),
            )),
      ),
    );
  }
}
