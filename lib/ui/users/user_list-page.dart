import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:user_data_system/bloc/users/user_edit/user_edit_event.dart';
import 'package:user_data_system/bloc/users/users_event.dart';
import 'package:user_data_system/data/repository/user_repository.dart';
import 'package:user_data_system/ui/users/user_edit.dart';
import 'package:user_data_system/ui/users/user_new_page.dart';
import 'package:user_data_system/ui/users/user_photo_upload_page.dart';
import '../../bloc/users/user_edit/user_edit_bloc.dart';
import '../../bloc/users/user_edit/user_edit_state.dart';
import '../../bloc/users/users_bloc.dart';
import '../../bloc/users/users_state.dart';
import '../../data/sharedpreference/shared_preference_helper.dart';
import '../../di/components/service_locator.dart';


class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  var sharedPreference=getIt<SharedPreferenceHelper>();
  String dropdownvalue = 'Item 1';
  UsersBloc _usersBloc = UsersBloc(getIt<UsersRepository>());
  UserEditBloc _userEditBloc = UserEditBloc(getIt<UsersRepository>());
  var token;
  File? file;
  String? selectFile;

  // List of items in our dropdown menu
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];


  @override
  void initState() {
    // TODO: implement initState

    _usersBloc.add(FetchUsers());
    token  = sharedPreference.getLoginToken.toString();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      print("After clicking the Signup Back Button");
      SystemNavigator.pop();

      return false;
    },child:Scaffold(

        appBar: AppBar(
          automaticallyImplyLeading: false,
          brightness: Brightness.dark,
          backgroundColor: Colors.teal,
          title: Text("Home"),
          actions: [
            TextButton(onPressed: (){
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (BuildContext context) =>
                      UserNewPage(
                      )
                  ));
            },
                child: Text("Add New User",  style: TextStyle(color: Colors.white)),
           )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 25, left: 15, right: 15),
                child: BlocBuilder<UsersBloc,UsersState>(
                  bloc: _usersBloc,
                  builder: (context, state) {
                    if (state is UsersLoading) {
                      return SpinKitFadingFour(
                        color: Color(0xff334A52),
                      );
                    } else if (state is UsersError) {
                      return  Container(
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          child: Center(
                              child: Text(
                                state.errorMessage,
                                style: TextStyle(color: Colors.red, fontSize: 15),
                              )));
                    } else if (state is UsersLoaded) {
                      return  (state.userListModel.list!.length == 0)?
                      Container(
                          child: Center(
                              child: Text("No Users.",
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 20,color: Colors.black,
                                    fontWeight: FontWeight.w400),
                              )
                          )
                      ):ListView.builder(
                        scrollDirection: Axis.vertical,
                        // shrinkWrap: true,
                        // physics: ScrollPhysics(),
                        itemCount: state.userListModel.list!.length,
                        itemBuilder: (BuildContext context, int index){
                          return
                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  list(state,index),
                                  Padding(padding: EdgeInsets.only(top: 13)),

                                ]);
                        },
                      );
                    }
                    return SpinKitFadingFour(
                      color: Color(0xff334A52),
                    );
                  },
                )
              ),
            )
          ],
        )
    ));
  }

  list(UsersLoaded state, int index) {
    return
      GestureDetector(
          onTap: () {
            // Navigator.pop(context);


          },

          child: Container(

            padding: EdgeInsets.only(top: 10,left: 10,bottom: 10),
            decoration: BoxDecoration(
              color: Colors.teal[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    image: DecorationImage(

                      image:(state.userListModel.list![index].profilePhotoLink.toString()!='')?

                      Image.network(state.userListModel.list![index].profilePhotoLink.toString()).image:
                        Image.asset('assets/images/person.jpg').image,
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 15)),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          state.userListModel.list![index].username.toString(),
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight:
                          FontWeight.w400,
                        ),),
                      Padding(padding: EdgeInsets.only(top: 14)),
                      Text(state.userListModel.list![index].role.toString(),
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight:
                          FontWeight.w100,
                        ),),
                    ],
                  ),
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: EdgeInsets.only(right: 10),


                    child:PullDownButton(
                      itemBuilder: (context) => [
                        PullDownMenuActionsRow.medium(
                          items: [
                            PullDownMenuItem(
                              onTap: () {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (BuildContext context) =>
                                        UserEdit(
                                          userId: state.userListModel.list![index].userId.toString(),
                                          username: state.userListModel.list![index].username.toString(),
                                          role: state.userListModel.list![index].role.toString(),
                                        )
                                    ));

                              },
                              title: 'Edit',
                              icon: CupertinoIcons.pencil,
                            ),
                            PullDownMenuItem(
                              onTap: () {
                                showDig(state,index);
                              },
                              title: 'Delete',
                              icon: CupertinoIcons.delete,
                            ),
                            PullDownMenuItem(
                              onTap: () {
                                String user_id = state.userListModel.list![index].userId.toString();
                                String user_photo = state.userListModel.list![index].profilePhotoLink.toString();

                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (BuildContext context) =>
                                        UserPhotoUploadPage(
                                          user_id: user_id,
                                          user_photo: user_photo,

                                        )
                                    ));
                              },
                              title: 'Upload',
                              icon: Icons.drive_folder_upload,
                            ),
                          ],
                        )
                      ],
                      position: PullDownMenuPosition.automatic,
                      buttonBuilder: (context, showMenu) => CupertinoButton(
                        onPressed: showMenu,
                        padding: EdgeInsets.zero,
                        child: const Icon(Icons.menu,color: Colors.black38,),
                      ),
                    ),
                  ),
                )

              ],
            ),
          )
      );
  }

  showDig(UsersLoaded state, int index) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Are you sure to delete this user.",
                      style: TextStyle(fontSize: 16, fontFamily: 'Poppins')),
                  Padding(padding: EdgeInsets.only(top: 30)),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {

                          _userEditBloc.add(FetchUserDelete(
                              user_id: state.userListModel.list![index].userId.toString()
                          ));

                          Navigator.pop(context);
                          _usersBloc.add(FetchUsers());
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          width: 80,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Color(0xff334A52),
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Center(
                            child: Text(
                              "OK",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Poppins',
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 20),
                          height: 40,
                          width: 80,
                          decoration: BoxDecoration(
                              color: Color(0xff334A52),
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Center(
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Poppins',
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                ],
              ));
        });



  }


}
