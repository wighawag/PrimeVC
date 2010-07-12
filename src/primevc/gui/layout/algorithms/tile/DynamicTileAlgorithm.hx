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
package primevc.gui.layout.algorithms.tile;
 import primevc.core.collections.ChainedListCollection;
 import primevc.core.collections.ChainedList;
 import primevc.core.collections.SimpleList;
 import primevc.core.geom.constraints.SizeConstraint;
 import primevc.core.geom.Box;
 import primevc.gui.layout.LayoutGroup;
 import primevc.gui.layout.algorithms.directions.Direction;
 import primevc.gui.layout.algorithms.directions.Horizontal;
 import primevc.gui.layout.algorithms.directions.Vertical;
 import primevc.gui.layout.algorithms.float.HorizontalFloatAlgorithm;
 import primevc.gui.layout.algorithms.float.VerticalFloatAlgorithm;
 import primevc.gui.layout.algorithms.tile.TileGroup;
 import primevc.gui.layout.algorithms.ILayoutAlgorithm;
 import primevc.gui.layout.LayoutClient;
 import primevc.gui.layout.LayoutFlags;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.IntUtil;
  using primevc.utils.TypeUtil;
 

/**
 * FixedTileAlgorithm will place a fixed number of tiles in one row or column.
 * DynamicTileAlgorithm will place as many tiles as possible in one row or 
 * column.
 * 
 * The amount of tiles in one row or column will be defined by the explicitWidth
 * and explicitHeight of the layoutgroup on which the algorithm is applied.
 * 
 * @creation-date	Jul 7, 2010
 * @author			Ruben Weijers
 */
class DynamicTileAlgorithm extends TileAlgorithmBase, implements ILayoutAlgorithm
{
	/**
	 * tileGroups is a TileGroup containing a reference to each TileGroup
	 * The tileGroups property is responsible for setting the correct x or y 
	 * position of each tilegroup.
	 * 
	 * tileGroups (TileGroup)
	 * 	-> children (ListCollection)
	 * 		-> tileGroup0 (TileGroup)
	 * 			-> children (ChainedList)
	 * 		-> tileGroup1 (TileGroup)
	 * 			-> children (ChainedList)
	 * 		-> etc.
	 */
	public var tileGroups (default, null)	: TileGroup < TileGroup < LayoutClient > >;
	/**
	 * HorizontalMap is a collection of the children properties of all tileGroups. 
	 * Defining them in a ChainedListCollection makes it easy to let the 
	 * children flow easily from one row to another.
	 * 
	 * map (ChainedListCollection)
	 * 		-> lists
	 * 			-> tileGroup0.children
	 * 			-> tileGroup1.children
	 * 		-> items
	 * 			-> tile0
	 * 			-> tile1
	 * 			-> ...
	 */
	private var tileCollection				: ChainedListCollection < LayoutClient > ;
	
