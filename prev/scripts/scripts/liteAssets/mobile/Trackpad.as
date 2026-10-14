package liteAssets.mobile
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.text.TextField;
   import flash.utils.*;
   import liteAssets.draw.*;

   public class Trackpad extends Sprite
   {

      private static var frameArt:BitmapData;

      private static var bgArt:BitmapData;

      private static var upArt:BitmapData;

      private static var downArt:BitmapData;

      private static var upR:Rectangle;

      private static var downR:Rectangle;

      private static var glyphR:Rectangle;

      public static const PAD:String = "pad";

      public static const STRIP:String = "strip";

      public static const LEFT:String = "left";

      public static const RIGHT:String = "right";

      public static const HOLD:String = "hold";

      public static const CLOSE:String = "close";

      public static const GRIP:String = "grip";

      public static const FRAME:String = "frame";

      public static const MIN:String = "min";

      private static const TITLE:String = "Mouse";

      private static const MAX_W:int = 960;

      private static const MAX_H:int = 482;

      private static const SIDE:int = 16;

      private static const TOP:int = 44;

      private static const BOT:int = 16;

      private static const X_W:int = 36;

      private static const WELL_R:int = 12;

      private static const BASE:int = 44;

      private static const EDGE:uint = 13145646;

      private static const LIT_EDGE:uint = 16767083;

      private static const CHEVRON:uint = 14725888;

      private static const INK:uint = 2759178;

      private static const INSET:DropShadowFilter = new DropShadowFilter(2,90,0,0.5,4,4,1,1,true);

      private static const LIT:GlowFilter = new GlowFilter(16767083,0.4,14,14,2,2,true);

      private static const SHADOW:DropShadowFilter = new DropShadowFilter(2,90,0,0.5,4,4,1,2);

      private static const SEL_GLOW:GlowFilter = new GlowFilter(16767083,0.9,10,10,2,2);

      private static const OUTLINE:GlowFilter = new GlowFilter(0,1,3,3,10,1);

      private static const GLYPH_OUTLINE:GlowFilter = new GlowFilter(0,1,3,3,8,2);

      private static const ARROW:Array = [0,0,0,16.5,4.2,12.6,7.2,18.6,9.6,17.5,6.7,11.6,11.8,11.6];

      private static const MIN_GAP:int = 3;

      private static const ANIM_MS:int = 120;

      private static var grabbed:Boolean = false;

      private static var frameIn:Array = [];

      private static var bgIn:Array = [];

      private var pw:int;

      private var ph:int;

      private var padS:Sprite;

      private var stripS:Sprite;

      private var titleBar:Sprite;

      private var closeObj:DisplayObject;

      private var padW:int;

      private var padH:int;

      private var stripW:int;

      private var stripH:int;

      private var parts:Array = [];

      private var btns:Array = [];

      private var faces:Array = [];

      private var bodies:Array = [];

      private var glyphs:Array = [];

      private var pressed:String;

      private var holdOn:Boolean = false;

      private var padOn:Boolean = false;

      private var stripOn:Boolean = false;

      private var nbg:MovieClip;

      private var fbS:Shape;

      private var pill:Sprite;

      private var pillBg:Shape;

      private var pillFr:Shape;

      private var bodyS:Sprite;

      private var closeR:Rectangle;

      private var minBtn:Sprite;

      private var minFace:Shape;

      private var minGlyph:Shape;

      private var minR:Rectangle;

      private var minG:Rectangle;

      private var mini:Boolean = false;

      private var curH:Number = 0;

      private var fromH:Number = 0;

      private var animT0:int = 0;

      public function Trackpad(param1:Number)
      {
         super();
         tabEnabled = false;
         tabChildren = false;
         var _loc1_:int = Math.max(6,Math.round(1.4 * param1));
         var _loc2_:int = int(Mobile.touchPx(9));
         this.stripW = Mobile.touchPx(10);
         this.padW = Math.min(Math.max(230,Math.round(52 * param1)),MAX_W - SIDE * 2 - _loc1_ - this.stripW);
         this.padH = Math.min(Math.max(150,Math.round(34 * param1)),MAX_H - TOP - _loc1_ - _loc2_ - BOT);
         this.stripH = this.padH;
         this.pw = SIDE * 2 + this.padW + _loc1_ + this.stripW;
         this.ph = TOP + this.padH + _loc1_ + _loc2_ + BOT;
         this.curH = this.ph;
         this.buildChrome();
         this.titleBar = new Sprite();
         this.titleBar.graphics.beginFill(0,0);
         this.titleBar.graphics.drawRect(0,0,this.pw - X_W,TOP - 4);
         this.titleBar.graphics.endFill();
         addChild(this.titleBar);
         this.bodyS = new Sprite();
         addChild(this.bodyS);
         this.padS = this.surface(SIDE,TOP);
         this.stripS = this.surface(SIDE + this.padW + _loc1_,TOP);
         this.drawPad();
         this.drawStrip();
         var _loc3_:int = TOP + this.padH + _loc1_;
         var _loc4_:int = this.padW + _loc1_ + this.stripW;
         var _loc5_:int = Math.floor((_loc4_ - _loc1_ * 2) / 3);
         var _loc6_:int = _loc4_ - _loc1_ * 2 - _loc5_ * 2;
         this.makeBtn(LEFT,"Left",SIDE,_loc3_,_loc5_,_loc2_);
         this.makeBtn(HOLD,"Hold",SIDE + _loc5_ + _loc1_,_loc3_,_loc6_,_loc2_);
         this.makeBtn(RIGHT,"Right",SIDE + _loc5_ + _loc1_ + _loc6_ + _loc1_,_loc3_,_loc5_,_loc2_);
         this.buildMin();
      }

      private static function plain(param1:Graphics, param2:Number, param3:Number) : void
      {
         var _loc3_:Matrix = new Matrix();
         _loc3_.createGradientBox(param2,param3,Math.PI / 2,0,0);
         param1.lineStyle(2,MailArt.TRIM,1,true);
         param1.beginGradientFill(GradientType.LINEAR,[2236962,1315860],[1,1],[0,255],_loc3_);
         param1.drawRoundRect(0,0,param2,param3,12,12);
         param1.endFill();
      }

      private static function grabArt(param1:MovieClip) : void
      {
         var bg:MovieClip = param1;
         if(grabbed)
         {
            return;
         }
         grabbed = true;
         try
         {
            frameArt = sliced(bg.frame as DisplayObjectContainer,frameIn);
         }
         catch(e:Error)
         {
            frameArt = null;
         }
         try
         {
            bgArt = sliced(bg.bg as DisplayObjectContainer,bgIn);
         }
         catch(e2:Error)
         {
            bgArt = null;
         }
         try
         {
            grabClose(bg.btnClose as SimpleButton);
         }
         catch(e3:Error)
         {
         }
      }

      private static function sliced(param1:DisplayObjectContainer, param2:Array) : BitmapData
      {
         if(param1 == null || param1.numChildren != 1)
         {
            return null;
         }
         var _loc2_:Rectangle = param1.scale9Grid;
         if(_loc2_ == null)
         {
            return null;
         }
         var _loc3_:DisplayObject = param1.getChildAt(0);
         var _loc4_:Rectangle = _loc3_.getBounds(param1);
         var _loc5_:Number = _loc2_.left - _loc4_.left;
         var _loc6_:Number = _loc2_.top - _loc4_.top;
         var _loc7_:Number = _loc4_.right - _loc2_.right;
         var _loc8_:Number = _loc4_.bottom - _loc2_.bottom;
         if(_loc5_ < 0 || _loc6_ < 0 || _loc7_ < 0 || _loc8_ < 0)
         {
            return null;
         }
         var _loc9_:Matrix = _loc3_.transform.matrix;
         _loc9_.translate(-_loc4_.x,-_loc4_.y);
         _loc9_.scale(NativeArt.K,NativeArt.K);
         var _loc10_:BitmapData = snap(_loc3_,_loc9_,_loc4_.width,_loc4_.height);
         if(_loc10_ != null)
         {
            param2.length = 0;
            param2.push(_loc5_,_loc6_,_loc7_,_loc8_);
         }
         return _loc10_;
      }

      private static function grabClose(param1:SimpleButton) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc1_:DisplayObject = param1.upState;
         var _loc2_:DisplayObject = glyphOf(_loc1_);
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:Rectangle = _loc1_.getBounds(_loc1_);
         var _loc4_:Rectangle = _loc2_.getBounds(_loc1_);
         if(_loc4_.width >= _loc3_.width * 0.8 || _loc4_.height >= _loc3_.height * 0.8)
         {
            return;
         }
         var _loc5_:BitmapData = noGlyph(_loc1_,_loc2_,_loc3_);
         if(_loc5_ == null)
         {
            return;
         }
         upArt = _loc5_;
         upR = _loc3_;
         glyphR = _loc4_;
         var _loc6_:DisplayObject = param1.downState;
         var _loc7_:DisplayObject = glyphOf(_loc6_);
         if(_loc7_ == null)
         {
            return;
         }
         var _loc8_:Rectangle = _loc6_.getBounds(_loc6_);
         _loc5_ = noGlyph(_loc6_,_loc7_,_loc8_);
         if(_loc5_ == null)
         {
            return;
         }
         downArt = _loc5_;
         downR = _loc8_;
      }

      private static function glyphOf(param1:DisplayObject) : DisplayObject
      {
         var _loc4_:DisplayObject = null;
         var _loc1_:DisplayObjectContainer = param1 as DisplayObjectContainer;
         if(_loc1_ == null)
         {
            return null;
         }
         var _loc2_:int = _loc1_.numChildren;
         if(_loc2_ >= 2 && _loc1_.getChildAt(0) is Shape && _loc1_.getChildAt(_loc2_ - 1) is Shape)
         {
            return _loc1_.getChildAt(_loc2_ - 1);
         }
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = glyphOf(_loc1_.getChildAt(_loc3_));
            if(_loc4_ != null)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }

      private static function noGlyph(param1:DisplayObject, param2:DisplayObject, param3:Rectangle) : BitmapData
      {
         var s:DisplayObject = param1;
         var x:DisplayObject = param2;
         var r:Rectangle = param3;
         var k:Number = Number(NativeArt.K);
         var bmd:BitmapData = null;
         x.visible = false;
         try
         {
            bmd = snap(s,new Matrix(k,0,0,k,-r.x * k,-r.y * k),r.width,r.height);
         }
         catch(e:Error)
         {
            bmd = null;
         }
         x.visible = true;
         return bmd;
      }

      private static function snap(param1:DisplayObject, param2:Matrix, param3:Number, param4:Number) : BitmapData
      {
         if(param3 <= 0 || param4 <= 0)
         {
            return null;
         }
         var _loc4_:BitmapData = new BitmapData(Math.ceil(param3 * NativeArt.K),Math.ceil(param4 * NativeArt.K),true,0);
         _loc4_.drawWithQuality(param1,param2,null,null,null,true,StageQuality.HIGH);
         if(_loc4_.getColorBoundsRect(4278190080,0,false).isEmpty())
         {
            _loc4_.dispose();
            return null;
         }
         return _loc4_;
      }

      private static function fit(param1:Graphics, param2:BitmapData, param3:Array, param4:Number, param5:Number) : void
      {
         if(param5 <= 0)
         {
            return;
         }
         var _loc5_:Number = Math.min(param3[1],param5 / 2);
         NativeArt.slice(param1,param2,param4,param5,param3[0],_loc5_,param3[2],Math.min(param3[3],param5 - _loc5_));
      }

      private static function ball(param1:Graphics, param2:Number, param3:Number) : void
      {
         var _loc3_:Number = Math.min(param2,param3) / 2;
         var _loc4_:Matrix = new Matrix();
         _loc4_.createGradientBox(param2,param3,Math.PI / 2,0,0);
         param1.lineStyle(1,INK,1,true);
         param1.beginGradientFill(GradientType.LINEAR,[16770186,11565598],[1,1],[0,255],_loc4_);
         param1.drawCircle(param2 / 2,param3 / 2,_loc3_ - 0.5);
         param1.endFill();
         param1.lineStyle();
         _loc4_.createGradientBox(_loc3_ * 1.5,_loc3_ * 1.5,Math.PI / 2,param2 / 2 - _loc3_ * 0.75,param3 / 2 - _loc3_ * 0.75);
         param1.beginGradientFill(GradientType.LINEAR,[15216688,7995392],[1,1],[0,255],_loc4_);
         param1.drawCircle(param2 / 2,param3 / 2,_loc3_ * 0.72);
         param1.endFill();
      }

      public function get boxW() : int
      {
         return this.pw;
      }

      public function get boxH() : int
      {
         return this.mini ? int(TOP) : int(this.ph);
      }

      public function get fullH() : int
      {
         return this.ph;
      }

      public function setMinimized(param1:Boolean, param2:Boolean) : void
      {
         this.mini = param1;
         this.drawMin();
         removeEventListener(Event.ENTER_FRAME,this.onAnim);
         var _loc2_:Number = param1 ? Number(TOP) : Number(this.ph);
         if(!param2 || this.curH == _loc2_)
         {
            this.chromeTo(_loc2_);
            return;
         }
         this.fromH = this.curH;
         this.animT0 = getTimer();
         addEventListener(Event.ENTER_FRAME,this.onAnim,false,0,true);
      }

      public function set hold(param1:Boolean) : void
      {
         if(this.holdOn == param1)
         {
            return;
         }
         this.holdOn = param1;
         this.redraw(HOLD);
      }

      public function partOf(param1:DisplayObject) : String
      {
         var _loc2_:int = 0;
         var _loc1_:DisplayObject = param1;
         while(_loc1_ != null)
         {
            if(_loc1_ == this)
            {
               return FRAME;
            }
            if(_loc1_ == this.closeObj)
            {
               return CLOSE;
            }
            if(_loc1_ == this.minBtn)
            {
               return MIN;
            }
            if(_loc1_ == this.titleBar)
            {
               return GRIP;
            }
            if(_loc1_ == this.padS)
            {
               return PAD;
            }
            if(_loc1_ == this.stripS)
            {
               return STRIP;
            }
            _loc2_ = int(this.btns.indexOf(_loc1_));
            if(_loc2_ >= 0)
            {
               return this.parts[_loc2_];
            }
            _loc1_ = _loc1_.parent;
         }
         return null;
      }

      public function press(param1:String, param2:Boolean) : void
      {
         if(param1 == PAD)
         {
            if(this.padOn == param2)
            {
               return;
            }
            this.padOn = param2;
            this.drawPad();
            return;
         }
         if(param1 == STRIP)
         {
            if(this.stripOn == param2)
            {
               return;
            }
            this.stripOn = param2;
            this.drawStrip();
            return;
         }
         var _loc2_:String = this.pressed;
         if(param2)
         {
            this.pressed = param1;
         }
         else if(this.pressed == param1)
         {
            this.pressed = null;
         }
         if(_loc2_ == this.pressed)
         {
            return;
         }
         this.redraw(_loc2_);
         this.redraw(this.pressed);
      }

      private function buildChrome() : void
      {
         var bg:MovieClip = null;
         var cls:Class = null;
         bg = null;
         try
         {
            cls = getDefinitionByName("LPFPanelBg") as Class;
         }
         catch(e:Error)
         {
            cls = null;
         }
         if(cls != null)
         {
            try
            {
               bg = new cls() as MovieClip;
            }
            catch(e2:Error)
            {
               bg = null;
            }
         }
         if(bg == null)
         {
            this.buildFallbackChrome();
            return;
         }
         addChildAt(bg,0);
         this.nbg = bg;
         try
         {
            bg.frame.width = this.pw;
            bg.frame.height = this.ph;
            bg.bg.width = this.pw - 12;
            bg.bg.height = this.ph - 10;
            bg.btnClose.x = this.pw - 31;
            this.closeObj = bg.btnClose as DisplayObject;
         }
         catch(e3:Error)
         {
         }
         try
         {
            if("dragonLeft" in bg)
            {
               bg.dragonLeft.visible = false;
            }
         }
         catch(e4:Error)
         {
         }
         try
         {
            if("dragonRight" in bg)
            {
               bg.dragonRight.visible = false;
            }
         }
         catch(e5:Error)
         {
         }
         try
         {
            bg.tTitle.text = TITLE;
            bg.tTitle.textColor = 16777215;
            bg.tTitle.mouseEnabled = false;
            bg.tTitle.x = int(this.pw / 2 - bg.tTitle.width / 2);
         }
         catch(e6:Error)
         {
         }
         grabArt(bg);
         this.pill = new Sprite();
         this.pillBg = new Shape();
         this.pillFr = new Shape();
         this.pill.addChild(this.pillBg);
         this.pill.addChild(this.pillFr);
         this.pill.visible = false;
         try
         {
            this.pillBg.x = bg.bg.x;
            this.pillBg.y = bg.bg.y;
            this.pillFr.x = bg.frame.x;
            this.pillFr.y = bg.frame.y;
            bg.addChildAt(this.pill,bg.getChildIndex(bg.bg));
         }
         catch(e7:Error)
         {
            bg.addChildAt(pill,0);
         }
         if(this.closeObj != null)
         {
            this.closeR = this.closeObj.getBounds(this);
         }
         if(this.closeObj is InteractiveObject)
         {
            TouchTargets.pad(InteractiveObject(this.closeObj),44,44);
         }
      }

      private function buildFallbackChrome() : void
      {
         this.fbS = new Shape();
         plain(this.fbS.graphics,this.pw,this.ph);
         addChildAt(this.fbS,0);
         var _loc11_:TextField = MailArt.tf(14,16777215,true);
         _loc11_.filters = [new DropShadowFilter(1,45,0,0.6,2,2,1,1)];
         _loc11_.text = TITLE;
         _loc11_.x = int(this.pw / 2 - _loc11_.width / 2);
         _loc11_.y = 10;
         addChild(_loc11_);
         var _loc1_:Sprite = new Sprite();
         var _loc2_:Graphics = _loc1_.graphics;
         _loc2_.beginFill(3807770);
         _loc2_.lineStyle(1,9054762,1,true);
         _loc2_.drawRoundRect(0,0,22,22,6,6);
         _loc2_.endFill();
         var _loc3_:TextField = MailArt.tf(12,16748688,true);
         _loc3_.text = "X";
         _loc3_.x = Math.round((22 - _loc3_.width) / 2);
         _loc3_.y = Math.round((22 - _loc3_.height) / 2);
         _loc1_.addChild(_loc3_);
         _loc1_.x = this.pw - 31;
         _loc1_.y = 8;
         _loc1_.mouseChildren = false;
         addChild(_loc1_);
         this.closeR = new Rectangle(_loc1_.x,_loc1_.y,22,22);
         TouchTargets.pad(_loc1_,44,44);
         this.closeObj = _loc1_;
      }

      private function drawPill(param1:Number) : void
      {
         var _loc1_:Graphics = this.pillFr.graphics;
         var _loc2_:Graphics = this.pillBg.graphics;
         _loc1_.clear();
         _loc2_.clear();
         if(frameArt == null || bgArt == null)
         {
            plain(_loc1_,this.pw,param1);
            return;
         }
         fit(_loc2_,bgArt,bgIn,this.pw - 12,param1 - 10);
         fit(_loc1_,frameArt,frameIn,this.pw,param1);
      }

      private function chromeTo(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         param1 = Math.round(param1);
         this.curH = param1;
         var _loc1_:Boolean = param1 >= this.ph;
         if(this.fbS != null)
         {
            this.fbS.graphics.clear();
            plain(this.fbS.graphics,this.pw,param1);
         }
         if(this.pill != null)
         {
            try
            {
               this.nbg.frame.visible = _loc1_;
               this.nbg.bg.visible = _loc1_;
            }
            catch(e:Error)
            {
            }
            this.pill.visible = !_loc1_;
            if(!_loc1_)
            {
               this.drawPill(param1);
            }
         }
         _loc2_ = (param1 - TOP) / (this.ph - TOP);
         this.bodyS.visible = _loc2_ > 0;
         this.bodyS.alpha = _loc2_ < 1 ? _loc2_ : 1;
         this.bodyS.scrollRect = _loc1_ ? null : new Rectangle(0,0,this.pw,Math.max(1,param1 - BOT / 2));
      }

      private function onAnim(param1:Event) : void
      {
         var _loc1_:Number = this.mini ? Number(TOP) : Number(this.ph);
         var _loc2_:Number = (getTimer() - this.animT0) / ANIM_MS;
         if(_loc2_ >= 1)
         {
            removeEventListener(Event.ENTER_FRAME,this.onAnim);
            this.chromeTo(_loc1_);
            return;
         }
         _loc2_ = 1 - (1 - _loc2_) * (1 - _loc2_);
         this.chromeTo(this.fromH + (_loc1_ - this.fromH) * _loc2_);
      }

      private function buildMin() : void
      {
         var _loc6_:Number = NaN;
         var _loc11_:Rectangle = this.closeR != null ? this.closeR : new Rectangle(this.pw - 31,8,22,22);
         this.minBtn = new Sprite();
         this.minBtn.mouseChildren = false;
         this.minBtn.x = Math.round(_loc11_.x - MIN_GAP - _loc11_.width);
         this.minBtn.y = _loc11_.y;
         var _loc1_:Number = _loc11_.x - this.minBtn.x - _loc11_.width;
         var _loc2_:Number = Mobile.active ? Math.max(0,(44 - _loc11_.width) / 2) : 0;
         var _loc3_:Number = Mobile.active ? Math.max(0,(44 - _loc11_.height) / 2) : 0;
         var _loc4_:Graphics = this.minBtn.graphics;
         _loc4_.beginFill(0,0);
         _loc4_.drawRect(-_loc2_,-_loc3_,_loc11_.width + _loc2_ + Math.min(_loc2_,_loc1_ / 2),_loc11_.height + _loc3_ * 2);
         _loc4_.endFill();
         var _loc5_:Sprite = new Sprite();
         this.minFace = new Shape();
         this.minGlyph = new Shape();
         _loc5_.addChild(this.minFace);
         _loc5_.addChild(this.minGlyph);
         if(upArt != null)
         {
            this.minR = upR;
            this.minG = glyphR;
            _loc6_ = _loc11_.width / upR.width;
            _loc5_.scaleX = _loc5_.scaleY = _loc6_;
            _loc5_.x = -upR.x * _loc6_;
            _loc5_.y = -upR.y * _loc6_;
         }
         else
         {
            this.minR = new Rectangle(0,0,_loc11_.width,_loc11_.height);
            this.minG = new Rectangle(_loc11_.width * 0.27,_loc11_.height * 0.3,_loc11_.width * 0.46,_loc11_.height * 0.4);
         }
         this.minBtn.addChild(_loc5_);
         addChild(this.minBtn);
         this.drawMin();
      }

      private function drawMin() : void
      {
         if(this.minBtn == null)
         {
            return;
         }
         var _loc11_:Boolean = this.pressed == MIN;
         var _loc1_:Boolean = _loc11_ && downArt != null;
         var _loc2_:BitmapData = _loc1_ ? downArt : upArt;
         var _loc3_:Rectangle = _loc1_ ? downR : upR;
         var _loc4_:Graphics = this.minFace.graphics;
         _loc4_.clear();
         if(_loc2_ != null)
         {
            _loc4_.beginBitmapFill(_loc2_,new Matrix(1 / NativeArt.K,0,0,1 / NativeArt.K,_loc3_.x,_loc3_.y),false,true);
            _loc4_.drawRect(_loc3_.x,_loc3_.y,_loc3_.width,_loc3_.height);
            _loc4_.endFill();
         }
         else
         {
            ball(_loc4_,this.minR.width,this.minR.height);
         }
         var _loc5_:Number = _loc11_ && !_loc1_ ? 0.82 : 1;
         this.minFace.transform.colorTransform = new ColorTransform(_loc5_,_loc5_,_loc5_);
         var _loc6_:Graphics = this.minGlyph.graphics;
         _loc6_.clear();
         var _loc7_:Number = this.minG.x + this.minG.width / 2;
         var _loc8_:Number = this.minG.y + this.minG.height / 2;
         var _loc9_:Number = this.minG.width * 0.45;
         var _loc10_:Number = _loc9_ * 0.6;
         var _loc12_:uint = _loc11_ ? uint(LIT_EDGE) : uint(CHEVRON);
         if(this.mini)
         {
            this.chevron(_loc6_,_loc7_,_loc8_ - _loc10_ / 2,_loc9_,_loc10_,1,_loc12_);
         }
         else
         {
            this.chevron(_loc6_,_loc7_,_loc8_ + _loc10_ / 2,_loc9_,_loc10_,-1,_loc12_);
         }
      }

      private function surface(param1:int, param2:int) : Sprite
      {
         var _loc2_:Sprite = new Sprite();
         _loc2_.mouseChildren = false;
         _loc2_.x = param1;
         _loc2_.y = param2;
         this.bodyS.addChild(_loc2_);
         return _loc2_;
      }

      private function well(param1:Sprite, param2:int, param3:int, param4:Boolean) : Graphics
      {
         var _loc4_:Graphics = param1.graphics;
         _loc4_.clear();
         _loc4_.lineStyle(1,2763306,1,true);
         _loc4_.beginFill(657930);
         _loc4_.drawRoundRect(0,0,param2,param3,WELL_R,WELL_R);
         _loc4_.endFill();
         _loc4_.lineStyle(1,param4 ? uint(LIT_EDGE) : uint(EDGE),param4 ? 0.85 : 0.3,true);
         _loc4_.drawRoundRect(2.5,2.5,param2 - 5,param3 - 5,WELL_R - 4,WELL_R - 4);
         _loc4_.lineStyle();
         param1.filters = param4 ? [INSET,LIT] : [INSET];
         return _loc4_;
      }

      private function drawPad() : void
      {
         var _loc11_:Graphics = this.well(this.padS,this.padW,this.padH,this.padOn);
         var _loc1_:Number = Math.min(this.padW,this.padH) * 0.22 / 18.6;
         var _loc2_:Number = Math.round(this.padW / 2 - 5.9 * _loc1_);
         var _loc3_:Number = Math.round(this.padH / 2 - 9.3 * _loc1_);
         _loc11_.lineStyle(1.5,this.padOn ? uint(LIT_EDGE) : uint(EDGE),this.padOn ? 0.6 : 0.3,true,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.MITER,3);
         _loc11_.beginFill(EDGE,this.padOn ? 0.14 : 0.06);
         _loc11_.moveTo(_loc2_ + ARROW[0] * _loc1_,_loc3_ + ARROW[1] * _loc1_);
         var _loc4_:int = 2;
         while(_loc4_ < ARROW.length)
         {
            _loc11_.lineTo(_loc2_ + ARROW[_loc4_] * _loc1_,_loc3_ + ARROW[_loc4_ + 1] * _loc1_);
            _loc4_ += 2;
         }
         _loc11_.lineTo(_loc2_ + ARROW[0] * _loc1_,_loc3_ + ARROW[1] * _loc1_);
         _loc11_.endFill();
         _loc11_.lineStyle();
      }

      private function drawStrip() : void
      {
         var _loc11_:Graphics = this.well(this.stripS,this.stripW,this.stripH,this.stripOn);
         var _loc1_:Number = Math.round(this.stripW / 2) + 0.5;
         var _loc2_:Number = Math.max(6,Math.round(this.stripW * 0.24));
         var _loc3_:Number = Math.max(4,Math.round(_loc2_ * 0.6));
         var _loc4_:Number = 10;
         var _loc5_:Number = this.stripH - 10;
         var _loc6_:uint = this.stripOn ? uint(LIT_EDGE) : uint(CHEVRON);
         this.chevron(_loc11_,_loc1_,_loc4_,_loc2_,_loc3_,1,_loc6_);
         this.chevron(_loc11_,_loc1_,_loc5_,_loc2_,_loc3_,-1,_loc6_);
         var _loc7_:Number = Math.max(5,Math.round(this.stripW * 0.28));
         var _loc8_:int = _loc4_ + _loc3_ + 10;
         var _loc9_:int = _loc5_ - _loc3_ - 10;
         var _loc10_:int = _loc8_;
         while(_loc10_ <= _loc9_)
         {
            _loc11_.lineStyle(1,0,0.9,true);
            _loc11_.moveTo(_loc1_ - _loc7_,_loc10_ + 0.5);
            _loc11_.lineTo(_loc1_ + _loc7_,_loc10_ + 0.5);
            _loc11_.lineStyle(1,this.stripOn ? uint(LIT_EDGE) : uint(EDGE),this.stripOn ? 0.45 : 0.22,true);
            _loc11_.moveTo(_loc1_ - _loc7_,_loc10_ + 1.5);
            _loc11_.lineTo(_loc1_ + _loc7_,_loc10_ + 1.5);
            _loc10_ += 6;
         }
         _loc11_.lineStyle();
      }

      private function chevron(param1:Graphics, param2:Number, param3:Number, param4:Number, param5:Number, param6:int, param7:uint) : void
      {
         var _loc7_:Number = Math.max(2,Math.round(param4 * 0.35));
         param1.lineStyle(_loc7_ + 2,INK,1,true,LineScaleMode.NORMAL,CapsStyle.ROUND,JointStyle.MITER,3);
         param1.moveTo(param2 - param4,param3 + param5 * param6);
         param1.lineTo(param2,param3);
         param1.lineTo(param2 + param4,param3 + param5 * param6);
         param1.lineStyle(_loc7_,param7,1,true,LineScaleMode.NORMAL,CapsStyle.ROUND,JointStyle.MITER,3);
         param1.moveTo(param2 - param4,param3 + param5 * param6);
         param1.lineTo(param2,param3);
         param1.lineTo(param2 + param4,param3 + param5 * param6);
      }

      private function makeBtn(param1:String, param2:String, param3:int, param4:int, param5:int, param6:int) : void
      {
         var _loc6_:Sprite = new Sprite();
         _loc6_.mouseChildren = false;
         _loc6_.x = param3;
         _loc6_.y = param4;
         var _loc7_:Shape = new Shape();
         VolumeButton.paintFace(_loc7_.graphics,param5,param6);
         _loc6_.addChild(_loc7_);
         var _loc8_:Sprite = new Sprite();
         var _loc9_:TextField = MailArt.tf(Math.max(13,Math.round(param6 * 0.3)),16777215,true);
         _loc9_.filters = [OUTLINE];
         _loc9_.text = param2;
         var _loc10_:Number = param6 / BASE * 0.8;
         var _loc12_:Number = 14 * _loc10_;
         var _loc13_:Number = Math.round(5 * _loc10_);
         var _loc14_:Shape = new Shape();
         _loc14_.scaleX = _loc14_.scaleY = _loc10_;
         _loc14_.filters = [GLYPH_OUTLINE];
         var _loc15_:Number = _loc12_ + _loc13_ + _loc9_.width - 4;
         if(_loc15_ > param5 - 12)
         {
            _loc14_.visible = false;
            _loc15_ = _loc9_.width - 4;
         }
         var _loc16_:Number = Math.round((param5 - _loc15_) / 2);
         if(_loc14_.visible)
         {
            _loc14_.x = Math.round(_loc16_ + _loc12_ / 2);
            _loc14_.y = Math.round(param6 / 2);
            _loc9_.x = Math.round(_loc16_ + _loc12_ + _loc13_) - 2;
         }
         else
         {
            _loc9_.x = _loc16_ - 2;
         }
         _loc9_.y = Math.round((param6 - _loc9_.height) / 2);
         _loc8_.addChild(_loc14_);
         _loc8_.addChild(_loc9_);
         _loc6_.addChild(_loc8_);
         this.bodyS.addChild(_loc6_);
         this.parts.push(param1);
         this.btns.push(_loc6_);
         this.faces.push(_loc7_);
         this.bodies.push(_loc8_);
         this.glyphs.push(_loc14_);
         this.drawBtn(this.btns.length - 1);
      }

      private function redraw(param1:String) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param1 == MIN)
         {
            this.drawMin();
            return;
         }
         var _loc1_:int = int(this.parts.indexOf(param1));
         if(_loc1_ >= 0)
         {
            this.drawBtn(_loc1_);
         }
      }

      private function drawBtn(param1:int) : void
      {
         var _loc1_:String = this.parts[param1];
         var _loc2_:Boolean = _loc1_ == this.pressed;
         var _loc3_:Boolean = _loc1_ == HOLD && Boolean(this.holdOn);
         var _loc4_:Shape = this.faces[param1];
         var _loc5_:Number = (_loc3_ ? 0.72 : 1) * (_loc2_ ? 0.82 : 1);
         _loc4_.transform.colorTransform = new ColorTransform(_loc5_,_loc5_,_loc5_);
         _loc4_.y = _loc2_ ? 1 : 0;
         _loc4_.filters = _loc3_ ? [SEL_GLOW,SHADOW] : [SHADOW];
         Sprite(this.bodies[param1]).y = _loc2_ ? 1 : 0;
         this.drawGlyph(Shape(this.glyphs[param1]).graphics,_loc1_);
      }

      private function drawGlyph(param1:Graphics, param2:String) : void
      {
         var _loc3_:int = 0;
         var _loc2_:uint = 16777215;
         param1.clear();
         if(param2 == LEFT || param2 == RIGHT)
         {
            _loc3_ = param2 == LEFT ? -1 : 1;
            param1.beginFill(_loc2_);
            param1.moveTo(0,-10);
            param1.lineTo(_loc3_,-10);
            param1.curveTo(_loc3_ * 7,-10,_loc3_ * 7,-4);
            param1.lineTo(_loc3_ * 7,-2);
            param1.lineTo(0,-2);
            param1.lineTo(0,-10);
            param1.endFill();
            param1.lineStyle(2,_loc2_,1,true,LineScaleMode.NORMAL,CapsStyle.ROUND,JointStyle.ROUND);
            param1.drawRoundRect(-7,-10,14,20,12,12);
            param1.moveTo(-7,-2);
            param1.lineTo(7,-2);
            param1.moveTo(0,-10);
            param1.lineTo(0,-2);
            return;
         }
         param1.beginFill(_loc2_);
         param1.drawRoundRect(-7,-1,14,11,4,4);
         param1.endFill();
         param1.beginFill(0);
         param1.drawCircle(0,3.5,1.8);
         param1.drawRect(-0.8,3.5,1.6,3.5);
         param1.endFill();
         param1.lineStyle(2.5,_loc2_,1,true,LineScaleMode.NORMAL,CapsStyle.ROUND,JointStyle.ROUND);
         if(this.holdOn)
         {
            param1.moveTo(-4.5,-1);
            param1.lineTo(-4.5,-5);
            param1.curveTo(-4.5,-9.5,0,-9.5);
            param1.curveTo(4.5,-9.5,4.5,-5);
            param1.lineTo(4.5,-1);
         }
         else
         {
            param1.moveTo(-4.5,-1);
            param1.lineTo(-4.5,-6);
            param1.curveTo(-4.5,-10.5,0,-10.5);
            param1.curveTo(4.5,-10.5,4.5,-6);
            param1.lineTo(4.5,-4.5);
         }
      }
   }
}
