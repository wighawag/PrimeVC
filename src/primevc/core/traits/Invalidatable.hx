/*
 * Copyright (c) 2010, The PrimeVC Project Contributors
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE PRIMEVC PROJECT CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE PRIMVC PROJECT CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 *
 *
 * Authors:
 *  Ruben Weijers	<ruben @ onlinetouch.nl>
 */
package primevc.core.traits;
 import haxe.FastList;
  using primevc.utils.BitUtil;



/**
 * Base class to allow simple invalidation on objects.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 31, 2010
 */
class Invalidatable implements IInvalidatable
{
	public var listeners		(default, null)	: FastList< IInvalidateListener >;
	
	
	public function new ()
	{
		listeners = new FastList< IInvalidateListener >();
	}
	
	
	public function dispose ()
	{
		while (!listeners.isEmpty())
			listeners.pop();
		
		listeners = null;
	}
	
	
	public function invalidate (change:Int) : Void
	{
	//	Assert.notNull(listeners, this+" is already disposed.");
		var current = listeners.head;
		while (current != null)
		{
			current.elt.invalidateCall( change, this );
			current = current.next;
		}
	}
	
	
	public function invalidateCall ( changeFromOther:Int, sender:IInvalidatable ) : Void
	{
		Assert.notEqual( sender, this );	// <-- prevent infinite loops
		invalidate( changeFromOther );
	}
}