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
package primevc.gui.behaviours;
 import primevc.gui.core.IUIElement;
 import primevc.gui.styling.declarations.StyleDeclarationType;
 import primevc.gui.styling.declarations.UIElementStyle;
  using primevc.utils.Bind;


/**
 * @author Ruben Weijers
 * @creation-date Sep 16, 2010
 */
class ManageStyleBehaviour extends BehaviourBase < IUIElement >
{
	override private function init ()
	{
		updateStyleClasses	.on( target.styleClasses.change, this );
		updateIdStyle		.on( target.id.change, this );
		updateElementStyle	.on( target.displayEvents.addedToStage, this );
		//state changes?
	}
	
	
	override private function reset ()
	{
		target.styleClasses.change.unbind( this );
		target.id.change.unbind( this );
		target.displayEvents.addedToStage.unbind( this );
	}
	
	
	private function updateStyleClasses ()
	{
	//	trace("updateStyleClasses");
	}
	
	
	private function updateIdStyle ()
	{
	//	trace("updateIdStyle");
	}
	
	
	private function updateElementStyle ()
	{
		//create unique style-object if it doesn't exist
		if (target.style == null)
			target.style = new UIElementStyle(StyleDeclarationType.specific);
		
		//fill it with the parent's style
	//	trace("updateElementStyle");
	}
}