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
package primevc.gui.components;
 import primevc.core.geom.space.Direction;
 import primevc.gui.behaviours.UpdateMaskBehaviour;
 import primevc.gui.core.UIGraphic;
 import primevc.gui.display.VectorShape;
  using Std;


/**
 * Slider component with a filling background to indicate which part of the
 * slider is slided.
 * 
 * @author Ruben Weijers
 * @creation-date Nov 05, 2010
 */
class Slider extends SliderBase
{
	override private function init ()
	{
		super.init();
		behaviours.add( new UpdateMaskBehaviour( maskShape, this ) );
	}
	
	
	
	//
	// CHILDREN
	//
	
	/**
	 * Shape that is used to fill the part of the slider that is slided
	 */
	private var background	: UIGraphic;
	private var maskShape	: VectorShape;
	
	
	override private function createChildren ()
	{
		maskShape	= new VectorShape();
		background	= new UIGraphic();
		
#if debug
		background.id.value	= id.value + "Background";
#end
		
		layoutContainer.children.add( background.layout );
		children.add( background );
		children.add( maskShape );

		background.mask = maskShape;
		super.createChildren();
	}
	
	
	override private function updateChildren ()
	{
		if (direction == horizontal)	background.layout.percentWidth = percentage;
		else							background.layout.percentHeight = percentage;
		return super.updateChildren();
	}
	
	
	override private function setDirection (v)
	{
		if (direction != v)
		{
			if (direction != null)
				styleClasses.remove( direction.string()+"Slider" );
			
			super.setDirection(v);
			
			if (v != null)
				styleClasses.add( direction.string()+"Slider" );
		}
		return v;
	}
}