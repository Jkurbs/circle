//'use strict';
//
//const functions = require('firebase-functions');
//const admin = require('firebase-admin');
//try {admin.initializeApp(functions.config().firebase);} catch(e) {}
//
//const stripe = require('stripe')("sk_test_QfBDc4JT7E6iz8EwrsuJcR58");
//var cron = require('cron');
//// [START chargecustomer]
////Charge the Stripe customer whenever an amount is written to the Realtime database
//
//exports = module.exports = functions.firestore.document('/circles/{id}/insiders/{userId}/time').onUpdate(event => { 
//   const val = event.data.data();
//   const id = event.params.id; 
//   const userId = event.params.userId; 
//   
//
//    
//    
//    return admin.firestore().collection('circles').doc(`${id}`).collection('insiders').doc(`${userId}`).get().then(snapshot => {
//    return snapshot.data();
//     }).then(circle => {
//
//        
//        
//        
//        
//        
//        
//        
//        
//        
//        
//        
//        
//        
//    });