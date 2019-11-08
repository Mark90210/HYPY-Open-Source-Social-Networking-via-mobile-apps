var args = arguments[0] || {},
	selfObj = this,
	item = args.item,
	gallery = {},
	token = "",
	currentEvent="",
	selectedItem;

$.header.headertitleWin.text = item.name;
var stoppullrefreshCallback;
var since_id=0;

setTimeout(function() {
	Alloy.Globals.loading.show('', false);
	getEventGallery(false);
}, 150);

function myRefresher(e){
	stoppullrefreshCallback =e.hide;
	getEventGallery(true);
}
var CommentModal = function() {
	this.init = function() {
		this.input.element.addEventListener("focus", this.input.clearValue);
		return this;
	}.bind(this);

	this.input = {
		placeholder: 'Enter comment',
		element: $.commentInput,
		getValue: function() {
			return this.input.element.value;
		}.bind(this),
		setValue: function(value) {
			this.input.element.value = value;
		}.bind(this),
		clearValue: function() {
			this.input.setValue('');
		}.bind(this),
		resetValue: function() {
			this.input.setValue(this.input.placeholder);
		}.bind(this),
		blank: function() {
			var value = this.input.getValue(),
				placeholder = this.input.placeholder;

			if (value == '' || value == placeholder) {
				return true;
			} else {
				return false;
			}
		}.bind(this)
	};

	this.setItem = function(item) {
		$.commentBtn.selectedItem = item;
		return this;
	}.bind(this);
	this.getItem = function() {
		return $.commentBtn.selectedItem;
	}.bind(this);

	this.show = function() {
	    $.commentView.visible = true;
	    return this;
	}.bind(this);
	this.hide = function() {
	    $.commentView.visible = false;
	    return this;
	}.bind(this);
	this.close = function() {
		this.input.clearValue();
		this.hide();
	    return this;
	}.bind(this);
};
var commentModal = new CommentModal();
commentModal.init();

function buildEventGalleryView(photos) {
	try {
		Ti.API.info("photos.length: " + photos.length);
		$.allphotos.setData([]);
		var photosViewsArr = [],
			photo, photoView, i;

		if (gallery != undefined && photos.length > 0) {
			for (i = 0; i < photos.length; i++) {
				photo = photos[i];
				photoView = Alloy.createController('eventphotoview', {item: photo}).getView();
				photoView.item = photo;
				photosViewsArr.push(photoView);
				Ti.API.info("Photo, id: " + photo.id);
				if(i==0) since_id = photo.id;
			}
			if (gallery.photos.length > 0 || photos.length > 0) {
				Ti.API.info("set photos");
				$.allphotos.setData(photosViewsArr);
				$.noPhotoMessage.hide();
				$.noPhotoMessage.height = 0;
				$.noPhotoMessage.top = 0;
				$.allphotos.visible = true;
				$.allphotos.height = Ti.UI.FILL;
			}
			Ti.API.info("since_id  " + since_id);
		} else {
			Ti.API.info("else");
			$.allphotos.hide();
			$.allphotos.height = 0;
			$.noPhotoMessage.top = "150dp";
		}
		$.photoListContainer.show();
		$.photoListContainer.height = Ti.UI.FILL;
		$.photoListContainer.contentHeight = Ti.UI.SIZE;
		
	} catch (exception) {
		Ti.API.error("buildEventGalleryView error:" + JSON.stringify(exception));
	}
}
function addNewEventGalleryView(photos) {
	try {
		var photosViewsArr = [],
			photo, photoView, i;

		if (gallery != undefined && photos.length > 0) {
			var size = photos.length-1;
			for (i = size; i>=0 ; i--) {
				photo = photos[i];
				photoView = Alloy.createController('eventphotoview', {item: photo}).getView();
				photoView.item = photo;
				photosViewsArr.push(photoView);
				$.allphotos.insertRowBefore(0,photoView);
				Ti.API.info("Photo, id: " + photo.id);
				if(i==0) since_id = photo.id;
			}
			
			
		} 
	} catch (exception) {
		Ti.API.error("addNewEventGalleryView error:" + JSON.stringify(exception));
	}
}
function updatePhotoRow(photoItem) {
	try {
		Ti.API.info("updatePhotoRow photoItem: " + JSON.stringify(photoItem));

		var section = $.allphotos.data[0], // grab the array of sections, use just the first section
			photoView;

		for (var i = 0; i < section.rowCount; i++) {
			Ti.API.info("record   " + section.rows[i].item.id);
			if (section.rows[i].item.id == photoItem.id){
				Ti.API.info("Row found, row index: " + i);
				//i = section.rowCount; // break out of the loop

				try {
					photoView = Alloy.createController('eventphotoview', {item: photoItem}).getView();
					photoView.item = photoItem;
	
					$.allphotos.updateRow(i, photoView);
					break;
				} catch(exception) {
					Ti.API.error("Row update failed, exception: " + exception);
				}
			}
		}
	} catch(exception) {
		Ti.API.error("error updating model " + exception);
	}	
}

