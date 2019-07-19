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
    // Load your resources here
    function onLayout(dc)
    {
        setLayout(Rez.Layouts.MainLayout(dc));
    	_labelData = View.findDrawableById("mainLabel");
    	_labelTitle = View.findDrawableById("titleLabel");
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow()
    {        
        _api.Log("Searching for position.\nENTER: Load last position.");
        Position.enableLocationEvents(Position.LOCATION_ONE_SHOT, method(:onPosition));
    }

    // Update the view
    function onUpdate(dc)
    {
        _labelData.setText(_api.GetLogMessage());
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() 
    {
    }

    // When received position, find busroutes
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
                //var location = Position.getInfo().position.toDegrees();
                //if(location == null) { _api.Log("Fant ikke plassering."); break; }
                //var position = {"latitude" => location[0], "longitude" => location[1]};
                var position = {"latitude" => 59.900928, "longitude" => 10.675506};

                //System.println("Stored position: " + location);
                _api.FetchClosestStops(position);
            break;

            case keyEvent.KEY_ESC:
                //WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
            break;
        }
        
        WatchUi.requestUpdate();
        return true;
    }
}