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
         var _loc1_:Object = null;
         var _loc2_:Object = null;
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
            _loc1_ = game != null ? game.world : null;
            _loc2_ = _loc1_ != null && _loc1_.myAvatar != null ? _loc1_.myAvatar.pMC : null;
            if(_loc2_ == null)
            {
               return;
            }
            if(_loc2_.steering)
            {
               _loc2_.steerStop();
            }
            if(_loc2_.walking)
            {
               _loc2_.stopWalking();
               _loc1_.steerSend(int(_loc2_.x),int(_loc2_.y));
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
         var _loc1_:Point = null;
         var _loc2_:Point = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Point = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Boolean = false;
         var _loc9_:Number = Math.sqrt(param3 * param3 + param4 * param4);
         var _loc10_:DisplayObject = param1.CHARS as DisplayObject;
         dashing = false;
         if(_loc9_ == 0 || _loc10_ == null)
         {
            game.pDash = false;
            return false;
         }
         param3 /= _loc9_;
         param4 /= _loc9_;
         var _loc11_:Point = _loc10_.localToGlobal(new Point(param2.x,param2.y));
         var _loc12_:Number = Number(DASH_PX);
         if(param5)
         {
            _loc2_ = _loc10_.localToGlobal(new Point(param2.x + param3 * 100,param2.y + param4 * 100)).subtract(_loc11_);
            _loc3_ = _loc2_.length;
            _loc4_ = Number.MAX_VALUE;
            if(_loc3_ > 0)
            {
               _loc2_.x /= _loc3_;
               _loc2_.y /= _loc3_;
               if(_loc2_.x > 0.001)
               {
                  _loc4_ = Math.min(_loc4_,(959 - _loc11_.x) / _loc2_.x);
               }
               else if(_loc2_.x < -0.001)
               {
                  _loc4_ = Math.min(_loc4_,(1 - _loc11_.x) / _loc2_.x);
               }
               if(_loc2_.y > 0.001)
               {
                  _loc4_ = Math.min(_loc4_,(499 - _loc11_.y) / _loc2_.y);
               }
               else if(_loc2_.y < -0.001)
               {
                  _loc4_ = Math.min(_loc4_,(1 - _loc11_.y) / _loc2_.y);
               }
            }
            if(_loc4_ < 2 || _loc4_ == Number.MAX_VALUE)
            {
               game.pDash = false;
               return false;
            }
            _loc5_ = _loc10_.globalToLocal(new Point(_loc11_.x + _loc2_.x * _loc4_,_loc11_.y + _loc2_.y * _loc4_));
            _loc12_ = Math.sqrt((_loc5_.x - param2.x) * (_loc5_.x - param2.x) + (_loc5_.y - param2.y) * (_loc5_.y - param2.y));
         }
         var _loc13_:Number = Number(param2.x);
         var _loc14_:Number = Number(param2.y);
         var _loc15_:Number = 12;
         while(_loc15_ <= _loc12_)
         {
            _loc6_ = param2.x + param3 * _loc15_;
            _loc7_ = param2.y + param4 * _loc15_;
            if(!walkable(_loc6_,_loc7_,_loc13_,_loc14_))
            {
               break;
            }
            _loc13_ = _loc6_;
            _loc14_ = _loc7_;
            _loc15_ += 12;
         }
         if((_loc13_ - param2.x) * (_loc13_ - param2.x) + (_loc14_ - param2.y) * (_loc14_ - param2.y) < 576)
         {
            game.pDash = false;
            return false;
         }
         var _loc16_:Object = null;
         try
         {
            _loc8_ = Boolean(param2.mcChar.onMove);
            _loc16_ = param2.simulateTo(Math.round(_loc13_),Math.round(_loc14_),int(param1.WALKSPEED) * 3);
            param2.mcChar.onMove = _loc8_;
         }
         catch(e1:Error)
         {
         }
         if(_loc16_ == null || (_loc16_.x - param2.x) * (_loc16_.x - param2.x) + (_loc16_.y - param2.y) * (_loc16_.y - param2.y) < 576)
         {
            game.pDash = false;
            return false;
         }
         _loc1_ = _loc10_.localToGlobal(new Point(_loc13_,_loc14_));
         if(param2.steering)
         {
            param2.steerStop();
         }
         steered = false;
         fresh = false;
         var _loc17_:Boolean = false;
         game.pDash = true;
         try
         {
            param1.mvTimerHandler(null);
            param1.mvTimerKill();
            _loc17_ = Boolean(param1.walkToPoint(Math.max(1,Math.min(959,_loc1_.x)),Math.max(1,Math.min(499,_loc1_.y)),true));
         }
         catch(e:Error)
         {
         }
         game.pDash = false;
         dashing = _loc17_ && param5;
         dashX = param3;
         dashY = param4;
         return _loc17_;
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
         var _loc1_:Number = param1 ? param2 : 0;
         var _loc2_:Number = param1 ? param3 : 0;
         if(param1 == runOn && _loc1_ == runX && _loc2_ == runY)
         {
            return;
         }
         runOn = param1;
         runX = _loc1_;
         runY = _loc2_;
         recompute();
      }

      public static function get samples() : Array
      {
         var _loc1_:int = 0;
         var _loc2_:Array = [];
         var _loc3_:int = Math.min(ringN,RING);
         var _loc4_:int = ringN - _loc3_;
         while(_loc4_ < ringN)
         {
            _loc1_ = _loc4_ % RING;
            _loc2_.push(ringT[_loc1_] + "," + Math.round(ringX[_loc1_] * 10) / 10 + "," + Math.round(ringY[_loc1_] * 10) / 10 + "," + (ringS[_loc1_] ? 1 : 0));
            _loc4_++;
         }
         return _loc2_;
      }

      public static function smoothness() : String
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:int = Math.min(ringN,RING);
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Number = 0;
         var _loc12_:Number = 0;
         var _loc13_:int = ringN - _loc7_ + 1;
         while(_loc13_ < ringN)
         {
            _loc1_ = (_loc13_ - 1) % RING;
            _loc2_ = _loc13_ % RING;
            if(!(!ringS[_loc1_] || !ringS[_loc2_]))
            {
               _loc3_ = ringT[_loc2_] - ringT[_loc1_];
               if(_loc3_ > 0)
               {
                  _loc4_ = ringX[_loc2_] - ringX[_loc1_];
                  _loc5_ = ringY[_loc2_] - ringY[_loc1_];
                  _loc6_ = Math.sqrt(_loc4_ * _loc4_ + _loc5_ * _loc5_) * 1000 / _loc3_;
                  _loc8_++;
                  if(_loc6_ < 1)
                  {
                     _loc9_++;
                  }
                  if(_loc3_ > _loc10_)
                  {
                     _loc10_ = _loc3_;
                  }
                  _loc11_ += _loc6_;
                  _loc12_ += _loc6_ * _loc6_;
               }
            }
            _loc13_++;
         }
         if(_loc8_ == 0)
         {
            return "frames=0";
         }
         var _loc14_:Number = _loc11_ / _loc8_;
         var _loc15_:Number = Math.sqrt(Math.max(0,_loc12_ / _loc8_ - _loc14_ * _loc14_));
         return "frames=" + _loc8_ + " stalls=" + _loc9_ + " speed=" + Math.round(_loc14_) + "px/s sd=" + Math.round(_loc15_ * 10) / 10 + " maxDt=" + _loc10_ + "ms";
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
         var _loc1_:String = null;
         var _loc2_:Object = game != null && game.litePreference != null ? game.litePreference.data.keys : null;
         if(_loc2_ == null)
         {
            return false;
         }
         for(_loc1_ in _loc2_)
         {
            if(_loc2_[_loc1_] == param1 && _loc1_.indexOf("Move ") != 0)
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
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         if(game == null)
         {
            return;
         }
         if(runOn)
         {
            _loc1_ = Number(runX);
            _loc2_ = Number(runY);
         }
         else
         {
            _loc3_ = false;
            _loc4_ = false;
            _loc5_ = false;
            _loc6_ = false;
            for each(_loc7_ in down)
            {
               if(_loc7_ == 1)
               {
                  _loc3_ = true;
               }
               else if(_loc7_ == 2)
               {
                  _loc4_ = true;
               }
               else if(_loc7_ == 3)
               {
                  _loc5_ = true;
               }
               else if(_loc7_ == 4)
               {
                  _loc6_ = true;
               }
            }
            _loc1_ = (_loc6_ ? 1 : 0) - (_loc5_ ? 1 : 0) + stickX + padX;
            _loc2_ = (_loc4_ ? 1 : 0) - (_loc3_ ? 1 : 0) + stickY + padY;
         }
         var _loc8_:Number = Math.sqrt(_loc1_ * _loc1_ + _loc2_ * _loc2_);
         var _loc9_:Boolean = wantX != 0 || wantY != 0;
         if(_loc8_ < 0.05)
         {
            wantX = 0;
            wantY = 0;
            fresh = false;
            if(_loc9_)
            {
               release();
            }
            return;
         }
         _loc1_ /= _loc8_;
         _loc2_ /= _loc8_;
         if(!_loc9_ || _loc1_ * wantX + _loc2_ * wantY < 0.995)
         {
            fresh = true;
         }
         wantX = _loc1_;
         wantY = _loc2_;
         snapshotMap();
         start();
         var _loc10_:Object = game.world;
         if(_loc10_ != null && _loc10_.myAvatar != null && _loc10_.myAvatar.pMC != null)
         {
            tick(_loc10_,_loc10_.myAvatar.pMC);
         }
      }

      private static function snapshotMap() : void
      {
         var _loc1_:Object = game.world;
         mapName = _loc1_ != null ? _loc1_.strMapName : null;
         mapAvatar = _loc1_ != null && _loc1_.myAvatar != null ? _loc1_.myAvatar.pMC : null;
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
         var _loc1_:String = null;
         var _loc2_:int = 0;
         var _loc3_:Object = game != null ? game.world : null;
         var _loc4_:Object = _loc3_ != null && _loc3_.myAvatar != null ? _loc3_.myAvatar.pMC : null;
         if(_loc3_ == null || _loc4_ == null || _loc4_ != mapAvatar || _loc3_.strMapName != mapName)
         {
            if(wantX == 0 && wantY == 0)
            {
               drop();
               return;
            }
            _loc1_ = _loc3_ != null ? _loc3_.strMapName : null;
            if(_loc3_ == null || _loc4_ == null || _loc1_ == null || _loc1_ == "")
            {
               _loc2_ = int(getTimer());
               if(lostAt == 0)
               {
                  lostAt = _loc2_;
               }
               else if(_loc2_ - lostAt > GRACE_MS)
               {
                  drop();
               }
               return;
            }
            rebind(_loc3_,_loc4_);
         }
         lostAt = 0;
         record(_loc4_);
         if(finalOn)
         {
            sendFinal(_loc3_);
         }
         if(wantX == 0 && wantY == 0)
         {
            if(!finalOn)
            {
               halt();
            }
            return;
         }
         tick(_loc3_,_loc4_);
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
         var _loc1_:int = 0;
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
            _loc1_ = int(getTimer());
            if(settleAt == 0)
            {
               settleAt = _loc1_;
            }
            if(_loc1_ - settleAt < SYNC_MS)
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
         var _loc2_:int = int(getTimer());
         if(_loc2_ - lastSend < SYNC_MS)
         {
            return;
         }
         var _loc3_:Point = param2.steerAhead(LOOK);
         var _loc4_:int = int(_loc3_.x);
         var _loc5_:int = int(_loc3_.y);
         if(_loc4_ == sentX && _loc5_ == sentY)
         {
            lastSend = _loc2_;
         }
         else if(param1.steerSend(_loc4_,_loc5_))
         {
            sentX = _loc4_;
            sentY = _loc5_;
            lastSend = _loc2_;
         }
      }

      private static function release() : void
      {
         var _loc1_:Object = game != null ? game.world : null;
         var _loc2_:Object = _loc1_ != null && _loc1_.myAvatar != null ? _loc1_.myAvatar.pMC : null;
         if(_loc2_ == null || _loc2_ != mapAvatar || _loc1_.strMapName != mapName)
         {
            drop();
            return;
         }
         if(dashing)
         {
            dashing = false;
            if(_loc2_.walking)
            {
               _loc2_.stopWalking();
               if(Boolean(_loc1_.bitWalk) && Boolean(alive(_loc1_)))
               {
                  _loc1_.mvTimerKill();
                  queueFinal(_loc1_,_loc2_);
               }
            }
            return;
         }
         var _loc3_:Boolean = Boolean(steered);
         steered = false;
         if(!_loc3_ || !_loc2_.steering)
         {
            return;
         }
         _loc2_.steerStop();
         if(Boolean(_loc1_.bitWalk) && Boolean(alive(_loc1_)))
         {
            queueFinal(_loc1_,_loc2_);
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
         var _loc1_:Object = game != null ? game.world : null;
         var _loc2_:DisplayObject = _loc1_ != null ? _loc1_.CHARS as DisplayObject : null;
         if(_loc2_ == null)
         {
            return true;
         }
         ptTo.x = param1;
         ptTo.y = param2;
         ptFrom.x = param3;
         ptFrom.y = param4;
         var _loc3_:Point = _loc2_.localToGlobal(ptTo);
         var _loc4_:Point = _loc2_.localToGlobal(ptFrom);
         var _loc5_:Number = Number(outside(_loc3_));
         if(_loc5_ > 0 && _loc5_ >= outside(_loc4_))
         {
            return false;
         }
         refreshAreas(_loc1_.map as DisplayObjectContainer);
         if(areas.length == 0 || Boolean(inArea(_loc3_)))
         {
            return true;
         }
         return !inArea(_loc4_);
      }

      private static function outside(param1:Point) : Number
      {
         return Math.max(0,-param1.x,param1.x - 960) + Math.max(0,-param1.y,param1.y - 500);
      }

      private static function refreshAreas(param1:DisplayObjectContainer) : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = param1 is MovieClip ? int(MovieClip(param1).currentFrame) : 0;
         if(param1 == areaMap && _loc2_ == areaFrame)
         {
            return;
         }
         areaMap = param1;
         areaFrame = _loc2_;
         areas = [];
         if(param1 == null)
         {
            return;
         }
         var _loc3_:int = 0;
         for(; _loc3_ < param1.numChildren; _loc3_++)
         {
            _loc1_ = param1.getChildAt(_loc3_) as MovieClip;
            if(_loc1_ != null)
            {
               try
               {
                  if("walk" in _loc1_ && _loc1_.btnWalkingArea is DisplayObject)
                  {
                     areas.push(_loc1_.btnWalkingArea);
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
         var _loc1_:DisplayObject = null;
         var _loc2_:SimpleButton = null;
         var _loc3_:DisplayObject = null;
         var _loc4_:Point = null;
         var _loc5_:int = 0;
         while(_loc5_ < areas.length)
         {
            _loc1_ = areas[_loc5_];
            if(!(_loc1_ == null || _loc1_.stage == null || !_loc1_.parent.visible))
            {
               _loc2_ = _loc1_ as SimpleButton;
               _loc3_ = _loc2_ != null && _loc2_.hitTestState != null ? _loc2_.hitTestState : _loc1_;
               if(_loc3_ == _loc1_ || _loc3_.stage != null)
               {
                  if(_loc3_.hitTestPoint(param1.x,param1.y,true))
                  {
                     return true;
                  }
               }
               else
               {
                  _loc4_ = _loc1_.globalToLocal(param1);
                  if(_loc3_.hitTestPoint(_loc4_.x,_loc4_.y,true))
                  {
                     return true;
                  }
               }
            }
            _loc5_++;
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
