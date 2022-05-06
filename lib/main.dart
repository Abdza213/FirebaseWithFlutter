import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sampleproject/users.dart';

import 'flaotaingButtonScreen.dart';

void main() {
  runApp(
    ChangeNotifierProvider<apiUser>(
      create: (_) => apiUser(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.orange,
          scaffoldBackgroundColor: Colors.orange[50],
        ),
        home: homePage(),
      ),
    ),
  );
}

class homePage extends StatefulWidget {
  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  bool isLoading = true;
  @override
  void initState() {
    ////
    ////
    ///fetchData() يتم هناا استدعاء البيانات من
    ///
    Provider.of<apiUser>(context, listen: false).fetchData().then((_) {
      setState(() {
        isLoading = false;
      });

      ///isLoading = false  اذا تم الاارجاع بشكل صحيح يرجع قيمة ال
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var newUser = Provider.of<apiUser>(context, listen: true).addNewUser;

    ///
    ////هناا يتم ارجاع ليست يلي ضفناها اول شي
    ///

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home Page',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('new user'),
        icon: Icon(Icons.add),
        onPressed: (() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => floatingButton()),
            ),
          );
        }),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : newUser.isEmpty
              ? RefreshIndicator(
                  onRefresh: () async =>
                      await Provider.of<apiUser>(context, listen: false)
                          .fetchData(),
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 600,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            'there are no items',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                      ),
                    ],
                  ))
              : isLoading
                  ? Center(child: CircularProgressIndicator())

                  /// دالة ل عمل ريفريش للصفحة تكتب بهذا الشكل
                  ////RefreshIndicator(
                  /// onRefresh : fetchData(),
                  /// child : ListVie.builder()
                  /// )
                  ////
                  : RefreshIndicator(
                      onRefresh: () async =>
                          await Provider.of<apiUser>(context, listen: false)
                              .fetchData(),
                      child: ListView.builder(
                        // physics: BouncingScrollPhysics(),
                        itemCount: newUser.length,
                        itemBuilder: (context, index) {
                          return CardInf(newUser[index].fullName,
                              newUser[index].password, newUser[index].id);
                        },
                      ),
                    ),
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
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: ((context) => homePage())));
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
