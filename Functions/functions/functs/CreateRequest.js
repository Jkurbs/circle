'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');
try {admin.initializeApp(functions.config().firebase);} catch(e) {}

const stripe = require('stripe')("sk_test_QfBDc4JT7E6iz8EwrsuJcR58");

// [START chargecustomer]
//Charge the Stripe customer whenever an amount is written to the Realtime database

exports = module.exports = functions.firestore.document('/users/{userId}/requests/{id}').onCreate(event => {
   const val = event.data.data();
   const ref =  event.data.ref;

   if (val === null) return null;
   const amount = val.amount;
    
  return admin.firestore().collection('users').doc(`${event.params.userId}`).get().then(snapshot => {
    return snapshot.data();
  }).then(customer => {
      
        const userId = event.params.userId;
        const to_first_name = val.to;
        const to_last_name = val.amount;
        const recipient_id = val.to;
        const amount = val.amount;
      
        const email_address = customer.email_address;
        const from_first_name = customer.first_name;
        const from_last_name = customer.last_name;
      
        var fromData = {
              from: userId,
              first_name: from_first_name, 
              last_name: from_last_name, 
              date: new Date(),
              amount: amount,
              type: 'request',
        };
      
      
        admin.firestore().collection('users').doc(recipient_id).collection('events').doc(`${event.params.id}`).set(fromData, {merge: true});
        return stripe.balance.retrieve({
             stripe_account: account_id
        }, function(err, charge) {
            const available = charge.available[0].amount;
            const pending = charge.pending[0].amount;
            var data = {
                 available_amount: available,
                 pending_amount: pending,
            };  
            return admin.firestore().collection('users').doc(`${event.params.userId}`).collection('insight').doc('balance').set(data, {merge: true});
        });
  }).then(response => {
      // If the result is successful, write it back to the database
      // WRITE RESPONSE BACK
      var data = {
          response: 'response', 
      };
      
    }).catch((error) => {
      
      var data = {
          customer_id: customer, 
      };
      return admin.firestore().collection('users').doc(`${event.params.userId}`).set(data, {merge: true});
          //return event.data.ref.doc('errors').set(userFacingMessage(error));
      }).then(() => {
       return;
        //return reportError(error, {user: event.params.userId});
    });
});
// [END chargecustomer]


