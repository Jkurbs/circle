//const functions = require('firebase-functions');
//const admin = require('firebase-admin');

//
//
//exports = module.exports = functions.database.ref('/members/{circleId}/{id}')
//	.onDelete((snapshot, context) => {     
//    
//		const circleId = context.params.circleId; 
//		const userId = context.params.id;
//    
//		var token = '';
//    
//		const userRef = admin.database().ref('/users').child(userId);  
//		const circleRef = admin.database().ref('/circles').child(circleId); 
//		const membersRef =  admin.database().ref('/members').child(circleId);  
//		const tokenRef = admin.database().ref('/tokens').child(userId); 
//    
//		tokenRef.once('value').then(function(snapshot) {           
//			token = snapshot.val().device_token; 
//		});
//    
//		membersRef.once('value').then(function(snapshot) {
//            
//			const value = snapshot.numChildren();
//            
//			circleRef.update({members: value - 1}).then(() => { 
//				userRef.update({circle: '', position: 0}).then(() => {
//
//					return admin.messaging().unsubscribeFromTopic(token, circleId)
//						.then(function(response) {
//							// See the MessagingTopicManagementResponse reference documentation
//							// for the contents of response.
//							console.log('Successfully unsubscribed from topic:', response);
//						})
//						.catch(function(error) {
//							console.log('Error unsubscribing from topic:', error);
//						});
//				});
//			});
//		}); 
//	});