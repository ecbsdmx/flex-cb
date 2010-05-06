package eu.ecb.core.view
{
	import flash.events.Event;
	
	import org.sdmx.model.v2.structure.hierarchy.CodeAssociation;
	import org.sdmx.model.v2.structure.hierarchy.Hierarchy;
	
	public interface IHierarchicalView extends IView
	{
		/**
		 * @private
	     */
		function set hierarchy(h:Hierarchy):void;

		/**
		 * Hierarchy used by the view.
	     */
		function get hierarchy():Hierarchy;
		
		/**
		 * @private
	     */
		function set selectedHierarchyItem(assoc:CodeAssociation):void;

		/**
		 * Code of the item in the hierarchy to be used by the view.
	     */
		function get selectedHierarchyItem():CodeAssociation;
		
		/**
		 * Handles a drilldown action from user
		 */ 
		function handleDrillDown(event:Event):void;
	}
}