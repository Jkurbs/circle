//
//
//
//
//
//
//
// exports = module.exports = functions.database.ref('/usersInfo/{userId}')
// 	.onUpdate((snap, context) => {
//
//     const userId = context.params.userId;
//
//     const accountIdRef = admin.database().ref('/stripe').child(userId).child('accountId');
//
//     let accountId;
//
//     accountIdRef.once('value').then(function(snapshot) {
//         accountId = snapshot.val();
//
//         return stripe.accounts.update(
//           {accountId},
//           {
//             tos_acceptance: {
//               date: Math.floor(Date.now() / 1000),
//               ip: request.connection.remoteAddress // Assumes you're not using a proxy
//             }
//           }
//         );
//
//
//        //
//        //  return stripe.accounts.update(accountId, {
//        //     support_phone: '555-867-5309',
//        //     email: 'kerby.jean@gmail.fr',
//        //
//        // });
//     });
// });