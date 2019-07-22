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

    function onStart(state)
    {
        _api = RuterAPI.GetReference();
        System.println("App started...");
    }

    function onStop(state) {}

    function getInitialView() 
    {
        return [ new MainView(), new MainDelegate() ];
    }
}