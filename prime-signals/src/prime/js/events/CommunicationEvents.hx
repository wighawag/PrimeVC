package prime.js.events;

import prime.core.events.CommunicationEvents;
import prime.js.net.XMLHttpRequest;
import prime.signal.Signal0;
import js.Dom;

/**
 * @author	Danny Wilson
 * @since 	April 14, 2011
 */

class CommunicationEvents extends CommunicationSignals
{
	public function new (request:XMLHttpRequest)
	{
		super();
		started		= new Signal0();
		progress	= new ProgressSignal();
		init		= new Signal0();
		completed	= new Signal0();
		error		= new ErrorSignal();
	}
}