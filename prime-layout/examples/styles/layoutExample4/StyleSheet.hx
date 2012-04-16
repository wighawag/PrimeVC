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
package ;
 import primevc.gui.styling.LayoutStyleFlags;
 import primevc.gui.styling.StyleChildren;
 import primevc.gui.styling.StyleBlockType;
 import primevc.gui.styling.StyleBlock;
 import primevc.types.Number;
 import primevc.core.geom.Box;
 import primevc.gui.graphics.fills.SolidFill;
 import primevc.gui.graphics.shapes.RegularRectangle;
 import primevc.gui.layout.algorithms.tile.SimpleTileAlgorithm;
 import primevc.gui.styling.GraphicsStyle;
 import primevc.gui.styling.LayoutStyle;
 import primevc.gui.styling.StatesStyle;
 import primevc.gui.styling.StyleBlock;
 import primevc.gui.styling.StyleBlockType;



/**
 * This class is a template for generating UIElementStyle classes
 */
class StyleSheet extends StyleBlock
{
	public function new ()
	{
		super(0, StyleBlockType.specific);
		elementChildren		= new ChildrenList();
		styleNameChildren	= new ChildrenList();
		idChildren			= new ChildrenList();
		
		
		var styleBlock0 = new StyleBlock(72, StyleBlockType.element, new GraphicsStyle(56, null, null, new RegularRectangle(), null, null, true, 1));
		this.elementChildren.set('primevc.gui.display.IDisplayObject', styleBlock0);
		var styleBlock1 = new StyleBlock(0x00081A, StyleBlockType.element, null, new LayoutStyle(8, null, null, null, function () { return new SimpleTileAlgorithm(); }));
		styleBlock1.setInheritedStyles(null, styleBlock0);
		var styleBlock2 = new StyleBlock(92, StyleBlockType.element, new GraphicsStyle(2, new SolidFill(0xFFAAAAFF)), new LayoutStyle(0x001003, null, null, new Box(20, 5, 20, 5), null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, 30, 50));
		styleBlock2.setInheritedStyles(null, null, styleBlock0, styleBlock1);
		var hash3 = new Hash();
		hash3.set('primevc.gui.display.IDisplayObject', styleBlock2);
		var styleBlock4 = new StyleBlock(0x00040A, StyleBlockType.element);
		styleBlock4.setInheritedStyles(null, styleBlock2, null, styleBlock1);
		var styleBlock5 = new StyleBlock(88, StyleBlockType.elementState, new GraphicsStyle(2, new SolidFill(0xEEAADDFF)), new LayoutStyle(3, null, null, null, null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, 80, 80));
		styleBlock5.setInheritedStyles(null, null, null, styleBlock4);
		var intHash6 = new IntHash();
		intHash6.set(2, styleBlock5);
		styleBlock4.states = new StatesStyle(2, intHash6);
		hash3.set('primevc.gui.core.UIComponent', styleBlock4);
		styleBlock1.setChildren(null, null, hash3);
		this.elementChildren.set('examples.layout.LayoutExample4', styleBlock1);
	}
}