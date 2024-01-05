class MyString{
    static const int DEFAULTNUMBER = 111111;
    static const String ADRESS_LOCAL = "localhost";
		static const String ADRESS_SERVER = "30.0.0.53";
    static const String BASE = 'http://$ADRESS_LOCAL:8090/api/';
    static const String BASEURL = 'http://localhost:8090';
    // static const String BASEURL = 'http://30.0.0.53:8090';

     static const String list_ranking = '${BASE}list_ranking';
     static const String create_ranking = '${BASE}add_ranking';
     static const String update_ranking = '${BASE}update_ranking';
     static const String delete_ranking = '${BASE}delete_ranking';
     static const String delete_ranking_all_and_add = '${BASE}delete_ranking_all_create_default';

    //RENDER: vegas-toilet-app.onrender.com

    // static const CREATE_FEEDBACK = 'http://192.168.101.58:8095/create_feedback';
    static const CREATE_FEEDBACK_STATUS = 'http://192.168.101.58:8095/create_feedback_status';
    static const LIST_FEEDBACK = 'http://192.168.101.58:8095/list_feedback';
    static const CREATE_NOTI_ALL = 'http://192.168.101.58:8095/firebase/notification/all';
    static const CREATE_NOTI = 'http://192.168.101.58:8095/firebase/notification';

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