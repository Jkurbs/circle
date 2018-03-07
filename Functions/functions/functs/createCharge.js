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
         // Create a charge using the pushId as the idempotency key, protecting against double charges 
        const amount = val.amount;
        const customer_id = customer.customer_id;
        const email_address = customer.email_address;
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
            var customer = charge.customer;
            var data = {
              id: charge.id,
              status: charge.status, 
              failure_message: charge.failure_message,
              created: new Date(),
            };
            return admin.firestore().collection('users').doc(`${event.params.userId}`).collection('charges').doc(`${event.params.id}`).set(data, {merge: true});
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


function reportError(err, context = {}) {
  // This is the name of the StackDriver log stream that will receive the log
  // entry. This name can be any valid log stream name, but must contain "err"
  // in order for the error to be picked up by StackDriver Error Reporting.
  const logName = 'errors';
  const log = logging.log(logName);

  // https://cloud.google.com/logging/docs/api/ref_v2beta1/rest/v2beta1/MonitoredResource
  const metadata = {
    resource: {
      type: 'cloud_function',
      labels: { function_name: process.env.FUNCTION_NAME }
    }
  };

  // https://cloud.google.com/error-reporting/reference/rest/v1beta1/ErrorEvent
  const errorEvent = {
    message: err.stack,
    serviceContext: {
      service: process.env.FUNCTION_NAME,
      resourceType: 'cloud_function'
    },
    context: context
  };

  // Write the error log entry
  return new Promise((resolve, reject) => {
    log.write(log.entry(metadata, errorEvent), error => {
      if (error) { reject(error); }
      resolve();
    });
  });
}
// [END reporterror]

// Sanitize the error message for the user
function userFacingMessage(error) {
  return error.type ? error.message : 'An error occurred, developers have been alerted';
}





//exports.createStripeCharge = functions.firestore.document('/stripe_customers/{userId}/charges/{id}').onWrite((event) => {
//  const val = event.data.val();
//  // This onWrite will trigger whenever anything is written to the path, so
//  // noop if the charge was deleted, errored out, or the Stripe API returned a result (id exists)
//  if (val === null || val.id || val.error) return null;
//  // Look up the Stripe customer id written in createStripeCustomer
//  return admin.database().ref(`/stripe_customers/${event.params.userId}/customer_id`).once('value').then((snapshot) => {
//    return snapshot.val();
//  }).then((customer) => {
//    // Create a charge using the pushId as the idempotency key, protecting against double charges
//    const amount = val.amount;
//    const idempotency_key = event.params.id;
//    let charge = {amount, currency, customer};
//    if (val.source !== null) charge.source = val.source;
//    return stripe.charges.create(charge, {idempotency_key});
//  }).then((response) => {
//    // If the result is successful, write it back to the database
//    return event.data.adminRef.set(response);
//  }).catch((error) => {
//    // We want to capture errors and render them in a user-friendly way, while
//    // still logging an exception with Stackdriver
//    return event.data.adminRef.child('error').set(userFacingMessage(error));
//  }).then(() => {
//    return reportError(error, {user: event.params.userId});
//  });
//});
// [END chargecustomer]]



