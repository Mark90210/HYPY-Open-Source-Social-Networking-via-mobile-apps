var args = arguments[0] || {},
	item = args.item;

try {
	$.image.image = item.hero_image;
	$.name.text = item.name;	
	$.usercount.text = item.count_active_users;
} catch(ex) {
	Ti.API.error("PastEventView error: " + JSON.stringify(ex));
}

var viewEvent = function(event){
	Ti.API.info("Event Row Clicked, event:" + JSON.stringify(event));
	Alloy.Globals.CurrentWindow = Alloy.createController('event', {'item': item}).getView();
	Alloy.Globals.CurrentWindow.open();
};

$.image.addEventListener('click', viewEvent);
$.name.addEventListener('click', viewEvent);
$.usercount.addEventListener('click', viewEvent);