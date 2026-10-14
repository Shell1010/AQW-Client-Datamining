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
         var _loc1_:DisplayObject = null;
         var _loc2_:Rectangle = null;
         var _loc3_:DisplayObject = null;
         var _loc4_:Rectangle = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:InteractiveObject = null;
         if(param1 == null)
         {
            return;
         }
         var _loc9_:DisplayObject = param1.getChildByName(SOUND_BTN);
         if(_loc9_ != null)
         {
            param1.removeChild(_loc9_);
         }
         var _loc10_:SimpleButton = param1.getChildByName("btnMusic") as SimpleButton;
         var _loc11_:Array = [_loc10_,param1.getChildByName("btnFX"),param1.getChildByName("btnAllSound")];
         if(_loc10_ == null || _loc11_[2] == null)
         {
            return;
         }
         VolumeButton.captureNative(_loc10_);
         var _loc12_:Rectangle = _loc10_.getBounds(param1);
         var _loc13_:Rectangle = _loc12_.clone();
         var _loc14_:Array = [];
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         while(_loc16_ < _loc11_.length)
         {
            _loc1_ = _loc11_[_loc16_] as DisplayObject;
            if(_loc1_ != null)
            {
               _loc2_ = _loc1_.getBounds(param1);
               _loc14_.push(_loc2_);
               _loc13_ = _loc13_.union(_loc2_);
               _loc15_ = Math.max(_loc15_,param1.getChildIndex(_loc1_));
               _loc1_.visible = false;
            }
            _loc16_++;
         }
         var _loc17_:int = 0;
         while(_loc17_ < param1.numChildren)
         {
            _loc3_ = param1.getChildAt(_loc17_);
            if(!(!(_loc3_ is StaticText) && !(_loc3_ is TextField)))
            {
               _loc4_ = _loc3_.getBounds(param1);
               _loc5_ = _loc4_.x + _loc4_.width / 2;
               _loc6_ = _loc4_.y + _loc4_.height / 2;
               _loc7_ = 0;
               while(_loc7_ < _loc14_.length)
               {
                  if(Rectangle(_loc14_[_loc7_]).contains(_loc5_,_loc6_))
                  {
                     _loc3_.visible = false;
                     _loc15_ = Math.max(_loc15_,_loc17_);
                     break;
                  }
                  _loc7_++;
               }
            }
            _loc17_++;
         }
         var _loc18_:VolumeButton = new VolumeButton(Math.round(_loc13_.right - _loc13_.x),Math.round(_loc12_.height),"Sound Settings",12);
         _loc18_.name = SOUND_BTN;
         _loc18_.x = Math.round(_loc13_.x);
         _loc18_.y = Math.round(_loc12_.y);
         _loc18_.addEventListener(MouseEvent.CLICK,param2,false,0,true);
         param1.addChildAt(_loc18_,_loc15_ + 1);
         if(!Mobile.active)
         {
            return;
         }
         var _loc19_:Array = [];
         var _loc20_:int = 0;
         while(_loc20_ < param1.numChildren)
         {
            _loc8_ = param1.getChildAt(_loc20_) as InteractiveObject;
            if(_loc8_ != null && _loc8_ != _loc18_)
            {
               _loc19_.push(_loc8_);
            }
            _loc20_++;
         }
         TouchTargets.pad(_loc18_,0,0,QtyTouch.band(_loc18_,null,_loc19_));
      }

      public static function touchLabel() : String
      {
         var _loc1_:String = Mobile.mode;
         return "Mobile Controls: " + (_loc1_ == "on" ? "On" : (_loc1_ == "off" ? "Off" : "Auto"));
      }

      public static function cycleTouch() : String
      {
         var _loc1_:String = Mobile.mode;
         Mobile.setMode(_loc1_ == "auto" ? "on" : (_loc1_ == "on" ? "off" : "auto"));
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
         var _loc1_:* = param1[KEYS[param2]];
         var _loc2_:Number = _loc1_ != null ? Number(_loc1_) : Number(DEFAULTS[param2]);
         if(isNaN(_loc2_))
         {
            _loc2_ = Number(DEFAULTS[param2]);
         }
         return Math.round(_loc2_ * 100);
      }

      private static function isMuted(param1:Object, param2:String) : Boolean
      {
         var _loc1_:Boolean = param1["bMuteAll"] == true;
         return param2 == "all" ? _loc1_ : _loc1_ || param1[MUTES[param2]] == true;
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
         var _loc1_:String = null;
         var _loc2_:Shape = null;
         this.buildChrome();
         var _loc3_:int = WELL_PAD * 2 + this.rowH.all + 1 + this.rowH.music + this.rowH.fx;
         var _loc4_:Shape = new Shape();
         _loc4_.graphics.beginFill(657930);
         _loc4_.graphics.lineStyle(1,2763306,1,true);
         _loc4_.graphics.drawRoundRect(OUT,WELL_Y,this.pw - OUT * 2,_loc3_,12,12);
         _loc4_.graphics.endFill();
         _loc4_.filters = [new DropShadowFilter(2,90,0,0.5,4,4,1,1,true)];
         this.win.addChild(_loc4_);
         var _loc5_:int = WELL_Y + WELL_PAD;
         var _loc6_:int = 0;
         while(_loc6_ < CHANNELS.length)
         {
            _loc1_ = CHANNELS[_loc6_];
            this.buildRow(_loc1_,_loc5_,this.rowH[_loc1_]);
            _loc5_ += this.rowH[_loc1_];
            if(_loc1_ == "all")
            {
               _loc2_ = new Shape();
               _loc2_.graphics.beginFill(MailArt.TRIM,0.4);
               _loc2_.graphics.drawRect(OUT + INSET,_loc5_,this.pw - (OUT + INSET) * 2,1);
               _loc2_.graphics.endFill();
               this.win.addChild(_loc2_);
               _loc5_ += 1;
            }
            _loc6_++;
         }
         var _loc7_:int = WELL_Y + _loc3_ + 14;
         this.muteAllBtn = new VolumeButton(BTN_W,this.btnH,"Mute All");
         this.muteAllBtn.x = FOOT_IN;
         this.muteAllBtn.y = _loc7_;
         this.muteAllBtn.addEventListener(MouseEvent.CLICK,this.onMuteAll,false,0,true);
         this.win.addChild(this.muteAllBtn);
         this.defaultsBtn = new VolumeButton(BTN_W,this.btnH,"Defaults");
         this.defaultsBtn.x = (this.pw - BTN_W) / 2;
         this.defaultsBtn.y = _loc7_;
         this.defaultsBtn.addEventListener(MouseEvent.CLICK,this.onDefaults,false,0,true);
         this.win.addChild(this.defaultsBtn);
         this.doneBtn = new VolumeButton(BTN_W,this.btnH,"Done");
         this.doneBtn.x = this.pw - FOOT_IN - BTN_W;
         this.doneBtn.y = _loc7_;
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
         var _loc1_:int = param2 + int(param3 / 2);
         var _loc2_:int = OUT + INSET;
         var _loc3_:int = _loc2_ + this.icon + GAP;
         var _loc4_:VolumeButton = new VolumeButton(this.icon,this.icon);
         _loc4_.name = param1;
         _loc4_.x = _loc2_;
         _loc4_.y = _loc1_ - this.icon / 2;
         _loc4_.addEventListener(MouseEvent.CLICK,this.onMute,false,0,true);
         if(this.m)
         {
            TouchTargets.pad(_loc4_);
         }
         this.win.addChild(_loc4_);
         this.icons[param1] = _loc4_;
         var _loc5_:Boolean = param1 == "all";
         var _loc6_:TextField = MailArt.tf(_loc5_ ? 15 : 13,_loc5_ ? 16777215 : 15919317,true);
         _loc6_.filters = [textShadow()];
         _loc6_.text = LABELS[param1];
         MailArt.fit(_loc6_,LABEL_W - 4);
         var _loc7_:TextField = MailArt.tf(11,10066329);
         _loc7_.filters = [textShadow()];
         _loc7_.text = SUBS[param1];
         MailArt.fit(_loc7_,LABEL_W - 4);
         var _loc8_:Number = _loc6_.textHeight + 1 + _loc7_.textHeight;
         _loc6_.x = _loc3_ - 2;
         _loc6_.y = Math.round(_loc1_ - _loc8_ / 2) - 2;
         _loc7_.x = _loc3_ - 2;
         _loc7_.y = _loc6_.y + Math.round(_loc6_.textHeight) + 1;
         this.win.addChild(_loc6_);
         this.win.addChild(_loc7_);
         var _loc9_:TouchSlider = new TouchSlider();
         _loc9_.name = param1;
         _loc9_.x = _loc3_ + LABEL_W + GAP + TouchSlider.THUMB / 2;
         _loc9_.y = _loc1_;
         _loc9_.addEventListener(Event.CHANGE,this.onSlide,false,0,true);
         _loc9_.addEventListener(Event.COMPLETE,this.onSlideDone,false,0,true);
         this.win.addChild(_loc9_);
         this.sliders[param1] = _loc9_;
         var _loc10_:Sprite = new Sprite();
         _loc10_.mouseEnabled = false;
         _loc10_.mouseChildren = false;
         _loc10_.graphics.lineStyle(1,3815994,1,true);
         _loc10_.graphics.beginFill(1710618);
         _loc10_.graphics.drawRoundRect(0,0,PILL_W,PILL_H,PILL_H,PILL_H);
         _loc10_.graphics.endFill();
         var _loc11_:TextField = MailArt.tf(13,MailArt.GOLD,true);
         _loc11_.filters = [textShadow()];
         _loc10_.addChild(_loc11_);
         _loc10_.x = _loc9_.x + TouchSlider.TRACK_W + TouchSlider.THUMB / 2 + GAP;
         _loc10_.y = _loc1_ - PILL_H / 2;
         this.win.addChild(_loc10_);
         this.pills[param1] = _loc11_;
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
         var _loc1_:Shape = new Shape();
         var _loc2_:Graphics = _loc1_.graphics;
         var _loc3_:Matrix = new Matrix();
         _loc3_.createGradientBox(this.pw,this.ph,Math.PI / 2,0,0);
         _loc2_.lineStyle(2,MailArt.TRIM,1,true);
         _loc2_.beginGradientFill(GradientType.LINEAR,[2236962,1315860],[1,1],[0,255],_loc3_);
         _loc2_.drawRoundRect(0,0,this.pw,this.ph,12,12);
         _loc2_.endFill();
         this.win.addChildAt(_loc1_,0);
         var _loc4_:TextField = MailArt.tf(14,16777215,true);
         _loc4_.filters = [textShadow()];
         _loc4_.text = "Sound Settings";
         _loc4_.x = int(this.pw / 2 - _loc4_.width / 2);
         _loc4_.y = 10;
         this.win.addChild(_loc4_);
         this.fallbackClose = new Sprite();
         var _loc5_:Graphics = this.fallbackClose.graphics;
         _loc5_.beginFill(3807770);
         _loc5_.lineStyle(1,9054762,1,true);
         _loc5_.drawRoundRect(0,0,22,22,6,6);
         _loc5_.endFill();
         var _loc6_:TextField = MailArt.tf(12,16748688,true);
         _loc6_.text = "X";
         _loc6_.x = Math.round((22 - _loc6_.width) / 2);
         _loc6_.y = Math.round((22 - _loc6_.height) / 2);
         this.fallbackClose.addChild(_loc6_);
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
         var _loc1_:Number = stage.stageWidth;
         var _loc2_:Number = stage.stageHeight;
         this.backdrop.graphics.clear();
         this.backdrop.graphics.beginFill(0,0.4);
         this.backdrop.graphics.drawRect(0,0,_loc1_,_loc2_);
         this.backdrop.graphics.endFill();
         var _loc3_:int = Math.round((_loc1_ - this.pw) / 2);
         var _loc4_:int = Math.round((_loc2_ - this.ph) / 2);
         if(_loc4_ + this.ph > 500 && this.ph <= 500)
         {
            _loc4_ = 500 - this.ph;
         }
         this.win.x = -this.pw / 2;
         this.win.y = -this.ph / 2;
         this.pivot.x = _loc3_ + this.pw / 2;
         this.pivot.y = _loc4_ + this.ph / 2;
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
         var _loc1_:TextField = this.pills[param1];
         _loc1_.text = param2 + "%";
         _loc1_.x = Math.round((PILL_W - _loc1_.width) / 2);
         _loc1_.y = Math.round((PILL_H - _loc1_.height) / 2);
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
         var _loc1_:String = null;
         var _loc2_:Object = prefs(this.game);
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:int = 0;
         while(_loc3_ < CHANNELS.length)
         {
            _loc1_ = CHANNELS[_loc3_];
            _loc2_[KEYS[_loc1_]] = DEFAULTS[_loc1_];
            _loc2_[MUTES[_loc1_]] = false;
            _loc3_++;
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
         var _loc1_:String = null;
         var _loc2_:Number = NaN;
         var _loc3_:Boolean = false;
         var _loc4_:TouchSlider = null;
         var _loc5_:Object = prefs(this.game);
         if(_loc5_ == null)
         {
            return;
         }
         var _loc6_:int = 0;
         while(_loc6_ < CHANNELS.length)
         {
            _loc1_ = CHANNELS[_loc6_];
            _loc2_ = Number(level(_loc5_,_loc1_));
            _loc3_ = Boolean(isMuted(_loc5_,_loc1_));
            _loc4_ = this.sliders[_loc1_];
            _loc4_.value = _loc2_;
            _loc4_.alpha = _loc3_ ? 0.5 : 1;
            this.setPill(_loc1_,_loc2_);
            VolumeButton(this.icons[_loc1_]).speaker(_loc2_,_loc3_);
            _loc6_++;
         }
         var _loc7_:Boolean = _loc5_["bMuteAll"] == true;
         this.muteAllBtn.selected = _loc7_;
         this.muteAllBtn.label = _loc7_ ? "Unmute All" : "Mute All";
      }
   }
}
