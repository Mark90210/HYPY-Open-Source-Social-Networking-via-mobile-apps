var args = arguments[0] || {};

setUserProfile();

function setUserProfile()
{
   	try{
			var profile = Titanium.App.Properties.getObject('userprofile', undefined);
			if(profile != undefined){
				var lastname =  (profile.last_name == null?"":profile.last_name);
				 var first_name = (profile.first_name == null?"":profile.first_name);
				 
				 $.header.headertitleWin.text = first_name + " " + lastname;
				 $.username.text = first_name + " " + lastname;
				 $.bio.text = (profile.bio == null?"":profile.bio); 
				 $.profile_image.image = profile.profile_image;
			}
			$.location.text = Titanium.App.Properties.getString('location',"");
		 
	}catch(ex){
		Ti.API.error("setUserProfile my profile " + JSON.stringify(ex));
	}	
}
function editProfile(){
	var wind = Alloy.createController('account').getView();
	Alloy.Globals.CurrentWindow=wind;
	wind.open();
	$.myprofile.close();
}