	private var childSizeConstraint			: SizeConstraint;
	private var childAlgorithm				: ILayoutAlgorithm;
	private var childPadding				: Box;
	
	
	private function createTileMap ()
	{
		Assert.that( group.is( LayoutGroup ), "group should be an LayoutGroup" );
		
		childSizeConstraint			= new SizeConstraint();
		
		tileCollection				= cast new ChainedListCollection <LayoutClient>();
		tileGroups					= new TileGroup<TileGroup<LayoutClient>>();
		tileGroups.padding			= group.padding;
		tileGroups.sizeConstraint	= group.sizeConstraint;
		
		var children = group.children;
		
		if (startDirection == Direction.horizontal) {
			tileGroups.algorithm = verAlgorithm;
			if (group.padding != null)
				childPadding = new Box( 0, group.padding.left, 0, group.padding.right );
		} else {
			tileGroups.algorithm = horAlgorithm;
			if (group.padding != null)
				childPadding = new Box( group.padding.top, 0, group.padding.bottom, 0 );
		}
		
		addTileGroup();
		for (child in children)
			tileCollection.add(child);
	}
	
	
	private inline function addTileGroup (childList:ChainedList<LayoutClient> = null)
	{
		if (childList == null)
			childList = new ChainedList<LayoutClient>();
		
		var tileGroup				= new TileGroup<LayoutClient>( childList );
		var group					= group.as(LayoutGroup);
		tileGroup.algorithm			= childAlgorithm;
		tileGroup.padding			= childPadding;
		
		if (startDirection == Direction.horizontal)
		{
			if		(group.explicitWidth.isSet())		tileGroup.width = group.explicitWidth;
			else if	(childSizeConstraint != null)		tileGroup.sizeConstraint = childSizeConstraint;
#if debug	else	throw "group should have an explicitWidth/maxWidth to use the dynamic-tile-algorithm"; #end
		}
		else
		{
			if		(group.explicitHeight.isSet())		tileGroup.height = group.explicitHeight;
			else if	(childSizeConstraint != null)		tileGroup.sizeConstraint = childSizeConstraint;
#if debug	else	throw "group should have an explicitHeight/maxHeight to use the dynamic-tile-algorithm";	#end	
		}
		
		tileCollection.addList( childList );
		tileGroups.children.add( tileGroup );	
	}
	
	
	private inline function removeTileGroup (tileGroup:TileGroup<LayoutClient>)
	{
		tileCollection.removeList( cast tileGroup.children );
		tileGroups.children.remove( tileGroup );
		tileGroup.dispose();
	}
	
	
	private function updateMapsAfterRemove (client, pos) : Void
	{
		if (tileCollection == null)
			return;
		
		tileCollection.remove(client);
	}
	
	
	private function updateMapsAfterAdd (client:LayoutClient, pos:Int) : Void
	{
		if (tileCollection == null)
			return;
		
		//reset boundary properties
		client.bounds.left	= 0;
		client.bounds.top	= 0;
		tileCollection.add(client, pos);
	}
	
	
	private function updateMapsAfterMove (client, oldPos, newPos)
	{
		if (tileCollection == null)
			return;
		
		tileCollection.move(client, newPos, oldPos);
	}
	
	
	
	
	//
	// LAYOUT METHODS
	//
	
	
	override public function isInvalid (changes:Int) : Bool {
		return super.isInvalid(changes) || changes.has( LayoutFlags.SIZE_CONSTRAINT_CHANGED );
	}
	
	
	override public function measure () : Void
	{
		var group = group.as(LayoutGroup);
		
		//
		//create a new tile map if it removed
		//
		if (tileCollection == null)
			createTileMap();
		
		if (group.children.length == 0)
			return;
		
		//
		// APPLY CHANGES IN SIZE CONSTRAINT ALSO ON THE CHILDREN
		//
		if (group.changes.has(LayoutFlags.SIZE_CONSTRAINT_CHANGED))
		{
			if (group.sizeConstraint == null) {
				childSizeConstraint.reset();
			} else {
				if (startDirection == horizontal) {
					childSizeConstraint.width.min = group.sizeConstraint.width.min;
					childSizeConstraint.width.max = group.sizeConstraint.width.max;
				} else {
					childSizeConstraint.height.min = group.sizeConstraint.height.min;
					childSizeConstraint.height.max = group.sizeConstraint.height.max;
				}
				
				tileGroups.sizeConstraint = group.sizeConstraint;
			}
		}
		
		//resize all rows
		else if (group.changes.has(LayoutFlags.WIDTH_CHANGED) && startDirection == horizontal && group.explicitWidth.isSet())
			for (tileGroup in tileGroups)
				tileGroup.width = group.explicitWidth;
		
		//resize all columns
		else if (group.changes.has(LayoutFlags.HEIGHT_CHANGED) && startDirection == vertical && group.explicitHeight.isSet())
			for (tileGroup in tileGroups)
				tileGroup.height = group.explicitHeight;
		
		//
		// Check if children are added, removed or moved in the list
		//
		if (group.changes.has(LayoutFlags.LIST_CHANGED))
		{
			var groupItr = tileGroups.iterator();
			
			//check each tileGroup for changes in the list or in the width of the children
			for (tileGroup in groupItr)
			{
				var children:ChainedList<LayoutClient> = cast tileGroup.children;
				
				if (children.length == 0) {
				//	if (groupItr.hasNext())
					removeTileGroup( tileGroup );
					continue;
				}
				
				var hasNext = children.nextList != null;
				tileGroup.measure();
				
				if (!hasNext && children.nextList != null) {
					//A chained list is added by the previous measure method.
					//Create a tile group for the list.
					addTileGroup( children.nextList );
				}
			}
		}
		
		if (startDirection == horizontal)
			measureVertical();
		else
			measureHorizontal();
	}
	
	
	override public function measureHorizontal ()
	{
		tileGroups.measureHorizontal();
		setGroupWidth(tileGroups.width);
	}
	
	
	override public function measureVertical ()
	{
		tileGroups.measureVertical();
		setGroupHeight(tileGroups.height);
	}
	
	
	override private function invalidate (shouldbeResetted:Bool = true) : Void
	{
		if (shouldbeResetted) {
			tileCollection = null;
			tileGroups = null;
		}
		
		super.invalidate(shouldbeResetted);
	}
	
	
	override public function apply ()
	{
		for (row in tileGroups)
			row.validate();
	/*	
		if (group.padding != null) {
			if (startDirection == Direction.horizontal && horizontalDirection == Horizontal.left)
				tileGroups.x = group.padding.left;
		}*/
		tileGroups.validate();
	}
	
	
	
