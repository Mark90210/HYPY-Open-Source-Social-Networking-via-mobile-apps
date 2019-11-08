var args = arguments[0] || {};
$.headertitleWin.text="Edit Profile";
var selfObj = this;
setUserProfile();

function setUserProfile()
{
   	try{
			var profile = Titanium.App.Properties.getObject('userprofile', undefined);
			Ti.API.info("profile " + JSON.stringify(profile));
			if(profile != undefined){
				 $.phone.value =(profile.phone == null?"":profile.phone);
				 $.firstname.value = (profile.first_name == null?"":profile.first_name);
				 $.lastname.value =  (profile.last_name == null?"":profile.last_name);
				 $.bio.value =(profile.bio == null?"":profile.bio); 
				 $.profile_image.image = profile.profile_image;
			}
			
			$.location.value = Titanium.App.Properties.getString('location',"");
		 
	}catch(ex){
		Ti.API.error("setUserProfile account " + JSON.stringify(ex));
	}	
}
function closeWindow(){
	saveProfile();
}

function saveProfile(){
	// if ($.firstname.value == ""){
		// alert("Please enter firstname");
		// return;
	// }
	// if ($.lastname.value == ""){
		// alert("Please enter lastname");
		// return;
	// }
	// if ($.bio.value == ""){
		// alert("Please enter bio");
		// return;
	// }
	Alloy.Globals.loading.show('update profile ', false);
	
	if (Titanium.Network.online == false){
		alert("Your device is not online. Please check connectivity.");
		return;
	} 

	var param =	{
	    'first_name': $.firstname.value,
	    'last_name': $.lastname.value,
	    'bio': $.bio.value,
	    'created_at': (new Date()),
	    'token': Titanium.App.Properties.getString('hypytoken')
	 };
	//var httpparams = 'token=abctest123';
	var httpClient = require("HttpConnection");
 	httpClient.callAPIPut("users/me", param, selfObj.cb_saveProfile);
 	
	
}

this.cb_saveProfile = function(data){
	try {
		var response = JSON.parse(data);
		Ti.API.info("doUserProfileCallback response called" + data);
			
		Titanium.App.Properties.setObject('userprofile',response);
		Ti.App.fireEvent("updateprofile");
		var wind = Alloy.createController('myprofile').getView();
	    Alloy.Globals.CurrentWindow=wind;
	    wind.open();
	    $.account.close();
	}catch(ex){
		Ti.API.error("doUserProfileCallback " + JSON.stringify(ex));
	}
};

var getProfilePic = showInputSelector;
function showInputSelector(){
	var option = option = ['Create Photo', 'Browse Photo', 'Cancel'],
		dialog = Ti.UI.createOptionDialog({
			cancel: 2,
			options: option,
			selectedIndex: 2,
			destructive: 0
		});

	dialog.addEventListener('click', function(event){
		Ti.API.info('Input Selector Click, event: ' + JSON.stringify(event));
	    if (event.index  == 0) {
	    	openCamera();	
	    } else if (event.index == 1) {
	    	 openGallery();
	    }
	});

	dialog.show();	
};

function openCamera() {
	if (OS_ANDROID && !Ti.Media.hasCameraPermissions()) {
		Ti.Media.requestCameraPermissions(function(e) {
			if (e.success) {
				Ti.API.info('User granted camera permission');
				openCamera();
			} else {
				Ti.API.info('User denied camera permission');
			}
		});
	}	
		
	Titanium.Media.showCamera({
		mediaTypes: [Titanium.Media.MEDIA_TYPE_PHOTO],
		saveToPhotoGallery: true,
		success: function (event) {
			try {
			} catch(error) {
				Ti.API.error("Camera Capture (success), error: " +error);
			}
		},
		error: function (error) {	
			try{
				var alert = Titanium.UI.createAlertDialog({title: 'Camera'});
				if (error.code == Titanium.Media.NO_CAMERA)
					errorMessage = 'No Device Camera';
				else
					alert.setMessage('Show Camera, error code: ' + error.code);
				alert.setMessage(errorMessage);
				alert.show();
			} catch(error) {
				Ti.API.error("Show Camera, error caught, error: " +error);
			}	
		},
		cancel: function() {
			Ti.API.info("User cancelled camera capture");
		}
	});	
}

function openGallery() {
	var mediaType = [Titanium.Media.MEDIA_TYPE_PHOTO];
		photoOptions;

	Titanium.Media.openPhotoGallery({	
		mediaTypes: mediaType,
		success: function (event) {	
			try {
		
			} catch(error) {
				Ti.API.error("User Picked Media, error: " + error);
			}
		},
		cancel: function() {				

		},
		error: function(error) {

		}
	});	
}