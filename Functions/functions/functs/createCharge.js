'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');
try {admin.initializeApp(functions.config().firebase);} catch(e) {}

const stripe = require('stripe')("sk_test_QfBDc4JT7E6iz8EwrsuJcR58");

// [START chargecustomer]
//Charge the Stripe customer whenever an amount is written to the Realtime database

exports = module.exports = functions.firestore.document('/users/{userId}/charges/{id}').onCreate(event => {
   const val = event.data.data();
   const ref =  event.data.ref;

   if (val === null) return null;
   const amount = val.amount;
   const destination = val.destination;
  // This onWrite will trigger whenever anything is written to the path, so
  // noop if the charge was deleted, errored out, or the Stripe API returned a result (id exists) 
  // Look up the Stripe customer id written in createStripeAccount
    
  return admin.firestore().collection('users').doc(`${event.params.userId}`).get().then(snapshot => {
    return snapshot.data();
  }).then(customer => {
      
        const userId = event.params.userId;
        const recipient_id = val.to;
        const amount = val.amount;
      
        const customer_id = customer.customer_id;
        const email_address = customer.email_address;
      
        const first_name = customer.first_name; 
        const last_name = customer.last_name;
      
        stripe.charges.create({
            
            amount: amount * 100,
            currency: 'usd',
            description: "Example charge",
            receipt_email: email_address,
            customer: customer_id,
            application_fee: 20,
            destination: {
               account: destination,
           },
        }, function(err, charge) {
            if (err !== null) {
               console.log('ERROR PAYMENT', err.message);
             var data = {
               success: false,
               error: err.message,
             };
               return admin.firestore().collection('users').doc(`${userId}`).collection('charges').doc(`${event.params.id}`).set(data, {merge: true});
            } else {
            var customer = charge.customer;
            var data = {
              chargeId: charge.id,
              status: charge.status, 
              created: new Date(),
              success: true,
            };   
                
            var receivedData = {
              from: userId,
              first_name: first_name, 
              last_name: last_name, 
              chargeId: charge.id,
              status: charge.status, 
              send: new Date(),
              amount: amount,
              customer: customer_id,
            };   
                
            admin.firestore().collection('users').doc(`${userId}`).collection('charges').doc(`${event.params.id}`).set(data, {merge: true});
            return admin.firestore().collection('users').doc(recipient_id).collection('event').doc(`${event.params.id}`).set(receivedData, {merge: true});
            }
        });
  }).then(response => {
      // If the result is successful, write it back to the database
      // WRITE RESPONSE BACK
      var data = {
          response: 'response', 
      };
      return admin.firestore().collection('users').doc(`${event.params.userId}`).collection('charges').doc(`${event.params.id}`).set(data, {merge: true});
      
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



// Sanitize the error message for the user
function userFacingMessage(error) {
  return error.type ? error.message : 'An error occurred, developers have been alerted';
}





