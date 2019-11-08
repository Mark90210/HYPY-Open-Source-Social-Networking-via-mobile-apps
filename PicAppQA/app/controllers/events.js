var stoppullrefreshCallback;

var args = arguments[0] || {},
	selfObj = this,
	eventList = [];

setTimeout(function(){
	Alloy.Globals.getGeolocation();
	getEvents();
}, 150);

function myRefresher(e){
	stoppullrefreshCallback =e.hide;
	getEvents();
}
function buildEventView() {
	try {
		$.eventList.setData([]);
		eventList = [];
		var sections = Titanium.App.Properties.getObject('events'),
			section, sectionIndex,
			events, event, eventIndex,
			eventViews, eventView;
		
		if (sections != undefined) {
			for (sectionIndex = 0; sectionIndex < sections.length; sectionIndex++) {
				section = sections[sectionIndex];
				events = section.events;
				countEvents = section.events.length;

				Ti.API.info("Section added, position: " + section.position);
				eventList.push(getSection(sectionIndex, section.title));
				
				eventViews = [];
				for (eventIndex = 0; eventIndex < events.length; eventIndex++) {
					event = events[eventIndex];
					Ti.API.info("Event added, id: " + event.id);

					if (section.position == 0) {
						eventView = Alloy.createController('currenteventview', {item: event}).getView();
					} else {
						eventView = Alloy.createController('pasteventview', {item: event}).getView();
					}
					eventList[sectionIndex].add(eventView);
				}
			}

			$.eventList.setData(eventList);
		}
	} catch(ex) {
		Ti.API.error("buildEventView " + JSON.stringify(ex));
	}
}

function getSection(index, title) {
	var sectionId = ['section', index].join('_');

	section = Ti.UI.createTableViewSection({
		id: sectionId,
		headerTitle: ""
	});
	
	if (title) {
		section.headerView = Ti.UI.createView({
			backgroundColor: "#eaeaea",
			height: "30dp"
		});
		section.headerView.add(Ti.UI.createLabel({
			font: {fontSize: '20'},
			color: "#8B8B8B",
			text: title
		})); 
	}
	
	return section;
}

function getEvents() {
   	try {
		if (Titanium.Network.online == false) {
			alert("Your device is not online. Please check connectivity.");
			return;
		} 
		var httpparams = 'token=' + Titanium.App.Properties.getString('hypytoken', Alloy.Globals.defaultToken);
		Alloy.Globals.loading.show('', false);
	 	var httpClient = require("HttpConnection");
	 	httpClient.callAPIGet("events", httpparams, selfObj.doEventCallback);
	} catch(ex) {
		Ti.API.error("getEvents " + JSON.stringify(ex));
	}	
}

this.doEventCallback = function(data) {
	try {
		Alloy.Globals.loading.hide();
		var response = JSON.parse(data);
		Ti.API.info("doEventCallback response called" + data);
		Titanium.App.Properties.setObject('events',response);
		buildEventView();
		
		if(stoppullrefreshCallback != undefined){
			stoppullrefreshCallback();
			stoppullrefreshCallback = undefined;
		}
	} catch(ex) {
		Ti.API.error("doEventCallback " + JSON.stringify(ex));
	}
};