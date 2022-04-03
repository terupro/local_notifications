import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  // スケジュールを指定できるようにする
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation("Asia/Tokyo"));
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Local Notifications',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LocalNotificationScreen(),
    );
  }
}

// ラジオボタンに区別をつける
enum RadioValue { FIRST, SECOND, THIRD, FOURTH, FIFTH }
// ローカル通知のインスタンスを生成
final flnp = FlutterLocalNotificationsPlugin();
// 指定したい時間をProviderで管理する
final provider = StateProvider((ref) => 0);

class LocalNotificationScreen extends StatefulWidget {
  @override
  _LocalNotificationScreenState createState() =>
      _LocalNotificationScreenState();
}

class _LocalNotificationScreenState extends State<LocalNotificationScreen> {
  RadioValue _gValue = RadioValue.THIRD; //ラジオボタンの値を変数として用意
  @override
  void initState() {
    // ローカル通知を読み込めるようにする
    flnp.initialize(
      const InitializationSettings(
        iOS: IOSInitializationSettings(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Local Notifications"),
      ),
      body: SafeArea(
        child: Center(
          child: Consumer(
            builder: (context, ref, child) {
              final _provider = ref.watch(provider.notifier);
              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(30, 50, 30, 30),
                    child: Text(
                      "1つ選んで通知ボタンを押してください。",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  RadioListTile(
                    title: const Text('1'),
                    value: RadioValue.FIRST,
                    groupValue: _gValue,
                    onChanged: (value) {
                      _onRadioSelected(value);
                      _provider.state = 1;
                      _provider.state == value;
                    },
                  ),
                  RadioListTile(
                    title: const Text('2'),
                    value: RadioValue.SECOND,
                    groupValue: _gValue,
                    onChanged: (value) {
                      _onRadioSelected(value);
                      _provider.state = 2;
                      _provider.state == value;
                    },
                  ),
                  RadioListTile(
                    title: const Text('3'),
                    value: RadioValue.THIRD,
                    groupValue: _gValue,
                    onChanged: (value) {
                      _onRadioSelected(value);
                      _provider.state = 3;
                      _provider.state == value;
                    },
                  ),
                  RadioListTile(
                    title: const Text('4'),
                    value: RadioValue.FOURTH,
                    groupValue: _gValue,
                    onChanged: (value) {
                      _onRadioSelected(value);
                      _provider.state = 4;
                      _provider.state == value;
                    },
                  ),
                  RadioListTile(
                    title: const Text('5'),
                    value: RadioValue.FIFTH,
                    groupValue: _gValue,
                    onChanged: (value) {
                      _onRadioSelected(value);
                      _provider.state = 5;
                      _provider.state == value;
                    },
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      //押したら通知
                      notify(_provider.state);
                    },
                    child: const Text("通知"),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // ラジオボタンの初期値を更新する
  _onRadioSelected(value) {
    setState(() {
      _gValue = value;
    });
  }

  // 通知の内容とスケジュールの設定: 通知ボタンを押したn秒後に通知を送信する
  void notify(int n) {
    flnp.zonedSchedule(
      0,
      'Hallo',
      'Welcome to my app!!!!',
      tz.TZDateTime.now(tz.UTC).add(Duration(seconds: n)),
      const NotificationDetails(),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
