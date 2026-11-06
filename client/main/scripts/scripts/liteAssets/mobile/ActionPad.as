package liteAssets.mobile
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;
   import liteAssets.draw.*;

   public class ActionPad extends Sprite
   {

      private static var inst:ActionPad;

      private static const STAGE_W:int = 960;

      private static const LIMIT_Y:int = 500;

      private static const EDGE:int = 6;

      private static const THRESHOLD_SQ:int = 36;

      private static const SLIDE_MS:int = 150;

      private static const TRAY_X:int = 360;

      private static const TRAY_Y:int = 60;

      private static const BTN_TOP:int = 110;

      private static const BTN_BOTTOM:int = 330;

      private static const DESK_H:int = 30;

      private static const DONE_W:int = 76;

      private static const DONE_H:int = 28;

      private static const EDIT_INK:uint = 16763904;

      private static const GLYPH_OUTLINE:GlowFilter = new GlowFilter(0,1,3,3,8,2);

      private static var seq:int = 0;

      private var g:MovieClip;

      private var touch:Boolean;

      private var bh:int;

      private var hw:int;

      private var gap:int;

      private var fs:int;

      private var trayBox:Sprite = new Sprite();

      private var handle:VolumeButton;

      private var glyph:Shape = new Shape();

      private var strip:Sprite = new Sprite();

      private var loose:Sprite = new Sprite();

      private var trayBtns:Array = [];

      private var looseBtns:Array = [];

      private var hudEdit:Boolean = false;

      private var selfEdit:Boolean = false;

      private var editMode:Boolean = false;

      private var done:VolumeButton;

      private var dirLeft:Boolean = false;

      private var p:Number = 0;

      private var pFrom:Number = 0;

      private var pTo:Number = 0;

      private var t0:int = 0;

      private var dragObj:Sprite;

      private var dst:Stage;

      private var dsx:Number = 0;

      private var dsy:Number = 0;

      private var dox:Number = 0;

      private var doy:Number = 0;

      private var moving:Boolean = false;

      private var rectList:Array = [];

      private var _ver:int = 0;

      private var timer:Timer;

      public function ActionPad(param1:MovieClip)
      {
         super();
         this.g = param1;
         this.touch = Mobile.active;
         this.bh = this.touch ? int(Math.round(Mobile.touchPx() * Mobile.uiScale)) : int(DESK_H);
         this.hw = Math.round(this.bh * 0.8);
         this.gap = Math.max(4,Math.round(this.bh / 11));
         this.fs = Math.max(12,Math.min(16,Math.round(this.bh * 0.24)));
         this.handle = new VolumeButton(this.hw,this.bh,null);
         this.glyph.filters = [GLYPH_OUTLINE];
         this.handle.addChild(this.glyph);
         this.handle.addEventListener(MouseEvent.CLICK,this.onHandle,false,0,true);
         this.trayBox.addChild(this.strip);
         this.trayBox.addChild(this.handle);
         this.trayBox.addEventListener(MouseEvent.MOUSE_DOWN,this.onDown,false,0,true);
         addChild(this.trayBox);
         addChild(this.loose);
         visible = false;
         LongPress.skip(this);
         this.p = QuickActions.expanded ? 1 : 0;
         QuickActions.events.addEventListener(Event.CHANGE,this.onChange,false,0,true);
         this.rebuild();
         this.timer = new Timer(150);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTick,false,0,true);
         this.timer.start();
         this.onTick(null);
      }

      public static function start(param1:MovieClip) : void
      {
         var game:MovieClip = param1;
         if(inst != null && inst.g == game && inst.touch == Mobile.active)
         {
            return;
         }
         stop();
         try
         {
            inst = new ActionPad(game);
         }
         catch(e:Error)
         {
            inst = null;
         }
      }

      public static function stop() : void
      {
         if(inst == null)
         {
            return;
         }
         inst.destroy();
         inst = null;
      }

      public static function get current() : ActionPad
      {
         return inst;
      }

      public static function setEditing(param1:Boolean) : void
      {
         if(inst == null)
         {
            return;
         }
         inst.hudEdit = param1;
         inst.applyEdit();
      }

      public static function resetPositions() : void
      {
         if(inst != null)
         {
            inst.rebuild();
         }
      }

      public static function beginMove() : Boolean
      {
         if(inst == null || !inst.hasActions)
         {
            return false;
         }
         inst.selfEdit = true;
         inst.applyEdit();
         return true;
      }

      public function get ver() : int
      {
         return this._ver;
      }

      public function get rects() : Array
      {
         return this.rectList;
      }

      private function get hasActions() : Boolean
      {
         return this.trayBtns.length + this.looseBtns.length > 0;
      }

      private function destroy() : void
      {
         this.endDrag();
         if(this.timer != null)
         {
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.onTick);
            this.timer = null;
         }
         removeEventListener(Event.ENTER_FRAME,this.onSlide);
         QuickActions.events.removeEventListener(Event.CHANGE,this.onChange);
         this.clearBtns(this.trayBtns);
         this.clearBtns(this.looseBtns);
         this.handle.removeEventListener(MouseEvent.CLICK,this.onHandle);
         this.trayBox.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDown);
         if(this.done != null)
         {
            this.done.removeEventListener(MouseEvent.CLICK,this.onDone);
         }
         if(parent != null)
         {
            parent.removeChild(this);
         }
         this.g = null;
      }

      private function onTick(param1:TimerEvent) : void
      {
         var show:Boolean;
         var e:TimerEvent = param1;
         if(this.g == null)
         {
            return;
         }
         if(!this.hasActions)
         {
            if(visible)
            {
               visible = false;
            }
            if(parent != null)
            {
               parent.removeChild(this);
            }
            return;
         }
         this.attach();
         show = Boolean(this.editMode);
         if(!show)
         {
            try
            {
               show = this.g.world != null && this.g.world.myAvatar != null && this.g.world.bitWalk != false && !MobileHUD.windowOpenCached(this.g) && !MobileHUD.frontGame(this.g) && !(Boolean(this.touch) && this.g.stage.focus is TextField);
            }
            catch(err:Error)
            {
               show = false;
            }
         }
         if(!show)
         {
            this.endDrag();
         }
         visible = show;
      }

      private function attach() : void
      {
         var hud:DisplayObject;
         var ui:DisplayObjectContainer = null;
         var hi:int = 0;
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
            return;
         }
         if(parent != ui)
         {
            try
            {
               ui.addChildAt(this,ui.getChildIndex(this.g.ui.mcInterface));
            }
            catch(e2:Error)
            {
               ui.addChild(this);
            }
         }
         hud = MobileHUD.instance;
         if(hud != null && hud.parent == ui)
         {
            hi = ui.getChildIndex(hud);
            if(hi > ui.getChildIndex(this))
            {
               ui.setChildIndex(this,hi);
            }
         }
      }

      private function onChange(param1:Event) : void
      {
         this.rebuild();
         this.onTick(null);
      }

      private function rebuild() : void
      {
         var _loc1_:String = null;
         var _loc2_:VolumeButton = null;
         this.endDrag();
         this.clearBtns(this.trayBtns);
         this.clearBtns(this.looseBtns);
         for each(_loc1_ in QuickActions.tray)
         {
            this.trayBtns.push(this.makeBtn(_loc1_,this.strip));
         }
         for each(_loc1_ in QuickActions.buttons)
         {
            _loc2_ = this.makeBtn(_loc1_,this.loose);
            _loc2_.addEventListener(MouseEvent.MOUSE_DOWN,this.onDown,false,0,true);
            this.looseBtns.push(_loc2_);
         }
         if(!this.hasActions && Boolean(this.selfEdit))
         {
            this.selfEdit = false;
            this.applyEdit();
         }
         this.layout();
      }

      private function clearBtns(param1:Array) : void
      {
         var _loc1_:VolumeButton = null;
         for each(_loc1_ in param1)
         {
            _loc1_.removeEventListener(MouseEvent.CLICK,this.onAct);
            _loc1_.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDown);
            if(_loc1_.parent != null)
            {
               _loc1_.parent.removeChild(_loc1_);
            }
         }
         param1.length = 0;
      }

      private function makeBtn(param1:String, param2:Sprite) : VolumeButton
      {
         var _loc1_:String = QuickActions.label(param1);
         var _loc2_:TextField = MailArt.tf(this.fs,16777215,true);
         _loc2_.text = _loc1_;
         var _loc3_:VolumeButton = new VolumeButton(Math.max(Math.round(this.bh * 1.4),Math.ceil(_loc2_.textWidth) + 22),this.bh,_loc1_,this.fs);
         _loc3_.name = param1;
         _loc3_.addEventListener(MouseEvent.CLICK,this.onAct,false,0,true);
         param2.addChild(_loc3_);
         return _loc3_;
      }

      private function opts() : Object
      {
         var _loc1_:Object = null;
         try
         {
            _loc1_ = this.g.litePreference.data;
            if(_loc1_.dOptions == null)
            {
               _loc1_.dOptions = {};
            }
            return _loc1_.dOptions;
         }
         catch(e:Error)
         {
         }
         return {};
      }

      private function flush() : void
      {
         try
         {
            this.g.litePreference.flush();
         }
         catch(e:Error)
         {
         }
      }

      private function applyEdit() : void
      {
         var _loc1_:Boolean = Boolean(this.hudEdit) || Boolean(this.selfEdit);
         if(Boolean(this.selfEdit) && this.done == null)
         {
            this.done = new VolumeButton(DONE_W,DONE_H,"Done");
            if(this.touch)
            {
               this.done.scaleX = this.done.scaleY = Mobile.touchPx(7) / DONE_H;
            }
            this.done.x = Math.round((STAGE_W - DONE_W * this.done.scaleX) / 2);
            this.done.y = 10;
            this.done.addEventListener(MouseEvent.CLICK,this.onDone,false,0,true);
            addChild(this.done);
         }
         if(this.done != null)
         {
            this.done.visible = this.selfEdit;
         }
         if(this.editMode == _loc1_)
         {
            return;
         }
         this.editMode = _loc1_;
         this.endDrag();
         this.layout();
         this.onTick(null);
      }

      private function onDone(param1:MouseEvent) : void
      {
         this.selfEdit = false;
         this.applyEdit();
      }

      private function layout() : void
      {
         var _loc1_:VolumeButton = null;
         var _loc2_:Object = null;
         var _loc3_:Object = this.opts();
         var _loc4_:Object = _loc3_.posQaTray;
         var _loc5_:Boolean = Boolean(QuickActions.left);
         this.trayBox.visible = this.trayBtns.length > 0;
         this.trayBox.x = _loc4_ != null && _loc4_.x != null ? Number(_loc4_.x) : (_loc5_ ? STAGE_W - TRAY_X - this.hw : Number(TRAY_X));
         this.trayBox.y = _loc4_ != null && _loc4_.y != null ? Number(_loc4_.y) : Number(TRAY_Y);
         this.clampTo(this.trayBox,this.hw,this.bh);
         this.layoutStrip();
         var _loc6_:Object = _loc3_.posQaBtns;
         var _loc7_:Number = STAGE_W - EDGE;
         var _loc8_:Number = Number(BTN_TOP);
         var _loc9_:Number = 0;
         for each(_loc1_ in this.looseBtns)
         {
            _loc2_ = _loc6_ != null ? _loc6_[_loc1_.name] : null;
            if(_loc2_ != null && _loc2_.x != null && _loc2_.y != null)
            {
               _loc1_.x = Number(_loc2_.x);
               _loc1_.y = Number(_loc2_.y);
            }
            else
            {
               if(_loc8_ + this.bh > BTN_BOTTOM)
               {
                  _loc7_ -= _loc9_ + this.gap;
                  _loc8_ = Number(BTN_TOP);
                  _loc9_ = 0;
               }
               _loc1_.x = _loc7_ - _loc1_.width;
               _loc1_.y = _loc8_;
               _loc8_ += this.bh + this.gap;
               _loc9_ = Math.max(_loc9_,_loc1_.width);
            }
            this.clampTo(_loc1_,_loc1_.width,this.bh);
         }
         this.drawGlyph();
         this.placeStrip();
      }

      private function layoutStrip() : void
      {
         var _loc1_:VolumeButton = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Boolean = false;
         var _loc5_:Number = NaN;
         var _loc6_:Number = 0;
         for each(_loc1_ in this.trayBtns)
         {
            _loc6_ = Math.max(_loc6_,_loc1_.width);
         }
         _loc2_ = this.trayBox.x - this.gap - EDGE;
         _loc3_ = STAGE_W - EDGE - (this.trayBox.x + this.hw + this.gap);
         _loc4_ = Boolean(QuickActions.left);
         if((_loc4_ ? _loc2_ : _loc3_) < _loc6_)
         {
            _loc4_ = !_loc4_;
         }
         this.dirLeft = _loc4_;
         var _loc7_:Number = _loc4_ ? _loc2_ : _loc3_;
         var _loc8_:Boolean = this.trayBox.y - EDGE > LIMIT_Y - EDGE - (this.trayBox.y + this.bh);
         var _loc9_:Number = 0;
         var _loc10_:int = 0;
         for each(_loc1_ in this.trayBtns)
         {
            _loc5_ = _loc1_.width;
            if(_loc9_ > 0 && _loc9_ + _loc5_ > _loc7_)
            {
               _loc9_ = 0;
               _loc10_++;
            }
            _loc1_.x = _loc4_ ? -this.gap - _loc9_ - _loc5_ : this.hw + this.gap + _loc9_;
            _loc1_.y = (_loc8_ ? -_loc10_ : _loc10_) * (this.bh + this.gap);
            _loc9_ += _loc5_ + this.gap;
         }
      }

      private function clampTo(param1:DisplayObject, param2:Number, param3:Number) : void
      {
         param1.x = Math.round(Math.max(EDGE,Math.min(STAGE_W - EDGE - param2,param1.x)));
         param1.y = Math.round(Math.max(EDGE,Math.min(LIMIT_Y - EDGE - param3,param1.y)));
      }

      private function drawGlyph() : void
      {
         var _loc1_:Graphics = this.glyph.graphics;
         _loc1_.clear();
         var _loc2_:int = this.dirLeft ? -1 : 1;
         var _loc3_:Boolean = Boolean(QuickActions.expanded) || Boolean(this.editMode);
         var _loc4_:Number = this.bh * 0.5 / 16;
         var _loc5_:Number = this.hw / 2 - _loc2_ * 3 * _loc4_ - 5 * _loc4_;
         var _loc6_:Number = this.bh / 2 - 8 * _loc4_;
         _loc1_.lineStyle();
         _loc1_.beginFill(16777215);
         _loc1_.moveTo(_loc5_ + 6 * _loc4_,_loc6_);
         _loc1_.lineTo(_loc5_ + 1 * _loc4_,_loc6_ + 9 * _loc4_);
         _loc1_.lineTo(_loc5_ + 4.5 * _loc4_,_loc6_ + 9 * _loc4_);
         _loc1_.lineTo(_loc5_ + 3 * _loc4_,_loc6_ + 16 * _loc4_);
         _loc1_.lineTo(_loc5_ + 9 * _loc4_,_loc6_ + 6 * _loc4_);
         _loc1_.lineTo(_loc5_ + 5.5 * _loc4_,_loc6_ + 6 * _loc4_);
         _loc1_.lineTo(_loc5_ + 7 * _loc4_,_loc6_);
         _loc1_.lineTo(_loc5_ + 6 * _loc4_,_loc6_);
         _loc1_.endFill();
         var _loc7_:Number = _loc2_ > 0 ? this.hw - 6 * _loc4_ : 6 * _loc4_;
         var _loc8_:Number = this.bh / 2;
         var _loc9_:Number = (_loc3_ ? -_loc2_ : _loc2_) * 2.5 * _loc4_;
         _loc1_.lineStyle(2.5 * _loc4_,16777215,1,true,LineScaleMode.NORMAL,CapsStyle.ROUND,JointStyle.ROUND);
         _loc1_.moveTo(_loc7_ - _loc9_,_loc8_ - 5 * _loc4_);
         _loc1_.lineTo(_loc7_ + _loc9_,_loc8_);
         _loc1_.lineTo(_loc7_ - _loc9_,_loc8_ + 5 * _loc4_);
      }

      private function onHandle(param1:MouseEvent) : void
      {
         if(this.editMode)
         {
            return;
         }
         QuickActions.expanded = !QuickActions.expanded;
         this.drawGlyph();
         this.pFrom = this.p;
         this.pTo = QuickActions.expanded ? 1 : 0;
         this.t0 = getTimer();
         addEventListener(Event.ENTER_FRAME,this.onSlide,false,0,true);
      }

      private function onSlide(param1:Event) : void
      {
         var _loc1_:Number = Math.min(1,(getTimer() - this.t0) / SLIDE_MS);
         this.p = this.pFrom + (this.pTo - this.pFrom) * _loc1_;
         this.placeStrip();
         if(_loc1_ >= 1)
         {
            removeEventListener(Event.ENTER_FRAME,this.onSlide);
         }
      }

      private function placeStrip() : void
      {
         var _loc1_:Number = this.editMode ? 1 : Number(this.p);
         var _loc2_:int = this.dirLeft ? -1 : 1;
         this.strip.x = -_loc2_ * (1 - _loc1_) * 16;
         this.strip.alpha = _loc1_;
         this.strip.visible = _loc1_ > 0;
         this.strip.mouseChildren = _loc1_ >= 1;
         this.updateRects();
      }

      private function updateRects() : void
      {
         var _loc1_:VolumeButton = null;
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:Rectangle = null;
         var _loc5_:Rectangle = null;
         var _loc6_:Rectangle = null;
         var _loc7_:Array = [];
         if(this.trayBox.visible)
         {
            _loc4_ = new Rectangle(this.trayBox.x,this.trayBox.y,this.hw,this.bh);
            if(Boolean(this.strip.visible) && this.strip.numChildren > 0)
            {
               _loc5_ = this.strip.getBounds(this);
               _loc5_.offset(-this.strip.x,0);
               _loc4_ = _loc4_.union(_loc5_);
            }
            _loc7_.push(_loc4_);
         }
         for each(_loc1_ in this.looseBtns)
         {
            _loc7_.push(new Rectangle(_loc1_.x,_loc1_.y,_loc1_.width,this.bh));
         }
         _loc2_ = _loc7_.length == this.rectList.length;
         _loc3_ = 0;
         while(_loc2_ && _loc3_ < _loc7_.length)
         {
            _loc2_ = Boolean(Rectangle(_loc7_[_loc3_]).equals(this.rectList[_loc3_]));
            _loc3_++;
         }
         graphics.clear();
         if(this.editMode)
         {
            graphics.lineStyle(2,EDIT_INK,0.9,true);
            for each(_loc6_ in _loc7_)
            {
               graphics.drawRoundRect(_loc6_.x - 3,_loc6_.y - 3,_loc6_.width + 6,_loc6_.height + 6,10,10);
            }
         }
         if(_loc2_)
         {
            return;
         }
         this.rectList = _loc7_;
         this._ver = ++seq;
      }

      private function onAct(param1:MouseEvent) : void
      {
         if(Boolean(this.editMode) || Boolean(this.moving))
         {
            return;
         }
         QuickActions.run(DisplayObject(param1.currentTarget).name);
      }

      private function onDown(param1:MouseEvent) : void
      {
         if(!this.editMode || stage == null)
         {
            return;
         }
         this.endDrag();
         this.dragObj = Sprite(param1.currentTarget);
         this.dst = stage;
         this.dsx = param1.stageX;
         this.dsy = param1.stageY;
         this.dox = this.dragObj.x;
         this.doy = this.dragObj.y;
         this.dst.addEventListener(MouseEvent.MOUSE_MOVE,this.onMove,false,0,true);
         this.dst.addEventListener(MouseEvent.MOUSE_UP,this.onUp,false,0,true);
         this.dst.addEventListener(Event.DEACTIVATE,this.onUp,false,0,true);
         this.dst.addEventListener(Event.MOUSE_LEAVE,this.onUp,false,0,true);
      }

      private function onMove(param1:MouseEvent) : void
      {
         if(this.dragObj == null)
         {
            return;
         }
         var _loc1_:Number = param1.stageX - this.dsx;
         var _loc2_:Number = param1.stageY - this.dsy;
         if(!this.moving)
         {
            if(_loc1_ * _loc1_ + _loc2_ * _loc2_ < THRESHOLD_SQ)
            {
               return;
            }
            this.moving = true;
         }
         this.dragObj.x = this.dox + _loc1_;
         this.dragObj.y = this.doy + _loc2_;
         if(this.dragObj == this.trayBox)
         {
            this.clampTo(this.trayBox,this.hw,this.bh);
            this.layoutStrip();
            this.drawGlyph();
         }
         else
         {
            this.clampTo(this.dragObj,this.dragObj.width,this.bh);
         }
         this.updateRects();
         param1.updateAfterEvent();
      }

      private function onUp(param1:Event) : void
      {
         var _loc1_:Sprite = this.dragObj;
         var _loc2_:Boolean = Boolean(this.moving);
         this.endDrag();
         if(!_loc2_ || _loc1_ == null)
         {
            return;
         }
         var _loc3_:Object = this.opts();
         if(_loc1_ == this.trayBox)
         {
            _loc3_.posQaTray = {
               "x":int(this.trayBox.x),
               "y":int(this.trayBox.y)
            };
         }
         else
         {
            if(_loc3_.posQaBtns == null)
            {
               _loc3_.posQaBtns = {};
            }
            _loc3_.posQaBtns[_loc1_.name] = {
               "x":int(_loc1_.x),
               "y":int(_loc1_.y)
            };
         }
         this.flush();
      }

      private function endDrag() : void
      {
         if(this.dst != null)
         {
            this.dst.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMove);
            this.dst.removeEventListener(MouseEvent.MOUSE_UP,this.onUp);
            this.dst.removeEventListener(Event.DEACTIVATE,this.onUp);
            this.dst.removeEventListener(Event.MOUSE_LEAVE,this.onUp);
            this.dst = null;
         }
         this.dragObj = null;
         this.moving = false;
      }
   }
}
