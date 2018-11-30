const functions = require('firebase-functions');
const admin = require('firebase-admin');



exports = module.exports = functions.database.ref('/circles/{id}/members')
	.onUpdate((change, context) => { 
    
		const count = change.after.val();
    
		const circleId = context.params.id;

		const circleRef = admin.database().ref('/circles').child(circleId);

		if (count === 5) {
			circleRef.update({activated: true});
			sendNotif(circleId);

			circleRef.once('value').then(function(snapshot) {                
				let amount = snapshot.val().amount; 
				let round = snapshot.val().round;  
				snapshot.ref.update({round: round + 1});
				return addInsight(circleId, amount, count, round);
			});
		} else {
			return null; 
		}
	});




function addInsight(circleId, amount, count, round) {
    
	const daysTotal = count * 7;
	const daysLeft = daysTotal - 1;
	const weeklyAmount = amount / count; 
	round = round + 1;

	var postData = {
		daysTotal: count * 7,
		daysLeft: daysLeft,
		weeklyAmount: weeklyAmount, 
		totalAmount: amount, 
		round: round
	};
    
    
	var updates = {};
	updates['/insights' + '/' + circleId ] = postData;
	addUserInsight(circleId);
	return admin.database().ref().update(updates);
}


function addUserInsight(circleId) {

	const membersRef = admin.database().ref('/members').child(circleId); 
    
	membersRef.on('value', function(snapshot) {
		snapshot.forEach(function(childSnapshot) {
			var childKey = childSnapshot.key;
            
			const usersRef = admin.database().ref('/users').child(childKey);             
            
			usersRef.once('value').then(function(snapshot) {
                
				const position = snapshot.val().position; 
				const daysTotal = position * 7;
				const daysLeft = daysTotal - 1;
				return usersRef.update({daysTotal: daysTotal, daysLeft: daysLeft});
			}, function(error) {
				console.error(error);
			});
		});
	});
}



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