function getEventGallery(getNewOnly) {
   	try {
		if (Titanium.Network.online == false) {
			alert("Your device is not online. Please check connectivity.");
			return;
		} 

	 	var url = "galleries/" + item.id,
	 		token = Titanium.App.Properties.getString('hypytoken', Alloy.Globals.defaultToken),
			params = ['token', token].join('='),
			callback;
			
			if(getNewOnly){
				url = "galleries/" + item.id + "/photos";
				params = 'token=' + token +"&since_id=" + since_id;
				callback = selfObj.cb_getEventGalleryOnlyNew;
			}else{
				callback = selfObj.cb_getEventGalleryAll;
			}
	 	require("HttpConnection").get(url, params, callback);
	} catch(exception) {
		Ti.API.error("getEventGallery error, exception: " + JSON.stringify(exception));
	}	
}
this.cb_getEventGalleryAll = function(data) {
	cb_getEventGallery(data,false);
};	
this.cb_getEventGalleryOnlyNew = function(data) {	
	cb_getEventGallery(data,true);
	if(stoppullrefreshCallback != undefined){
		stoppullrefreshCallback();
		stoppullrefreshCallback = undefined;
	}
};

function cb_getEventGallery(data,getNewOnly) {
	try {
		Alloy.Globals.loading.hide();
		var response = JSON.parse(data);
		Ti.API.info(getNewOnly + "doEventCallback response called" + data);
		if(getNewOnly == true){
			gallery.photos = response;
			addNewEventGalleryView(gallery.photos);
		}else{
			gallery = response;
			buildEventGalleryView(gallery.photos);
		}
	} catch(exception) {
		Ti.API.error("doEventGalleryCallback " + JSON.stringify(exception));
	}
};


