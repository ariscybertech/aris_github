import "dart:html";

import "package:github/browser.dart";
import "common.dart";

DivElement info;

Future<void> main() async {
  await initViewSourceButton("user_info.dart");
  info = document.getElementById("info");
  loadUser();
}

GitHub createClient(String token) {
  return GitHub(auth: Authentication.withToken(token));
}

void loadUser() {
  var localToken = document.getElementById("token") as InputElement;

  var loadBtn = document.getElementById("load");
  loadBtn.onClick.listen((event) {
    if (localToken.value == null || localToken.value.isEmpty) {
      window.alert("Please Enter a Token");
      return;
    }

    github = createClient(localToken.value);

    github.users.getCurrentUser().then((CurrentUser user) {
      info.children.clear();
      info.hidden = false;
      info.appendHtml("""
      <b>Name</b>: ${user.name}
      """);

      void append(String name, dynamic value) {
        if (value != null) {
          info.appendHtml("""
            <br/>
            <b>$name</b>: ${value.toString()}
          """);
        }
      }

      append("Biography", user.bio);
      append("Company", user.company);
      append("Email", user.email);
      append("Followers", user.followersCount);
      append("Following", user.followingCount);
      append("Disk Usage", user.diskUsage);
      append("Plan Name", user.plan.name);
      append("Created", user.createdAt);
      document.getElementById("load").hidden = true;
      document.getElementById("token").hidden = true;
    }).catchError((e) {
      if (e is AccessForbidden) {
        window.alert("Invalid Token");
      }
    });
  });

  if (token != null) {
    localToken.value = token;
    loadBtn.click();
  }
}
