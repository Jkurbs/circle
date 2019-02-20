
const functions = require('firebase-functions');
const admin = require('firebase-admin');

exports = module.exports = functions.https.onRequest((req, res) => {

	console.log(req, res);

	const circlesRef = admin.database().ref('circles').orderByChild('activated').equalTo(true);

	return circlesRef.on('value', function(snapshot) {

		return snapshot.forEach(function(childSnapshot) {
			var circleId = childSnapshot.key;
			const insightsRef = admin.database().ref('/insights').child(circleId);
			const membersRef = admin.database().ref('/members').child(circleId);

			return insightsRef.child('daysLeft').once('value').then(function(snapshot) {
				const daysLeft = snapshot.val();
				if (daysLeft > 0) {
					circlesRef.off();
					return insightsRef.update({daysLeft: daysLeft - 1});
				}
			}).then(() => {
				return membersRef.once('value').then(function(snapshot) {
					return snapshot.forEach(function(childSnapshot) {
						var childKey = childSnapshot.key;
						const usersRef = admin.database().ref('/users').child(childKey);
						usersRef.once('value').then(function(snapshot) {
							const daysLeft = snapshot.val().daysLeft;
							if (daysLeft > 0) {
								snapshot.ref.update({daysLeft: daysLeft - 1});
							}
							return res.status(200).end();
						});
					});
				});
			});
		});
	});
});
