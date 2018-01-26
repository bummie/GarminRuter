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
        api = RuterAPI.getReference();
    }

    // onStart() is called on application start up
    function onStart(state)
    {
    	Position.enableLocationEvents(Position.LOCATION_ONE_SHOT, method(:onPosition));
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
	    //api.fetchClosestStop(loc[0], loc[1]);
	  	api.fetchClosestStop(59.910011, 10.680239);
	  	System.println("YO)" + api.stopDataRetrieveTYo());
	    
	}

}