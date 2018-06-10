


const admin = require('firebase-admin');
const functions = require('firebase-functions');

const schedule = require('node-schedule');



exports = module.exports =  functions.https.onRequest((req, res) => {
    const circleRef= admin.firestore().collection('circles');
    var unsubscribe = circleRef.onSnapshot(function(snapshot) {
       snapshot.forEach(doc => {
            const ref = circleRef.doc(doc.id);
            var batch = admin.firestore().batch();

            batch.update(ref, {'days_left': 5});
            unsubscribe();
           
           
           
//            return admin.firestore().runTransaction(function(transaction) {
//                const ref = circleRef.doc(doc.id);
//                return transaction.get(ref).then(function(sfDoc) {
//                    if (!sfDoc.exists) {
//                        throw "Document does not exist!";
//                    }
//
//                    const data = sfDoc.data();
//                    var activated = data.activated
//                    if (activated === true) {
//                    var days_left = data.days_left
//                        if (days_left > 0) {
//                            days_left = data.days_left - 1
//                        }
//                    transaction.update(ref, { days_left: days_left});
//                    unsubscribe();
//                    } else {
//                         return Promise.reject("Sorry! Circle not activated");
//                    }
//                });
//            }).then(function(days_left) {
//                console.log("Transaction successfully committed!", days_left);
//            }).catch(function(error) {
//                console.log("Transaction failed: ", error);
//            });
//        });
//    }, function(error) {
//       console.log("Transaction failed: ", error);
         });
    });
});
    

    



