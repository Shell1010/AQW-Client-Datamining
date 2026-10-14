package liteAssets.listOptionsItem
{
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.text.TextField;
   import liteAssets.handlers.*;
   import liteAssets.mobile.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol2185")]
   public class listOptionsItem extends MovieClip
   {

      public var txtName:TextField;

      public var txtStatus:TextField;

      public var btnLeft:MovieClip;

      public var btnRight:MovieClip;

      public var bEnabled:Boolean;

      public var sDesc:String;

      public var rootClass:MovieClip;

      private var pill:VolumeButton;

      internal var bypass:Boolean = false;

      public function listOptionsItem(param1:MovieClip, param2:Boolean, param3:String)
      {
         super();
         this.rootClass = param1;
         this.txtStatus.text = param2 ? "ON" : " OFF";
         this.bEnabled = param2;
         this.sDesc = param3;
         this.btnLeft.addEventListener(MouseEvent.CLICK,this.onToggle,false,0,true);
         this.btnRight.addEventListener(MouseEvent.CLICK,this.onToggle,false,0,true);
         this.btnLeft.visible = this.btnRight.visible = this.txtStatus.visible = false;
         this.pill = new VolumeButton(72,22,param2 ? "ON" : "OFF",11);
         this.pill.dim = !param2;
         this.pill.x = 288 - 72 - 10;
         this.pill.y = 5;
         this.pill.addEventListener(MouseEvent.CLICK,this.onSwitch,false,0,true);
         addChild(this.pill);
      }

      private function onSwitch(param1:MouseEvent) : void
      {
         this.btnLeft.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
      }

      public function confirmAction(param1:Object) : void
      {
         if(param1.accept)
         {
            this.bypass = true;
            this.btnLeft.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         }
      }

      public function onToggle(param1:MouseEvent) : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         switch(this.txtName.text)
         {
            case "Custom Drops UI":
               if(!this.bEnabled || this.bypass)
               {
                  break;
               }
               _loc1_ = new ModalMC();
               _loc2_ = {};
               _loc2_.strBody = "Turning this off will decline all drops! Are you sure?";
               _loc2_.params = {};
               _loc2_.callback = this.confirmAction;
               _loc2_.glow = "red,medium";
               this.rootClass.ui.ModalStack.addChild(_loc1_);
               _loc1_.init(_loc2_);
               return;
               break;
            case "Chat UI":
               _loc1_ = new ModalMC();
               _loc2_ = {};
               _loc2_.strBody = "You must restart your client for changes to take affect!";
               _loc2_.callback = null;
               _loc2_.btns = "mono";
               _loc2_.glow = "red,medium";
               this.rootClass.ui.ModalStack.addChild(_loc1_);
               _loc1_.init(_loc2_);
         }
         this.bypass = false;
         this.bEnabled = !this.bEnabled;
         this.txtStatus.text = this.bEnabled ? "ON" : " OFF";
         this.pill.label = this.bEnabled ? "ON" : "OFF";
         this.pill.dim = !this.bEnabled;
         optionHandler.cmd(this.rootClass,this.txtName.text);
      }
   }
}