function getRegInput() {
	var usertoken = Titanium.App.Properties.getString('hypytoken');

	if (usertoken != undefined && usertoken != Alloy.Globals.defaultToken) {
		$.reginput.visible = false;
		showInputSelector();
	} else {
		currentEvent="addPhoto";
		showRegistrationConfirm();	
	}
}
function showRegistrationConfirm() {
	$.reginput.visible = true;

	switch ($.regBtn.title) {
		case 'Next':
			$.regFld.height = 40;
			$.regFld.bottom = 20;

			$.confirmcode.height = 0;
			$.confirmcode.bottom = 0;
			
			$.regFld.value = "";
			$.regmsg.text = "To post a photo, please create an account by entering your mobile number";
			break;		
		case 'Sign Up':
			$.confirmcode.height = 40;
			$.confirmcode.bottom = 20;

			$.regFld.bottom = 0;
			$.regFld.height = 0;

			$.confirmcode.value = "";
			$.regmsg.text = "Thanks! We've sent you a confirmation code via text. Enter it below.";
			break;
	}
}
function submitNumber(){
	if ($.regBtn.title == "Next") {

		if ($.regFld.value == "") {
			alert("Please enter your phone number");
			return;
		}
		
		if (Titanium.Network.online == false){
			alert("Your device is not online. Please check connectivity.");
			return;
		} 

		$.regFld.blur();
		var onlyno = $.regFld.value.replace(/\D/g,''),
			url = "users/me",
			params =	{
			    'phone': onlyno
			},
			callback = function(data) {
				Alloy.Globals.loading.hide();
		 		try {
		 			Ti.API.info("create user account at users/me, response: " + data);

					var response = JSON.parse(data);

					if (!response.success) {
						alert("Unable to register now. Please try later");
						return;
					}

					token = response.token;
					$.regBtn.title ="Sign Up";
					showRegistrationConfirm();
				} catch(ex) {
					Ti.API.error("doEventCallback " + JSON.stringify(ex));
				}
		 	};

		Alloy.Globals.loading.show('', false);
	 	require("HttpConnection").post(url, params, callback);
	} else if($.regBtn.title =="Sign Up") {
		if ($.confirmcode.value == ""){
			alert("Please enter confirmation code.");
			return;
		}

		if (Titanium.Network.online == false){
			alert("Your device is not online. Please check connectivity.");
			return;
		}

		$.confirmcode.blur();
		var usertoken = token;
		Ti.API.error('save usertoken 1 ' + usertoken);
		var onlyno = $.confirmcode.value.replace(/\D/g,''),
			url = "users/me/confirmation",
			params = {
				'token': token,
				'verification_code': onlyno
			},
			callback = function(data) {
	 			Alloy.Globals.loading.hide();
	 			Ti.API.info("users/me/confirmation" + data);
				Ti.API.error('save usertoken 2 ' + usertoken);
		 		try {
					var response = JSON.parse(data);
				} catch (exception) {
					Ti.API.error('Failed to parse JSON response, exception: ' + exception);
				}

				if (!response.success) {
					alert("Confirmation code do not match");
				}else{
					
					Ti.API.error('save token ' + usertoken);
					Titanium.App.Properties.setString('hypytoken', usertoken);
					Ti.API.error('get token ' + Titanium.App.Properties.getString('hypytoken'));	
					getEventGallery(false);
					var url = "users/me",
						token = Titanium.App.Properties.getString('hypytoken'),
						params = ['token', usertoken].join('='),
						callback = function(data) {
					 		try{
					 			Ti.API.info("/users/me" + data);
								
								var response = JSON.parse(data);
							
								$.regBtn.title = "Next";
								$.reginput.visible=false;
								Titanium.App.Properties.setObject('userprofile', response);
	
								alert("Successfully registered");
								
								switch(currentEvent){
									case "addPhoto":
										showInputSelector();
										break;
									case "addLike":
										addLike();
										break;
									case "showComment":
										showComment();
										break;
									case "addFlag":
										addFlag();
										break;	
								}
									
							}catch(ex){
								Ti.API.error("doEventCallback " + JSON.stringify(ex));
							}
						};
	
					require("HttpConnection").get(url, params, callback);
				}	
		 	};

		Alloy.Globals.loading.show('', false);
	 	require("HttpConnection").post(url, params, callback);
	}
}
  
function closeRegistrationModal() {
	Ti.API.info("closeRegistrationModal");
    $.reginput.visible = false;
    $.regBtn.title = "Next";
    currentEvent="";
}

function showInputSelector(){
	currentEvent="";
	var option = option = ['Create Photo', 'Browse Photo', 'Cancel'];
	
	var opts = {
	  options: option,
	  destructive: 0
	};
	var dialog = Ti.UI.createOptionDialog(opts);
	dialog.show();
	
	dialog.addEventListener('click',function(e){
		Ti.API.info(JSON.stringify(e));
	    if(e.index  == 0){
	    	openCamera();	
	    }else if(e.index == 1){
	    	 openGallery();
	    }
	});
	
};
function openCamera() {
	if(OS_ANDROID){
		var hasCameraPermissions = Ti.Media.hasCameraPermissions();
	
		if (!hasCameraPermissions) {
				Ti.Media.requestCameraPermissions(function(e) {
				//log.args('Ti.Media.requestCameraPermissions', e);
		
				if (e.success) {
					openCamera();
					// Instead, probably call the same method you call if hasCameraPermissions() is true
					//alert('You granted permission.');
		
				} else if (OS_ANDROID) {
					//alert('You don\'t have the required uses-permissions in tiapp.xml or you denied permission for now, forever or the dialog did not show at all because you denied forever before.');
		
				} else {
		
					// We already check AUTHORIZATION_DENIED earlier so we can be sure it was denied now and not before
					//alert('You denied permission.');
				}
			});
		}	
	}	
	Titanium.Media.showCamera({
		mediaTypes: [Titanium.Media.MEDIA_TYPE_PHOTO],
		success:pickMediafunction,
		saveToPhotoGallery:true,
		cancel:function()
		{	
			Ti.API.info("Cancelled");
		},
		error:errorCaptureCamerafunction
	});

	
}

