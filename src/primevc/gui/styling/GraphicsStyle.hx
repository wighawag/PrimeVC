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
package primevc.gui.styling;
#if neko
 import primevc.tools.generator.ICodeGenerator;
 import primevc.types.Reference;
  using primevc.types.Reference;
#end
 import primevc.core.geom.Corners;
 import primevc.core.traits.IInvalidatable;
 import primevc.gui.core.ISkin;
 import primevc.gui.graphics.borders.IBorder;
 import primevc.gui.graphics.shapes.IGraphicShape;
 import primevc.gui.graphics.IGraphicProperty;
 import primevc.types.Bitmap;
 import primevc.types.Number;
  using primevc.utils.BitUtil;
  using primevc.utils.NumberUtil;


private typedef Flags = GraphicFlags;


/**
 * Style-sub-block containing all the graphic/visual properties for an element.
 * 
 * @author Ruben Weijers
 * @creation-date Oct 25, 2010
 */
class GraphicsStyle extends StyleSubBlock
{
	private var extendedStyle	: GraphicsStyle;
	private var superStyle		: GraphicsStyle;
	
#if neko	
	private var _shape			: Reference;
	private var _skin			: Reference;
	private var _overflow		: Reference;
#else	
	private var _shape			: IGraphicShape;
	private var _skin			: Class < ISkin >;
	private var _overflow		: Class < Dynamic >;
#end
	private var _opacity		: Float;
	private var _visible		: Null < Bool >;
	private var _icon			: Bitmap;
	private var _background		: IGraphicProperty;
	private var _border			: IBorder;
	private var _borderRadius	: Corners;
	
	
#if neko	
	public var shape		(getShape,			setShape)			: Reference;
	public var skin			(getSkin,			setSkin)			: Reference;
	public var overflow		(getOverflow,		setOverflow)		: Reference;
#else	
	public var shape		(getShape,			setShape)			: IGraphicShape;
	public var skin			(getSkin,			setSkin)			: Class < ISkin >;
	public var overflow		(getOverflow,		setOverflow)		: Class < Dynamic >;
#end
	public var opacity		(getOpacity,		setOpacity)			: Float;
	public var visible		(getVisible,		setVisible)			: Null< Bool >;
	public var icon			(getIcon,			setIcon)			: Bitmap;
	public var background	(getBackground, 	setBackground)		: IGraphicProperty;
	public var border		(getBorder,			setBorder)			: IBorder;
	public var borderRadius	(getBorderRadius,	setBorderRadius)	: Corners;
	
	
	
