import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'database_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FORM'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: mobileController,
              decoration: InputDecoration(labelText: 'Mobile'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                Map<String, dynamic> row = {
                  'name': nameController.text,
                  'age': int.parse(ageController.text),
                  'mobile': mobileController.text,
                  'email': emailController.text,
                };
                await DatabaseHelper.instance.insert(row);
                clearTextFields();
              },
              child: Text('Add Data'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DataListPage()),
                );
              },
              child: Text('View Data'),
            ),
          ],
        ),
      ),
    );
  }

  void clearTextFields() {
    nameController.clear();
    ageController.clear();
    mobileController.clear();
    emailController.clear();
  }
}

class DataListPage extends StatefulWidget {
  @override
  _DataListPageState createState() => _DataListPageState();
}

class _DataListPageState extends State<DataListPage> {
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    var result = await DatabaseHelper.instance.queryAll();
    setState(() {
      data = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data List'),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return ListTile(

            title:Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('name: ${data[index]['name']}'),
                    Text('Age: ${data[index]['age']}'),
                    Text('mobile: ${data[index]['mobile']}'),
                    Text('email: ${data[index]['email']}'),

               ]
            ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Options'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        editData(data[index]);
                      },
                      child: Text('Edit'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await DatabaseHelper.instance
                            .delete(data[index]['_id']);
                        getData();
                      },
                      child: Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> editData(Map<String, dynamic> row) async {


      await DatabaseHelper.instance.update(row);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditDataPage(row: row),
      ),

    );

  }
}

class EditDataPage extends StatefulWidget {
  final Map<String, dynamic> row;

  EditDataPage({required this.row});

  @override
  _EditDataPageState createState() => _EditDataPageState();
}

class _EditDataPageState extends State<EditDataPage> {
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.row['name'];
    ageController.text = widget.row['age'].toString();
    mobileController.text = widget.row['mobile'];
    emailController.text = widget.row['email'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [





            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: mobileController,
              decoration: InputDecoration(labelText: 'Mobile'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                try {

                  Map<String, dynamic> updatedRow = {
                    '_id': widget.row['_id'],
                    'name': nameController.text,
                    'age': int.parse(ageController.text),
                    'mobile': mobileController.text,
                    'email': emailController.text,
                  };

                  await DatabaseHelper.instance.update(updatedRow);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DataListPage()),
                  );

                } catch (e) {
                  print('Error updating data: $e');
                  // Handle the error, such as showing a dialog or snackbar to the user
                }


              },


              child: const Text('Update Data'),
            )
          ],
        ),
      ),
    );
  }
}