function errorCaptureCamerafunction(error)
{	
	try{
		// create alert
		var a = Titanium.UI.createAlertDialog({title:'Camera'});

		// set message
		if (error.code == Titanium.Media.NO_CAMERA)
		{
			a.setMessage('Please run this test on device');
		}
		else
		{
			a.setMessage('Unexpected error: ' + error.code);
		}

		// show alert
		a.show();
	}catch(e){
		Ti.API.error("openCamera (error) " +e);
	}	
}
function openGallery() {
	
	var mediaType; var photoOptions;

	mediaType = [Titanium.Media.MEDIA_TYPE_PHOTO];
	Titanium.Media.openPhotoGallery({	
		mediaTypes:mediaType,
		success:pickMediafunction,
		cancel:function()
		{
				
		},
		error:function(error)
		{
			
		}
	});	
}
function pickMediafunction(event)
{	
	try{
		Ti.API.info(event.mediaType + "  event.mediaType  ");

		Ti.API.info(" width " + event.media.width + " height " + event.media.height);
		var image = event.media; 

		if(event.media.width>800 || event.media.height>800){
			Ti.API.info(" width or height > 800"); 
			image = event.media.imageAsResized(800, 800);
		}
		
		addPhoto(image);
	}catch(e){
		Ti.API.error("pickMediafunction " +e);
	}
}


function addPhoto(imageToUpload)
{
   	try{

		if(Titanium.Network.online == false){
			alert("Your device is not online. Please check connectivity.");
			return;
		} 
		
		var compression_level = 0.75; 
	  	var ImageFactory = require('ti.imagefactory');
	  	resizedImage = ImageFactory.compress( imageToUpload, compression_level );   
		
		var httpparams = {
			'token' : Titanium.App.Properties.getString('hypytoken'),
			'description': "",
			'photo':resizedImage
		};
		Alloy.Globals.loading.show("",true);
	 	var httpClient = require("HttpConnection");
	 	httpClient.callAPIPost("galleries/" + item.id + "/photos",httpparams,selfObj.doAddPhotoCallback);
		 
	}catch(ex){
		Ti.API.error("addPhoto " + JSON.stringify(ex));
	}	
}


this.doAddPhotoCallback = function(data){
	try{
		
		Alloy.Globals.loading.hide();
		var response = JSON.parse(data);
		Ti.API.info("doAddPhotoCallback response called" + data);
		Ti.API.info("gallery " + JSON.stringify(gallery));
		//gallery = response;
		gallery.photos.push(response);
		//buildEventGalleryView();
		Ti.API.info("gallery after push" + JSON.stringify(gallery));
		var photoview = Alloy.createController('eventphotoview',{item:response}).getView();
		photoview.item = response;
		
		Ti.API.info("gallery.photos.length " + gallery.photos.length);
		if(gallery.photos.length>1)
			$.allphotos.insertRowBefore(0,photoview);
		else
			$.allphotos.appendRow(photoview);
		
		$.noPhotoMessage.hide();
		$.noPhotoMessage.height = 0;
		$.allphotos.visible = true;
		$.allphotos.height = Ti.UI.FILL;
		
	}catch(ex){
		Ti.API.error("doAddPhotoCallback " + JSON.stringify(ex));
	}
};

