package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.system.*;
   import flash.text.*;
   import flash.utils.*;
   import liteAssets.mobile.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol2493")]
   public class OFrameMC extends MovieClip
   {

      public var bg:MovieClip;

      public var cntMask:MovieClip;

      public var t1:MovieClip;

      internal var world:MovieClip;

      internal var rootClass:MovieClip;

      public var fData:Object = null;

      internal var uli:int;

      internal var isOpen:Boolean = false;

      internal var mc:MovieClip;

      internal var tcnt:MovieClip;

      internal var mDown:Boolean = false;

      internal var hRun:int = 0;

      internal var dRun:int = 0;

      internal var mbY:int = 0;

      internal var mhY:int = 0;

      internal var mbD:int = 0;

      private var touch:TouchScroll;

      public function OFrameMC()
      {
         super();
         addFrameScript(0,this.frame1,5,this.frame6,9,this.frame10);
         this.mc = MovieClip(this);
         if(stage)
         {
            this.rootClass = stage.getChildAt(0) as MovieClip;
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage,false,0,true);
         }
      }

      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.rootClass = stage.getChildAt(0) as MovieClip;
      }

      public function fOpenWith(param1:*) : *
      {
         this.fData = param1;
         this.isOpen = true;
         this.clearCnt();
         if(this.mc.currentLabel != "Idle")
         {
            this.mc.gotoAndPlay("Open");
         }
         else
         {
            this.update();
         }
      }

      public function fClose() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         this.isOpen = false;
         this.fData = {};
         this.detachTouch();
         var _loc3_:* = this.mc.getChildByName("cnt");
         if(_loc3_ != null)
         {
            _loc1_ = _loc3_.scr;
            _loc2_ = _loc3_.cnt;
            if(Boolean(_loc1_) && Boolean(_loc1_.hit))
            {
               _loc1_.hit.removeEventListener(MouseEvent.MOUSE_DOWN,this.scrDown);
            }
            if(Boolean(_loc1_) && Boolean(_loc1_.h))
            {
               _loc1_.h.removeEventListener(Event.ENTER_FRAME,this.hEF);
            }
            if(_loc2_)
            {
               _loc2_.removeEventListener(Event.ENTER_FRAME,this.dEF);
            }
         }
         if(stage)
         {
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.scrUp);
         }
         this.clearCnt();
         if(this.mc.currentLabel != "Init")
         {
            if(this.mc.currentLabel == "Idle")
            {
               this.mc.gotoAndPlay("Close");
            }
            else
            {
               this.mc.gotoAndStop("Init");
            }
         }
      }

      public function update() : *
      {
         var _loc1_:String = null;
         var _loc2_:Class = null;
         var _loc3_:MovieClip = null;
         var _loc4_:Class = null;
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc7_:MovieClip = null;
         var _loc8_:MovieClip = null;
         var _loc9_:MovieClip = null;
         this.clearCnt();
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         switch(this.fData.typ)
         {
            case "userListA":
               _loc1_ = "mcUListA";
               if(!ApplicationDomain.currentDomain.hasDefinition(_loc1_))
               {
                  trace("[Load] ERR missing linkage " + _loc1_ + " OFrameMC " + this.fData.typ);
                  return;
               }
               _loc2_ = getDefinitionByName(_loc1_) as Class;
               _loc3_ = this.mc.addChild(new _loc2_()) as MovieClip;
               _loc3_.name = "cnt";
               _loc3_.x = 10;
               _loc3_.y = this.t1.y + this.t1.height + 4;
               _loc3_.mask = this.cntMask;
               _loc3_.scr.buttonMode = true;
               this.t1.txtTitle.text = "Users in your area";
               this.t1.txtSubTitle.text = "/who";
               _loc10_ = 0;
               this.tcnt = MovieClip(this.mc.getChildByName("cnt"));
               this.tcnt.strMeta.text = "Class";
               for(_loc6_ in this.fData.ul)
               {
                  _loc5_ = this.tcnt.cnt.addChild(new mcUListAItem());
                  _loc5_.ID = this.fData.ul[_loc6_].ID;
                  _loc5_.txtName.text = this.fData.ul[_loc6_].sName;
                  _loc5_.txtMeta.text = this.fData.ul[_loc6_].sClass;
                  _loc5_.txtLevel.text = this.fData.ul[_loc6_].iLvl;
                  _loc5_.addEventListener(MouseEvent.CLICK,this.uNameClick,false,0,true);
                  _loc5_.buttonMode = true;
                  _loc5_.y = _loc10_ * 20;
                  _loc10_++;
               }
               _loc7_ = this.tcnt.scr;
               if(this.tcnt.cnt.height < this.tcnt.cntMask.height)
               {
                  _loc7_.visible = false;
                  if(this.mc.bg)
                  {
                     _loc3_.x = int(this.mc.bg.x + this.mc.bg.width / 2 - _loc3_.cntMask.width / 2);
                  }
               }
               else
               {
                  if(this.mc.bg)
                  {
                     _loc3_.x = int(this.mc.bg.x + this.mc.bg.width / 2 - _loc3_.width / 2);
                  }
                  _loc8_ = this.tcnt.cntMask;
                  _loc9_ = this.tcnt.cnt;
                  _loc7_.visible = true;
                  _loc7_.h.height = int(_loc8_.height / _loc9_.height * _loc7_.b.height);
                  this.hRun = _loc7_.b.height - _loc7_.h.height;
                  this.dRun = _loc9_.height - _loc8_.height + 5;
                  _loc7_.h.y = 0;
                  _loc9_.oy = _loc9_.y = _loc7_.y;
                  _loc7_.visible = false;
                  _loc7_.hit.alpha = 0;
                  this.mDown = false;
                  if(_loc9_.height > _loc7_.b.height)
                  {
                     _loc7_.visible = true;
                     _loc7_.hit.addEventListener(MouseEvent.MOUSE_DOWN,this.scrDown,false,0,true);
                     _loc7_.h.addEventListener(Event.ENTER_FRAME,this.hEF,false,0,true);
                     _loc9_.addEventListener(Event.ENTER_FRAME,this.dEF,false,0,true);
                     this.attachTouch();
                  }
               }
               this.tcnt.cnt.iproto.visible = false;
               break;
            case "userListFriends":
               _loc1_ = "mcUListA";
               if(!ApplicationDomain.currentDomain.hasDefinition(_loc1_))
               {
                  trace("[Load] ERR missing linkage " + _loc1_ + " OFrameMC " + this.fData.typ);
                  return;
               }
               _loc2_ = getDefinitionByName(_loc1_) as Class;
               _loc3_ = this.mc.addChild(new _loc2_()) as MovieClip;
               _loc3_.name = "cnt";
               _loc3_.x = 10;
               _loc3_.y = this.t1.y + this.t1.height + 4;
               _loc3_.mask = this.cntMask;
               _loc3_.scr.buttonMode = true;
               this.t1.txtTitle.text = "Friends List - " + this.fData.ul.length + "/" + String(this.rootClass.iMaxFriends);
               this.t1.txtSubTitle.text = "/friends";
               _loc10_ = 0;
               this.tcnt = MovieClip(this.mc.getChildByName("cnt"));
               this.tcnt.strMeta.text = "Server";
               _loc11_ = 0;
               while(_loc11_ < this.fData.ul.length)
               {
                  _loc5_ = this.tcnt.cnt.addChild(new mcUListAItem());
                  _loc5_.ID = this.fData.ul[_loc11_].ID;
                  _loc5_.txtName.text = this.fData.ul[_loc11_].sName;
                  _loc5_.txtMeta.text = this.fData.ul[_loc11_].sServer;
                  _loc5_.txtLevel.text = this.fData.ul[_loc11_].iLvl;
                  _loc5_.addEventListener(MouseEvent.CLICK,this.uNameClick,false,0,true);
                  _loc5_.buttonMode = true;
                  _loc5_.y = _loc10_ * 20;
                  _loc10_++;
                  if(this.fData.ul[_loc11_].sServer == "Offline")
                  {
                     _loc5_.transform.colorTransform = new ColorTransform(1,1,1,1,-100,-100,-100,0);
                  }
                  _loc11_++;
               }
               _loc7_ = this.tcnt.scr;
               if(this.tcnt.cnt.height < this.tcnt.cntMask.height)
               {
                  _loc7_.visible = false;
                  if(this.mc.bg)
                  {
                     _loc3_.x = int(this.mc.bg.x + this.mc.bg.width / 2 - _loc3_.cntMask.width / 2);
                  }
               }
               else
               {
                  if(this.mc.bg)
                  {
                     _loc3_.x = int(this.mc.bg.x + this.mc.bg.width / 2 - _loc3_.width / 2);
                  }
                  _loc8_ = this.tcnt.cntMask;
                  _loc9_ = this.tcnt.cnt;
                  _loc7_.visible = true;
                  _loc7_.h.height = int(_loc8_.height / _loc9_.height * _loc7_.b.height);
                  this.hRun = _loc7_.b.height - _loc7_.h.height;
                  this.dRun = _loc9_.height - _loc8_.height + 5;
                  _loc7_.h.y = 0;
                  _loc9_.oy = _loc9_.y = _loc7_.y;
                  _loc7_.visible = false;
                  _loc7_.hit.alpha = 0;
                  this.mDown = false;
                  if(_loc9_.height > _loc7_.b.height)
                  {
                     _loc7_.visible = true;
                     _loc7_.hit.addEventListener(MouseEvent.MOUSE_DOWN,this.scrDown,false,0,true);
                     _loc7_.h.addEventListener(Event.ENTER_FRAME,this.hEF,false,0,true);
                     _loc9_.addEventListener(Event.ENTER_FRAME,this.dEF,false,0,true);
                     this.attachTouch();
                  }
               }
               this.tcnt.cnt.iproto.visible = false;
               break;
            case "userListGuild":
               _loc1_ = "mcUListA";
               if(!ApplicationDomain.currentDomain.hasDefinition(_loc1_))
               {
                  trace("[Load] ERR missing linkage " + _loc1_ + " OFrameMC " + this.fData.typ);
                  return;
               }
               _loc2_ = getDefinitionByName(_loc1_) as Class;
               _loc3_ = this.mc.addChild(new _loc2_()) as MovieClip;
               _loc3_.name = "cnt";
               _loc3_.x = 10;
               _loc3_.y = this.t1.y + this.t1.height + 4;
               _loc3_.mask = this.cntMask;
               _loc3_.scr.buttonMode = true;
               this.t1.txtTitle.text = "Guild Members";
               this.t1.txtSubTitle.text = "/guild";
               _loc10_ = 0;
               this.tcnt = MovieClip(this.mc.getChildByName("cnt"));
               this.tcnt.strMeta.text = "Server";
               _loc11_ = 0;
               while(_loc11_ < this.fData.ul.length)
               {
                  _loc5_ = this.tcnt.cnt.addChild(new mcUListAItem());
                  _loc5_.ID = this.fData.ul[_loc11_].ID;
                  _loc5_.txtName.text = this.fData.ul[_loc11_].userName;
                  _loc5_.txtMeta.text = this.fData.ul[_loc11_].Server;
                  _loc5_.txtLevel.text = this.fData.ul[_loc11_].Level;
                  _loc5_.addEventListener(MouseEvent.CLICK,this.uNameClick,false,0,true);
                  _loc5_.buttonMode = true;
                  _loc5_.y = _loc10_ * 20;
                  _loc10_++;
                  if(this.fData.ul[_loc11_].sServer == "Offline")
                  {
                     _loc5_.transform.colorTransform = new ColorTransform(1,1,1,1,-100,-100,-100,0);
                  }
                  _loc11_++;
               }
               _loc7_ = this.tcnt.scr;
               if(this.tcnt.cnt.height < this.tcnt.cntMask.height)
               {
                  _loc7_.visible = false;
                  if(this.mc.bg)
                  {
                     _loc3_.x = int(this.mc.bg.x + this.mc.bg.width / 2 - _loc3_.cntMask.width / 2);
                  }
               }
               else
               {
                  if(this.mc.bg)
                  {
                     _loc3_.x = int(this.mc.bg.x + this.mc.bg.width / 2 - _loc3_.width / 2);
                  }
                  _loc8_ = this.tcnt.cntMask;
                  _loc9_ = this.tcnt.cnt;
                  _loc7_.visible = true;
                  _loc7_.h.height = int(_loc8_.height / _loc9_.height * _loc7_.b.height);
                  this.hRun = _loc7_.b.height - _loc7_.h.height;
                  this.dRun = _loc9_.height - _loc8_.height + 5;
                  _loc7_.h.y = 0;
                  _loc9_.oy = _loc9_.y = _loc7_.y;
                  _loc7_.visible = false;
                  _loc7_.hit.alpha = 0;
                  this.mDown = false;
                  if(_loc9_.height > _loc7_.b.height)
                  {
                     _loc7_.visible = true;
                     _loc7_.hit.addEventListener(MouseEvent.MOUSE_DOWN,this.scrDown,false,0,true);
                     _loc7_.h.addEventListener(Event.ENTER_FRAME,this.hEF,false,0,true);
                     _loc9_.addEventListener(Event.ENTER_FRAME,this.dEF,false,0,true);
                     this.attachTouch();
                  }
               }
               this.tcnt.cnt.iproto.visible = false;
               break;
            case "userListIgnore":
               _loc1_ = "mcUListB";
               if(!ApplicationDomain.currentDomain.hasDefinition(_loc1_))
               {
                  trace("[Load] ERR missing linkage " + _loc1_ + " OFrameMC " + this.fData.typ);
                  return;
               }
               _loc2_ = getDefinitionByName(_loc1_) as Class;
               _loc3_ = this.mc.addChild(new _loc2_()) as MovieClip;
               _loc3_.name = "cnt";
               _loc3_.x = 10;
               _loc3_.y = this.t1.y + this.t1.height + 4;
               _loc3_.mask = this.cntMask;
               _loc3_.scr.buttonMode = true;
               this.t1.txtTitle.text = "Ignore List";
               this.t1.txtSubTitle.text = "";
               _loc10_ = 0;
               this.tcnt = MovieClip(this.mc.getChildByName("cnt"));
               this.fData.ul = [];
               for each(_loc6_ in this.rootClass.chatF.ignoreList.data.users)
               {
                  this.fData.ul.push({"sName":_loc6_});
               }
               _loc11_ = 0;
               while(_loc11_ < this.fData.ul.length)
               {
                  _loc5_ = this.tcnt.cnt.addChild(new mcUListBItem());
                  _loc5_.txtName.text = this.fData.ul[_loc11_].sName;
                  _loc5_.addEventListener(MouseEvent.CLICK,this.uNameClick,false,0,true);
                  _loc5_.buttonMode = true;
                  _loc5_.y = _loc10_ * 20;
                  _loc10_++;
                  _loc11_++;
               }
               _loc7_ = this.tcnt.scr;
               if(this.tcnt.cnt.height < this.tcnt.cntMask.height)
               {
                  _loc7_.visible = false;
                  if(this.mc.bg)
                  {
                     _loc3_.x = int(this.mc.bg.x + this.mc.bg.width / 2 - _loc3_.cntMask.width / 2);
                  }
               }
               else
               {
                  if(this.mc.bg)
                  {
                     _loc3_.x = int(this.mc.bg.x + this.mc.bg.width / 2 - _loc3_.width / 2);
                  }
                  _loc8_ = this.tcnt.cntMask;
                  _loc9_ = this.tcnt.cnt;
                  _loc7_.visible = true;
                  _loc7_.h.height = int(_loc8_.height / _loc9_.height * _loc7_.b.height);
                  this.hRun = _loc7_.b.height - _loc7_.h.height;
                  this.dRun = _loc9_.height - _loc8_.height + 5;
                  _loc7_.h.y = 0;
                  _loc9_.oy = _loc9_.y = _loc7_.y;
                  _loc7_.visible = false;
                  _loc7_.hit.alpha = 0;
                  this.mDown = false;
                  if(_loc9_.height > _loc7_.b.height)
                  {
                     _loc7_.visible = true;
                     _loc7_.hit.addEventListener(MouseEvent.MOUSE_DOWN,this.scrDown,false,0,true);
                     _loc7_.h.addEventListener(Event.ENTER_FRAME,this.hEF,false,0,true);
                     _loc9_.addEventListener(Event.ENTER_FRAME,this.dEF,false,0,true);
                     this.attachTouch();
                  }
               }
               this.tcnt.cnt.iproto.visible = false;
         }
         if(this.mc.bg.btnClose)
         {
            this.mc.bg.btnClose.addEventListener(MouseEvent.CLICK,this.closeClick,false,0,true);
         }
         if(this.mc.bg)
         {
            if(this.mc.bg.fx)
            {
               this.mc.bg.fx.visible = false;
            }
            if(this.mc.bg.btnWiki)
            {
               this.mc.bg.btnWiki.visible = false;
            }
            if(this.mc.bg.btnPin)
            {
               this.mc.bg.btnPin.visible = false;
            }
            if(this.mc.bg.btnTry)
            {
               this.mc.bg.btnTry.visible = false;
            }
         }
      }

      private function detachTouch() : void
      {
         if(this.touch != null)
         {
            this.touch.detach();
            this.touch = null;
         }
      }

      private function attachTouch() : void
      {
         this.detachTouch();
         this.touch = TouchScroll.attach(this.tcnt,this.touchGet,this.touchSet,this.touchMax);
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
         return this.tcnt.scr.h.y / this.hRun * this.dRun;
      }

      private function touchSet(param1:Number) : void
      {
         if(this.mDown || this.hRun <= 0 || this.dRun <= 0)
         {
            return;
         }
         this.tcnt.scr.h.y = param1 / this.dRun * this.hRun;
      }

      private function clearCnt() : *
      {
         this.detachTouch();
         var _loc1_:* = this.mc.getChildByName("cnt");
         if(_loc1_ != null)
         {
            this.mc.removeChild(_loc1_);
         }
      }

      private function closeClick(param1:MouseEvent) : *
      {
         this.fClose();
      }

      private function uNameClick(param1:MouseEvent) : *
      {
         var _loc1_:* = MovieClip(param1.currentTarget);
         this.rootClass.debugMessage("User clicked: " + _loc1_.txtName.text);
         var _loc2_:* = {};
         if("ID" in _loc1_)
         {
            _loc2_.ID = _loc1_.ID;
         }
         _loc2_.strUsername = _loc1_.txtName.text;
         if(this.fData.typ == "userListFriends" && _loc1_.txtMeta.text != this.rootClass.objServerInfo.sName)
         {
            this.rootClass.ui.cMenu.fOpenWith("offline",_loc2_);
         }
         else if(this.fData.typ == "userListFriends" && _loc1_.txtMeta.text == this.rootClass.objServerInfo.sName)
         {
            this.rootClass.ui.cMenu.fOpenWith("friend",_loc2_);
         }
         else if(this.fData.typ == "userListIgnore")
         {
            this.rootClass.ui.cMenu.fOpenWith("ignored",_loc2_);
         }
         else
         {
            this.rootClass.ui.cMenu.fOpenWith("user",_loc2_);
         }
      }

      private function scrUp(param1:MouseEvent) : *
      {
         this.mDown = false;
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.scrUp);
      }

      private function scrDown(param1:MouseEvent) : *
      {
         this.mbY = int(mouseY);
         this.mhY = int(this.tcnt.scr.h.y);
         this.mDown = true;
         stage.addEventListener(MouseEvent.MOUSE_UP,this.scrUp);
      }

      private function hEF(param1:Event) : *
      {
         var _loc1_:* = undefined;
         if(this.mDown)
         {
            _loc1_ = this.tcnt.scr;
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
         var _loc1_:* = this.tcnt.scr;
         var _loc2_:* = MovieClip(param1.currentTarget);
         var _loc3_:* = -_loc1_.h.y / this.hRun;
         var _loc4_:* = int(_loc3_ * this.dRun) + _loc2_.oy;
         if(Math.abs(_loc4_ - _loc2_.y) > 0.2)
         {
            _loc2_.y += (_loc4_ - _loc2_.y) / 4;
         }
         else
         {
            _loc2_.y = _loc4_;
         }
      }

      internal function frame1() : *
      {
         stop();
      }

      internal function frame6() : *
      {
         this.update();
      }

      internal function frame10() : *
      {
         stop();
      }
   }
}
