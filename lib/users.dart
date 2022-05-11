import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class User {
  String id;
  String fullName;
  String password;

  User({
    required this.id,
    required this.fullName,
    required this.password,
  });
}

class apiUser with ChangeNotifier {
  List<User> addNewUser = [];
  Object? authToken;
  apiUser({this.authToken, required this.addNewUser});

  ///api تعريف ليست  ل اضافة المعلومات اليها من ال

  ///
  ////
  /////
  Future<void> fetchData() async {
    /// api التحقق من اضافة المعلومات وجلب المعلومات من ال

    final String uri =
        'https://flutterapp-3a779-default-rtdb.firebaseio.com/users.json?auth=$authToken';

    /// http.get => api لجلب البيانات من ال فايربيز من ال
    http.Response res = await http.get(Uri.parse(uri));
    if (json.decode(res.body) == null) {
      return null;
    }
    ////data تخزين المعلومات في ال
    var data = json.decode(res.body) as Map<String, dynamic>;

    //// forEach : ل جلب المعلومات من ال داتا وتخزينها داخل ال ليست يلي عرفناها فوق الشي
    data.forEach(
      (key, value) {
        ////true اذا كانت المعلومات موجودة من قبل يرجع
        /// false غير ذلك
        var result = addNewUser.any(
          (element) => element.id == key,
        );

        /// false عندما يرجع
        /// يتم الاضافة الى ال ليست
        if (result == false) {
          addNewUser.add(
            User(
              id: key,
              fullName: value['fullName'],
              password: value['password'],
            ),
          );
          notifyListeners(); //// لا تنسى هل كلمة ياا عموو
        }
      },
    );
    print('fetchData successfully');

    notifyListeners(); //// لا تنسى هل كلمة ياا عموو
  }

  ///
  /////
  ////
  /////
  //
  Future<void> addItem({
    /// دالة ااضافة العناصر المطلوبة
    required String id,
    required String fullName,
    required String password,
  }) async {
    String uri =
        'https://flutterapp-3a779-default-rtdb.firebaseio.com/users.json';

    //post : لرفع البيانات الى الفايربيز
    //// عنصرين post يستقبل ال
    /// URI, body=> json.encode
    http.Response res = await http.post(Uri.parse(uri),
        body: json.encode({
          'fullName': fullName,
          'password': password,
        }));

    //// بعدها يتم الاضافة الى اليست
    addNewUser.add(User(
      id: json
          .decode(res.body)['name'], ////من الفايربيس مباشرة id نحرص ان يكون ال
      fullName: fullName,
      password: password,
    ));
    print('Added');
    notifyListeners();

    /// اهم كلمة ب الكود
  }

  ///
  ////
  ////

  ///
  //////
  ///
  ///
  Future<void> deleteData(String id) async {
    String uri =
        'https://flutterapp-3a779-default-rtdb.firebaseio.com/users/$id.json';

    final itemIndex = addNewUser.indexWhere((element) => element.id == id);
    var item = addNewUser[itemIndex]; //item اولاا نخزن المعلومات داخل
    addNewUser.removeAt(itemIndex);

    /// الخاص به index يتم حذف العنصر عن طريق ال

    var res = await http.delete(Uri.parse(uri));
    if (res.statusCode >= 400) {
      /// اذا كان فيه خطا في الحذف
      addNewUser.insert(itemIndex, item);

      /// يتم ارجاع العنصر الى مكانه
      notifyListeners();
      print("Could not deleted item");
    } else {
      print("Item deleted");
    }
  }
}
