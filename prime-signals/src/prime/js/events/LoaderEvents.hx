package prime.js.events;

import prime.core.events.CommunicationEvents;
import prime.js.net.URLLoader;
import prime.core.events.LoaderEvents;
import prime.signal.Signal0;
import prime.signal.Signal1;
import prime.js.net.XMLHttpRequest;
import js.Dom;
import js.Lib;

/**
 * JS implementation of loader-events.
 * 
 * @author	Stanislav Sopov
 * @since	April 5, 2011
 */

// TODO: Make events extend DOMSignal 
 
class LoaderEvents extends LoaderSignals
{
	public function new (request:XMLHttpRequest)
	{
		super();
		unloaded	= new Signal0();
		load		= new CommunicationEvents(request);
		httpStatus	= new Signal1<Int>();
	}
}