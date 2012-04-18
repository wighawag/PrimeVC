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
 import prime.bindable.collections.iterators.IIterator;
 import prime.core.events.ListChangeSignal;

/**
 * @author Ruben Weijers
 * @creation-date Nov 16, 2010
 */
interface IReadOnlyList<T>
	  implements prime.core.traits.IClonable<IReadOnlyList<T> >
	, implements prime.core.traits.IDuplicatable<IReadOnlyList<T> >
	, implements prime.core.traits.IDisposable
#if prime_data, implements prime.core.traits.IValueObject #end
{
	public var change		(default, null)									: ListChangeSignal<T>;
	/**
	 * TODO - Ruben sep 5, 2011:
	 * Maybe combine change and beforeChange to one Signal2 that has an extra parameter
	 * to indicate if the change is before or after applying the change..
	 */
//	public var beforeChange	(default, null)									: ListChangeSignal<T>;
	public var length		(getLength, never)								: Int;
	
	/**
	 * Method will check if the requested item is in this collection
	 * @param	item
	 * @return	true if the item is in the list, otherwise false
	 */
	public function has		(item:T)									: Bool;
	
	/**
	 * Method will return the index of the requested item or -1 of the item is 
	 * not in the list.
	 * @param	item
	 * @return	position of the requested item
	 */
	public function indexOf	(item:T)									: Int;
	
	
	//
	// ITERATION METHODS
	//
	
	public function getItemAt (pos:Int)		: T;
	public function iterator ()				: Iterator<T>;
	public function forwardIterator ()		: IIterator<T>;
	public function reversedIterator ()		: IIterator<T>;
	
	
#if debug
	public var name : String;
#end
}