import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/auth/firebaselogic.dart';
import 'package:whatsapp_clone/provider/userprovider.dart';
import 'package:whatsapp_clone/screens/confirmscreen.dart';
import 'package:whatsapp_clone/utils/imagepicker.dart';

class AddPostScreen extends StatefulWidget {
  final snap;
  const AddPostScreen({Key? key, this.snap}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();

     pickvideo(ImageSource source, BuildContext context){
                var video = PickImage().pickVideo(source, context);
                if(video != null){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ConfirmScreen(videoFile: File(video.path), videoPath: video.path)));
                }
                }

  _selectvideo(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              children: [
                SimpleDialogOption(
                  child: ElevatedButton(
                    child: Text("choose video from gallery"),
                    onPressed: () => PickImage().pickVideo(ImageSource.gallery, context),
                  ),
                ),
                SimpleDialogOption(
                  child: ElevatedButton(
                    onPressed: () => PickImage().pickVideo(ImageSource.camera, context),
                    child: Text("take video with Camera"),
                  ),
                )
              ],
            ));
  }

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await PickImage().pickedImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await PickImage().pickedImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void postImage(String uid) async {
    String res = await AuthMethods().post(_descriptionController.text, DateTime.now(), _file!, uid);
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return _file == null 
        ? Center(
            child: Column(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.upload,
                  ),
                  onPressed: () => _selectImage(context),
                ),
                IconButton(onPressed: ()=> pickvideo(ImageSource.gallery, context), icon: Icon(Icons.video_collection_sharp))
              ],
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              title: const Text(
                'Post to',
              ),
              centerTitle: false,
              actions: <Widget>[
                TextButton(
                  onPressed: () => postImage(FirebaseAuth.instance.currentUser!.uid),

                  // onPressed: () => postImage(
                  //   userProvider.getUser.uid,
                  //   userProvider.getUser.username,
                  //   userProvider.getUser.photoUrl,
                  // ),
                  child: const Text(
                    "Post",
                    style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                )
              ],
            ),
            // POST FORM
            body: Column(
              children: <Widget>[
                isLoading ? const LinearProgressIndicator() : const Padding(padding: EdgeInsets.only(top: 0.0)),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(userProvider.getUser.profPic),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(hintText: "Write a caption...", border: InputBorder.none),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45.0,
                      width: 45.0,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            fit: BoxFit.fill,
                            alignment: FractionalOffset.topCenter,
                            image: MemoryImage(_file!),
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
          );
  }
}
