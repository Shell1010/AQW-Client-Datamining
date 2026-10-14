package liteAssets.mobile
{
   import flash.display.MovieClip;
   import flash.display.Stage;
   import flash.events.*;
   import flash.system.*;
   import flash.ui.*;

   public class GamePad
   {

      private static var game:MovieClip;

      private static var stage:Stage;

      private static var input:GameInput;

      private static var binds:Vector.<String>;

      private static var onCapture:Function;

      private static var baseline:Object;

      public static const ACTIONS:Vector.<String> = Vector.<String>(["Auto Attack","Skill 1","Skill 2","Skill 3","Skill 4","Skill 5","Target Random Monster","Cancel Target","Options","Inventory","Dash"]);

      private static const DEAD:Number = 0.22;

      private static const PRESS:Number = 0.5;

      private static const NB:int = 11;

      private static const SX:int = 0;

      private static const SY:int = 1;

      private static const DU:int = 2;

      private static const DD:int = 3;

      private static const DL:int = 4;

      private static const DR:int = 5;

      private static const HX:int = 6;

      private static const HY:int = 7;

      private static const MOVE_N:int = 8;

      private static const MOVE_A:Vector.<String> = Vector.<String>(["AXIS_0","AXIS_1","BUTTON_19","BUTTON_20","BUTTON_21","BUTTON_22","AXIS_15","AXIS_16"]);

      private static const MOVE_D:Vector.<String> = Vector.<String>(["AXIS_0","AXIS_1","BUTTON_16","BUTTON_17","BUTTON_18","BUTTON_19",null,null]);

      private static const DEF_A:Vector.<String> = Vector.<String>(["BUTTON_96","BUTTON_99","BUTTON_100","BUTTON_97","BUTTON_103","BUTTON_102","BUTTON_105","BUTTON_104","BUTTON_108","BUTTON_109","BUTTON_106"]);

      private static const DEF_D:Vector.<String> = Vector.<String>(["BUTTON_4","BUTTON_6","BUTTON_7","BUTTON_5","BUTTON_9","BUTTON_8","BUTTON_11","BUTTON_10","BUTTON_13","BUTTON_12","BUTTON_14"]);

      private static const UNALIAS_A:Object = {
         "AXIS_17":"BUTTON_104",
         "AXIS_18":"BUTTON_105"
      };

      private static const NAMES_A:Object = {
         "BUTTON_96":"A",
         "BUTTON_97":"B",
         "BUTTON_99":"X",
         "BUTTON_100":"Y",
         "BUTTON_102":"LB",
         "BUTTON_103":"RB",
         "BUTTON_104":"LT",
         "BUTTON_105":"RT",
         "BUTTON_106":"L3",
         "BUTTON_107":"R3",
         "BUTTON_108":"Start",
         "BUTTON_109":"Back"
      };

      private static const NAMES_D:Object = {
         "BUTTON_4":"A",
         "BUTTON_5":"B",
         "BUTTON_6":"X",
         "BUTTON_7":"Y",
         "BUTTON_8":"LB",
         "BUTTON_9":"RB",
         "BUTTON_10":"LT",
         "BUTTON_11":"RT",
         "BUTTON_12":"Back",
         "BUTTON_13":"Start",
         "BUTTON_14":"L3",
         "BUTTON_15":"R3"
      };

      private static var devices:Vector.<GameInputDevice> = new Vector.<GameInputDevice>();

      private static var moves:Vector.<Vector.<GameInputControl>> = new Vector.<Vector.<GameInputControl>>();

      private static var acts:Vector.<Array> = new Vector.<Array>();

      private static var android:Boolean = false;

      private static var polling:Boolean = false;

      private static var held:Vector.<Boolean> = new Vector.<Boolean>(NB,true);

      private static var down:Vector.<Boolean> = new Vector.<Boolean>(NB,true);

      private static var codes:Vector.<int> = new Vector.<int>(NB,true);

      public static var suspended:Boolean = false;

      public function GamePad()
      {
         super();
      }

      public static function init(param1:MovieClip) : void
      {
         if(param1 == null || param1.stage == null || !GameInput.isSupported)
         {
            return;
         }
         stop();
         game = param1;
         stage = param1.stage;
         android = (Capabilities.manufacturer + " " + Capabilities.version).indexOf("Android") >= 0;
         loadBinds();
         if(input == null)
         {
            input = new GameInput();
            input.addEventListener(GameInputEvent.DEVICE_ADDED,onAdded);
            input.addEventListener(GameInputEvent.DEVICE_REMOVED,onRemoved);
            input.addEventListener(GameInputEvent.DEVICE_UNUSABLE,onRemoved);
         }
         var _loc1_:int = 0;
         while(_loc1_ < GameInput.numDevices)
         {
            add(GameInput.getDeviceAt(_loc1_));
            _loc1_++;
         }
      }

      public static function stop() : void
      {
         cancelCapture();
         devices.length = 0;
         moves.length = 0;
         acts.length = 0;
         idle();
      }

      public static function get connectedName() : String
      {
         return devices.length > 0 ? devices[0].name : null;
      }

      public static function bindOf(param1:int) : String
      {
         if(binds == null)
         {
            loadBinds();
         }
         return binds[param1];
      }

      public static function label(param1:String) : String
      {
         if(param1 == null)
         {
            return "None";
         }
         var _loc1_:Object = android ? NAMES_A : NAMES_D;
         if(_loc1_[param1] != null)
         {
            return _loc1_[param1];
         }
         if(param1.indexOf("BUTTON_") == 0)
         {
            return "Button " + param1.substr(7);
         }
         return param1;
      }

      public static function setBind(param1:int, param2:String) : void
      {
         if(binds == null)
         {
            loadBinds();
         }
         var _loc1_:String = binds[param1];
         var _loc2_:int = 0;
         while(_loc2_ < NB)
         {
            if(_loc2_ != param1 && binds[_loc2_] == param2)
            {
               binds[_loc2_] = _loc1_;
            }
            _loc2_++;
         }
         binds[param1] = param2;
         saveBinds();
         remap();
      }

      public static function resetBinds() : void
      {
         binds = (android ? DEF_A : DEF_D).concat();
         saveBinds();
         remap();
      }

      public static function capture(param1:Function) : void
      {
         onCapture = param1;
         baseline = null;
      }

      public static function cancelCapture() : void
      {
         onCapture = null;
         baseline = null;
      }

      private static function prefKey() : String
      {
         return android ? "padBindsA" : "padBindsD";
      }

      private static function loadBinds() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Vector.<Boolean> = null;
         var _loc3_:int = 0;
         var _loc4_:* = undefined;
         var _loc5_:int = 0;
         binds = (android ? DEF_A : DEF_D).concat();
         try
         {
            _loc1_ = game.litePreference.data.dOptions[prefKey()];
            if(_loc1_ == null)
            {
               return;
            }
            _loc2_ = new Vector.<Boolean>(NB,true);
            _loc3_ = 0;
            while(_loc3_ < NB)
            {
               _loc4_ = _loc1_[ACTIONS[_loc3_]];
               if(_loc4_ is String && String(_loc4_).length > 0)
               {
                  binds[_loc3_] = String(_loc4_);
                  _loc2_[_loc3_] = true;
               }
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < NB)
            {
               if(!(_loc2_[_loc3_] || binds[_loc3_] == null))
               {
                  _loc5_ = 0;
                  while(_loc5_ < NB)
                  {
                     if(_loc5_ != _loc3_ && _loc2_[_loc5_] && binds[_loc5_] == binds[_loc3_])
                     {
                        binds[_loc3_] = null;
                        break;
                     }
                     _loc5_++;
                  }
               }
               _loc3_++;
            }
         }
         catch(e:Error)
         {
         }
      }

      private static function saveBinds() : void
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         try
         {
            _loc1_ = {};
            _loc2_ = 0;
            while(_loc2_ < NB)
            {
               _loc1_[ACTIONS[_loc2_]] = binds[_loc2_];
               _loc2_++;
            }
            if(game.litePreference.data.dOptions == null)
            {
               game.litePreference.data.dOptions = {};
            }
            game.litePreference.data.dOptions[prefKey()] = _loc1_;
            game.litePreference.flush();
         }
         catch(e:Error)
         {
         }
      }

      private static function idle() : void
      {
         if(stage != null)
         {
            stage.removeEventListener(Event.ENTER_FRAME,onFrame);
         }
         polling = false;
         var _loc1_:int = 0;
         while(_loc1_ < NB)
         {
            down[_loc1_] = false;
            _loc1_++;
         }
         sync();
         MoveInput.setPad(0,0);
      }

      private static function onAdded(param1:GameInputEvent) : void
      {
         add(param1.device);
      }

      private static function onRemoved(param1:GameInputEvent) : void
      {
         var _loc1_:int = int(devices.indexOf(param1.device));
         if(_loc1_ < 0)
         {
            return;
         }
         devices.splice(_loc1_,1);
         moves.splice(_loc1_,1);
         acts.splice(_loc1_,1);
         notify("Controller disconnected");
         if(devices.length == 0)
         {
            idle();
         }
      }

      private static function add(param1:GameInputDevice) : void
      {
         if(param1 == null || stage == null || devices.indexOf(param1) >= 0)
         {
            return;
         }
         param1.enabled = true;
         devices.push(param1);
         moves.push(moveList(param1));
         acts.push(actList(param1));
         notify("Controller connected: " + param1.name);
         if(!polling)
         {
            polling = true;
            stage.addEventListener(Event.ENTER_FRAME,onFrame);
         }
      }

      private static function remap() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < devices.length)
         {
            acts[_loc1_] = actList(devices[_loc1_]);
            _loc1_++;
         }
      }

      private static function moveList(param1:GameInputDevice) : Vector.<GameInputControl>
      {
         var _loc1_:GameInputControl = null;
         var _loc2_:int = 0;
         var _loc3_:Vector.<String> = android ? MOVE_A : MOVE_D;
         var _loc4_:Vector.<GameInputControl> = new Vector.<GameInputControl>(MOVE_N,true);
         var _loc5_:int = 0;
         while(_loc5_ < param1.numControls)
         {
            _loc1_ = param1.getControlAt(_loc5_);
            _loc2_ = _loc3_.indexOf(_loc1_.id);
            if(_loc2_ >= 0)
            {
               _loc4_[_loc2_] = _loc1_;
            }
            _loc5_++;
         }
         return _loc4_;
      }

      private static function actList(param1:GameInputDevice) : Array
      {
         var _loc1_:GameInputControl = null;
         var _loc2_:String = null;
         if(binds == null)
         {
            loadBinds();
         }
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < NB)
         {
            _loc3_.push([]);
            _loc4_++;
         }
         var _loc5_:int = 0;
         while(_loc5_ < param1.numControls)
         {
            _loc1_ = param1.getControlAt(_loc5_);
            _loc2_ = Boolean(android) && UNALIAS_A[_loc1_.id] != null ? UNALIAS_A[_loc1_.id] : _loc1_.id;
            _loc4_ = 0;
            while(_loc4_ < NB)
            {
               if(binds[_loc4_] == _loc2_)
               {
                  _loc3_[_loc4_].push(_loc1_);
               }
               _loc4_++;
            }
            _loc5_++;
         }
         return _loc3_;
      }

      private static function bindable(param1:GameInputControl) : String
      {
         var _loc1_:String = param1.id;
         if(Boolean(android) && UNALIAS_A[_loc1_] != null)
         {
            return UNALIAS_A[_loc1_];
         }
         if(_loc1_.indexOf("BUTTON_") != 0)
         {
            return null;
         }
         if((android ? MOVE_A : MOVE_D).indexOf(_loc1_) >= 0)
         {
            return null;
         }
         return _loc1_;
      }

      private static function captureFrame() : void
      {
         var _loc1_:String = null;
         var _loc2_:GameInputDevice = null;
         var _loc3_:int = 0;
         var _loc4_:GameInputControl = null;
         var _loc5_:String = null;
         var _loc6_:Object = {};
         var _loc7_:String = null;
         var _loc8_:int = 0;
         while(_loc8_ < devices.length)
         {
            _loc2_ = devices[_loc8_];
            _loc3_ = 0;
            while(_loc3_ < _loc2_.numControls)
            {
               _loc4_ = _loc2_.getControlAt(_loc3_);
               if(_loc4_.value >= PRESS)
               {
                  _loc5_ = bindable(_loc4_);
                  if(_loc5_ != null)
                  {
                     _loc6_[_loc5_] = true;
                     if(baseline != null && baseline[_loc5_] != true && _loc7_ == null)
                     {
                        _loc7_ = _loc5_;
                     }
                  }
               }
               _loc3_++;
            }
            _loc8_++;
         }
         if(baseline == null)
         {
            baseline = _loc6_;
            return;
         }
         var _loc9_:Array = [];
         for(_loc1_ in baseline)
         {
            if(_loc6_[_loc1_] != true)
            {
               _loc9_.push(_loc1_);
            }
         }
         for each(_loc1_ in _loc9_)
         {
            delete baseline[_loc1_];
         }
         if(_loc7_ == null)
         {
            return;
         }
         var _loc10_:Function = onCapture;
         cancelCapture();
         if(_loc10_ != null)
         {
            _loc10_(_loc7_);
         }
      }

      private static function notify(param1:String) : void
      {
         trace(param1);
         try
         {
            game.chatF.pushMsg("server",param1,"SERVER","",0);
         }
         catch(e:Error)
         {
         }
      }

      private static function onFrame(param1:Event) : void
      {
         var _loc1_:int = 0;
         var _loc2_:Vector.<GameInputControl> = null;
         var _loc3_:Array = null;
         var _loc4_:GameInputControl = null;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         if(onCapture != null || suspended)
         {
            if(onCapture != null)
            {
               captureFrame();
            }
            _loc1_ = 0;
            while(_loc1_ < NB)
            {
               down[_loc1_] = false;
               _loc1_++;
            }
            MoveInput.setPad(0,0);
            sync();
            return;
         }
         var _loc8_:Boolean = stage.focus != null && "text" in stage.focus;
         var _loc9_:Number = 0;
         var _loc10_:Number = 0;
         var _loc11_:Number = 0;
         var _loc12_:Number = 0;
         _loc1_ = 0;
         while(_loc1_ < NB)
         {
            down[_loc1_] = false;
            _loc1_++;
         }
         var _loc13_:int = 0;
         while(_loc13_ < moves.length)
         {
            _loc2_ = moves[_loc13_];
            if(_loc2_[SX] != null)
            {
               _loc9_ += _loc2_[SX].value;
            }
            if(_loc2_[SY] != null)
            {
               _loc10_ += _loc2_[SY].value;
            }
            if(_loc2_[HX] != null)
            {
               _loc11_ += _loc2_[HX].value;
            }
            if(_loc2_[HY] != null)
            {
               _loc12_ += _loc2_[HY].value;
            }
            if(_loc2_[DU] != null && _loc2_[DU].value >= PRESS)
            {
               _loc12_--;
            }
            if(_loc2_[DD] != null && _loc2_[DD].value >= PRESS)
            {
               _loc12_ += 1;
            }
            if(_loc2_[DL] != null && _loc2_[DL].value >= PRESS)
            {
               _loc11_--;
            }
            if(_loc2_[DR] != null && _loc2_[DR].value >= PRESS)
            {
               _loc11_ += 1;
            }
            _loc3_ = acts[_loc13_];
            _loc1_ = 0;
            while(_loc1_ < NB)
            {
               for each(_loc4_ in _loc3_[_loc1_])
               {
                  if(_loc4_.value >= PRESS)
                  {
                     down[_loc1_] = true;
                  }
               }
               _loc1_++;
            }
            _loc13_++;
         }
         if(_loc8_)
         {
            _loc1_ = 0;
            while(_loc1_ < NB)
            {
               down[_loc1_] = false;
               _loc1_++;
            }
            MoveInput.setPad(0,0);
            sync();
            return;
         }
         var _loc14_:Number = Math.sqrt(_loc9_ * _loc9_ + _loc10_ * _loc10_);
         if(_loc14_ > 1)
         {
            _loc9_ /= _loc14_;
            _loc10_ /= _loc14_;
            _loc14_ = 1;
         }
         if(_loc14_ > DEAD)
         {
            _loc5_ = (_loc14_ - DEAD) / (1 - DEAD) / _loc14_;
            MoveInput.setPad(_loc9_ * _loc5_,_loc10_ * _loc5_);
         }
         else
         {
            _loc6_ = _loc11_ > PRESS ? 1 : (_loc11_ < -PRESS ? -1 : 0);
            _loc7_ = _loc12_ > PRESS ? 1 : (_loc12_ < -PRESS ? -1 : 0);
            if(_loc6_ != 0 && _loc7_ != 0)
            {
               MoveInput.setPad(_loc6_ * 0.70710678,_loc7_ * 0.70710678);
            }
            else
            {
               MoveInput.setPad(_loc6_,_loc7_);
            }
         }
         sync();
      }

      private static function sync() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         if(stage == null)
         {
            return;
         }
         var _loc3_:int = 0;
         while(_loc3_ < NB)
         {
            if(down[_loc3_] != held[_loc3_])
            {
               if(down[_loc3_])
               {
                  if(ACTIONS[_loc3_] == "Dash")
                  {
                     codes[_loc3_] = -1;
                     held[_loc3_] = true;
                     MoveInput.requestDash();
                  }
                  else
                  {
                     _loc1_ = game != null && game.litePreference != null ? game.litePreference.data.keys : null;
                     _loc2_ = _loc1_ != null ? _loc1_[ACTIONS[_loc3_]] : null;
                     if(_loc2_ != null)
                     {
                        codes[_loc3_] = int(_loc2_);
                        held[_loc3_] = true;
                        fire(KeyboardEvent.KEY_DOWN,codes[_loc3_]);
                     }
                  }
               }
               else
               {
                  held[_loc3_] = false;
                  if(codes[_loc3_] >= 0)
                  {
                     fire(KeyboardEvent.KEY_UP,codes[_loc3_]);
                  }
               }
            }
            _loc3_++;
         }
      }

      private static function fire(param1:String, param2:int) : void
      {
         MoveInput.synth = true;
         try
         {
            stage.dispatchEvent(new KeyboardEvent(param1,true,false,0,param2));
         }
         catch(e:Error)
         {
         }
         MoveInput.synth = false;
      }
   }
}
