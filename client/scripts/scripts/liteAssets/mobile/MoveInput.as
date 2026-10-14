package liteAssets.mobile
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;

   public class MoveInput
   {

      private static var game:MovieClip;

      private static var stage:Stage;

      private static var mapName:String;

      private static var mapAvatar:Object;

      private static var areaMap:DisplayObjectContainer;

      private static const SYNC_MS:int = 350;

      private static const LOOK:Number = 0.6;

      private static const FINAL_MS:int = 1600;

      private static const RING:int = 120;

      private static const GRACE_MS:int = 3000;

      private static const DASH_PX:int = 180;

      private static const DASH_KEEP:Number = 0.82;

      private static var down:Object = {};

      private static var stickX:Number = 0;

      private static var stickY:Number = 0;

      public static var synth:Boolean = false;

      private static var padX:Number = 0;

      private static var padY:Number = 0;

      private static var runOn:Boolean = false;

      private static var runX:Number = 0;

      private static var runY:Number = 0;

      private static var wantX:Number = 0;

      private static var wantY:Number = 0;

      private static var fresh:Boolean = false;

      private static var dashing:Boolean = false;

      private static var dashX:Number = 0;

      private static var dashY:Number = 0;

      private static var running:Boolean = false;

      private static var steered:Boolean = false;

      private static var lastSend:int = 0;

      private static var settling:Boolean = false;

      private static var settleAt:int = 0;

      private static var lostAt:int = 0;

      private static var sentX:int = int.MIN_VALUE;

      private static var sentY:int = int.MIN_VALUE;

      private static var finalOn:Boolean = false;

      private static var finalX:int = 0;

      private static var finalY:int = 0;

      private static var finalTS:int = 0;

      private static var areaFrame:int = -1;

      private static var areas:Array = [];

      private static var ringT:Vector.<int> = new Vector.<int>(RING,true);

      private static var ringX:Vector.<Number> = new Vector.<Number>(RING,true);

      private static var ringY:Vector.<Number> = new Vector.<Number>(RING,true);

      private static var ringS:Vector.<Boolean> = new Vector.<Boolean>(RING,true);

      private static var ringN:int = 0;

      private static var ptTo:Point = new Point();

      private static var ptFrom:Point = new Point();

      public function MoveInput()
      {
         super();
      }

      public static function init(param1:MovieClip) : void
      {
         if(param1 == null || param1.stage == null)
         {
            return;
         }
         if(stage != null)
         {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
            stage.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
            stage.removeEventListener(Event.DEACTIVATE,onDeactivate);
            stage.removeEventListener(FocusEvent.FOCUS_IN,onFocusIn,true);
         }
         game = param1;
         stage = param1.stage;
         stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown,false,0,true);
         stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp,false,0,true);
         stage.addEventListener(Event.DEACTIVATE,onDeactivate,false,0,true);
         stage.addEventListener(FocusEvent.FOCUS_IN,onFocusIn,true,0,true);
      }

      private static function onFocusIn(param1:FocusEvent) : void
      {
         if(!Mobile.active)
         {
            return;
         }
         var _loc1_:TextField = param1.target as TextField;
         if(_loc1_ != null && _loc1_.type == TextFieldType.INPUT)
         {
            stopAll();
         }
      }

      public static function stopAll() : void
      {
         var _loc2_:Object = null;
         var _loc1_:Object = null;
         down = {};
         stickX = 0;
         stickY = 0;
         padX = 0;
         padY = 0;
         runOn = false;
         runX = 0;
         runY = 0;
         recompute();
         try
         {
            _loc2_ = game != null ? game.world : null;
            _loc1_ = _loc2_ != null && _loc2_.myAvatar != null ? _loc2_.myAvatar.pMC : null;
            if(_loc1_ == null)
            {
               return;
            }
            if(_loc1_.steering)
            {
               _loc1_.steerStop();
            }
            if(_loc1_.walking)
            {
               _loc1_.stopWalking();
               _loc2_.steerSend(int(_loc1_.x),int(_loc1_.y));
            }
         }
         catch(err:Error)
         {
         }
      }

      public static function dashReady(param1:Object = null) : Boolean
      {
         var _loc1_:Object = null;
         try
         {
            if(param1 == null)
            {
               param1 = game.world;
            }
            _loc1_ = param1.uoTree[param1.myAvatar.pnm];
            if(!_loc1_.sta.$dsh)
            {
               _loc1_.sta.$dsh = 100;
            }
            return param1.myAvatar.dataLeaf.intSP >= _loc1_.sta.$dsh;
         }
         catch(e:Error)
         {
         }
         return false;
      }

      public static function requestDash() : Boolean
      {
         var dx:Number;
         var dy:Number;
         var w:Object = game != null ? game.world : null;
         var p:Object = w != null && w.myAvatar != null ? w.myAvatar.pMC : null;
         if(p == null || !canMove(w) || !dashReady(w))
         {
            return false;
         }
         dx = Number(wantX);
         dy = Number(wantY);
         if(dx == 0 && dy == 0)
         {
            try
            {
               dx = p.mcChar.scaleX < 0 ? -1 : 1;
            }
            catch(e:Error)
            {
               dx = 1;
            }
         }
         return lunge(w,p,dx,dy,wantX != 0 || wantY != 0);
      }

      private static function lunge(param1:Object, param2:Object, param3:Number, param4:Number, param5:Boolean) : Boolean
      {
         var _loc3_:Point = null;
         var _loc4_:Point = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Point = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Boolean = false;
         var _loc11_:Number = Math.sqrt(param3 * param3 + param4 * param4);
         var _loc12_:DisplayObject = param1.CHARS as DisplayObject;
         dashing = false;
         if(_loc11_ == 0 || _loc12_ == null)
         {
            game.pDash = false;
            return false;
         }
         param3 /= _loc11_;
         param4 /= _loc11_;
         var _loc13_:Point = _loc12_.localToGlobal(new Point(param2.x,param2.y));
         var _loc14_:Number = Number(DASH_PX);
         if(param5)
         {
            _loc4_ = _loc12_.localToGlobal(new Point(param2.x + param3 * 100,param2.y + param4 * 100)).subtract(_loc13_);
            _loc5_ = _loc4_.length;
            _loc6_ = Number.MAX_VALUE;
            if(_loc5_ > 0)
            {
               _loc4_.x /= _loc5_;
               _loc4_.y /= _loc5_;
               if(_loc4_.x > 0.001)
               {
                  _loc6_ = Math.min(_loc6_,(959 - _loc13_.x) / _loc4_.x);
               }
               else if(_loc4_.x < -0.001)
               {
                  _loc6_ = Math.min(_loc6_,(1 - _loc13_.x) / _loc4_.x);
               }
               if(_loc4_.y > 0.001)
               {
                  _loc6_ = Math.min(_loc6_,(499 - _loc13_.y) / _loc4_.y);
               }
               else if(_loc4_.y < -0.001)
               {
                  _loc6_ = Math.min(_loc6_,(1 - _loc13_.y) / _loc4_.y);
               }
            }
            if(_loc6_ < 2 || _loc6_ == Number.MAX_VALUE)
            {
               game.pDash = false;
               return false;
            }
            _loc7_ = _loc12_.globalToLocal(new Point(_loc13_.x + _loc4_.x * _loc6_,_loc13_.y + _loc4_.y * _loc6_));
            _loc14_ = Math.sqrt((_loc7_.x - param2.x) * (_loc7_.x - param2.x) + (_loc7_.y - param2.y) * (_loc7_.y - param2.y));
         }
         var _loc15_:Number = Number(param2.x);
         var _loc16_:Number = Number(param2.y);
         var _loc17_:Number = 12;
         while(_loc17_ <= _loc14_)
         {
            _loc8_ = param2.x + param3 * _loc17_;
            _loc9_ = param2.y + param4 * _loc17_;
            if(!walkable(_loc8_,_loc9_,_loc15_,_loc16_))
            {
               break;
            }
            _loc15_ = _loc8_;
            _loc16_ = _loc9_;
            _loc17_ += 12;
         }
         if((_loc15_ - param2.x) * (_loc15_ - param2.x) + (_loc16_ - param2.y) * (_loc16_ - param2.y) < 576)
         {
            game.pDash = false;
            return false;
         }
         var _loc18_:Object = null;
         try
         {
            _loc10_ = Boolean(param2.mcChar.onMove);
            _loc18_ = param2.simulateTo(Math.round(_loc15_),Math.round(_loc16_),int(param1.WALKSPEED) * 3);
            param2.mcChar.onMove = _loc10_;
         }
         catch(e1:Error)
         {
         }
         if(_loc18_ == null || (_loc18_.x - param2.x) * (_loc18_.x - param2.x) + (_loc18_.y - param2.y) * (_loc18_.y - param2.y) < 576)
         {
            game.pDash = false;
            return false;
         }
         _loc3_ = _loc12_.localToGlobal(new Point(_loc15_,_loc16_));
         if(param2.steering)
         {
            param2.steerStop();
         }
         steered = false;
         fresh = false;
         var _loc19_:Boolean = false;
         game.pDash = true;
         try
         {
            param1.mvTimerHandler(null);
            param1.mvTimerKill();
            _loc19_ = Boolean(param1.walkToPoint(Math.max(1,Math.min(959,_loc3_.x)),Math.max(1,Math.min(499,_loc3_.y)),true));
         }
         catch(e:Error)
         {
         }
         game.pDash = false;
         dashing = _loc19_ && param5;
         dashX = param3;
         dashY = param4;
         return _loc19_;
      }

      public static function setStick(param1:Number, param2:Number) : void
      {
         if(param1 == stickX && param2 == stickY)
         {
            return;
         }
         stickX = param1;
         stickY = param2;
         if(GameKeys.active)
         {
            GameKeys.steer(stickX + padX,stickY + padY);
         }
         else
         {
            recompute();
         }
      }

      public static function setPad(param1:Number, param2:Number) : void
      {
         if(param1 == padX && param2 == padY)
         {
            return;
         }
         padX = param1;
         padY = param2;
         if(GameKeys.active)
         {
            GameKeys.steer(stickX + padX,stickY + padY);
         }
         else
         {
            recompute();
         }
      }

      public static function setRun(param1:Boolean, param2:Number = 0, param3:Number = 0) : void
      {
         var _loc20_:Number = param1 ? param2 : 0;
         var _loc21_:Number = param1 ? param3 : 0;
         if(param1 == runOn && _loc20_ == runX && _loc21_ == runY)
         {
            return;
         }
         runOn = param1;
         runX = _loc20_;
         runY = _loc21_;
         recompute();
      }

      public static function get samples() : Array
      {
         var _loc20_:int = 0;
         var _loc2_:Array = [];
         var _loc1_:int = Math.min(ringN,RING);
         var _loc22_:int = ringN - _loc1_;
         while(_loc22_ < ringN)
         {
            _loc20_ = _loc22_ % RING;
            _loc2_.push(ringT[_loc20_] + "," + Math.round(ringX[_loc20_] * 10) / 10 + "," + Math.round(ringY[_loc20_] * 10) / 10 + "," + (ringS[_loc20_] ? 1 : 0));
            _loc22_++;
         }
         return _loc2_;
      }

      public static function smoothness() : String
      {
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc2_:int = Math.min(ringN,RING);
         var _loc1_:int = 0;
         var _loc22_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:Number = 0;
         var _loc11_:Number = 0;
         var _loc12_:int = ringN - _loc2_ + 1;
         while(_loc12_ < ringN)
         {
            _loc14_ = (_loc12_ - 1) % RING;
            _loc15_ = _loc12_ % RING;
            if(!(!ringS[_loc14_] || !ringS[_loc15_]))
            {
               _loc16_ = ringT[_loc15_] - ringT[_loc14_];
               if(_loc16_ > 0)
               {
                  _loc17_ = ringX[_loc15_] - ringX[_loc14_];
                  _loc18_ = ringY[_loc15_] - ringY[_loc14_];
                  _loc19_ = Math.sqrt(_loc17_ * _loc17_ + _loc18_ * _loc18_) * 1000 / _loc16_;
                  _loc1_++;
                  if(_loc19_ < 1)
                  {
                     _loc22_++;
                  }
                  if(_loc16_ > _loc20_)
                  {
                     _loc20_ = _loc16_;
                  }
                  _loc21_ += _loc19_;
                  _loc11_ += _loc19_ * _loc19_;
               }
            }
            _loc12_++;
         }
         if(_loc1_ == 0)
         {
            return "frames=0";
         }
         var _loc13_:Number = _loc21_ / _loc1_;
         var _loc3_:Number = Math.sqrt(Math.max(0,_loc11_ / _loc1_ - _loc13_ * _loc13_));
         return "frames=" + _loc1_ + " stalls=" + _loc22_ + " speed=" + Math.round(_loc13_) + "px/s sd=" + Math.round(_loc3_ * 10) / 10 + " maxDt=" + _loc20_ + "ms";
      }

      public static function clearSamples() : void
      {
         ringN = 0;
      }

      private static function axis(param1:int) : int
      {
         var _loc1_:Object = game != null && game.litePreference != null ? game.litePreference.data.keys : null;
         if(_loc1_ != null)
         {
            if(_loc1_["Move Up"] == param1)
            {
               return 1;
            }
            if(_loc1_["Move Down"] == param1)
            {
               return 2;
            }
            if(_loc1_["Move Left"] == param1)
            {
               return 3;
            }
            if(_loc1_["Move Right"] == param1)
            {
               return 4;
            }
         }
         switch(param1)
         {
            case 38:
               return 1;
            case 40:
               return 2;
            case 37:
               return 3;
            case 39:
               return 4;
            default:
               return 0;
         }
      }

      private static function isBound(param1:int) : Boolean
      {
         var _loc22_:String = null;
         var _loc1_:Object = game != null && game.litePreference != null ? game.litePreference.data.keys : null;
         if(_loc1_ == null)
         {
            return false;
         }
         for(_loc22_ in _loc1_)
         {
            if(_loc1_[_loc22_] == param1 && _loc22_.indexOf("Move ") != 0)
            {
               return true;
            }
         }
         return false;
      }

      private static function onKeyDown(param1:KeyboardEvent) : void
      {
         var _loc1_:int = int(axis(param1.keyCode));
         if(synth || _loc1_ == 0 || Boolean(down[param1.keyCode]))
         {
            return;
         }
         if(param1.ctrlKey || param1.altKey)
         {
            return;
         }
         if(stage.focus != null && "text" in stage.focus)
         {
            return;
         }
         if(isBound(param1.keyCode))
         {
            return;
         }
         down[param1.keyCode] = _loc1_;
         recompute();
      }

      private static function onKeyUp(param1:KeyboardEvent) : void
      {
         if(synth)
         {
            return;
         }
         if(!down[param1.keyCode])
         {
            return;
         }
         delete down[param1.keyCode];
         recompute();
      }

      private static function onDeactivate(param1:Event) : void
      {
         down = {};
         stickX = 0;
         stickY = 0;
         padX = 0;
         padY = 0;
         recompute();
      }

      private static function recompute() : void
      {
         var _loc2_:Number = NaN;
         var _loc1_:Number = NaN;
         var _loc11_:Boolean = false;
         var _loc12_:Boolean = false;
         var _loc13_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc14_:int = 0;
         if(game == null)
         {
            return;
         }
         if(runOn)
         {
            _loc2_ = Number(runX);
            _loc1_ = Number(runY);
         }
         else
         {
            _loc11_ = false;
            _loc12_ = false;
            _loc13_ = false;
            _loc3_ = false;
            for each(_loc14_ in down)
            {
               if(_loc14_ == 1)
               {
                  _loc11_ = true;
               }
               else if(_loc14_ == 2)
               {
                  _loc12_ = true;
               }
               else if(_loc14_ == 3)
               {
                  _loc13_ = true;
               }
               else if(_loc14_ == 4)
               {
                  _loc3_ = true;
               }
            }
            _loc2_ = (_loc3_ ? 1 : 0) - (_loc13_ ? 1 : 0) + stickX + padX;
            _loc1_ = (_loc12_ ? 1 : 0) - (_loc11_ ? 1 : 0) + stickY + padY;
         }
         var _loc22_:Number = Math.sqrt(_loc2_ * _loc2_ + _loc1_ * _loc1_);
         var _loc20_:Boolean = wantX != 0 || wantY != 0;
         if(_loc22_ < 0.05)
         {
            wantX = 0;
            wantY = 0;
            fresh = false;
            if(_loc20_)
            {
               release();
            }
            return;
         }
         _loc2_ /= _loc22_;
         _loc1_ /= _loc22_;
         if(!_loc20_ || _loc2_ * wantX + _loc1_ * wantY < 0.995)
         {
            fresh = true;
         }
         wantX = _loc2_;
         wantY = _loc1_;
         snapshotMap();
         start();
         var _loc21_:Object = game.world;
         if(_loc21_ != null && _loc21_.myAvatar != null && _loc21_.myAvatar.pMC != null)
         {
            tick(_loc21_,_loc21_.myAvatar.pMC);
         }
      }

      private static function snapshotMap() : void
      {
         var _loc2_:Object = game.world;
         mapName = _loc2_ != null ? _loc2_.strMapName : null;
         mapAvatar = _loc2_ != null && _loc2_.myAvatar != null ? _loc2_.myAvatar.pMC : null;
      }

      private static function start() : void
      {
         if(Boolean(running) || stage == null)
         {
            return;
         }
         running = true;
         stage.addEventListener(Event.ENTER_FRAME,onFrame);
      }

      private static function halt() : void
      {
         if(!running)
         {
            return;
         }
         running = false;
         stage.removeEventListener(Event.ENTER_FRAME,onFrame);
      }

      private static function drop() : void
      {
         if(mapAvatar != null)
         {
            try
            {
               if(mapAvatar.steering)
               {
                  mapAvatar.steerStop();
               }
            }
            catch(e:Error)
            {
            }
         }
         wantX = 0;
         wantY = 0;
         fresh = false;
         steered = false;
         dashing = false;
         finalOn = false;
         settling = false;
         lostAt = 0;
         halt();
      }

      private static function onFrame(param1:Event) : void
      {
         var _loc20_:String = null;
         var _loc21_:int = 0;
         var _loc1_:Object = game != null ? game.world : null;
         var _loc22_:Object = _loc1_ != null && _loc1_.myAvatar != null ? _loc1_.myAvatar.pMC : null;
         if(_loc1_ == null || _loc22_ == null || _loc22_ != mapAvatar || _loc1_.strMapName != mapName)
         {
            if(wantX == 0 && wantY == 0)
            {
               drop();
               return;
            }
            _loc20_ = _loc1_ != null ? _loc1_.strMapName : null;
            if(_loc1_ == null || _loc22_ == null || _loc20_ == null || _loc20_ == "")
            {
               _loc21_ = int(getTimer());
               if(lostAt == 0)
               {
                  lostAt = _loc21_;
               }
               else if(_loc21_ - lostAt > GRACE_MS)
               {
                  drop();
               }
               return;
            }
            rebind(_loc1_,_loc22_);
         }
         lostAt = 0;
         record(_loc22_);
         if(finalOn)
         {
            sendFinal(_loc1_);
         }
         if(wantX == 0 && wantY == 0)
         {
            if(!finalOn)
            {
               halt();
            }
            return;
         }
         tick(_loc1_,_loc22_);
      }

      private static function rebind(param1:Object, param2:Object) : void
      {
         if(mapAvatar != null && mapAvatar != param2)
         {
            try
            {
               if(mapAvatar.steering)
               {
                  mapAvatar.steerStop();
               }
            }
            catch(e:Error)
            {
            }
         }
         mapAvatar = param2;
         mapName = param1.strMapName;
         steered = false;
         dashing = false;
         finalOn = false;
         fresh = true;
         settling = true;
         settleAt = 0;
         sentX = int.MIN_VALUE;
         sentY = int.MIN_VALUE;
      }

      private static function tick(param1:Object, param2:Object) : void
      {
         var _loc12_:int = 0;
         if(param2 != mapAvatar || param1.strMapName != mapName)
         {
            return;
         }
         if(!canMove(param1))
         {
            if(param2.steering)
            {
               param2.steerStop();
               if(Boolean(steered) && Boolean(param1.bitWalk) && Boolean(alive(param1)))
               {
                  queueFinal(param1,param2);
               }
            }
            steered = false;
            if(Boolean(dashing) && Boolean(param1.bitWalk) && Boolean(alive(param1)))
            {
               if(param2.walking)
               {
                  param2.stopWalking();
               }
               param1.mvTimerKill();
               queueFinal(param1,param2);
            }
            dashing = false;
            settleAt = 0;
            return;
         }
         if(settling)
         {
            _loc12_ = int(getTimer());
            if(settleAt == 0)
            {
               settleAt = _loc12_;
            }
            if(_loc12_ - settleAt < SYNC_MS)
            {
               return;
            }
            settling = false;
         }
         if(Boolean(game.pDash) && (wantX != 0 || wantY != 0))
         {
            if(dashReady(param1))
            {
               lunge(param1,param2,wantX,wantY,true);
               return;
            }
            game.pDash = false;
         }
         if(dashing)
         {
            if(Boolean(param2.walking) && wantX * dashX + wantY * dashY >= DASH_KEEP)
            {
               return;
            }
            dashing = false;
            fresh = true;
            param1.mvTimerKill();
         }
         if(!param2.steering)
         {
            steered = false;
            if(Boolean(param2.walking) && !fresh)
            {
               return;
            }
            param2.steer(wantX,wantY,int(param1.WALKSPEED),walkable);
            fresh = false;
            if(!param2.steering)
            {
               return;
            }
            steered = true;
            finalOn = false;
            lastSend = getTimer() - SYNC_MS;
         }
         else
         {
            param2.steer(wantX,wantY,int(param1.WALKSPEED),walkable);
            fresh = false;
         }
         var _loc22_:int = int(getTimer());
         if(_loc22_ - lastSend < SYNC_MS)
         {
            return;
         }
         var _loc20_:Point = param2.steerAhead(LOOK);
         var _loc21_:int = int(_loc20_.x);
         var _loc11_:int = int(_loc20_.y);
         if(_loc21_ == sentX && _loc11_ == sentY)
         {
            lastSend = _loc22_;
         }
         else if(param1.steerSend(_loc21_,_loc11_))
         {
            sentX = _loc21_;
            sentY = _loc11_;
            lastSend = _loc22_;
         }
      }

      private static function release() : void
      {
         var _loc2_:Object = game != null ? game.world : null;
         var _loc1_:Object = _loc2_ != null && _loc2_.myAvatar != null ? _loc2_.myAvatar.pMC : null;
         if(_loc1_ == null || _loc1_ != mapAvatar || _loc2_.strMapName != mapName)
         {
            drop();
            return;
         }
         if(dashing)
         {
            dashing = false;
            if(_loc1_.walking)
            {
               _loc1_.stopWalking();
               if(Boolean(_loc2_.bitWalk) && Boolean(alive(_loc2_)))
               {
                  _loc2_.mvTimerKill();
                  queueFinal(_loc2_,_loc1_);
               }
            }
            return;
         }
         var _loc22_:Boolean = Boolean(steered);
         steered = false;
         if(!_loc22_ || !_loc1_.steering)
         {
            return;
         }
         _loc1_.steerStop();
         if(Boolean(_loc2_.bitWalk) && Boolean(alive(_loc2_)))
         {
            queueFinal(_loc2_,_loc1_);
         }
      }

      private static function queueFinal(param1:Object, param2:Object) : void
      {
         finalX = Math.round(param2.x);
         finalY = Math.round(param2.y);
         if(finalX == sentX && finalY == sentY)
         {
            return;
         }
         finalOn = true;
         finalTS = getTimer();
         sendFinal(param1);
         if(finalOn)
         {
            start();
         }
      }

      private static function sendFinal(param1:Object) : void
      {
         if(!param1.bitWalk || getTimer() - finalTS > FINAL_MS)
         {
            finalOn = false;
            return;
         }
         if(param1.steerSend(finalX,finalY))
         {
            sentX = finalX;
            sentY = finalY;
            finalOn = false;
         }
      }

      private static function canMove(param1:Object) : Boolean
      {
         if(!param1.bitWalk || !alive(param1))
         {
            return false;
         }
         try
         {
            return !param1.auraMoveBlocked();
         }
         catch(e:Error)
         {
         }
         return true;
      }

      private static function alive(param1:Object) : Boolean
      {
         var _loc1_:Object = param1.myAvatar.dataLeaf;
         return _loc1_ == null || !("intState" in _loc1_) || _loc1_.intState != 0;
      }

      private static function walkable(param1:Number, param2:Number, param3:Number, param4:Number) : Boolean
      {
         var _loc21_:Object = game != null ? game.world : null;
         var _loc11_:DisplayObject = _loc21_ != null ? _loc21_.CHARS as DisplayObject : null;
         if(_loc11_ == null)
         {
            return true;
         }
         ptTo.x = param1;
         ptTo.y = param2;
         ptFrom.x = param3;
         ptFrom.y = param4;
         var _loc12_:Point = _loc11_.localToGlobal(ptTo);
         var _loc13_:Point = _loc11_.localToGlobal(ptFrom);
         var _loc3_:Number = Number(outside(_loc12_));
         if(_loc3_ > 0 && _loc3_ >= outside(_loc13_))
         {
            return false;
         }
         refreshAreas(_loc21_.map as DisplayObjectContainer);
         if(areas.length == 0 || Boolean(inArea(_loc12_)))
         {
            return true;
         }
         return !inArea(_loc13_);
      }

      private static function outside(param1:Point) : Number
      {
         return Math.max(0,-param1.x,param1.x - 960) + Math.max(0,-param1.y,param1.y - 500);
      }

      private static function refreshAreas(param1:DisplayObjectContainer) : void
      {
         var _loc20_:MovieClip = null;
         var _loc1_:int = param1 is MovieClip ? int(MovieClip(param1).currentFrame) : 0;
         if(param1 == areaMap && _loc1_ == areaFrame)
         {
            return;
         }
         areaMap = param1;
         areaFrame = _loc1_;
         areas = [];
         if(param1 == null)
         {
            return;
         }
         var _loc22_:int = 0;
         for(; _loc22_ < param1.numChildren; _loc22_++)
         {
            _loc20_ = param1.getChildAt(_loc22_) as MovieClip;
            if(_loc20_ != null)
            {
               try
               {
                  if("walk" in _loc20_ && _loc20_.btnWalkingArea is DisplayObject)
                  {
                     areas.push(_loc20_.btnWalkingArea);
                  }
               }
               catch(e:Error)
               {
                  continue;
               }
            }
         }
      }

      private static function inArea(param1:Point) : Boolean
      {
         var _loc22_:DisplayObject = null;
         var _loc20_:SimpleButton = null;
         var _loc21_:DisplayObject = null;
         var _loc11_:Point = null;
         var _loc1_:int = 0;
         while(_loc1_ < areas.length)
         {
            _loc22_ = areas[_loc1_];
            if(!(_loc22_ == null || _loc22_.stage == null || !_loc22_.parent.visible))
            {
               _loc20_ = _loc22_ as SimpleButton;
               _loc21_ = _loc20_ != null && _loc20_.hitTestState != null ? _loc20_.hitTestState : _loc22_;
               if(_loc21_ == _loc22_ || _loc21_.stage != null)
               {
                  if(_loc21_.hitTestPoint(param1.x,param1.y,true))
                  {
                     return true;
                  }
               }
               else
               {
                  _loc11_ = _loc22_.globalToLocal(param1);
                  if(_loc21_.hitTestPoint(_loc11_.x,_loc11_.y,true))
                  {
                     return true;
                  }
               }
            }
            _loc1_++;
         }
         return false;
      }

      private static function record(param1:Object) : void
      {
         var _loc1_:int = ringN % RING;
         ringT[_loc1_] = getTimer();
         ringX[_loc1_] = param1.x;
         ringY[_loc1_] = param1.y;
         ringS[_loc1_] = param1.steering == true;
         ++ringN;
      }
   }
}
