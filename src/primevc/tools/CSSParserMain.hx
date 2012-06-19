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
package primevc.tools;
 import primevc.gui.styling.StyleBlock;
 import primevc.gui.styling.StyleFlags;
 import primevc.tools.generator.ICodeFormattable;
 import primevc.tools.generator.CodeGenerator;
  using primevc.tools.generator.output.HaxeOutputUtil;
  using primevc.utils.TypeUtil;



/**
 * Main class for compiling a css file to a haxe file.
 * 
 * @author Ruben Weijers
 * @creation-date Sep 15, 2010
 */
class CSSParserMain
{
	public static inline function print(v:String)
		#if nodejs 	js.Lib.print(v)
		#else 		neko.Lib.print(v+"\n") #end

	/**
	 * This script needs one parameter to run: the location of the skin folder
	 */
	public static function main ()
	{
		var args:Array<String> = 
			#if js 	js.Node.process.argv;
			#else 	Sys.args(); #end
#if js 	args.shift(); args.shift(); #end
		if (args.length == 0)	throw "Skin folder location is needed to run this script.";
		
		var timer = new StopWatch().start();
		var primevcDir = "src/primevc";
		if (args.length == 2)
			primevcDir = args[1] + "/" + primevcDir;
		
		var css = new CSSParserMain( args[0], primevcDir );
		css.parse();
		css.generateCode();
		css.flush();
		print("\t" + Date.now() + " - " + timer.stop() + " ms - Done!");
	}
	
	
	private var timer		: StopWatch;
	private var styles		: StyleBlock;
	private var parser		: CSSParser;
	private var generator	: CodeGenerator;
	private var manifest	: Manifest;
	
	private var template	: String;
	private var skinFolder	: String;
	
	
	public function new (skin:String, primevcDir:String)
	{
		skinFolder	= skin;
		timer		= new StopWatch();
		styles		= new StyleBlock(null);
		manifest	= new Manifest(); // skinFolder + "/manifest.xml" );
		parser		= new CSSParser( styles, manifest );
		generator	= new CodeGenerator();
		generator.instanceIgnoreList.set( styles._oid, styles );
		
		var tplName = primevcDir + "/tools/StyleSheet.tpl.hx";
		if (#if nodejs !js.Node.path.existsSync(tplName) #else !sys.FileSystem.exists( tplName ) #end)
			throw "Template does not exist! "+tplName;
		
		template = #if nodejs Std.string(js.Node.fs.readFileSync(tplName)); #else sys.io.File.getContent(tplName); #end
	}
	
	
	public function parse ()
	{
		beginTimer();
		parser.parse( skinFolder + "/Style.css", ".." );
		stopTimer("Parsing: " + skinFolder + "/Style.css");
	}
	
	
	public function generateCode ()
	{
	//	print(Date.now() + " Generating code");
		
		generator.start();
		if (styles.has( StyleFlags.ELEMENT_CHILDREN ))			generateSelectorCode( cast styles.elementChildren, "elementChildren" );
		if (styles.has( StyleFlags.STYLE_NAME_CHILDREN ))		generateSelectorCode( cast styles.styleNameChildren, "styleNameChildren" );
		if (styles.has( StyleFlags.ID_CHILDREN ))				generateSelectorCode( cast styles.idChildren, "idChildren" );
		
		//write to template
		setTemplateVar( "imports",   generator.imports.writeImports() );
		setTemplateVar( "selectors", generator.values.writeValues() );
		
		generator.flush();
	}
	
	
	private function setTemplateVar (varName:String, replacement:StringBuf) : Void
	{
		beginTimer();
		varName = "//" + varName;
		var pos = template.indexOf( varName );
		
		if (pos == -1)
			return;
		
		var begin	= template.substr( 0, pos );
		pos += varName.length;
		var end 	= template.substr( pos );
		template	= begin + replacement.toString() + end;
		stopTimer( "write "+varName );
	}
	
	
	public function flush ()
	{
		beginTimer();
		//write haxe code
#if nodejs
		js.Node.fs.writeFileSync(skinFolder + "/StyleSheet.hx", template);
#else 	var output = sys.io.File.write( skinFolder + "/StyleSheet.hx", false );
		output.writeString( template );
		output.close();
#end
		stopTimer(" Writing code to " + skinFolder + "/StyleSheet.hx");
	}
	
	
	
	private function generateSelectorCode (selectorHash:Hash<ICodeFormattable>, name:String) : Void
	{
		Assert.notNull(selectorHash);
		beginTimer();
		var i = 0;
		for (key in selectorHash.keys()) {
			var val = selectorHash.get(key);
			if (!val.isEmpty()) {
				generator.setSelfAction( name + ".set", [ key, val ] );
				i++;
			}
		}
		stopTimer("generate "+name+" ("+i+")");
	}
	
	
	private inline function beginTimer ()	timer.start()
	private inline function stopTimer (name:String)
	{
		timer.stop();
		print("\t" + Date.now() + " - " + timer.currentTime + " ms - " + name);
		timer.reset();
	//	print(Date.now() +" - "+name);
	}
}