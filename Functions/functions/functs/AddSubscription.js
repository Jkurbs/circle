'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');
try {admin.initializeApp(functions.config().firebase);} catch(e) {}

const stripe = require('stripe')("sk_test_QfBDc4JT7E6iz8EwrsuJcR58");

// [START chargecustomer]
//Charge the Stripe customer whenever an amount is written to the Realtime database

exports = module.exports = functions.firestore.document('/circles/{id}/insiders/{userId}').onCreate(event => { 
   const val = event.data.data();
   const id = event.params.id; 
   const userId = event.params.userId;  
   const customer_id = val.customer_id;
    console.log('SIZEEE::', event.size);

   return admin.firestore().collection('circles').doc(`${id}`).get().then(snapshot => {
    return snapshot.data();
   }).then(circle => { 
       const activated = circle.activated; 
       const plan_id = circle.plan_id;      
        return stripe.subscriptions.create({
          customer: customer_id,
          items: [{plan: plan_id}],
        });
           
        var data = {
          days_left: 7,
        }; 
        
        return admin.firestore().collection('circles').doc(`${id}`).collection('insiders').doc(`${userId}`).set(data, {merge: true});
    });
});