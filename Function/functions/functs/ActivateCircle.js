const functions = require('firebase-functions');
const admin = require('firebase-admin');


exports = module.exports = functions.firestore.document('/circles/{id}').onUpdate((change, context) => {
	const afterData = change.after.data(); // data after the write
	const activated = afterData.activated;
	const circleId = context.params.id;
   
	if (activated === true) {
		return sendNotif(circleId);
	}
});


function sendNotif(circleId) {
	const payLoad = {
		notification:{
			title: '',
			body: 'Your Circle has been activated',
			sound: 'default'
		}
	};

	const options = {
		priority: 'high',
		timeToLive: 60*60*2
	};

	return admin.messaging().sendToTopic(circleId, payLoad, options);
}
