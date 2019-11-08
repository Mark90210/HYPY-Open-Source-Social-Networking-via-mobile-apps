var isFirstTime = Titanium.App.Properties.getBool('isFirstTimehypy',true);

if(isFirstTime){
	var win = Alloy.createController('locationrequest').getView(),
	selfObj = this;
	win.open();
	Titanium.App.Properties.setBool('isFirstTimehypy',false);
}else{
	 Alloy.Globals.CurrentWindow=Alloy.createController('home').getView();
	 Alloy.Globals.CurrentWindow.open();
}
setTimeout(function() {
	Alloy.Globals.getGeolocation();
	getUserProfile();
}, 150);

if (OS_ANDROID) {
	setTimeout(function(){
		Alloy.Globals.checkLocationPermission();
		Alloy.Globals.checkStoragePermission();
	}, 100);
}

function getUserProfile() {
   	try {
		if(Titanium.Network.online == false){
			alert("Your device is not online. Please check connectivity.");
			return;
		}
		var httpparams = 'token=' + Titanium.App.Properties.getString('hypytoken',Alloy.Globals.defaultToken);
		var httpClient = require("HttpConnection");
	 	httpClient.callAPIGet("users/me", httpparams, selfObj.cb_getUserProfile);
	} catch(ex) {
		Ti.API.error("getUserProfile " + JSON.stringify(ex));
	}	
}
this.cb_getUserProfile = function(data) {
	try {
		var response = JSON.parse(data);
		Ti.API.info("cb_getUserProfile, data: " + data);
		Titanium.App.Properties.setObject('userprofile', response);
	} catch(ex) {
		Ti.API.error("doUserProfileCallback " + JSON.stringify(ex));
	}
};