// Import the functions you need from the SDKs you need
// import { initializeApp } from "/node_modules/firebase/app";
// import { getMessaging, onMessage } from "/node_modules/firebase/messaging";
// import { getMessaging, onBackgroundMessage } from "/node_modules/firebase/messaging/sw";
    //   import { initializeApp } from "https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js";
    //   import { getMessaging, onMessage, getToken } from "https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js";
importScripts('https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js');
importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js");
const firebaseConfig = {
  apiKey: "AIzaSyAI9TdgVUBRtPxGYVMWI7GwVTXx8D8cL5o",
  authDomain: "vcms-7c769.firebaseapp.com",
  projectId: "vcms-7c769",
  storageBucket: "vcms-7c769.appspot.com",
  messagingSenderId: "1030093545952",
  appId: "1:1030093545952:web:59f352860e04186df40b85",
  measurementId: "G-41Q73SB2TD"
};

// Initialize Firebase
const app = firebase.initializeApp(firebaseConfig);
const messaging = firebase.messaging();

// messaging.onBackgroundMessage((payload) => {
//     // Customize notification here
//     const notificationTitle = 'Background Message Title';
//     const notificationOptions = {
//       body: 'Background Message body.',
//       icon: '/firebase-logo.png'
//     };
  
//     self.registration.showNotification(notificationTitle,
//       notificationOptions);
//   });

//   messaging.onMessage((payload) => {
//   console.log('Message received. ', payload);
//   // Update the UI to include the received message.
//   appendMessage(payload);
// });

// function appendMessage(payload) {
//   const messagesElement = document.querySelector('#messages');
//   const dataHeaderElement = document.createElement('h5');
//   const dataElement = document.createElement('pre');
//   dataElement.style = 'overflow-x:hidden;';
//   dataHeaderElement.textContent = 'Received message:';
//   dataElement.textContent = JSON.stringify(payload, null, 2);
//   messagesElement.appendChild(dataHeaderElement);
//   messagesElement.appendChild(dataElement);
// }
