package liteAssets.mobile
{
   import flash.display.MovieClip;
   import flash.display.Stage;
   import flash.events.*;
   import flash.system.*;

   public class Mobile
   {

      public static var game:MovieClip;

      private static var hud:MobileHUD;

      private static var mmStage:Stage;

      public static const events:EventDispatcher = new EventDispatcher();

      private static var _active:Boolean = false;

      private static var hudOn:Boolean = false;

      private static var pxPerMm:Number = 0;

      private static const SIZES:Array = [1,0.9,0.8,0.7,0.6,0.5,1.2,1.1];

      public function Mobile()
      {
         super();
      }

      public static function init(param1:MovieClip) : void
      {
         game = param1;
         _active = compute();
         QtyTouch.init(param1);
      }

      public static function get isAIR() : Boolean
      {
         return Security.sandboxType == "application";
      }

      public static function get isTouchDevice() : Boolean
      {
         return isAIR || Capabilities.touchscreenType == TouchscreenType.FINGER;
      }

      public static function get mode() : String
      {
         var _loc1_:String = game != null && game.litePreference != null ? game.litePreference.data.sTouchMode : null;
         return _loc1_ == "on" || _loc1_ == "off" ? _loc1_ : "auto";
      }

      public static function setMode(param1:String) : void
      {
         if(param1 != "on" && param1 != "off")
         {
            param1 = "auto";
         }
         if(game != null && game.litePreference != null)
         {
            game.litePreference.data.sTouchMode = param1;
            try
            {
               game.litePreference.flush();
            }
            catch(e:Error)
            {
            }
         }
         var _loc1_:Boolean = Boolean(_active);
         _active = compute();
         if(_loc1_ != _active)
         {
            events.dispatchEvent(new Event(Event.CHANGE));
         }
      }

      public static function get active() : Boolean
      {
         return _active;
      }

      public static function get useDropTray() : Boolean
      {
         if(!_active)
         {
            return false;
         }
         try
         {
            return game.litePreference.data.dOptions["classicDropsMobile"] != true;
         }
         catch(e:Error)
         {
         }
         return true;
      }

      public static function touchPx(param1:Number = 9) : int
      {
         if(!isTouchDevice && !(mode == "on" && Capabilities.touchscreenType != TouchscreenType.NONE))
         {
            return 44;
         }
         var _loc1_:Number = pxPerMm > 0 ? Number(pxPerMm) : Number(measure());
         if(_loc1_ <= 0)
         {
            return 44;
         }
         return Math.min(96,Math.max(44,Math.round(param1 * _loc1_)));
      }

      public static function physPx(param1:Number) : Number
      {
         if(!isTouchDevice && !(mode == "on" && Capabilities.touchscreenType != TouchscreenType.NONE))
         {
            return 0;
         }
         var _loc1_:Number = pxPerMm > 0 ? Number(pxPerMm) : Number(measure());
         return _loc1_ > 0 ? param1 * _loc1_ : 0;
      }

      private static function measure() : Number
      {
         var _loc1_:Stage = game != null ? game.stage : null;
         if(_loc1_ != mmStage)
         {
            if(mmStage != null)
            {
               mmStage.removeEventListener(Event.RESIZE,onResize);
            }
            mmStage = _loc1_;
            if(_loc1_ != null)
            {
               _loc1_.addEventListener(Event.RESIZE,onResize,false,0,true);
            }
         }
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         if(_loc1_ != null)
         {
            try
            {
               _loc2_ = _loc1_.fullScreenWidth;
               _loc3_ = _loc1_.fullScreenHeight;
            }
            catch(e:Error)
            {
            }
            if(!(_loc2_ > 0 && _loc3_ > 0))
            {
               _loc2_ = _loc1_.stageWidth;
               _loc3_ = _loc1_.stageHeight;
            }
         }
         if(!(_loc2_ > 0 && _loc3_ > 0))
         {
            _loc2_ = Number(Capabilities.screenResolutionX);
            _loc3_ = Number(Capabilities.screenResolutionY);
         }
         var _loc4_:Number = Math.min(Math.max(_loc2_,_loc3_) / 960,Math.min(_loc2_,_loc3_) / 550);
         if(_loc4_ <= 0 || Capabilities.screenDPI <= 0)
         {
            return 0;
         }
         var _loc5_:Number = Capabilities.screenDPI / 25.4 / _loc4_;
         if(_loc1_ != null)
         {
            pxPerMm = _loc5_;
         }
         return _loc5_;
      }

      private static function onResize(param1:Event) : void
      {
         pxPerMm = 0;
      }

      public static function hudStart() : void
      {
         QtyTouch.init(game);
         hudOn = true;
         events.removeEventListener(Event.CHANGE,onChange);
         events.addEventListener(Event.CHANGE,onChange);
         syncHud();
      }

      public static function hudStop() : void
      {
         hudOn = false;
         events.removeEventListener(Event.CHANGE,onChange);
         syncHud();
      }

      private static function onChange(param1:Event) : void
      {
         syncHud();
      }

      public static function syncHud() : void
      {
         if(Boolean(hudOn) && Boolean(_active))
         {
            if(hud == null)
            {
               try
               {
                  hud = new MobileHUD(game);
               }
               catch(e:Error)
               {
                  hud = null;
               }
            }
         }
         else if(hud != null)
         {
            hud.destroy();
            hud = null;
         }
         if(Boolean(hudOn) && Boolean(_active))
         {
            HoldRun.start(game);
            LongPress.start(game);
            ActBarTouch.start(game);
         }
         else
         {
            HoldRun.stop();
            LongPress.stop();
            ActBarTouch.stop();
         }
      }

      public static function get uiScale() : Number
      {
         var _loc1_:Number = 1;
         try
         {
            _loc1_ = Number(game.litePreference.data.nMobileUI);
         }
         catch(e:Error)
         {
         }
         return _loc1_ >= 0.5 && _loc1_ <= 1.2 ? _loc1_ : 1;
      }

      public static function sizeLabel() : String
      {
         return "Mobile UI Size: " + Math.round(uiScale * 100) + "%";
      }

      public static function cycleSize() : String
      {
         var _loc1_:Number = Number(SIZES[(SIZES.indexOf(uiScale) + 1) % SIZES.length]);
         if(game != null && game.litePreference != null)
         {
            game.litePreference.data.nMobileUI = _loc1_;
            try
            {
               game.litePreference.flush();
            }
            catch(e:Error)
            {
            }
         }
         if(hud != null)
         {
            hud.destroy();
            hud = null;
         }
         syncHud();
         return sizeLabel();
      }

      private static function compute() : Boolean
      {
         var _loc1_:String = mode;
         return _loc1_ == "on" || _loc1_ == "auto" && isTouchDevice;
      }
   }
}
