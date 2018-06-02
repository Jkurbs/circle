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
    
   const circleRef= admin.firestore().collection('users').doc(userId);
    var unsubscribe = circleRef.onSnapshot(function(snapshot) {
       snapshot.forEach(doc => {
           const size = snapshot.size();
           console.log('SIZE::', size);
            return admin.firestore().runTransaction(function(transaction) {
                const ref = circleRef.doc(doc.id);
                return transaction.get(ref).then(function(sfDoc) {
                    if (!sfDoc.exists) {
                        throw "Document does not exist!";
                    }
                    
                    const data = sfDoc.data();
                    console.log('CIRCLE DATA::', data);
                    var days_left = data.days_left
                    if (days_left > 0) {
                        days_left = 7 * size
                    }
                    transaction.update(ref, { days_left: days_left});
                    unsubscribe();
                });
            }).then(function() {
                console.log("Transaction successfully committed!");
            }).catch(function(error) {
                console.log("Transaction failed: ", error);
            });
        });
    }, function(error) {
       console.log("Transaction failed: ", error);

    });
    
    
    
    
    
    
    
    
    
    
    
//   const val = event.data.data();
//   const id = event.params.id; 
//   const userId = event.params.userId;  
//   const customer_id = val.customer_id;
//    console.log('SIZEEE::', event.size);
//
//   return admin.firestore().collection('circles').doc(`${id}`).get().then(snapshot => {
//    return snapshot.data();
//   }).then(circle => { 
//       const activated = circle.activated;
//       if (activated === true) {
//        const plan_id = circle.plan_id; 
//        return stripe.subscriptions.create({
//          customer: customer_id,
//          items: [{plan: plan_id}],
//        });
//           
//        var data = {
//          days_left: 7,
//        }; 
//        
//        return admin.firestore().collection('circles').doc(`${id}`).collection('insiders').doc(`${userId}`).set(data, {merge: true});
//       }
//    });
});