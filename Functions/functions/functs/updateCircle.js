


const admin = require('firebase-admin');
const functions = require('firebase-functions');

const schedule = require('node-schedule');

exports = module.exports =  functions.https.onRequest((req, res) => {
    const circleRef= admin.firestore().collection('circles');
    var unsubscribe = circleRef.onSnapshot(function(snapshot) {
       snapshot.forEach(doc => {
           let newRef = circleRef.doc(doc.id).collection('insight');
        unsubscribe = newRef.onSnapshot(function(snapshot) {
            snapshot.forEach(doc => {
                return admin.firestore().runTransaction(function(transaction) {
                    const ref = newRef.doc(doc.id);
                    return transaction.get(ref).then(function(sfDoc) {
                        if (!sfDoc.exists) {
                            throw "Document does not exist!";
                        }
                        const data = sfDoc.data();
                        var activated = data.activated

                        var days_left = data.days_left
                            if (days_left > 0) {
                                days_left = data.days_left - 1
                            } else if (days_left === 0) {
                                activated = false
                                ref.delete().then(function() {
                                    console.log("Document successfully deleted!");
                                     }).catch(function(error) {
                                     console.error("Error removing document: ", error);
                                });
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
    }, function(error) {
       console.log("Transaction failed: ", error);
         });
        });
    });








