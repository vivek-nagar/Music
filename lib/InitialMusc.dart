import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:music/TrackDetails.dart';

class MusicList extends StatefulWidget {
  @override
  _MusicListState createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool isLoading = false;
  var api1 = Uri.parse(
      "https://api.musixmatch.com/ws/1.1/chart.tracks.get?apikey=2d782bc7a52a41ba2fc1ef05b9cf40d7");
  var res, track;

  @override
  void initState() {
    super.initState();

    fetchData();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _connectionStatus = "None";
      });
      // return showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return AlertDialog(
      //       title: new Text("Alert!!"),
      //       content: new Text("No Internet Connection"),
      //       actions: <Widget>[
      //         // ignore: deprecated_member_use
      //         new FlatButton(
      //           child: new Text("OK"),
      //           onPressed: () {
      //             Navigator.of(context).pop();
      //           },
      //         ),
      //       ],
      //     );
      //   },
      // );
    }
  
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }

  fetchData() async {
    res = await http.get(api1);
    track = jsonDecode(res.body)["message"]["body"]["track_list"];
    //print(track.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_connectionStatus == "ConnectivityResult.none") {
      return Container(
          child: Center(
              child: Text(
        "No Internet",
        style: TextStyle(fontSize: 15, color: Colors.white),
      )));
    } else
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text("Trending"),
          centerTitle: true,
          backgroundColor: Color(0XFFBD081C),
        ),
        body: res != null || isLoading
            ? ListView.builder(
                itemCount: track.length,
                itemBuilder: (BuildContext ctx, index) {
                  var trackDetails = track[index]["track"];
                  var trackId = trackDetails[
                      "track_id"]; //track=["message"]["body"]["track_list"]
                  return GestureDetector(
                      onTap: () {
                        setState(() {
                          isLoading = true;
                        });
                        //
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailsPage(
                                    trackDetails: trackDetails, id: trackId)));
                      },
                      child: ListTile(
                        leading: Icon(
                          Icons.library_music_outlined,
                          color: Color(0XFFBD081C),
                          size: 28,
                        ),
                        title: Text("${trackDetails["track_name"]}",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("${trackDetails["track_name"]}"),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              width: 70,
                              child: Text(
                                "${trackDetails["artist_name"]}",
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                      ));
                })
            : Center(child: CircularProgressIndicator()),
      );
  }
}
