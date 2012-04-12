package prime.js.events;

import prime.signal.IWireWatcher;
import prime.signal.Signal2;
import prime.signal.Wire;
import prime.core.ListNode;
import prime.core.events.CommunicationEvents;		// needed for ProgressHandler typedef

import prime.js.net.XMLHttpRequest;
import js.Dom;

/**
 * @author	Stanislav Sopov
 * @since	April 6, 2011
 */
class ProgressSignal extends Signal2<Int, Int>, implements IWireWatcher <ProgressHandler> 
{
	
	var request:XMLHttpRequest;
	var event:String;
	
	
	public function new (r:XMLHttpRequest, e:String)
	{
		super();
		
		this.request = r;
		this.event = e;
	}
	
	public function wireEnabled(wire:Wire<ProgressHandler>) : Void 
	{
		Assert.isNotNull(n);
		
		if (ListUtil.next(n) == null) // First wire connected
		{
			request.addEventListener(event, dispatch, false);
		}
	}
	
	public function wireDisabled(wire:Wire<ProgressHandler>):Void 
	{
		if (n == null) // No more wires connected
		{
			request.removeEventListener(event, dispatch, false);
		}
	}
	
	private function dispatch(e:Event)
	{	
		send(untyped e.loaded, untyped e.total);
	}
}