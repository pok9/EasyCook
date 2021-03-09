import 'package:flutter/material.dart';

class test extends StatefulWidget {
  const test({
    this.initialCount = 3,
  });

  // ยังอนุญาตให้มีจำนวนผู้เล่นเริ่มต้นแบบไดนามิก
  final int initialCount;

  @override
  _testState createState() => _testState();
}

// List<Widget> list = new List();

class _testState extends State<test> {

 int fieldCount = 0;
  int nextIndex = 0;
  // คุณต้องติดตาม TextEditingControllers หากคุณต้องการให้ค่ายังคงอยู่อย่างถูกต้อง
  List<TextEditingController> controllers = <TextEditingController>[];

  // สร้างรายการ TextFields จากรายการ TextControllers
  // List<Widget> _buildList() {
  //   int i;
  //   // กรอกคีย์หากรายการไม่ยาวพอ (ในกรณีที่เราเพิ่มเข้าไป)
  //   if (controllers.length < fieldCount) {
  //     for (i = controllers.length; i < fieldCount; i++) {
  //       controllers.add(TextEditingController());
  //     }
  //   }

  //   i = 0;
  //   // วนรอบตัวควบคุมและสร้างใหม่แต่ละตัวต่อคอนโทรลเลอร์ที่มีอยู่
  //   return controllers.map<Widget>((TextEditingController controller) {
  //     int displayNumber = i + 1;
  //     i++;
  //     return TextField(
  //       // style: TextStyle(color: Colors.red, fontWeight: FontWeight.w100),
  //       controller: controller,
  //       maxLength: 20,
  //       decoration: InputDecoration(
  //         hintText: "ค้นหาสูตรอาหาร $displayNumber",
  //         // labelText: "ส่วนผสม $displayNumber",
  //         counterText: "",
  //         prefixIcon: const Icon(Icons.fastfood),
  //         suffixIcon: IconButton(
  //           icon: Icon(Icons.clear),
  //           onPressed: () {
  //             // เมื่อลบ TextField คุณต้องทำสองสิ่ง:
  //             // 1. ลดจำนวนคอนโทรลเลอร์ที่คุณควรมี (fieldCount)
  //             // 2. ลบคอนโทรลเลอร์ของฟิลด์นี้ออกจากรายการคอนโทรลเลอร์
  //             setState(() {
  //               fieldCount--;
  //               controllers.remove(controller);
  //             });
  //           },
  //         ),
  //       ),
  //     );
  //   }).toList(); // แปลงเป็นlist
  // }
  List<Widget> _buildList() {
    int i;
    // กรอกคีย์หากรายการไม่ยาวพอ (ในกรณีที่เราเพิ่มเข้าไป)
    if (controllers.length < fieldCount) {
      for (i = controllers.length; i < fieldCount; i++) {
        controllers.add(TextEditingController());
      }
    }

    i = 0;
    // วนรอบตัวควบคุมและสร้างใหม่แต่ละตัวต่อคอนโทรลเลอร์ที่มีอยู่
    return controllers.map<Widget>((TextEditingController controller) {
      int displayNumber = i + 1;
      i++;
      return TextField(
        // style: TextStyle(color: Colors.red, fontWeight: FontWeight.w100),
        controller: controller,
        maxLength: 20,
        decoration: InputDecoration(
          hintText: "ค้นหาสูตรอาหาร $displayNumber",
          // labelText: "ส่วนผสม $displayNumber",
          counterText: "",
          prefixIcon: const Icon(Icons.fastfood),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              // เมื่อลบ TextField คุณต้องทำสองสิ่ง:
              // 1. ลดจำนวนคอนโทรลเลอร์ที่คุณควรมี (fieldCount)
              // 2. ลบคอนโทรลเลอร์ของฟิลด์นี้ออกจากรายการคอนโทรลเลอร์
              setState(() {
                fieldCount--;
                controllers.remove(controller);
              });
            },
          ),
        ),
      );
    }).toList(); // แปลงเป็นlist
  }
  


  @override
  Widget build(BuildContext context) {
    // สร้างรายการ TextFields
    final List<Widget> children = _buildList();

    // กดปุ่มเพื่อเพิ่ม list
    children.add(
      GestureDetector(
        onTap: () {
          // เมื่อเพิ่มlist(ส่วนผสม)เราจำเป็นต้องใส่ fieldCount เท่านั้น, because the _buildList()
          // จะจัดการสร้าง TextEditingController ใหม่
          setState(() {
            fieldCount++;
          });
        },
        child: Container(
          color: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'เพิ่ม ส่วนผสม',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );

    // สร้าง ListView
    return ListView(
      padding: EdgeInsets.all(0),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: children,
    );
  }

  @override
  void initState() {
    super.initState();

    // เมื่อสร้างขึ้นให้คัดลอกจำนวนเริ่มต้นไปยังจำนวนปัจจุบัน
    fieldCount = widget.initialCount;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(test oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}