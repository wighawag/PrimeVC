/******************************************************************************
 * Shamelessly copied from the Caffeine-hx project and expanded a bit.        *
 * (thanks guys!)                                                             *
 ******************************************************************************
 * 
 * Copyright (c) 2011, The Caffeine-hx project contributors
 * Original author: Russell Weir
 * Contributors: Danny Wilson
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
 * THIS SOFTWARE IS PROVIDED BY THE CAFFEINE-HX PROJECT CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE CAFFEINE-HX PROJECT CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
 * THE POSSIBILITY OF SUCH DAMAGE.
 */

import haxe.macro.Expr;
import haxe.macro.Context;
 using Type;

/**
 * A class of basic assertions macros that only generate code when the -debug
 * flag is used on the haxe compiler command line.
 **/
#if !macro extern #end class Assert {
	#if macro static private var emptyExpr = Context.makeExpr(null, Context.currentPos()); #end
	/**
	* Asserts that expected is equal to actual
	* @param expected Any expression that can test against actual
	* @param actual Any expression that can test againt expected
	**/
	@:macro public static function  isEqual( expected : Expr, actual : Expr ) : Expr return buildCompareAssert(expected, OpNotEq, actual)
	@:macro public static function notEqual( expected : Expr, actual : Expr ) : Expr return buildCompareAssert(expected, OpEq, actual)

	#if macro private static function buildCompareAssert( expected:Expr, assertCompareOp:Binop, actual:Expr ) : Expr {
		if(!Context.defined("debug"))
			return emptyExpr;
		var pos = Context.currentPos();
		return
		{ expr : EIf(
			{ expr : EBinop(
				assertCompareOp,
				expected,
				actual),
			pos : pos},
			{ expr : EThrow(
				{ expr : ENew(
					{
						sub : null,
						name : "FatalException",
						pack : ["chx", "lang"],
						params : []
					},
					[
						{ expr : EBinop(OpAdd,
							{ expr : EConst(CString("Assertion failed. Expected " + (switch(assertCompareOp){
								case OpEq:	"not ";
								case OpGt:	"< ";
								case OpGte:	"<= ";
								case OpLt:	"> ";
								case OpLte:	">= ";
								default: ""; }))), pos : pos },
							{ expr : EBinop(
								OpAdd,
								{ expr : ECall({ expr : EField({ expr : EConst(CType("Std")), pos : pos },"string"),pos : pos },[expected]), pos : pos },
								{ expr : EBinop(OpAdd, { expr : EConst(CString(". Got ")), pos : pos }, { expr : ECall({ expr : EField({ expr : EConst(CType("Std")), pos : pos },"string"), pos : pos },[actual]), pos : pos }), pos:pos}
								),
							pos : pos
							}),
						pos : pos
						}
					]),
				pos : pos }),
			pos : pos },
			null),
		pos : pos };
	}
	#end

	/**
	* Asserts that expr evaluates to true
	* @param expr An expression that evaluates to a Bool
	**/
	@:macro public static function that( expr:Expr, ?message:ExprRequire<String> ) : Expr   return isTrue_impl(expr, message)

	/**
	* Asserts that expr evaluates to true
	* @param expr An expression that evaluates to a Bool
	**/
	@:macro public static function isTrue( expr:Expr, ?message:ExprRequire<String> ) : Expr return isTrue_impl(expr)

	#if macro public static function isTrue_impl( expr:Expr, ?message:ExprRequire<String> ) : Expr {
		if(!Context.defined("debug"))
			return emptyExpr;
		var pos = Context.currentPos();
		return
		{ expr : EIf(
			{ expr : EBinop(
				OpNotEq,
				{ expr : EConst(CIdent("true")), pos : pos },
				expr),
			pos : pos},
			{ expr : EThrow(
				{ expr : ENew(
					{
						sub : null,
						name : "FatalException",
						pack : ["chx", "lang"],
						params : []
					},
					[
						message != null? message : { expr : EConst(CString("Assertion failed. Expected "+ #if thx thx.macro.Macros.stringOfExpr(expr) #else "" #end +" but was false")), pos : pos }
					]),
				pos : pos }),
			pos : pos },
			null),
		pos : pos };
	}
	#end

	/**
	* Asserts that expr evaluates to false
	* @param expr An expression that evaluates to a Bool
	**/
	@:macro public static function not( expr:Expr ) : Expr     return isFalse_impl(expr)

	/**
	* Asserts that expr evaluates to false
	* @param expr An expression that evaluates to a Bool
	**/
	@:macro public static function isFalse( expr:Expr ) : Expr return isFalse_impl(expr)

	#if macro private static function isFalse_impl( expr:Expr ) : Expr {
		if(!Context.defined("debug"))
			return emptyExpr;
		var pos = Context.currentPos();
		return
		{ expr : EIf(
			{ expr : EBinop(
				OpNotEq,
				{ expr : EConst(CIdent("false")), pos : pos },
				expr),
			pos : pos},
			{ expr : EThrow(
				{ expr : ENew(
					{
						sub : null,
						name : "FatalException",
						pack : ["chx", "lang"],
						params : []
					},
					[
						{ expr : EConst(CString("Assertion failed. Expected false but was true")), pos : pos }
					]),
				pos : pos }),
			pos : pos },
			null),
		pos : pos };
	}
	#end

	/**
	* Checks that the passed expression is not null.
	* @param expr A string, class or anything that can be tested for null
	**/
	@:macro public static function isNull   ( expr:Expr, ?message:ExprRequire<String> ) : Expr return compareNull(expr, OpNotEq, message)
	@:macro public static function isNotNull( expr:Expr, ?message:ExprRequire<String> ) : Expr return compareNull(expr, OpEq,    message)

	#if macro private static function compareNull( expr:Expr, assertCompareOp:Binop, message:Expr ) : Expr {
		if(!Context.defined("debug"))
			return emptyExpr;
		var pos = Context.currentPos();
		return
		{ expr : EIf(
			{ expr : EBinop(
				assertCompareOp,
				{ expr : EConst(CIdent("null")), pos : pos },
				expr),
			pos : pos},
			{ expr : EThrow(
				{ expr : ENew(
					{
						sub : null,
						name : "FatalException",
						pack : ["chx", "lang"],
						params : []
					},
					[
						message != null? message : { expr : EConst(CString("Assertion failed. Expected "+ (assertCompareOp == OpEq? "non " : "") +"null value")), pos : pos }
					]),
				pos : pos }),
			pos : pos },
			null),
		pos : pos };
	}
	#end

	//
	// Prime additions
	//

	static inline public function isType(var1:Dynamic, type:Class<Dynamic>, ?pos:haxe.PosInfos) : Void
	{
#if debug
		Assert.isNotNull( var1, "To check the type of a variable it can't be null." );
		Assert.isNotNull( type, "The type of a variable can't be null." );
		Assert.that( Std.is(var1, type), "var of type '" + Type.getClass(var1).getClassName() + "' should be of type '" + type.getClassName() + "'" );
#end
	}

	static inline public function abstract	(msg:String = "", ?pos:haxe.PosInfos) : Void {
		#if debug sendError("Abstract method", msg, pos); #end
	}

	static inline private function sendError (error:String, msg:Dynamic, pos:haxe.PosInfos) : Void
	{
#if debug
		var className = pos.className.split(".").pop();
		var s = className + "." + pos.methodName + "()::" + pos.lineNumber + ": "+error + "; msg: " + Std.string(msg);
		trace(s);
	//#if flash9
	//	throw new Error(s);
	//#else
		throw s;
	//#end
#end
	}
}