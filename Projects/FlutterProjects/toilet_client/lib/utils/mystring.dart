class MyString{
    static const int DEFAULTNUMBER = 111111;
    static const String ADRESS_LOCAL = "localhost";
		// static const String ADRESS = "localhost";
		static const String ADRESS = "192.168.101.58";
		static const String PORT = "8095";
    static const String BASE = 'http://$ADRESS:$PORT';


    // //RENDER: vegas-toilet-app.onrender.com
    // static const CREATE_FEEDBACK = '$BASE/create_feedback';
    static const CREATE_FEEDBACK_STATUS = '$BASE/create_feedback_status';
    static const LIST_FEEDBACK = '$BASE/list_feedback';
    static const CREATE_NOTI_ALL = '$BASE/firebase/notification/all';
    static const CREATE_NOTI = '$BASE/firebase/notification';
    static const CREATE_FEEDBACK = '$BASE/create_feedback';


    
     static const LIST_USER= '$BASE/user/list';
     static const CREATE_USER= '$BASE/user/register';
     static const DELETE_USER= '$BASE/user/delete/';
     static const UPDATE_USER= '$BASE/user/update/';
     static const CREATE_CHECKLIST= '$BASE/checklist/create';

     static const String FIREBASE_APP_NAME = 'toilet-info';
     static const String FIREBASE_apiKey = 'AIzaSyAw_HIIX23VppjgRlWsaOUfULgeCGIWUg8';
     static const String FIREBASE_appId = '1:551431577143:ios:57829f77c77c27257669b2';

     static const String FIREBASE_messagingSenderId = '551431577143';
     static const String FIREBASE_projectId = 'toilet-info';
     static const String FIREBASE_auth_domain= 'toilet-info.firebaseapp.com';
     static const String FIREBASE_url = 'https://toilet-info-default-rtdb.asia-southeast1.firebasedatabase.app';
     static const String FIREBASE_storage_bucket = 'toilet-info.appspot.com';
     static const String FIREBASE_measurementId = 'G-RSN4SQ0LP2';
}