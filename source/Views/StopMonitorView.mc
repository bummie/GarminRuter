using Toybox.WatchUi;
using Toybox.System;
using Toybox.Time;

class StopMonitorView extends WatchUi.View 
{
    private var _api; 
    private var _stopName;
    private var _stopId;
    var _thickness = 7;

    function initialize(stopId, name) 
    {
        View.initialize();
        _api = RuterAPI.GetReference();
        _api.FetchStopData(stopId);
        _stopName = name;
        _stopId = stopId;
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

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        DrawText(dc, (dc.getWidth() / 2), thickness + shift, GetDisplayText(:firstName));
        DrawText(dc, (dc.getWidth() / 2), (thickness * 4) + shift, GetDisplayText(:secondName));

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        DrawText(dc, (dc.getWidth() / 2), 10 + shift, _stopName);
        DrawText(dc, (dc.getWidth() / 2), (thickness * 2) + shift, GetDisplayText(:firstTime));
        DrawText(dc, (dc.getWidth() / 2), (thickness * 5) + shift, GetDisplayText(:secondTime));
    }

    private function DrawText(dc, x, y, text)
    {
        dc.drawText(
            x, 
            y,     
            Graphics.FONT_XTINY,
            text,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    private function GetDisplayText(label)
    {
        if(!_api.HasLoaded()) { return "Loading.."; }
        var data = _api.GetStopData();
        _api.SetPageLimit(data.size());

        if(data.size() <= 0) { return "No data received.."; }

        var indexTwo = _api.GetPage() + 1;
        switch(label)
        {
            case :firstName:
                return data.keys()[_api.GetPage()];
            break;

            case :firstTime:
                return BeautifyTimeStrings(data.values()[_api.GetPage()]);
            break;

            case :secondName:
                if(indexTwo >= data.size() ) { return ""; }
                return data.keys()[indexTwo];
            break;

            case :secondTime:
                if(indexTwo >= data.size() ) { return ""; }
                return BeautifyTimeStrings(data.values()[indexTwo]);
            break;
        }
    }

    private function BeautifyTimeStrings(timeStrings)
    {
        var timeString = "";

        for(var i = 0; i < timeStrings.size(); i++)
        {
            timeString += ParseTimeString(timeStrings[i]) + " min";

            if(i < timeStrings.size()-1) { timeString += ", "; }
        }

        return timeString;
    }

    private function ParseTimeString(timeString)
    {
        var offset = 11;
        var hours = timeString.toString().substring(offset, offset+2);
        var minutes = timeString.toString().substring(offset+3, offset+5);
        var seconds = timeString.toString().substring(offset+6, offset+8);

        var currentTime = System.getClockTime();
        var busTime = (hours.toNumber() * 60 * 60) + (minutes.toNumber() * 60) + seconds.toNumber();
        var clockTime = (currentTime.hour * 60 * 60) + (currentTime.min * 60) + currentTime.sec;
        
        var differenceInMinutes = (busTime - clockTime) / 60;
        
        return differenceInMinutes;
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
                _api.FlipPage(1);
            break;
            
            case keyEvent.KEY_DOWN:
                _api.FlipPage(0);
            break;  

            case keyEvent.KEY_ENTER:
                System.println("Enter");
                _api.FetchStopData(_api.GetLastStopId());
            break;

            case keyEvent.KEY_ESC:
                WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
            break;
        }
        
        WatchUi.requestUpdate();
        return true;
    }
}  