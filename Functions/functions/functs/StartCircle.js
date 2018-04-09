'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');
try {admin.initializeApp(functions.config().firebase);} catch(e) {}

const stripe = require('stripe')("sk_test_QfBDc4JT7E6iz8EwrsuJcR58");

// [START chargecustomer]
//Charge the Stripe customer whenever an amount is written to the Realtime database

exports = module.exports = functions.firestore.document('/circles/{id}/activated').onUpdate(event => {

   const val = event.data.data();
   const amount = val.amount;
   const interval = val.interval;
   const interval_count = val.interval_count;
    
   return admin.firestore().collection('users').doc(`${event.params.id}`).get().then(snapshot => {
    return snapshot.data();
   }).then(customer => {    
     return stripe.plans.create({
        amount: amount,
        interval: interval,
        interval_count: interval_count,
        product: {
           name: `${event.params.id}`
        },
          currency: "usd",
        }, function(err, plan) {
          console.log('PLAN::', plan)
          // asynchronously called
      });
   })
});


