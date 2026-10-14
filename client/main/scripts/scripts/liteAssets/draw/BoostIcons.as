package liteAssets.draw
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Rectangle;
   import flash.net.*;
   import flash.utils.*;

   public class BoostIcons extends MovieClip
   {

      private static const ORDER:Array = ["dmgBoost","classBoost","goldBoost","repBoost","xpBoost"];

      private static const ART:Object = {
         "dmgBoost":"damageBoost",
         "classBoost":"classBoost",
         "goldBoost":"goldBoost",
         "repBoost":"repBoost",
         "xpBoost":"xpBoost"
      };

      private static const DMG:Object = {
         "dmgall":"All",
         "undead":"Undead",
         "human":"Human",
         "chaos":"Chaos",
         "dragonkin":"Dragonkin",
         "orc":"Orc",
         "drakath":"Drakath",
         "elemental":"Elemental"
      };

      private static const GAP:int = 2;

      private static const GUIDE:String = "https://www.aq.com/lore/Guides/AQWBoosts";

      public var count:int = 0;

      private var game:MovieClip;

      private var tips:Object;

      public function BoostIcons(param1:MovieClip, param2:*, param3:int)
      {
         var _loc1_:Rectangle = null;
         var _loc2_:String = null;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         super();
         this.game = param1;
         this.tips = parse(param2);
         var _loc5_:Number = 0;
         for each(_loc2_ in ORDER)
         {
            if(this.tips[_loc2_] != null)
            {
               _loc4_ = this.make(ART[_loc2_]);
               if(_loc4_ != null)
               {
                  _loc4_.name = _loc2_;
                  _loc4_.width = param3;
                  _loc4_.height = param3;
                  addChild(_loc4_);
                  _loc1_ = _loc4_.getBounds(this);
                  _loc4_.x += _loc5_ - _loc1_.left;
                  _loc4_.y -= _loc1_.top;
                  _loc5_ += _loc1_.width + GAP;
                  _loc4_.addEventListener(MouseEvent.MOUSE_OVER,this.onOver,false,0,true);
                  _loc4_.addEventListener(MouseEvent.MOUSE_OUT,this.onOut,false,0,true);
                  ++this.count;
               }
            }
         }
         if(this.count == 0)
         {
            return;
         }
         _loc3_ = this.make("btnMoreInfo");
         if(_loc3_ == null)
         {
            return;
         }
         addChild(_loc3_);
         _loc1_ = _loc3_.getBounds(this);
         _loc3_.x += _loc5_ + 1 - _loc1_.left;
         _loc3_.y += Math.round((param3 - _loc1_.height) / 2) - _loc1_.top;
         _loc3_.addEventListener(MouseEvent.CLICK,this.onMore,false,0,true);
      }

      public static function parse(param1:*) : Object
      {
         var _loc1_:String = null;
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:Object = {};
         if(param1 == null || param1 is Number || String(param1).indexOf(":") < 0)
         {
            return _loc5_;
         }
         for each(_loc1_ in String(param1).split(","))
         {
            _loc2_ = _loc1_.split(":");
            if(!(_loc2_.length < 2 || Boolean(isNaN(Number(_loc2_[1])))))
            {
               _loc3_ = String(Math.round((Number(_loc2_[1]) - 1) * 100));
               _loc4_ = String(_loc2_[0]).toLowerCase();
               if(_loc4_ in DMG)
               {
                  _loc5_.dmgBoost = (_loc5_.dmgBoost != null ? _loc5_.dmgBoost + "\n" : "") + DMG[_loc4_] + " +" + _loc3_ + "%";
               }
               else if(_loc4_ == "cp")
               {
                  _loc5_.classBoost = "Class Points +" + _loc3_ + "%";
               }
               else if(_loc4_ == "gold")
               {
                  _loc5_.goldBoost = "Gold +" + _loc3_ + "%";
               }
               else if(_loc4_ == "rep")
               {
                  _loc5_.repBoost = "Reputation +" + _loc3_ + "%";
               }
               else if(_loc4_ == "exp")
               {
                  _loc5_.xpBoost = "Experience +" + _loc3_ + "%";
               }
            }
         }
         return _loc5_;
      }

      private function make(param1:String) : MovieClip
      {
         try
         {
            return new (getDefinitionByName(param1) as Class)() as MovieClip;
         }
         catch(e:Error)
         {
         }
         return null;
      }

      private function onOver(param1:MouseEvent) : void
      {
         var _loc1_:DisplayObject = param1.currentTarget as DisplayObject;
         if(_loc1_ != null && this.game != null && this.game.ui != null)
         {
            this.game.ui.ToolTip.openWith({"str":this.tips[_loc1_.name]});
         }
      }

      private function onOut(param1:MouseEvent) : void
      {
         if(this.game != null && this.game.ui != null)
         {
            this.game.ui.ToolTip.close();
         }
      }

      private function onMore(param1:MouseEvent) : void
      {
         navigateToURL(new URLRequest(GUIDE),"_blank");
      }
   }
}
