using Toybox.Application as App;
using Toybox.Communications as Com;
using Toybox.Math;
using Toybox.WatchUi as Ui;

class RuterAPI
{
	private static var api = null;
	private var URL = "https://api.entur.io/journey-planner/v2/graphql";
	private var JSON_REQUEST_CLOSEST_STOP = { "query" => "{stopPlace(id: \\\"NSR:StopPlace:4370\\\"){ name }}"};
	
	hidden var options =	
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
	function FetchClosestStop(latitude, longitude) 
	{		  
		System.println("Making web request");
		System.println(JSON_REQUEST_CLOSEST_STOP);	
	    Com.makeWebRequest(URL, JSON_REQUEST_CLOSEST_STOP, options, method(:CallbackPrint));
	}
	
	function CallbackPrint(responseCode, data)
	{
		if(responseCode != 200) { System.println( responseCode +  " : Could not retrieve data."); }
		if(data == null || data.size() <= 0) { System.println("Data received is empty."); }

		System.println("Data received: " + data);
	}

	hidden function CreateGraphQLRequest(request)
	{
		return 
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
}