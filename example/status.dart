import 'dart:async';
import "dart:convert";
import "dart:html";

Future<Null> main() async {
  var request = await HttpRequest.request(
      "https://status.github.com/api/status.json",
      requestHeaders: {"Origin": window.location.origin});

  var text = request.responseText;
  var map = json.decode(text);

  querySelector("#status")
    ..appendText(map["status"])
    ..classes.add("status-${map["status"]}");
}
