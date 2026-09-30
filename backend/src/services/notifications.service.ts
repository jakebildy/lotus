//        __
//       /oo\
//      |    |
//  ^^  (vvvv)  ^^
//  \\  /\__/\ //
//  \\/      \//
//  /        \
// |          |    ^
// /          \___/ |
// (            )   |
//  \----------/   /
//   //    \\_____/      ANCIENT CODE (prehistoric code tbh)
//   W       W

import admin, { ServiceAccount } from "firebase-admin";
import serviceAccount = require("../firebase/firebase.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount as ServiceAccount),
  databaseURL: "https://shellevate-41398-default-rtdb.firebaseio.com",
});

export function sendPushNotification(
  devices: Array<string | undefined>,
  title: string,
  body: string,
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  data: Record<string, any>,
  sound: boolean | null,
  type: string | null,
): void {
  if (devices.length === 0) return;

  // Typed as any because it carries legacy FCM fields (sound, registration_ids,
  // priority) on top of what MulticastMessage declares.
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const notification: any = {
    sound: sound != null ? sound : false,
    registration_ids: devices,
    data: {
      ...data,
      type: type ?? data["type"] ?? "",
      click_action: "FLUTTER_NOTIFICATION_CLICK",
    },
    priority: "high",
    tokens: devices,
    notification: { title, body },
  };

  admin
    .messaging()
    .sendEachForMulticast(notification)
    .then((response) => {
      // TODO fix notification failure because old tokens.
      if (response.failureCount > 0) {
        response.responses.forEach((resp) => {
          if (!resp.success) {
            console.log("failed to send push notification :(");
            console.log(resp.error);
          } else {
            console.log("succesfully sent push notification");
          }
        });
      }
    });
}
