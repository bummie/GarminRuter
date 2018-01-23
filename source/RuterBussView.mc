using Toybox.WatchUi as Ui;

class RuterBussView extends Ui.View 
{

	var label;
	var i = 0;
    function initialize() 
    {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc)
    {
        setLayout(Rez.Layouts.MainLayout(dc));
    	label = View.findDrawableById("mainLabel");
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
        // Call the parent onUpdate function to redraw the layout
       	label.setText("I: " + i);
       	i++;
       	
       	View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() 
    {
    }

}
