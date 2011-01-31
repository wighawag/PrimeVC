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
package primevc.gui.layout.algorithms.float;
 import primevc.core.geom.space.Vertical;
 import primevc.core.geom.IRectangle;
 import primevc.gui.layout.algorithms.IVerticalAlgorithm;
 import primevc.gui.layout.algorithms.VerticalBaseAlgorithm;
 import primevc.gui.layout.AdvancedLayoutClient;
 import primevc.utils.NumberMath;
  using primevc.utils.NumberMath;
  using primevc.utils.NumberUtil;
  using primevc.utils.TypeUtil;


/**
 * Floating algorithm for vertical layouts
 * 
 * @creation-date	Jun 24, 2010
 * @author			Ruben Weijers
 */
class VerticalFloatAlgorithm extends VerticalBaseAlgorithm, implements IVerticalAlgorithm
{
	/**
	 * Measured point of the bottom side of the middlest child (rounded above)
	 * when the direction is center.
	 */
	private var halfHeight	: Int;
	
	
	
	//
	// LAYOUT
	//
	
	
	/**
	 * Method will return the total height of all the children.
	 */
	public inline function validate ()
	{
		if (group.children.length == 0)
			return;
		
		validateHorizontal();
		validateVertical();
	}
	
	
	public function validateVertical ()
	{
		var height:Int = halfHeight = 0;
		
		if (group.childHeight.notSet())
		{
			var i:Int = 0;
			
			for (child in group.children)
			{
				if (!child.includeInLayout)
					continue;
				
				height += child.outerBounds.height;
				
				//only count even children
				if (i.isEven())
					halfHeight += child.outerBounds.height;
				
				i++;
			}
		}
		else
		{
			height		= group.childHeight * group.children.length;
			halfHeight	= group.childHeight * group.children.length.divCeil(2);
		}
		
		setGroupHeight(height);
	}


	override public function apply ()
	{
		switch (direction) {
			case Vertical.top:		applyTopToBottom();
			case Vertical.center:	applyCentered();
			case Vertical.bottom:	applyBottomToTop();
		}
		super.apply();
	}
	
	
	private inline function applyTopToBottom (next:Int = -1) : Void
	{
		if (group.children.length > 0)
		{
			if (next == -1)
				next = getTopStartValue();
			
			Assert.that(next.isSet());
			
			//use 2 loops for algorithms with and without a fixed child-height. This is faster than doing the if statement inside the loop!
			if (group.childHeight.notSet())
			{
				for (child in group.children) {
					if (!child.includeInLayout)
						continue;
					
					child.outerBounds.top	= next;
					next					= child.outerBounds.bottom;
				}
			}
			else
			{
				for (child in group.children) {
					if (!child.includeInLayout)
						continue;
					
					child.outerBounds.top	 = next;
					next					+= group.childHeight;
				}
			}
		}
	}
	
	
	private inline function applyCentered () : Void
	{
		applyTopToBottom( getVerCenterStartValue() );
		/*if (group.children.length > 0)
		{
			var i:Int = 0;
			var evenPos:Int, oddPos:Int;
			evenPos = oddPos = halfHeight + getTopStartValue();
		
			//use 2 loops for algorithms with and without a fixed child-height. This is faster than doing the if statement inside the loop!
			if (group.childHeight.notSet())
			{
				for (child in group.children)
				{
					if (!child.includeInLayout)
						continue;
					
					if (i.isEven()) {
						//even
						child.bounds.bottom	= evenPos;
						evenPos				= child.bounds.top;
					} else {
						//odd
						child.bounds.top	= oddPos;
						oddPos				= child.bounds.bottom;
					}
					i++;
				}
			}
			else
			{
				for (child in group.children)
				{
					if (!child.includeInLayout)
						continue;
					
					if (i.isEven()) {
						//even
						child.bounds.bottom	 = evenPos;
						evenPos				-= group.childHeight;
					} else {
						//odd
						child.bounds.top	 = oddPos;
						oddPos				+= group.childHeight;
					}
					i++;
				}
			}
		}*/
	}
	
	
	private inline function applyBottomToTop () : Void
	{
		if (group.children.length > 0)
		{
			var next = getBottomStartValue();
			Assert.that(next.isSet());
			
			//use 2 loops for algorithms with and without a fixed child-height. This is faster than doing the if statement inside the loop!
			if (group.childHeight.notSet())
			{
				for (child in group.children) {
					if (!child.includeInLayout)
						continue;
					
					child.outerBounds.bottom	= next;
					next						= child.outerBounds.top;
				}
			}
			else
			{
				next -= group.childHeight;
				for (child in group.children) {
					if (!child.includeInLayout)
						continue;
					
					child.outerBounds.top	= next;
					next					= child.outerBounds.top - group.childHeight;
				}
			}
		}
	}


