package ;

import IInsertStrategy.InsertBehaviour;


/**
 * Choose best node based on perimeter.
 * 
 * @author azrafe7
 */
class InsertStrategyPerimeter<T> implements IInsertStrategy<T>
{
	static var combinedAABB = new AABB();
	
	public function new() {}
	
	public function choose<T>(leafAABB:AABB, parent:AABBTreeNode<T>, ?extraData:Dynamic):InsertBehaviour
	{
		var left = parent.left;
		var right = parent.right;
		var perimeter = parent.aabb.getPerimeter();

		combinedAABB.asUnionOf(parent.aabb, leafAABB);
		var combinedPerimeter = combinedAABB.getPerimeter();

		// cost of creating a new parent for this node and the new leaf
		var costParent = 2 * combinedPerimeter;

		// minimum cost of pushing the leaf further down the tree
		var costDescend = 2 * (combinedPerimeter - perimeter);

		// cost of descending into left node
		combinedAABB.asUnionOf(leafAABB, left.aabb);
		var costLeft = combinedAABB.getPerimeter() + costDescend;
		if (!left.isLeaf()) {
			costLeft -= left.aabb.getPerimeter();
		}

		// cost of descending into right node
		combinedAABB.asUnionOf(leafAABB, right.aabb);
		var costRight = combinedAABB.getPerimeter() + costDescend;
		if (!right.isLeaf()) {
			costRight -= right.aabb.getPerimeter();
		}

		// break/descend according to the minimum cost
		if (costParent < costLeft && costParent < costRight) {
			return InsertBehaviour.PARENT;
		}

		// descend
		return costLeft < costRight ? InsertBehaviour.DESCEND_LEFT : InsertBehaviour.DESCEND_RIGHT;
	}
}