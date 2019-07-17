using Toybox.Application as App;
using Toybox.Communications as Com;
using Toybox.Math;
using Toybox.WatchUi as Ui;

class RuterAPI
{
	private static var api = null;
	private var BASE_URL = "https://reisapi.ruter.no/";
	public var stopName = "";
	private var stopId = "";
	public var stopDataString = "";
	
	hidden var options =
	{
		:method => Com.HTTP_REQUEST_METHOD_GET,
		:headers => {"Content-Type" => Com.HTTP_RESPONSE_CONTENT_TYPE_JSON},
		:responseType => Com.HTTP_RESPONSE_CONTENT_TYPE_JSON
	};
	
	static function GetReference()
	{
		if(api == null) { api = new RuterAPI(); }
		return api;
	}
	
	// Returns the stops for given line
	function FetchStopData(stopid) 
	{
	  	var url = "https://bevster.net/GarminRuter/?id=" + stopid;
	  	System.println(url);
		var responseCallback = method(:CallbackPrint);   
		               
	    Com.makeWebRequest(url, {}, options, responseCallback);
	}
	
	// Fetches the closest stop by position
	function FetchClosestStop(lat, lon)
	{
		var utm = DegToUTM(lat, lon);
		var url = BASE_URL + "Place/GetClosestStops?coordinates=(x=" + utm["east"] + ",y=" + utm["north"] + ")";
		var responseCallback = method(:CallbackClosestStop);       
		           
	    Com.makeWebRequest(url, {}, options, responseCallback);
	}
	
	// Gets the response about closest stop and retrieves data from given stop
	function CallbackClosestStop(response, data)
	{
		if(response == 200)
		{
			if(data != null && data.size() > 0)
			{
				stopName = data[0]["Name"];
				stopId = data[0]["ID"];
				System.println("Stoppested: " + stopName + " ID: "  + stopId);
				FetchStopData(stopId);
			}
		}
		else
		{
			System.println("Something went wrong!");
		}
	}
	
	function CallbackPrint(responseCode, data)
	{
		if(responseCode != 200) { System.println( responseCode +  " :Something went wrong!"); }
		
		if(data != null && data.size() > 0)
		{
			for(var i = 0; i < data.size(); i++)
			{
				System.println(responseCode + " : " + data[i]["name"] + " - " + data[i]["line"] + " - " + data[i]["arrival"]);
				stopDataString = stopDataString + data[i]["name"] + "\n" + data[i]["line"] + ": " + data[i]["arrival"] + "\n";
			}
			Ui.requestUpdate();
			Ui.requestUpdate();	
		}
	}
	
	// Converts Degrees to UTM coordinates
	function DegToUTM(Lat, Lon)
	{
		var zone = Math.floor(Lon/6+31);
		
		var easting = 0.5*Math.log((1+Math.cos(Lat*Math.PI/180)*Math.sin(Lon*Math.PI/180-(6*zone-183)*Math.PI/180))/(1-Math.cos(Lat*Math.PI/180)*Math.sin(Lon*Math.PI/180-(6*zone-183)*Math.PI/180)), Math.E)*0.9996*6399593.62/Math.pow((1+Math.pow(0.0820944379, 2)*Math.pow(Math.cos(Lat*Math.PI/180), 2)), 0.5)*(1 + Math.pow(0.0820944379,2)/2*Math.pow((0.5*Math.log((1+Math.cos(Lat*Math.PI/180)*Math.sin(Lon*Math.PI/180-(6*zone-183)*Math.PI/180))/(1-Math.cos(Lat*Math.PI/180)*Math.sin(Lon*Math.PI/180-(6*zone-183)*Math.PI/180)), Math.E)),2)*Math.pow(Math.cos(Lat*Math.PI/180),2)/3)+500000;
		easting = Math.round(easting*100)*0.01;
		       
		var northing = (Math.atan(Math.tan(Lat*Math.PI/180)/Math.cos((Lon*Math.PI/180-(6*zone -183)*Math.PI/180)))-Lat*Math.PI/180)*0.9996*6399593.625/Math.sqrt(1+0.006739496742*Math.pow(Math.cos(Lat*Math.PI/180),2))*(1+0.006739496742/2*Math.pow(0.5*Math.log((1+Math.cos(Lat*Math.PI/180)*Math.sin((Lon*Math.PI/180-(6*zone -183)*Math.PI/180)))/(1-Math.cos(Lat*Math.PI/180)*Math.sin((Lon*Math.PI/180-(6*zone -183)*Math.PI/180))), Math.E),2)*Math.pow(Math.cos(Lat*Math.PI/180),2))+0.9996*6399593.625*(Lat*Math.PI/180-0.005054622556*(Lat*Math.PI/180+Math.sin(2*Lat*Math.PI/180)/2)+4.258201531e-05*(3*(Lat*Math.PI/180+Math.sin(2*Lat*Math.PI/180)/2)+Math.sin(2*Lat*Math.PI/180)*Math.pow(Math.cos(Lat*Math.PI/180),2))/4-1.674057895e-07*(5*(3*(Lat*Math.PI/180+Math.sin(2*Lat*Math.PI/180)/2)+Math.sin(2*Lat*Math.PI/180)*Math.pow(Math.cos(Lat*Math.PI/180),2))/4+Math.sin(2*Lat*Math.PI/180)*Math.pow(Math.cos(Lat*Math.PI/180),2)*Math.pow(Math.cos(Lat*Math.PI/180),2))/3);
		northing = Math.round(northing*100)*0.01;

       return	{ 	
       				"east" => easting.toNumber(),
    				"north" => northing.toNumber()
       			};
	}
	
	function StopDataRetrieveTYo()
	{
		return stopDataString;
	}
}