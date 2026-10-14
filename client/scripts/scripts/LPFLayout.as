package
{
   import flash.display.*;
   import flash.text.*;

   public class LPFLayout extends MovieClip
   {

      public var panels:Array;

      public var fData:Object;

      public var w:int;

      public var h:int;

      public var panelID:int = 0;

      public var events:Object = {};

      public var sMode:String;

      public function LPFLayout()
      {
         super();
      }

      public function update(param1:Object) : *
      {
         param1 = this.handleUpdate(param1);
         this.notifyByEventType(param1);
      }

      protected function handleUpdate(param1:Object) : Object
      {
         return param1;
      }

      public function notifyByEventType(param1:Object) : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         if(param1 != null)
         {
            if(this.events[param1.eventType] != null)
            {
               _loc1_ = this.events[param1.eventType];
               _loc2_ = 0;
               while(_loc2_ < _loc1_.length)
               {
                  _loc1_[_loc2_].notify(param1);
                  _loc2_++;
               }
            }
         }
      }

      public function registerForEvents(param1:LPFFrame, param2:Array) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         while(_loc3_ < param2.length)
         {
            _loc2_ = param2[_loc3_];
            if(this.events[_loc2_] == null)
            {
               this.events[_loc2_] = [];
            }
            if(this.events[_loc2_].indexOf(param1) == -1)
            {
               this.events[_loc2_].push(param1);
            }
            _loc3_++;
         }
      }

      public function unregisterFrame(param1:*) : void
      {
         var _loc1_:String = null;
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < param1.eventTypes.length)
         {
            _loc1_ = param1.eventTypes[_loc2_];
            if(this.events[_loc1_] == null)
            {
               return;
            }
            _loc3_ = int(this.events[_loc1_].indexOf(param1));
            while(_loc3_ > -1)
            {
               this.events[_loc1_].splice(_loc3_,1);
               _loc3_ = int(this.events[_loc1_].indexOf(param1));
            }
            _loc2_++;
         }
      }

      public function addPanel(param1:Object) : MovieClip
      {
         var _loc1_:LPFPanel = addChild(param1.panel) as LPFPanel;
         _loc1_.subscribeTo(this);
         this.panels.push({
            "mc":_loc1_,
            "id":this.panelID++
         });
         _loc1_.fOpen(param1);
         return _loc1_;
      }

      public function delPanel(param1:*) : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.panels.length)
         {
            if(this.panels[_loc1_].mc == param1)
            {
               this.panels.splice(_loc1_,1);
            }
            _loc1_++;
         }
         removeChild(param1);
      }

      public function fOpen(param1:Object) : void
      {
         var _loc1_:Object = null;
         this.fData = param1.fData;
         _loc1_ = param1.r;
         x = _loc1_.x;
         y = _loc1_.y;
         this.w = _loc1_.w;
         this.h = _loc1_.h;
      }

      public function fClose() : void
      {
         var _loc1_:Object = null;
         var _loc2_:MovieClip = null;
         var _loc4_:Array = this.panels.concat();
         this.panels.length = 0;
         for each(_loc1_ in _loc4_)
         {
            try
            {
               _loc1_.mc.fClose();
            }
            catch(ce:Error)
            {
            }
         }
         if(parent != null)
         {
            _loc2_ = MovieClip(parent);
            _loc2_.removeChild(this);
            _loc2_.onClose();
         }
      }

      protected function tempFill() : void
      {
      }
   }
}
