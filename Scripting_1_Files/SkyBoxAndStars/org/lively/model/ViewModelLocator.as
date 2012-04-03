package org.lively.model {
	
	import com.adobe.cairngorm.model.IModelLocator;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class ViewModelLocator implements IModelLocator {
	
		private static var instance:ViewModelLocator;

		public function ViewModelLocator(enforcer:SingletonEnforcer) {
		if (enforcer == null) {
				throw new Error( "You Can Only Have One ViewModelLocator" );
			}
		}

		public static function getInstance() : ViewModelLocator {
			if (instance == null) {
				instance = new ViewModelLocator( new SingletonEnforcer );
			}
			return instance;
		}

		// DEFINE YOUR VARIABLES HERE
		public var dukeHouses:ArrayCollection;
		
		//Data showing what customer was looking at
		public var customerLookData:String;
		
		public var myFrameState:int;

        //popUpNumber
        public var myPopUpIndex:int=0;
        
        
        public var myHouseChosen:int=10;
        
        public var myVideoState:String= "videoHere";
        public var myVideoState3:String= "videoHere";
       
        public var myVideo2OffStage:Boolean=false;
        
        public var myHousePick:Boolean=false;
        
        public var myDataGridNum:String="zero";

	}
}

// Utility Class to Deny Access to Constructor
class SingletonEnforcer {}