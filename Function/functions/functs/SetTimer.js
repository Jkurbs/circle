//
//'use strict';
//
//const admin = require('firebase-admin');
//const functions = require('firebase-functions');
////admin.initializeApp();
//
//const cron = require('node-cron');
//
//
//
//
//
//exports = module.exports = functions.https.onRequest((req, res) => { 
//    
//	let circleId = req.body.circleId; 
//	let endDate = req.body.endDate;
//    
//	var date = new Date(endDate);
//    
//	console.log('RES:', res.id);
//
//	var secs = date.getSeconds();
//
//	var mins = date.getMinutes();
//
//	var hours = date.getHours();
//
//	var dayofmonth = date.getDate();
//
//	var month = date.getMonth();
//
//	var dayofweek = date.getDay();
//
//    
//	var data = ['' + secs, '' + mins, '' + hours, '' + dayofmonth, '' + month, '' + dayofweek].join(' ');
//
//	console.log('DATA:', data);
//    
//	var postData = {
//		activated: true
//	};
//    
//    
//	cron.schedule(data, () => {
//		console.log('ACTIVATION STARTEED');
//		return admin.database().ref('circles/' + circleId).update(postData);
//	});   
//});
//
//
