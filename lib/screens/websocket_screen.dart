import 'package:flutter/material.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:rte_app/common/constants.dart';
import 'package:sensitive_http/http.dart' as http;

class WebSocketScreen extends StatefulWidget {
  const WebSocketScreen({Key? key}) : super(key: key);

  @override
  _WebSocketScreenState createState() => _WebSocketScreenState();
}

class _WebSocketScreenState extends State<WebSocketScreen> {
  String apiKey = "";
  PusherClient pusher = PusherClient(
      "local_rte_key",
      PusherOptions(
        host: '10.0.2.2',
        wsPort: 6001,
        encrypted: false,
        auth: PusherAuth(
            '${dev_endpoint}/broadcasting/auth',
            headers: {
              'Authorization': 'Bearer 4|vml6kO2Iv7oPAeR5MyUu1vHfTqEGnyvlBhdXZ1qV',
            }
        ),

        // auth: PusherAuth(
        //   '/api/broadcasting/auth',
        //   headers: {
        //     'Application': 'application/json',
        //     'Cookie': "laravel_session=7vjDQ28uAvwIMAnhVjU5cprmsQJ7trXvafk9M03y",
        //   }
        // )
      ), enableLogging: true, autoConnect: false);
  late Channel channel;
  late Channel privateChannel;

  @override
  void initState() {
    socket();
    super.initState();
  }

  Future<void> login () async {
    try {
      var response = await http.post(Uri.parse("${dev_endpoint}/api/sanctum/token"), body: {
        'email': "johndoe@example.org",
        'password': 'password'
      });
      print(response.body);
      setState(() {
        apiKey = response.body;
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> socket() async {
    try {
      await pusher.connect();
      channel = pusher.subscribe('home');
      print('socket');
      print(pusher.getSocketId());

      // channel.bind('App\\Events\\Test', (event) {
      //   print('listening');
      //   print(event!.data);
      // });

      privateChannel = pusher.subscribe('private-App.Models.User.1');
      privateChannel.bind('new-message-event', (event) {
        print('listening from private channel');
        print(event!.data);
      });


      pusher.onConnectionError((error) {
        print('error');
        print(error!.message);
      });

    } catch (error) {
      print(error);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          privateChannel.trigger('new-message-event', "testing");
        },
        child: Text('socket on'),
      ),
      appBar: AppBar(
        title: Text('Websocket testing'),
      ),
      body: Center(
        child: TextField(
          onChanged: (val) {
            print(val);

          },
        ),
      ),
    );
  }
}
