var slideSpeed=300;
var st=false;
var bgcolor="transparent";
var animation = Titanium.UI.createAnimation();
var viewanimation = Titanium.UI.createAnimation();
animation.duration=slideSpeed;

function animateDrawer(){
	$.slidemenu.profileMenuShow();
	$.slidemenu.setUserProfile();
	if(!st){ 
		animation.addEventListener('complete',animationComplete);
		animation.left=0; 
		//bgcolor="#50000000";		
		bgcolor="#01ffffff";
		$.slidemenu.slidemenu.animate(animation); 
		st=true; 
	}else{
		st=false;
		animation.left="-100%";
		bgcolor="transparent";
		$.slidemenu.slidemenu.animate(animation);
	}
}

function animationComplete(){
	$.slidemenu.slidemenu.backgroundColor=bgcolor;
	if(bgcolor=="transparent"){
		animation.removeEventListener('complete',animationComplete);
	}
}

function slideSwipe(e){
	if(e.direction=="left"){
		slideClose();
	}else if(e.direction=="right"){
		animateDrawer();
	}   
}





function slideClose(){
	st=true;
	$.slidemenu.slidemenu.backgroundColor="transparent";
	animateDrawer();
}

function addRemoveViews(view){
	$.header.headertitle.text="HYPY";
	var child = $.primarycontainer.getChildren()[0];
	var newview = view.getView();
	newview.opacity=0;
	viewanimation.opacity=0;
	viewanimation.duration=200;
	viewanimation.addEventListener("complete",removeChildView);
	child.animate(viewanimation);
	$.primarycontainer.add(newview);
	newview.animate({opacity:1,duration:100});
	$.primarycontainer.remove(child);
}

function removeChildView(e){
	viewanimation.removeEventListener("complete",removeChildView);
}

function showScreens(e){
	Ti.API.info("showScreens " +JSON.stringify(e));
	st=true;
	animateDrawer();
	var rowid=e.row.id;
	setTimeout(function(){
		switch(rowid){
			case "myprofile":
			Ti.API.info("token " + Titanium.App.Properties.getString('hypytoken',Alloy.Globals.defaultToken) );
			Ti.API.info("defaultToken " + Alloy.Globals.defaultToken);
			
			if(Titanium.App.Properties.getString('hypytoken',Alloy.Globals.defaultToken) != Alloy.Globals.defaultToken){
					var wind = Alloy.createController('myprofile').getView();
					Alloy.Globals.CurrentWindow=wind;
					wind.open();
				}
				
			break;
			case "myevents":
				//$.header.noti.visible=true;
				var events = Alloy.createController('events');
				addRemoveViews(events);
			break;
			case "newevents":
				//$.header.noti.visible=true; 
				var events = Alloy.createController('events');
				addRemoveViews(events);
			break;
			case "notifications":
				var wind = Alloy.createController('notifications').getView();
				Alloy.Globals.CurrentWindow=wind;
				wind.open();
			break;
			case "settings":
				
			break;
		}
	},200);
}
/* Menu Event Binds */
$.header.nav.addEventListener('singletap',animateDrawer);
$.slidemenu.slidemenu.addEventListener('swipe',slideSwipe);
$.home.addEventListener('swipe',slideSwipe);
$.slidemenu.backnav.addEventListener('click',slideClose);
/* Initial screen */
var findevts = Alloy.createController('findevents');
$.primarycontainer.add(findevts.getView());
//$.header.noti.visible=false;

setTimeout(function(){
	showScreens({row:{id:'newevents'}});
},100);

/* Menu event binding */
$.slidemenu.menuTable.addEventListener('click',showScreens);

