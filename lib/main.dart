import 'package:ddl_er/API/getApiData.dart';
import 'package:ddl_er/page/Home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQL To ER',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: GoogleFonts.libreBaskerville().fontFamily,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'SQL To ER'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GetAPIData getAPIData = GetAPIData();
  int appStarted = 0;
  late Future<int> apiFuture;
  bool stopPolling = false;

  late Stream<List<ConnectivityResult>> connectivityStream;
  List<ConnectivityResult> _connectivityResult = [ConnectivityResult.none];
  @override
  void initState() {
    super.initState();

    connectivityStream = Connectivity().onConnectivityChanged;
    _initializeConnectivity();
    apiFuture = getAPIData.isAPIAvailable(url: apiTestLink, isNew: stopPolling);
    setState(() {});
  }

  Future<void> _initializeConnectivity() async {
    List<ConnectivityResult> result;
    try {
      result = (await Connectivity().checkConnectivity());
    } catch (e) {
      result = [ConnectivityResult.none];
    }
    if (result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.other) ||
        result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet)) {
      _connectivityResult = [ConnectivityResult.mobile];
    } else {
      _connectivityResult = [ConnectivityResult.none];
    }
    setState(() {});
  }

  // Future<void> _checkConnectivity() async {
  //   List<ConnectivityResult> result;
  //   try {
  //     result = await _connectivity.checkConnectivity();
  //   } catch (e) {
  //     result = [ConnectivityResult.none];
  //   }
  //   setState(() {
  //     if (result.contains(ConnectivityResult.mobile) ||
  //         result.contains(ConnectivityResult.other) ||
  //         result.contains(ConnectivityResult.wifi) ||
  //         result.contains(ConnectivityResult.ethernet)) {
  //       _connectivityResult = true;
  //     } else {
  //       _connectivityResult = false;
  //     }
  //   });
  // }

  @override
  void dispose() {
    stopPolling = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder<List<ConnectivityResult>>(
          stream: connectivityStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _connectivityResult = snapshot.data!;
            }

            if (_connectivityResult.contains(ConnectivityResult.mobile) ||
                _connectivityResult.contains(ConnectivityResult.other) ||
                _connectivityResult.contains(ConnectivityResult.wifi) ||
                _connectivityResult.contains(ConnectivityResult.ethernet)) {
              return Center(
                  child: FutureBuilder(
                future: apiFuture,
                builder: (ctx, snap) {
                  if (snap.hasError) {
                    return const Text('Error');
                  }
                  if (snap.data == 1) {
                    return const Home();
                  }

                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/1474.gif",
                          height: 125.0,
                          width: 125.0,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Server is starting...',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ));
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/1479.gif",
                      height: 125.0,
                      width: 125.0,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Waiting for internet..',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ));
  }
}
