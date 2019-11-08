var ctrl;

function show(_message, _cancelable) {

    if (ctrl && ctrl.hasFocus) {
        ctrl.update(_message, _cancelable);
        return;
    }

    var newCtrl = Widget.createController((OS_ANDROID && $.progress) ? 'window' : 'window');
	//var newCtrl = Widget.createController('window');
    newCtrl.show(_message, _cancelable);

    if (ctrl) {
        hide();
    }

    ctrl = newCtrl;
}

function hide() {

    if (ctrl) {
        ctrl.hide();
        ctrl = null;
    }

    return;
}

function pbprogress(val){
	//alert("W");
	 if (ctrl) {
	 	Ti.API.info("pbprogress 1");
        ctrl.pbprogress(val);
    }else{
    	Ti.API.info("pbprogress 2");
    	var newCtrl = Widget.createController((OS_ANDROID && $.progress) ? 'window' : 'window');
    	ctrl=newCtrl;
    	ctrl.pbprogress(val);
    }
}
Object.defineProperty($, 'visible', {
    get: function() {
        return (ctrl && ctrl.hasFocus);
    },
    set: function(visible) {
        return visible ? show() : hide();
    }
});

$.show = show;
$.hide = hide;
$.pbprogress = pbprogress;
$.progress = true;