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
 *  Ruben Weijers	<ruben @ prime.vc>
 */
package prime.bindable.collections;


private typedef OldPos = Int;
private typedef NewPos = Int;


/**
 * @author			Ruben Weijers
 * @creation-date	Oct 26, 2010
 */
enum ListChange <T>
{
	added ( item:T, newPos:NewPos );
	removed ( item:T, oldPos:OldPos );
	moved ( item:T, newPos:NewPos, oldPos:OldPos );
	reset;
}

extern class ListChangeUtil
{
	static inline public function undoListChange<T>(list:IEditableList<T>, change:ListChange<T>) : Void
		switch (change) {
			case added(item, newPos):			list.remove(item);
			case removed(item, oldPos):			list.add( item, oldPos );
			case moved(item, newPos, oldPos):	list.move( item, oldPos, newPos );
			default:							//what to do with a reset :-S
		}

	static public inline function redoListChange<T>(list:IEditableList<T>, change:ListChange<T>) : Void
		switch (change) {
			case added(item, newPos):			list.add(item, newPos);
			case removed(item, oldPos):			list.remove( item, oldPos );
			case moved(item, newPos, oldPos):	list.move( item, newPos, oldPos );
			default:							//what to do with a reset :-S
		}
}