import 'package:flutter/material.dart';
import 'dart:js_interop_unsafe';
import 'package:web/web.dart' as web;
import 'dart:js_interop';
import 'dart:async';

@JS() // The JavaScript-Bridge
@staticInterop
abstract final class JSBridge {

  @JS('port')
  external static JSString? get port;
}

final class NetworkService {

  static String? get port => JSBridge.port?.toDart;
}