	//
	// SETTERS / GETTERS
	//
	
	
	override private function setStartDirection (v)
	{
		if (v != startDirection)
		{
			startDirection = v;
			if (startDirection == Direction.horizontal)
				childAlgorithm = new DynamicRowAlgorithm( horizontalDirection );
			else
				childAlgorithm = new DynamicColumnAlgorithm( verticalDirection );
			
			invalidate( true );
		}
		return v;
	}
	
	
	override private function setGroup (v)
	{
		if (group != v)
		{
			if (group != null) {
				if (tileGroups.padding == group.padding)
					tileGroups.padding = null;
				
				group.children.events.unbind(this);
			}
			
			v = super.setGroup(v);
			
			if (v != null) {
				updateMapsAfterAdd		.on( group.children.events.added, this );
				updateMapsAfterRemove	.on( group.children.events.removed, this );
				updateMapsAfterMove		.on( group.children.events.moved, this );
			}
		}
		return v;
	}
	
	
	override private function setHorizontalDirection (v:Horizontal)
	{
		if (v != horizontalDirection) {
			super.setHorizontalDirection(v);
			if (childAlgorithm != null && childAlgorithm.is(DynamicRowAlgorithm))
				childAlgorithm.as(DynamicRowAlgorithm).direction = v;
		}
		return v;
	}
	
	
	override private function setVerticalDirection (v:Vertical)
	{
		if (v != verticalDirection) {
			super.setVerticalDirection(v);
			if (childAlgorithm != null && childAlgorithm.is(DynamicColumnAlgorithm))
				childAlgorithm.as(DynamicColumnAlgorithm).direction = v;
		}
		return v;
	}
}



/**
 * Layout-algorithm which is only used for rows. It measures them and if there
 */
private class DynamicRowAlgorithm extends HorizontalFloatAlgorithm
{
	override public function measureHorizontal ()
	{
		var children:ChainedList<LayoutClient> = cast group.children;
		
		if ( group.changes.has(LayoutFlags.LIST_CHANGED) || group.changes.has(LayoutFlags.CHILDREN_INVALIDATED) )
		{
			var groupSize		= group.width;
			var fullChildNum	= -1;			//counter to count all the children that didn't fit in the group
			
			//TileGroups children are changed.
			//Check the group to see if the width is bigger then the maxWidth
			for (child in children)
			{
				//check if the child will still fit in this row
				if (fullChildNum >= 0 || groupSize < child.bounds.width)
				{
					//move child to the next list
					fullChildNum++;
					children.moveItemToNextList( child, fullChildNum );
				}
				else
				{
					//add child to row
					groupSize -= child.bounds.width;
				}
			}
			
			//try to add children from the next list to this lsit
			if (fullChildNum == -1 && children.nextList != null && children.nextList.length > 0)
			{
				for (child in children.nextList)
				{
					if (groupSize < child.bounds.width)
						break;
					
					children.nextList.remove(child);
					children.add( child );
					groupSize -= child.bounds.width;
				}
			}
		}
	}
}



private class DynamicColumnAlgorithm extends VerticalFloatAlgorithm
{
	override public function measureVertical ()
	{
		var children:ChainedList<LayoutClient> = cast group.children;
		
		if ( group.changes.has(LayoutFlags.LIST_CHANGED) || group.changes.has(LayoutFlags.CHILDREN_INVALIDATED) )
		{
			var groupSize		= group.height;
			var fullChildNum	= -1;				//counter to count all the children that didn't fit in the group
			
			//TileGroups children are changed.
			//Check the group to see if the width is bigger then the maxWidth
			for (child in children)
			{
				//check if the child will still fit in this row
				if (fullChildNum >= 0 || groupSize < child.bounds.height)
				{
					//move child to the next list
					fullChildNum++;
					children.moveItemToNextList( child, fullChildNum );
				}
				else
				{
					//add child to row
					groupSize -= child.bounds.height;
				}
			}

			//try to add children from the next list to this lsit
			if (fullChildNum == -1 && children.nextList != null && children.nextList.length > 0)
			{
				for (child in children.nextList)
				{
					if (groupSize < child.bounds.height)
						break;

					children.nextList.remove(child);
					children.add( child );
					groupSize -= child.bounds.height;
				}
			}
		}
	}
}