	public function new (
		background	: IGraphicProperty = null,
		border		: IBorder = null,
#if neko		
		shape		: Reference = null,
		skin		: Reference = null,
		overflow	: Reference = null,
#else		
		shape		: IGraphicShape = null,
		skin		: Class< ISkin > = null,
		overflow	: Class < Dynamic > = null,
#end
		visible		: Null < Bool > = null,
		opacity		: Float = Number.INT_NOT_SET,
		icon		: Bitmap = null,
		borderRadius: Corners = null)
	{
		super();
		
		this.shape			= shape;
		this.background		= background;
		this.border			= border;
		this.skin			= skin;
		this.visible		= visible;
		this.opacity		= opacity != Number.INT_NOT_SET ? opacity : Number.FLOAT_NOT_SET;
		this.icon			= icon;
		this.overflow		= overflow;
		this.borderRadius	= borderRadius;
	}
	
	
	override public function dispose ()
	{
		extendedStyle = superStyle = null;
		
	//	if (_skin != null)			_skin.dispose();
		if (_background != null)	_background.dispose();
		if (_border != null)		_border.dispose();
#if !neko
		if (_shape != null)			_shape.dispose();
		if (_icon != null)			_icon.dispose();
#end
		
		_skin			= null;
		_shape			= null;
		_background		= null;
		_border			= null;
		_icon			= null;
		_overflow		= null;
		_visible		= null;
		_borderRadius	= null;
		_opacity		= Number.FLOAT_NOT_SET;
		
		super.dispose();
	}
	
	
	override private function updateOwnerReferences (changedReference:Int) : Void
	{
		if (changedReference.has( StyleFlags.EXTENDED_STYLE ))
		{
			if (extendedStyle != null)
				extendedStyle.listeners.remove( this );
			
			extendedStyle = null;
			if (owner != null && owner.extendedStyle != null)
			{
				extendedStyle = owner.extendedStyle.graphics;
				
				if (extendedStyle != null)
					extendedStyle.listeners.add( this );
			}
		}
		
		
		if (changedReference.has( StyleFlags.SUPER_STYLE ))
		{
			if (superStyle != null)
				superStyle.listeners.remove( this );
			
			superStyle = null;
			if (owner != null && owner.superStyle != null)
			{
				superStyle = owner.superStyle.graphics;
				
				if (superStyle != null)
					superStyle.listeners.add( this );
			}
		}
	}
	
	
	override public function updateAllFilledPropertiesFlag ()
	{
		super.updateAllFilledPropertiesFlag();
		
		if (allFilledProperties < Flags.ALL_PROPERTIES && extendedStyle != null)	allFilledProperties |= extendedStyle.allFilledProperties;
		if (allFilledProperties < Flags.ALL_PROPERTIES && superStyle != null)		allFilledProperties |= superStyle.allFilledProperties;
	}
	
	
	/**
	 * Method is called when a property in the super- or extended-style is 
	 * changed. If the property is not set in this style-object, it means that 
	 * the allFilledPropertiesFlag needs to be changed..
	 */
	override public function invalidateCall ( changeFromOther:Int, sender:IInvalidatable ) : Void
	{
		Assert.that(sender != null);
		
		if (sender == owner)
			return super.invalidateCall( changeFromOther, sender );
		
		if (filledProperties.has( changeFromOther ))
			return;
		
		//The changed property is not in this style-object.
		//Check if the change should be broadcasted..
		var propIsInExtended	= extendedStyle != null	&& extendedStyle.allFilledProperties.has( changeFromOther );
		var propIsInSuper		= superStyle != null	&& superStyle	.allFilledProperties.has( changeFromOther );
		
		if (sender == extendedStyle)
		{
			if (propIsInExtended)	allFilledProperties = allFilledProperties.set( changeFromOther );
			else					allFilledProperties = allFilledProperties.unset( changeFromOther );
			
			invalidate( changeFromOther );
		}
		
		//if the sender is the super style and the extended-style doesn't have the property that is changed, broadcast the change as well
		else if (sender == superStyle && !propIsInExtended)
		{
			if (propIsInSuper)		allFilledProperties = allFilledProperties.set( changeFromOther );
			else					allFilledProperties = allFilledProperties.unset( changeFromOther );
			
			invalidate( changeFromOther );
		}
		
		return;
	}
	
	
	
	//
	// GETTERS
	//
	
	
	private function getSkin ()
	{
		var v = _skin;
		if (v == null && extendedStyle != null)		v = extendedStyle.skin;
		if (v == null && superStyle != null)		v = superStyle.skin;
		return v;
	}
	
	
	private function getShape ()
	{
		var v = _shape;
		if (v == null && extendedStyle != null)		v = extendedStyle.shape;
		if (v == null && superStyle != null)		v = superStyle.shape;
		return v;
	}
	

	private function getBackground ()
	{
		var v = _background;
		if (v == null && extendedStyle != null)		v = extendedStyle.background;
		if (v == null && superStyle != null)		v = superStyle.background;
		return v;
	}


	private function getBorder ()
	{
		var v = _border;
		if (v == null && extendedStyle != null)		v = extendedStyle.border;
		if (v == null && superStyle != null)		v = superStyle.border;
		return v;
	}
	
	
	private function getVisible ()
	{
		var v = _visible;
		if (v == null && extendedStyle != null)		v = extendedStyle.visible;
		if (v == null && superStyle != null)		v = superStyle.visible;
		return v;
	}


	private function getOpacity ()
	{
		var v = _opacity;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.opacity;
		if (v.notSet() && superStyle != null)		v = superStyle.opacity;
		return v;
	}
	

	private function getIcon ()
	{
		var v = _icon;
		if (v == null && extendedStyle != null)		v = extendedStyle.icon;
		if (v == null && superStyle != null)		v = superStyle.icon;
		return v;
	}
	

