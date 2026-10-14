package liteAssets.mobile
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.text.*;
   import flash.utils.*;
   import liteAssets.draw.*;

   public class VolumePanel extends Sprite
   {

      private static var current:VolumePanel;

      private static const KEYS:Object = {
         "all":"iSoundAll",
         "music":"iSoundMusic",
         "fx":"iSoundFX"
      };

      private static const DEFAULTS:Object = {
         "all":1,
         "music":0.35,
         "fx":1
      };

      private static const MUTES:Object = {
         "all":"bMuteAll",
         "music":"bMuteMusic",
         "fx":"bMuteFX"
      };

      private static const CHANNELS:Array = ["all","music","fx"];

      private static const LABELS:Object = {
         "all":"Master",
         "music":"Music",
         "fx":"Sound FX"
      };

      private static const SUBS:Object = {
         "all":"All game audio",
         "music":"Background music",
         "fx":"Effects & combat sounds"
      };

      private static const ROW_H:Object = {
         "all":72,
         "music":58,
         "fx":58
      };

      private static const W:int = 534;

      private static const H:int = 318;

      private static const FOOT_IN:int = 40;

      private static const OUT:int = 16;

      private static const INSET:int = 16;

      private static const GAP:int = 12;

      private static const WELL_Y:int = 46;

      private static const WELL_PAD:int = 6;

      private static const ICON:int = 40;

      private static const LABEL_W:int = 132;

      private static const PILL_W:int = 52;

      private static const PILL_H:int = 24;

      private static const BTN_W:int = 112;

      private static const BTN_H:int = 32;

      private static const OPEN_MS:int = 120;

      private static const SOUND_BTN:String = "btnSoundSettings";

      private var game:MovieClip;

      private var sliders:Object = {};

      private var pills:Object = {};

      private var icons:Object = {};

      private var muteAllBtn:VolumeButton;

      private var defaultsBtn:VolumeButton;

      private var doneBtn:VolumeButton;

      private var bg:MovieClip;

      private var fallbackClose:Sprite;

      private var backdrop:Sprite = new Sprite();

      private var pivot:Sprite = new Sprite();

      private var win:Sprite = new Sprite();

      private var m:Boolean = Mobile.active;

      private var pw:int = 534;

      private var ph:int = 318;

      private var icon:int = 40;

      private var btnH:int = 32;

      private var rowH:Object = ROW_H;

      private var lastDragEnd:int = -1000;

      private var openAt:int = 0;

      public function VolumePanel(param1:MovieClip)
      {
         var _loc1_:int = 0;
         super();
         this.game = param1;
         if(this.m)
         {
            _loc1_ = int(Mobile.touchPx(9));
            this.icon = Mobile.touchPx(8);
            this.btnH = Mobile.touchPx(8);
            this.rowH = {
               "all":Math.max(ROW_H.all,_loc1_),
               "music":Math.max(ROW_H.music,_loc1_),
               "fx":Math.max(ROW_H.fx,_loc1_)
            };
            this.pw = W + this.icon - ICON;
            this.ph = H + (this.rowH.all - ROW_H.all) + (this.rowH.music - ROW_H.music) + (this.rowH.fx - ROW_H.fx) + (this.btnH - BTN_H);
         }
         addChild(this.backdrop);
         addChild(this.pivot);
         this.pivot.addChild(this.win);
         this.backdrop.addEventListener(MouseEvent.CLICK,this.onBackdrop,false,0,true);
         addEventListener(Event.ADDED_TO_STAGE,this.onAdded,false,0,true);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved,false,0,true);
      }

      public static function effective(param1:String) : Number
      {
         var _loc1_:Object = prefs(Mobile.game);
         if(_loc1_ == null)
         {
            return DEFAULTS[param1];
         }
         if(_loc1_["bMuteAll"] == true)
         {
            return 0;
         }
         if(param1 != "all" && _loc1_[MUTES[param1]] == true)
         {
            return 0;
         }
         var _loc2_:* = _loc1_[KEYS[param1]];
         var _loc3_:Number = _loc2_ != null ? Number(_loc2_) : Number(DEFAULTS[param1]);
         return isNaN(_loc3_) ? Number(DEFAULTS[param1]) : _loc3_;
      }

      public static function applyAll(param1:MovieClip) : void
      {
         if(param1 == null)
         {
            return;
         }
         SoundMixer.soundTransform = new SoundTransform(effective("all"));
         if(param1.mixer != null)
         {
            param1.mixer.stf = new SoundTransform(effective("fx"));
         }
         if(param1.world != null && param1.world.sController != null && param1.world.sController.mChannel != null)
         {
            param1.world.sController.mChannel.soundTransform = new SoundTransform(effective("music"));
         }
      }

      public static function open(param1:MovieClip) : void
      {
         if(param1 == null || param1.stage == null)
         {
            return;
         }
         if(current != null)
         {
            if(current.parent != null)
            {
               current.parent.setChildIndex(current,current.parent.numChildren - 1);
            }
            return;
         }
         current = new VolumePanel(param1);
         param1.stage.addChild(current);
         current.layout();
      }

      public static function soundButton(param1:DisplayObjectContainer, param2:Function) : void
      {
         var _loc4_:DisplayObject = null;
         var _loc5_:Rectangle = null;
         var _loc6_:DisplayObject = null;
         var _loc7_:Rectangle = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:int = 0;
         var _loc11_:InteractiveObject = null;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:DisplayObject = param1.getChildByName(SOUND_BTN);
         if(_loc2_ != null)
         {
            param1.removeChild(_loc2_);
         }
         var _loc3_:SimpleButton = param1.getChildByName("btnMusic") as SimpleButton;
         var _loc12_:Array = [_loc3_,param1.getChildByName("btnFX"),param1.getChildByName("btnAllSound")];
         if(_loc3_ == null || _loc12_[2] == null)
         {
            return;
         }
         VolumeButton.captureNative(_loc3_);
         var _loc13_:Rectangle = _loc3_.getBounds(param1);
         var _loc14_:Rectangle = _loc13_.clone();
         var _loc15_:Array = [];
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         while(_loc17_ < _loc12_.length)
         {
            _loc4_ = _loc12_[_loc17_] as DisplayObject;
            if(_loc4_ != null)
            {
               _loc5_ = _loc4_.getBounds(param1);
               _loc15_.push(_loc5_);
               _loc14_ = _loc14_.union(_loc5_);
               _loc16_ = Math.max(_loc16_,param1.getChildIndex(_loc4_));
               _loc4_.visible = false;
            }
            _loc17_++;
         }
         var _loc18_:int = 0;
         while(_loc18_ < param1.numChildren)
         {
            _loc6_ = param1.getChildAt(_loc18_);
            if(!(!(_loc6_ is StaticText) && !(_loc6_ is TextField)))
            {
               _loc7_ = _loc6_.getBounds(param1);
               _loc8_ = _loc7_.x + _loc7_.width / 2;
               _loc9_ = _loc7_.y + _loc7_.height / 2;
               _loc10_ = 0;
               while(_loc10_ < _loc15_.length)
               {
                  if(Rectangle(_loc15_[_loc10_]).contains(_loc8_,_loc9_))
                  {
                     _loc6_.visible = false;
                     _loc16_ = Math.max(_loc16_,_loc18_);
                     break;
                  }
                  _loc10_++;
               }
            }
            _loc18_++;
         }
         var _loc19_:VolumeButton = new VolumeButton(Math.round(_loc14_.right - _loc14_.x),Math.round(_loc13_.height),"Sound Settings",12);
         _loc19_.name = SOUND_BTN;
         _loc19_.x = Math.round(_loc14_.x);
         _loc19_.y = Math.round(_loc13_.y);
         _loc19_.addEventListener(MouseEvent.CLICK,param2,false,0,true);
         param1.addChildAt(_loc19_,_loc16_ + 1);
         if(!Mobile.active)
         {
            return;
         }
         var _loc20_:Array = [];
         var _loc21_:int = 0;
         while(_loc21_ < param1.numChildren)
         {
            _loc11_ = param1.getChildAt(_loc21_) as InteractiveObject;
            if(_loc11_ != null && _loc11_ != _loc19_)
            {
               _loc20_.push(_loc11_);
            }
            _loc21_++;
         }
         TouchTargets.pad(_loc19_,0,0,QtyTouch.band(_loc19_,null,_loc20_));
      }

      public static function touchLabel() : String
      {
         var _loc22_:String = Mobile.mode;
         return "Mobile Controls: " + (_loc22_ == "on" ? "On" : (_loc22_ == "off" ? "Off" : "Auto"));
      }

      public static function cycleTouch() : String
      {
         var _loc22_:String = Mobile.mode;
         Mobile.setMode(_loc22_ == "auto" ? "on" : (_loc22_ == "on" ? "off" : "auto"));
         return touchLabel();
      }

      private static function prefs(param1:MovieClip) : Object
      {
         if(param1 == null || param1.litePreference == null)
         {
            return null;
         }
         if(param1.litePreference.data.dOptions == null)
         {
            param1.litePreference.data.dOptions = {};
         }
         return param1.litePreference.data.dOptions;
      }

      private static function level(param1:Object, param2:String) : Number
      {
         var _loc2_:* = param1[KEYS[param2]];
         var _loc3_:Number = _loc2_ != null ? Number(_loc2_) : Number(DEFAULTS[param2]);
         if(isNaN(_loc3_))
         {
            _loc3_ = Number(DEFAULTS[param2]);
         }
         return Math.round(_loc3_ * 100);
      }

      private static function isMuted(param1:Object, param2:String) : Boolean
      {
         var _loc2_:Boolean = param1["bMuteAll"] == true;
         return param2 == "all" ? _loc2_ : _loc2_ || param1[MUTES[param2]] == true;
      }

      private static function textShadow() : DropShadowFilter
      {
         return new DropShadowFilter(1,45,0,0.6,2,2,1,1);
      }

      private function onAdded(param1:Event) : void
      {
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKey,false,0,true);
         stage.addEventListener(Event.RESIZE,this.onResize,false,0,true);
      }

      private function onRemoved(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onAnim);
         if(stage != null)
         {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKey);
            stage.removeEventListener(Event.RESIZE,this.onResize);
         }
         if(current == this)
         {
            current = null;
         }
      }

      private function onResize(param1:Event) : void
      {
         this.place();
      }

      private function onKey(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 27)
         {
            this.close();
         }
      }

      private function onBackdrop(param1:MouseEvent) : void
      {
         if(getTimer() - this.lastDragEnd < 400)
         {
            return;
         }
         this.close();
      }

      public function close() : void
      {
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }

      private function layout() : void
      {
         var _loc13_:String = null;
         var _loc14_:Shape = null;
         this.buildChrome();
         var _loc22_:int = WELL_PAD * 2 + this.rowH.all + 1 + this.rowH.music + this.rowH.fx;
         var _loc1_:Shape = new Shape();
         _loc1_.graphics.beginFill(657930);
         _loc1_.graphics.lineStyle(1,2763306,1,true);
         _loc1_.graphics.drawRoundRect(OUT,WELL_Y,this.pw - OUT * 2,_loc22_,12,12);
         _loc1_.graphics.endFill();
         _loc1_.filters = [new DropShadowFilter(2,90,0,0.5,4,4,1,1,true)];
         this.win.addChild(_loc1_);
         var _loc2_:int = WELL_Y + WELL_PAD;
         var _loc3_:int = 0;
         while(_loc3_ < CHANNELS.length)
         {
            _loc13_ = CHANNELS[_loc3_];
            this.buildRow(_loc13_,_loc2_,this.rowH[_loc13_]);
            _loc2_ += this.rowH[_loc13_];
            if(_loc13_ == "all")
            {
               _loc14_ = new Shape();
               _loc14_.graphics.beginFill(MailArt.TRIM,0.4);
               _loc14_.graphics.drawRect(OUT + INSET,_loc2_,this.pw - (OUT + INSET) * 2,1);
               _loc14_.graphics.endFill();
               this.win.addChild(_loc14_);
               _loc2_ += 1;
            }
            _loc3_++;
         }
         var _loc12_:int = WELL_Y + _loc22_ + 14;
         this.muteAllBtn = new VolumeButton(BTN_W,this.btnH,"Mute All");
         this.muteAllBtn.x = FOOT_IN;
         this.muteAllBtn.y = _loc12_;
         this.muteAllBtn.addEventListener(MouseEvent.CLICK,this.onMuteAll,false,0,true);
         this.win.addChild(this.muteAllBtn);
         this.defaultsBtn = new VolumeButton(BTN_W,this.btnH,"Defaults");
         this.defaultsBtn.x = (this.pw - BTN_W) / 2;
         this.defaultsBtn.y = _loc12_;
         this.defaultsBtn.addEventListener(MouseEvent.CLICK,this.onDefaults,false,0,true);
         this.win.addChild(this.defaultsBtn);
         this.doneBtn = new VolumeButton(BTN_W,this.btnH,"Done");
         this.doneBtn.x = this.pw - FOOT_IN - BTN_W;
         this.doneBtn.y = _loc12_;
         this.doneBtn.addEventListener(MouseEvent.CLICK,this.onCloseClick,false,0,true);
         this.win.addChild(this.doneBtn);
         if(this.m)
         {
            TouchTargets.pad(this.muteAllBtn);
            TouchTargets.pad(this.defaultsBtn);
            TouchTargets.pad(this.doneBtn);
         }
         this.refresh();
         this.place();
         this.startAnim();
      }

      private function buildRow(param1:String, param2:int, param3:int) : void
      {
         var _loc3_:int = param2 + int(param3 / 2);
         var _loc12_:int = OUT + INSET;
         var _loc13_:int = _loc12_ + this.icon + GAP;
         var _loc14_:VolumeButton = new VolumeButton(this.icon,this.icon);
         _loc14_.name = param1;
         _loc14_.x = _loc12_;
         _loc14_.y = _loc3_ - this.icon / 2;
         _loc14_.addEventListener(MouseEvent.CLICK,this.onMute,false,0,true);
         if(this.m)
         {
            TouchTargets.pad(_loc14_);
         }
         this.win.addChild(_loc14_);
         this.icons[param1] = _loc14_;
         var _loc15_:Boolean = param1 == "all";
         var _loc16_:TextField = MailArt.tf(_loc15_ ? 15 : 13,_loc15_ ? 16777215 : 15919317,true);
         _loc16_.filters = [textShadow()];
         _loc16_.text = LABELS[param1];
         MailArt.fit(_loc16_,LABEL_W - 4);
         var _loc17_:TextField = MailArt.tf(11,10066329);
         _loc17_.filters = [textShadow()];
         _loc17_.text = SUBS[param1];
         MailArt.fit(_loc17_,LABEL_W - 4);
         var _loc18_:Number = _loc16_.textHeight + 1 + _loc17_.textHeight;
         _loc16_.x = _loc13_ - 2;
         _loc16_.y = Math.round(_loc3_ - _loc18_ / 2) - 2;
         _loc17_.x = _loc13_ - 2;
         _loc17_.y = _loc16_.y + Math.round(_loc16_.textHeight) + 1;
         this.win.addChild(_loc16_);
         this.win.addChild(_loc17_);
         var _loc19_:TouchSlider = new TouchSlider();
         _loc19_.name = param1;
         _loc19_.x = _loc13_ + LABEL_W + GAP + TouchSlider.THUMB / 2;
         _loc19_.y = _loc3_;
         _loc19_.addEventListener(Event.CHANGE,this.onSlide,false,0,true);
         _loc19_.addEventListener(Event.COMPLETE,this.onSlideDone,false,0,true);
         this.win.addChild(_loc19_);
         this.sliders[param1] = _loc19_;
         var _loc20_:Sprite = new Sprite();
         _loc20_.mouseEnabled = false;
         _loc20_.mouseChildren = false;
         _loc20_.graphics.lineStyle(1,3815994,1,true);
         _loc20_.graphics.beginFill(1710618);
         _loc20_.graphics.drawRoundRect(0,0,PILL_W,PILL_H,PILL_H,PILL_H);
         _loc20_.graphics.endFill();
         var _loc21_:TextField = MailArt.tf(13,MailArt.GOLD,true);
         _loc21_.filters = [textShadow()];
         _loc20_.addChild(_loc21_);
         _loc20_.x = _loc19_.x + TouchSlider.TRACK_W + TouchSlider.THUMB / 2 + GAP;
         _loc20_.y = _loc3_ - PILL_H / 2;
         this.win.addChild(_loc20_);
         this.pills[param1] = _loc21_;
      }

      private function buildChrome() : void
      {
         var cls:Class = null;
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
               this.bg = new cls() as MovieClip;
            }
            catch(e2:Error)
            {
               bg = null;
            }
         }
         if(this.bg == null)
         {
            this.buildFallbackChrome();
            return;
         }
         this.win.addChildAt(this.bg,0);
         try
         {
            this.bg.frame.width = this.pw;
            this.bg.frame.height = this.ph;
            this.bg.bg.width = this.pw - 12;
            this.bg.bg.height = this.ph - 10;
            this.bg.btnClose.x = this.pw - 31;
         }
         catch(e3:Error)
         {
         }
         try
         {
            if("dragonLeft" in this.bg)
            {
               this.bg.dragonLeft.visible = false;
            }
         }
         catch(e4:Error)
         {
         }
         try
         {
            if("dragonRight" in this.bg)
            {
               this.bg.dragonRight.visible = false;
            }
         }
         catch(e5:Error)
         {
         }
         try
         {
            this.bg.tTitle.text = "Sound Settings";
            this.bg.tTitle.textColor = 16777215;
            this.bg.tTitle.x = int(this.pw / 2 - this.bg.tTitle.width / 2);
         }
         catch(e6:Error)
         {
         }
         try
         {
            this.bg.btnClose.addEventListener(MouseEvent.CLICK,this.onCloseClick,false,0,true);
            if(this.m)
            {
               TouchTargets.pad(this.bg.btnClose as InteractiveObject);
            }
         }
         catch(e7:Error)
         {
         }
      }

      private function buildFallbackChrome() : void
      {
         var _loc22_:Shape = new Shape();
         var _loc1_:Graphics = _loc22_.graphics;
         var _loc2_:Matrix = new Matrix();
         _loc2_.createGradientBox(this.pw,this.ph,Math.PI / 2,0,0);
         _loc1_.lineStyle(2,MailArt.TRIM,1,true);
         _loc1_.beginGradientFill(GradientType.LINEAR,[2236962,1315860],[1,1],[0,255],_loc2_);
         _loc1_.drawRoundRect(0,0,this.pw,this.ph,12,12);
         _loc1_.endFill();
         this.win.addChildAt(_loc22_,0);
         var _loc3_:TextField = MailArt.tf(14,16777215,true);
         _loc3_.filters = [textShadow()];
         _loc3_.text = "Sound Settings";
         _loc3_.x = int(this.pw / 2 - _loc3_.width / 2);
         _loc3_.y = 10;
         this.win.addChild(_loc3_);
         this.fallbackClose = new Sprite();
         var _loc12_:Graphics = this.fallbackClose.graphics;
         _loc12_.beginFill(3807770);
         _loc12_.lineStyle(1,9054762,1,true);
         _loc12_.drawRoundRect(0,0,22,22,6,6);
         _loc12_.endFill();
         var _loc13_:TextField = MailArt.tf(12,16748688,true);
         _loc13_.text = "X";
         _loc13_.x = Math.round((22 - _loc13_.width) / 2);
         _loc13_.y = Math.round((22 - _loc13_.height) / 2);
         this.fallbackClose.addChild(_loc13_);
         this.fallbackClose.x = this.pw - 31;
         this.fallbackClose.y = 8;
         this.fallbackClose.buttonMode = true;
         this.fallbackClose.mouseChildren = false;
         this.fallbackClose.addEventListener(MouseEvent.CLICK,this.onCloseClick,false,0,true);
         if(this.m)
         {
            TouchTargets.pad(this.fallbackClose);
         }
         this.win.addChild(this.fallbackClose);
      }

      private function place() : void
      {
         if(stage == null)
         {
            return;
         }
         var _loc22_:Number = stage.stageWidth;
         var _loc1_:Number = stage.stageHeight;
         this.backdrop.graphics.clear();
         this.backdrop.graphics.beginFill(0,0.4);
         this.backdrop.graphics.drawRect(0,0,_loc22_,_loc1_);
         this.backdrop.graphics.endFill();
         var _loc2_:int = Math.round((_loc22_ - this.pw) / 2);
         var _loc3_:int = Math.round((_loc1_ - this.ph) / 2);
         if(_loc3_ + this.ph > 500 && this.ph <= 500)
         {
            _loc3_ = 500 - this.ph;
         }
         this.win.x = -this.pw / 2;
         this.win.y = -this.ph / 2;
         this.pivot.x = _loc2_ + this.pw / 2;
         this.pivot.y = _loc3_ + this.ph / 2;
      }

      private function startAnim() : void
      {
         this.openAt = getTimer();
         alpha = 0;
         this.pivot.scaleX = this.pivot.scaleY = 0.96;
         addEventListener(Event.ENTER_FRAME,this.onAnim,false,0,true);
      }

      private function onAnim(param1:Event) : void
      {
         var _loc1_:Number = Math.min(1,(getTimer() - this.openAt) / OPEN_MS);
         var _loc2_:Number = 1 - (1 - _loc1_) * (1 - _loc1_);
         alpha = _loc2_;
         this.pivot.scaleX = this.pivot.scaleY = 0.96 + 0.04 * _loc2_;
         if(_loc1_ < 1)
         {
            return;
         }
         alpha = 1;
         this.pivot.scaleX = this.pivot.scaleY = 1;
         removeEventListener(Event.ENTER_FRAME,this.onAnim);
      }

      private function onCloseClick(param1:MouseEvent) : void
      {
         this.close();
      }

      private function setPill(param1:String, param2:Number) : void
      {
         var _loc2_:TextField = this.pills[param1];
         _loc2_.text = param2 + "%";
         _loc2_.x = Math.round((PILL_W - _loc2_.width) / 2);
         _loc2_.y = Math.round((PILL_H - _loc2_.height) / 2);
      }

      private function onSlide(param1:Event) : void
      {
         var _loc1_:TouchSlider = TouchSlider(param1.currentTarget);
         var _loc2_:Object = prefs(this.game);
         if(_loc2_ == null)
         {
            return;
         }
         _loc2_[KEYS[_loc1_.name]] = _loc1_.value / 100;
         this.setPill(_loc1_.name,_loc1_.value);
         VolumeButton(this.icons[_loc1_.name]).speaker(_loc1_.value,isMuted(_loc2_,_loc1_.name));
         applyAll(this.game);
      }

      private function onSlideDone(param1:Event) : void
      {
         this.lastDragEnd = getTimer();
         this.flush();
         if(DisplayObject(param1.currentTarget).name == "fx")
         {
            try
            {
               if(this.game.mixer != null)
               {
                  this.game.mixer.playSound("Click");
               }
            }
            catch(err:Error)
            {
            }
         }
      }

      private function onMute(param1:MouseEvent) : void
      {
         var _loc1_:Object = prefs(this.game);
         if(_loc1_ == null)
         {
            return;
         }
         var _loc2_:String = MUTES[DisplayObject(param1.currentTarget).name];
         _loc1_[_loc2_] = _loc1_[_loc2_] != true;
         this.finish();
      }

      private function onMuteAll(param1:MouseEvent) : void
      {
         var _loc1_:Object = prefs(this.game);
         if(_loc1_ == null)
         {
            return;
         }
         _loc1_["bMuteAll"] = _loc1_["bMuteAll"] != true;
         this.finish();
      }

      private function onDefaults(param1:MouseEvent) : void
      {
         var _loc3_:String = null;
         var _loc1_:Object = prefs(this.game);
         if(_loc1_ == null)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < CHANNELS.length)
         {
            _loc3_ = CHANNELS[_loc2_];
            _loc1_[KEYS[_loc3_]] = DEFAULTS[_loc3_];
            _loc1_[MUTES[_loc3_]] = false;
            _loc2_++;
         }
         this.finish();
      }

      private function finish() : void
      {
         applyAll(this.game);
         this.flush();
         this.refresh();
      }

      private function flush() : void
      {
         try
         {
            if(this.game.litePreference != null)
            {
               this.game.litePreference.flush();
            }
         }
         catch(e:Error)
         {
         }
      }

      private function refresh() : void
      {
         var _loc3_:String = null;
         var _loc12_:Number = NaN;
         var _loc13_:Boolean = false;
         var _loc14_:TouchSlider = null;
         var _loc22_:Object = prefs(this.game);
         if(_loc22_ == null)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < CHANNELS.length)
         {
            _loc3_ = CHANNELS[_loc1_];
            _loc12_ = Number(level(_loc22_,_loc3_));
            _loc13_ = Boolean(isMuted(_loc22_,_loc3_));
            _loc14_ = this.sliders[_loc3_];
            _loc14_.value = _loc12_;
            _loc14_.alpha = _loc13_ ? 0.5 : 1;
            this.setPill(_loc3_,_loc12_);
            VolumeButton(this.icons[_loc3_]).speaker(_loc12_,_loc13_);
            _loc1_++;
         }
         var _loc2_:Boolean = _loc22_["bMuteAll"] == true;
         this.muteAllBtn.selected = _loc2_;
         this.muteAllBtn.label = _loc2_ ? "Unmute All" : "Mute All";
      }
   }
}
