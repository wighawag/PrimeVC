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
 import primevc.core.IDisposable;
 import primevc.gui.graphics.borders.IBorder;
 import primevc.gui.graphics.fills.IFill;
 import primevc.gui.styling.declarations.UIContainerStyle;
 import primevc.tools.generator.ICSSFormattable;
 import primevc.types.RGBA;
 import Hash;
#if debug
  using StringTools;
#end

#if neko
 import primevc.tools.generator.ICodeFormattable;
 import primevc.tools.generator.ICodeGenerator;
 import primevc.utils.StringUtil;
#end


/**
 * @author Ruben Weijers
 * @creation-date Aug 05, 2010
 */
class StyleContainer 
				implements IDisposable
			,	implements ICSSFormattable
#if neko	,	implements ICodeFormattable		#end
{
#if neko
	public var uuid					(default, null) : String;
#end
	
	public var typeSelectors		(default, null) : Hash < UIContainerStyle >;
	public var styleNameSelectors	(default, null) : Hash < UIContainerStyle >;
	public var idSelectors			(default, null) : Hash < UIContainerStyle >;
	
	public var globalFills			(default, null) : Hash < IFill >;
	public var globalBorders		(default, null) : Hash < IBorder<IFill> >;
	public var globalColors			(default, null) : Hash < RGBA >;
	
	
	public function new ()
	{
#if neko
		uuid = StringUtil.createUUID();
#end
		typeSelectors		= new Hash();
		styleNameSelectors	= new Hash();
		idSelectors			= new Hash();
		
		globalFills			= new Hash();
		globalBorders		= new Hash();
		globalColors		= new Hash();
		
		createGlobals();
		createTypeSelectors();
		createStyleNameSelectors();
		createIdSelectors();
	}
	
	
	public function dispose ()
	{
		typeSelectors		= null;
		styleNameSelectors	= null;
		idSelectors			= null;
	}
	
	
	private function createGlobals ()				: Void {}
	private function createTypeSelectors ()			: Void {} // Assert.abstract(); }
	private function createStyleNameSelectors ()	: Void {} // Assert.abstract(); }
	private function createIdSelectors ()			: Void {} // Assert.abstract(); }
	
	
#if (debug || neko)
	public function toString ()		{ return toCSS(); }
	
	
	public function isEmpty ()
	{
		return !idSelectors.iterator().hasNext() && !styleNameSelectors.iterator().hasNext() && !typeSelectors.iterator().hasNext();
	}
	

	public function toCSS (namePrefix:String = "")
	{
		var css = "";
		
		if (idSelectors.iterator().hasNext()) {
		//	css += "\n/** ID STYLES **/";
			css += hashToCSSString( namePrefix, idSelectors, "#" );
		}
		
		if (styleNameSelectors.iterator().hasNext()) {
		//	css += "\n\n/** CLASS STYLES **/";
			css += hashToCSSString( namePrefix, styleNameSelectors, "." );
		}
		
		if (typeSelectors.iterator().hasNext()) {
		//	css += "\n\n/** ELEMENT STYLES **/";
			css += hashToCSSString( namePrefix, typeSelectors, "" );
		}
		
		return css;
	}
	
	
	private  function hashToCSSString (namePrefix:String, hash:Hash<UIContainerStyle>, keyPrefix:String = "") : String
	{
		var css = "";
		var keys = hash.keys();
		while (keys.hasNext()) {
			var key = keys.next();
			var val = hash.get(key);
			var name = (namePrefix + " " + keyPrefix + key).trim();
			
			if (!val.isEmpty())
				css += "\n" + name + " " + val.toCSS( name );
			if (!val.children.isEmpty())
				css += "\n" + val.children.toCSS( name );
		}
		return css;
	}
#end

#if neko
	public function toCode (code:ICodeGenerator)
	{
		if (!isEmpty())
		{
			code.construct( this );
		
			var keys = typeSelectors.keys();
			for (key in keys)
				code.setAction(this, "typeSelectors.set", [ key, typeSelectors.get(key) ]);
		
			keys = styleNameSelectors.keys();
			for (key in keys)
				code.setAction(this, "styleNameSelectors.set", [ key, styleNameSelectors.get(key) ]);
		
			keys = idSelectors.keys();
			for (key in keys)
				code.setAction(this, "idSelectors.set", [ key, idSelectors.get(key) ]);
		}
	}
#end
}