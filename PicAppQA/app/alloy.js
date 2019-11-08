// The contents of this file will be executed before any of
// your view controllers are ever executed, including the index.
// You have access to all functionality on the `Alloy` namespace.
//
// This is a great place to do any initialization for your app
// or create any global variables/functions that you'd like to
// make available throughout your app. You can easily make things
// accessible globally by attaching them to the `Alloy.Globals`
// object. For example:
//
// Alloy.Globals.someGlobalFunction = function(){};

var heightOfTabBar = 50;
var heightOfFilterBar = 50;
var cameraActionbuttonHeight = 50;
var vspacing = 10;
var deviceW = Ti.Platform.displayCaps.platformWidth ;
var deviceH = Ti.Platform.displayCaps.platformHeight;
var devicePR = Ti.Platform.displayCaps.logicalDensityFactor;

Alloy.Globals.defaultToken = "abctest123";
Alloy.Globals.centerContentHeight = (deviceH - heightOfTabBar - cameraActionbuttonHeight - heightOfFilterBar - vspacing -10);


if(Ti.Platform.osname === "android"){
	var devicePR = Ti.Platform.displayCaps.logicalDensityFactor;
	var deviceW = (Ti.Platform.displayCaps.platformWidth)/devicePR ;
	var deviceH = (Ti.Platform.displayCaps.platformHeight)/devicePR;
	
	Alloy.Globals.centerContentHeight = (deviceH - heightOfTabBar - cameraActionbuttonHeight - heightOfFilterBar - vspacing -10);

}

Alloy.Globals.CurrentWindow=null;

Alloy.Globals.loading = Alloy.createWidget("nl.fokkezb.loading");

Alloy.Globals.closeWin=function(){
	Alloy.Globals.CurrentWindow.close();
};

Alloy.Globals.notiWin=function(){
	var wind = Alloy.createController('notifications').getView();
	wind.open();
	if(Alloy.Globals.CurrentWindow != null && Alloy.Globals.CurrentWindow != undefined){
		Alloy.Globals.CurrentWindow.close();
	}
	Alloy.Globals.CurrentWindow=wind;
};

Alloy.Globals.checkStoragePermission = function(){
	try{
		var hasStoragePermissions =Ti.Filesystem.hasStoragePermissions();
		
		if(hasStoragePermissions == true) return;
		
		Ti.Filesystem.requestStoragePermissions(function(e) {
			if (e.success) {
				// Instead, probably call the same method you call if hasCameraPermissions() is true
				//Ti.API.info('You granted permission.');
			} else if (OS_ANDROID) {
				//Ti.API.info('STORAGE You don\'t have the required uses-permissions in tiapp.xml or you denied permission for now, forever or the dialog did not show at all because you denied forever before.');
			} else {
				// We already check AUTHORIZATION_DENIED earlier so we can be sure it was denied now and not before
				//Ti.API.info('You denied permission.');
			}
		});
	}catch(ex){
		Ti.API.error("storage permission " + ex.toString());
	}
};  

Alloy.Globals.checkLocationPermission = function(){
	try{
		var hasLocationPermissions =Titanium.Geolocation.hasLocationPermissions(Titanium.Geolocation.AUTHORIZATION_WHEN_IN_USE);
		
		if(hasLocationPermissions == true) return;
		
		Titanium.Geolocation.requestLocationPermissions(Titanium.Geolocation.AUTHORIZATION_WHEN_IN_USE,function(e) {
			if (e.success) {
				// Instead, probably call the same method you call if hasCameraPermissions() is true
				//Ti.API.info('You granted permission.');
			} else if (OS_ANDROID) {
				//Ti.API.info('STORAGE You don\'t have the required uses-permissions in tiapp.xml or you denied permission for now, forever or the dialog did not show at all because you denied forever before.');
			} else {
				// We already check AUTHORIZATION_DENIED earlier so we can be sure it was denied now and not before
				//Ti.API.info('You denied permission.');
			}
		});
	}catch(ex){
		Ti.API.error("checkLocationPermission " + ex.toString());
	}
};  

Alloy.Globals.getGeolocation = function(){
	
	try{
		Titanium.Geolocation.accuracy = Titanium.Geolocation.ACCURACY_KILOMETER;
		Titanium.Geolocation.getCurrentPosition(function(e)
		{
			try{
				Ti.API.info("received geo response");
				if (e.error)
				{
					Ti.API.error(e.error);
					
					return;
				}
				Titanium.App.Properties.setDouble('longitude',e.coords.longitude);
				Titanium.App.Properties.setDouble('latitude',e.coords.latitude);
				
				Ti.API.info("You are at: "+e.coords.longitude+"\n"+e.coords.latitude+ " ");
				getAddress();
				
			//	Titanium.Geolocation.reverseGeocoder(e.coords.latitude, e.coords.longitude,selfObj.getAddress);
			}catch(e1){
				Ti.API.error(" getCurrentPosition  " +  e1);
			}
		});
	}catch(e){
		Ti.API.error(" getGeolocation  " +  e);
		
	}
};

function getAddress(){
	var longitude = Titanium.App.Properties.getDouble('longitude',0);
	var latitude = Titanium.App.Properties.getDouble('latitude',0);
	if(longitude!=0 && latitude!=0){
		
		Titanium.Geolocation.reverseGeocoder(latitude,longitude,function(evt)
		{
			try{
				
			if (evt.success) {
				var places = evt.places;
				if (places && places.length >0) {
						var place = places[0];
						Ti.API.info("place = "+ JSON.stringify(place));
					 	var city = place.city;
					 	
					 	var utility = require("utility");
					 	var state = utility.getUSState(place.state);
					 	
					 	if(state == undefined || state == null || state ==""){
					 		 state = utility.getUSState(place.address);
					 	}
					 	
					 	city = ((city=="" || city==undefined || city == null)?"": city);
					 	
					 	Ti.API.info("city = "+city);
					 	var location;
					 	
					 	if(state !="" && state != undefined && state != null){
					 		location = city + ", " + state;
					 	}else{
					 		location = city;
					 	}
					 	Ti.API.info("state = "+state);
					 	Ti.API.info("location = "+location);
					 	
					 	Titanium.App.Properties.setString('location',location);
				} else {
					//reverseGeo.text = "No address found";
				}
				Ti.API.info("reverse geolocation result = "+JSON.stringify(evt));
			}
			
			}catch(ex){
				Ti.API.error("exception reverse geo " + JSON.stringify(ex));
			}
		});	
	}
	
}

Alloy.Globals.getGeolocation();