	/**
	 * 
	 */
	public inline function getDepthForBounds (bounds:IRectangle) : Int
	{
		return switch (direction) {
			case Vertical.top:		getDepthForBoundsTtB(bounds);
			case Vertical.center:	getDepthForBoundsC(bounds);
			case Vertical.bottom:	getDepthForBoundsBtT(bounds);
		}
	}


	private inline function getDepthForBoundsTtB (bounds:IRectangle) : Int
	{
		var depth:Int	= 0;
		var posY:Int	= bounds.top;
		var centerY:Int	= bounds.top + (bounds.height * .5).roundFloat();
		
		if (group.childHeight.isSet())
		{
			depth = posY.divRound(group.childHeight);
		}
		else
		{
			//if pos <= 0, the depth will be 0
			if (posY > 0)
			{
				//check if it's smart to start searching at the end or at the beginning..
				var groupHeight = group.height.value;
				if (group.is(AdvancedLayoutClient))
					groupHeight = IntMath.max( 0, group.as(AdvancedLayoutClient).measuredHeight );
				
				var halfH = groupHeight * .5;
				if (posY < halfH) {
					//start at beginning
					for (child in group.children) {
						if (child.includeInLayout && centerY <= child.outerBounds.bottom && centerY >= child.outerBounds.top)
							break;

						depth++;
					}
				}
				else
				{
					//start at end
					var itr	= group.children.reversedIterator();
					depth	= group.children.length;
					while (itr.hasNext()) {
						var child = itr.next();
						if (child.includeInLayout && centerY >= child.outerBounds.bottom)
							break;

						depth--;
					}
				}
			}
		}
		return depth;
	}


	private inline function getDepthForBoundsC (bounds:IRectangle) : Int
	{
		Assert.abstract( "Wrong implementation since the way centered layouts behave is changed");
		var depth:Int	= 0;
		var posY:Int	= bounds.top;
		var centerY:Int	= bounds.top + (bounds.height * .5).roundFloat();
		
		var groupHeight	= group.height.value;
		if (group.is(AdvancedLayoutClient))
			groupHeight	= IntMath.max( 0, group.as(AdvancedLayoutClient).measuredHeight );
		
		var halfH = groupHeight * .5;
		
		for (child in group.children) {
			if (child.includeInLayout 
				&& (
						(centerY <= child.outerBounds.bottom && centerY >= halfH)
					||	(centerY >= child.outerBounds.bottom && centerY <= halfH)
				)
			)
				break;

			depth++;
		}
		return depth;
	}


	private inline function getDepthForBoundsBtT (bounds:IRectangle) : Int
	{
		var depth:Int	= 0;
		var posY:Int	= bounds.top;
		var centerY:Int	= bounds.top + (bounds.height * .5).roundFloat();
		
		var groupHeight = group.height.value;
		var emptyHeight	= 0;
		if (group.is(AdvancedLayoutClient))
		{
			groupHeight = IntMath.max( 0, group.as(AdvancedLayoutClient).measuredHeight );
			//check if there's any width left. This happens when there's an explicitWidth set.
			emptyHeight	= IntMath.max( 0, group.height.value - groupHeight );
		}
		
		if (group.childHeight.isSet())
		{
			depth = group.children.length - ( posY - emptyHeight ).divRound( group.childHeight );
		}
		else
		{
			//if pos <= emptyHeight, the depth will be at the end of the list
			if (posY <= emptyHeight)
				depth = group.children.length;
			
			//if bounds.bottom < maximum group height, then the depth is at the beginning of the list
			else if (bounds.right < IntMath.max(group.height.value, groupHeight))
			{
				//check if it's smart to start searching at the end or at the beginning..
				var halfH = groupHeight * .5;

				if (posY > (emptyHeight + halfH)) {
					//start at beginning
					for (child in group.children) {
						if (child.includeInLayout && centerY >= child.outerBounds.top)
							break;

						depth++;
					}
				}
				else
				{
					//start at end
					var itr	= group.children.reversedIterator();
					depth	= group.children.length - 1;
					while (itr.hasNext()) {
						var child = itr.next();
						if (child.includeInLayout && centerY <= child.outerBounds.bottom)
							break;

						depth--;
					}
				}
			}

		}
		return depth;
	}
	
	
#if (neko || debug)
	override public function toCSS (prefix:String = "") : String
	{
		return "float-ver (" + direction + ", " + horizontal + ")";
	}
#end
}