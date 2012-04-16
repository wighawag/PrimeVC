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
package prime.binding.collections;
 import prime.binding.collections.iterators.IIterator;
 import prime.binding.collections.iterators.FastDoubleCellForwardIterator;
 import prime.binding.collections.iterators.FastDoubleCellReversedIterator;
 import prime.core.traits.IClonable;
 import prime.core.traits.IPrioritizable;
 import prime.core.traits.IDisposable;


/**
 * Priority list helps to manage all objects that implement IPrioritizable that apply on a stylesheet.
 * 
 * @author Ruben Weijers
 * @creation-date Oct 20, 2010
 */
class PriorityList <T:IPrioritizable>
						implements IDisposable
					,	implements IClonable<PriorityList<T>>
#if (flash9 || cpp)	,	implements haxe.rtti.Generic #end
{
	public var length		(default, null)		: Int;
	/**
	 * Pointer to the first added cell
	 */
	public var first		(default, null)		: FastDoubleCell<T>;
	/**
	 * Pointer to the last added cell
	 */
	public var last			(default, null)		: FastDoubleCell<T>;
	
	
	public function new ()				{ length = 0; }
	public function dispose ()			{ removeAll(); }
	public function iterator ()			: Iterator<T>	{ return forwardIterator(); }
	public function forwardIterator ()	: IIterator<T>	{ return new FastDoubleCellForwardIterator<T> (first); }
	public function reversedIterator ()	: IIterator<T>	{ return new FastDoubleCellReversedIterator<T> (last); }
	
	
	public function clone ()
	{
		var l = new PriorityList<T>();
		var cur = first;
		while (cur != null)
		{
			l.add( cur.data );
			cur = cur.next;
		}
		return l;
	}
	
	
	public function removeAll ()
	{
		var cur = first;
		while (cur != null)
		{
			var tmp = cur;
			cur = cur.next;
			tmp.dispose();
		}
		
		first = last = null;
		length = 0;
	}
	
	
	public function has (item:T)
	{
		if (item == null)
			return false;
		
		if (first == null && last == null)
			return false;
		
		if (last.data.getPriority() > item.getPriority())
			return false;
		
		var cur = first;
		while (cur != null)
		{
			if (cur.data == item)
				return true;
			
			cur = cur.next;
		}
		return false;
	}
	
	
	public function hasCell (cell:FastDoubleCell<T>)
	{
		if (first == null && last == null)
			return false;
		
		var cur = first;
		while (cur != null)
		{
			if (cur == cell)
				return true;
			
			cur = cur.next;
		}
		return false;
	}
	
	
	/**
	 * Method will add the given item on the correct position in the list. 
	 * The higher the priority, the earlier the position
	 */
	public function add ( item : T )
	{
		var cell	= new FastDoubleCell < T >( item );
		var isAdded	= false;
		
		if (first == null || last == null)
		{
			first	= last = cell;
			isAdded	= true;
		}
		
		//short cut for when the last priority is still bigger then the one of the new item
		if (!isAdded && last.data.getPriority() > item.getPriority() )
		{
			cell.insertAfter( last );
			last	= cell;
			isAdded	= true;
		}
		
		if (!isAdded)
		{
			var cur = first;
			while (cur != null && !isAdded)
			{
				if (cur.data.getPriority() <= item.getPriority())
				{
					cell.insertBefore( cur );
					if (first == cur)
						first = cell;
					
					isAdded = true;
				}
				
				cur = cur.next;
			}
		}
		
		if (!isAdded)
			return null;
		
		length++;
		return cell;
	}
	
	
	public function remove (item:T)
	{
		var cell = getCellForItem(item);
		if (cell != null)
			removeCell(cell);
	}
	
	
	
	public inline function addBefore (item:T, otherCell:FastDoubleCell<T>) : FastDoubleCell<T>
	{
		var cell = new FastDoubleCell<T>(item);
		length++;
		
		if (otherCell == first)
			first = cell;
		
		return cell.insertBefore( otherCell );
	}
	
	
	public inline function addAfter (item:T, otherCell:FastDoubleCell<T>) : FastDoubleCell<T>
	{
		var cell = new FastDoubleCell<T>(item);
		length++;
		
		if (otherCell == last)
			last = cell;
		
		return cell.insertAfter( otherCell );
	}
	
	
	/**
	 * Removes all items with the given priority
	 */
	public function removePriority (searchedPriority:Int)
	{
		var cur = first;
		while (cur != null)
		{
			//there are no more elements with a higher priority
			if (cur.data.getPriority() < searchedPriority)
				break;
			
			if (cur.data.getPriority() == searchedPriority)
			{
				var tmp = cur;
				cur	= cur.next;
				
				removeCell( tmp );
				tmp.dispose();
			}
			else {
				cur = cur.next;
			}
		}
	}
	
	
	public function removeCell (cell:FastDoubleCell < T >)
	{
		if (cell == first)	first = cell.next;
		if (cell == last)	last = cell.prev;
		
		cell.remove();
		length--;
	}
	
	
	/**
	 * returns the cell of the requested item
	 */
	public function getCellForItem (item:T) : FastDoubleCell < T >
	{
		var cur = first;
		while (cur != null)
		{
			if (cur.data == item)
				return cur;
			
			cur = cur.next;
		}
		return null;
	}
	
	
	/**
	 * returns the first cell with that has the given priority
	 */
	public function getCellWithPriority (priority:Int) : FastDoubleCell < T >
	{
		var cur = first;
		while (cur != null)
		{
			if (cur.data.getPriority() == priority)
				return cur;
			
			cur = cur.next;
		}
		return null;
	}
	
	
	public inline function hasPriority (priority:Int) : Bool
	{
		var cur = first;
		while (cur != null)
		{
			var curPrio = cur.data.getPriority();
			if (curPrio == priority)
				return true;
			
			if (curPrio < priority)
				return false;
			
			cur = cur.next;
		}
		return false;
	}
	
	
	public inline function getHighestPriority () : Int	{ return first != null ? first.data.getPriority() : 0; }
	public inline function getLowestPriority () : Int	{ return last != null ? last.data.getPriority() : 0; }
	
	
#if debug
	public var name : String;
	public function toString()
	{
		var items = [];
		var i = 0;
		for (item in this) {
			items.push( "[ " + i + " ] = " + item + " (" + item.getPriorityName()+ ")" ); // Type.getClassName(Type.getClass(item)));
			i++;
		}
		return name + "PriorityList ("+items.length+")\n" + items.join("\n");
	}
#end
}