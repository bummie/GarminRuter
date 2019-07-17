using Toybox.WatchUi;
using Toybox.System;

class MenuView extends WatchUi.BehaviorDelegate 
{    
    function initialize()
    {
        BehaviorDelegate.initialize();
        System.println("MenuView Loaded");
    }

    function OpenMenu(stopNames)
    {   
        var menu = new WatchUi.Menu2({:title=>"Stoppesteder"});
        var delegate;

        for(var i = 0; i < stopNames.size(); i++)
        {
            menu.addItem( new MenuItem( stopNames[i], "", i, {}) );
        }

        delegate = new MenuViewDelegate(); // a WatchUi.Menu2InputDelegate
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
        System.println(item.getId());
    }
}