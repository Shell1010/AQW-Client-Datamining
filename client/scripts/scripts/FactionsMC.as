package
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import liteAssets.mobile.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol2727")]
   public class FactionsMC extends MovieClip
   {

      public var cnt:MovieClip;

      public var world:MovieClip;

      public var rootClass:MovieClip;

      internal var isOpen:Boolean = false;

      internal var mc:MovieClip;

      internal var mDown:Boolean = false;

      internal var hRun:int = 0;

      internal var dRun:int = 0;

      internal var mbY:int = 0;

      internal var mhY:int = 0;

      internal var mbD:int = 0;

      private var touch:TouchScroll;

      internal var qly:int = 57;

      internal var iRepMax:int = 302500;

      public var factions:Array;

      public function FactionsMC()
      {
         super();
         addFrameScript(0,this.frame1,6,this.frame7,11,this.frame12,15,this.frame16);
         this.mc = MovieClip(this);
         this.mc.cnt.bg.btnClose.addEventListener(MouseEvent.CLICK,this.xClick);
      }

      public function open() : *
      {
         this.rootClass = MovieClip(this.stage.getChildAt(0));
         this.world = this.rootClass.world;
         this.factions = this.world.myAvatar.factions;
         this.mc = MovieClip(this);
         if(!this.isOpen)
         {
            this.isOpen = true;
            this.mc.cnt.gotoAndPlay("intro");
         }
         else
         {
            this.isOpen = false;
            this.fClose();
         }
      }

      public function showFactionList() : *
      {
         if(this.factions.length > 0)
         {
            this.buildFactionList();
         }
         else
         {
            this.showEmptyList();
         }
         this.mc.cnt.fList.visible = true;
         this.mc.cnt.fList.mHi.visible = false;
         this.mc.cnt.mouseChildren = true;
      }

      private function buildFactionList() : *
      {
         var _loc1_:MovieClip = null;
         var _loc2_:Object = {};
         this.factions.sortOn("sName");
         var _loc3_:* = 0;
         while(_loc3_ < this.factions.length)
         {
            _loc2_ = this.factions[_loc3_];
            if(_loc2_ != null)
            {
               _loc1_ = this.mc.cnt.fList.addChild(new fProto()) as MovieClip;
               _loc1_.t1.htmlText = _loc2_.sName;
               _loc1_.tRank.htmlText = "Rank " + _loc2_.iRank;
               if(_loc2_.iRank == "10")
               {
                  _loc2_.iSpillRep = 0;
               }
               _loc1_.t2.htmlText = _loc2_.iSpillRep + " <font color=\'#FF0000\'>/</font> " + _loc2_.iRepToRank;
               _loc1_.addEventListener(MouseEvent.MOUSE_OVER,this.iMouseOver,false,0,true);
               _loc1_.addEventListener(MouseEvent.MOUSE_OUT,this.iMouseOut,false,0,true);
               _loc1_.hit.alpha = 0;
               _loc1_.y = _loc3_ * 20;
               _loc1_.x = 10;
            }
            _loc3_++;
         }
         var _loc4_:* = this.mc.cnt.scr;
         var _loc5_:* = this.mc.cnt.bMask;
         var _loc6_:* = this.mc.cnt.fList;
         _loc4_.h.height = int(_loc4_.b.height / _loc6_.height * _loc4_.b.height);
         this.hRun = _loc4_.b.height - _loc4_.h.height;
         this.dRun = _loc6_.height - _loc4_.b.height + 20;
         _loc4_.h.y = 0;
         _loc6_.oy = _loc6_.y = this.qly;
         _loc4_.visible = false;
         _loc4_.hit.alpha = 0;
         this.mDown = false;
         if(_loc6_.height > _loc4_.b.height)
         {
            _loc4_.visible = true;
            _loc4_.hit.addEventListener(MouseEvent.MOUSE_DOWN,this.scrDown,false,0,true);
            _loc4_.h.addEventListener(Event.ENTER_FRAME,this.hEF,false,0,true);
            _loc6_.addEventListener(Event.ENTER_FRAME,this.dEF,false,0,true);
            this.attachTouch();
         }
         this.mc.cnt.scr.hit.buttonMode = true;
         this.mc.cnt.fList.iproto.visible = false;
      }

      private function fListClick(param1:MouseEvent) : *
      {
         var _loc1_:* = MovieClip(param1.currentTarget);
      }

      private function showEmptyList() : *
      {
         var _loc2_:* = this.mc.cnt.fList.addChild(new fProto());
         _loc2_.t1.htmlText = "<font color=\"#DDDDDD\">No Factions!</font>";
         _loc2_.t2.visible = false;
         _loc2_.tRank.visible = false;
         _loc2_.hit.alpha = 0;
         _loc2_.x = 10;
         this.mc.cnt.fList.iproto.visible = false;
         this.mc.cnt.scr.visible = false;
      }

      private function attachTouch() : void
      {
         this.detachTouch();
         this.touch = TouchScroll.attach(this.mc.cnt,this.touchGet,this.touchSet,this.touchMax);
      }

      private function detachTouch() : void
      {
         if(this.touch != null)
         {
            this.touch.detach();
            this.touch = null;
         }
      }

      private function touchMax() : Number
      {
         if(this.hRun <= 0 || this.dRun <= 0)
         {
            return 0;
         }
         return this.dRun;
      }

      private function touchGet() : Number
      {
         if(this.hRun <= 0)
         {
            return 0;
         }
         return this.mc.cnt.scr.h.y / this.hRun * this.dRun;
      }

      private function touchSet(param1:Number) : void
      {
         if(this.mDown || this.hRun <= 0 || this.dRun <= 0)
         {
            return;
         }
         this.mc.cnt.scr.h.y = param1 / this.dRun * this.hRun;
      }

      private function scrDown(param1:MouseEvent) : *
      {
         this.mbY = int(mouseY);
         this.mhY = int(MovieClip(param1.currentTarget.parent).h.y);
         this.mDown = true;
         stage.addEventListener(MouseEvent.MOUSE_UP,this.scrUp);
      }

      private function scrUp(param1:MouseEvent) : *
      {
         this.mDown = false;
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.scrUp);
      }

      private function hEF(param1:Event) : *
      {
         var _loc1_:* = undefined;
         if(this.mDown)
         {
            _loc1_ = MovieClip(param1.currentTarget.parent);
            this.mbD = int(mouseY) - this.mbY;
            _loc1_.h.y = this.mhY + this.mbD;
            if(_loc1_.h.y + _loc1_.h.height > _loc1_.b.height)
            {
               _loc1_.h.y = int(_loc1_.b.height - _loc1_.h.height);
            }
            if(_loc1_.h.y < 0)
            {
               _loc1_.h.y = 0;
            }
         }
      }

      private function dEF(param1:Event) : *
      {
         var _loc1_:* = MovieClip(param1.currentTarget.parent).scr;
         var _loc3_:* = MovieClip(param1.currentTarget);
         var _loc4_:* = -_loc1_.h.y / this.hRun;
         var _loc5_:* = int(_loc4_ * this.dRun) + _loc3_.oy;
         if(Math.abs(_loc5_ - _loc3_.y) > 0.2)
         {
            _loc3_.y += (_loc5_ - _loc3_.y) / 4;
         }
         else
         {
            _loc3_.y = _loc5_;
         }
      }

      public function xClick(param1:MouseEvent = null) : *
      {
         this.mc.gotoAndPlay("outro");
      }

      public function fClose() : void
      {
         this.detachTouch();
         this.mc.cnt.bg.btnClose.removeEventListener(MouseEvent.CLICK,this.xClick);
         this.rootClass.ui.mcPopup.onClose();
      }

      private function bMouseOver(param1:MouseEvent) : *
      {
         var _loc1_:* = MovieClip(param1.currentTarget);
         _loc1_.fx.visible = true;
      }

      private function bMouseOut(param1:MouseEvent) : *
      {
         var _loc1_:* = MovieClip(param1.currentTarget);
         _loc1_.fx.visible = false;
      }

      private function setCT(param1:*, param2:*) : *
      {
         var _loc3_:* = param1.transform.colorTransform;
         _loc3_.color = param2;
         param1.transform.colorTransform = _loc3_;
      }

      private function iMouseOver(param1:MouseEvent) : *
      {
         var _loc1_:* = MovieClip(param1.currentTarget);
         _loc1_.parent.mHi.visible = true;
         _loc1_.parent.mHi.y = _loc1_.y;
      }

      private function iMouseOut(param1:MouseEvent) : *
      {
         var _loc1_:* = MovieClip(param1.currentTarget);
         _loc1_.parent.mHi.visible = false;
      }

      internal function frame1() : *
      {
         this.open();
      }

      internal function frame7() : *
      {
         stop();
      }

      internal function frame12() : *
      {
      }

      internal function frame16() : *
      {
         this.fClose();
      }
   }
}
