var useImages = false,
    cancelable = null;

$.show = show;
$.hide = hide;
$.update = update;
$.cancel = cancel;
$.pbprogress = pbprogress;

Object.defineProperty($, 'visible', {
    get: function() {
        return $.loadingMask.visible;
    },
    set: function(visible) {
        return visible ? show() : hide();
    }
});

(function constructor(args) {
	//if ($.loadingImages.images) {
    if (false) {
        useImages = true;

        $.loadingInner.remove($.loadingIndicator);
        $.loadingIndicator = null;

    } else {
        $.loadingInner.remove($.loadingImages);
        $.loadingImages = null;
    }

    args = null;

})(arguments[0] || {});

function update(_message, _cancelable) {
    $.loadingMessage.text = "";//_message || L('loadingMessage', 'Loading...');
    cancelable = _cancelable;
}

function cancel() {
	try{
	Ti.API.info("cancel called " + cancelable);
    //if (_.isFunction(cancelable)) {
    	Ti.API.info("inside if");
       // cancelable();

        $.trigger('cancel');

        hide();
   // }
   }catch(ex){
   		Ti.API.error("cancel " + JSON.stringify(ex));
   }
}


function show(_message, _cancelable) {
    update(_message, _cancelable);
	$.pbHolder.visible=false;
    $.loadingMask.show();

    if (useImages) {
        $.loadingImages.start();
    } else {
        $.loadingIndicator.show();
    }
}
function pbprogress(val) {
	
	$.pbHolder.visible=true;
	$.pb.value=val;
	
	if ($.pb.value < $.pb.max) {
		$.uploadpercentage.text = 'Uploading '+ parseInt($.pb.value*100) + '% complete';
	}else{
		$.pb.value=0;
    	hide();
	}
}
function hide() {
    $.loadingMask.hide();
    $.pbHolder.visible=false;
}