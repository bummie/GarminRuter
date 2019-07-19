using Toybox.Application as App;
using Toybox.Position;
using Toybox.System;

class RuterBussApp extends App.AppBase
{
	var _api;
    var location;
	
    function initialize()
    {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state)
    {
        _api = RuterAPI.GetReference();
        System.println("App started...");
        _api.SetLocation({"latitude" => 59.908795624003076, "longitude" => 10.749941278450478});
        //api.FetchClosestStops({"latitude" => 59.910011, "longitude" => 10.680239});
    }

    // onStop() is called when your application is exiting
    function onStop(state) 
    {
    }

    // Return the initial view of your application here
    function getInitialView() 
    {
        return [ new MainView(), new MainDelegate() ];
    }
}