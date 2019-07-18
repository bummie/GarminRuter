using Toybox.WatchUi;
using Toybox.System;

class StopMonitorView extends WatchUi.View 
{
    private var _api; 
    private var _stopName;
    var _thickness = 7;

    function initialize(stopId, name) 
    {
        View.initialize();
        _api = RuterAPI.GetReference();
        _api.FetchStopData(stopId);
        _stopName = name;
    }

    // Load your resources here
    function onLayout(dc)
    {
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow()
    {

    }

    // Update the view
    function onUpdate(dc)
    {
        ClearScreen(dc);
        DrawRectangles(dc);
        DrawTexts(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() 
    {
    }

    function DrawRectangles(dc)
    {
        var shift = 5;
        var thickness = dc.getHeight() / _thickness;

        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
        dc.fillRectangle( 0, (thickness * 1) + shift, dc.getWidth(), thickness);
        dc.fillRectangle( 0, (thickness * 4) + shift, dc.getWidth(), thickness);

        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK);
        dc.fillRectangle( 0, (thickness * 2) + shift, dc.getWidth(), thickness);
        dc.fillRectangle( 0, (thickness * 5) + shift, dc.getWidth(), thickness);
    }

    private function ClearScreen(dc)
    {
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_DK_GRAY);    
        dc.clear();
    }

    private function DrawTexts(dc)
    {
        var thickness = dc.getHeight() / _thickness;
        var shift = thickness / 2;

        DrawText(dc, (dc.getWidth() / 2), 10 + shift, _stopName);

        DrawText(dc, (dc.getWidth() / 2), thickness + shift, "Bygdøy via Bygdøynes");
        DrawText(dc, (dc.getWidth() / 2), (thickness * 4) + shift, "Nydalen");

        DrawText(dc, (dc.getWidth() / 2), (thickness * 2) + shift, "Nå - 2 min - 10 min");
        DrawText(dc, (dc.getWidth() / 2), (thickness * 5) + shift, "2 min - 8 min - 15 min");
    }

    private function DrawText(dc, x, y, text)
    {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            x, 
            y,     
            Graphics.FONT_XTINY,
            text,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }
}

class StopMonitorDelegate extends WatchUi.InputDelegate
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
            case keyEvent.KEY_UP:
                System.println("Up");
            break;
            
            case keyEvent.KEY_DOWN:
                System.println("Down");
            break;

            case keyEvent.KEY_ENTER:
                System.println("Enter");
            break;
        }

        return true;
    }
}  