package liteAssets.mobile
{
   import flash.display.*;
   import flash.events.*;
   import flash.ui.*;
   import flash.utils.*;

   public class GameKeys extends Sprite
   {

      private static var inst:GameKeys;

      private static var game:MovieClip;

      private static var repeat:Timer;

      private static var st:Stage;

      private static const ON:Number = 0.383;

      private static const REPEAT_DELAY:int = 400;

      private static const REPEAT_MS:int = 50;

      private static const EDGE:int = 12;

      private static const BOTTOM:int = 495;

      private static const PREF:String = "mgKeys";

      private static const ROW:Array = [["A",65],["S",83],["D",68],["F",70],["Ctrl",17]];

      public static var firing:Boolean = false;

      private static var _active:Boolean = false;

      private static var _on:Boolean = false;

      private static var gameKey:String = null;

      private static var held:Object = {};

      private static var chars:Object = {
         32:32,
         13:13,
         65:97,
         83:115,
         68:100,
         70:102
      };

      private var pad:Sprite;

      private var toggle:VolumeButton;

      private var bst:Stage;

      private var pressed:uint = 0;

      private var touches:Object = {};

      private var tst:Stage;

      public function GameKeys()
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:VolumeButton = null;
         super();
         var _loc5_:int = int(Mobile.touchPx(15));
         var _loc6_:int = int(Mobile.touchPx(10));
         var _loc7_:int = int(Mobile.touchPx(7));
         _loc1_ = Math.max(6,Math.round(_loc6_ / 6));
         _loc2_ = 960 - EDGE;
         this.toggle = new VolumeButton(_loc5_,_loc7_,"Controls",13);
         this.toggle.x = _loc2_ - _loc5_;
         this.toggle.y = BOTTOM - _loc7_;
         this.toggle.addEventListener(MouseEvent.CLICK,this.onToggle,false,0,true);
         addChild(this.toggle);
         this.pad = new Sprite();
         addChild(this.pad);
         var _loc8_:VolumeButton = this.keyBtn("Space",Keyboard.SPACE,_loc5_,_loc6_,14);
         _loc8_.x = _loc2_ - _loc5_;
         _loc8_.y = this.toggle.y - _loc1_ - _loc6_;
         var _loc9_:VolumeButton = this.keyBtn("Enter",Keyboard.ENTER,_loc5_,_loc6_,14);
         _loc9_.x = _loc2_ - _loc5_;
         _loc9_.y = _loc8_.y - _loc1_ - _loc6_;
         var _loc10_:int = int(Mobile.touchPx(9));
         var _loc11_:int = Math.round(_loc10_ * 1.4);
         var _loc12_:int = _loc2_;
         var _loc13_:* = int(ROW.length - 1);
         while(_loc13_ >= 0)
         {
            _loc3_ = ROW[_loc13_][0] == "Ctrl" ? _loc11_ : _loc10_;
            _loc12_ -= _loc3_;
            _loc4_ = this.keyBtn(ROW[_loc13_][0],ROW[_loc13_][1],_loc3_,_loc10_,14);
            _loc4_.x = _loc12_;
            _loc4_.y = _loc9_.y - _loc1_ - _loc10_;
            _loc12_ -= _loc1_;
            _loc13_--;
         }
         this.pad.visible = false;
      }

      public static function get active() : Boolean
      {
         return _active;
      }

      public static function get controlsOn() : Boolean
      {
         return Boolean(_active) && Boolean(_on);
      }

      public static function setActive(param1:Boolean, param2:DisplayObjectContainer = null, param3:MovieClip = null) : void
      {
         var _loc1_:String = null;
         if(param3 != null)
         {
            game = param3;
         }
         if(param1 && Boolean(_active))
         {
            _loc1_ = frontKey();
            if(_loc1_ != gameKey)
            {
               gameKey = _loc1_;
               applyOn(saved(_loc1_));
            }
            return;
         }
         if(param1 == _active)
         {
            return;
         }
         _active = param1;
         MoveInput.stopAll();
         if(param1)
         {
            if(inst == null)
            {
               inst = new GameKeys();
            }
            if(param2 != null)
            {
               param2.addChild(inst);
               st = param2.stage;
            }
            if(st != null)
            {
               st.addEventListener(Event.DEACTIVATE,onDeactivate,false,0,true);
            }
            gameKey = frontKey();
            applyOn(saved(gameKey));
         }
         else
         {
            if(st != null)
            {
               st.removeEventListener(Event.DEACTIVATE,onDeactivate);
            }
            releaseAll();
            if(inst != null)
            {
               inst.endBtn();
               if(inst.parent != null)
               {
                  inst.parent.removeChild(inst);
               }
            }
            gameKey = null;
         }
      }

      private static function frontKey() : String
      {
         var _loc1_:Object = null;
         try
         {
            _loc1_ = game.world;
            if(_loc1_.frontFile != null)
            {
               return String(_loc1_.frontFile);
            }
            return "map:" + _loc1_.strMapName;
         }
         catch(e:Error)
         {
         }
         return "?";
      }

      private static function prefs() : Object
      {
         var _loc1_:Object = null;
         try
         {
            _loc1_ = game.litePreference.data;
            if(_loc1_.dOptions == null)
            {
               _loc1_.dOptions = {};
            }
            if(_loc1_.dOptions[PREF] == null)
            {
               _loc1_.dOptions[PREF] = {};
            }
            return _loc1_.dOptions[PREF];
         }
         catch(e:Error)
         {
         }
         return null;
      }

      private static function saved(param1:String) : Boolean
      {
         var _loc1_:Object = prefs();
         return _loc1_ != null && _loc1_[param1] == true;
      }

      private static function applyOn(param1:Boolean) : void
      {
         _on = param1;
         if(inst == null)
         {
            return;
         }
         if(!param1)
         {
            inst.endBtn();
            releaseAll();
         }
         inst.pad.visible = param1;
         inst.toggle.selected = param1;
         inst.toggle.label = param1 ? "Hide" : "Controls";
      }

      private static function onDeactivate(param1:Event) : void
      {
         if(inst != null)
         {
            inst.endBtn();
         }
         releaseAll();
      }

      public static function steer(param1:Number, param2:Number) : void
      {
         if(!_active)
         {
            return;
         }
         setKey(Keyboard.LEFT,param1 < -ON);
         setKey(Keyboard.RIGHT,param1 > ON);
         setKey(Keyboard.UP,param2 < -ON);
         setKey(Keyboard.DOWN,param2 > ON);
      }

      private static function setKey(param1:uint, param2:Boolean) : void
      {
         var _loc1_:InteractiveObject = null;
         if(param2 == (held[param1] != null))
         {
            return;
         }
         if(param2)
         {
            held[param1] = target();
            fire(KeyboardEvent.KEY_DOWN,param1,held[param1]);
            armRepeat();
         }
         else
         {
            _loc1_ = held[param1];
            delete held[param1];
            fire(KeyboardEvent.KEY_UP,param1,_loc1_);
         }
      }

      private static function releaseAll() : void
      {
         var _loc1_:String = null;
         for(_loc1_ in held)
         {
            fire(KeyboardEvent.KEY_UP,uint(_loc1_),held[_loc1_]);
         }
         held = {};
         if(repeat != null)
         {
            repeat.stop();
         }
      }

      private static function armRepeat() : void
      {
         if(repeat == null)
         {
            repeat = new Timer(REPEAT_DELAY);
            repeat.addEventListener(TimerEvent.TIMER,onRepeat,false,0,true);
         }
         repeat.delay = REPEAT_DELAY;
         repeat.reset();
         repeat.start();
      }

      private static function onRepeat(param1:TimerEvent) : void
      {
         var _loc1_:String = null;
         var _loc2_:Boolean = false;
         for(_loc1_ in held)
         {
            _loc2_ = true;
            fire(KeyboardEvent.KEY_DOWN,uint(_loc1_),held[_loc1_]);
         }
         if(!_loc2_ || !_active)
         {
            repeat.stop();
            return;
         }
         repeat.delay = REPEAT_MS;
      }

      private static function target() : InteractiveObject
      {
         if(st == null)
         {
            return null;
         }
         return st.focus != null ? st.focus : st;
      }

      private static function fire(param1:String, param2:uint, param3:InteractiveObject) : void
      {
         if(param3 == null)
         {
            param3 = target();
         }
         if(param3 == null)
         {
            return;
         }
         var _loc1_:uint = chars[param2] != null ? uint(chars[param2]) : 0;
         var _loc2_:Boolean = held[Keyboard.CONTROL] != null || param2 == Keyboard.CONTROL && param1 == KeyboardEvent.KEY_DOWN;
         firing = true;
         MoveInput.synth = true;
         try
         {
            param3.dispatchEvent(new KeyboardEvent(param1,true,false,_loc1_,param2,0,_loc2_));
         }
         catch(e:Error)
         {
         }
         MoveInput.synth = false;
         firing = false;
      }

      private function onToggle(param1:MouseEvent) : void
      {
         applyOn(!_on);
         var _loc1_:Object = prefs();
         if(_loc1_ == null || gameKey == null)
         {
            return;
         }
         if(_on)
         {
            _loc1_[gameKey] = true;
         }
         else
         {
            delete _loc1_[gameKey];
         }
         try
         {
            game.litePreference.flush();
         }
         catch(err:Error)
         {
         }
      }

      private function keyBtn(param1:String, param2:uint, param3:int, param4:int, param5:int) : VolumeButton
      {
         var _loc1_:VolumeButton = new VolumeButton(param3,param4,param1,param5);
         _loc1_.name = String(param2);
         _loc1_.addEventListener(MouseEvent.MOUSE_DOWN,this.onBtnDown,false,0,true);
         if(Multitouch.supportsTouchEvents)
         {
            _loc1_.addEventListener(TouchEvent.TOUCH_BEGIN,this.onBtnTouch,false,0,true);
         }
         this.pad.addChild(_loc1_);
         return _loc1_;
      }

      private function onBtnDown(param1:MouseEvent) : void
      {
         if(stage == null)
         {
            return;
         }
         this.endMouse();
         this.pressed = uint(VolumeButton(param1.currentTarget).name);
         this.bst = stage;
         this.bst.addEventListener(MouseEvent.MOUSE_UP,this.onBtnUp,false,0,true);
         setKey(this.pressed,true);
      }

      private function onBtnUp(param1:MouseEvent) : void
      {
         this.endMouse();
      }

      private function onBtnTouch(param1:TouchEvent) : void
      {
         if(param1.isPrimaryTouchPoint || stage == null)
         {
            return;
         }
         var _loc1_:uint = uint(VolumeButton(param1.currentTarget).name);
         this.touches[param1.touchPointID] = _loc1_;
         if(this.tst == null)
         {
            this.tst = stage;
            this.tst.addEventListener(TouchEvent.TOUCH_END,this.onTouchEnd,false,0,true);
         }
         setKey(_loc1_,true);
      }

      private function onTouchEnd(param1:TouchEvent) : void
      {
         var _loc1_:* = this.touches[param1.touchPointID];
         if(_loc1_ == null)
         {
            return;
         }
         delete this.touches[param1.touchPointID];
         setKey(uint(_loc1_),false);
      }

      private function endBtn() : void
      {
         var _loc1_:String = null;
         for(_loc1_ in this.touches)
         {
            setKey(uint(this.touches[_loc1_]),false);
         }
         this.touches = {};
         if(this.tst != null)
         {
            this.tst.removeEventListener(TouchEvent.TOUCH_END,this.onTouchEnd);
            this.tst = null;
         }
         this.endMouse();
      }

      private function endMouse() : void
      {
         var _loc1_:uint = 0;
         if(this.bst != null)
         {
            this.bst.removeEventListener(MouseEvent.MOUSE_UP,this.onBtnUp);
            this.bst = null;
         }
         if(this.pressed != 0)
         {
            _loc1_ = uint(this.pressed);
            this.pressed = 0;
            setKey(_loc1_,false);
         }
      }
   }
}
