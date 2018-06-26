const admin = require('firebase-admin');
const functions = require('firebase-functions');

const schedule = require('node-schedule');
const stripe = require('stripe')("sk_test_QfBDc4JT7E6iz8EwrsuJcR58");


exports = module.exports =  functions.https.onRequest((req, res) => {
    const circleRef= admin.firestore().collection('circles');
    var unsubscribe = circleRef.onSnapshot(function(snapshot) {
       snapshot.forEach(doc => {
           var data = doc.data();
           var activated = data.activated;
           if (activated === true) {
            let newRef = circleRef.doc(doc.id).collection('insiders');
            unsubscribe = newRef.onSnapshot(function(snapshot) {
                snapshot.forEach(doc => {
                    return admin.firestore().runTransaction(function(transaction) {
                        const ref = newRef.doc(doc.id);
                        return transaction.get(ref).then(function(sfDoc) {
                            if (!sfDoc.exists) {
                                throw "Document does not exist!";
                            }
                            const data = sfDoc.data();

                            var days_left = data.days_left
                            var accountId = data.account_id
                            console.log('account_id', accountId);
                                if (days_left > 0) {
                                    days_left = data.days_left - 1
                                } else if (days_left === 0) {
                                    payDay(accountId, 200);
                                }
                            transaction.update(ref, { days_left: days_left});
                            unsubscribe();
                        });
                    }).then(function(days_left) {
                        console.log("Transaction successfully committed!", days_left);
                        unsubscribe();
                    }).catch(function(error) {
                        console.log("Transaction failed: ", error);
                    });
                });
            });
        }
    }, function(error) {
       console.log("Transaction failed: ", error);
         });
        });
    });




function payDay(accountId, amount) {
    console.log('ITS PAYDAY');
    stripe.transfers.create({
        amount: amount,
        currency: "usd",
      },
      {stripe_account: accountId}
    );
}

