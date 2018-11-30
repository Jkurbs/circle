//
//const functions = require('firebase-functions');
//const admin = require('firebase-admin');
//
//
//exports = module.exports = functions.https.onRequest((req, res) => {
//  
//	console.log(req, res);
//	var circlesRef = admin.database().ref('users').orderByChild('activated').equalTo(true);
//
//	return circlesRef.on('value', function(snapshot) {
//    
//		return snapshot.forEach(function(childSnapshot) { 
//        
//			var childKey = childSnapshot.key;
//            
//			var insightRef = admin.database().ref('/insights').child(childKey);
//            
//			return insightRef.once('value').then(function(snapshot) {           
//				var daysLeft = snapshot.val().daysLeft;
//				return snapshot.ref.update({daysLeft: daysLeft - 1}).then(() => {
//					circlesRef.off(); 
//					return res.status(200).end();
//				});
//			});
//		});        
//	});  
//});
