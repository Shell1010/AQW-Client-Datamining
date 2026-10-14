package liteAssets.listOptionsItem
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.*;
   import flash.text.*;
   import liteAssets.handlers.*;
   import liteAssets.mobile.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol2174")]
   public class listOptionsItemBtn extends MovieClip
   {

      private static const PILL_W:int = 72;

      private static const ACTION_LABELS:Object = {
         "Decline All Drops":"Decline",
         "Reset UI Positions":"Reset"
      };

      public var txtName:TextField;

      public var btnActive:SimpleButton;

      public var sDesc:String;

      public var rootClass:MovieClip;

      private var pill:VolumeButton;

      internal var bypass:Boolean = false;

      public function listOptionsItemBtn(param1:MovieClip, param2:String)
      {
         super();
         this.rootClass = param1;
         this.sDesc = param2;
         this.btnActive.addEventListener(MouseEvent.CLICK,this.onActive,false,0,true);
         this.btnActive.visible = false;
         var _loc1_:int = 0;
         while(_loc1_ < numChildren)
         {
            if(getChildAt(_loc1_) is StaticText)
            {
               getChildAt(_loc1_).visible = false;
            }
            _loc1_++;
         }
         this.pill = new VolumeButton(PILL_W,22,"Open",11);
         this.pill.x = 288 - PILL_W - 10;
         this.pill.y = 5;
         this.pill.addEventListener(MouseEvent.CLICK,this.onPill,false,0,true);
         addChild(this.pill);
         addEventListener(Event.ADDED_TO_STAGE,this.onShown,false,0,true);
      }

      private function onShown(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onShown);
         this.relabel();
      }

      private function onPill(param1:MouseEvent) : void
      {
         this.btnActive.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         this.relabel();
      }

      private function relabel() : void
      {
         var _loc2_:String = this.txtName.text;
         var _loc3_:int = _loc2_.indexOf(": ");
         if(_loc3_ > 0)
         {
            this.txtName.text = _loc2_.substr(0,_loc3_);
            this.pill.label = _loc2_.substr(_loc3_ + 2);
         }
         else
         {
            this.pill.label = ACTION_LABELS[_loc2_] != null ? ACTION_LABELS[_loc2_] : "Open";
         }
      }

      public function confirmAction(param1:Object) : void
      {
         if(param1.accept)
         {
            this.bypass = true;
            this.btnActive.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         }
      }

      public function onActive(param1:MouseEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc1_:* = undefined;
         switch(this.txtName.text)
         {
            case "Decline All Drops":
               if(this.bypass)
               {
                  break;
               }
               _loc3_ = new ModalMC();
               _loc1_ = {};
               _loc1_.strBody = "Are you sure you want to decline all drops?";
               _loc1_.params = {};
               _loc1_.callback = this.confirmAction;
               _loc1_.glow = "red,medium";
               this.rootClass.ui.ModalStack.addChild(_loc3_);
               _loc3_.init(_loc1_);
               return;
         }
         if(this.txtName.text.indexOf("Mobile Controls") == 0)
         {
            this.txtName.text = VolumePanel.cycleTouch();
            this.rootClass.ui.ToolTip.close();
            return;
         }
         if(this.txtName.text.indexOf("Max FPS") == 0)
         {
            this.txtName.text = this.rootClass.cycleMaxFPS();
            this.rootClass.ui.ToolTip.close();
            return;
         }
         this.bypass = false;
         optionHandler.cmd(this.rootClass,this.txtName.text);
      }
   }
}
