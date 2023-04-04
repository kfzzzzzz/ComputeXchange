import 'package:compute_xchange/HomeDrawer.dart';
import 'package:compute_xchange/record/record.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';

class ScaffoldRoute extends StatefulWidget {
  @override
  _ScaffoldRouteState createState() => _ScaffoldRouteState();
}

class _ScaffoldRouteState extends State<ScaffoldRoute> {
  int _selectedIndex = 1;
  final record = Record();
  final path = 'wav/myrecord';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //导航栏
        title: Text("ComputeXchange"),
        actions: <Widget>[
          //导航栏右侧菜单
          IconButton(icon: Icon(Icons.share), onPressed: () {}),
        ],
      ),
      drawer: const HomeDrawer(), //抽屉
      bottomNavigationBar: BottomNavigationBar(
        // 底部导航
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: '市场'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: '客服'),
          BottomNavigationBarItem(icon: Icon(Icons.abc), label: '我的'),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.blue,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      startRecord(record);
    }
    if (index == 2) {
      stopRecord(record);
    }
    setState(() {
      _selectedIndex = index;
    });
  }
}
