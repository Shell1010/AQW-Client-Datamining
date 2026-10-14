package it.gotoandplay.smartfoxserver.handlers
{
   import it.gotoandplay.smartfoxserver.*;
   import it.gotoandplay.smartfoxserver.util.*;

   public class ExtHandler implements IMessageHandler
   {

      private var sfs:SmartFoxClient;

      public function ExtHandler(param1:SmartFoxClient)
      {
         super();
         this.sfs = param1;
      }

      public function handleMessage(param1:Object, param2:String) : void
      {
         var _loc1_:Object = null;
         var _loc2_:SFSEvent = null;
         var _loc3_:XML = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:Object = null;
         if(param2 == SmartFoxClient.XTMSG_TYPE_XML)
         {
            _loc3_ = param1 as XML;
            _loc4_ = _loc3_.body.@action;
            _loc5_ = int(_loc3_.body.@id);
            if(_loc4_ == "xtRes")
            {
               _loc6_ = _loc3_.body.toString();
               _loc7_ = ObjectSerializer.getInstance().deserialize(_loc6_);
               _loc1_ = {};
               _loc1_.dataObj = _loc7_;
               _loc1_.type = param2;
               _loc2_ = new SFSEvent(SFSEvent.onExtensionResponse,_loc1_);
               this.sfs.dispatchEvent(_loc2_);
            }
         }
         else if(param2 == SmartFoxClient.XTMSG_TYPE_JSON)
         {
            _loc1_ = {};
            _loc1_.dataObj = param1.o;
            _loc1_.type = param2;
            _loc2_ = new SFSEvent(SFSEvent.onExtensionResponse,_loc1_);
            this.sfs.dispatchEvent(_loc2_);
         }
         else if(param2 == SmartFoxClient.XTMSG_TYPE_STR)
         {
            _loc1_ = {};
            _loc1_.dataObj = param1;
            _loc1_.type = param2;
            _loc2_ = new SFSEvent(SFSEvent.onExtensionResponse,_loc1_);
            this.sfs.dispatchEvent(_loc2_);
         }
      }
   }
}
