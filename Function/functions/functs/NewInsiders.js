const functions = require('firebase-functions');
const admin = require('firebase-admin');


exports = module.exports = functions.firestore.document('/circles/{circleId}/users/{id}').onCreate((change, context) => {
//  const beforeData = change.before.data(); // data before the write
//  const afterData = change.after.data(); // data after the write
//  const token = afterData.device_token;
    
	const circleId = context.params.circleId;

	return sendNotif(circleId);
	//return admin.messaging().subscribeToTopic(token, circleId);
});


function sendNotif(circleId) {
	const payLoad = {
		notification:{
			title: '',
			body: 'Someone joined the Circle',
			sound: 'default'
		}
	};

	const options = {
		priority: 'high',
		timeToLive: 60*60*2
	};

	return admin.messaging().sendToTopic(circleId, payLoad, options);
}
