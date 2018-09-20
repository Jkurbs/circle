// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
admin.initializeApp();


const fs = require('fs');
const path = require('path');

// Folder where all your individual Cloud Functions files are located.
const FUNCTIONS_FOLDER = './functs';

fs.readdirSync(path.resolve(__dirname, FUNCTIONS_FOLDER)).forEach(file => { // list files in the folder.
	if(file.endsWith('.js')) {
		const fileBaseName = file.slice(0, -3); // Remove the '.js' extension
		if (!process.env.FUNCTION_NAME || process.env.FUNCTION_NAME === fileBaseName) {
			exports[fileBaseName] = require(`${FUNCTIONS_FOLDER}/${fileBaseName}`);
		}
	}
});
