package org.sdmx.stores.xml.v2.structure.keyfamily
{
	import mx.collections.ArrayCollection;
	
	import org.sdmx.model.v2.base.SDMXArtefact;
	import org.sdmx.model.v2.base.structure.Component;
	import org.sdmx.model.v2.reporting.provisioning.ContentConstraint;
	import org.sdmx.model.v2.reporting.provisioning.CubeRegion;
	import org.sdmx.model.v2.reporting.provisioning.CubeRegionsCollection;
	import org.sdmx.model.v2.reporting.provisioning.MemberSelection;
	import org.sdmx.model.v2.reporting.provisioning.MemberSelectionsCollection;
	import org.sdmx.model.v2.structure.concept.Concept;
	import org.sdmx.stores.xml.v2.structure.ISDMXExtractor;

	public class ConstraintExtractor implements ISDMXExtractor
	{
		/*==============================Fields================================*/
				
		private namespace structure21 = 
			"http://www.sdmx.org/resources/sdmxml/schemas/v2_1/structure";		
		use namespace structure21;
		
		private namespace common21 = 
			"http://www.sdmx.org/resources/sdmxml/schemas/v2_1/common";		
		use namespace common21;
		
		/*===========================Constructor==============================*/
		
		public function ConstraintExtractor()
		{
			super();
		}

		/*==========================Public methods============================*/
		
		/**
		 * @inheritDoc
		 */
		public function extract(items:XML):SDMXArtefact
		{
			var constraint:ContentConstraint;
			//Fetching constraints (works only with cube regions for now)
			if (items.CubeRegion.length() > 0) {
				constraint = new ContentConstraint(items.@id);
				var cubeCollection:CubeRegionsCollection = 
					new CubeRegionsCollection();
				for each (var cube:XML in items.CubeRegion) {
					var region:CubeRegion = new CubeRegion();
					region.isIncluded = 
						(cube.attribute("include") == true) ? true : false;
					cubeCollection.addItem(region);
					if (cube.KeyValue.length() > 0) {
						var members:MemberSelectionsCollection = 
							new MemberSelectionsCollection();
						for each (var mem:XML in 
							items.CubeRegion.KeyValue) {
							var member:MemberSelection = new MemberSelection();
							member.isIncluded = 
								(mem.attribute("include") == "true") ? true : false;
							var component:Component = new Component(mem.@id, 
								new Concept(mem.@id));
							member.structureComponent = component;
							var values:ArrayCollection = new ArrayCollection();
							for each (var val:XML in mem.Value) {
								values.addItem(String(val)); 
							}		
							member.values = values;
							members.addItem(member);			
						}
						region.members = members;	
					}
				}		
				constraint.permittedContentRegion = cubeCollection;
			}
			return constraint;
		}
		
	}
}