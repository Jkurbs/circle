
const functions = require('firebase-functions');
const admin = require('firebase-admin');

//New User Name

exports = module.exports = functions.database.ref('/members/{circleId}/{id}')
	.onCreate((change, context) => {

		const circleId = context.params.circleId;
		const userId = context.params.id;

		const userRef = admin.database().ref('/users').child(userId);
		const tokenRef = admin.database().ref('/tokens').child(userId);
		const membersRef = admin.database().ref('/circles').child(circleId).child('members');
		const circleRef = admin.database().ref('/circles').child(circleId);

		let count; let firstName;

		userRef.once('value').then(function(snapshot) {
			firstName = snapshot.val().first_name;
			return console.log('first name: ', firstName);
		});

		// User Join
		return membersRef.transaction((current) => {
			count = (current);
			let timeStamp = admin.database.ServerValue.TIMESTAMP;
			userRef.update({circleId: circleId, position: count, joinTime: timeStamp});
			return count;
		}).then(() => {
			circleRef.update({members: count + 1 });
			return tokenRef.once('value').then(function(snapshot) {
				let token = snapshot.val().device_token;
				return admin.messaging().subscribeToTopic(token, circleId)
					.then(function(response) {
						console.log('Successfully subscribed from topic:', response);
					})
					.catch(function(error) {
						console.log('Error subscribing from topic:', error);
					});
			}).then(() => {
				return sendNotif(circleId, firstName, 'has joined your Circle');
			});
		});
	});


function sendNotif(circleId, firstName, message) {
	const payLoad = {
		notification:{
			title: '',
			body:  firstName + message,
			sound: 'default'
		}
	};

	const options = {
		priority: 'high',
		timeToLive: 60*60*2
	};
	return admin.messaging().sendToTopic(circleId, payLoad, options);
}
