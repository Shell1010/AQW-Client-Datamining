package liteAssets.listOptionsItem
{
   import fl.controls.*;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.text.*;
   import liteAssets.handlers.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol2160")]
   public class listOptionsItemExtra extends MovieClip
   {

      public var txtName:TextField;

      public var chkActive:MovieClip;

      public var sDesc:String;

      public var rootClass:MovieClip;

      internal var bypass:Boolean = false;

      public function listOptionsItemExtra(param1:MovieClip, param2:Boolean, param3:String)
      {
         super();
         this.rootClass = param1;
         this.sDesc = param3;
         this.chkActive.checkmark.visible = param2;
         this.chkActive.addEventListener(MouseEvent.CLICK,this.onToggle,false,0,true);
      }

      public function confirmAction(param1:Object) : void
      {
         if(param1.accept)
         {
            this.bypass = true;
            this.chkActive.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         }
      }

      public function onToggle(param1:MouseEvent) : void
      {
         var _loc1_:Class = null;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         switch(this.txtName.text)
         {
            case "Quantity Warnings":
               if(!this.chkActive.checkmark.visible || this.bypass)
               {
                  break;
               }
               _loc2_ = new ModalMC();
               _loc3_ = {};
               _loc3_.strBody = "Turning this off means that you will not go to player support for unaccepted drops! Are you sure?";
               _loc3_.params = {};
               _loc3_.callback = this.confirmAction;
               _loc3_.glow = "red,medium";
               this.rootClass.ui.ModalStack.addChild(_loc2_);
               _loc2_.init(_loc3_);
               return;
         }
         this.bypass = false;
         this.chkActive.checkmark.visible = !this.chkActive.checkmark.visible;
         optionHandler.cmd(this.rootClass,this.txtName.text);
      }
   }
}
