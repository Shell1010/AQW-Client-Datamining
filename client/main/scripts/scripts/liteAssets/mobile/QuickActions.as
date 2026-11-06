package liteAssets.mobile
{
   import flash.events.*;

   public class QuickActions
   {

      public static const OFF:int = 0;

      public static const TRAY:int = 1;

      public static const BUTTON:int = 2;

      public static const events:EventDispatcher = new EventDispatcher();

      private static const SKIP:Object = {
         "Auto Attack":1,
         "Skill 1":1,
         "Skill 2":1,
         "Skill 3":1,
         "Skill 4":1,
         "Skill 5":1,
         "Move Up":1,
         "Move Left":1,
         "Move Down":1,
         "Move Right":1,
         "World Camera\'s Hide":1
      };

      private static const SHORT:Object = {
         "Target Random Monster":"Target",
         "Cancel Target":"Untarget",
         "Travel Menu\'s Travel":"Travel",
         "Camera Tool":"Camera",
         "World Camera":"World Cam",
         "Quest Log":"Quests",
         "Friends List":"Friends",
         "Friendships UI":"Friendships",
         "Character Panel":"Character",
         "Player HP Bar":"HP Bars",
         "Stats Overview":"Stats",
         "Battle Analyzer":"Analyzer",
         "Battle Analyzer Toggle":"Analyze",
         "Custom Drops UI":"Drops",
         "Decline All Drops":"Decline All",
         "Hide Monsters":"Hide Mons",
         "@ Debugger - Cell Menu":"Cells",
         "@ Debugger - Packet Logger":"Packets"
      };

      public function QuickActions()
      {
         super();
      }

      public static function eligible(param1:String) : Boolean
      {
         if(param1 == "Custom Drops UI")
         {
            return !Mobile.useDropTray;
         }
         return SKIP[param1] == null;
      }

      public static function label(param1:String) : String
      {
         var _loc1_:String = SHORT[param1];
         return _loc1_ != null ? _loc1_ : param1;
      }

      private static function opts() : Object
      {
         var _loc1_:Object = null;
         try
         {
            _loc1_ = Mobile.game.litePreference.data;
            if(_loc1_.dOptions == null)
            {
               _loc1_.dOptions = {};
            }
            return _loc1_.dOptions;
         }
         catch(e:Error)
         {
         }
         return {};
      }

      private static function list(param1:String) : Array
      {
         var _loc1_:Object = opts();
         var _loc2_:Array = _loc1_[param1] as Array;
         if(_loc2_ == null)
         {
            _loc2_ = [];
            _loc1_[param1] = _loc2_;
         }
         return _loc2_;
      }

      public static function get tray() : Array
      {
         return list("qaTray");
      }

      public static function get buttons() : Array
      {
         return list("qaBtns");
      }

      public static function get left() : Boolean
      {
         return opts().qaLeft == true;
      }

      public static function set left(param1:Boolean) : void
      {
         if(left == param1)
         {
            return;
         }
         opts().qaLeft = param1;
         changed();
      }

      public static function get expanded() : Boolean
      {
         return opts().qaOpen == true;
      }

      public static function set expanded(param1:Boolean) : void
      {
         if(expanded == param1)
         {
            return;
         }
         opts().qaOpen = param1;
         flush();
      }

      public static function modeOf(param1:String) : int
      {
         if(tray.indexOf(param1) >= 0)
         {
            return TRAY;
         }
         if(buttons.indexOf(param1) >= 0)
         {
            return BUTTON;
         }
         return OFF;
      }

      public static function setMode(param1:String, param2:int) : void
      {
         var _loc1_:Object = null;
         if(modeOf(param1) == param2)
         {
            return;
         }
         var _loc2_:Array = tray;
         var _loc3_:Array = buttons;
         var _loc4_:int = _loc2_.indexOf(param1);
         if(_loc4_ >= 0)
         {
            _loc2_.splice(_loc4_,1);
         }
         _loc4_ = _loc3_.indexOf(param1);
         if(_loc4_ >= 0)
         {
            _loc3_.splice(_loc4_,1);
         }
         if(param2 == TRAY)
         {
            _loc2_.push(param1);
         }
         else if(param2 == BUTTON)
         {
            _loc3_.push(param1);
         }
         if(param2 != BUTTON)
         {
            _loc1_ = opts().posQaBtns;
            if(_loc1_ != null)
            {
               delete _loc1_[param1];
            }
         }
         changed();
      }

      public static function clear() : void
      {
         var _loc1_:Object = opts();
         _loc1_.qaTray = [];
         _loc1_.qaBtns = [];
         delete _loc1_.posQaBtns;
         changed();
      }

      public static function run(param1:String) : void
      {
         try
         {
            Mobile.game.runBind(param1);
         }
         catch(e:Error)
         {
         }
      }

      private static function changed() : void
      {
         flush();
         events.dispatchEvent(new Event(Event.CHANGE));
      }

      private static function flush() : void
      {
         try
         {
            Mobile.game.litePreference.flush();
         }
         catch(e:Error)
         {
         }
      }
   }
}
