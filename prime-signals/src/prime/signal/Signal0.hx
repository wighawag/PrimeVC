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
 *  Danny Wilson	<danny @ onlinetouch.nl>
 */
package prime.signal;
  using prime.core.ListNode;
  using prime.signal.Wire;
  using prime.utils.BitUtil;
  using prime.utils.IfUtil;

 import haxe.macro.Expr;

/**
 * Signal with no arguments to send()
 * 
 * @author Danny Wilson
 * @creation-date Jun 09, 2010
 */
class Signal0 extends Signal<Void->Void>//, implements ISender0, implements INotifier<Void->Void>
{
	public function new() enabled = true
	
	@:macro
	public function send(#if macro e : Expr #end) : Expr {
		var sendExpr : Expr = haxe.macro.Context.parse('
		if (signal.enabled)
		{
			var w : prime.signal.Wire<Void->Void> = (untyped signal).n;
			
			while (w != null)
			{
				signal.nextSendable = (untyped w).n;
				
				Assert.that(w.isEnabled());
				Assert.notEqual(w, signal.nextSendable);
				Assert.notEqual(w.flags, 0);
				if (untyped(w.flags & prime.signal.Wire.SEND_ONCE))
					w.disable();
				
				w.handler();
				
				if (untyped(w.flags & prime.signal.Wire.SEND_ONCE))
					w.dispose();
				
				w = signal.nextSendable; // Next node
			}
		}', haxe.macro.Context.currentPos());
		//trace(sendExpr);

		return {expr : EBlock([
			{expr: EVars([
				{name: "signal", type: null, expr: e}
			]), pos: haxe.macro.Context.currentPos() },
			sendExpr
		]), pos: haxe.macro.Context.currentPos() }
	}
	
	public inline function bind           ( owner:Dynamic, handler:Void->Void )	return Wire.make(this, owner, handler, Wire.ENABLED)
	public inline function bindOnce       ( owner:Dynamic, handler:Void->Void )	return Wire.make(this, owner, handler, Wire.ENABLED | Wire.SEND_ONCE)
	public inline function bindDisabled   ( owner:Dynamic, handler:Void->Void )	return Wire.make(this, owner, cast handler, 0)
	public inline function observe        ( owner:Dynamic, handler:Void->Void )	return bind(owner, handler)
	public inline function observeOnce    ( owner:Dynamic, handler:Void->Void )	return bindOnce(owner, handler)
	public inline function observeDisabled( owner:Dynamic, handler:Void->Void )	return bindDisabled(owner, handler)
}