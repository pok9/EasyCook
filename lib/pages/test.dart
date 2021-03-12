// import 'dart:html';

// import 'package:file_picker/file_picker.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

class test extends StatefulWidget {
  @override
  _testState createState() => _testState();
}



class _testState extends State<test> {
//   String _fileName;
//   String _path;
//   Map<String,String> _paths;
//   String _extension;
//   bool _loadingPath = false;
//   bool _multiPick = false;
//   bool _hasValidMime = false;
//   FileType _pickingType;
//   TextEditingController _controller = new TextEditingController();

//   void initState(){
//     super.initState();
//     _controller.addListener(() => _extension = _controller.text);
//   }

//   void _openFileExplorer() async {
//   if(_pickingType != FileType.custom || _hasValidMime){
//     setState(() => _loadingPath = true);
//     try{
//       if(_multiPick){
//         _path = null;
//         // _paths = await FilePicker.getMultiFilePath(//getMultiFilePath
//         //   type: _pickingType, fileExtension: _extension);
//       } else{
//         _paths = null;
//         // _path = await FilePicker.getFilePath(
//         //   type: _pickingType,fileExtension:_extension);
//       }
//     }on PlatformException catch (e){//PlatformException
//       print("Unsupported operation" + e.toString());
//     }
//     if(!mounted)return;
//     setState(() {
//       _loadingPath = false;
//       _fileName = _path != null
//         ? _path.split('/').last
//         : _path != null ? _paths.keys.toString() : '...'; 
//     });
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Easy Cook'),
      ),
      // body: Container(
      //   child: Center(
      //     child: Column(
      //       children: [
      //         new Padding(padding: const EdgeInsets.only(top:50.0,bottom: 20.0),
      //         child: new RaisedButton(onPressed: ()=> _openFileExplorer(),
      //         child: new Text("Open file picker"),
      //         ),
      //         ),
      //         new Builder(builder: (BuildContext context) => _loadingPath
      //               ? Padding(padding: const EdgeInsets.only(bottom: 10.0),
      //               child: const CircularProgressIndicator())
      //               : _path != null || _paths != null
      //                 ? new Container(
      //                   padding: const EdgeInsets.only(bottom: 30.0),
      //                   height: MediaQuery.of(context).size.height * 0.50,
      //                   child: new Scrollbar(child: new ListView.separated(itemCount: _paths != null && _paths.isNotEmpty
      //                     ? _paths.length
      //                     : 1,
      //                     itemBuilder: (BuildContext context,int index){
      //                       final bool isMultiPath = _paths != null && _paths.isNotEmpty;
      //                       final String name = 'File $index: '+
      //                             (isMultiPath
      //                                 ? _paths.keys.toList()[index]
      //                                 : _fileName ?? '...');
      //                       final path = isMultiPath
      //                           ? _paths.values.toList()[index].toString()
      //                           : _paths;
                            
      //                       return new ListTile(
      //                         title: new Text(
      //                           name,
      //                         ),
      //                         subtitle: new Text(path),
      //                       );
      //                       },
      //                       separatorBuilder: (BuildContext context,int index) => 
      //                                           new Divider(),
      //                       )),
      //                 )
      //                 : new Container(),
      //                 ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
