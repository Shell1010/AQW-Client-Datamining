package liteAssets.mobile
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;
   import liteAssets.draw.*;

   public class DropTray extends Sprite
   {

      private static var inst:DropTray;

      private static const STAGE_W:int = 960;

      private static const STAGE_H:int = 550;

      private static const THRESHOLD_SQ:int = 36;

      private static const EDGE:int = 6;

      private static const GAP:int = 6;

      private static const PAD:int = 5;

      private static const LIFT:int = 4;

      private static const MAX_VIS:int = 6;

      private static const HOLD_MS:int = 500;

      private static const MOVE_SQ:int = 64;

      private static const FADE_MS:int = 150;

      private static const TICK_MS:int = 100;

      private static const PLATE:uint = 2105376;

      private static const BAR:Rectangle = new Rectangle(347,487,267,40);

      private static const NUM_GLOW:Array = [new GlowFilter(0,1,3,3,4,2)];

      private static var editMode:Boolean = false;

      private var g:MovieClip;

      private var cd:*;

      private var sw:int;

      private var sh:int;

      private var sg:int;

      private var row:Sprite;

      private var plate:Sprite;

      private var outline:Shape;

      private var ghosts:Array = [];

      private var hasPos:Boolean = false;

      private var px:Number = 0;

      private var py:Number = 0;

      private var mst:Stage;

      private var moving:Boolean = false;

      private var followPending:Boolean = false;

      private var msx:Number = 0;

      private var msy:Number = 0;

      private var mox:Number = 0;

      private var moy:Number = 0;

      private var view:Sprite;

      private var strip:Sprite;

      private var fadeL:Sprite;

      private var fadeR:Sprite;

      private var count:Sprite;

      private var countTf:TextField;

      private var slots:Array = [];

      private var byKey:Object = {};

      private var pool:Array = [];

      private var scroller:TouchScroll;

      private var pos:Number = 0;

      private var viewW:int = 0;

      private var contentW:int = -1;

      private var plateW:int = -1;

      private var zones:Array = [];

      private var timer:Timer;

      private var hold:Timer;

      private var busyAt:int = 0;

      private var pst:Stage;

      private var pressSlot:DropSlot;

      private var sx:Number = 0;

      private var sy:Number = 0;

      private var cancelled:Boolean = false;

      private var fired:Boolean = false;

      private var pop:DropPopover;

      private var popSlot:DropSlot;

      private var gst:Stage;

      private var fadeTarget:Number = 1;

      private var fadeFrom:Number = 1;

      private var fadeT0:int = 0;

      public function DropTray(param1:MovieClip)
      {
         super();
         this.g = param1;
         tabEnabled = false;
         tabChildren = false;
         this.measureSlots();
         this.sh = DropSlot.slotH(this.sw);
         this.row = new Sprite();
         addChild(this.row);
         this.plate = new Sprite();
         this.row.addChild(this.plate);
         this.outline = new Shape();
         this.outline.visible = false;
         this.row.addChild(this.outline);
         this.view = new Sprite();
         this.view.x = PAD;
         this.row.addChild(this.view);
         this.strip = new Sprite();
         this.view.addChild(this.strip);
         this.fadeL = this.fade(false);
         this.fadeR = this.fade(true);
         this.row.addChild(this.fadeL);
         this.row.addChild(this.fadeR);
         this.count = new Sprite();
         this.count.mouseEnabled = false;
         this.count.mouseChildren = false;
         this.countTf = MailArt.tf(11,16777215,true);
         this.countTf.filters = NUM_GLOW;
         this.count.addChild(this.countTf);
         this.count.visible = false;
         this.row.addChild(this.count);
         this.scroller = TouchScroll.attach(this.row,this.getPos,this.setPos,this.getMax,true);
         this.row.addEventListener(MouseEvent.MOUSE_DOWN,this.onRowDown,false,0,true);
         this.loadPos();
      }

      public static function sync(param1:*) : void
      {
         var t:DropTray = null;
         var cd:* = param1;
         var n:int = 0;
         try
         {
            if(cd != null && Boolean(Mobile.useDropTray) && Mobile.game != null)
            {
               n = int(cd.invTree.length);
            }
         }
         catch(e:Error)
         {
            n = 0;
         }
         if(Mobile.useDropTray)
         {
            hideDesktopIcon(Mobile.game);
         }
         if(n <= 0)
         {
            if(inst != null)
            {
               if(editMode)
               {
                  inst.emptyOut();
               }
               else
               {
                  inst.destroy();
               }
            }
            return;
         }
         if(inst == null)
         {
            t = new DropTray(Mobile.game);
            if(!t.attach())
            {
               t.destroy();
               return;
            }
            inst = t;
         }
         inst.update(cd);
      }

      public static function close(param1:*) : void
      {
         if(inst == null || param1 != null && inst.cd != param1)
         {
            return;
         }
         if(editMode)
         {
            inst.emptyOut();
         }
         else
         {
            inst.destroy();
         }
      }

      public static function setEditing(param1:Boolean) : void
      {
         var _loc1_:DropTray = null;
         if(editMode == param1)
         {
            return;
         }
         editMode = param1;
         if(param1 && inst == null && Boolean(Mobile.useDropTray) && Mobile.game != null)
         {
            _loc1_ = new DropTray(Mobile.game);
            if(!_loc1_.attach())
            {
               _loc1_.destroy();
               return;
            }
            inst = _loc1_;
         }
         if(inst == null)
         {
            return;
         }
         inst.applyEdit();
         if(!param1 && inst.slots.length == 0)
         {
            inst.destroy();
         }
      }

      public static function resetPos() : void
      {
         if(inst != null)
         {
            inst.clearPos();
         }
      }

      private static function hideDesktopIcon(param1:MovieClip) : void
      {
         var _loc1_:DisplayObject = null;
         try
         {
            _loc1_ = param1.ui.mcPortrait.iconDrops as DisplayObject;
            if(_loc1_ != null && _loc1_.visible)
            {
               _loc1_.visible = false;
            }
         }
         catch(e:Error)
         {
         }
      }

      private function measureSlots() : void
      {
         var _loc1_:DisplayObjectContainer = null;
         var _loc2_:Rectangle = null;
         var _loc3_:Rectangle = null;
         this.sw = 42;
         this.sg = 3;
         try
         {
            _loc1_ = this.g.ui.mcInterface.actBar as DisplayObjectContainer;
            _loc2_ = _loc1_.getChildByName("blank0").getBounds(this.g.ui as DisplayObject);
            _loc3_ = _loc1_.getChildByName("blank1").getBounds(this.g.ui as DisplayObject);
            if(_loc2_.width > 20 && _loc3_.x > _loc2_.x)
            {
               this.sw = Math.round(_loc2_.width);
               this.sg = Math.max(0,Math.round(_loc3_.x - _loc2_.x) - this.sw);
            }
         }
         catch(e:Error)
         {
         }
      }

      private function attach() : Boolean
      {
         var ui:DisplayObjectContainer = null;
         ui = null;
         try
         {
            ui = this.g.ui as DisplayObjectContainer;
         }
         catch(e:Error)
         {
            ui = null;
         }
         if(ui == null)
         {
            return false;
         }
         try
         {
            ui.addChildAt(this,ui.getChildIndex(this.g.ui.mcInterface) + 1);
         }
         catch(e2:Error)
         {
            ui.addChild(this);
         }
         this.timer = new Timer(TICK_MS);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTick,false,0,true);
         this.timer.start();
         this.onTick(null);
         return true;
      }

      public function destroy() : void
      {
         var _loc1_:DropSlot = null;
         if(inst == this)
         {
            inst = null;
         }
         if(this.timer != null)
         {
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.onTick);
            this.timer = null;
         }
         this.endPress();
         this.endMove();
         this.row.removeEventListener(MouseEvent.MOUSE_DOWN,this.onRowDown);
         if(this.hold != null)
         {
            this.hold.stop();
            this.hold.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onHold);
            this.hold = null;
         }
         this.closePop();
         if(this.pop != null)
         {
            this.pop.destroy();
            this.pop = null;
         }
         if(this.scroller != null)
         {
            this.scroller.detach();
            this.scroller = null;
         }
         removeEventListener(Event.ENTER_FRAME,this.onFade);
         var _loc2_:Array = this.slots.concat(this.pool,this.ghosts);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc1_ = _loc2_[_loc3_];
            _loc1_.removeEventListener(MouseEvent.MOUSE_DOWN,this.onSlotDown);
            _loc1_.dispose();
            _loc3_++;
         }
         this.slots = [];
         this.pool = [];
         this.ghosts = [];
         this.byKey = {};
         if(parent != null)
         {
            parent.removeChild(this);
         }
         this.g = null;
         this.cd = null;
      }

      private function update(param1:*) : void
      {
         var _loc1_:int = 0;
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc4_:DropSlot = null;
         var _loc5_:DropSlot = null;
         this.cd = param1;
         var _loc6_:Array = this.cd.invTree as Array;
         var _loc7_:Object = this.cd.itemCount;
         var _loc8_:Array = [];
         var _loc9_:Object = {};
         var _loc10_:Boolean = false;
         _loc1_ = 0;
         while(_loc6_ != null && _loc1_ < _loc6_.length)
         {
            _loc2_ = _loc6_[_loc1_];
            if(_loc2_ != null)
            {
               _loc3_ = String(_loc2_.dID);
               if(_loc9_[_loc3_] != true)
               {
                  _loc9_[_loc3_] = true;
                  _loc4_ = this.byKey[_loc3_] as DropSlot;
                  if(_loc4_ == null)
                  {
                     _loc4_ = this.pool.length > 0 ? DropSlot(this.pool.pop()) : this.newSlot();
                     _loc4_.key = _loc3_;
                     this.strip.addChild(_loc4_);
                     _loc10_ = true;
                  }
                  _loc4_.show(_loc2_,int(_loc7_[_loc2_.dID]),this.g);
                  _loc8_.push(_loc4_);
               }
            }
            _loc1_++;
         }
         var _loc11_:Boolean = false;
         _loc1_ = 0;
         while(_loc1_ < this.slots.length)
         {
            _loc5_ = this.slots[_loc1_];
            if(_loc9_[_loc5_.key] != true)
            {
               _loc11_ = true;
               if(_loc5_ == this.pressSlot)
               {
                  this.endPress();
               }
               if(_loc5_ == this.popSlot)
               {
                  this.closePop();
               }
               if(_loc5_.parent != null)
               {
                  _loc5_.parent.removeChild(_loc5_);
               }
               _loc5_.reset();
               this.pool.push(_loc5_);
            }
            _loc1_++;
         }
         this.slots = _loc8_;
         this.byKey = {};
         _loc1_ = 0;
         while(_loc1_ < this.slots.length)
         {
            this.byKey[DropSlot(this.slots[_loc1_]).key] = this.slots[_loc1_];
            _loc1_++;
         }
         if(_loc10_ || _loc11_)
         {
            _loc1_ = 0;
            while(_loc1_ < this.slots.length)
            {
               DropSlot(this.slots[_loc1_]).owned = DropSlot.isOwned(this.g,DropSlot(this.slots[_loc1_]).item);
               _loc1_++;
            }
         }
         var _loc12_:Boolean = _loc10_ && this.pos >= this.getMax() - 0.5;
         var _loc13_:Boolean = Boolean(this.trayBusy());
         if(_loc12_ && _loc13_)
         {
            this.followPending = true;
         }
         this.layout();
         if(_loc12_ && !_loc13_)
         {
            this.setPos(this.getMax());
         }
         if(this.pop != null && this.pop.parent != null && this.popSlot != null)
         {
            this.pop.setQty(int(_loc7_[this.popSlot.item.dID]));
            this.placePop();
         }
      }

      private function newSlot() : DropSlot
      {
         var _loc1_:DropSlot = new DropSlot(this.sw);
         _loc1_.addEventListener(MouseEvent.MOUSE_DOWN,this.onSlotDown,false,0,true);
         return _loc1_;
      }

      private function fade(param1:Boolean) : Sprite
      {
         var _loc1_:Sprite = null;
         _loc1_ = new Sprite();
         _loc1_.mouseEnabled = false;
         _loc1_.mouseChildren = false;
         var _loc2_:Matrix = new Matrix();
         _loc2_.createGradientBox(10,10,param1 ? Math.PI : 0,0,0);
         _loc1_.graphics.beginGradientFill(GradientType.LINEAR,[PLATE,PLATE,PLATE],[1,0.7,0],[0,110,255],_loc2_);
         _loc1_.graphics.drawRect(0,0,10,10);
         _loc1_.graphics.endFill();
         _loc1_.visible = false;
         return _loc1_;
      }

      private function barRect() : Rectangle
      {
         var _loc1_:DisplayObjectContainer = null;
         var _loc2_:DisplayObject = null;
         var _loc3_:DisplayObject = null;
         var _loc4_:Rectangle = null;
         try
         {
            _loc1_ = this.g.ui.mcInterface.actBar as DisplayObjectContainer;
            _loc2_ = _loc1_.getChildByName("blank0");
            _loc3_ = _loc1_.getChildByName("blank5");
            if(_loc2_ != null && _loc3_ != null && parent != null)
            {
               _loc4_ = _loc2_.getBounds(parent).union(_loc3_.getBounds(parent));
               if(_loc4_.width > 0 && _loc4_.top > 300)
               {
                  return _loc4_;
               }
            }
         }
         catch(e:Error)
         {
         }
         return BAR;
      }

      private function layout() : void
      {
         var _loc1_:Point = null;
         var _loc2_:Rectangle = null;
         var _loc3_:Graphics = null;
         var _loc4_:DropSlot = null;
         var _loc5_:int = int(this.slots.length);
         var _loc6_:int = Math.max(0,MAX_VIS - _loc5_);
         var _loc7_:int = _loc5_ + _loc6_;
         var _loc8_:Boolean = _loc5_ > MAX_VIS;
         this.viewW = MAX_VIS * this.sw + (MAX_VIS - 1) * this.sg;
         var _loc9_:int = _loc7_ * this.sw + (_loc7_ - 1) * this.sg;
         var _loc10_:int = PAD * 2 + this.viewW;
         var _loc11_:int = this.sh + PAD * 2;
         this.zones = MobileHUD.zones();
         if(!this.moving)
         {
            if(this.hasPos)
            {
               _loc1_ = this.resolve(this.px,this.py,_loc10_,_loc11_);
               this.row.x = _loc1_.x;
               this.row.y = _loc1_.y;
            }
            else
            {
               _loc2_ = this.barRect();
               this.row.x = Math.max(EDGE,Math.min(STAGE_W - EDGE - _loc10_,Math.round(_loc2_.x + _loc2_.width / 2 - _loc10_ / 2)));
               this.row.y = Math.round(_loc2_.top - LIFT - _loc11_);
            }
         }
         if(_loc10_ != this.plateW)
         {
            this.plateW = _loc10_;
            this.drawPlate(_loc10_,_loc11_);
         }
         if(_loc9_ != this.contentW)
         {
            this.contentW = _loc9_;
            _loc3_ = this.strip.graphics;
            _loc3_.clear();
            _loc3_.beginFill(0,0);
            _loc3_.drawRect(0,0,Math.max(this.viewW,_loc9_),this.sh);
            _loc3_.endFill();
         }
         var _loc12_:int = 0;
         while(_loc12_ < _loc5_)
         {
            _loc4_ = this.slots[_loc12_];
            _loc4_.x = _loc12_ * (this.sw + this.sg);
            _loc4_.y = 0;
            _loc12_++;
         }
         this.layoutGhosts(_loc5_,_loc6_);
         var _loc13_:int = Math.round(this.sw * 0.7);
         this.fadeL.x = PAD;
         this.fadeR.x = PAD + this.viewW - _loc13_;
         this.fadeL.y = this.fadeR.y = PAD;
         this.fadeL.width = this.fadeR.width = _loc13_;
         this.fadeL.height = this.fadeR.height = this.sh;
         this.count.visible = _loc8_;
         if(_loc8_)
         {
            this.drawCount(_loc5_);
         }
         this.pos = Math.max(0,Math.min(this.getMax(),this.pos));
         this.applyScroll();
      }

      private function layoutGhosts(param1:int, param2:int) : void
      {
         var _loc1_:int = 0;
         var _loc2_:DropSlot = null;
         _loc1_ = 0;
         while(_loc1_ < param2)
         {
            if(_loc1_ < this.ghosts.length)
            {
               _loc2_ = this.ghosts[_loc1_];
            }
            else
            {
               _loc2_ = new DropSlot(this.sw);
               _loc2_.mouseEnabled = false;
               _loc2_.alpha = 0.45;
               _loc2_.show(null,0,this.g);
               this.ghosts.push(_loc2_);
            }
            if(_loc2_.parent != this.strip)
            {
               this.strip.addChild(_loc2_);
            }
            _loc2_.x = (param1 + _loc1_) * (this.sw + this.sg);
            _loc2_.y = 0;
            _loc1_++;
         }
         _loc1_ = param2;
         while(_loc1_ < this.ghosts.length)
         {
            if(this.ghosts[_loc1_].parent != null)
            {
               this.ghosts[_loc1_].parent.removeChild(this.ghosts[_loc1_]);
            }
            _loc1_++;
         }
      }

      private function resolve(param1:Number, param2:Number, param3:Number, param4:Number) : Point
      {
         var _loc1_:int = 0;
         var _loc2_:Rectangle = null;
         var _loc3_:Boolean = false;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = STAGE_W - EDGE - param3;
         var _loc9_:Number = STAGE_H - EDGE - param4;
         param1 = Math.max(EDGE,Math.min(_loc8_,param1));
         param2 = Math.max(EDGE,Math.min(_loc9_,param2));
         var _loc10_:Array = [];
         _loc1_ = 0;
         while(_loc1_ < this.zones.length)
         {
            _loc2_ = Rectangle(this.zones[_loc1_]).clone();
            _loc2_.inflate(GAP * 2,GAP * 2);
            _loc10_.push(_loc2_);
            _loc1_++;
         }
         _loc2_ = this.barRect().clone();
         _loc2_.inflate(GAP,GAP);
         _loc10_.push(_loc2_);
         var _loc11_:int = 0;
         while(_loc11_ < 6)
         {
            _loc3_ = false;
            _loc1_ = 0;
            while(_loc1_ < _loc10_.length)
            {
               _loc2_ = _loc10_[_loc1_];
               if(!(param1 >= _loc2_.right || param1 + param3 <= _loc2_.left || param2 >= _loc2_.bottom || param2 + param4 <= _loc2_.top))
               {
                  _loc4_ = param1;
                  _loc5_ = param2;
                  _loc6_ = Number.MAX_VALUE;
                  _loc7_ = _loc2_.left - param3;
                  if(_loc7_ >= EDGE && param1 - _loc7_ < _loc6_)
                  {
                     _loc6_ = param1 - _loc7_;
                     _loc4_ = _loc7_;
                     _loc5_ = param2;
                  }
                  _loc7_ = _loc2_.right;
                  if(_loc7_ <= _loc8_ && _loc7_ - param1 < _loc6_)
                  {
                     _loc6_ = _loc7_ - param1;
                     _loc4_ = _loc7_;
                     _loc5_ = param2;
                  }
                  _loc7_ = _loc2_.top - param4;
                  if(_loc7_ >= EDGE && param2 - _loc7_ < _loc6_)
                  {
                     _loc6_ = param2 - _loc7_;
                     _loc4_ = param1;
                     _loc5_ = _loc7_;
                  }
                  _loc7_ = _loc2_.bottom;
                  if(_loc7_ <= _loc9_ && _loc7_ - param2 < _loc6_)
                  {
                     _loc6_ = _loc7_ - param2;
                     _loc4_ = param1;
                     _loc5_ = _loc7_;
                  }
                  if(_loc6_ != Number.MAX_VALUE)
                  {
                     param1 = _loc4_;
                     param2 = _loc5_;
                     _loc3_ = true;
                  }
               }
               _loc1_++;
            }
            if(!_loc3_)
            {
               break;
            }
            _loc11_++;
         }
         return new Point(Math.round(param1),Math.round(param2));
      }

      private function loadPos() : void
      {
         var p:Object = null;
         try
         {
            p = this.g.litePreference.data.dOptions.posDrops;
            if(p != null && p.x != null && p.y != null)
            {
               this.px = Number(p.x);
               this.py = Number(p.y);
               this.hasPos = !isNaN(this.px) && !isNaN(this.py);
            }
         }
         catch(e:Error)
         {
            hasPos = false;
         }
      }

      private function savePos() : void
      {
         var _loc1_:Object = null;
         try
         {
            _loc1_ = this.g.litePreference.data;
            if(_loc1_.dOptions == null)
            {
               _loc1_.dOptions = {};
            }
            _loc1_.dOptions.posDrops = {
               "x":int(this.px),
               "y":int(this.py)
            };
            this.g.litePreference.flush();
         }
         catch(e:Error)
         {
         }
      }

      private function clearPos() : void
      {
         this.hasPos = false;
         this.layout();
         this.placePop();
      }

      private function emptyOut() : void
      {
         var _loc1_:DropSlot = null;
         this.endPress();
         this.closePop();
         this.cd = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.slots.length)
         {
            _loc1_ = this.slots[_loc2_];
            if(_loc1_.parent != null)
            {
               _loc1_.parent.removeChild(_loc1_);
            }
            _loc1_.reset();
            this.pool.push(_loc1_);
            _loc2_++;
         }
         this.slots = [];
         this.byKey = {};
         this.layout();
      }

      private function applyEdit() : void
      {
         this.endPress();
         this.closePop();
         this.row.mouseChildren = !editMode;
         this.outline.visible = editMode;
         if(!editMode)
         {
            this.endMove();
         }
         this.layout();
      }

      private function onRowDown(param1:MouseEvent) : void
      {
         if(!editMode || stage == null)
         {
            return;
         }
         this.endMove();
         this.mst = stage;
         this.msx = param1.stageX;
         this.msy = param1.stageY;
         this.mox = this.row.x;
         this.moy = this.row.y;
         this.mst.addEventListener(MouseEvent.MOUSE_MOVE,this.onMoveMove,false,0,true);
         this.mst.addEventListener(MouseEvent.MOUSE_UP,this.onMoveUp,false,0,true);
      }

      private function onMoveMove(param1:MouseEvent) : void
      {
         var _loc1_:Number = param1.stageX - this.msx;
         var _loc2_:Number = param1.stageY - this.msy;
         if(!this.moving)
         {
            if(_loc1_ * _loc1_ + _loc2_ * _loc2_ < THRESHOLD_SQ)
            {
               return;
            }
            this.moving = true;
         }
         this.row.x = Math.round(Math.max(EDGE,Math.min(STAGE_W - EDGE - this.plateW,this.mox + _loc1_)));
         this.row.y = Math.round(Math.max(EDGE,Math.min(STAGE_H - EDGE - (this.sh + PAD * 2),this.moy + _loc2_)));
         this.placePop();
         param1.updateAfterEvent();
      }

      private function onMoveUp(param1:MouseEvent) : void
      {
         var _loc1_:Boolean = Boolean(this.moving);
         this.endMove();
         if(!_loc1_)
         {
            return;
         }
         var _loc2_:Point = this.resolve(this.row.x,this.row.y,this.plateW,this.sh + PAD * 2);
         this.px = _loc2_.x;
         this.py = _loc2_.y;
         this.hasPos = true;
         this.savePos();
         this.layout();
         this.placePop();
      }

      private function endMove() : void
      {
         if(this.mst != null)
         {
            this.mst.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMoveMove);
            this.mst.removeEventListener(MouseEvent.MOUSE_UP,this.onMoveUp);
            this.mst = null;
         }
         this.moving = false;
      }

      private function drawPlate(param1:int, param2:int) : void
      {
         var _loc1_:Graphics = this.outline.graphics;
         _loc1_.clear();
         _loc1_.lineStyle(2,15255671,1);
         _loc1_.drawRoundRect(0,0,param1,param2,PAD * 3,PAD * 3);
         var _loc2_:Graphics = this.plate.graphics;
         _loc2_.clear();
         var _loc3_:Number = PAD * 3;
         var _loc4_:Matrix = new Matrix();
         _loc4_.createGradientBox(param1,param2,Math.PI / 2,0,0);
         _loc2_.lineStyle(1,0,1,true);
         _loc2_.beginGradientFill(GradientType.LINEAR,[1579032,2697513],[0.92,0.92],[0,255],_loc4_);
         _loc2_.drawRoundRect(0,0,param1,param2,_loc3_,_loc3_);
         _loc2_.endFill();
         _loc2_.lineStyle(1,5460819,1,true);
         _loc2_.moveTo(_loc3_ / 2,1.5);
         _loc2_.lineTo(param1 - _loc3_ / 2,1.5);
      }

      private function drawCount(param1:int) : void
      {
         this.countTf.text = String(param1);
         var _loc1_:int = 14;
         var _loc2_:int = Math.max(16,Math.ceil(this.countTf.textWidth) + 8);
         var _loc3_:Graphics = this.count.graphics;
         _loc3_.clear();
         _loc3_.lineStyle(1,MailArt.TRIM,1,true);
         _loc3_.beginFill(1118481,0.9);
         _loc3_.drawRoundRect(0,0,_loc2_,_loc1_,_loc1_,_loc1_);
         _loc3_.endFill();
         this.countTf.x = Math.round((_loc2_ - this.countTf.width) / 2);
         this.countTf.y = Math.round((_loc1_ - this.countTf.height) / 2);
         this.count.x = this.plateW - _loc2_ - 2;
         this.count.y = -6;
      }

      private function getPos() : Number
      {
         return this.pos;
      }

      private function trayBusy() : Boolean
      {
         return this.pressSlot != null || this.popSlot != null || Boolean(this.moving) || Boolean(TouchScroll.dragging);
      }

      private function setPos(param1:Number) : void
      {
         this.followPending = false;
         this.pos = Math.max(0,Math.min(this.getMax(),param1));
         this.applyScroll();
         this.placePop();
      }

      private function getMax() : Number
      {
         return Math.max(0,this.contentW - this.viewW);
      }

      private function applyScroll() : void
      {
         this.view.scrollRect = new Rectangle(Math.round(this.pos),-PAD,this.viewW,this.sh + PAD * 2);
         var _loc1_:Number = Number(this.getMax());
         this.fadeL.visible = this.pos > 0.5;
         this.fadeR.visible = this.pos < _loc1_ - 0.5;
      }

      private function onTick(param1:TimerEvent) : void
      {
         if(this.g == null || stage == null)
         {
            return;
         }
         if(this.busyAt != 0 && getTimer() - this.busyAt > 3000)
         {
            this.busyAt = 0;
            if(this.pop != null)
            {
               this.pop.busy = false;
            }
         }
         var _loc1_:Boolean = Boolean(MobileHUD.windowOpenCached(this.g)) || Boolean(this.chatFocused());
         this.fadeTo(!_loc1_);
         if(_loc1_)
         {
            this.endPress();
            this.closePop();
            return;
         }
         hideDesktopIcon(this.g);
         if(Boolean(this.followPending) && !this.trayBusy())
         {
            this.setPos(this.getMax());
         }
         if(!this.sameZones(MobileHUD.zones()))
         {
            this.layout();
            this.placePop();
         }
      }

      private function chatFocused() : Boolean
      {
         try
         {
            return this.g.stage != null && this.g.stage.focus is TextField;
         }
         catch(e:Error)
         {
         }
         return false;
      }

      private function sameZones(param1:Array) : Boolean
      {
         if(param1 == this.zones)
         {
            return true;
         }
         if(param1.length != this.zones.length)
         {
            return false;
         }
         var _loc1_:int = 0;
         while(_loc1_ < param1.length)
         {
            if(!Rectangle(param1[_loc1_]).equals(this.zones[_loc1_]))
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }

      private function fadeTo(param1:Boolean) : void
      {
         var _loc1_:Number = param1 ? 1 : 0;
         if(_loc1_ == this.fadeTarget)
         {
            return;
         }
         this.fadeTarget = _loc1_;
         this.fadeFrom = alpha;
         this.fadeT0 = getTimer();
         mouseChildren = param1;
         visible = true;
         addEventListener(Event.ENTER_FRAME,this.onFade,false,0,true);
      }

      private function onFade(param1:Event) : void
      {
         var _loc1_:Number = Math.min(1,(getTimer() - this.fadeT0) / FADE_MS);
         alpha = this.fadeFrom + (this.fadeTarget - this.fadeFrom) * _loc1_;
         if(_loc1_ < 1)
         {
            return;
         }
         removeEventListener(Event.ENTER_FRAME,this.onFade);
         visible = this.fadeTarget > 0;
      }

      private function onSlotDown(param1:MouseEvent) : void
      {
         if(this.fadeTarget < 1 || stage == null)
         {
            return;
         }
         this.endPress();
         this.pressSlot = DropSlot(param1.currentTarget);
         this.sx = param1.stageX;
         this.sy = param1.stageY;
         this.cancelled = false;
         this.fired = false;
         this.pressSlot.pressed = true;
         this.pst = stage;
         this.pst.addEventListener(MouseEvent.MOUSE_MOVE,this.onPressMove,false,0,true);
         this.pst.addEventListener(MouseEvent.MOUSE_UP,this.onPressUp,false,0,true);
         if(this.hold == null)
         {
            this.hold = new Timer(HOLD_MS,1);
            this.hold.addEventListener(TimerEvent.TIMER_COMPLETE,this.onHold,false,0,true);
         }
         this.hold.reset();
         this.hold.start();
      }

      private function onPressMove(param1:MouseEvent) : void
      {
         if(this.pressSlot == null || Boolean(this.cancelled))
         {
            return;
         }
         var _loc1_:Number = param1.stageX - this.sx;
         var _loc2_:Number = param1.stageY - this.sy;
         if(_loc1_ * _loc1_ + _loc2_ * _loc2_ < MOVE_SQ && !TouchScroll.dragging)
         {
            return;
         }
         this.cancelled = true;
         this.pressSlot.pressed = false;
         if(this.hold != null)
         {
            this.hold.stop();
         }
      }

      private function onHold(param1:TimerEvent) : void
      {
         var _loc1_:DropSlot = this.pressSlot;
         if(_loc1_ == null || Boolean(this.cancelled) || Boolean(this.fired) || Boolean(TouchScroll.dragging))
         {
            return;
         }
         this.fired = true;
         _loc1_.pressed = false;
         this.closePop();
         this.act(DropPopover.PREVIEW,_loc1_.item);
      }

      private function onPressUp(param1:MouseEvent) : void
      {
         var _loc1_:DropSlot = this.pressSlot;
         var _loc2_:Boolean = _loc1_ != null && !this.cancelled && !this.fired && _loc1_.stage != null && _loc1_.hitTestPoint(param1.stageX,param1.stageY);
         this.endPress();
         if(!_loc2_)
         {
            return;
         }
         if(this.popSlot == _loc1_ && this.pop != null && this.pop.parent != null)
         {
            this.closePop();
         }
         else
         {
            this.openPop(_loc1_);
         }
      }

      private function endPress() : void
      {
         if(this.pst != null)
         {
            this.pst.removeEventListener(MouseEvent.MOUSE_MOVE,this.onPressMove);
            this.pst.removeEventListener(MouseEvent.MOUSE_UP,this.onPressUp);
            this.pst = null;
         }
         if(this.hold != null)
         {
            this.hold.stop();
         }
         if(this.pressSlot != null)
         {
            this.pressSlot.pressed = false;
         }
         this.pressSlot = null;
      }

      private function openPop(param1:DropSlot) : void
      {
         if(param1 == null || param1.item == null || this.cd == null)
         {
            return;
         }
         if(this.pop == null)
         {
            this.pop = new DropPopover(this.g,this.onPopAction);
         }
         if(this.popSlot != null)
         {
            this.popSlot.selected = false;
         }
         this.popSlot = param1;
         param1.selected = true;
         var _loc1_:Number = param1.x - this.pos;
         if(_loc1_ < 0)
         {
            this.setPos(param1.x);
         }
         else if(_loc1_ + this.sw > this.viewW)
         {
            this.setPos(param1.x + this.sw - this.viewW);
         }
         addChild(this.pop);
         var _loc2_:Boolean = Boolean(DropSlot.isOwned(this.g,param1.item));
         param1.owned = _loc2_;
         this.busyAt = 0;
         this.pop.open(param1.item,int(this.cd.itemCount[param1.item.dID]),param1.key,_loc2_);
         this.placePop();
         if(this.gst == null && this.g != null && this.g.stage != null)
         {
            this.gst = this.g.stage;
            this.gst.addEventListener(MouseEvent.MOUSE_DOWN,this.onStageDown,true,0,true);
         }
      }

      private function placePop() : void
      {
         if(this.pop == null || this.pop.parent == null || this.popSlot == null)
         {
            return;
         }
         var _loc1_:Number = Math.max(0,Math.min(this.viewW,this.popSlot.x - this.pos + this.sw / 2));
         var _loc2_:Number = this.row.y - GAP;
         if(_loc2_ - this.pop.boxH < EDGE)
         {
            _loc2_ = this.row.y + this.sh + PAD * 2 + GAP + this.pop.boxH;
         }
         this.pop.place(this.row.x + PAD + _loc1_,_loc2_,this.zones);
      }

      private function closePop() : void
      {
         this.busyAt = 0;
         if(this.popSlot != null)
         {
            this.popSlot.selected = false;
         }
         this.popSlot = null;
         if(this.pop != null && this.pop.parent != null)
         {
            this.pop.parent.removeChild(this.pop);
         }
         if(this.gst != null)
         {
            this.gst.removeEventListener(MouseEvent.MOUSE_DOWN,this.onStageDown,true);
            this.gst = null;
         }
      }

      private function onStageDown(param1:MouseEvent) : void
      {
         var _loc1_:DisplayObject = param1.target as DisplayObject;
         if(_loc1_ != null && (this.pop != null && Boolean(this.pop.contains(_loc1_)) || Boolean(this.row.contains(_loc1_))))
         {
            return;
         }
         this.closePop();
      }

      private function onPopAction(param1:String) : void
      {
         if(this.pop == null)
         {
            return;
         }
         var _loc1_:Object = this.pop.item;
         if(_loc1_ == null)
         {
            this.closePop();
            return;
         }
         if(param1 == DropPopover.ACCEPT)
         {
            if(this.send(_loc1_))
            {
               this.pop.busy = true;
               this.busyAt = getTimer() | 1;
            }
            return;
         }
         this.closePop();
         this.act(param1,_loc1_);
      }

      private function act(param1:String, param2:Object) : void
      {
         if(this.cd == null || param2 == null)
         {
            return;
         }
         try
         {
            if(param1 == DropPopover.DECLINE)
            {
               this.cd.declineDrop(param2);
            }
            else if(param1 == DropPopover.PREVIEW)
            {
               this.cd.previewDrop(param2);
            }
         }
         catch(e:Error)
         {
         }
      }

      private function send(param1:Object) : Boolean
      {
         if(this.cd == null || param1 == null)
         {
            return false;
         }
         try
         {
            return this.cd.requestDrop(param1,true) == true;
         }
         catch(e:Error)
         {
         }
         return false;
      }
   }
}
