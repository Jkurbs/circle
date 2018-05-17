'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');
try {admin.initializeApp(functions.config().firebase);} catch(e) {}

const stripe = require('stripe')("sk_test_QfBDc4JT7E6iz8EwrsuJcR58");

// [START chargecustomer]
//Charge the Stripe customer whenever an amount is written to the Realtime database

exports = module.exports = functions.firestore.document('/circles/{id}').onCreate(event => { 
   const val = event.data.data();
   const id = event.params.id; 
   const weekly_amount = val.weekly_amount;
   return admin.firestore().collection('circles').doc(`${id}`).get().then(snapshot => {
    return snapshot.data();
   }).then(circle => {
        return stripe.plans.create({
            amount: weekly_amount,
            interval: 'week',
            interval_count: 1,
            product: {
                name: id, 
            },
              currency: 'usd',
            }, function(err, plan) {
            console.log('PLAN::', plan);
            var data = {
                plan_id: plan.id,
                plan_created: plan.created,
            };
            return admin.firestore().collection('circles').doc(`${id}`).set(data, {merge: true});
            console.log(product.id);
        });
    });
});