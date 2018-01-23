using Toybox.Application as App;
using Toybox.Communications as Com;
using Toybox.Math;

class RuterAPI
{
	var stopName = null;
	var stopId = null;
	
	// Returns the stops for given line
	function fetchStopData(stopid) 
	{
	  	var url = "https://reisapi.ruter.no/StopVisit/GetDepartures/" + stopid;
	  	var options =
	  	{
	  		:method => Com.HTTP_REQUEST_METHOD_GET,
	   		:headers => {"Content-Type" => Com.HTTP_RESPONSE_CONTENT_TYPE_JSON},
	    	:responseType => Com.HTTP_RESPONSE_CONTENT_TYPE_JSON
	  	};
	
		var responseCallback = method(:callbackPrint);                  
	    Com.makeWebRequest(url, {}, options, responseCallback);
	}
	
	// Fetches the closest stop by position
	function fetchClosestStop(lat, lon)
	{
		var utm = DegToUTM(lat, lon);
		var url = "https://reisapi.ruter.no/Place/GetClosestStops?coordinates=(x=" + utm["east"] + ",y=" + utm["north"] + ")";
	  	var options =
	  	{
	  		:method => Com.HTTP_REQUEST_METHOD_GET,
	   		:headers => {"Content-Type" => Com.HTTP_RESPONSE_CONTENT_TYPE_JSON},
	    	:responseType => Com.HTTP_RESPONSE_CONTENT_TYPE_JSON
	  	};
	
		var responseCallback = method(:callbackClosestStop);                  
	    Com.makeWebRequest(url, {}, options, responseCallback);
	}
	
	function callbackClosestStop(response, data)
	{
		if(response == 200)
		{
			if(data != null && data.size() > 0)
			{
				stopName = data[0]["Name"];
				stopId = data[0]["ID"];
				System.println("Stoppested: " + stopName + " ID: "  + stopId);
				fetchStopData(stopId);
			}
		}
		else
		{
			System.println("Something went wrong!");
		}
	}
	
	function callbackPrint(responseCode, data)
	{
		System.println(responseCode + " : " + data[0]);
	}
	
	// Converts Degrees to UTM coordinates
	function DegToUTM(Lat, Lon)
	{
		var Zone = Math.floor(Lon/6+31);
		
		var Easting = 0.5*Math.log((1+Math.cos(Lat*Math.PI/180)*Math.sin(Lon*Math.PI/180-(6*Zone-183)*Math.PI/180))/(1-Math.cos(Lat*Math.PI/180)*Math.sin(Lon*Math.PI/180-(6*Zone-183)*Math.PI/180)), Math.E)*0.9996*6399593.62/Math.pow((1+Math.pow(0.0820944379, 2)*Math.pow(Math.cos(Lat*Math.PI/180), 2)), 0.5)*(1 + Math.pow(0.0820944379,2)/2*Math.pow((0.5*Math.log((1+Math.cos(Lat*Math.PI/180)*Math.sin(Lon*Math.PI/180-(6*Zone-183)*Math.PI/180))/(1-Math.cos(Lat*Math.PI/180)*Math.sin(Lon*Math.PI/180-(6*Zone-183)*Math.PI/180)), Math.E)),2)*Math.pow(Math.cos(Lat*Math.PI/180),2)/3)+500000;
		Easting = Math.round(Easting*100)*0.01;
		       
		var Northing = (Math.atan(Math.tan(Lat*Math.PI/180)/Math.cos((Lon*Math.PI/180-(6*Zone -183)*Math.PI/180)))-Lat*Math.PI/180)*0.9996*6399593.625/Math.sqrt(1+0.006739496742*Math.pow(Math.cos(Lat*Math.PI/180),2))*(1+0.006739496742/2*Math.pow(0.5*Math.log((1+Math.cos(Lat*Math.PI/180)*Math.sin((Lon*Math.PI/180-(6*Zone -183)*Math.PI/180)))/(1-Math.cos(Lat*Math.PI/180)*Math.sin((Lon*Math.PI/180-(6*Zone -183)*Math.PI/180))), Math.E),2)*Math.pow(Math.cos(Lat*Math.PI/180),2))+0.9996*6399593.625*(Lat*Math.PI/180-0.005054622556*(Lat*Math.PI/180+Math.sin(2*Lat*Math.PI/180)/2)+4.258201531e-05*(3*(Lat*Math.PI/180+Math.sin(2*Lat*Math.PI/180)/2)+Math.sin(2*Lat*Math.PI/180)*Math.pow(Math.cos(Lat*Math.PI/180),2))/4-1.674057895e-07*(5*(3*(Lat*Math.PI/180+Math.sin(2*Lat*Math.PI/180)/2)+Math.sin(2*Lat*Math.PI/180)*Math.pow(Math.cos(Lat*Math.PI/180),2))/4+Math.sin(2*Lat*Math.PI/180)*Math.pow(Math.cos(Lat*Math.PI/180),2)*Math.pow(Math.cos(Lat*Math.PI/180),2))/3);
		Northing = Math.round(Northing*100)*0.01;
		
       return 	{ 	
       				"east" => Easting.toNumber(),
       				"north" => Northing.toNumber()
       			};
	}
}