$.allphotos.addEventListener('click', function(e) {
	Ti.API.info("Allphotos click, event: " + JSON.stringify(e));

	try {
		

		if (OS_ANDROID) {
			selectedItem =  e.row.item;
		} else if(OS_IOS) {
			selectedItem =  e.rowData.item;
		}

		Ti.API.info("photo clicked: " + JSON.stringify(selectedItem));
		Ti.API.info("click source id: " + e.source.id);

		if (e.source.id == "likeview") {
			addLike(selectedItem);
		} else if (e.source.id == "viewcomment") {
			var usertoken = Titanium.App.Properties.getString('hypytoken');
			currentEvent="showComment";
			if (usertoken == undefined || usertoken == null || usertoken == Alloy.Globals.defaultToken) {
				showRegistrationConfirm();	
				return;
			}else{
				commentModal.setItem(selectedItem).show();
			}
			
		} else if (e.source.id == "flagphotoview") {
			addFlag(selectedItem);
		}
	} catch(exception) {
		Ti.API.error("Error in click handler, exception: "+ JSON.stringify(exception));
	}
});	
function showComment(){
	commentModal.setItem(selectedItem).show();
}
function addLike(selectedItem) {
   	try {
   		currentEvent="addLike";
   		var usertoken = Titanium.App.Properties.getString('hypytoken');

		if (usertoken == undefined || usertoken == null || usertoken == Alloy.Globals.defaultToken) {
			showRegistrationConfirm();	
			return;
		}
		
		if (Titanium.Network.online == false){
			alert("Your device is not online. Please check connectivity.");
			return;
		} 
		
		Alloy.Globals.loading.show("",true);

		var url = "photos/" + selectedItem.id + "/likes",
			params = {
				'token' : Titanium.App.Properties.getString('hypytoken')
			},
		 	callback = function(response){
		 		try {
		 			Ti.API.info("callback addlike");
					Alloy.Globals.loading.hide();
	
					var response = JSON.parse(response);				
					selectedItem.user_has_liked = true;
					updatePhotoRow(selectedItem);
				} catch(ex) {
					Ti.API.error("addLike response " + JSON.stringify(ex));
				}
		 	};

	 	require("HttpConnection").post(url, params, callback);
	} catch(exception) {
		Ti.API.error("Add Like error, exception: " + JSON.stringify(exception));
	}
}

function submitComment(){
	try {
		currentEvent="submitComment";
		var selectedItem = commentModal.getItem();
		
		if (commentModal.input.blank()) {
			alert("Please enter comment");
			return;
		}
		
		if (Titanium.Network.online == false) {
			alert("Your device is not online. Please check connectivity.");
			return;
		} 
		
		Alloy.Globals.loading.show("", true);

		var url = "galleries/"+ item.id+ "/photos/"+ selectedItem.id + "/comments",
			params = {
				'token': Titanium.App.Properties.getString('hypytoken'),
				'text': commentModal.input.getValue()
			},
			callback = function(response) {
		 		try {
					Alloy.Globals.loading.hide();
	
					var response = JSON.parse(response);
					commentModal.input.resetValue();
					commentModal.hide();
	
					alert("Thank you! Commented saved.");
				} catch(exception) {
					Ti.API.error("Comment save error, exception: " + JSON.stringify(exception));
				}
		 	};

	 	require("HttpConnection").post(url, params, callback);
	} catch(exception) {
		Ti.API.error("Submit comment error, exception:" + JSON.stringify(exception));
	}
}

function addFlag(selectedItem) {
   	try {
   		currentEvent="addFlag";
   		var usertoken = Titanium.App.Properties.getString('hypytoken');

		if (usertoken == undefined || usertoken == null || usertoken == Alloy.Globals.defaultToken) {
			showRegistrationConfirm();	
			return;
		}
		
		if (Titanium.Network.online == false){
			alert("Your device is not online. Please check connectivity.");
			return;
		} 
		
		Alloy.Globals.loading.show("",true);

		var url = "photos/" + selectedItem.id + "/flag",
			params = {
				'token' : Titanium.App.Properties.getString('hypytoken')
			},
		 	callback = function(response){
		 		try {
					Alloy.Globals.loading.hide();
	
					var response = JSON.parse(response);				
					selectedItem.flagged = true;
					updatePhotoRow(selectedItem);
				} catch(ex) {
					Ti.API.error("addLike response " + JSON.stringify(ex));
				}
		 	};

	 	require("HttpConnection").post(url, params, callback);
	} catch(exception) {
		Ti.API.error("Add flag error, exception: " + exception.toString());
	}
}
