package spider_fla
{
   import flash.accessibility.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.net.drm.*;
   import flash.system.*;
   import flash.text.*;
   import flash.text.ime.*;
   import flash.ui.*;
   import flash.utils.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol693")]
   public dynamic class mcQFrame_bg_547 extends MovieClip
   {

      public var bg:MovieClip;

      public var bl1:MovieClip;

      public var br1:MovieClip;

      public var btnClose:SimpleButton;

      public var btnPin:SimpleButton;

      public var btnTry:SimpleButton;

      public var btnWiki:SimpleButton;

      public var fx:MovieClip;

      public var tl1:MovieClip;

      public var tl2:MovieClip;

      public var tl3:MovieClip;

      public var tr1:MovieClip;

      public var tr2:MovieClip;

      public var tr3:MovieClip;

      public function mcQFrame_bg_547()
      {
         super();
         addFrameScript(0,this.frame1);
      }

      public function buildBounds() : void
      {
         this.boundsOK = true;
         var _loc1_:Array = this.tl = [{
            "mc":this.tl1,
            "dx":0,
            "dy":0
         },{
            "mc":this.tl2,
            "dx":0,
            "dy":0
         },{
            "mc":this.tl3,
            "dx":0,
            "dy":0
         }];
         var _loc2_:Array = this.tr = [{
            "mc":this.tl1,
            "dx":0,
            "dy":0
         },{
            "mc":this.tr2,
            "dx":0,
            "dy":0
         },{
            "mc":this.tr3,
            "dx":0,
            "dy":0
         },{
            "mc":this.btnClose,
            "dx":0,
            "dy":0
         }];
         var _loc3_:Array = this.bl = [{
            "mc":this.bl1,
            "dx":0,
            "dy":0
         }];
         var _loc4_:Array = this.br = [{
            "mc":this.br1,
            "dx":0,
            "dy":0
         }];
         var _loc5_:int = 0;
         var _loc6_:Object = {};
         var _loc7_:Point = new Point();
         var _loc8_:Point = new Point();
         var _loc9_:Rectangle = this.bgA = this.bg.getBounds(this);
         _loc5_ = 0;
         while(_loc5_ < _loc1_.length)
         {
            _loc6_ = _loc1_[_loc5_];
            _loc7_ = _loc9_.topLeft;
            _loc6_.dx = _loc7_.x - _loc6_.mc.x;
            _loc6_.dy = _loc7_.y - _loc6_.mc.y;
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < _loc2_.length)
         {
            _loc6_ = _loc2_[_loc5_];
            _loc7_ = _loc9_.topLeft;
            _loc7_.x += _loc9_.width;
            _loc6_.dx = _loc7_.x - _loc6_.mc.x;
            _loc6_.dy = _loc7_.y - _loc6_.mc.y;
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < _loc3_.length)
         {
            _loc6_ = _loc3_[_loc5_];
            _loc7_ = _loc9_.topLeft;
            _loc7_.y += _loc9_.height;
            _loc6_.dx = _loc7_.x - _loc6_.mc.x;
            _loc6_.dy = _loc7_.y - _loc6_.mc.y;
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc6_ = _loc4_[_loc5_];
            _loc7_ = _loc9_.bottomRight;
            _loc6_.dx = _loc7_.x - _loc6_.mc.x;
            _loc6_.dy = _loc7_.y - _loc6_.mc.y;
            _loc5_++;
         }
      }

      public function resizeTo(param1:int, param2:int, param3:int = 0) : void
      {
         var _loc1_:Rectangle = null;
         if(!("boundsOK" in this))
         {
            this.buildBounds();
         }
         var _loc2_:Array = this.tl;
         var _loc3_:Array = this.tr;
         var _loc4_:Array = this.bl;
         var _loc5_:Array = this.br;
         var _loc6_:int = 0;
         var _loc7_:Object = {};
         var _loc8_:Point = new Point();
         var _loc9_:Point = new Point();
         _loc1_ = this.bgA;
         this.bg.width = param1;
         this.bg.height = param2;
         this.bg.x = _loc1_.topLeft.x + Math.round(this.bg.width / 2);
         this.bg.y = _loc1_.topLeft.y + Math.round(this.bg.height / 2);
         var _loc10_:Rectangle = this.bg.getBounds(this);
         _loc6_ = 0;
         while(_loc6_ < _loc2_.length)
         {
            _loc7_ = _loc2_[_loc6_];
            _loc9_ = _loc10_.topLeft;
            _loc7_.mc.x = _loc9_.x - _loc7_.dx;
            _loc7_.mc.y = _loc9_.y - _loc7_.dy;
            _loc6_++;
         }
         _loc6_ = 0;
         while(_loc6_ < _loc3_.length)
         {
            _loc7_ = _loc3_[_loc6_];
            _loc9_ = _loc10_.topLeft;
            _loc9_.x += _loc10_.width;
            _loc7_.mc.x = _loc9_.x - _loc7_.dx;
            _loc7_.mc.y = _loc9_.y - _loc7_.dy;
            _loc6_++;
         }
         _loc6_ = 0;
         while(_loc6_ < _loc4_.length)
         {
            _loc7_ = _loc4_[_loc6_];
            _loc9_ = _loc10_.topLeft;
            _loc9_.y += _loc10_.height;
            _loc7_.mc.x = _loc9_.x - _loc7_.dx;
            _loc7_.mc.y = _loc9_.y - _loc7_.dy;
            _loc6_++;
         }
         _loc6_ = 0;
         while(_loc6_ < _loc5_.length)
         {
            _loc7_ = _loc5_[_loc6_];
            _loc9_ = _loc10_.bottomRight;
            _loc7_.mc.x = _loc9_.x - _loc7_.dx;
            _loc7_.mc.y = _loc9_.y - _loc7_.dy;
            _loc6_++;
         }
         this.fx.y = 110;
      }

      internal function frame1() : *
      {
      }
   }
}
