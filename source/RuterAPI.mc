using Toybox.Application as App;
using Toybox.Communications as Com;

class RuterAPI
{
	// Returns the stops for given line
	function fetchLineStops(lineId) 
	{
	  	var url = "https://reisapi.ruter.no/Line/GetStopsByLineId/" + lineId;
	  	var options =
	  	{
	  		:method => Com.HTTP_REQUEST_METHOD_GET,      // set HTTP method
	   		:headers => {"Content-Type" => Com.HTTP_RESPONSE_CONTENT_TYPE_JSON},
	    	:responseType => Com.HTTP_RESPONSE_CONTENT_TYPE_JSON
	  	};
	
		var responseCallback = method(:callbackPrint);                  
	    Com.makeWebRequest(url, {}, options, responseCallback);
	}
	
	// Fetches the closest stop
	function fetchClosestStop()
	{
		var url = "https://reisapi.ruter.no/Place/GetClosestStops?coordinates=(x=593909,y=6641591)";
	  	var options =
	  	{
	  		:method => Com.HTTP_REQUEST_METHOD_GET,
	   		:headers => {"Content-Type" => Com.HTTP_RESPONSE_CONTENT_TYPE_JSON},
	    	:responseType => Com.HTTP_RESPONSE_CONTENT_TYPE_JSON
	  	};
	
		var responseCallback = method(:callbackPrint);                  
	    Com.makeWebRequest(url, {}, options, responseCallback);
	}
	
	function callbackPrint(responseCode, data)
	{
			System.println(responseCode + " : " + data[0]);
	}
}