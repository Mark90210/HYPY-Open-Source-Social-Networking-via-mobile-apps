var HttpConnection = {
	callAPIGet: function(apiname, params, callback){
	 	try{
		 	var httpClient = createHTTClient(callback);
		 	var apiurl = Alloy.CFG.apiurl + apiname + "?" + params;
		 
		 	Ti.API.info(apiname +' URL ' + apiurl);
		 	Ti.API.info('params ' + JSON.stringify(params));
		 	
		 	httpClient.open("GET",apiurl);
		 	httpClient.send();
		}catch(ex){
			Ti.API.error("callAPIGet " + JSON.stringify(ex));
		}	
	},
	callAPIPost: function(apiname,params,callback){
	 	try{
		 	var httpClient = createHTTClient(callback);
		 	var apiurl = Alloy.CFG.apiurl + apiname ;
		 
		 	Ti.API.info(apiname +' URL ' + apiurl);
		 	Ti.API.info('params ' + JSON.stringify(params));
		 	
		 	httpClient.open("POST",apiurl);
		 	httpClient.send(params);
		}catch(ex){
			Ti.API.error("callAPIPost " + JSON.stringify(ex));
		}
	},
	callAPIPut: function(apiname,params,callback){
	 	try{
		 	var httpClient = createHTTClient(callback);
		 	var apiurl = Alloy.CFG.apiurl + apiname ;
		 
		 	Ti.API.info(apiname +' URL ' + apiurl);
		 	Ti.API.info('params ' + JSON.stringify(params));
		 	
		 	httpClient.open("PUT",apiurl);
		 	httpClient.send(params);
		}catch(ex){
			Ti.API.error("callAPIPost " + JSON.stringify(ex));
		}	
	}
};
HttpConnection.get = HttpConnection.callAPIGet;
HttpConnection.post = HttpConnection.callAPIPost;
HttpConnection.put = HttpConnection.callAPIPut;

function createHTTClient(cb_success, cb_progress){	
	var onsuccess = cb_success || function() {},
		onsendstream = cb_progress || function() {},
		onload = function(e) {
			Ti.API.info('onload ' +JSON.stringify(e));
			var responsedata = httpClient.responseText;
			Ti.API.info('responsedata ' + responsedata);
			onsuccess(responsedata);
		},
		onerror = function(e) {
			var result = new Object();
			result.success = false;
			
			try {
				result.message = e.error;
				result.errorType = e.code;
				Ti.API.info('onerror ' +JSON.stringify(e));
			} catch(ex) {
				Ti.API.error("onerror " + ex);	
			} finally {
				onsuccess(JSON.stringify(result));
			}
		},
		httpClient = Titanium.Network.createHTTPClient({
			onload : onload, // function called when the response data is available
			onerror : onerror, // function called when an error occurs, including a timeout
			onsendstream: onsendstream,
			timeout: 30 * 1000
		});

	return httpClient;
}

module.exports = HttpConnection;