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
 import primevc.core.Bindable;
 import primevc.gui.core.UIDataContainer;
 import primevc.gui.styling.IIconOwner;
 import primevc.gui.text.TextFormat;
 import primevc.gui.traits.ITextStylable;
 import primevc.types.Bitmap;


private typedef DataType	= Bindable<String>;
private typedef Flags		= primevc.gui.core.UIElementFlags;


/**
 * Button component
 * 
 * @author Ruben Weijers
 * @creation-date Oct 29, 2010
 */
class Button extends UIDataContainer <DataType>, implements IIconOwner, implements ITextStylable
{
	public var icon			(default, setIcon)		: Bitmap;
#if flash9
	public var textStyle	(default, setTextStyle)	: TextFormat;
	public var wordWrap		: Bool;
#end
	
	
	public function new (id:String = null, value:String = null, icon:Bitmap = null)
	{
		super(id, new DataType(value));
		this.icon = icon;
	}
	
	
	private inline function setIcon (v:Bitmap)
	{
		if (v != icon) {
			icon = v;
			invalidate( Flags.ICON );
		}
		return v;
	}
	
	
#if flash9
	private inline function setTextStyle (v:TextFormat)
	{
		if (v != textStyle) {
			textStyle = v;
			invalidate( Flags.TEXTSTYLE );
		}
		return v;
	}
#end
}