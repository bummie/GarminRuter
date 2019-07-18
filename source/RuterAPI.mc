using Toybox.Application as App;
using Toybox.Communications as Com;
using Toybox.Math;
using Toybox.WatchUi as Ui;

class RuterAPI
{
	private static var api = null;
	private var URL = "https://api.entur.io/journey-planner/v2/graphql";	
	private var _closestStopIDs = [];
	private var _closestStops = {};
	private var _stopData;
	private var _lastLocation;
	public var _hasLoaded = false;
	private var _pageIndex = 0;
	private var _pageLimit = 10;

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
	function FetchClosestStops(location) 
	{		  	
		_hasLoaded = false;
		_lastLocation = location;
		System.println("Fetching closest stops.");
	    Com.makeWebRequest(URL, RequestClosestStops(location["latitude"], location["longitude"]), options, method(:CallbackClosestStops));
	}

	function CallbackClosestStops(responseCode, data)
	{
		if(!ValidData(responseCode, data)) { System.println("Retrying.."); FetchClosestStops(_lastLocation); return; }
		
		var nodes = data["data"]["nearest"]["edges"]; //TODO:: Check if nodes has size greater than 0	
		_closestStopIDs = new [nodes.size()];

		for(var i = 0; i < nodes.size(); i++)
		{
			_closestStopIDs[i] = nodes[i]["node"]["place"]["id"];
			System.println(i + ": " + _closestStopIDs[i]);
		}

		FetchStopNames(_closestStopIDs);
		//System.println("Stopnames: " + RequestStopNames(_closestStopIDs));
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
		
		_stopData = ParseStopData(data);
		_hasLoaded = true;
	}

	private function ParseStopData(stopData)
	{
		var stops = stopData["data"]["stopPlace"]["estimatedCalls"];
		var sortedStops = {};

		for(var i = 0; i < stops.size(); i++)
		{
			var name = stops[i]["destinationDisplay"]["frontText"];
			var time = stops[i]["expectedArrivalTime"];

			if(!sortedStops.hasKey(name)) { sortedStops.put(name, []); }
			sortedStops[name].add(time);
		}

		System.println(sortedStops);
		return sortedStops;
	}

	function FetchStopNames(stopIDs)
	{
		if(stopIDs.size() <= 0) { System.println("StopIDs cannot be empty."); return; }
	
		System.println("Fetching stop names.");
	    Com.makeWebRequest(URL, RequestStopNames(stopIDs), options, method(:CallbackStopNames));
	}

	function CallbackStopNames(responseCode, data)
	{
		if(!ValidData(responseCode, data)) { System.println("Retrying.."); FetchStopNames(_closestStopIDs); return; }
		
		var nodes = data["data"]["stopPlaces"]; //TODO:: Check if nodes has size greater than 0	
		
		_closestStops = new [nodes.size()];

		for(var i = 0; i < nodes.size(); i++)
		{
			_closestStops[i] = {"id" => nodes[i]["id"], "name" => nodes[i]["name"]};
		}

		System.println(_closestStops);
		OpenStopSelectionMenu();
	}

	private function OpenStopSelectionMenu()
	{
		var menu = new MenuView();
        menu.OpenMenu(_closestStops);
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

	private function RequestClosestStops(latitude, longitude)
	{
		var jsonRequest = "{nearest(latitude:" + latitude + ",longitude:" + longitude + ",maximumDistance:300,filterByPlaceTypes:stopPlace,filterByModes:bus){edges{node{place{id}}}}}";
		return CreateRequest(jsonRequest);
	}

	private function RequestStopData(stopID)
	{
		var jsonRequest = "{stopPlace(id:\\\""+ stopID + "\\\"){name,estimatedCalls{expectedArrivalTime,destinationDisplay{frontText}}}}";
		return CreateRequest(jsonRequest);
	}

	private function RequestStopNames(stopIDs)
	{
		if(stopIDs.size() <= 0) { System.println("StopIDs are empty."); return; }

		var formattedStopIDs = "";

		for(var i = 0; i < stopIDs.size(); i++)
		{
			formattedStopIDs += "\\\""+ stopIDs[i] + "\\\"";
			if(i < stopIDs.size()-1) { formattedStopIDs += ","; }
		}

		var jsonRequest = "{stopPlaces(ids:[" + formattedStopIDs + "]){id,name}}";
		return CreateRequest(jsonRequest);
	}

	private function CreateRequest(request)
	{
		return { "query" => request};
	}

	function HasLoaded()
	{
		return _hasLoaded;
	}

	function SelectStop(stopId)
	{
		FetchStopData(stopId);
	}

	function GetStopData()
	{
		return _stopData;
	}

	function SetPageLimit(limit)
	{
		_pageLimit = limit;
	}

	function FlipPage(direction)
	{
		if(direction == 0)
		{
			if(_pageIndex < (_pageLimit-1)) { _pageIndex++; }
		}else
		{
			if(_pageIndex > 0) { _pageIndex--; }
		}
	}

	function GetPage()
	{
		return _pageIndex;
	}
}