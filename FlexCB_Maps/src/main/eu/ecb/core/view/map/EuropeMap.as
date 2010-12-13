package eu.ecb.core.view.map {
  import ilog.maps.Map;
  import ilog.maps.MapBase;

  public class EuropeMap extends MapBase  {
  	
  	private var _bsdImpl:Boolean;
  	
  	public function EuropeMap(bsdImpl:Boolean) {
  		_bsdImpl = bsdImpl;
  	}
  	
   /**
    * @inheritDoc
    */
    public override function createMap():Map {
      return (_bsdImpl) ? new Europe() : new Europe2();
    }
   /**
    * @inheritDoc
    */
    public override function getString(k:String):String {
      if(resourceManager != null)
        return resourceManager.getString("Europe", k);
      return k;
    }
  }
}
