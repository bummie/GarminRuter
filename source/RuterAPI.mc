using Toybox.Application as App;
using Toybox.Communications as Com;
using Toybox.Math;
using Toybox.WatchUi as Ui;

class RuterAPI
{
	private static var api = null;
	private var URL = "https://api.entur.io/journey-planner/v2/graphql";	
	private var _closestStops = [];

	private var options =	
	{
		:method => Com.HTTP_REQUEST_METHOD_POST,
		:headers => {"Content-Type" => Com.REQUEST_CONTENT_TYPE_JSON},
		:responseType => Com.HTTP_RESPONSE_CONTENT_TYPE_JSON
	};
	
	static function GetReference()
	{
		if(api == null) { api = new RuterAPI(); }
		return api;
	}
	
	// Returns the closest stops for a given position
	function FetchClosestStops(latitude, longitude) 
	{		  	
		System.println("Fetching closest stops.");
	    Com.makeWebRequest(URL, RequestClosestStops(latitude, longitude), options, method(:CallbackClosestStops));
	}

	function CallbackClosestStops(responseCode, data)
	{
		if(!ValidData(responseCode, data)) { return; }
		
		var nodes = data["data"]["nearest"]["edges"]; //TODO:: Check if nodes has size greater than 0	
		_closestStops = new[nodes.size()];
		
		for(var i = 0; i < nodes.size(); i++)
		{
			_closestStops[i] = nodes[i]["node"]["place"]["id"];
			System.println(i + ": " + _closestStops[i]);
		}

		FetchStopData(_closestStops[0]);
	}
	
	function FetchStopData(stopID)
	{
		if(stopID == "") { System.println("StopID cannot be empty."); return; }
	
		System.println("Fetching stop data: " + stopID);
	    Com.makeWebRequest(URL, RequestStopData(stopID), options, method(:CallbackStopData));
	}

	function CallbackStopData(responseCode, data)
	{
		if(!ValidData(responseCode, data)) { return; }
		
		System.println(data);
	}
	
	private function ValidData(responseCode, data)
	{
		if(responseCode != 200) { System.println( responseCode +  " : Could not retrieve data."); return false; }
		if(data == null || data.size() <= 0) { System.println("Data received is empty."); return false;}
		return true;
	}

	function CallbackPrint(responseCode, data)
	{
		if(!ValidData(responseCode, data)) { return; }
		
		System.println( responseCode + ": Data received: " + data);
	}

	private function CreateRequest(request)
	{
		return { "query" => request};
	}

	private function RequestClosestStops(latitude, longitude)
	{
		var jsonRequest = "{nearest(latitude:" + latitude + ", longitude:" + longitude + ", filterByPlaceTypes: stopPlace){edges{node{place{id}}}}}";
		return CreateRequest(jsonRequest);
	}

	private function RequestStopData(stopID)
	{
		var jsonRequest = "{stopPlace(id:\""+ stopID + "\"){name,estimatedCalls{expectedArrivalTime,destinationDisplay{frontText}}}}";
		System.println(jsonRequest);
		return CreateRequest(jsonRequest);
	}
}