import 'package:shared_value/shared_value.dart';

final SharedValue<String> dID = SharedValue(
  value: "",
  key: "dId",
  autosave: true,
);

final SharedValue<String> appVersion = SharedValue(
  value: "",
  key: "app_version",
);

final SharedValue<String> pushID = SharedValue(
  value: "",
  key: "push_id",
);

final SharedValue<String> phone = SharedValue(
  value: "+255 783 446 669",
  key: "phone_no",
  autosave: true,
);

final SharedValue<bool> ticketSold = SharedValue(
  value: false,
  key: "ticket_sold",
);

final SharedValue<String> lnCode = SharedValue(
  value: "1",
  key: "ln_code",
  autosave: true,
);

getSharedValueHelperData() async {
  // PackageInfo packageInfo = await PackageInfo.fromPlatform();
  // appVersion.$ = packageInfo.buildNumber;
  // await lnCode.load();
  // await phone.load();
}
