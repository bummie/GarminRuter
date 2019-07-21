using Toybox.WatchUi;
using Toybox.System;

class MenuView extends WatchUi.BehaviorDelegate 
{    
    private var _api;

    function initialize()
    {
        BehaviorDelegate.initialize();
        _api = RuterAPI.GetReference();

        System.println("MenuView Loaded");
    }

    function OpenMenu(stops)
    {   
        var menu = new WatchUi.Menu2({:title=>"Stoppesteder"});
        var delegate;

        for(var i = 0; i < stops.size(); i++)
        {
            menu.addItem( new MenuItem( stops[i]["name"], stops[i]["id"], stops[i]["id"], {}) );
        }

        delegate = new MenuViewDelegate(); 
        WatchUi.pushView(menu, delegate, WatchUi.SLIDE_IMMEDIATE);
    }
}

class MenuViewDelegate extends WatchUi.Menu2InputDelegate
{    
    function initialize()
    {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) 
    {
        WatchUi.pushView( new StopMonitorView(item.getId(), item.getLabel()), new StopMonitorDelegate(), WatchUi.SLIDE_IMMEDIATE);
    }
}