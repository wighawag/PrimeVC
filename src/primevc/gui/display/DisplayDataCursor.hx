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
package primevc.gui.display;
 import primevc.core.collections.DataCursor;
 import primevc.core.collections.IDataCursor;
 import primevc.core.geom.Point;
  using primevc.utils.NumberUtil;


/**
 * Metadata about a displayObject containing the current depth, parent and 
 * coordinates.
 * 
 * @author			Ruben Weijers
 * @creation-date	Oct 28, 2010
 */
class DisplayDataCursor extends DataCursor < IDisplayObject >, implements IDataCursor < IDisplayObject >
{
	/**
	 * Current x&y-coordinates of the target
	 */
	public var position		(default, null)	: Point;
	
	
	public function new (target:IDisplayObject)
	{
		if (target.container != null)
			super(target, target.container.children);
		else
			super(target, null);
		
		position = new Point( target.x, target.y );
	}
	
	
	override public function dispose ()
	{
		position = null;
		super.dispose();
	}
	
	
	override public function restore ()
	{
		target.visible	= false;
		target.x		= target.rect.left	= position.x.roundFloat();
		target.y		= target.rect.top	= position.y.roundFloat();
	//	super.restore();
		target.visible	= true;
	}
}