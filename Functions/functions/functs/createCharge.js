'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');
try {admin.initializeApp(functions.config().firebase);} catch(e) {}

const stripe = require('stripe')("sk_test_QfBDc4JT7E6iz8EwrsuJcR58");

// [START chargecustomer]
//Charge the Stripe customer whenever an amount is written to the Realtime database

exports = module.exports = functions.firestore.document('/users/{userId}/charges/{id}').onWrite(event => {
   const val = event.data.data();
   console.log("VALUR ", val);

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
    const idempotency_key = "boiDbxmRdjhfIznKhVkNd2mjJrX22";
    const customer_id = customer.customer_id;
    console.log("SOURCES TOKEN", customer.token);
    console.log("IDEMPOTENCY KEY", idempotency_key);
    console.log("CUSTOMER ID", customer_id);
    console.log("AMOUNT", amount);

//    let charge = {amount, currency, customer};
//    if (val.source !== null) charge.source = val.source;
//    return stripe.charges.create(charge, {idempotency_key});
      
    stripe.charges.create({
        amount: amount,
        currency: "usd",
        customer: customer_id,
        destination: {
           account: destination,
       },
    });
  }).then(response => {
       console.log("RESPONSE", response);

      // If the result is successful, write it back to the database
      //return event.data.adminRef.set(response);
    }, error => {
        console.log("ERROR", error);

      // We want to capture errors and render them in a user-friendly way, while
      // still logging an exception with Stackdriver
//      return event.data.adminRef.child('error').set(userFacingMessage(error)).then(() => {
//        return reportError(error, {user: event.params.userId});
//      });
    });
});
// [END chargecustomer]





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



