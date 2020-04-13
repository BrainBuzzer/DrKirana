import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

export const userOrderUpdate = functions.firestore
  .document('orders/{orderId}')
  .onUpdate(async (change, _context) => {

    const order = change.after.data()!;

    const querySnapshot = await db
      .collection('users')
      .doc(order.uid)
      .collection('tokens')
      .get();

    const tokens = querySnapshot.docs.map(snap => snap.id);

    let payload: admin.messaging.MessagingPayload;

    switch(order.status) {
        case 'processing':
             payload = {
                notification: {
                  title: 'ऑर्डर तयार करण्यात येत आहे',
                  body: 'दुकानदार सध्या तुमची ऑर्डर तयार करत आहेत.',
                  click_action: 'FLUTTER_NOTIFICATION_CLICK'
                }
              };
            break;
        case 'out_for_delivery':
            payload = {
                notification: {
                  title: 'ऑर्डरची पावती भेटली',
                  body: 'आपली ऑर्डर दुकानदाराने तयार केली आहे व लवकरच घरपोच दिली जाईल.',
                  click_action: 'FLUTTER_NOTIFICATION_CLICK'
                }
              };
          
              break;
        case 'declined':
            payload = {
                notification: {
                  title: 'ऑर्डर नाकारली',
                  body: 'माफ करा. आपण निवडलेल्या दुकानदारांनी आपली ऑर्डर नाकारली आहे. कृपया दुसर्‍या दुकानातून प्रयत्न करा.',
                  click_action: 'FLUTTER_NOTIFICATION_CLICK'
                }
              };
            break;
        case 'completed':
            payload = {
                notification: {
                  title: 'ऑर्डर डिलीवेरी केली',
                  body: 'डॉक्टर किराणा वर आपण टाकलेली ऑर्डर घरपोच देण्यात आली आहे. आम्हाला निवडल्या बद्दल धन्यवाद.',
                  click_action: 'FLUTTER_NOTIFICATION_CLICK'
                }
              };
            break;
        default:
            return null;
    }

    return fcm.sendToDevice(tokens, payload)
  });
