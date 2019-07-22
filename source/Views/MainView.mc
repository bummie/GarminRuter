using Toybox.WatchUi;
using Toybox.System;
using Toybox.Position;

class MainView extends WatchUi.View 
{
	var _labelData;
	var _labelTitle;
	var _api;
    var _menuShown = false;

    function initialize() 
    {
        View.initialize();
        _api = RuterAPI.GetReference();
    }
    
   function onLayout(dc)
    {
        setLayout(Rez.Layouts.MainLayout(dc));
    	_labelData = View.findDrawableById("mainLabel");
    	_labelTitle = View.findDrawableById("titleLabel");
    }

    function onShow()
    {        
        _api.Log("Searching for position.\nENTER: Load last position.");
        Position.enableLocationEvents(Position.LOCATION_ONE_SHOT, method(:onPosition));
    }

    function onUpdate(dc)
    {
        _labelData.setText(_api.GetLogMessage());
        View.onUpdate(dc);
    }

    function onHide() {}

	function onPosition(info) 
	{
	    var location = info.position.toDegrees();
	  	System.println("Received position: " + location[0] + ", " + location[1]);
        _api.Log("Found fresh position,\n press ENTER!");
        _api.SetLocation({"latitude" => location[0], "longitude" => location[1]});
	}
}
    
class MainDelegate extends WatchUi.InputDelegate
{
    private var _api;

    function initialize()
    {
        BehaviorDelegate.initialize();
        _api = RuterAPI.GetReference();
    }

    function onKey(keyEvent)
    {
        switch(keyEvent.getKey())
        {
            case keyEvent.KEY_ENTER:
                System.println("Enter");
                var location = Position.getInfo().position.toDegrees();
                if(location == null) { _api.Log("Fant ikke plassering."); break; }
                var position = {"latitude" => location[0], "longitude" => location[1]};
                //var position = {"latitude" => 59.900928, "longitude" => 10.675506};
                _api.SetLocation(position);
                //System.println("Stored position: " + location);
                _api.ResetConnections();
                _api.FetchClosestStops(_api.GetLocation());
            break;

            case keyEvent.KEY_ESC:
                //WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
            break;
        }
        
        WatchUi.requestUpdate();
        return true;
    }
}