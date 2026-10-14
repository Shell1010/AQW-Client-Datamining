package
{
   import fl.motion.Color;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.system.ApplicationDomain;
   import flash.utils.getTimer;

   [Embed(source="/_assets/assets.swf", symbol="symbol3324")]
   public class AvatarMC extends MovieClip
   {

      private static var solidArr:Array;

      private static var solidSpace:DisplayObject;

      private static var solidTick:Shape;

      private static var solidLen:int = -1;

      private static var solidDirty:Boolean = true;

      private static var solidPad:Number = 4;

      private static const solidBox:Vector.<Number> = new Vector.<Number>();

      private static const solidObj:Vector.<DisplayObject> = new Vector.<DisplayObject>();

      private static const solidShd:Vector.<DisplayObject> = new Vector.<DisplayObject>();

      private static const steerOrigin:Point = new Point(0,0);

      private static const IAF_BODY_PARTS:Array = ["head","chest","hip","idlefoot","frontfoot","backfoot","frontshoulder","backshoulder","fronthand","backhand","frontthigh","backthigh","frontshin","backshin","robe","backrobe"];

      public var Sounds:MovieClip;

      public var bubble:MovieClip;

      public var cShadow:MovieClip;

      public var fx:MovieClip;

      public var hpBar:MovieClip;

      public var ignore:MovieClip;

      public var mcChar:mcSkel;

      public var pname:MovieClip;

      public var proxy:MovieClip;

      public var shadow:MovieClip;

      private var xDep:*;

      private var yDep:*;

      private var xTar:*;

      private var yTar:Number;

      private var nDuration:*;

      private var nXStep:*;

      private var nYStep:*;

      private var walkSpeed:Number;

      private var op:Point;

      public var tp:Point;

      private var walkTS:Number;

      private var walkD:Number;

      private var walkDist:Number = 0;

      private var walkOn:Boolean = false;

      private var steerOn:Boolean = false;

      private var steerVX:Number = 0;

      private var steerVY:Number = 0;

      private var steerSpd:int = 8;

      private var steerTS:int = 0;

      private var steerStall:int = 0;

      private var steerPetTS:int = 0;

      private var steerArea:Function = null;

      private var headPoint:Point;

      private var cbx:*;

      private var cby:Number;

      private var bLoadingHelm:Boolean = false;

      private var objLinks:Object = {};

      private var heavyAssets:Array = [];

      private var totalTransform:Object = {
         "alphaMultiplier":1,
         "alphaOffset":0,
         "redMultiplier":1,
         "redOffset":0,
         "greenMultiplier":1,
         "greenOffset":0,
         "blueMultiplier":1,
         "blueOffset":0
      };

      private var clampedTransform:ColorTransform = new ColorTransform();

      private var animQueue:Array = [];

      public var pAV:Avatar;

      public var projClass:Projectile;

      public var spFX:Object = {};

      public var spellDur:int = 0;

      public var bBackHair:Boolean = false;

      public var isLoaded:Boolean = false;

      public var STAGE:MovieClip;

      public var world:MovieClip;

      public var px:*;

      public var py:*;

      public var tx:*;

      public var ty:Number;

      public var kv:Killvis = null;

      public var defaultCT:ColorTransform = MovieClip(this).transform.colorTransform;

      public var strGender:String;

      public var previousframe:int = -1;

      public var hitboxR:Rectangle;

      public var CT3:ColorTransform = new ColorTransform(1,1,1,1,255,255,255,0);

      public var CT2:ColorTransform = new ColorTransform(1,1,1,1,127,127,127,0);

      public var CT1:ColorTransform = new ColorTransform(1,1,1,1,0,0,0,0);

      private var rootClass:MovieClip;

      private const MAX_RATIO:Number = 4.656612875245797e-10;

      private const NEGA_MAX_RATIO:Number = -this.MAX_RATIO;

      private var r:int = Math.random() * int.MAX_VALUE;

      private var randNum:Number;

      private var weaponLoad:Boolean = true;

      private var armorLoad:Boolean = true;

      private var classLoad:Boolean = true;

      private var helmLoad:Boolean = true;

      private var hairLoad:Boolean = true;

      private var capeLoad:Boolean = true;

      private var miscLoad:Boolean = true;

      private var animEvents:Object = new Object();

      private var mcOrder:Object = new Object();

      private var testMC:*;

      private var topIndex:int = 0;

      private var hidePausedFrame:int = 0;

      public var isRasterized:Boolean;

      private var rasterWait:int = 0;

      private var rasterArmed:Boolean = false;

      private var rawWepRetries:int = 0;

      public var helmBackHair:Boolean = false;

      private var queueStallTicks:int = 0;

      public var attackFrames:Array = [];

      public var sp:Number = 8;

      public var mvts:Number;

      public var mvtd:Number;

      private var _spFXQueue:Array = [];

      public function AvatarMC(param1:Boolean = true)
      {
         super();
         addFrameScript(0,this.frame1,4,this.frame5,7,this.frame8,9,this.frame10,11,this.frame12,12,this.frame13,13,this.frame14,17,this.frame18,19,this.frame20,22,this.frame23);
         this.Sounds.visible = false;
         this.ignore.visible = false;
         if(param1)
         {
            this.mcChar.addEventListener(MouseEvent.CLICK,this.onClickHandler);
         }
         this.mcChar.buttonMode = true;
         this.mcChar.pvpFlag.mouseEnabled = false;
         this.mcChar.pvpFlag.mouseChildren = false;
         this.pname.mouseChildren = false;
         this.pname.buttonMode = false;
         this.mcChar.mouseChildren = true;
         this.bubble.mouseEnabled = this.bubble.mouseChildren = false;
         if(param1)
         {
            this.shadow.addEventListener(MouseEvent.CLICK,this.onClickHandler);
         }
         this.bubble.visible = false;
         this.bubble.t = "";
         this.pname.ti.text = "";
         this.headPoint = new Point(0,this.mcChar.head.y - 1.4 * this.mcChar.head.height);
         this.hideOptionalParts();
      }

      private static function onSolidExit(param1:Event) : void
      {
         solidDirty = true;
      }

      private static function solidBuild(param1:Array, param2:DisplayObject) : void
      {
         var _loc1_:* = undefined;
         var _loc2_:DisplayObject = null;
         var _loc3_:Rectangle = null;
         var _loc4_:Matrix = null;
         if(solidTick == null)
         {
            solidTick = new Shape();
            solidTick.addEventListener(Event.EXIT_FRAME,onSolidExit);
         }
         solidArr = param1;
         solidSpace = param2;
         solidLen = param1.length;
         solidDirty = false;
         solidBox.length = 0;
         solidObj.length = 0;
         solidShd.length = 0;
         var _loc5_:int = 0;
         while(_loc5_ < solidLen)
         {
            _loc1_ = param1[_loc5_];
            if(!(_loc1_ == null || _loc1_.shadow == null || _loc1_.stage == null))
            {
               _loc2_ = _loc1_.shadow as DisplayObject;
               if(_loc2_ != null)
               {
                  _loc3_ = _loc2_.getBounds(param2);
                  solidBox.push(_loc3_.x,_loc3_.y,_loc3_.x + _loc3_.width,_loc3_.y + _loc3_.height);
                  solidObj.push(_loc1_);
                  solidShd.push(_loc2_);
               }
            }
            _loc5_++;
         }
         var _loc6_:Number = NaN;
         try
         {
            _loc4_ = param2.transform.concatenatedMatrix;
            if(_loc4_.b == 0 && _loc4_.c == 0)
            {
               _loc6_ = Math.min(Math.abs(_loc4_.a),Math.abs(_loc4_.d));
            }
         }
         catch(e:Error)
         {
         }
         solidPad = _loc6_ > 0.01 && _loc6_ < 100 ? Math.max(32,32 / _loc6_) : 4000;
      }

      public static function solidHit(param1:DisplayObject, param2:Array, param3:DisplayObject) : Boolean
      {
         var _loc6_:int = 0;
         if(param1 == null || param2 == null)
         {
            return false;
         }
         if(param1.stage == null || param3 == null || param3.stage == null)
         {
            _loc6_ = 0;
            while(_loc6_ < param2.length)
            {
               if(!(param2[_loc6_] == null || param2[_loc6_].shadow == null || param2[_loc6_].stage == null))
               {
                  if(param1.hitTestObject(param2[_loc6_].shadow))
                  {
                     return true;
                  }
               }
               _loc6_++;
            }
            return false;
         }
         if(solidDirty || param2 !== solidArr || param2.length != solidLen || param3 !== solidSpace)
         {
            solidBuild(param2,param3);
         }
         _loc6_ = int(solidObj.length);
         if(_loc6_ == 0)
         {
            return false;
         }
         var _loc1_:Rectangle = param1.getBounds(param3);
         var _loc2_:Number = solidPad;
         var _loc3_:Number = _loc1_.x - _loc2_;
         var _loc4_:Number = _loc1_.y - _loc2_;
         var _loc7_:Number = _loc1_.x + _loc1_.width + _loc2_;
         var _loc8_:Number = _loc1_.y + _loc1_.height + _loc2_;
         var _loc9_:Vector.<Number> = solidBox;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         while(_loc11_ < _loc6_)
         {
            if(!(_loc9_[_loc10_] > _loc7_ || _loc9_[_loc10_ + 2] < _loc3_ || _loc9_[_loc10_ + 1] > _loc8_ || _loc9_[_loc10_ + 3] < _loc4_))
            {
               if(solidObj[_loc11_].stage != null)
               {
                  if(param1.hitTestObject(solidShd[_loc11_]))
                  {
                     return true;
                  }
               }
            }
            _loc11_++;
            _loc10_ += 4;
         }
         return false;
      }

      public function fClose() : void
      {
         var _loc12_:Boolean = false;
         if(this.stage != null)
         {
            this.world = MovieClip(stage.getChildAt(0)).world;
         }
         if(this.world != null && this.world.CHARS != null && Boolean(this.world.CHARS.contains(this)))
         {
            this.world.CHARS.removeChild(this);
         }
         if(this.world != null && this.world.TRASH != null && Boolean(this.world.TRASH.contains(this)))
         {
            this.world.TRASH.removeChild(this);
         }
         if(this.kv != null)
         {
            try
            {
               this.kv.cleanup();
            }
            catch(eKV:Error)
            {
            }
            this.kv = null;
         }
         try
         {
            this.derasterizeChar();
         }
         catch(eDRC:Error)
         {
         }
         if(this.pAV != null)
         {
            _loc12_ = this.world != null && this.pAV == this.world.myAvatar || this.pAV != null && this.pAV.isMyAvatar;
            if(!_loc12_)
            {
               try
               {
                  this.pAV.unloadPet();
               }
               catch(ePT:Error)
               {
               }
               try
               {
                  this.unloadEquipment();
               }
               catch(eEQ:Error)
               {
               }
            }
            if(this.world != null && this.pAV == this.world.myAvatar)
            {
               this.world.setTarget(null);
            }
            else if(this.pAV != null)
            {
               this.pAV.target = null;
            }
            this.pAV.pMC = null;
            this.pAV = null;
         }
         try
         {
            this.recursiveStop(this);
         }
         catch(eRS:Error)
         {
         }
         if(this.mcChar != null)
         {
            this.mcChar.removeEventListener(MouseEvent.CLICK,this.onClickHandler);
         }
         if(this.pname != null)
         {
            this.pname.removeEventListener(MouseEvent.CLICK,this.onClickHandler);
         }
         if(this.shadow != null)
         {
            this.shadow.removeEventListener(MouseEvent.CLICK,this.onClickHandler);
         }
         this.hideNameCleanup();
         this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrameWalk);
         this.removeEventListener(Event.ENTER_FRAME,this.checkQueue);
         try
         {
            if(getChildByName("HealIconMC") != null)
            {
               MovieClip(getChildByName("HealIconMC")).fClose();
            }
         }
         catch(e:Error)
         {
         }
         if(this.fx != null)
         {
            while(this.fx.numChildren > 0)
            {
               this.fx.removeChildAt(0);
            }
         }
         this.clearAnimEvents();
         this.clearSpFXQueue();
         this.spFX = null;
      }

      public function unloadEquipment() : void
      {
         var _loc12_:DisplayObject = null;
         if(this.mcChar != null)
         {
            if(this.mcChar.head != null)
            {
               this.unloadSlot(this.mcChar.head.helm,"helm");
               this.unloadSlot(this.mcChar.head.hair,"hair");
               this.unloadSlot(this.mcChar.head.face,"face");
            }
            this.unloadSlot(this.mcChar.weapon,"weapon");
            this.unloadSlot(this.mcChar.weaponOff,"weaponOff");
            this.unloadSlot(this.mcChar.cape,"cape");
            try
            {
               for each(_loc12_ in this.mcChar)
               {
                  if(_loc12_ is MovieClip && _loc12_ != this.mcChar)
                  {
                     this.unloadMovieClip(MovieClip(_loc12_));
                  }
               }
            }
            catch(e:Error)
            {
            }
         }
      }

      private function unloadSlot(param1:*, param2:String) : void
      {
         var _loc5_:DisplayObjectContainer = null;
         var _loc6_:DisplayObject = null;
         if(param1 != null)
         {
            try
            {
               if(param1 is DisplayObjectContainer)
               {
                  _loc5_ = param1 as DisplayObjectContainer;
                  while(_loc5_.numChildren > 0)
                  {
                     _loc6_ = _loc5_.removeChildAt(_loc5_.numChildren - 1);
                     if(_loc6_ is MovieClip)
                     {
                        this.unloadMovieClip(MovieClip(_loc6_));
                     }
                  }
               }
            }
            catch(e:Error)
            {
            }
         }
      }

      private function unloadMovieClip(param1:MovieClip) : void
      {
         var _loc13_:DisplayObject = null;
         if(param1 == null)
         {
            return;
         }
         try
         {
            param1.stop();
            while(param1.numChildren > 0)
            {
               _loc13_ = param1.removeChildAt(param1.numChildren - 1);
               if(_loc13_ is MovieClip)
               {
                  MovieClip(_loc13_).stop();
               }
            }
            if(this.world != null)
            {
               this.world.recursiveStop(param1);
            }
         }
         catch(e:Error)
         {
         }
      }

      override public function gotoAndPlay(param1:Object, param2:String = null) : void
      {
         this.handleAnimEvent(String(param1));
         super.gotoAndPlay(param1);
      }

      public function pauseHidden() : void
      {
         if(this.mcChar != null && this.mcChar.isPlaying)
         {
            this.mcChar.stop();
            this.hidePausedFrame = this.mcChar.currentFrame;
         }
      }

      public function resumeHidden() : void
      {
         if(this.hidePausedFrame > 0)
         {
            if(this.mcChar != null && !this.mcChar.isPlaying && this.mcChar.currentFrame == this.hidePausedFrame)
            {
               this.mcChar.play();
            }
            this.hidePausedFrame = 0;
         }
      }

      public function disablePNameMouse() : void
      {
         mouseEnabled = false;
         this.pname.mouseEnabled = false;
         this.pname.mouseChildren = false;
         this.pname.removeEventListener(MouseEvent.CLICK,this.onClickHandler);
      }

      public function hasLabel(param1:String) : Boolean
      {
         var _loc13_:Array = this.mcChar.currentLabels;
         var _loc5_:int = 0;
         while(_loc5_ < _loc13_.length)
         {
            if(_loc13_[_loc5_].name == param1)
            {
               return true;
            }
            _loc5_++;
         }
         return false;
      }

      private function recursiveStop(param1:MovieClip) : void
      {
         var _loc5_:MovieClip = null;
         var _loc6_:int = 0;
         var _loc1_:DisplayObject = null;
         var _loc13_:Array = [param1];
         while(_loc13_.length > 0)
         {
            _loc5_ = _loc13_.pop();
            _loc6_ = 0;
            while(_loc6_ < _loc5_.numChildren)
            {
               _loc1_ = _loc5_.getChildAt(_loc6_);
               if(_loc1_ is MovieClip)
               {
                  MovieClip(_loc1_).stop();
                  _loc13_.push(MovieClip(_loc1_));
               }
               _loc6_++;
            }
         }
      }

      public function showHPBar() : void
      {
         this.hpBar.y = this.pname.y - 3;
         this.hpBar.visible = true;
         this.updateHPBar();
      }

      public function hideHPBar() : void
      {
         this.hpBar.visible = false;
      }

      public function updateHPBar() : void
      {
         var _loc5_:Object = null;
         var _loc12_:MovieClip = this.hpBar.g as MovieClip;
         var _loc13_:MovieClip = this.hpBar.r as MovieClip;
         if(this.hpBar.visible)
         {
            _loc5_ = this.pAV.dataLeaf;
            if(_loc5_ != null && _loc5_.intHP != null)
            {
               _loc12_.visible = true;
               _loc12_.width = Math.round(_loc5_.intHP / _loc5_.intHPMax * _loc13_.width);
               if(_loc5_.intHP < 1)
               {
                  _loc12_.visible = false;
               }
            }
         }
      }

      public function updateName() : void
      {
         var _csRoot:* = undefined;
         var uoLeaf:* = this.world.uoTree[this.pAV.pnm];
         if(uoLeaf == null)
         {
            uoLeaf = this.world.uoTree[this.pAV.pnm.toLowerCase()];
         }
         try
         {
            if(uoLeaf.afk)
            {
               this.pname.ti.text = "<AFK> " + this.pAV.objData.strUsername;
            }
            else
            {
               this.pname.ti.text = this.pAV.objData.strUsername;
            }
            if(this.pAV.objData.guild != null)
            {
               this.pname.tg.text = "< " + String(this.pAV.objData.guild.Name) + " >";
            }
            _csRoot = MovieClip(stage.getChildAt(0));
            if(_csRoot.litePreference.data.bComicSans)
            {
               _csRoot.applyComicSansPname(this.pname,true);
            }
            _csRoot.fixInputHeight(this.pname.ti);
            _csRoot.fixInputHeight(this.pname.tg);
         }
         catch(e:Error)
         {
            trace("[Avatar] ERR updateName: " + e.message);
         }
      }

      private function hideOptionalParts() : void
      {
         var _loc12_:* = ["cape","backhair","robe","backrobe","pvpFlag"];
         var _loc13_:* = ["weapon","weaponOff","weaponFist","weaponFistOff","shield"];
         var _loc5_:String = "";
         for(_loc5_ in _loc12_)
         {
            if(typeof this.mcChar[_loc12_[_loc5_]] != undefined)
            {
               this.mcChar[_loc12_[_loc5_]].visible = false;
            }
         }
         for(_loc5_ in _loc13_)
         {
            if(typeof this.mcChar[_loc13_[_loc5_]] != undefined)
            {
               this.mcChar[_loc13_[_loc5_]].visible = false;
            }
         }
      }

      private function onClickHandler(param1:MouseEvent) : void
      {
         var _loc5_:Object = null;
         var _loc6_:* = undefined;
         this.world = MovieClip(stage.getChildAt(0)).world as MovieClip;
         var _loc13_:Avatar = param1.currentTarget.parent.pAV;
         if(_loc13_ == null || _loc13_.isCharPage || _loc13_.isCameraTool || this.world == null)
         {
            return;
         }
         if(param1.shiftKey)
         {
            this.world.onWalkClick();
         }
         else if(param1.altKey)
         {
            _loc5_ = stage.getObjectsUnderPoint(new Point(param1.stageX,param1.stageY));
            for(_loc6_ in _loc5_)
            {
               if(Boolean(_loc5_[_loc6_].parent) && _loc5_[_loc6_].parent.name == "mcChar")
               {
                  this.world.setTarget(_loc5_[_loc6_].parent.parent.pAV);
                  break;
               }
            }
         }
         else if(!param1.ctrlKey)
         {
            if(Boolean(_loc13_ != this.world.myAvatar && this.world.bPvP) && Boolean(_loc13_.dataLeaf.pvpTeam != this.world.myAvatar.dataLeaf.pvpTeam) && _loc13_ == this.world.myAvatar.target)
            {
               this.world.approachTarget();
            }
            else if(_loc13_ != this.world.myAvatar.target)
            {
               this.world.setTarget(_loc13_);
            }
         }
      }

      public function loadClass(param1:String, param2:String) : void
      {
         if(this.pAV.objData.eqp.co == null)
         {
            this.classLoad = false;
            trace("[Avatar] loadClass: " + param1);
            this.world.queueLoad({
               "strFile":this.world.rootClass.getFilePath() + "classes/" + this.strGender + "/" + param1,
               "callBackA":this.onLoadClassComplete,
               "callBackB":this.classErrorHandler,
               "avt":this.pAV,
               "sES":"ar"
            });
         }
      }

      public function onLoadClassComplete(param1:Event = null) : void
      {
         trace("[Avatar] onLoadClassComplete: " + this.pAV.objData.eqp.ar.sLink);
         this.classLoad = true;
         if(this.pAV.isMyAvatar && this.pAV.FirstLoad)
         {
            this.pAV.markEquipmentLoaded("ar");
         }
         if(this.pAV.objData.eqp.co == null)
         {
            this.loadArmorPieces(this.pAV.objData.eqp.ar.sLink);
         }
      }

      public function loadMisc(param1:String, param2:String) : void
      {
         this.miscLoad = false;
         this.objLinks.mi = param2;
         this.world.queueLoad({
            "strFile":this.world.rootClass.getFilePath() + param1,
            "callBackA":this.onLoadMiscComplete,
            "callBackB":this.miscErrorHandler,
            "avt":this.pAV,
            "sES":"ac"
         });
      }

      public function onLoadMiscComplete(param1:Event) : void
      {
         this.rasterPoke();
         this.miscLoad = true;
         if(this.pAV.isMyAvatar && this.pAV.FirstLoad)
         {
            this.pAV.markEquipmentLoaded("mi");
         }
         var _loc13_:Class = this.world.getClass(this.objLinks.mi) as Class;
         if(_loc13_ != null)
         {
            this.cShadow.visible = true;
            this.cShadow.removeChildAt(0);
            this.cShadow.addChild(new _loc13_());
            this.cShadow.scaleX = this.mcChar.scaleX;
            this.cShadow.scaleY = this.mcChar.scaleY;
            this.cShadow.mouseEnabled = this.cShadow.mouseChildren = false;
            this.shadow.alpha = 0;
         }
         else
         {
            this.cShadow.visible = false;
            this.shadow.alpha = 1;
         }
         if(this.world.rootClass.litePreference.data.bDisGround)
         {
            if(this.pAV.isMyAvatar && Boolean(this.world.rootClass.litePreference.data.dOptions["groundSelf"]))
            {
               return;
            }
            this.cShadow.visible = false;
            this.shadow.alpha = 1;
         }
         if(Boolean(this.world.rootClass.litePreference.data.bHidePlayers) && !this.pAV.isMyAvatar)
         {
            this.cShadow.visible = false;
         }
      }

      public function loadArmor(param1:String, param2:String) : void
      {
         this.objLinks.co = param2;
         this.armorLoad = false;
         this.world.queueLoad({
            "strFile":this.world.rootClass.getFilePath() + "classes/" + this.strGender + "/" + param1,
            "callBackA":this.onLoadArmorComplete,
            "callBackB":this.armorErrorHandler,
            "avt":this.pAV,
            "sES":"ar"
         });
      }

      public function onLoadArmorComplete(param1:Event) : void
      {
         this.armorLoad = true;
         if(this.pAV.isMyAvatar && this.pAV.FirstLoad)
         {
            this.pAV.markEquipmentLoaded("co");
         }
         this.clearAnimEvents();
         this.loadArmorPieces(this.objLinks.co);
         if(this.name.indexOf("previewMCB") > -1)
         {
            MovieClip(parent.parent).repositionPreview(MovieClip(this.mcChar));
         }
      }

      public function ioErrorHandler(param1:*) : void
      {
         trace("[Avatar] ERR ioErrorHandler: " + param1);
         if(this.pAV.isMyAvatar && this.pAV.FirstLoad)
         {
            this.pAV.markAnyEquipmentLoaded();
         }
      }

      private function markSlotFailed(param1:String) : void
      {
         if(this.pAV.isMyAvatar && this.pAV.FirstLoad)
         {
            this.pAV.markEquipmentLoaded(param1);
         }
      }

      public function classErrorHandler(param1:*) : void
      {
         this.classLoad = true;
         this.markSlotFailed("ar");
      }

      public function miscErrorHandler(param1:*) : void
      {
         this.miscLoad = true;
         this.markSlotFailed("mi");
      }

      public function armorErrorHandler(param1:*) : void
      {
         this.armorLoad = true;
         this.markSlotFailed("co");
      }

      public function hairErrorHandler(param1:*) : void
      {
         this.hairLoad = true;
         this.markSlotFailed("Hair");
      }

      public function weaponErrorHandler(param1:*) : void
      {
         this.weaponLoad = true;
         this.markSlotFailed("Weapon");
      }

      public function weaponOffErrorHandler(param1:*) : void
      {
         this.weaponLoad = true;
         this.markSlotFailed("WeaponOff");
         this.markSlotFailed("Weapon");
      }

      public function capeErrorHandler(param1:*) : void
      {
         this.capeLoad = true;
         this.markSlotFailed("ba");
      }

      public function helmErrorHandler(param1:*) : void
      {
         this.helmLoad = true;
         this.bLoadingHelm = false;
         this.markSlotFailed("he");
      }

      public function loadArmorPieces(param1:String) : void
      {
         var _loc13_:Class = null;
         var _loc5_:DisplayObject = null;
         var _loc6_:Color = null;
         trace("[Avatar] loadArmorPieces: " + param1);
         try
         {
            _loc13_ = this.world.getClass(param1 + this.strGender + "Head") as Class;
            if(_loc13_ == null)
            {
               _loc13_ = this.world.getClass("mcHead" + this.strGender) as Class;
            }
            if(_loc13_ != null)
            {
               _loc5_ = this.mcChar.head.getChildByName("face");
               if(_loc5_ != null)
               {
                  this.mcChar.head.removeChild(_loc5_);
               }
               this.testMC = this.mcChar.head.addChildAt(new _loc13_(),0);
               this.testMC.name = "face";
            }
         }
         catch(err:Error)
         {
         }
         if(this.pAV == this.world.myAvatar)
         {
            this.world.rootClass.showPortrait(this.pAV);
         }
         else if(this.pAV == this.world.myAvatar.target)
         {
            this.world.rootClass.showPortraitTarget(this.pAV);
         }
         try
         {
            _loc13_ = this.world.getClass(param1 + this.strGender + "Chest") as Class;
            if(_loc13_ != null)
            {
               this.mcChar.chest.removeChildAt(0);
               this.mcChar.chest.addChild(new _loc13_());
            }
         }
         catch(e:Error)
         {
         }
         try
         {
            _loc13_ = this.world.getClass(param1 + this.strGender + "Hip") as Class;
            if(_loc13_ != null)
            {
               this.mcChar.hip.removeChildAt(0);
               this.mcChar.hip.addChild(new _loc13_());
            }
         }
         catch(e:Error)
         {
         }
         try
         {
            _loc13_ = this.world.getClass(param1 + this.strGender + "FootIdle") as Class;
            if(_loc13_ != null)
            {
               this.mcChar.idlefoot.removeChildAt(0);
               this.mcChar.idlefoot.addChild(new _loc13_());
            }
         }
         catch(e:Error)
         {
         }
         try
         {
            _loc13_ = this.world.getClass(param1 + this.strGender + "Foot") as Class;
            if(_loc13_ != null)
            {
               this.mcChar.frontfoot.removeChildAt(0);
               this.mcChar.frontfoot.addChild(new _loc13_());
               this.mcChar.frontfoot.visible = false;
               this.mcChar.backfoot.removeChildAt(0);
               this.mcChar.backfoot.addChild(new _loc13_());
            }
         }
         catch(e:Error)
         {
         }
         try
         {
            _loc13_ = this.world.getClass(param1 + this.strGender + "Shoulder") as Class;
            if(_loc13_ != null)
            {
               this.mcChar.frontshoulder.removeChildAt(0);
               this.mcChar.frontshoulder.addChild(new _loc13_());
               this.mcChar.backshoulder.removeChildAt(0);
               this.mcChar.backshoulder.addChild(new _loc13_());
            }
         }
         catch(e:Error)
         {
         }
         try
         {
            _loc13_ = this.world.getClass(param1 + this.strGender + "Hand") as Class;
            if(_loc13_ != null)
            {
               this.mcChar.fronthand.removeChildAt(0);
               this.mcChar.fronthand.addChildAt(new _loc13_(),0);
               this.mcChar.backhand.removeChildAt(0);
               this.mcChar.backhand.addChildAt(new _loc13_(),0);
               _loc6_ = new Color();
               _loc6_.brightness = -1;
               this.mcChar.backhand.getChildAt(0).transform.colorTransform = _loc6_;
            }
         }
         catch(e:Error)
         {
         }
         try
         {
            _loc13_ = this.world.getClass(param1 + this.strGender + "Thigh") as Class;
            if(_loc13_ != null)
            {
               this.mcChar.frontthigh.removeChildAt(0);
               this.mcChar.frontthigh.addChild(new _loc13_());
               this.mcChar.backthigh.removeChildAt(0);
               this.mcChar.backthigh.addChild(new _loc13_());
            }
         }
         catch(e:Error)
         {
         }
         try
         {
            _loc13_ = this.world.getClass(param1 + this.strGender + "Shin") as Class;
            if(_loc13_ != null)
            {
               this.mcChar.frontshin.removeChildAt(0);
               this.mcChar.frontshin.addChild(new _loc13_());
               this.mcChar.backshin.removeChildAt(0);
               this.mcChar.backshin.addChild(new _loc13_());
            }
         }
         catch(e:Error)
         {
         }
         _loc13_ = this.world.getClass(param1 + this.strGender + "Robe") as Class;
         if(_loc13_ != null)
         {
            this.mcChar.robe.removeChildAt(0);
            this.mcChar.robe.addChild(new _loc13_());
            this.mcChar.robe.visible = true;
         }
         else
         {
            this.mcChar.robe.visible = false;
         }
         _loc13_ = this.world.getClass(param1 + this.strGender + "RobeBack") as Class;
         if(_loc13_ != null)
         {
            this.mcChar.backrobe.removeChildAt(0);
            this.mcChar.backrobe.addChild(new _loc13_());
            this.mcChar.backrobe.visible = true;
         }
         else
         {
            this.mcChar.backrobe.visible = false;
         }
         if(this.pAV.isMyAvatar && this.pAV.FirstLoad)
         {
            this.gotoAndPlay("hold");
         }
         else if(!this.isLoaded)
         {
            this.isLoaded = true;
            if(this.pAV.isCharPage || this.pAV.dataLeaf != null && this.pAV.dataLeaf.strFrame == this.world.strFrame)
            {
               this.gotoAndPlay("in1");
               this.handleAfterAvatarLoad();
            }
         }
      }

      public function rasterizeChar() : void
      {
         if(this.pAV == null || this.pAV.isCameraTool || this.pAV.isCharPage || this.pAV.isMyAvatar)
         {
            return;
         }
         if(this.isRasterized || !this.isLoaded || this.mcChar == null || this.world == null)
         {
            return;
         }
         if(!this.world.rootClass.litePreference.data.bCachePlayers)
         {
            return;
         }
         this.rasterWait = 8;
         if(!this.rasterArmed)
         {
            this.rasterArmed = true;
            this.addEventListener(Event.ENTER_FRAME,this.rasterTick,false,0,true);
         }
      }

      public function rasterPoke() : void
      {
         if(this.isRasterized)
         {
            this.derasterizeChar();
         }
         this.rasterizeChar();
      }

      private function rasterTick(param1:Event) : void
      {
         if(this.stage == null || this.pAV == null || this.pAV.isMyAvatar || this.mcChar == null || this.world == null || this.isRasterized || !this.world.rootClass.litePreference.data.bCachePlayers)
         {
            this.rasterArmed = false;
            this.removeEventListener(Event.ENTER_FRAME,this.rasterTick);
            return;
         }
         --this.rasterWait;
         if(this.rasterWait > 0)
         {
            return;
         }
         this.rasterArmed = false;
         this.removeEventListener(Event.ENTER_FRAME,this.rasterTick);
         try
         {
            this.scanColor(this,this.pAV.objData);
         }
         catch(eSC:Error)
         {
         }
         this.mcChar.gotoAndStop("Idle");
         this.world.rootClass.rasterize(this.mcChar);
         try
         {
            if(this.cShadow != null && this.cShadow.visible)
            {
               this.world.rootClass.rasterize(this.cShadow);
            }
         }
         catch(eCS:Error)
         {
         }
         this.isRasterized = true;
      }

      public function derasterizeChar() : void
      {
         if(!this.isRasterized)
         {
            return;
         }
         this.isRasterized = false;
         if(this.mcChar == null || this.world == null)
         {
            return;
         }
         try
         {
            this.world.rootClass.derasterize(this.mcChar);
         }
         catch(eDR:Error)
         {
         }
         try
         {
            if(this.cShadow != null)
            {
               this.world.rootClass.derasterize(this.cShadow);
            }
         }
         catch(eDS:Error)
         {
         }
      }

      public function handleAfterAvatarLoad() : void
      {
         if(this.pAV.isCameraTool || this.pAV.isCharPage)
         {
            return;
         }
         this.rasterizeChar();
         if(this.world.rootClass.litePreference.data.bHideNames)
         {
            this.hideNameSetup();
         }
         if(Boolean(this.world.rootClass.litePreference.data.bHidePlayers) && !this.pAV.isMyAvatar)
         {
            this.mcChar.visible = false;
            this.cShadow.visible = false;
            this.pname.visible = this.world.rootClass.litePreference.data.dOptions["showNames"];
            this.shadow.visible = this.world.rootClass.litePreference.data.dOptions["showShadows"];
         }
      }

      public function hideNameSetup() : void
      {
         if(this.world.rootClass.litePreference.data.dOptions["hideSelf"])
         {
            if(this.pAV.isMyAvatar)
            {
               this.pname.visible = false;
            }
            else
            {
               this.hideNameCleanup();
            }
            return;
         }
         this.pname.ti.visible = this.world.rootClass.litePreference.data.dOptions["hideGuild"];
         this.pname.tg.visible = false;
         if(!this.mcChar.hasEventListener(MouseEvent.ROLL_OVER))
         {
            this.mcChar.addEventListener(MouseEvent.ROLL_OVER,this.onNameHover,false,0,true);
            this.mcChar.addEventListener(MouseEvent.ROLL_OUT,this.onNameOut,false,0,true);
         }
      }

      public function hideNameCleanup() : void
      {
         if(this.mcChar != null && this.mcChar.hasEventListener(MouseEvent.ROLL_OVER))
         {
            this.mcChar.removeEventListener(MouseEvent.ROLL_OVER,this.onNameHover);
            this.mcChar.removeEventListener(MouseEvent.ROLL_OUT,this.onNameOut);
         }
         if(this.pname != null)
         {
            this.pname.visible = true;
            this.pname.ti.visible = true;
            this.pname.tg.visible = this.pname.tg.text;
         }
      }

      public function onNameHover(param1:MouseEvent) : void
      {
         if(this.world.rootClass.litePreference.data.dOptions["hideGuild"])
         {
            this.pname.tg.visible = true;
         }
         else
         {
            this.pname.ti.visible = true;
            this.pname.tg.visible = true;
         }
      }

      public function onNameOut(param1:MouseEvent) : void
      {
         if(this.world.rootClass.litePreference.data.dOptions["hideGuild"])
         {
            this.pname.tg.visible = false;
         }
         else
         {
            this.pname.ti.visible = false;
            this.pname.tg.visible = false;
         }
      }

      public function loadArmorPiecesFromDomain(param1:String, param2:ApplicationDomain) : void
      {
         var AssetClass:Class = null;
         var child:DisplayObject = null;
         var drk:Color = null;
         var strSkinLinkage:String = param1;
         var pLoaderD:ApplicationDomain = param2;
         trace("[Avatar] loadArmorPiecesFromDomain: " + strSkinLinkage);
         try
         {
            AssetClass = pLoaderD.getDefinition(strSkinLinkage + this.strGender + "Head") as Class;
            child = this.mcChar.head.getChildByName("face");
            if(child != null)
            {
               this.mcChar.head.removeChild(child);
            }
            this.testMC = this.mcChar.head.addChildAt(new AssetClass(),0);
            this.testMC.name = "face";
         }
         catch(err:Error)
         {
            try
            {
               AssetClass = pLoaderD.getDefinition("mcHead" + strGender) as Class;
               child = mcChar.head.getChildByName("face");
               if(child != null)
               {
                  mcChar.head.removeChild(child);
               }
               testMC = mcChar.head.addChildAt(new AssetClass(),0);
               testMC.name = "face";
            }
            catch(e2:Error)
            {
            }
         }
         try
         {
            AssetClass = pLoaderD.getDefinition(strSkinLinkage + this.strGender + "Chest") as Class;
            this.mcChar.chest.removeChildAt(0);
            this.mcChar.chest.addChild(new AssetClass());
         }
         catch(e:Error)
         {
         }
         try
         {
            AssetClass = pLoaderD.getDefinition(strSkinLinkage + this.strGender + "Hip") as Class;
            this.mcChar.hip.removeChildAt(0);
            this.mcChar.hip.addChild(new AssetClass());
         }
         catch(e:Error)
         {
         }
         try
         {
            AssetClass = pLoaderD.getDefinition(strSkinLinkage + this.strGender + "FootIdle") as Class;
            this.mcChar.idlefoot.removeChildAt(0);
            this.mcChar.idlefoot.addChild(new AssetClass());
         }
         catch(e:Error)
         {
         }
         try
         {
            AssetClass = pLoaderD.getDefinition(strSkinLinkage + this.strGender + "Foot") as Class;
            this.mcChar.frontfoot.removeChildAt(0);
            this.mcChar.frontfoot.addChild(new AssetClass());
            this.mcChar.frontfoot.visible = false;
            this.mcChar.backfoot.removeChildAt(0);
            this.mcChar.backfoot.addChild(new AssetClass());
         }
         catch(e:Error)
         {
         }
         try
         {
            AssetClass = pLoaderD.getDefinition(strSkinLinkage + this.strGender + "Shoulder") as Class;
            this.mcChar.frontshoulder.removeChildAt(0);
            this.mcChar.frontshoulder.addChild(new AssetClass());
            this.mcChar.backshoulder.removeChildAt(0);
            this.mcChar.backshoulder.addChild(new AssetClass());
         }
         catch(e:Error)
         {
         }
         try
         {
            AssetClass = pLoaderD.getDefinition(strSkinLinkage + this.strGender + "Hand") as Class;
            this.mcChar.fronthand.removeChildAt(0);
            this.mcChar.fronthand.addChildAt(new AssetClass(),0);
            this.mcChar.backhand.removeChildAt(0);
            this.mcChar.backhand.addChildAt(new AssetClass(),0);
            drk = new Color();
            drk.brightness = -1;
            this.mcChar.backhand.getChildAt(0).transform.colorTransform = drk;
         }
         catch(e:Error)
         {
         }
         try
         {
            AssetClass = pLoaderD.getDefinition(strSkinLinkage + this.strGender + "Thigh") as Class;
            this.mcChar.frontthigh.removeChildAt(0);
            this.mcChar.frontthigh.addChild(new AssetClass());
            this.mcChar.backthigh.removeChildAt(0);
            this.mcChar.backthigh.addChild(new AssetClass());
         }
         catch(e:Error)
         {
         }
         try
         {
            AssetClass = pLoaderD.getDefinition(strSkinLinkage + this.strGender + "Shin") as Class;
            this.mcChar.frontshin.removeChildAt(0);
            this.mcChar.frontshin.addChild(new AssetClass());
            this.mcChar.backshin.removeChildAt(0);
            this.mcChar.backshin.addChild(new AssetClass());
         }
         catch(e:Error)
         {
         }
         try
         {
            AssetClass = pLoaderD.getDefinition(strSkinLinkage + this.strGender + "Robe") as Class;
            if(AssetClass != null)
            {
               this.mcChar.robe.removeChildAt(0);
               this.mcChar.robe.addChild(new AssetClass());
               this.mcChar.robe.visible = true;
            }
            else
            {
               this.mcChar.robe.visible = false;
            }
         }
         catch(e:Error)
         {
            mcChar.robe.visible = false;
         }
         try
         {
            AssetClass = pLoaderD.getDefinition(strSkinLinkage + this.strGender + "RobeBack") as Class;
            if(AssetClass != null)
            {
               this.mcChar.backrobe.removeChildAt(0);
               this.mcChar.backrobe.addChild(new AssetClass());
               this.mcChar.backrobe.visible = true;
            }
            else
            {
               this.mcChar.backrobe.visible = false;
            }
         }
         catch(e:Error)
         {
            mcChar.backrobe.visible = false;
         }
         if(this.pAV.isMyAvatar && this.pAV.FirstLoad)
         {
            this.gotoAndPlay("hold");
         }
         else if(!this.isLoaded)
         {
            this.isLoaded = true;
            if(this.pAV.isCharPage || this.pAV.dataLeaf != null && this.pAV.dataLeaf.strFrame == this.world.strFrame)
            {
               this.gotoAndPlay("in1");
               this.handleAfterAvatarLoad();
            }
         }
      }

      public function loadHair() : void
      {
         var _loc12_:* = this.pAV.objData.strHairFilename;
         if(_loc12_ == undefined || _loc12_ == null || _loc12_ == "" || _loc12_ == "none")
         {
            this.mcChar.head.hair.visible = false;
            if(this.pAV.isMyAvatar && this.pAV.FirstLoad)
            {
               this.pAV.markEquipmentLoaded("Hair");
            }
            return;
         }
         this.hairLoad = false;
         this.world.queueLoad({
            "strFile":this.world.rootClass.getFilePath() + _loc12_,
            "callBackA":this.onHairLoadComplete,
            "callBackB":this.hairErrorHandler,
            "avt":this.pAV,
            "sES":"hair"
         });
      }

      public function onHairLoadComplete(param1:Event) : void
      {
         var AssetClass:Class = null;
         var e:Event = param1;
         this.rasterPoke();
         this.hairLoad = true;
         if(this.pAV.isMyAvatar && this.pAV.FirstLoad)
         {
            this.pAV.markEquipmentLoaded("Hair");
         }
         try
         {
            AssetClass = this.world.getClass(this.pAV.objData.strHairName + this.pAV.objData.strGender + "Hair") as Class;
            if(AssetClass != null)
            {
               if(this.mcChar.head.hair.numChildren > 0)
               {
                  this.mcChar.head.hair.removeChildAt(0);
               }
               this.mcChar.head.hair.addChild(new AssetClass());
               this.mcChar.head.hair.visible = true;
            }
            else
            {
               this.mcChar.head.hair.visible = false;
            }
            AssetClass = this.world.getClass(this.pAV.objData.strHairName + this.pAV.objData.strGender + "HairBack") as Class;
            if(AssetClass != null)
            {
               if(!this.helmBackHair || this.helmBackHair && !this.pAV.dataLeaf.showHelm)
               {
                  if(this.mcChar.backhair.numChildren > 0)
                  {
                     this.mcChar.backhair.removeChildAt(0);
                  }
                  this.mcChar.backhair.addChild(new AssetClass());
                  this.mcChar.backhair.visible = true;
               }
               this.bBackHair = true;
            }
            else
            {
               this.mcChar.backhair.visible = false;
               this.bBackHair = false;
            }
            if(this.pAV.isMyAvatar && !MovieClip(parent.parent.parent).ui.mcPortrait.visible && !this.bLoadingHelm)
            {
               this.world.rootClass.showPortrait(this.pAV);
            }
            else if(this.pAV == this.world.myAvatar.target)
            {
               this.world.rootClass.showPortraitTarget(this.pAV);
            }
            if("he" in this.pAV.objData.eqp && this.pAV.objData.eqp.he != null)
            {
               if(this.pAV.dataLeaf.showHelm)
               {
                  this.mcChar.head.hair.visible = false;
                  this.mcChar.backhair.visible = this.helmBackHair;
               }
               else
               {
                  this.mcChar.head.hair.visible = true;
                  this.mcChar.backhair.visible = this.bBackHair;
               }
            }
         }
         catch(e:Error)
         {
            trace("[Avatar] ERR onHairLoadComplete: " + pAV.objData.strUsername + " " + e.message);
         }
      }

      private function requeueRawWeapon(param1:String, param2:Function, param3:Function) : Boolean
      {
         if(this.rawWepRetries >= 2 || param1 == null)
         {
            return false;
         }
         ++this.rawWepRetries;
         this.weaponLoad = false;
         var _loc6_:String = this.world.rootClass.getFilePath() + param1;
         _loc6_ += (_loc6_.indexOf("?") < 0 ? "?r=" : "&r=") + uint(Math.random() * 16777215);
         this.world.queueLoad({
            "strFile":_loc6_,
            "callBackA":param2,
            "callBackB":param3,
            "avt":this.pAV,
            "sES":"weapon"
         });
         return true;
      }

      private function recursivePlay(param1:MovieClip) : void
      {
         var _loc5_:MovieClip = null;
         param1.play();
         var _loc13_:int = 0;
         while(_loc13_ < param1.numChildren)
         {
            _loc5_ = param1.getChildAt(_loc13_) as MovieClip;
            if(_loc5_ != null)
            {
               this.recursivePlay(_loc5_);
            }
            _loc13_++;
         }
      }

      public function loadWeapon(param1:*, param2:*) : void
      {
         this.weaponLoad = false;
         this.rawWepRetries = 0;
         this.world.queueLoad({
            "strFile":this.world.rootClass.getFilePath() + param1,
            "callBackA":this.onLoadWeaponComplete,
            "callBackB":this.weaponErrorHandler,
            "avt":this.pAV,
            "sES":"weapon"
         });
      }

      public function onLoadWeaponComplete(param1:Event) : void
      {
         var isDualWield:Boolean;
         var wItem:Object = null;
         var AssetClass:Class = null;
         var raw:MovieClip = null;
         var wEqp:Object = null;
         var e:Event = param1;
         this.rasterPoke();
         this.weaponLoad = true;
         wItem = this.pAV.getItemByEquipSlot("Weapon");
         if(this.mcChar.weaponFist.numChildren > 0)
         {
            this.mcChar.weaponFist.removeChildAt(0);
         }
         if(this.mcChar.weaponFistOff.numChildren > 0)
         {
            this.mcChar.weaponFistOff.removeChildAt(0);
         }
         if(this.mcChar.weapon.numChildren > 0)
         {
            this.mcChar.weapon.removeChildAt(0);
         }
         if(this.mcChar.fronthand.numChildren > 1)
         {
            this.mcChar.fronthand.removeChildAt(1);
         }
         if(this.mcChar.backhand.numChildren > 1)
         {
            this.mcChar.backhand.removeChildAt(1);
         }
         try
         {
            AssetClass = this.world.getClass(this.pAV.objData.eqp.Weapon.sLink) as Class;
            if(wItem != null && wItem.sType == "Gauntlet")
            {
               this.mcChar.fronthand.addChildAt(new AssetClass(),1);
               this.mcChar.fronthand.getChildAt(1).scaleX = 0.8;
               this.mcChar.fronthand.getChildAt(1).scaleY = 0.8;
               this.mcChar.fronthand.getChildAt(1).scaleX = this.mcChar.fronthand.getChildAt(1).scaleX * -1;
               this.mcChar.backhand.addChildAt(new AssetClass(),1);
               this.mcChar.backhand.getChildAt(1).scaleX = 0.8;
               this.mcChar.backhand.getChildAt(1).scaleY = 0.8;
               this.mcChar.backhand.getChildAt(1).scaleX = this.mcChar.backhand.getChildAt(1).scaleX * -1;
               this.mcChar.weapon.mcWeapon = new MovieClip();
            }
            else
            {
               this.mcChar.weapon.mcWeapon = new AssetClass();
               this.mcChar.weapon.addChild(this.mcChar.weapon.mcWeapon);
            }
         }
         catch(err:Error)
         {
            trace("[Avatar] ERR onLoadWeaponComplete: linkage miss, added raw content");
            if(wItem == null || wItem.sType != "Gauntlet")
            {
               raw = null;
               try
               {
                  raw = MovieClip(e.target.content);
               }
               catch(errRaw:Error)
               {
               }
               if(raw != null && raw.parent != null && !(raw.parent is Loader))
               {
                  wEqp = null;
                  try
                  {
                     wEqp = pAV.objData.eqp.Weapon;
                  }
                  catch(eEqp:Error)
                  {
                  }
                  if(wEqp != null && requeueRawWeapon(wEqp.sFile,onLoadWeaponComplete,weaponErrorHandler))
                  {
                     if(pAV.isMyAvatar && pAV.FirstLoad)
                     {
                        pAV.markEquipmentLoaded("Weapon");
                     }
                     return;
                  }
                  raw = null;
               }
               if(raw != null)
               {
                  try
                  {
                     recursivePlay(raw);
                     mcChar.weapon.mcWeapon = raw;
                     mcChar.weapon.addChild(raw);
                  }
                  catch(errAdd:Error)
                  {
                  }
               }
            }
         }
         this.mcChar.weapon.visible = false;
         this.mcChar.weaponOff.visible = false;
         this.mcChar.weaponFist.visible = false;
         this.mcChar.weaponFistOff.visible = false;
         if(wItem == null || wItem.sType != "Gauntlet")
         {
            this.mcChar.weapon.visible = true;
         }
         isDualWield = wItem != null && wItem.sType == "Dagger";
         if(isDualWield)
         {
            if(this.pAV.isMyAvatar && this.pAV.FirstLoad)
            {
               this.pAV.registerPendingEquipment("WeaponOff");
            }
            this.loadWeaponOff(this.pAV.objData.eqp.Weapon.sFile,this.pAV.objData.eqp.Weapon.sLink);
         }
         if(!isDualWield && this.pAV.isMyAvatar && this.pAV.FirstLoad)
         {
            this.pAV.markEquipmentLoaded("Weapon");
         }
         if(Boolean(this.world.rootClass.litePreference.data.bDisWepAnim && wItem != null) && Boolean(wItem.ItemID != 4711) && wItem.ItemID != 31273)
         {
            if(Boolean(!this.pAV.isMyAvatar) && Boolean(this.world.rootClass.litePreference.data.dOptions["wepSelf"]) || !this.world.rootClass.litePreference.data.dOptions["wepSelf"])
            {
               this.world.rootClass.movieClipStopAll(this.mcChar.weapon);
            }
         }
      }

      public function loadWeaponOff(param1:*, param2:*) : void
      {
         this.weaponLoad = false;
         this.world.queueLoad({
            "strFile":this.world.rootClass.getFilePath() + param1,
            "callBackA":this.onLoadWeaponOffComplete,
            "callBackB":this.weaponOffErrorHandler,
            "avt":this.pAV,
            "sES":"weapon"
         });
      }

      public function onLoadWeaponOffComplete(param1:Event) : void
      {
         var wItem:Object;
         var AssetClass:Class = null;
         var rawOff:MovieClip = null;
         var wEqpOff:Object = null;
         var e:Event = param1;
         this.rasterPoke();
         this.weaponLoad = true;
         if(this.pAV.isMyAvatar && this.pAV.FirstLoad)
         {
            this.pAV.markEquipmentLoaded("WeaponOff");
            this.pAV.markEquipmentLoaded("Weapon");
         }
         wItem = this.pAV.getItemByEquipSlot("Weapon");
         if(this.mcChar.weaponOff.numChildren > 0)
         {
            this.mcChar.weaponOff.removeChildAt(0);
         }
         try
         {
            AssetClass = this.world.getClass(this.pAV.objData.eqp.Weapon.sLink) as Class;
            this.mcChar.weaponOff.addChild(new AssetClass());
         }
         catch(err:Error)
         {
            trace("[Avatar] ERR onLoadWeaponOffComplete: linkage miss, added raw content");
            rawOff = null;
            try
            {
               rawOff = MovieClip(e.target.content);
            }
            catch(errRaw:Error)
            {
            }
            if(rawOff != null && rawOff.parent != null && !(rawOff.parent is Loader))
            {
               wEqpOff = null;
               try
               {
                  wEqpOff = pAV.objData.eqp.Weapon;
               }
               catch(eEqp2:Error)
               {
               }
               if(wEqpOff != null && requeueRawWeapon(wEqpOff.sFile,onLoadWeaponOffComplete,weaponOffErrorHandler))
               {
                  return;
               }
               rawOff = null;
            }
            if(rawOff != null)
            {
               try
               {
                  recursivePlay(rawOff);
                  mcChar.weaponOff.addChild(rawOff);
               }
               catch(errAdd2:Error)
               {
               }
            }
         }
         this.mcChar.weaponOff.visible = true;
         if(this.world.rootClass.litePreference.data.bDisWepAnim)
         {
            if(Boolean(!this.pAV.isMyAvatar) && Boolean(this.world.rootClass.litePreference.data.dOptions["wepSelf"]) || !this.world.rootClass.litePreference.data.dOptions["wepSelf"])
            {
               this.world.rootClass.movieClipStopAll(this.mcChar.weaponOff);
            }
         }
      }

      public function loadCape(param1:*, param2:*) : void
      {
         this.capeLoad = false;
         this.world.queueLoad({
            "strFile":this.world.rootClass.getFilePath() + param1,
            "callBackA":this.onLoadCapeComplete,
            "callBackB":this.capeErrorHandler,
            "avt":this.pAV,
            "sES":"cape"
         });
      }

      public function onLoadCapeComplete(param1:Event) : void
      {
         var AssetClass:Class = null;
         var e:Event = param1;
         this.rasterPoke();
         this.capeLoad = true;
         if(this.pAV.isMyAvatar && this.pAV.FirstLoad)
         {
            this.pAV.markEquipmentLoaded("ba");
         }
         try
         {
            AssetClass = this.world.getClass(this.pAV.objData.eqp.ba.sLink) as Class;
            this.mcChar.cape.removeChildAt(0);
            this.mcChar.cape.cape = new AssetClass();
            this.mcChar.cape.addChild(this.mcChar.cape.cape);
            this.setCloakVisibility(this.pAV.dataLeaf.showCloak);
         }
         catch(e:*)
         {
            trace("[Avatar] ERR onLoadCapeComplete: " + e.message);
         }
      }

      public function loadHelm(param1:*, param2:*) : void
      {
         this.helmLoad = false;
         this.world.queueLoad({
            "strFile":this.world.rootClass.getFilePath() + param1,
            "callBackA":this.onLoadHelmComplete,
            "callBackB":this.helmErrorHandler,
            "avt":this.pAV,
            "sES":"helm"
         });
         this.bLoadingHelm = true;
      }

      public function onLoadHelmComplete(param1:Event) : void
      {
         this.rasterPoke();
         this.helmLoad = true;
         if(this.pAV.isMyAvatar && this.pAV.FirstLoad)
         {
            this.pAV.markEquipmentLoaded("he");
         }
         var _loc13_:Class = this.world.getClass(this.pAV.objData.eqp.he.sLink) as Class;
         var _loc5_:Class = this.world.getClass(this.pAV.objData.eqp.he.sLink + "_backhair") as Class;
         if(_loc13_ != null)
         {
            if(this.mcChar.head.helm.numChildren > 0)
            {
               this.mcChar.head.helm.removeChildAt(0);
            }
            this.mcChar.head.helm.visible = this.pAV.dataLeaf.showHelm;
            this.mcChar.head.hair.visible = !this.mcChar.head.helm.visible;
            this.mcChar.backhair.visible = Boolean(this.mcChar.head.hair.visible) && this.bBackHair;
            if(_loc5_ != null)
            {
               if(this.pAV.dataLeaf.showHelm)
               {
                  if(this.mcChar.backhair.numChildren > 0)
                  {
                     this.mcChar.backhair.removeChildAt(0);
                  }
                  this.mcChar.backhair.visible = true;
                  this.mcChar.backhair.addChild(new _loc5_());
               }
               this.helmBackHair = true;
            }
            else
            {
               this.helmBackHair = false;
            }
            this.mcChar.head.helm.addChild(new _loc13_());
            if(this.pAV == this.world.myAvatar)
            {
               this.world.rootClass.showPortrait(this.pAV);
            }
            if(this.pAV == this.world.myAvatar.target)
            {
               this.world.rootClass.showPortraitTarget(this.pAV);
            }
         }
         this.bLoadingHelm = false;
      }

      public function setHelmVisibility(param1:Boolean) : void
      {
         if(this.pAV.objData.eqp.he != null && this.pAV.objData.eqp.he.sLink != null)
         {
            if(param1)
            {
               if(this.helmBackHair && this.bBackHair)
               {
                  this.pAV.loadMovieAtES("he",this.pAV.objData.eqp["he"].sFile,this.pAV.objData.eqp["he"].sLink);
                  return;
               }
               this.mcChar.head.helm.visible = true;
               this.mcChar.head.hair.visible = false;
               this.mcChar.backhair.visible = this.helmBackHair;
            }
            else
            {
               if(this.helmBackHair && this.bBackHair)
               {
                  this.loadHair();
                  return;
               }
               this.mcChar.head.helm.visible = false;
               this.mcChar.head.hair.visible = true;
               this.mcChar.backhair.visible = this.bBackHair;
            }
            if(this.pAV == this.world.myAvatar)
            {
               this.world.rootClass.showPortrait(this.pAV);
            }
            if(this.pAV == this.world.myAvatar.target)
            {
               this.world.rootClass.showPortraitTarget(this.pAV);
            }
         }
      }

      public function setCloakVisibility(param1:Boolean) : void
      {
         if(this.pAV.objData.eqp.ba != null && this.pAV.objData.eqp.ba.sLink != null)
         {
            if(this.pAV.isMyAvatar)
            {
               this.mcChar.cape.visible = param1;
            }
            else if(this.pAV.isCharPage)
            {
               this.mcChar.cape.visible = param1;
            }
            else
            {
               this.mcChar.cape.visible = param1 && !this.world.hideAllCapes;
            }
         }
      }

      public function setColor(param1:MovieClip, param2:String, param3:String, param4:String) : void
      {
         var _loc1_:Number = Number(this.pAV.objData["intColor" + param3]);
         if(param1.isColored === true && param1.intColor === _loc1_ && param1.strShade === param4 && param1.strLocation === param3)
         {
            return;
         }
         param1.isColored = true;
         param1.intColor = _loc1_;
         param1.strLocation = param3;
         param1.strShade = param4;
         this.changeColor(param1,_loc1_,param4);
      }

      public function changeColor(param1:MovieClip, param2:Number, param3:String, param4:String = "") : void
      {
         var _loc1_:ColorTransform = new ColorTransform();
         if(param4 == "")
         {
            _loc1_.color = param2;
         }
         switch(param3.toUpperCase())
         {
            case "LIGHT":
               _loc1_.redOffset += 100;
               _loc1_.greenOffset += 100;
               _loc1_.blueOffset += 100;
               break;
            case "DARK":
               _loc1_.redOffset -= param1.strLocation == "Skin" ? 25 : 50;
               _loc1_.greenOffset -= 50;
               _loc1_.blueOffset -= 50;
               break;
            case "DARKER":
               _loc1_.redOffset -= 125;
               _loc1_.greenOffset -= 125;
               _loc1_.blueOffset -= 125;
         }
         if(param4 == "-")
         {
            _loc1_.redOffset *= -1;
            _loc1_.greenOffset *= -1;
            _loc1_.blueOffset *= -1;
         }
         var _loc2_:ColorTransform = param1.transform.colorTransform;
         if(param4 == "" || _loc2_.redOffset != _loc1_.redOffset || _loc2_.greenOffset != _loc1_.greenOffset || _loc2_.blueOffset != _loc1_.blueOffset || _loc2_.color != _loc1_.color)
         {
            param1.transform.colorTransform = _loc1_;
         }
      }

      public function modulateColor(param1:ColorTransform, param2:String) : void
      {
         if(this.stage == null)
         {
            return;
         }
         var _loc5_:MovieClip = this.stage.getChildAt(0) as MovieClip;
         if(param2 == "+")
         {
            this.totalTransform.alphaMultiplier += param1.alphaMultiplier;
            this.totalTransform.alphaOffset += param1.alphaOffset;
            this.totalTransform.redMultiplier += param1.redMultiplier;
            this.totalTransform.redOffset += param1.redOffset;
            this.totalTransform.greenMultiplier += param1.greenMultiplier;
            this.totalTransform.greenOffset += param1.greenOffset;
            this.totalTransform.blueMultiplier += param1.blueMultiplier;
            this.totalTransform.blueOffset += param1.blueOffset;
         }
         else if(param2 == "-")
         {
            this.totalTransform.alphaMultiplier -= param1.alphaMultiplier;
            this.totalTransform.alphaOffset -= param1.alphaOffset;
            this.totalTransform.redMultiplier -= param1.redMultiplier;
            this.totalTransform.redOffset -= param1.redOffset;
            this.totalTransform.greenMultiplier -= param1.greenMultiplier;
            this.totalTransform.greenOffset -= param1.greenOffset;
            this.totalTransform.blueMultiplier -= param1.blueMultiplier;
            this.totalTransform.blueOffset -= param1.blueOffset;
         }
         this.clampedTransform.alphaMultiplier = _loc5_.clamp(this.totalTransform.alphaMultiplier,-1,1);
         this.clampedTransform.alphaOffset = _loc5_.clamp(this.totalTransform.alphaOffset,-255,255);
         this.clampedTransform.redMultiplier = _loc5_.clamp(this.totalTransform.redMultiplier,-1,1);
         this.clampedTransform.redOffset = _loc5_.clamp(this.totalTransform.redOffset,-255,255);
         this.clampedTransform.greenMultiplier = _loc5_.clamp(this.totalTransform.greenMultiplier,-1,1);
         this.clampedTransform.greenOffset = _loc5_.clamp(this.totalTransform.greenOffset,-255,255);
         this.clampedTransform.blueMultiplier = _loc5_.clamp(this.totalTransform.blueMultiplier,-1,1);
         this.clampedTransform.blueOffset = _loc5_.clamp(this.totalTransform.blueOffset,-255,255);
         this.transform.colorTransform = this.clampedTransform;
      }

      public function updateColor(param1:Object = null) : *
      {
         var _loc1_:* = undefined;
         var _loc13_:* = this.pAV.objData;
         if(param1 != null)
         {
            _loc13_ = param1;
         }
         var _loc5_:* = MovieClip(stage.getChildAt(0)).ui;
         this.derasterizeChar();
         this.scanColor(this,_loc13_);
         if(this.pAV != null && _loc5_.mcPortrait.pAV != null && _loc5_.mcPortrait.pAV == this.pAV)
         {
            this.scanColor(_loc5_.mcPortrait.mcHead,_loc13_);
         }
         if(this.pAV != null && _loc5_.mcPortraitTarget.pAV != null && _loc5_.mcPortraitTarget.pAV == this.pAV)
         {
            this.scanColor(_loc5_.mcPortraitTarget.mcHead,_loc13_);
         }
         this.rasterizeChar();
         if(!this.pAV.isMyAvatar)
         {
            return;
         }
         var _loc6_:int = 1;
         while(_loc6_ < 6)
         {
            _loc1_ = _loc5_.mcInterface.actBar.getChildByName("i" + _loc6_);
            if(_loc1_ != null)
            {
               this.scanColor(_loc1_,_loc13_);
            }
            _loc6_++;
         }
      }

      private function scanColor(param1:MovieClip, param2:*) : void
      {
         var _loc6_:DisplayObject = null;
         if("isColored" in param1)
         {
            this.changeColor(param1,Number(param2["intColor" + param1.strLocation]),param1.strShade);
         }
         var _loc5_:int = 0;
         while(_loc5_ < param1.numChildren)
         {
            _loc6_ = param1.getChildAt(_loc5_);
            if(_loc6_ is MovieClip)
            {
               this.scanColor(MovieClip(_loc6_),param2);
            }
            _loc5_++;
         }
      }

      public function queueAnim(param1:String) : void
      {
         var _loc6_:Array = null;
         var _loc1_:String = null;
         var _loc2_:Object = null;
         var _loc3_:Boolean = false;
         var _loc4_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:* = undefined;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc11_:int = 0;
         var _loc14_:String = null;
         var _loc15_:* = undefined;
         if(this.stage == null)
         {
            return;
         }
         var _loc13_:MovieClip = MovieClip(stage.getChildAt(0)).world as MovieClip;
         if(Boolean(this.pAV.isMyAvatar) && Boolean(_loc13_.rootClass.litePreference.data.bDisSelfMAnim) && param1 != "Walk")
         {
            return;
         }
         if(!this.pAV.isMyAvatar && !_loc13_.showAnimations && param1 != "Walk")
         {
            return;
         }
         if(Boolean(param1.indexOf("Pet") > -1) && Boolean(this.pAV.petMC) && this.pAV.petMC.stage != null)
         {
            _loc2_ = this.pAV.getItemByEquipSlot("pe");
            if(param1.indexOf(":") > -1)
            {
               _loc6_ = param1.split(":");
               param1 = _loc6_[0];
               try
               {
                  if(_loc2_ != null)
                  {
                     if(_loc6_[1] == "PetAttack")
                     {
                        _loc1_ = ["Attack1","Attack2"][Math.round(Math.random() * 1)];
                        if(this.pAV.petMC.mcChar.currentLabel == "Idle")
                        {
                           this.pAV.petMC.mcChar.gotoAndPlay(_loc1_);
                        }
                     }
                     else
                     {
                        _loc1_ = _loc6_[1].slice(3);
                        if(this.pAV.petMC.mcChar.currentLabel == "Idle")
                        {
                           this.pAV.petMC.mcChar.gotoAndPlay(_loc1_);
                        }
                     }
                  }
               }
               catch(e:*)
               {
               }
            }
            else if(_loc2_ != null)
            {
               _loc1_ = ["Attack1","Attack2"][Math.round(Math.random() * 1)];
               _loc3_ = false;
               try
               {
                  _loc4_ = this.pAV.petMC.mcChar.currentLabels;
                  _loc7_ = 0;
                  while(_loc7_ < _loc4_.length)
                  {
                     if(_loc4_[_loc7_].name == _loc1_)
                     {
                        _loc3_ = true;
                        break;
                     }
                     _loc7_++;
                  }
                  if(_loc3_ && this.pAV.petMC.mcChar.currentLabel == "Idle")
                  {
                     this.pAV.petMC.mcChar.gotoAndPlay(_loc1_);
                  }
               }
               catch(e:*)
               {
               }
               if(_loc3_ || param1 == "PetAttack")
               {
                  return;
               }
               param1 = _loc1_;
            }
            else
            {
               if(param1 == "PetAttack")
               {
                  return;
               }
               param1 = param1.indexOf("1") > -1 ? "Attack1" : "Attack2";
            }
         }
         var _loc5_:Object = this.pAV.getItemByEquipSlot("Weapon");
         if(param1 == "Attack1" || param1 == "Attack2")
         {
            if(_loc5_ != null && _loc5_.sType != null)
            {
               _loc8_ = _loc5_.sType;
               if(_loc5_.ItemID == 156 || _loc5_.ItemID == 12583)
               {
                  _loc8_ = "Unarmed";
               }
               _loc9_ = null;
               switch(_loc8_)
               {
                  case "Unarmed":
                     _loc9_ = ["UnarmedAttack1","UnarmedAttack2","KickAttack","FlipAttack"];
                     break;
                  case "Polearm":
                     _loc9_ = ["PolearmAttack1","PolearmAttack2"];
                     break;
                  case "Dagger":
                     _loc9_ = ["DuelWield/DaggerAttack1","DuelWield/DaggerAttack2"];
                     break;
                  case "Bow":
                     _loc9_ = ["RangedAttack3"];
                     break;
                  case "Whip":
                     _loc9_ = ["WhipAttack"];
                     break;
                  case "HandGun":
                     _loc9_ = ["GunAttack","GunAttack2"];
                     break;
                  case "Rifle":
                     _loc9_ = ["RifleAttack2"];
                     break;
                  case "Gauntlet":
                     _loc9_ = ["UnarmedAttack1","UnarmedAttack2","FistweaponAttack1","FistweaponAttack2"];
               }
               if(_loc9_ != null)
               {
                  _loc10_ = [];
                  _loc11_ = 0;
                  while(_loc11_ < _loc9_.length)
                  {
                     if(this.hasLabel(_loc9_[_loc11_]))
                     {
                        _loc10_.push(_loc9_[_loc11_]);
                     }
                     _loc11_++;
                  }
                  if(_loc10_.length > 0)
                  {
                     param1 = _loc10_[Math.floor(Math.random() * _loc10_.length)];
                  }
               }
            }
         }
         if(this.hasLabel(param1) && this.pAV.dataLeaf.intState > 0)
         {
            this.pAV.handleItemAnimation();
            _loc14_ = this.mcChar.currentLabel;
            if(_loc13_.combatAnims.indexOf(param1) > -1 && _loc13_.combatAnims.indexOf(_loc14_) > -1)
            {
               this.animQueue.push(param1);
               if(this.animQueue.length > 2)
               {
                  this.animQueue.shift();
               }
               this.addEventListener(Event.ENTER_FRAME,this.checkQueue,false,0,true);
            }
            else
            {
               this.mcChar.gotoAndPlay(param1);
               if(this.pAV.dataLeaf.intState == 2)
               {
                  if(this.pAV.objData.eqp != null)
                  {
                     for(_loc15_ in this.pAV.objData.eqp)
                     {
                        this.handleAttack(_loc15_);
                     }
                  }
               }
            }
         }
      }

      private function checkQueue(param1:Event) : Boolean
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         if(this.animQueue.length == 0)
         {
            this.queueStallTicks = 0;
            this.removeEventListener(Event.ENTER_FRAME,this.checkQueue);
            return false;
         }
         if(this.stage == null)
         {
            return false;
         }
         var _loc13_:MovieClip = MovieClip(stage.getChildAt(0)).world as MovieClip;
         var _loc5_:String = this.mcChar.currentLabel;
         var _loc6_:int = this.mcChar.emoteLoopFrame();
         if(_loc13_.combatAnims.indexOf(_loc5_) > -1 && this.mcChar.currentFrame > _loc6_ + 4)
         {
            _loc1_ = this.animQueue[0];
            this.queueStallTicks = 0;
            this.mcChar.gotoAndPlay(_loc1_);
            if(this.pAV.dataLeaf.intState == 2)
            {
               if(this.pAV.objData.eqp != null)
               {
                  for(_loc2_ in this.pAV.objData.eqp)
                  {
                     this.handleAttack(_loc2_);
                  }
               }
            }
            this.animQueue.shift();
            return true;
         }
         if(param1 != null && ++this.queueStallTicks > 90)
         {
            this.animQueue = [];
            this.queueStallTicks = 0;
         }
         return false;
      }

      public function performAttack(param1:*) : void
      {
         var _loc13_:int = 0;
         if(!(param1 is MovieClip))
         {
            return;
         }
         param1 = MovieClip(param1);
         while(true)
         {
            if(!(_loc13_ < 4 && Boolean(param1)))
            {
               return;
            }
            if(param1.hasOwnProperty("bAttack"))
            {
               param1.gotoAndPlay("Attack");
               break;
            }
            if(!(param1.numChildren > 0 && param1.getChildAt(0) is MovieClip))
            {
               break;
            }
            param1 = MovieClip(param1.getChildAt(0));
            _loc13_++;
         }
      }

      public function handleAttack(param1:String) : void
      {
         var _loc5_:* = undefined;
         var _loc1_:Array = null;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc13_:Object = this.pAV.getItemByEquipSlot(param1);
         if(param1 == "Weapon")
         {
            if(_loc13_.sType == "Gauntlet")
            {
               _loc1_ = [(this.mcChar.fronthand.getChildAt(1) as MovieClip).getChildAt(1),(this.mcChar.backhand.getChildAt(1) as MovieClip).getChildAt(0)];
               for each(_loc2_ in _loc1_)
               {
                  this.performAttack(_loc2_);
               }
               return;
            }
            if(_loc13_.sType == "Dagger")
            {
               _loc1_ = [this.mcChar.weapon.mcWeapon,this.mcChar.weaponOff];
               if(this.mcChar.weapon.mcWeapon.numChildren > 1)
               {
                  _loc1_ = [(this.mcChar.weapon.mcWeapon as MovieClip).getChildAt(1),(this.mcChar.weaponOff as MovieClip).getChildAt(0)];
               }
               for each(_loc2_ in _loc1_)
               {
                  this.performAttack(_loc2_);
               }
               return;
            }
            _loc5_ = this.mcChar.weapon.mcWeapon;
            this.performAttack(_loc5_);
            return;
         }
         var _loc6_:* = 0;
         while(_loc6_ < this.attackFrames.length)
         {
            _loc3_ = this.attackFrames[_loc6_];
            if(!_loc3_)
            {
               this.attackFrames.splice(_loc6_,1);
               _loc6_--;
            }
            else if(_loc3_ is MovieClip)
            {
               MovieClip(_loc3_).gotoAndPlay("Attack");
            }
            _loc6_++;
         }
      }

      public function clearQueue() : void
      {
         this.animQueue = [];
      }

      private function linearTween(param1:*, param2:*, param3:*, param4:*) : Number
      {
         return param3 * param1 / param4 + param2;
      }

      public function walkTo(param1:int, param2:int, param3:int) : void
      {
         var isOK:Boolean;
         var wasSteer:Boolean = false;
         var dist:Number = NaN;
         var turned:Boolean = false;
         var dx:Number = NaN;
         var toX:int = param1;
         var toY:int = param2;
         var walkSpeed:int = param3;
         if(this.pAV.isMyAvatar && this.pAV.isWorldCamera)
         {
            return;
         }
         isOK = true;
         try
         {
            this.STAGE = MovieClip(parent.parent);
         }
         catch(e:Error)
         {
            isOK = false;
         }
         if(isOK)
         {
            wasSteer = this.steerOn;
            if(this.steerOn)
            {
               this.steerOff();
            }
            this.op = new Point(this.x,this.y);
            this.tp = new Point(toX,toY);
            if(this.pAV.petMC != null && this.pAV.petMC.mcChar != null)
            {
               turned = false;
               if(this.op.x - this.tp.x < 0)
               {
                  if(this.pAV.petMC.mcChar.scaleX < 0)
                  {
                     this.pAV.petMC.turn("right");
                     turned = true;
                  }
               }
               else if(this.pAV.petMC.mcChar.scaleX > 0)
               {
                  this.pAV.petMC.turn("left");
                  turned = true;
               }
               this.pAV.petMC.walkTo(toX - 20,toY + 5,walkSpeed - 3);
            }
            this.walkSpeed = walkSpeed;
            dist = Point.distance(this.op,this.tp);
            this.walkDist = dist;
            this.walkTS = getTimer();
            this.walkD = Math.round(1000 * (dist / (walkSpeed * 22)));
            if(this.walkD > 0)
            {
               dx = this.op.x - this.tp.x;
               if(dx < 0)
               {
                  this.turn("right");
               }
               else
               {
                  this.turn("left");
               }
               if(!this.mcChar.onMove)
               {
                  this.mcChar.onMove = true;
                  if(this.mcChar.currentLabel != "Walk")
                  {
                     this.mcChar.gotoAndPlay("Walk");
                  }
               }
               this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrameWalk);
               this.addEventListener(Event.ENTER_FRAME,this.onEnterFrameWalk,false,0,true);
               this.walkOn = true;
            }
            else if(wasSteer)
            {
               this.stopWalking();
            }
         }
      }

      private function lerp(param1:*, param2:*, param3:*) : Number
      {
         return param1 + (param2 - param1) * param3;
      }

      public function calculateNewPxPy() : void
      {
         var _loc12_:* = MovieClip(stage.getChildAt(0));
         var _loc13_:Number = (_loc12_.mtcidNow - this.mvts) / this.mvtd;
         if(_loc13_ > 1)
         {
            this.x = this.tx;
            this.y = this.ty;
            this.resetSyncVars();
            return;
         }
         this.x = Math.floor(this.lerp(this.px,this.tx,_loc13_));
         this.y = Math.floor(this.lerp(this.py,this.ty,_loc13_));
      }

      public function resetSyncVars() : void
      {
         this.px = 0;
         this.py = 0;
         this.mvts = 0;
         this.mvtd = 0;
         this.mcChar.onMove = false;
      }

      public function destroyWalkFrame() : void
      {
         this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrameWalk);
         this.walkOn = false;
         if(this.steerOn)
         {
            this.steerOff();
         }
         if(this.mcChar != null && this.mcChar.onMove)
         {
            this.stopWalking();
         }
      }

      private function onEnterFrameWalk(param1:Event) : void
      {
         var _loc6_:Number = NaN;
         var _loc1_:Number = NaN;
         var _loc2_:Array = null;
         var _loc3_:Boolean = false;
         var _loc4_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:Boolean = false;
         var _loc9_:Point = null;
         var _loc10_:Rectangle = null;
         if(this.mcChar == null || this.pAV == null || stage == null)
         {
            this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrameWalk);
            this.walkOn = false;
            if(this.mcChar != null)
            {
               this.mcChar.onMove = false;
            }
            return;
         }
         var _loc13_:int = getTimer();
         var _loc5_:Number = (_loc13_ - this.walkTS) / this.walkD;
         if(_loc5_ > 1)
         {
            _loc5_ = 1;
         }
         if(this.walkDist > 0.5 && this.mcChar.onMove)
         {
            _loc6_ = this.x;
            _loc1_ = this.y;
            this.x = this.op.x + _loc5_ * (this.tp.x - this.op.x);
            this.y = this.op.y + _loc5_ * (this.tp.y - this.op.y);
            _loc2_ = this.STAGE.arrSolid;
            _loc3_ = solidHit(this.shadow,_loc2_,this.STAGE);
            if(_loc3_)
            {
               _loc4_ = this.y;
               this.y = _loc1_;
               _loc3_ = solidHit(this.shadow,_loc2_,this.STAGE);
               if(_loc3_)
               {
                  this.y = _loc4_;
                  this.x = _loc6_;
                  _loc3_ = solidHit(this.shadow,_loc2_,this.STAGE);
                  if(_loc3_)
                  {
                     this.x = _loc6_;
                     this.y = _loc1_;
                     this.stopWalking();
                  }
               }
            }
            if(Math.round(_loc6_) == Math.round(this.x) && Math.round(_loc1_) == Math.round(this.y) && _loc13_ > this.walkTS + 50)
            {
               this.stopWalking();
            }
            if(this.pAV.isMyAvatar)
            {
               this.checkPadLabels();
               _loc7_ = 0;
               while(_loc7_ < this.STAGE.arrEvent.length)
               {
                  if(!(this.STAGE.arrEvent[_loc7_] == null || this.STAGE.arrEvent[_loc7_].shadow == null || this.STAGE.arrEvent[_loc7_].stage == null))
                  {
                     _loc8_ = false;
                     this.world = MovieClip(stage.getChildAt(0)).world;
                     if(this.world.bPvP)
                     {
                        _loc9_ = this.shadow.localToGlobal(new Point(0,0));
                        _loc10_ = this.STAGE.arrEvent[_loc7_].shadow.getBounds(stage);
                        if(_loc10_.containsPoint(_loc9_))
                        {
                           _loc8_ = true;
                        }
                     }
                     else if(this.shadow.hitTestObject(this.STAGE.arrEvent[_loc7_].shadow))
                     {
                        _loc8_ = true;
                     }
                     if(_loc8_)
                     {
                        if(!this.STAGE.arrEvent[_loc7_]._entered && Boolean(MovieClip(this.STAGE.arrEvent[_loc7_]).isEvent))
                        {
                           this.STAGE.arrEvent[_loc7_]._entered = true;
                           if(this == MovieClip(parent.parent).myAvatar.pMC)
                           {
                              this.STAGE.arrEvent[_loc7_].dispatchEvent(new Event("enter"));
                           }
                        }
                     }
                     else if(this.STAGE.arrEvent[_loc7_]._entered)
                     {
                        this.STAGE.arrEvent[_loc7_]._entered = false;
                     }
                  }
                  _loc7_++;
               }
            }
         }
         else
         {
            this.stopWalking();
         }
      }

      public function simulateTo(param1:int, param2:int, param3:int) : Point
      {
         this.STAGE = MovieClip(parent.parent);
         this.xDep = this.x;
         this.yDep = this.y;
         this.xTar = param1;
         this.yTar = param2;
         this.walkSpeed = param3;
         this.nDuration = Math.round(Math.sqrt(Math.pow(this.xTar - this.x,2) + Math.pow(this.yTar - this.y,2)) / param3);
         var _loc6_:* = new Point();
         if(this.nDuration)
         {
            this.nXStep = 0;
            this.nYStep = 0;
            if(!this.mcChar.onMove)
            {
               this.mcChar.onMove = true;
            }
            solidDirty = true;
            _loc6_ = this.simulateWalkLoop();
            solidDirty = true;
         }
         else
         {
            _loc6_ = null;
         }
         this.x = this.xDep;
         this.y = this.yDep;
         this.mcChar.onMove = false;
         return _loc6_;
      }

      private function simulateWalkLoop() : Point
      {
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc5_:Boolean = false;
         var _loc6_:* = undefined;
         while((this.nXStep <= this.nDuration || this.nYStep <= this.nDuration) && this.mcChar.onMove)
         {
            _loc12_ = this.x;
            _loc13_ = this.y;
            this.x = this.linearTween(this.nXStep,this.xDep,this.xTar - this.xDep,this.nDuration);
            this.y = this.linearTween(this.nYStep,this.yDep,this.yTar - this.yDep,this.nDuration);
            _loc5_ = solidHit(this.shadow,this.STAGE.arrSolid,this.STAGE);
            if(_loc5_)
            {
               _loc6_ = this.y;
               this.y = _loc13_;
               _loc5_ = solidHit(this.shadow,this.STAGE.arrSolid,this.STAGE);
               if(_loc5_)
               {
                  this.y = _loc6_;
                  this.x = _loc12_;
                  _loc5_ = solidHit(this.shadow,this.STAGE.arrSolid,this.STAGE);
                  if(_loc5_)
                  {
                     this.x = _loc12_;
                     this.y = _loc13_;
                     this.mcChar.onMove = false;
                     this.nDuration = -1;
                     return new Point(this.x,this.y);
                  }
                  if(this.nYStep <= this.nDuration)
                  {
                     ++this.nYStep;
                  }
               }
               else if(this.nXStep <= this.nDuration)
               {
                  ++this.nXStep;
               }
            }
            else
            {
               if(this.nXStep <= this.nDuration)
               {
                  ++this.nXStep;
               }
               if(this.nYStep <= this.nDuration)
               {
                  ++this.nYStep;
               }
            }
            if(Math.round(_loc12_) == Math.round(this.x) && Math.round(_loc13_) == Math.round(this.y) && (this.nXStep > 1 || this.nYStep > 1))
            {
               this.mcChar.onMove = false;
               this.nDuration = -1;
               return new Point(this.x,this.y);
            }
         }
         this.mcChar.onMove = false;
         this.nDuration = -1;
         return new Point(this.x,this.y);
      }

      public function stopWalking() : void
      {
         this.walkOn = false;
         if(this.steerOn)
         {
            this.steerOff();
         }
         if(stage == null || this.mcChar == null || this.pAV == null)
         {
            this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrameWalk);
            if(this.mcChar != null)
            {
               this.mcChar.onMove = false;
            }
            return;
         }
         this.world = MovieClip(stage.getChildAt(0)).world;
         if(this.mcChar.onMove)
         {
            this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrameWalk);
            if(this.pAV.isMyAvatar && this.world != null && parent != null && parent.parent != null && Boolean(MovieClip(parent.parent).actionReady))
            {
               this.world.testAction(this.world.getAutoAttack());
            }
         }
         this.mcChar.onMove = false;
         this.mcChar.gotoAndPlay("Idle");
         this.px = 0;
         this.py = 0;
      }

      public function get steering() : Boolean
      {
         return this.steerOn;
      }

      public function get walking() : Boolean
      {
         return this.walkOn;
      }

      public function steer(param1:Number, param2:Number, param3:int, param4:Function = null) : void
      {
         if(this.pAV == null || this.mcChar == null || parent == null)
         {
            return;
         }
         if(this.pAV.isMyAvatar && this.pAV.isWorldCamera)
         {
            return;
         }
         var _loc1_:MovieClip = parent.parent as MovieClip;
         if(_loc1_ == null)
         {
            return;
         }
         var _loc2_:Number = Math.sqrt(param1 * param1 + param2 * param2);
         if(_loc2_ < 0.001)
         {
            this.steerStop();
            return;
         }
         this.STAGE = _loc1_;
         param1 /= _loc2_;
         param2 /= _loc2_;
         var _loc3_:Boolean = !this.steerOn || param1 != this.steerVX || param2 != this.steerVY;
         this.steerVX = param1;
         this.steerVY = param2;
         this.steerSpd = param3 > 0 ? param3 : 8;
         this.steerArea = param4;
         if(_loc3_)
         {
            this.steerFace();
         }
         if(this.steerOn)
         {
            return;
         }
         if(this.walkOn)
         {
            this.walkOn = false;
            this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrameWalk);
         }
         this.steerOn = true;
         this.steerTS = getTimer();
         this.steerStall = 0;
         this.steerPetTS = 0;
         this.steerWalkAnim();
         this.addEventListener(Event.ENTER_FRAME,this.onEnterFrameSteer,false,0,true);
      }

      public function steerStop() : void
      {
         if(!this.steerOn)
         {
            return;
         }
         this.steerOff();
         this.steerPet(0);
         this.stopWalking();
      }

      public function steerAhead(param1:Number) : Point
      {
         var _loc13_:Point = new Point(Math.round(this.x),Math.round(this.y));
         if(!this.steerOn || this.STAGE == null || this.mcChar == null)
         {
            return _loc13_;
         }
         var _loc5_:Boolean = this.mcChar.onMove;
         var _loc6_:Number = this.steerSpd * 22 * param1;
         var _loc1_:Point = null;
         while(_loc1_ == null && _loc6_ >= 4)
         {
            _loc1_ = this.simulateTo(Math.round(this.x + this.steerVX * _loc6_),Math.round(this.y + this.steerVY * _loc6_),this.steerSpd);
            if(_loc1_ != null && this.steerArea != null && !this.steerArea(_loc1_.x,_loc1_.y,this.x,this.y))
            {
               _loc1_ = null;
            }
            _loc6_ *= 0.5;
         }
         this.mcChar.onMove = _loc5_;
         if(_loc1_ == null)
         {
            return _loc13_;
         }
         return new Point(Math.round(_loc1_.x),Math.round(_loc1_.y));
      }

      private function steerOff() : void
      {
         this.steerOn = false;
         this.steerArea = null;
         this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrameSteer);
      }

      private function steerFace() : void
      {
         if(this.steerVX > 0.2)
         {
            this.turn("right");
         }
         else if(this.steerVX < -0.2)
         {
            this.turn("left");
         }
      }

      private function steerWalkAnim() : void
      {
         this.mcChar.onMove = true;
         if(this.mcChar.currentLabel != "Walk")
         {
            this.mcChar.gotoAndPlay("Walk");
         }
      }

      private function onEnterFrameSteer(param1:Event) : void
      {
         var _loc7_:Number = NaN;
         if(!this.steerOn || this.mcChar == null || this.pAV == null || stage == null || this.STAGE == null)
         {
            this.steerOff();
            if(this.mcChar != null)
            {
               this.mcChar.onMove = false;
            }
            return;
         }
         var _loc13_:int = getTimer();
         var _loc5_:int = _loc13_ - this.steerTS;
         this.steerTS = _loc13_;
         if(_loc5_ <= 0)
         {
            return;
         }
         if(_loc5_ > 100)
         {
            _loc5_ = 100;
         }
         var _loc6_:Number = this.steerSpd * 22 * _loc5_ / 1000;
         var _loc1_:int = Math.ceil(_loc6_ / 8);
         var _loc2_:Number = _loc6_ / _loc1_;
         var _loc3_:Number = 0;
         var _loc4_:int = 0;
         while(_loc4_ < _loc1_)
         {
            _loc7_ = this.steerStep(_loc2_);
            if(_loc7_ <= 0)
            {
               break;
            }
            _loc3_ += _loc7_;
            _loc4_++;
         }
         if(_loc3_ > 0)
         {
            this.steerStall = 0;
            if(!this.mcChar.onMove)
            {
               this.steerWalkAnim();
            }
            if(_loc13_ - this.steerPetTS >= 250)
            {
               this.steerPetTS = _loc13_;
               this.steerPet(0.5);
            }
            if(this.pAV.isMyAvatar)
            {
               this.checkPadLabels();
               this.steerEvents();
            }
         }
         else
         {
            this.steerStall += _loc5_;
            if(this.steerStall >= 150 && this.mcChar.onMove)
            {
               this.mcChar.onMove = false;
               if(this.mcChar.currentLabel == "Walk")
               {
                  this.mcChar.gotoAndPlay("Idle");
               }
            }
         }
      }

      private function steerStep(param1:Number) : Number
      {
         var _loc13_:Number = this.x;
         var _loc5_:Number = this.y;
         var _loc6_:Number = _loc13_ + this.steerVX * param1;
         var _loc1_:Number = _loc5_ + this.steerVY * param1;
         var _loc2_:Number = param1 * 0.25;
         this.x = _loc6_;
         this.y = _loc1_;
         if(this.steerFits(_loc13_,_loc5_))
         {
            return param1;
         }
         if(Math.abs(_loc6_ - _loc13_) >= _loc2_)
         {
            this.y = _loc5_;
            if(this.steerFits(_loc13_,_loc5_))
            {
               return Math.abs(_loc6_ - _loc13_);
            }
         }
         if(Math.abs(_loc1_ - _loc5_) >= _loc2_)
         {
            this.x = _loc13_;
            this.y = _loc1_;
            if(this.steerFits(_loc13_,_loc5_))
            {
               return Math.abs(_loc1_ - _loc5_);
            }
         }
         this.x = _loc13_;
         this.y = _loc5_;
         return 0;
      }

      private function steerFits(param1:Number, param2:Number) : Boolean
      {
         if(this.steerArea != null && !this.steerArea(this.x,this.y,param1,param2))
         {
            return false;
         }
         var _loc5_:Array = this.STAGE.arrSolid;
         if(_loc5_ == null)
         {
            return true;
         }
         return !solidHit(this.shadow,_loc5_,this.STAGE);
      }

      private function steerEvents() : void
      {
         var _loc6_:* = undefined;
         var _loc1_:Boolean = false;
         var _loc2_:Point = null;
         var _loc3_:Rectangle = null;
         if(this.STAGE.arrEvent == null)
         {
            return;
         }
         var _loc12_:Boolean = this.STAGE.bPvP == true;
         var _loc13_:Boolean = this.STAGE.myAvatar != null && this.STAGE.myAvatar.pMC == this;
         var _loc5_:int = 0;
         while(_loc5_ < this.STAGE.arrEvent.length)
         {
            _loc6_ = this.STAGE.arrEvent[_loc5_];
            if(!(_loc6_ == null || _loc6_.shadow == null || _loc6_.stage == null))
            {
               _loc1_ = false;
               if(_loc12_)
               {
                  _loc2_ = this.shadow.localToGlobal(steerOrigin);
                  _loc3_ = _loc6_.shadow.getBounds(stage);
                  if(_loc3_.containsPoint(_loc2_))
                  {
                     _loc1_ = true;
                  }
               }
               else if(this.shadow.hitTestObject(_loc6_.shadow))
               {
                  _loc1_ = true;
               }
               if(_loc1_)
               {
                  if(!_loc6_._entered && Boolean(MovieClip(_loc6_).isEvent))
                  {
                     _loc6_._entered = true;
                     if(_loc13_)
                     {
                        _loc6_.dispatchEvent(new Event("enter"));
                        if(!this.steerOn || this.STAGE.arrEvent == null)
                        {
                           return;
                        }
                     }
                  }
               }
               else if(_loc6_._entered)
               {
                  _loc6_._entered = false;
               }
            }
            _loc5_++;
         }
      }

      private function steerPet(param1:Number) : void
      {
         if(this.pAV == null || this.pAV.petMC == null || this.pAV.petMC.mcChar == null || this.mcChar == null)
         {
            return;
         }
         var _loc13_:PetMC = this.pAV.petMC;
         var _loc5_:Boolean = this.mcChar.scaleX > 0;
         if(_loc5_ != _loc13_.mcChar.scaleX > 0)
         {
            _loc13_.turn(_loc5_ ? "right" : "left");
         }
         var _loc6_:Number = this.steerSpd * 22 * param1;
         _loc13_.walkTo(this.x + this.steerVX * _loc6_ - 20,this.y + this.steerVY * _loc6_ + 5,Math.max(1,this.steerSpd - 3));
      }

      public function checkPadLabels() : *
      {
         var _loc6_:* = undefined;
         var _loc1_:* = undefined;
         var _loc12_:* = MovieClip(stage.getChildAt(0));
         var _loc13_:* = _loc12_.ui;
         var _loc5_:int = 0;
         while(_loc5_ < _loc13_.mcPadNames.numChildren)
         {
            _loc6_ = MovieClip(_loc13_.mcPadNames.getChildAt(_loc5_));
            _loc1_ = new Point(4,8);
            _loc1_ = _loc6_.cnt.localToGlobal(_loc1_);
            if(_loc12_.distanceO(this,_loc1_) < 200)
            {
               if(!_loc6_.isOn)
               {
                  _loc6_.isOn = true;
                  _loc6_.gotoAndPlay("in");
               }
            }
            else if(_loc6_.isOn)
            {
               _loc6_.isOn = false;
               _loc6_.gotoAndPlay("out");
            }
            _loc5_++;
         }
      }

      public function turn(param1:String) : void
      {
         if(param1 == "right" && this.mcChar.scaleX < 0 || param1 == "left" && this.mcChar.scaleX > 0)
         {
            this.mcChar.scaleX *= -1;
            if(this.pAV.morphMC != null && this.pAV.morphMC.visible)
            {
               this.pAV.morphMC.scaleX *= -1;
            }
         }
      }

      public function scale(param1:Number) : void
      {
         if(this.mcChar.scaleX >= 0)
         {
            this.mcChar.scaleX = param1;
         }
         else
         {
            this.mcChar.scaleX = -param1;
         }
         this.mcChar.scaleY = param1;
         this.shadow.scaleX = this.shadow.scaleY = param1;
         this.cShadow.scaleX = this.cShadow.scaleY = param1;
         var _loc13_:Point = this.mcChar.localToGlobal(this.headPoint);
         _loc13_ = this.globalToLocal(_loc13_);
         this.pname.y = int(_loc13_.y);
         this.hpBar.y = this.pname.y - 3;
         this.bubble.y = int(this.pname.y - this.bubble.height);
         this.ignore.y = int(this.pname.y - this.ignore.height - 2);
         this.drawHitBox();
      }

      public function endAction() : void
      {
         var tChar:*;
         var dx:Number = NaN;
         var s:String = null;
         var wItem:Object = null;
         var sType:* = undefined;
         if(this.mcChar == null)
         {
            return;
         }
         if(this.pAV == null)
         {
            this.mcChar.stop();
            return;
         }
         tChar = null;
         if(this.pAV.target != null && this.pAV.target.pMC != null)
         {
            tChar = this.pAV.target.pMC.mcChar;
         }
         try
         {
            if(tChar == null && this.pAV.target != null && this.pAV.target.dataLeaf != null && this.pAV.target.dataLeaf.intState == 0 && this.world != null && this.pAV == this.world.myAvatar)
            {
               this.world.setTarget(null);
            }
            if(!this.checkQueue(null))
            {
               if(this.mcChar.onMove)
               {
                  this.mcChar.gotoAndPlay("Walk");
                  if(this.steerOn)
                  {
                     this.steerFace();
                  }
                  else
                  {
                     dx = this.x - this.xTar;
                     if(dx < 0)
                     {
                        this.turn("right");
                     }
                     else
                     {
                        this.turn("left");
                     }
                  }
               }
               else if(tChar == null || tChar != null && (tChar.currentLabel == "Die" || tChar.currentLabel == "Feign" || tChar.currentLabel == "Dead" || this.pAV.target.npcType == "player" && (!("pvpTeam" in this.pAV.dataLeaf) || this.pAV.dataLeaf.pvpTeam == this.pAV.target.dataLeaf.pvpTeam)))
               {
                  if(this.mcChar.currentLabel != "Jump")
                  {
                     this.mcChar.gotoAndPlay("Idle");
                  }
                  if(tChar != null)
                  {
                     if(this.pAV.target.dataLeaf.intState == 0)
                     {
                        if(this.pAV == this.world.myAvatar)
                        {
                           this.world.setTarget(null);
                        }
                     }
                  }
               }
               else
               {
                  s = "Fight";
                  wItem = this.pAV.getItemByEquipSlot("Weapon");
                  if(wItem != null && wItem.sType != null)
                  {
                     sType = wItem.sType;
                     if(wItem.ItemID == 156)
                     {
                        sType = "Unarmed";
                     }
                     switch(sType)
                     {
                        case "Bow":
                           s = "RangedFight";
                           break;
                        case "Rifle":
                           s = "RifleFight";
                           break;
                        case "Gauntlet":
                           s = "UnarmedFight";
                           break;
                        case "Unarmed":
                           s = "UnarmedFight";
                           break;
                        case "Polearm":
                           s = "PolearmFight";
                           break;
                        case "Dagger":
                           s = "DuelWield/DaggerFight";
                     }
                  }
                  this.mcChar.gotoAndPlay(s);
               }
            }
         }
         catch(eEnd:Error)
         {
            try
            {
               this.mcChar.gotoAndPlay("Idle");
            }
            catch(eEnd2:Error)
            {
            }
         }
      }

      private function drawHitBox() : void
      {
         this.mcChar.hitbox.graphics.clear();
         var _loc12_:int = -30;
         var _loc13_:int = 60;
         var _loc5_:int = this.mcChar.head.y;
         var _loc6_:int = -_loc5_ * 0.8;
         this.hitboxR = new Rectangle(_loc12_,_loc5_,_loc13_,_loc6_);
         var _loc1_:Graphics = this.mcChar.hitbox.graphics;
         _loc1_.lineStyle(0,16777215,0);
         _loc1_.beginFill(11141375,0);
         _loc1_.moveTo(_loc12_,_loc5_);
         _loc1_.lineTo(_loc12_ + _loc13_,_loc5_);
         _loc1_.lineTo(_loc12_ + _loc13_,_loc5_ + _loc6_);
         _loc1_.lineTo(_loc12_,_loc5_ + _loc6_);
         _loc1_.lineTo(_loc12_,_loc5_);
         _loc1_.endFill();
      }

      public function showHealIcon() : void
      {
         var _loc12_:HealIconMC = null;
         if(this.rootClass.litePreference.data.bDisHealBubble)
         {
            return;
         }
         if(!getChildByName("HealIconMC"))
         {
            _loc12_ = new HealIconMC(this.pAV,this.world);
            _loc12_.name = "HealIconMC";
            addChild(_loc12_);
         }
      }

      private function randomNumber(param1:Number, param2:Number) : Number
      {
         this.randNum = param1 + (param2 + 1 - param1) * this.XORandom();
         return this.randNum < param2 ? this.randNum : param2;
      }

      private function XORandom() : Number
      {
         this.r ^= this.r << 21;
         this.r ^= this.r >>> 35;
         this.r ^= this.r << 4;
         if(this.r > 0)
         {
            return this.r * this.MAX_RATIO;
         }
         return this.r * this.NEGA_MAX_RATIO;
      }

      public function iaF(param1:Object) : void
      {
         var _loc13_:String = null;
         var _loc5_:MovieClip = null;
         var _loc6_:MovieClip = null;
         for each(_loc13_ in IAF_BODY_PARTS)
         {
            try
            {
               _loc5_ = this.mcChar[_loc13_] as MovieClip;
               if(_loc5_ != null && _loc5_.numChildren > 0)
               {
                  _loc6_ = _loc5_.getChildAt(0) as MovieClip;
                  if(_loc6_ != null)
                  {
                     _loc6_.iaF(param1);
                  }
               }
            }
            catch(e:Error)
            {
            }
         }
      }

      public function clearSpFXQueue() : void
      {
         this._spFXQueue = [];
      }

      public function canCastSpFX() : void
      {
         if(this._spFXQueue.length < 1)
         {
            return;
         }
         this.world.castSpellFX(this.pAV,this.nextSpFX,null,0);
      }

      public function get nextSpFX() : Object
      {
         return this._spFXQueue.shift();
      }

      public function queueSpFX(param1:Object) : void
      {
         if(this.spFX.strl != "")
         {
            this._spFXQueue.push(param1);
         }
         else
         {
            this.spFX = param1;
         }
      }

      public function playSound() : void
      {
      }

      public function addAnimationListener(param1:String, param2:Function, param3:Boolean = true) : void
      {
         if(this.animEvents[param1] == null)
         {
            this.animEvents[param1] = [];
         }
         if(!this.hasAnimationListener(param1,param2))
         {
            this.animEvents[param1].push(param2);
            this.animEvents[param1].push(param3);
         }
      }

      public function removeAnimationListener(param1:String, param2:Function) : void
      {
         if(this.animEvents[param1] == null)
         {
            return;
         }
         var _loc5_:uint = 0;
         while(_loc5_ < this.animEvents[param1].length)
         {
            if(this.animEvents[param1][_loc5_] == param2)
            {
               this.animEvents[param1].splice(_loc5_,2);
               break;
            }
            _loc5_ += 2;
         }
      }

      public function hasAnimationListener(param1:String, param2:Function) : Boolean
      {
         if(this.animEvents[param1] == null)
         {
            return false;
         }
         var _loc5_:uint = 0;
         while(_loc5_ < this.animEvents[param1].length)
         {
            if(this.animEvents[param1][_loc5_] == param2)
            {
               return true;
            }
            _loc5_ += 2;
         }
         return false;
      }

      private function handleAnimEvent(param1:String) : void
      {
         var _loc13_:Function = null;
         if(this.animEvents[param1] == null)
         {
            return;
         }
         var _loc5_:uint = 0;
         while(_loc5_ < this.animEvents[param1].length)
         {
            _loc13_ = this.animEvents[param1][_loc5_];
            _loc13_();
            _loc5_ += 2;
         }
      }

      public function clearAnimEvents() : void
      {
         this.animEvents = new Object();
      }

      public function get AnimEvent() : Object
      {
         return this.animEvents;
      }

      public function artLoaded() : Boolean
      {
         return this.weaponLoad && this.capeLoad && this.helmLoad && this.armorLoad && this.classLoad && this.hairLoad && this.miscLoad;
      }

      private function disposeAllBitmaps(param1:DisplayObjectContainer) : void
      {
         var _loc5_:DisplayObject = null;
         var _loc6_:Bitmap = null;
         var _loc13_:* = int(param1.numChildren - 1);
         while(_loc13_ >= 0)
         {
            _loc5_ = param1.getChildAt(_loc13_);
            if(_loc5_ is Bitmap)
            {
               _loc6_ = _loc5_ as Bitmap;
               if(_loc6_.bitmapData != null)
               {
                  _loc6_.bitmapData.dispose();
               }
            }
            else if(_loc5_ is DisplayObjectContainer)
            {
               this.disposeAllBitmaps(DisplayObjectContainer(_loc5_));
            }
            _loc13_--;
         }
      }

      internal function frame1() : *
      {
         this.mcChar.transform.colorTransform = this.CT1;
         this.mcChar.alpha = 0;
         stop();
      }

      internal function frame5() : *
      {
         this.mcChar.transform.colorTransform = this.CT1;
         this.mcChar.alpha = 0;
      }

      internal function frame8() : *
      {
         stop();
      }

      internal function frame10() : *
      {
         this.mcChar.alpha = 0;
      }

      internal function frame12() : *
      {
         this.mcChar.transform.colorTransform = this.CT3;
      }

      internal function frame13() : *
      {
         this.mcChar.transform.colorTransform = this.CT2;
      }

      internal function frame14() : *
      {
         this.mcChar.transform.colorTransform = this.CT1;
      }

      internal function frame18() : *
      {
         stop();
      }

      internal function frame20() : *
      {
         this.mcChar.transform.colorTransform = this.CT1;
      }

      internal function frame23() : *
      {
         stop();
      }
   }
}
