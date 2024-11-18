import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:user_data_system/ui/users/user_list-page.dart';

import '../../bloc/users/user_edit/user_edit_bloc.dart';
import '../../bloc/users/user_edit/user_edit_event.dart';
import '../../bloc/users/user_edit/user_edit_state.dart';
import '../../data/repository/user_repository.dart';
import '../../di/components/service_locator.dart';

class UserPhotoUploadPage extends StatefulWidget {
  String user_id; String user_photo;

  UserPhotoUploadPage({required this.user_id, required this.user_photo});

  @override
  _UserPhotoUploadPageState createState() => _UserPhotoUploadPageState();
}

class _UserPhotoUploadPageState extends State<UserPhotoUploadPage> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  File? file;
  String? selectFile;
  UserEditBloc _userEditBloc = UserEditBloc(getIt<UsersRepository>());

  @override
  void initState() {
    _userEditBloc.add(UserEditStart());
    _userEditBloc.add(UserPhotoUploadStart());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);

          return false;
        }, child: Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.teal,
        title: Text("Users Photo Upload"),


      ),
      body: Container(
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return blocData(widget.user_id);
          },
        ),
      ),
    )
    );
  }


  blocData(String user_id){
    return BlocBuilder<UserEditBloc,UserEditState>(
      bloc: _userEditBloc,
      builder: (context,state) {
        if (state is UserUploadPhotoLoading) {
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            showDialog(
                barrierColor: Color(0x00ffffff),
                context: context,
                builder: (BuildContext context){
                  return
                    Material(
                      type: MaterialType.transparency,
                      child: Center(
                          child: SpinKitThreeBounce(color: Color(0xff334A52),)
                      ),
                    );
                }
            );
          });
        }else if (state is UserUploadPhotoError) {
          _userEditBloc.add(UserPhotoUploadStart());
          WidgetsBinding.instance?.addPostFrameCallback((_){
            Navigator.pop(context);
            showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    content:
                    Text(
                        state.errorMessage,style: TextStyle(fontSize: 18,fontFamily: 'Poppins')
                    ),
                  );
                }
            );
          });
        } else if (state is UserUploadPhotoLoaded) {
          _userEditBloc.add(UserPhotoUploadStart());

          WidgetsBinding.instance?.addPostFrameCallback((_){
            print('loaded');
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(state.msg.toString(),
                            style: TextStyle(
                                fontSize: 18, fontFamily: 'Rasa')),
                        Padding(padding: EdgeInsets.only(top: 30)),
                        GestureDetector(
                          onTap: () {

                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        UserListPage()));

                          },
                          child: Container(
                            margin:
                            EdgeInsets.only(left: 20, right: 20),
                            height: 40,
                            decoration: BoxDecoration(
                                color: Color(0xff334A52),
                                borderRadius:
                                BorderRadius.circular(5.0)),
                            child: Center(
                              child: Text(
                                'OK',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Rasa',
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 20)),
                      ],
                    ));
              }
          );
          });
        }
        return Form(
            key: _key,
            child: formContainer(),
        );
      },

    );
  }


  formContainer(){
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 30,),
              Text(
                "Profile Picture",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'MyanmarSansPro',
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              ),
              Divider(
                thickness: 1,
              ),
              SizedBox(height: 30,),
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 4,
                      color: Theme.of(context)
                          .scaffoldBackgroundColor),
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 2,
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.1),
                        offset: Offset(0, 10))
                  ],
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: file != null
                        ? new FileImage(file!)
                        : ( widget.user_photo== '')
                        ? Image.asset(
                        'assets/images/person.jpg').image
                        : Image.network(widget.user_photo).image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 20)),
              GestureDetector(
                onTap: ()  async {
                  print('gall');
                  var res = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: [
                      'jpg',
                      'png',
                    ],
                  );

                  setState(() {
                    file = File(res!.files.single.path!);
                    selectFile = file!.path;

                  });

                  print(file.toString());
                  print('image');
                },
                child: Container(
                  margin: EdgeInsets.only(left: 30, right: 30),
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cloud_download,
                            color: Colors.grey,
                          ),
                          Text( 'Choose Image',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily:'Poppins'
                            ),)
                        ],
                      )),
                ),
              ),
              Padding(padding: EdgeInsets.only(left: 30,top: 30)),
              Container(
                margin: EdgeInsets.only(left: 20,right: 20),
                width: MediaQuery.of(context).size.width,
                child:  ElevatedButton(
                  onPressed: () {
                    print("upload");


                    _userEditBloc.add(UserPhotoUpload(
                        file: File(file!.path), user_id: widget.user_id
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 50),
                    backgroundColor: Colors.teal,
                  ),
                  child: const Text(
                    "Upload",
                    style: TextStyle(fontSize: 16,color: Colors.black),
                  ),
                ),
              ),

              Padding(padding: EdgeInsets.only(top: 10)),
            ])
    );
  }





}