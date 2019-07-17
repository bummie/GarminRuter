using Toybox.WatchUi as Ui;

class RuterBussView extends Ui.View 
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
    }

    // Update the view
    function onUpdate(dc)
    {
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() 
    {
    }

}
