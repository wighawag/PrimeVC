package prime.js.events;

import prime.signal.Wire;
import prime.signal.Signal0;
import prime.signal.IWireWatcher;
import prime.core.ListNode;
import js.Dom;

/**
 * @author	Stanislav Sopov
 * @since 	April 6, 2011
 */
class DOMSignal0 extends Signal0, implements IWireWatcher<Void->Void>
{
	var eventDispatcher:Dynamic;
	var event:String;
	
	public function new (eventDispatcher:Dynamic, event:String)
	{
		super();
		this.eventDispatcher = eventDispatcher;
		this.event = event;
	}
	
	public function wireEnabled (wire:Wire<Void->Void>):Void
	{	
		Assert.isNotNull(n);
		
		if (ListUtil.next(n) == null) // First wire connected
		{
			untyped eventDispatcher.addEventListener(event, dispatch, false);
		}
	}
	
	public function wireDisabled (wire:Wire<Void->Void>):Void
	{	
		if (n == null) // No more wires connected
		{
			untyped eventDispatcher.removeEventListener(event, dispatch, false);
		}
	}
	
	private function dispatch(e:Event) 
	{
		Assert.abstract();
	}
}
