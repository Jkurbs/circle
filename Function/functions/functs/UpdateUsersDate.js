const functions = require('firebase-functions');
const admin = require('firebase-admin');


exports = module.exports = functions.https.onRequest((req, res) => {
	var ref = admin.firestore().collection('users');
	var listener = ref.where('status', '==', 'ready').onSnapshot(function(querySnapshot) {
		querySnapshot.forEach(function(docu) {
			const circleId = docu.data().circle;
			console.log('ID:', docu.id);
			console.log('CIRCLE ID:', circleId);
			if (docu.exists) { 
				const circleRef = admin.firestore().collection('circles').doc(circleId).collection('users').doc(docu.id);

				circleRef.get().then(function(doc) {
					console.log('DATA:', doc.data());
					if (doc.exists) {
						return admin.firestore().runTransaction(transaction => {
							return transaction.get(circleRef).then(res => {
								if (!res.exists) {
									throw new Error('error');
								}
								var daysLeft = res.data().days_left;
                            
								if (daysLeft == 0 || daysLeft == null) {
									return;
								}
                            
								var newDaysLeft = daysLeft - 1;
								sendNotif(docu.id, daysLeft);
								listener();
								return transaction.update(doc.ref, {
									days_left: newDaysLeft
								});
							});
						});
					} else {
						throw new Error('error');
					}
				}).catch(function(error) {
					console.log('Error getting document:', error);
				}); 
			}
		});
		res.send('Its working');
	});
});              

     
          

                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
//                 
//                 .doc('activities').get().then(function(doc) {
//                if (doc.exists) {
//                    return admin.firestore().runTransaction(transaction => {
//                        return transaction.get(doc.ref).then(res => {
//                            if (!res.exists) {
//                                 throw new Error("error");
//                            }
//                            var daysLeft = res.data().days_left;
//                            var newDaysLeft = daysLeft - 1;
//                            sendNotif(docu.id, daysLeft);
//                            listener();
//                            return transaction.update(doc.ref, {
//                                days_left: newDaysLeft
//                            });
//                        });
//                    });
//                    } else {
//                        throw new Error("error");
//                    }
//                }).catch(function(error) {
//                    console.log("Error getting document:", error);
//                }); 
//             }
//        });
//        res.send('Its working');
//    });
//});
//


function sendNotif(circleId, daysLeft) {
	console.log('CIRCLE ID:', circleId);
	switch(daysLeft) {
	case 1:
		send(circleId, 'Your Circle has 1 day left.');
		break;
	case 5:
		send(circleId, 'Your Circle has 5 days left.');
		break;
	case 10:
		send(circleId, 'Your Circle has 10 days left.');
		console.log('10 DAYS LEFT');
		break;
	default:
		console.log('No value');
	}
}

function send(circleId, body) {
	const payLoad = {
		notification:{
			title: '',
			body: body,
			sound: 'default'
		}
	};

	const options = {
		priority: 'high',
		timeToLive: 60*60*2
	};

	return admin.messaging().sendToTopic(circleId, payLoad, options);
}



