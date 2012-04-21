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
 import prime.bindable.collections.iterators.FastDoubleCellForwardIterator;
 import prime.bindable.collections.iterators.FastDoubleCellReversedIterator;
 import prime.core.events.ListChangeSignal;
 import prime.utils.DuplicateUtil;
  using prime.utils.NumberUtil;
 

/**
 *.IEditableList implementation as FastList. When this list is iterated it will
 * start with the first added item instead of the last added item as with
 * FastList.
 * 
 * @creation-date	Jun 29, 2010
 * @author			Ruben Weijers
 */
class SimpleList<T> implements IEditableList<T>
	#if (flash9 || cpp) ,implements haxe.rtti.Generic #end
{
	public var change		(default, null)		: ListChangeSignal<T>;
	public var beforeChange	(default, null)		: ListChangeSignal<T>;
	
	private var _length		: Int;
	public var length		(getLength, never)	: Int;
	/**
	 * Pointer to the first added cell
	 */
	public var first		(default, null)		: FastDoubleCell<T>;
	/**
	 * Pointer to the last added cell
	 */
	public var last			(default, null)		: FastDoubleCell<T>;
	
	
	public function new()
	{
		_length			= 0;
		change			= new ListChangeSignal();
		beforeChange	= new ListChangeSignal();
	}
	
	
	public function removeAll ()
	{
		if (_length > 0)
		{
			beforeChange.send( ListChange.reset );
			var cur = first;
			while (cur != null)
			{
				var tmp = cur;
				cur = cur.next;
				tmp.dispose();
			}
		
			first = last = null;
			_length = 0;
			change.send( ListChange.reset );
		}
	}
	
	
	public function dispose ()
	{
		if (change == null)
			return;
		
		removeAll();
		change.dispose();
		change = null;
	}
	
	
	public function clone () : IReadOnlyList<T>
	{
		var inst	= new SimpleList<T>();
		var length	= this.length;
		for (i in 0...length)
			inst.insertAt( getItemAt(i), i );
		
		return inst;
	}
	
	
	public function duplicate () : IReadOnlyList<T>
	{
		var inst	= new SimpleList<T>();
		var length	= this.length;
		for (i in 0...length)
			inst.insertAt( DuplicateUtil.duplicateItem( getItemAt(i) ), i );
		
		return inst;
	}
	
	
	public  inline function isEmpty()   : Bool          return length == 0
	private inline function getLength() : Int           return _length
	public function iterator()          : Iterator<T>   return forwardIterator()
	public function forwardIterator()   : IIterator<T>  return new FastDoubleCellForwardIterator<T>(first)
	public function reversedIterator()  : IIterator<T>  return new FastDoubleCellReversedIterator<T>(last)

	
	
	/**
	 * Returns the item at the given position. It is allowed to give negative values.
	 * The returned item will then be on position -> length - askedPosition
	 * 
	 * @param	pos
	 * @return
	 */
	public function getItemAt (pos:Int) : T {
		var cell = getCellAt(pos);
		return (cell != null) ? cell.data : null;
	}
	
	
	public function add (item:T, pos:Int = -1) : T
	{
		beforeChange.send( ListChange.added( item, pos ) );
		pos = insertAt( item, pos );
		change.send( ListChange.added( item, pos ) );
		return item;
	}
	
	
	public function remove (item:T, curPos:Int = -1) : T
	{
		if (item != null)
		{
			if (curPos == -1)	curPos = indexOf(item);
			if (curPos == -1)	return item;
			
			beforeChange.send( ListChange.removed( item, curPos ) );
			removeItem( item, curPos );
			change.send( ListChange.removed( item, curPos ) );
		}
		return item;
	}
	
	
	public function move (item:T, newPos:Int, curPos:Int = -1) : T
	{
		if		(curPos == -1)		curPos = indexOf( item );
		if		(newPos > length)	newPos = length;
		else if (newPos < 0)		newPos = length + newPos;
		
		if (curPos != newPos)
		{
			beforeChange.send( ListChange.moved( item, newPos, curPos ) );

			var cell = getCellAt( curPos );
			removeCell( cell );
			
			if (newPos == length || curPos > newPos)
				insertCellAt( cell, newPos );
			else
				insertCellAt( cell, (newPos - 1) );
			
			change.send( ListChange.moved( item, newPos, curPos ) );
		}
		return item;
	}
	
	
	public function indexOf (item:T) : Int
	{
		var cur = first;
		var pos = -1, foundPos = -1;
		while (cur != null && foundPos == -1)
		{
			pos++;
			if (cur.data == item)
				foundPos = pos;
			
			cur = cur.next;
		}
		return foundPos;
	}
	
	
	public inline function has (item:T) : Bool
		return indexOf(item) > -1
	
	
	/**
	 * Method does the same thing as the add method, except that it won't fire
	 * an 'added' event.
	 * 
	 * @param	item
	 * @param	pos
	 * @return	position where the cell is inserted
	 */
	public inline function insertAt (item:T, ?pos:Int = -1) : Int
		return insertCellAt( new FastDoubleCell<T>( item, null ), pos )


	private function insertCellAt( cell:FastDoubleCell<T>, ?pos:Int = -1) : Int
	{
		if (pos < 0 || pos > length)
			pos = length;

		if (pos == 0)
		{
			//add at beginning of list
			if (first != null)	cell.insertBefore( first );
			first = cell;
			if (last == null)	last = cell;
		}
		else if (pos == length)
		{
			//add at the end of the list
			cell.insertAfter( last );
			last = cell;
			Assert.that( cell.prev != null, "No previous cell for "+cell+" in "+this);
		}
		else
		{
			//insert item in the middle
			cell.insertBefore( getCellAt(pos) );

			Assert.isNotNull( cell.next, "No next cell for "+cell+" in "+this);
			Assert.isNotNull( cell.prev, "No previous cell for "+cell+" in "+this+"; next = "+cell.next);
			Assert.notEqual( cell.next, cell );
			Assert.notEqual( cell.prev, cell );
		}

		_length++;
		return pos;
	}
	
	
	private function getCellAt (pos:Int) : FastDoubleCell<T>
	{
		var currentCell:FastDoubleCell<T> = first;
		pos = pos < 0 ? length + pos : pos;
		
		if (pos == 0) 				return first;
		if (pos == (length - 1))	return last;
		
		//find out if it's faster to loop forward or backwards through the list
		if (pos < length.divFloor(2))
		{
			//loop forward through list
			for ( i in 0...pos )
				if (currentCell != null)
					currentCell = currentCell.next;
		}
		else
		{
			//loop backwards through list
			currentCell = last;
			pos = length - pos - 1;
			
			for ( i in 0...pos )
				if (currentCell != null)
					currentCell = currentCell.prev;
		}
		
		return currentCell;
	}
	
	
	/**
	 * Method does the same thing as the remove method, except that it won't fire
	 * an 'removed' event.
	 * 
	 * @param	item
	 * @return	last position of the item
	 */
	private inline function removeItem (item:T, curPos:Int = -1) : Int
	{
		if (curPos == -1)
			curPos = indexOf( item );
		
		if (curPos > -1)
		{
			var cell = getCellAt( curPos );
			if (cell != null)
				removeCell( cell );
		}	
		return curPos;
	}
	
	
	private function removeCell (cell:FastDoubleCell<T>)
	{
		if (cell == first)	first = cell.next;
		if (cell == last)	last = cell.prev;
		
		cell.remove();
		_length--;
	}
	
#if debug
	public var name : String;
	public function toString()
	{
		var items = [];
		var i = 0;
		for (item in this) {
			items.push( "[ " + i + " ] = " + item ); // Type.getClassName(Type.getClass(item)));
			i++;
		}
		return "\n\t" + name + "SimpleList ("+items.length+")\n\t\t\t" + items.join("\n\t\t\t");
	}
#end
}