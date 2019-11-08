var args = arguments[0] || {};

function findevents(){
   Alloy.Globals.CurrentWindow=Alloy.createController('home').getView();
   Alloy.Globals.CurrentWindow.open();
   $.locationrequest.close();
}
