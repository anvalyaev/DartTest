import "dart:async";

import "package:threading/threading.dart";

Future main() async {
//  await runFutures();
  await runThreads();
}

Future runFutures() async {
  print("Futures (linear execution)");
  print("----------------");
  var futures = <Future>[];
  var numOfFutures = 3;
  var count = 3;
  for (var i = 0; i < numOfFutures; i++) {
    var name = new String.fromCharCode(65 + i);
    var thread = new Future(() async {
      for (var j = 0; j < count; j++) {
        await new Future.value();
        print("$name: $j");
      }
    });

    futures.add(thread);
  }

  await Future.wait(futures);
}

Future runThreads() async {
  print("Threads (interleaved execution)");
  print("----------------");
  var threads = <Thread>[];
  var numOfThreads = 3;
  var count = 3;
  for (var i = 0; i < numOfThreads; i++) {
    final StreamController ctrl = StreamController<String>.broadcast();
    var name = new String.fromCharCode(65 + i);
    var thread = new Thread(() async {
//      for (var j = 0; j < count; j++) {
//        await new Future.value();
//        print("$name: $j");
//      }

      int j = 0;
      while (true) {
        await new Future.value();
//        print("$name: $j");
        j++;
        ctrl.sink.add("SINK: $name: $j");
      }
    });

    threads.add(thread);
    await thread.start();
    final StreamSubscription subscription = ctrl.stream.listen((value) => print('$value'));
  }

  for (var i = 0; i < 3; i++) {
    await threads[i].join();
  }
}
//import 'package:DartTest2/DartTest2.dart' as DartTest2;
//
//import 'dart:async';
//import 'dart:io';
//import "package:threading/threading.dart";
//
//main() {
//  // All Dart programs implicitly run in a root zone.
//  // runZoned creates a new zone.  The new zone is a child of the root zone.
//  print("Run zone 1");
//  runZoned(() async {
//    await runZone1();
//  }
//  );
//  print("Run zone 2");
//  runZoned(() async {
//    await runZone2();
//  }
//  );
//  print("End main");
//}
//
////Future runZone1()async{
////  while(true){
////    print("zone-1");
////    sleep(const Duration(seconds:1));
////  };
////}
////
////Future runZone2(){
////  while(true){
////    print("zone-2");
////    sleep(const Duration(seconds:1));
////  };
////}
//
//Future runZone1()async{
//  print("zone-1");
//
//  return new Future<void>.delayed(Duration(seconds: 1),runZone1);
//}
//
//Future runZone2()async{
//  print("zone-2");
//  return new Future<void>.delayed(Duration(seconds: 1),runZone2);
//}
//
//Future runZone3()async{
//  print("zone-3");
//  return new Future<void>.delayed(Duration(seconds: 1),runZone3);
//}
////
////Future runZone(){
////  print("zone-2");
////  return new Future(runZone2);
////}