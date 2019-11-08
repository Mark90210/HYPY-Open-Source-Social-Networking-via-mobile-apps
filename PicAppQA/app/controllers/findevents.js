var args = arguments[0] || {};

function pastevents(){  
	$.header.mailicid.visible="false";  
    $.fevents.removeAllChildren();
    var pevents=Alloy.createController('events');
    $.fevents.add(pevents.getView());    
}
