package liteAssets.listOptionsItem
{
   import fl.controls.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import liteAssets.draw.*;
   import liteAssets.mobile.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol2151")]
   public class listOptionsItemTxt extends MovieClip
   {

      public var txtName:TextField;

      public var txtSearch:TextField;

      public var btnActive:SimpleButton;

      public var sDesc:String;

      public var rootClass:MovieClip;

      private var box:Sprite;

      private var inputX:Number = -1;

      public function listOptionsItemTxt(param1:MovieClip, param2:String)
      {
         var _loc1_:VolumeButton = null;
         var _loc2_:DisplayObject = null;
         super();
         this.rootClass = param1;
         this.sDesc = param2;
         this.btnActive.addEventListener(MouseEvent.CLICK,this.onActive,false,0,true);
         this.txtSearch.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyPress,false,0,true);
         this.btnActive.visible = false;
         var _loc3_:int = 1;
         while(_loc3_ < numChildren)
         {
            _loc2_ = getChildAt(_loc3_);
            if(_loc2_ is Shape || _loc2_ is MovieClip && _loc2_ != this.btnActive)
            {
               _loc2_.visible = false;
            }
            _loc3_++;
         }
         _loc1_ = new VolumeButton(46,22,"Go",11);
         _loc1_.x = 289 - 46 - 10;
         _loc1_.y = 5;
         _loc1_.addEventListener(MouseEvent.CLICK,this.onGo,false,0,true);
         addChild(_loc1_);
         this.box = new Sprite();
         this.box.mouseEnabled = false;
         addChildAt(this.box,getChildIndex(this.txtSearch));
         this.txtSearch.textColor = 16777215;
         addEventListener(Event.ADDED_TO_STAGE,this.onShown,false,0,true);
      }

      private function onShown(param1:Event) : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         removeEventListener(Event.ADDED_TO_STAGE,this.onShown);
         var _loc3_:TextField = this["txtName"] as TextField;
         if(this.inputX < 0)
         {
            this.inputX = this.txtSearch.x;
         }
         _loc1_ = int(this.inputX) - 5;
         if(_loc3_ != null)
         {
            _loc1_ = Math.max(_loc1_,int(_loc3_.x + _loc3_.textWidth) + 12);
         }
         _loc2_ = 289 - 46 - 10 - 8 - _loc1_;
         this.txtSearch.x = _loc1_ + 5;
         this.txtSearch.width = _loc2_ - 8;
         this.box.graphics.clear();
         this.box.graphics.lineStyle(1,4868682,1,true);
         this.box.graphics.beginFill(789516);
         this.box.graphics.drawRoundRect(0,0,_loc2_,22,8,8);
         this.box.graphics.endFill();
         this.box.x = _loc1_;
         this.box.y = 5;
      }

      private function onGo(param1:MouseEvent) : void
      {
         this.btnActive.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
      }

      public function onActive(param1:MouseEvent) : void
      {
         if(this.txtSearch.text.length < 1)
         {
            return;
         }
         var _loc1_:charPage = new charPage(this.rootClass,this.txtSearch.text);
         this.rootClass.ui.addChild(_loc1_);
      }

      public function onKeyPress(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 13)
         {
            this.btnActive.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         }
      }
   }
}
