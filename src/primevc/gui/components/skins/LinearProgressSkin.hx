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
 * DAMAGE.s
 *
 *
 * Authors:
 *  Ruben Weijers	<ruben @ onlinetouch.nl>
 */
package primevc.gui.components.skins;
 import primevc.core.net.CommunicationType;
 import primevc.core.Bindable;

 import primevc.gui.behaviours.UpdateMaskBehaviour;

 import primevc.gui.components.Label;
 import primevc.gui.components.ProgressBar;

 import primevc.gui.core.Skin;
 import primevc.gui.core.UIElementFlags;
 import primevc.gui.core.UIGraphic;

 import primevc.gui.display.VectorShape;
  using primevc.utils.NumberUtil;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;


/**
 * Linear loader bar for the ProgressBar component. Use the following style-names
 * to style the different parts of the skin
 * 	- ProgressBar				-> style for the complete bar (i.e. background, border)
 * 	- ProgressBar #indicator	-> style for the block that indicates the progress
 * 
 * @author Ruben Weijers
 * @creation-date Mar 28, 2011
 */
class LinearProgressSkin extends Skin<ProgressBar>
{
	private var label		: Bindable<String>;
	private var indicator	: UIGraphic;
	private var maskShape	: VectorShape;
	private var labelField	: Label;
	
	/**
	 * String to put before the label ('Laden' or 'Uploaden')
	 */
	private var labelPrefix	: String;
	
	
	override private function createBehaviours ()
	{
		label = new Bindable<String>();
		update.on( owner.data.perc.change, this );
	}
	
	
	override private function removeBehaviours ()
	{
		label.dispose();
		label = null;
		
		owner.data.perc.change.unbind(this);
		super.removeBehaviours();
	}
	

	override public function createChildren ()
	{
		indicator	= new UIGraphic("indicator");
		maskShape	= new VectorShape();
		labelField	= new Label(null, label);
		
		var o = owner;
		var l = o.layoutContainer;
		l.children.add( indicator.layout );
		l.children.add( labelField.layout );
		
		o.children.add( indicator );
		o.children.add( maskShape );
		o.children.add( labelField );
		
		indicator.mask = maskShape;
		behaviours.add( new UpdateMaskBehaviour( maskShape, owner ) );
	}


	override private function removeChildren ()
	{
		if (indicator != null)
		{
			if (owner != null && !owner.isDisposed())
			{
				var o = owner;
				var l = o.layoutContainer;
				l.children.remove( labelField.layout );
				l.children.remove( indicator.layout );
				
				o.children.remove( indicator );
				o.children.remove( maskShape );
				o.children.remove( labelField );
			}
			
			indicator.dispose();
			maskShape.dispose();
			labelField.dispose();
			
			indicator	= null;
			maskShape	= null;
			labelField	= null;
		}
	}
	
	
	override public function validate (changes:Int)
	{
		if (changes.has( UIElementFlags.SOURCE ))
		{
			if (owner.source != null) {
				labelPrefix	= owner.source.type == CommunicationType.loading ? 'Laden: ' : 'Uploaden: ';
				update( owner.data.percentage, 0 );
			}
			else
			{
				labelPrefix = "";
				update( owner.data.percentage, 0 );
			}
		}
	}
	
	
	//
	// EVENTHANDLERS
	//
	
	private function update (newVal:Float, oldVal:Float)
	{
		label.value						= labelPrefix + (newVal * 100).roundFloat() + "%";
		indicator.layout.percentWidth	= newVal;
	//	trace(newVal);
	}
}