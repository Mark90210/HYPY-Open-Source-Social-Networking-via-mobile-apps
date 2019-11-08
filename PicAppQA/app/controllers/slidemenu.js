var args = arguments[0] || {};



$.profileMenuShow = function(){
	if(Titanium.App.Properties.getString('hypytoken',Alloy.Globals.defaultToken) == Alloy.Globals.defaultToken){
		$.myprofilelbl.color = "gray";
	}else{
		$.myprofilelbl.color = "black";
	}
};

$.setUserProfile = function(){
   	try{
			var profile = Titanium.App.Properties.getObject('userprofile', undefined);
			if(profile != undefined){
				 var lastname =  (profile.last_name == null?"":profile.last_name);
				 var first_name = (profile.first_name == null?"":profile.first_name);
				 
				 $.username.text = first_name + " " + lastname;
				 $.profile_image.image = profile.profile_image;
			}
			var loc = Titanium.App.Properties.getString('location',"");
			Ti.API.info("loc " + loc);
			$.location.text = loc;
		 
	}catch(ex){
		Ti.API.error("setUserProfile - slidemenu " + JSON.stringify(ex));
	}	
};

function updateUserProfile(){
	$.setUserProfile();
};
Ti.App.addEventListener("updateprofile",updateUserProfile);

updateUserProfile();