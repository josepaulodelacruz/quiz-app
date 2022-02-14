import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:laravel_echo/laravel_echo.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/common/widgets/transparent_app_bar_widget.dart';
import 'package:rte_app/main.dart';
import 'package:rte_app/blocs/cookie/cookie_bloc.dart';
import 'package:sensitive_http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  PusherClient pusher = PusherClient(
      "local_rte_key",
      PusherOptions(
        host: '10.0.2.2',
        wsPort: 6001,
        encrypted: false,
        auth: PusherAuth(
          '$dev_endpoint/broadcasting/auth',
          headers: {
              'Authorization': 'Bearer 6|ymTHC8bJz7NN2wSuBTwutayvWXWkDsOgn8QPfnnL',
              'csrfToken': 'wB7Ecy827BB77RNXP9vJmU2Dsqto05gwut6iCcau',
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

  Future<void> socket() async {
    try {

      await pusher.connect();
      channel = pusher.subscribe('home');
      print('socket');
      print(pusher.getSocketId());

      channel.bind('App\\Events\\Test', (event) {
        print('listening');
        print(event!.data);
      });

      privateChannel = pusher.subscribe('private-App.User.1');

      privateChannel.bind('App\\Events\\Word', (event) {
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


  // Future<void> socket () async {
  //   try {
  //     PusherOptions pusherOptions = PusherOptions(
  //       host: 'http://10.0.2.2',
  //       wsPort: 6001,
  //       encrypted: false,
  //       cluster: 'mt1',
  //       // auth: PusherAuth(
  //       //     '$dev_endpoint',
  //       //     headers: {
  //       //       'Accept': 'application/json',
  //       //       'Cookie': getIt<CookieBloc>().state.cookie!.session.toString()
  //       //     }
  //       // ),
  //     );
  //
  //     pusher = PusherClient('local_rte_key', pusherOptions, autoConnect: false, enableLogging: true);
  //
  //     Channel channel = pusher.subscribe('home');
  //     await pusher.connect();
  //
  //
  //     // channel.bind('Test', (PusherEvent event) {
  //     //   print(event);
  //     // });
  //
  //     await channel.bind("Test", (PusherEvent? event) {
  //       print(event);
  //       print('listengin');
  //       print(event!.data);
  //     });
  //
  //     pusher.onConnectionStateChange((state) {
  //       print(state!.currentState);
  //     });
  //
  //     pusher.onConnectionError((error) {
  //       print('throw');
  //       print(error!.message);
  //     });
  //
  //
  //
  //   } catch (error) {
  //     print('promise error');
  //     print(error);
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // privateChannel.bind("pusher:subscription_succeeded", (PusherEvent? event) {
            //   privateChannel.trigger('Word', {"message": "from mobile"})
            // });
            // privateChannel.bind('App\\Events\\Word', (event) {
              privateChannel.trigger('client-App\\Events\\Word', {"message": "from mobile"});
            // });
          },
          child: Icon(Icons.add),
        ),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: TextField(
              onChanged: (text) async  {
                // channel.trigger('client-App\\Events\\Test', {"message": "${text}"});
                // await http.get(Uri.parse('${dev_endpoint}/api/user/socket-test/${text}'));
                //
                // privateChannel.bind("pusher:subscription_succeeded", (PusherEvent? event) {
                //   privateChannel.trigger('Word', {"message": "from mobile"} );
                // });
                //
                //   print('completed');
                // });

                //

                // channel.bind('App\\Events\\Tests', (event) {
                //   channel.trigger('client-App\\Events\\Tests', {"message": "Hello mobile"});
                // });

              },
            ),
          ),
          body: ListView(
            children: [],
          )),
    );
  }
}
