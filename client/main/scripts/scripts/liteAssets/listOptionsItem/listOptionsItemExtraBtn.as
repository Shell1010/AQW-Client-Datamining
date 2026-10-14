package liteAssets.listOptionsItem
{
   import fl.controls.*;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.*;
   import flash.text.*;
   import liteAssets.handlers.*;
   import liteAssets.mobile.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol2154")]
   public class listOptionsItemExtraBtn extends MovieClip
   {

      public var txtName:TextField;

      public var btnActive:SimpleButton;

      public var sDesc:String;

      public var rootClass:MovieClip;

      private var pill:VolumeButton;

      public function listOptionsItemExtraBtn(param1:MovieClip, param2:String)
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
         this.pill = new VolumeButton(60,20,"Open",11);
         this.pill.x = 270 - 60 - 12;
         this.pill.y = 6;
         this.pill.addEventListener(MouseEvent.CLICK,this.onPill,false,0,true);
         addChild(this.pill);
         addEventListener(Event.ADDED_TO_STAGE,this.onShown,false,0,true);
      }

      private function onShown(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onShown);
         if(this.txtName.text.indexOf("Reset") == 0)
         {
            this.pill.label = "Reset";
         }
      }

      private function onPill(param1:MouseEvent) : void
      {
         this.btnActive.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
      }

      public function onActive(param1:MouseEvent) : void
      {
         optionHandler.cmd(this.rootClass,this.txtName.text);
      }
   }
}
