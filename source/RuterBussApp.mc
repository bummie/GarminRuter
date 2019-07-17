using Toybox.Application as App;
using Toybox.Communications as Com;
using Toybox.Application.Storage as Storage;
using Toybox.Position;
using Toybox.System;

class RuterBussApp extends App.AppBase
{
	var api;
	
    function initialize()
    {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state)
    {
        api = RuterAPI.GetReference();
    	Position.enableLocationEvents(Position.LOCATION_ONE_SHOT, method(:onPosition));
        System.println("App started...");
        
        api.FetchClosestStops(59.910011, 10.680239);
        //api.FetchClosestStops(59.91439857093467, 10.733748436295173); 
    }

    // onStop() is called when your application is exiting
    function onStop(state) 
    {
    }

    // Return the initial view of your application here
    function getInitialView() 
    {
        return [ new RuterBussView() ];
    }
    
    // When received position, find busroutes
	function onPosition(info) 
	{
	    var loc = info.position.toDegrees();
	  	System.println("Received position: " + loc[0] + ", " + loc[1]);
	}
}