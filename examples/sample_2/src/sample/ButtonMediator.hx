package sample;

import primevc.gui.events.MouseEvents;
import primevc.mvc.Mediator;
import primevc.core.dispatcher.Signal1;
import primevc.gui.components.Button;
using primevc.utils.Bind;
using primevc.utils.TypeUtil;


/**
 * ButtonMediator corresponds to a mediator in the MVC model.
 * A mediator separates event handling for a specific UI element
 * from the element itself. It defines what Button events should 
 * be listened to and what functions react to them. 
 */
class ButtonMediator extends Mediator <MainEvents, MainModel, MainView, Button>
{	
    override public function startListening ()
    {
        if (isListening())
            return;
		
        clickHandler.on(viewComponent.userEvents.mouse.click, this);
        super.startListening();
    }

    override public function stopListening ()
    {
        if (!isListening())
            return;
        
        viewComponent.userEvents.unbind(this);
        super.stopListening ();
    }
	
    private function clickHandler(e)
    {
        events.loadImage.send(model.mainProxy.vo.value);
    }
}