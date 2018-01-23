using Toybox.Application as App;
using Toybox.Communications as Com;
using Toybox.Application.Storage as Storage;

class RuterBussApp extends App.AppBase
 {

    function initialize()
    {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state)
    {
    	System.print("HELLO");
    	Storage.setValue("Test", "{PlaceType=>Stop, IsHub=>false, DistrictID=>null, X=>597868, Lines=>[], District=>Oslo, ID=>3010013, Name=>Jernbanetorget (foran Oslo S), ShortName=>JERB, Y=>6642859, Zone=>1}");
    	
    	System.println("Storage: " + Storage.getValue("Test") );
    	var api = new RuterAPI();
    	api.fetchClosestStop();
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

}