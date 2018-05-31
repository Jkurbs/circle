//'use strict';
//
//const functions = require('firebase-functions');
//const admin = require('firebase-admin');
//try {admin.initializeApp(functions.config().firebase);} catch(e) {}
//
//const stripe = require('stripe')("sk_test_QfBDc4JT7E6iz8EwrsuJcR58");
//
//// [START chargecustomer]
////Charge the Stripe customer whenever an amount is written to the Realtime database
//
//exports = module.exports = functions.firestore.document('/circles/{id}').onCreate(event => {
//   const id = event.params.id;   
//   return admin.firestore().collection('circles').doc(`${id}`).get().then(snapshot => {
//    return snapshot.data();
//   }).then(circle => { 
//        console.log('CIRCLE:::', circle)
//        return stripe.products.create({
//          name: 'circle',
//          type: 'circle',
//        }, function(err, product) {
//           var data = {
//                product_id: product.id,
//            };   
//           return admin.firestore().collection('circles').doc(`${id}`).set(data, {merge: true});
//           console.log(product.id);
//    });
////        snapshot.forEach(function(doc) {
////        // doc.data() is never undefined for query doc snapshots
////        console.log(doc.id, " => ", doc.data());
////      });
//   });
//});