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
                  title: 'Order Processing',
                  body: 'Your order is currently being processed by the shopkeeper.',
                  click_action: 'FLUTTER_NOTIFICATION_CLICK'
                }
              };
            break;
        case 'out_for_delivery':
            payload = {
                notification: {
                  title: 'Order Receipt Available!',
                  body: 'Your order has successfully been picked up by the shopkeeper.',
                  click_action: 'FLUTTER_NOTIFICATION_CLICK'
                }
              };
          
              break;
        case 'declined':
            payload = {
                notification: {
                  title: 'Order Declined',
                  body: 'Your order has been declined by the shopkeeper.',
                  click_action: 'FLUTTER_NOTIFICATION_CLICK'
                }
              };
            break;
        case 'completed':
            payload = {
                notification: {
                  title: 'Delivery Successful!',
                  body: 'We have successfully delivered your product!',
                  click_action: 'FLUTTER_NOTIFICATION_CLICK'
                }
              };
            break;
        default:
            return null;
    }

    return fcm.sendToDevice(tokens, payload)
  });
