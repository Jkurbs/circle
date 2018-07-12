
const stripe = require('stripe')("sk_test_QfBDc4JT7E6iz8EwrsuJcR58");

const admin = require('firebase-admin');
const functions = require('firebase-functions');


exports = module.exports =  functions.https.onRequest((req, res) => {
    const circleRef= admin.firestore().collection('users');
    var unsubscribe = circleRef.where('activated', '==', true).where('days_left', '==', 0).onSnapshot(function(snapshot) {
       snapshot.forEach(doc => {
            return admin.firestore().runTransaction(function(transaction) {
                const ref = circleRef.doc(doc.id);
                return transaction.get(ref).then(function(sfDoc) {
                    if (!sfDoc.exists) {
                        throw "Document does not exist!";
                    }

                    const data = sfDoc.data();
                    const circle = data.circle
                    const account_id = data.account_id
                    console.log('CIRCLE ID:::', circle);
                    
                    
                    
            return admin.firestore().collection('circles').doc(circle).get().then(snapshot => {
            return snapshot.data();
            }).then(circle => {
               const admin = circle.admin;
               const weekly_amount = circle.weekly_amount;
               
               sendPayment(weekly_amount, account_id)
               console.log('ADMIN:::', admin);
                
               
               unsubscribe(); 
    
//                    var days_left = data.days_left
//                    if (days_left > 0) {
//                        days_left = data.days_left - 1
//                    }
//                    transaction.update(ref, { days_left: days_left});
                    });  
                });
            }).then(function() {
                console.log("Payment successfully committed!");
            }).catch(function(error) {
                console.log("Payment failed: ", error);
            });
        });
    }, function(error) {
       console.log("Transaction failed: ", error);
    });
});







function sendPayment(amount, stripe_id) {
    console.log('SEND PAYMENT::', amount, stripe_id);
   stripe.payouts.create({
      amount: amount,
      currency: "usd",
    }, {
      stripe_account: stripe_id,
    }).then(function(payout) {
      console.log('PAYOUT:::', payout);
    });
}