	private function getOverflow ()
	{
		var v = _overflow;
		if (v == null && extendedStyle != null)		v = extendedStyle.overflow;
		if (v == null && superStyle != null)		v = superStyle.overflow;
		return v;
	}
	

	private function getBorderRadius ()
	{
		var v = _borderRadius;
		if (v == null && extendedStyle != null)		v = extendedStyle.borderRadius;
		if (v == null && superStyle != null)		v = superStyle.borderRadius;
		return v;
	}
	
	
	
	
	//
	// SETTERS
	//
	
	private function setSkin (v)
	{
		if (v != _skin) {
			_skin = v;
			markProperty( Flags.SKIN, v != null );
		}
		return v;
	}


	private function setShape (v)
	{
		if (v != _shape) {
			_shape = v;
			markProperty( Flags.SHAPE, v != null );
		}
		return v;
	}
	
	
	private function setBackground (v)
	{
		if (v != _background) {
			_background = v;
			markProperty( Flags.BACKGROUND, v != null );
		}
		return v;
	}


	private function setBorder (v)
	{
		if (v != _border) {
			_border = v;
			markProperty( Flags.BORDER, v != null );
		}
		return v;
	}
	
	
	private function setVisible (v)
	{
		if (v != _visible) {
			_visible = v;
			markProperty( Flags.VISIBLE, v != null );
		}
		return v;
	}
	
	
	private function setOpacity (v)
	{
		if (v != _opacity) {
			_opacity = v;
			markProperty( Flags.OPACITY, v.isSet() );
		}
		return v;
	}
	
	
	private function setIcon (v)
	{
		if (v != _icon) {
			_icon = v;
			markProperty( Flags.ICON, v != null );
		}
		return v;
	}
	
	
	private function setOverflow (v)
	{
		if (v != _overflow) {
			_overflow = v;
			markProperty( Flags.OVERFLOW, v != null );
		}
		return v;
	}
	
	
	private function setBorderRadius (v)
	{
		if (v != _borderRadius) {
			_borderRadius = v;
			markProperty( Flags.BORDER_RADIUS, v != null );
		}
		return v;
	}
	
	
	
	
#if neko
	override public function toCSS (prefix:String = "")
	{
		var css = [];
		if (_skin != null)			css.push("skin: " + _skin.toCSS() );
		if (_shape != null)			css.push("shape: " + _shape.toCSS() );
		if (_background != null)	css.push("background: " + _background.toCSS() );
		if (_border != null)		css.push("border: "+ _border.toCSS() );
		if (_visible != null)		css.push("visability: "+ _visible );
		if (_opacity.isSet())		css.push("opacity: "+ _opacity );
		if (_icon != null)			css.push("icon: "+ _icon );
		if (_overflow != null)		css.push("overflow: "+ _overflow.toCSS() );
		if (_borderRadius != null)	css.push("border-radius: "+ _borderRadius );
		
		if (css.length > 0)
			return "\n\t" + css.join(";\n\t") + ";";
		else
			return "";
	}
	
	
	override public function toCode (code:ICodeGenerator)
	{
		if (!isEmpty())
			code.construct( this, [ _background, _border, _shape, _skin, _overflow, _visible, _opacity, _icon, _borderRadius ] );
	}
	
	
	override public function cleanUp ()
	{
		if (_background != null)
		{
			_background.cleanUp();
			if (_background.isEmpty()) {
				_background.dispose();
				background = null;
			}
		}
		
		if (_border != null)
		{
			_border.cleanUp();
			if (_border.isEmpty()) {
				_border.dispose();
				border = null;
			}
		}
	#if !neko
		if (_shape != null)
		{
			_shape.cleanUp();
			if (_shape.isEmpty()) {
				_shape.dispose();
				shape = null;
			}
		}
		
		if (_icon != null)
		{
			_icon.cleanUp();
			if (_icon.isEmpty()) {
				_icon.dispose();
				icon = null;
			}
		}
	#end
	}
#end

#if debug
	override public function readProperties (flags:Int = -1) : String
	{
		if (flags == -1)
			flags = filledProperties;

		return Flags.readProperties(flags);
	}
#end
}