
const functions = require('firebase-functions');
const admin = require('firebase-admin');


exports = module.exports = functions.https.onRequest((req, res) => {
  
	console.log(req, res);
    
	var circlesRef = admin.database().ref('circles').orderByChild('activated').equalTo(true);

	circlesRef.once('value').then(function(snapshot) { 
         
		return snapshot.forEach(function(childSnapshot) { 
        
			var circleId = childSnapshot.key;
            
			var userRef =  admin.database().ref('/users').child(circleId);
			var membersRef = admin.database().ref('/members').child(circleId);            
            
			return userRef.child('daysLeft').once('value').then(function(snapshot) {            
				const daysLeft = snapshot.val();
				return userRef.update({daysLeft: daysLeft - 1});
			}).then(() => {
				return membersRef.once('value').then(function(snapshot) {  
					return snapshot.forEach(function(childSnapshot) { 
						var userID = childSnapshot.key;
						var daysLeftRef = admin.database().ref('/users').child(userID).child('daysLeft'); 
						var usersRef = admin.database().ref('/users').child(userID);
						daysLeftRef.once('value').then(function(snapshot) { 
							const daysLeft = snapshot.val();
							return usersRef.update({daysLeft: daysLeft - 1});
						});
					});
				}); 
			}); 
		});            
	});
	return res.status(200).end();
});

