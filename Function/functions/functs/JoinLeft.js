
const functions = require('firebase-functions');
const admin = require('firebase-admin');



exports = module.exports = functions.database.ref('/members/{circleId}/{id}')
	.onWrite((snap, context) => {  

		const circleId = context.params.circleId;
		const userId = context.params.id;

		const tokenRef = admin.database().ref('/tokens').child(userId); 
		const userRef = admin.database().ref('/users').child(userId);  
		const circleRef = admin.database().ref('/circles').child(circleId).child('members'); 

		let firstName; let members; let token;

		userRef.once('value').then(function(snapshot) {           
			firstName = snapshot.val().first_name; 
			return console.log('first name: ', firstName);
		});
    
		tokenRef.once('value').then(function(snapshot) {           
			token = snapshot.val().device_token; 
			return console.log('token: ', token);
		});
    
    
		if (snap.after.exists() && !snap.before.exists()) {
			// User Join 
			members = 1;
            
			return circleRef.transaction((current) => {
				var count = (current || 0) + members;
				console.log('join', count);
				userRef.update({circleId: circleId, position: count});
				return count;
			}).then(() => {
				sendNotif(circleId, firstName, ' joined your circle.');
				subscribe(token, circleId);
				return console.log('Counter updated.');
			});

		} else if (!snap.after.exists() && snap.before.exists()) {
            
			// User Left 
			members = -1;
                        
			return circleRef.transaction((current) => {
				var count = (current || 0) + members;
				userRef.update({circleId: '', position: 0});
				return count;
			}).then(() => {
				unsubscribe(token, circleId);
				sendNotif(circleId, firstName, ' left your circle.');
				return console.log('Counter updated.');
			});
		} else {
			return null;
		}
	});



function subscribe(token, circleId) {
	return admin.messaging().subscribeToTopic(token, circleId)
		.then(function(response) {
			console.log('Successfully subscribed from topic:', response);
		})
		.catch(function(error) {
			console.log('Error subscribing from topic:', error);
		});
}



function unsubscribe(token, circleId) {
	return admin.messaging().unsubscribeFromTopic(token, circleId)
		.then(function(response) {
			console.log('Successfully subscribed from topic:', response);
		})
		.catch(function(error) {
			console.log('Error subscribing from topic:', error);
		});
}



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