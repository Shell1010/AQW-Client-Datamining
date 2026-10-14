package liteAssets.mobile
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;
   import liteAssets.draw.*;

   public class MobileHUD extends Sprite
   {

      private static var inst:MobileHUD;

      private static const STAGE_W:int = 960;

      private static const LIMIT_Y:int = 500;

      private static const BASE:int = 44;

      private static const GLYPH_Y:int = 15;

      private static const DONE_W:int = 76;

      private static const DONE_H:int = 28;

      private static const JOY_X:int = 55;

      private static const JOY_Y:int = 175;

      private static const ZONE_MM:Number = 32;

      private static const ZONE_MIN:int = 260;

      private static const ZONE_MAX:int = 360;

      private static const ZONE_FLOOR:int = 120;

      private static const BAR_RECT:Rectangle = new Rectangle(347,487,267,40);

      private static const CHAT_RECT:Rectangle = new Rectangle(0,380,380,170);

      private static const SKILL_X:int = 890;

      private static const SKILL_Y:int = 430;

      private static const TAB_X:int = 0;

      private static const TAB_Y:int = 230;

      private static const THRESHOLD_SQ:int = 36;

      private static const INK:uint = 16777215;

      private static const INK_ON:uint = 16763904;

      private static const OUTLINE:GlowFilter = new GlowFilter(0,1,3,3,10,1);

      private static const GLYPH_OUTLINE:GlowFilter = new GlowFilter(0,1,3,3,8,2);

      private static const IDENT:ColorTransform = new ColorTransform();

      private static const DARK:ColorTransform = new ColorTransform(0.8,0.8,0.8);

      private static const JOY_I:int = 0;

      private static const SKILLS_I:int = 1;

      private static const MOUSE_I:int = 4;

      private static const HIDE_I:int = 5;

      private static const SLIDE_MS:int = 150;

      private static var zCache:Array = [];

      private static var zKey:Array = [];

      private static const FADE_MS:int = 150;

      private static const CHAR_PAGE:String = "liteAssets.draw::charPage";

      private static const WIN_CACHE_MS:int = 250;

      private static var winAt:int = -WIN_CACHE_MS;

      private static var winVal:Boolean = false;

      private var g:MovieClip;

      private var joy:Joystick;

      private var skills:SkillCluster;

      private var tab:Sprite;

      private var tabFace:Shape;

      private var tabFill:Shape;

      private var tabHold:HoldPress;

      private var px:Number = 0;

      private var py:Number = 0;

      private var chevron:Shape;

      private var bar:Sprite;

      private var done:VolumeButton;

      private var btnS:int;

      private var gap:int;

      private var pad:int;

      private var tabW:int;

      private var tabH:int;

      private var barW:int;

      private var artOk:Boolean = false;

      private var buttons:Array;

      private var callbacks:Array;

      private var faces:Array;

      private var glyphs:Array;

      private var lbls:Array;

      private var kinds:Array;

      private var offs:Array;

      private var pressedIdx:int = -1;

      private var pst:Stage;

      private var timer:Timer;

      private var st:Stage;

      private var drag:Sprite;

      private var dragging:Boolean = false;

      private var sx:Number = 0;

      private var sy:Number = 0;

      private var ox:Number = 0;

      private var oy:Number = 0;

      private var editing:Boolean = false;

      private var open:Boolean = false;

      private var barP:Number = 0;

      private var slideFrom:Number = 0;

      private var slideTo:Number = 0;

      private var slideT0:int = 0;

      private var joyShown:Boolean = true;

      private var zone:Rectangle;

      private var zoneKey:Vector.<Number>;

      private var zoneKeyOk:Boolean = false;

      private var barCache:Rectangle;

      private var gst:Stage;

      private var vm:VirtualMouse;

      private var onTop:Boolean = false;

      private var fadeTarget:Number = 1;

      private var fadeFrom:Number = 1;

      private var fadeT0:int = 0;

      public function MobileHUD(param1:MovieClip)
      {
         var game:MovieClip = param1;
         this.buttons = [];
         this.callbacks = [];
         this.faces = [];
         this.glyphs = [];
         this.lbls = [];
         this.kinds = [];
         this.offs = [];
         this.zoneKey = new Vector.<Number>(12,true);
         super();
         this.g = game;
         this.tabW = Mobile.touchPx(7);
         this.tabH = Math.max(56,Mobile.touchPx(12));
         this.btnS = Mobile.touchPx();
         this.gap = Math.max(4,Math.round(this.btnS * 4 / BASE));
         this.pad = this.gap;
         this.btnS = Math.min(this.btnS,Math.floor((STAGE_W - this.tabW - this.gap * 9) / 6));
         this.barW = this.btnS * 6 + this.gap * 5;
         this.joy = new Joystick();
         addChild(this.joy);
         this.skills = new SkillCluster();
         addChild(this.skills);
         this.tab = new Sprite();
         this.tab.mouseChildren = false;
         this.tabFace = new Shape();
         this.tab.addChild(this.tabFace);
         this.tabFill = new Shape();
         this.tab.addChild(this.tabFill);
         this.tabHold = new HoldPress(this.tabFill);
         this.chevron = new Shape();
         this.chevron.filters = [GLYPH_OUTLINE];
         this.tab.addChild(this.chevron);
         this.artOk = NativeArt.menu(false) != null;
         this.drawTab(false);
         addChild(this.tab);
         this.bar = new Sprite();
         this.bar.visible = false;
         this.drawPlate();
         addChild(this.bar);
         this.makeBtn("Joy","joy",this.onJoyToggle);
         this.makeBtn("Skills","skills",this.onSkillsToggle);
         this.makeBtn("Move","move",this.onEdit);
         this.makeBtn("Reset","reset",this.onReset);
         this.makeBtn("Mouse","mouse",this.onMouseToggle);
         this.makeBtn("Hide","hide",this.onCollapse);
         this.tab.addEventListener(MouseEvent.MOUSE_DOWN,this.onDragDown,false,0,true);
         this.joy.addEventListener(MouseEvent.MOUSE_DOWN,this.onDragDown,false,0,true);
         this.skills.addEventListener(MouseEvent.MOUSE_DOWN,this.onDragDown,false,0,true);
         this.skills.addEventListener(Event.CHANGE,this.onSkillsCollapse,false,0,true);
         this.skills.addEventListener(SkillCluster.HOLD_HINT,this.onSkillsHint,false,0,true);
         this.applyPositions();
         this.applySkillsBtn();
         this.applyJoy();
         this.drawChevron();
         this.attach(false);
         try
         {
            this.gst = this.g.stage;
            if(this.gst != null)
            {
               this.gst.addEventListener(MouseEvent.MOUSE_DOWN,this.onStageDown,true,0,true);
            }
            this.vm = new VirtualMouse(this.g,this.joy,JOY_X + Joystick.PAD,SKILL_X - this.skills.extL);
            this.vm.addEventListener(Event.CLOSE,this.onVmClose,false,0,true);
            this.vm.addEventListener(Event.CHANGE,this.onVmMoved,false,0,true);
            this.vm.addEventListener(VirtualMouse.MINIMIZE,this.onVmMin,false,0,true);
            this.applyMouse();
            addEventListener(MouseEvent.MOUSE_DOWN,this.onOwnPress,false,0,true);
            addEventListener(MouseEvent.CLICK,this.onOwnPress,false,0,true);
            this.timer = new Timer(100);
            this.timer.addEventListener(TimerEvent.TIMER,this.onTick,false,0,true);
            this.timer.start();
            this.onTick(null);
            inst = this;
         }
         catch(err:Error)
         {
            destroy();
            throw err;
         }
      }

      public static function zones() : Array
      {
         var _loc1_:MobileHUD = inst;
         if(_loc1_ == null || _loc1_.g == null)
         {
            if(zCache.length > 0)
            {
               zCache = [];
            }
            zKey.length = 0;
            return zCache;
         }
         _loc1_.refreshZone();
         var _loc2_:Rectangle = _loc1_.zone;
         var _loc3_:Object = _loc1_.opts();
         var _loc4_:Boolean = _loc3_.bJoyHidden == true;
         var _loc5_:Boolean = _loc3_.bSkillsHidden == true;
         var _loc6_:Array = zKey;
         if(_loc6_.length == 14 && _loc2_ != null && _loc6_[10] == _loc2_.x && _loc6_[11] == _loc2_.y && _loc6_[12] == _loc2_.width && _loc6_[13] == _loc2_.height && _loc6_[0] == _loc4_ && _loc6_[1] == _loc5_ && _loc6_[2] == _loc1_.x + _loc1_.joy.x && _loc6_[3] == _loc1_.y + _loc1_.joy.y && _loc6_[4] == _loc1_.x + _loc1_.skills.x && _loc6_[5] == _loc1_.y + _loc1_.skills.y && _loc6_[6] == _loc1_.skills.extL && _loc6_[7] == _loc1_.skills.extT && _loc6_[8] == _loc1_.skills.extR && _loc6_[9] == _loc1_.skills.extB)
         {
            return zCache;
         }
         var _loc7_:Array = [];
         if(!_loc4_)
         {
            _loc7_.push(new Rectangle(_loc1_.x + _loc2_.x,_loc1_.y + _loc2_.y,_loc2_.width,_loc2_.height));
         }
         var _loc8_:Rectangle = _loc1_.skills.handleRect;
         if(_loc5_)
         {
            _loc7_.push(new Rectangle(_loc1_.x + _loc1_.skills.x + _loc8_.x,_loc1_.y + _loc1_.skills.y + _loc8_.y,_loc8_.width,_loc8_.height));
         }
         else
         {
            _loc7_.push(new Rectangle(_loc1_.x + _loc1_.skills.x - _loc1_.skills.extL,_loc1_.y + _loc1_.skills.y - _loc1_.skills.extT,_loc1_.skills.extL + _loc1_.skills.extR,_loc1_.skills.extT + _loc1_.skills.extB));
         }
         zKey = [_loc4_,_loc5_,_loc1_.x + _loc1_.joy.x,_loc1_.y + _loc1_.joy.y,_loc1_.x + _loc1_.skills.x,_loc1_.y + _loc1_.skills.y,_loc1_.skills.extL,_loc1_.skills.extT,_loc1_.skills.extR,_loc1_.skills.extB,_loc2_.x,_loc2_.y,_loc2_.width,_loc2_.height];
         zCache = _loc7_;
         return _loc7_;
      }

      public static function windowOpenCached(param1:MovieClip) : Boolean
      {
         if(getTimer() - winAt < WIN_CACHE_MS)
         {
            return winVal;
         }
         return windowOpenStore(param1);
      }

      private static function windowOpenStore(param1:MovieClip) : Boolean
      {
         winVal = windowOpen(param1);
         winAt = getTimer();
         return winVal;
      }

      public static function frontGame(param1:MovieClip) : Boolean
      {
         var _loc2_:* = undefined;
         var _loc3_:Boolean = false;
         var _loc4_:* = 0;
         try
         {
            _loc2_ = param1.world != null ? param1.world.FG : null;
            if(_loc2_ == null || !_loc2_.visible)
            {
               return false;
            }
            _loc3_ = false;
            _loc4_ = int(_loc2_.numChildren - 1);
            while(_loc4_ >= 0)
            {
               if(_loc2_.getChildAt(_loc4_).visible)
               {
                  _loc3_ = true;
                  break;
               }
               _loc4_--;
            }
            return _loc3_ && !windowOpen(param1,true);
         }
         catch(e:Error)
         {
         }
         return false;
      }

      public static function windowOpen(param1:MovieClip, param2:Boolean = false) : Boolean
      {
         var ui:MovieClip = null;
         var p:MovieClip = null;
         var o:MovieClip = null;
         var i:int = 0;
         var fg:* = undefined;
         var st:Stage = null;
         var hm:DisplayObject = null;
         var c:DisplayObject = null;
         var g:MovieClip = param1;
         var skipFront:Boolean = param2;
         try
         {
            ui = g.ui;
            p = ui.mcPopup;
            if(p != null && p.visible && p.currentFrame > 1 && p.currentLabel != "Idle")
            {
               if(p.currentLabel != "House")
               {
                  return true;
               }
               hm = p.getChildByName("mcHouseMenu");
               if(hm != null && hm.visible)
               {
                  return true;
               }
            }
            if(ui.ModalStack != null && ui.ModalStack.numChildren > 0)
            {
               return true;
            }
            o = ui.mcOFrame;
            if(o != null && o.visible && o.currentLabel != "Init")
            {
               return true;
            }
            if(ui.getChildByName("qRewardPrev") != null || ui.getChildByName("mcStatsPanel") != null)
            {
               return true;
            }
            fg = g.world != null ? g.world.FG : null;
            if(!skipFront && fg != null && Boolean(fg.visible))
            {
               i = fg.numChildren - 1;
               while(i >= 0)
               {
                  if(fg.getChildAt(i).visible)
                  {
                     return true;
                  }
                  i--;
               }
            }
            i = ui.numChildren - 1;
            while(i >= 0)
            {
               c = ui.getChildAt(i);
               if(c is MailWindow || getQualifiedClassName(c) == CHAR_PAGE)
               {
                  return true;
               }
               i--;
            }
            st = g.stage;
            i = st.numChildren - 1;
            while(i >= 0)
            {
               if(st.getChildAt(i) is VolumePanel)
               {
                  return true;
               }
               i--;
            }
         }
         catch(e:Error)
         {
            return false;
         }
         return false;
      }

      public function destroy() : void
      {
         if(inst == this)
         {
            inst = null;
         }
         GameKeys.setActive(false);
         removeEventListener(MouseEvent.MOUSE_DOWN,this.onOwnPress);
         removeEventListener(MouseEvent.CLICK,this.onOwnPress);
         if(this.timer != null)
         {
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.onTick);
            this.timer = null;
         }
         if(this.gst != null)
         {
            this.gst.removeEventListener(MouseEvent.MOUSE_DOWN,this.onStageDown,true);
            this.gst = null;
         }
         this.endDrag();
         this.releaseBtn();
         removeEventListener(Event.ENTER_FRAME,this.onSlide);
         if(this.vm != null)
         {
            this.vm.removeEventListener(Event.CLOSE,this.onVmClose);
            this.vm.removeEventListener(Event.CHANGE,this.onVmMoved);
            this.vm.removeEventListener(VirtualMouse.MINIMIZE,this.onVmMin);
            this.vm.destroy();
            this.vm = null;
         }
         this.tab.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDragDown);
         this.joy.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDragDown);
         this.skills.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDragDown);
         this.skills.removeEventListener(Event.CHANGE,this.onSkillsCollapse);
         this.skills.removeEventListener(SkillCluster.HOLD_HINT,this.onSkillsHint);
         if(this.done != null)
         {
            this.done.removeEventListener(MouseEvent.CLICK,this.onDone);
         }
         var _loc1_:int = 0;
         while(_loc1_ < this.buttons.length)
         {
            this.buttons[_loc1_].removeEventListener(MouseEvent.CLICK,this.callbacks[_loc1_]);
            this.buttons[_loc1_].removeEventListener(MouseEvent.MOUSE_DOWN,this.onBtnPress);
            _loc1_++;
         }
         this.buttons = [];
         this.callbacks = [];
         DropTray.setEditing(false);
         this.joy.destroy();
         this.skills.destroy();
         if(parent != null)
         {
            parent.removeChild(this);
         }
         this.g = null;
      }

      private function opts() : Object
      {
         var _loc1_:Object = this.g.litePreference.data;
         if(_loc1_.dOptions == null)
         {
            _loc1_.dOptions = {};
         }
         return _loc1_.dOptions;
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

      private function drawTab(param1:Boolean) : void
      {
         NativeArt.menuFace(this.tabFace.graphics,this.tabW,this.tabH,param1);
         this.tabFace.transform.colorTransform = param1 ? DARK : IDENT;
      }

      private function drawPlate() : void
      {
         var _loc1_:Graphics = this.bar.graphics;
         _loc1_.clear();
         var _loc2_:Number = this.barW + this.pad * 2;
         var _loc3_:Number = this.btnS + this.pad * 2;
         var _loc4_:Number = this.pad * 3;
         var _loc5_:Matrix = new Matrix();
         _loc5_.createGradientBox(_loc2_,_loc3_,Math.PI / 2,-this.pad,-this.pad);
         _loc1_.lineStyle(1,0,1,true);
         _loc1_.beginGradientFill(GradientType.LINEAR,[1579032,2697513],[0.96,0.96],[0,255],_loc5_);
         _loc1_.drawRoundRect(-this.pad,-this.pad,_loc2_,_loc3_,_loc4_,_loc4_);
         _loc1_.endFill();
         _loc1_.lineStyle(1,5460819,1,true);
         _loc1_.moveTo(-this.pad + _loc4_ / 2,-this.pad + 1.5);
         _loc1_.lineTo(-this.pad + _loc2_ - _loc4_ / 2,-this.pad + 1.5);
      }

      private function makeBtn(param1:String, param2:String, param3:Function) : void
      {
         var _loc4_:int = int(this.buttons.length);
         var _loc5_:Sprite = new Sprite();
         _loc5_.mouseChildren = false;
         var _loc6_:Shape = new Shape();
         _loc5_.addChild(_loc6_);
         var _loc7_:Shape = new Shape();
         _loc7_.x = BASE / 2;
         _loc7_.filters = [GLYPH_OUTLINE];
         _loc5_.addChild(_loc7_);
         var _loc8_:TextField = MailArt.tf(10,16777215,true);
         _loc8_.filters = [OUTLINE];
         _loc8_.text = param1;
         _loc8_.x = Math.round((BASE - _loc8_.width) / 2);
         _loc5_.addChild(_loc8_);
         _loc5_.scaleX = _loc5_.scaleY = this.btnS / BASE;
         _loc5_.x = _loc4_ * (this.btnS + this.gap);
         _loc5_.addEventListener(MouseEvent.CLICK,param3,false,0,true);
         _loc5_.addEventListener(MouseEvent.MOUSE_DOWN,this.onBtnPress,false,0,true);
         this.callbacks.push(param3);
         this.buttons.push(_loc5_);
         this.faces.push(_loc6_);
         this.glyphs.push(_loc7_);
         this.lbls.push(_loc8_);
         this.kinds.push(param2);
         this.offs.push(false);
         this.bar.addChild(_loc5_);
         this.drawBtn(_loc4_);
      }

      private function setOff(param1:int, param2:Boolean) : void
      {
         this.offs[param1] = param2;
         this.drawBtn(param1);
      }

      private function drawBtn(param1:int) : void
      {
         var _loc2_:Boolean = param1 == this.pressedIdx;
         var _loc3_:Shape = this.faces[param1];
         var _loc4_:Shape = this.glyphs[param1];
         var _loc5_:TextField = this.lbls[param1];
         var _loc6_:int = _loc2_ ? 1 : 0;
         NativeArt.menuFace(_loc3_.graphics,BASE,BASE,_loc2_);
         _loc3_.transform.colorTransform = _loc2_ ? DARK : IDENT;
         this.drawGlyph(param1,_loc2_ ? uint(INK_ON) : uint(INK));
         _loc4_.y = GLYPH_Y + _loc6_;
         _loc5_.y = BASE - _loc5_.height - 1 + _loc6_;
         _loc4_.alpha = this.offs[param1] ? 0.35 : 1;
         _loc5_.alpha = this.offs[param1] ? 0.5 : 1;
      }

      private function drawGlyph(param1:int, param2:uint) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         var _loc9_:int = 0;
         var _loc3_:Graphics = Shape(this.glyphs[param1]).graphics;
         _loc3_.clear();
         var _loc4_:String = this.kinds[param1];
         if(_loc4_ == "joy")
         {
            _loc3_.beginFill(param2);
            _loc3_.drawEllipse(-9,4,18,6);
            _loc3_.endFill();
            _loc3_.lineStyle(2.5,param2,1,true,LineScaleMode.NORMAL,CapsStyle.ROUND);
            _loc3_.moveTo(0,6);
            _loc3_.lineTo(0,-2);
            _loc3_.lineStyle();
            _loc3_.beginFill(param2);
            _loc3_.drawCircle(0,-5,4.5);
            _loc3_.endFill();
         }
         else if(_loc4_ == "skills")
         {
            _loc3_.beginFill(param2);
            _loc3_.drawRoundRect(-9,-9,8,8,3,3);
            _loc3_.drawRoundRect(1,-9,8,8,3,3);
            _loc3_.drawRoundRect(-9,1,8,8,3,3);
            _loc3_.drawRoundRect(1,1,8,8,3,3);
            _loc3_.endFill();
         }
         else if(_loc4_ == "move")
         {
            _loc3_.lineStyle(2,param2,1,true,LineScaleMode.NORMAL,CapsStyle.ROUND);
            _loc3_.moveTo(-6,0);
            _loc3_.lineTo(6,0);
            _loc3_.moveTo(0,-6);
            _loc3_.lineTo(0,6);
            _loc3_.lineStyle();
            _loc3_.beginFill(param2);
            this.arrowHead(_loc3_,0,-10,0,1);
            this.arrowHead(_loc3_,0,10,0,-1);
            this.arrowHead(_loc3_,-10,0,1,0);
            this.arrowHead(_loc3_,10,0,-1,0);
            _loc3_.endFill();
         }
         else if(_loc4_ == "reset")
         {
            _loc5_ = -70 * Math.PI / 180;
            _loc6_ = 220 * Math.PI / 180;
            _loc3_.lineStyle(2,param2,1,true,LineScaleMode.NORMAL,CapsStyle.ROUND);
            _loc3_.moveTo(7 * Math.cos(_loc5_),7 * Math.sin(_loc5_));
            _loc7_ = 1;
            while(_loc7_ <= 18)
            {
               _loc8_ = _loc5_ + (_loc6_ - _loc5_) * _loc7_ / 18;
               _loc3_.lineTo(7 * Math.cos(_loc8_),7 * Math.sin(_loc8_));
               _loc7_++;
            }
            _loc3_.lineStyle();
            _loc3_.beginFill(param2);
            this.arrowHead(_loc3_,7 * Math.cos(_loc5_) + 4.5 * Math.sin(_loc5_),7 * Math.sin(_loc5_) - 4.5 * Math.cos(_loc5_),-Math.sin(_loc5_),Math.cos(_loc5_));
            _loc3_.endFill();
         }
         else if(_loc4_ == "mouse")
         {
            _loc3_.lineStyle(2,param2,1,true,LineScaleMode.NORMAL,CapsStyle.ROUND,JointStyle.ROUND);
            _loc3_.drawRoundRect(-6.5,-9,13,19,12,12);
            _loc3_.moveTo(-6.5,-1.5);
            _loc3_.lineTo(6.5,-1.5);
            _loc3_.moveTo(0,-9);
            _loc3_.lineTo(0,-6.5);
            _loc3_.lineStyle();
            _loc3_.beginFill(param2);
            _loc3_.drawRoundRect(-1.5,-6.5,3,4.5,3,3);
            _loc3_.endFill();
         }
         else
         {
            _loc9_ = this.rightSide() ? -1 : 1;
            _loc3_.lineStyle(2.5,param2,1,true,LineScaleMode.NORMAL,CapsStyle.ROUND,JointStyle.ROUND);
            _loc3_.moveTo(0,-7);
            _loc3_.lineTo(6 * _loc9_,0);
            _loc3_.lineTo(0,7);
            _loc3_.moveTo(-6 * _loc9_,-7);
            _loc3_.lineTo(0,0);
            _loc3_.lineTo(-6 * _loc9_,7);
         }
      }

      private function arrowHead(param1:Graphics, param2:Number, param3:Number, param4:Number, param5:Number) : void
      {
         param1.moveTo(param2,param3);
         param1.lineTo(param2 + param4 * 4.5 - param5 * 4,param3 + param5 * 4.5 + param4 * 4);
         param1.lineTo(param2 + param4 * 4.5 + param5 * 4,param3 + param5 * 4.5 - param4 * 4);
         param1.lineTo(param2,param3);
      }

      private function onBtnPress(param1:MouseEvent) : void
      {
         this.releaseBtn();
         this.pressedIdx = this.buttons.indexOf(param1.currentTarget);
         if(this.pressedIdx < 0)
         {
            return;
         }
         this.drawBtn(this.pressedIdx);
         this.pst = Sprite(param1.currentTarget).stage;
         if(this.pst != null)
         {
            this.pst.addEventListener(MouseEvent.MOUSE_UP,this.onBtnRelease,false,0,true);
         }
      }

      private function onBtnRelease(param1:MouseEvent) : void
      {
         this.releaseBtn();
      }

      private function releaseBtn() : void
      {
         if(this.pst != null)
         {
            this.pst.removeEventListener(MouseEvent.MOUSE_UP,this.onBtnRelease);
            this.pst = null;
         }
         var _loc1_:int = int(this.pressedIdx);
         this.pressedIdx = -1;
         if(_loc1_ >= 0 && _loc1_ < this.buttons.length)
         {
            this.drawBtn(_loc1_);
         }
      }

      private function applyPositions() : void
      {
         var _loc1_:Object = this.opts();
         var _loc2_:Object = _loc1_.posJoy;
         this.joy.x = _loc2_ != null && _loc2_.x != null ? Number(_loc2_.x) : Number(JOY_X);
         this.joy.y = _loc2_ != null && _loc2_.y != null ? Number(_loc2_.y) : Number(JOY_Y);
         _loc2_ = _loc1_.posMobileTab;
         this.tab.x = _loc2_ != null && _loc2_.x != null ? Number(_loc2_.x) : Number(TAB_X);
         this.tab.y = _loc2_ != null && _loc2_.y != null ? Number(_loc2_.y) : Number(TAB_Y);
         _loc2_ = _loc1_.posSkills;
         this.skills.x = _loc2_ != null && _loc2_.x != null ? Number(_loc2_.x) : Number(SKILL_X);
         this.skills.y = _loc2_ != null && _loc2_.y != null ? Number(_loc2_.y) : Number(SKILL_Y);
         this.clampJoy();
         this.clampSkills();
         this.clampTab();
         this.placeBar();
         this.refreshZone();
      }

      private function zoneSame() : Boolean
      {
         var _loc1_:Vector.<Number> = this.zoneKey;
         var _loc2_:Boolean = Boolean(this.zoneKeyOk);
         this.zoneKeyOk = true;
         _loc2_ = Boolean(this.zset(_loc1_,0,this.joy.x)) && _loc2_;
         _loc2_ = Boolean(this.zset(_loc1_,1,this.joy.y)) && _loc2_;
         _loc2_ = Boolean(this.zset(_loc1_,2,this.skills.x)) && _loc2_;
         _loc2_ = Boolean(this.zset(_loc1_,3,this.skills.y)) && _loc2_;
         _loc2_ = Boolean(this.zset(_loc1_,4,this.skills.extL)) && _loc2_;
         _loc2_ = Boolean(this.zset(_loc1_,5,this.skills.extT)) && _loc2_;
         _loc2_ = Boolean(this.zset(_loc1_,6,this.skills.extR)) && _loc2_;
         _loc2_ = Boolean(this.zset(_loc1_,7,this.skills.extB)) && _loc2_;
         _loc2_ = Boolean(this.zset(_loc1_,8,this.tab.x)) && _loc2_;
         _loc2_ = Boolean(this.zset(_loc1_,9,this.tab.y)) && _loc2_;
         return Boolean(this.zset(_loc1_,10,this.opts().bSkillsHidden == true ? 1 : 0)) && _loc2_;
      }

      private function zset(param1:Vector.<Number>, param2:int, param3:Number) : Boolean
      {
         if(param1[param2] == param3)
         {
            return true;
         }
         param1[param2] = param3;
         return false;
      }

      private function refreshZone() : void
      {
         if(this.zoneSame())
         {
            return;
         }
         this.barCache = null;
         var _loc1_:Number = Number(Mobile.physPx(ZONE_MM));
         _loc1_ = _loc1_ > 0 ? Math.max(ZONE_MIN,Math.min(ZONE_MAX,_loc1_)) : Number(ZONE_MIN);
         var _loc2_:Number = this.joy.x + Joystick.PAD / 2;
         var _loc3_:Number = this.joy.y + Joystick.PAD / 2;
         var _loc4_:Rectangle = new Rectangle(Math.max(0,Math.min(STAGE_W - _loc1_,_loc2_ - _loc1_ / 2)),Math.max(0,Math.min(LIMIT_Y - _loc1_,_loc3_ - _loc1_ / 2)),_loc1_,_loc1_);
         var _loc5_:Rectangle = this.skills.handleRect;
         if(this.opts().bSkillsHidden == true)
         {
            _loc4_ = this.cutZone(_loc4_,new Rectangle(this.skills.x + _loc5_.x,this.skills.y + _loc5_.y,_loc5_.width,_loc5_.height),_loc2_,_loc3_);
         }
         else
         {
            _loc4_ = this.cutZone(_loc4_,new Rectangle(this.skills.x - this.skills.extL,this.skills.y - this.skills.extT,this.skills.extL + this.skills.extR,this.skills.extT + this.skills.extB),_loc2_,_loc3_);
         }
         _loc4_ = this.cutZone(_loc4_,new Rectangle(this.tab.x,this.tab.y,this.tabW,this.tabH),_loc2_,_loc3_);
         _loc4_ = this.cutZone(_loc4_,this.barRect(),_loc2_,_loc3_);
         _loc4_ = this.cutZone(_loc4_,CHAT_RECT,_loc2_,_loc3_);
         if(this.zone != null && Boolean(this.zone.equals(_loc4_)))
         {
            return;
         }
         this.zone = _loc4_;
         this.joy.setZone(new Rectangle(_loc4_.x - this.joy.x,_loc4_.y - this.joy.y,_loc4_.width,_loc4_.height));
      }

      private function barRect() : Rectangle
      {
         var _loc1_:DisplayObjectContainer = null;
         var _loc2_:DisplayObject = null;
         var _loc3_:DisplayObject = null;
         var _loc4_:Rectangle = null;
         if(this.barCache != null)
         {
            return this.barCache;
         }
         this.barCache = BAR_RECT;
         try
         {
            _loc1_ = this.g.ui.mcInterface.actBar as DisplayObjectContainer;
            _loc2_ = _loc1_.getChildByName("blank0");
            _loc3_ = _loc1_.getChildByName("blank5");
            if(_loc2_ != null && _loc3_ != null)
            {
               _loc4_ = _loc2_.getBounds(this).union(_loc3_.getBounds(this));
               if(_loc4_.width > 0 && _loc4_.top > 300)
               {
                  this.barCache = _loc4_;
               }
            }
         }
         catch(e:Error)
         {
         }
         return this.barCache;
      }

      private function cutZone(param1:Rectangle, param2:Rectangle, param3:Number, param4:Number) : Rectangle
      {
         var _loc7_:Rectangle = null;
         if(!param1.intersects(param2))
         {
            return param1;
         }
         var _loc5_:Rectangle = param1;
         var _loc6_:Number = -1;
         var _loc8_:Array = [];
         if(param2.left > param3)
         {
            _loc8_.push(new Rectangle(param1.x,param1.y,param2.left - param1.x,param1.height));
         }
         if(param2.right < param3)
         {
            _loc8_.push(new Rectangle(param2.right,param1.y,param1.right - param2.right,param1.height));
         }
         if(param2.top > param4)
         {
            _loc8_.push(new Rectangle(param1.x,param1.y,param1.width,param2.top - param1.y));
         }
         if(param2.bottom < param4)
         {
            _loc8_.push(new Rectangle(param1.x,param2.bottom,param1.width,param1.bottom - param2.bottom));
         }
         for each(_loc7_ in _loc8_)
         {
            if(_loc7_.width >= ZONE_FLOOR && _loc7_.height >= ZONE_FLOOR && _loc7_.width * _loc7_.height > _loc6_)
            {
               _loc6_ = _loc7_.width * _loc7_.height;
               _loc5_ = _loc7_;
            }
         }
         return _loc5_;
      }

      private function clampJoy() : void
      {
         this.joy.x = Math.round(Math.max(0,Math.min(STAGE_W - Joystick.PAD,this.joy.x)));
         this.joy.y = Math.round(Math.max(0,Math.min(LIMIT_Y - Joystick.PAD,this.joy.y)));
      }

      private function clampSkills() : void
      {
         this.skills.x = Math.round(Math.max(this.skills.extL,Math.min(STAGE_W - this.skills.extR,this.skills.x)));
         this.skills.y = Math.round(Math.max(this.skills.extT,Math.min(LIMIT_Y - this.skills.extB,this.skills.y)));
      }

      private function clampTab() : void
      {
         this.tab.x = Math.round(Math.max(0,Math.min(STAGE_W - this.tabW,this.tab.x)));
         this.tab.y = Math.round(Math.max(0,Math.min(LIMIT_Y - this.tabH,this.tab.y)));
      }

      private function rightSide() : Boolean
      {
         return this.tab.x < STAGE_W / 2;
      }

      private function placeBar() : void
      {
         var _loc1_:Number = Math.max(this.pad,Math.min(this.tab.y + (this.tabH - this.btnS) / 2,LIMIT_Y - this.btnS - this.pad));
         var _loc2_:int = this.rightSide() ? 1 : -1;
         var _loc3_:Number = this.rightSide() ? this.tab.x + this.tabW + this.gap + this.pad : this.tab.x - this.gap - this.pad - this.barW;
         _loc3_ = Math.max(this.pad,Math.min(STAGE_W - this.barW - this.pad,_loc3_));
         this.bar.x = _loc3_ - _loc2_ * (1 - this.barP) * (this.btnS + this.tabW);
         this.bar.y = _loc1_;
         this.bar.alpha = this.barP;
         this.bar.visible = this.barP > 0;
      }

      private function drawChevron() : void
      {
         var _loc1_:Graphics = this.chevron.graphics;
         _loc1_.clear();
         var _loc2_:Number = Math.min(this.tabW / 28,this.tabH / 56);
         _loc1_.lineStyle(3 * _loc2_,INK,1,true,LineScaleMode.NORMAL,CapsStyle.ROUND,JointStyle.ROUND);
         var _loc3_:Boolean = this.rightSide() != this.open;
         var _loc4_:Number = this.tabW / 2;
         var _loc5_:Number = this.tabH / 2;
         var _loc6_:Number = (_loc3_ ? 1 : -1) * _loc2_;
         _loc1_.moveTo(_loc4_ - 4 * _loc6_,_loc5_ - 9 * _loc2_);
         _loc1_.lineTo(_loc4_ + 4 * _loc6_,_loc5_);
         _loc1_.lineTo(_loc4_ - 4 * _loc6_,_loc5_ + 9 * _loc2_);
         if(this.buttons.length > HIDE_I)
         {
            this.drawBtn(HIDE_I);
         }
      }

      private function applyJoy() : void
      {
         var _loc1_:Boolean = this.opts().bJoyHidden == true;
         this.setOff(JOY_I,_loc1_);
         if(_loc1_ && !this.editing)
         {
            if(this.joyShown)
            {
               this.joy.release();
            }
            this.joyShown = false;
            this.joy.visible = false;
         }
         else
         {
            this.joyShown = true;
            this.joy.visible = true;
            this.onTick(null);
         }
      }

      private function blocked() : Boolean
      {
         var f:* = undefined;
         var w:* = undefined;
         try
         {
            f = this.g.stage.focus;
            if(f is TextField)
            {
               return true;
            }
            w = this.g.world;
            if(w == null || w.bitWalk == false)
            {
               return true;
            }
         }
         catch(e:Error)
         {
            return true;
         }
         return false;
      }

      private function fadeHud(param1:Boolean) : void
      {
         var _loc2_:Number = param1 ? 1 : 0;
         if(_loc2_ == this.fadeTarget)
         {
            return;
         }
         if(!param1)
         {
            this.endDrag();
         }
         this.fadeTarget = _loc2_;
         this.fadeFrom = alpha;
         this.fadeT0 = getTimer();
         mouseChildren = param1;
         visible = true;
         addEventListener(Event.ENTER_FRAME,this.onFade,false,0,true);
      }

      private function onFade(param1:Event) : void
      {
         var _loc2_:Number = Math.min(1,(getTimer() - this.fadeT0) / FADE_MS);
         alpha = this.fadeFrom + (this.fadeTarget - this.fadeFrom) * _loc2_;
         if(_loc2_ < 1)
         {
            return;
         }
         removeEventListener(Event.ENTER_FRAME,this.onFade);
         visible = this.fadeTarget > 0;
      }

      private function onTick(param1:TimerEvent) : void
      {
         if(this.g == null)
         {
            return;
         }
         var _loc2_:Boolean = Boolean(windowOpenStore(this.g));
         var _loc3_:Boolean = !this.editing && _loc2_ && frontGame(this.g);
         if(_loc3_ != this.onTop)
         {
            this.attach(_loc3_);
         }
         GameKeys.setActive(_loc3_,this,this.g);
         var _loc4_:Boolean = !this.editing && _loc2_ && !_loc3_;
         this.fadeHud(!_loc4_);
         var _loc5_:Boolean = this.gst != null && this.gst.focus is TextField;
         var _loc6_:Boolean = !_loc4_ && !_loc3_ && !this.blocked();
         this.skills.collapsed = !this.editing && this.opts().bSkillsHidden == true;
         this.skills.shown = Boolean(this.editing) || _loc6_;
         this.refreshZone();
         var _loc7_:Boolean = _loc3_ && Boolean(GameKeys.controlsOn) && !_loc5_ || this.opts().bJoyHidden != true && (_loc6_ || Boolean(this.joy.pressed) && !_loc4_ && !_loc5_);
         if(this.editing)
         {
            _loc7_ = true;
         }
         if(_loc7_ == this.joy.visible)
         {
            return;
         }
         if(!_loc7_)
         {
            this.joy.release();
         }
         this.joy.visible = _loc7_;
         this.joyShown = _loc7_;
      }

      private function attach(param1:Boolean) : void
      {
         var uiC:MovieClip = null;
         var top:Boolean = param1;
         this.onTop = top;
         if(top)
         {
            this.g.addChild(this);
            return;
         }
         uiC = this.g.ui;
         try
         {
            uiC.addChildAt(this,uiC.getChildIndex(uiC.mcInterface));
         }
         catch(e:Error)
         {
            uiC.addChild(this);
         }
      }

      private function onOwnPress(param1:MouseEvent) : void
      {
         if(GameKeys.active)
         {
            param1.stopPropagation();
         }
      }

      private function onStageDown(param1:MouseEvent) : void
      {
         if(this.g == null || this.gst == null)
         {
            return;
         }
         var _loc2_:* = this.gst.focus;
         if(!(_loc2_ is TextField))
         {
            return;
         }
         var _loc3_:* = param1.target;
         if(_loc3_ is TextField)
         {
            return;
         }
         if(!(_loc3_ is DisplayObject) || !this.g.contains(DisplayObject(_loc3_)))
         {
            return;
         }
         var _loc4_:* = _loc2_.parent;
         if(_loc4_ != null && _loc3_ is DisplayObject && Boolean(_loc4_.contains(_loc3_)))
         {
            return;
         }
         this.gst.focus = null;
      }

      private function onDragDown(param1:MouseEvent) : void
      {
         if(!this.editing && param1.currentTarget != this.tab)
         {
            return;
         }
         this.endDrag();
         this.drag = Sprite(param1.currentTarget);
         if(this.drag == this.tab)
         {
            this.drawTab(true);
         }
         this.dragging = false;
         this.sx = this.px = param1.stageX;
         this.sy = this.py = param1.stageY;
         this.ox = this.drag.x;
         this.oy = this.drag.y;
         this.st = this.drag.stage;
         this.st.addEventListener(MouseEvent.MOUSE_MOVE,this.onDragMove,false,0,true);
         this.st.addEventListener(MouseEvent.MOUSE_UP,this.onDragUp,false,0,true);
         this.st.addEventListener(Event.DEACTIVATE,this.onDragLost,false,0,true);
         this.st.addEventListener(Event.MOUSE_LEAVE,this.onDragLost,false,0,true);
         if(this.drag == this.tab && !this.editing && !this.open)
         {
            this.tabHold.start(this.tabW,this.tabH,this.onTabHoldDone);
         }
      }

      private function onTabHoldDone() : void
      {
         var _loc1_:Boolean = this.drag == this.tab && Boolean(this.tab.hitTestPoint(this.px,this.py,true));
         this.endDrag();
         if(_loc1_)
         {
            this.setOpen(true);
         }
      }

      private function onDragMove(param1:MouseEvent) : void
      {
         this.px = param1.stageX;
         this.py = param1.stageY;
         if(this.drag == null)
         {
            return;
         }
         if(Boolean(this.tabHold.active) && !this.tab.hitTestPoint(this.px,this.py,true))
         {
            this.tabHold.stop();
         }
         var _loc2_:Number = param1.stageX - this.sx;
         var _loc3_:Number = param1.stageY - this.sy;
         if(!this.dragging)
         {
            if(!this.editing || _loc2_ * _loc2_ + _loc3_ * _loc3_ < THRESHOLD_SQ)
            {
               return;
            }
            this.dragging = true;
         }
         this.drag.x = this.ox + _loc2_;
         this.drag.y = this.oy + _loc3_;
         if(this.drag == this.tab)
         {
            this.clampTab();
            this.placeBar();
            this.drawChevron();
         }
         else if(this.drag == this.skills)
         {
            this.clampSkills();
         }
         else
         {
            this.clampJoy();
         }
         this.refreshZone();
         param1.updateAfterEvent();
      }

      private function onDragUp(param1:MouseEvent) : void
      {
         var _loc2_:Sprite = this.drag;
         var _loc3_:Boolean = Boolean(this.dragging);
         this.endDrag();
         if(_loc3_)
         {
            this.savePos(_loc2_);
         }
         else if(_loc2_ == this.tab && !this.editing)
         {
            if(this.open)
            {
               this.setOpen(false);
            }
            else if(this.tab.hitTestPoint(param1.stageX,param1.stageY,true))
            {
               this.hint("Hold to open",this.tab.localToGlobal(new Point(this.tabW + 50,this.tabH / 2 + 22)));
            }
         }
      }

      private function onDragLost(param1:Event) : void
      {
         var _loc2_:Sprite = this.drag;
         var _loc3_:Boolean = Boolean(this.dragging);
         this.endDrag();
         if(_loc3_)
         {
            this.savePos(_loc2_);
         }
      }

      private function savePos(param1:Sprite) : void
      {
         var _loc2_:Object = this.opts();
         if(param1 == this.tab)
         {
            _loc2_.posMobileTab = {
               "x":int(this.tab.x),
               "y":int(this.tab.y)
            };
         }
         else if(param1 == this.skills)
         {
            _loc2_.posSkills = {
               "x":int(this.skills.x),
               "y":int(this.skills.y)
            };
         }
         else
         {
            _loc2_.posJoy = {
               "x":int(this.joy.x),
               "y":int(this.joy.y)
            };
         }
         this.flush();
      }

      private function onSkillsHint(param1:Event) : void
      {
         var _loc2_:Rectangle = this.skills.handleRect;
         this.hint("Hold to collapse",this.skills.localToGlobal(new Point(_loc2_.x + _loc2_.width / 2 - 45,_loc2_.y + 6)));
      }

      private function hint(param1:String, param2:Point) : void
      {
         var _loc3_:MovieClip = null;
         try
         {
            _loc3_ = this.g.ui.ToolTip as MovieClip;
            _loc3_.openWith({
               "str":param1,
               "fromlocal":_loc3_.parent.globalToLocal(param2),
               "closein":1500
            });
         }
         catch(err:Error)
         {
         }
      }

      private function endDrag() : void
      {
         this.tabHold.stop();
         if(this.st != null)
         {
            this.st.removeEventListener(MouseEvent.MOUSE_MOVE,this.onDragMove);
            this.st.removeEventListener(MouseEvent.MOUSE_UP,this.onDragUp);
            this.st.removeEventListener(Event.DEACTIVATE,this.onDragLost);
            this.st.removeEventListener(Event.MOUSE_LEAVE,this.onDragLost);
            this.st = null;
         }
         if(this.drag == this.tab)
         {
            this.drawTab(false);
         }
         this.drag = null;
         this.dragging = false;
      }

      private function setOpen(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         if(this.open == param1 && this.barP == (param1 ? 1 : 0))
         {
            return;
         }
         this.open = param1;
         this.slideFrom = this.barP;
         this.slideTo = param1 ? 1 : 0;
         this.slideT0 = getTimer();
         if(!this.artOk && NativeArt.menu(false) != null)
         {
            this.artOk = true;
            this.drawTab(this.drag == this.tab);
            _loc2_ = 0;
            while(_loc2_ < this.buttons.length)
            {
               this.drawBtn(_loc2_);
               _loc2_++;
            }
         }
         this.drawChevron();
         addEventListener(Event.ENTER_FRAME,this.onSlide,false,0,true);
      }

      private function onSlide(param1:Event) : void
      {
         var _loc2_:Number = Math.min(1,(getTimer() - this.slideT0) / SLIDE_MS);
         this.barP = this.slideFrom + (this.slideTo - this.slideFrom) * _loc2_;
         this.placeBar();
         if(_loc2_ >= 1)
         {
            removeEventListener(Event.ENTER_FRAME,this.onSlide);
         }
      }

      private function onJoyToggle(param1:MouseEvent) : void
      {
         var _loc2_:Object = this.opts();
         _loc2_.bJoyHidden = _loc2_.bJoyHidden != true;
         this.flush();
         this.applyJoy();
      }

      private function applySkillsBtn() : void
      {
         this.setOff(SKILLS_I,this.opts().bSkillsHidden == true);
      }

      private function onSkillsToggle(param1:MouseEvent) : void
      {
         var _loc2_:Object = this.opts();
         _loc2_.bSkillsHidden = _loc2_.bSkillsHidden != true;
         this.flush();
         this.applySkillsBtn();
         this.onTick(null);
      }

      private function onSkillsCollapse(param1:Event) : void
      {
         this.onSkillsToggle(null);
      }

      private function onEdit(param1:MouseEvent) : void
      {
         this.setEditing(true);
      }

      private function setEditing(param1:Boolean) : void
      {
         this.editing = param1;
         this.joy.editing = param1;
         this.skills.editing = param1;
         DropTray.setEditing(param1);
         if(param1 && this.done == null)
         {
            this.done = new VolumeButton(DONE_W,DONE_H,"Done");
            this.done.scaleX = this.done.scaleY = Mobile.touchPx(7) / DONE_H;
            this.done.x = Math.round((STAGE_W - DONE_W * this.done.scaleX) / 2);
            this.done.y = 10;
            this.done.addEventListener(MouseEvent.CLICK,this.onDone,false,0,true);
            addChild(this.done);
         }
         if(this.done != null)
         {
            this.done.visible = param1;
         }
         if(param1)
         {
            this.setOpen(false);
         }
         this.applyJoy();
         this.onTick(null);
      }

      private function onDone(param1:MouseEvent) : void
      {
         this.setEditing(false);
      }

      private function onReset(param1:MouseEvent) : void
      {
         var _loc2_:Object = this.opts();
         delete _loc2_.posJoy;
         delete _loc2_.posSkills;
         delete _loc2_.posMobileTab;
         delete _loc2_.posDrops;
         delete _loc2_.posVMouse;
         _loc2_.bJoyHidden = false;
         _loc2_.bSkillsHidden = false;
         _loc2_.bVMouseMin = false;
         this.flush();
         DropTray.resetPos();
         this.applyPositions();
         this.drawChevron();
         this.applySkillsBtn();
         this.onTick(null);
         this.applyJoy();
         if(this.vm != null)
         {
            this.vm.minimized = false;
            this.vm.place(null);
         }
      }

      private function applyMouse() : void
      {
         var _loc1_:Boolean = this.opts().bVMouse == true;
         if(_loc1_)
         {
            this.vm.open(this.opts().posVMouse,this.opts().bVMouseMin == true);
         }
         else
         {
            this.vm.close();
         }
         this.setOff(MOUSE_I,!this.vm.isOpen);
      }

      private function onMouseToggle(param1:MouseEvent) : void
      {
         var _loc2_:Object = this.opts();
         _loc2_.bVMouse = _loc2_.bVMouse != true;
         this.flush();
         this.applyMouse();
         if(this.vm.isOpen)
         {
            this.setOpen(false);
         }
      }

      private function onVmClose(param1:Event) : void
      {
         this.opts().bVMouse = false;
         this.flush();
         this.applyMouse();
      }

      private function onVmMoved(param1:Event) : void
      {
         var _loc2_:Object = this.vm.pos;
         if(_loc2_ == null)
         {
            return;
         }
         this.opts().posVMouse = _loc2_;
         this.flush();
      }

      private function onVmMin(param1:Event) : void
      {
         var _loc2_:Object = this.opts();
         _loc2_.bVMouseMin = this.vm.minimized;
         var _loc3_:Object = this.vm.pos;
         if(_loc2_.posVMouse != null && _loc3_ != null)
         {
            _loc2_.posVMouse = _loc3_;
         }
         this.flush();
      }

      private function onCollapse(param1:MouseEvent) : void
      {
         this.setOpen(false);
      }
   }
}
