package
{
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;

   public class interfaceMenu extends MovieClip
   {

      public var mcMenu:MovieClip;

      private var currentPos:Number;

      private var h:Number = 25.2;

      private var w:Number = 118.25;

      public var btnOpen:String = "";

      private var rootClass:MovieClip;

      public function interfaceMenu(param1:Array, param2:String, param3:MovieClip)
      {
         var _loc1_:MovieClip = null;
         var _loc2_:uint = 0;
         super();
         this.btnOpen = param2;
         this.rootClass = param3;
         this.mcMenu = new MovieClip();
         _loc1_ = new menuBottom() as MovieClip;
         --_loc1_.height;
         --_loc1_.width;
         _loc1_.x -= 43;
         _loc1_.y -= 10.7;
         this.currentPos = _loc1_.y - 2;
         this.mcMenu.addChild(_loc1_);
         _loc1_ = new menuListItem() as MovieClip;
         _loc1_.x += 17;
         _loc1_.height = this.h;
         _loc1_.width = this.w;
         _loc1_.mTxt.text = param1[0].txt;
         _loc1_.y = this.currentPos - (this.h >> 1) + 1;
         _loc1_.addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
         _loc1_.buttonMode = true;
         _loc1_.mouseChildren = false;
         _loc1_.name = param1[0].fct;
         this.currentPos = _loc1_.y;
         this.mcMenu.addChild(_loc1_);
         _loc2_ = 1;
         while(_loc2_ < param1.length - 1)
         {
            _loc1_ = new menuListItem() as MovieClip;
            _loc1_.x += 17;
            _loc1_.height = this.h;
            _loc1_.width = this.w;
            _loc1_.y = this.currentPos - this.h + 1;
            this.currentPos = _loc1_.y;
            _loc1_.mTxt.text = param1[_loc2_].txt;
            _loc1_.addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
            _loc1_.buttonMode = true;
            _loc1_.mouseChildren = false;
            _loc1_.name = param1[_loc2_].fct;
            this.mcMenu.addChild(_loc1_);
            _loc2_++;
         }
         _loc1_ = new menuTop() as MovieClip;
         --_loc1_.height;
         --_loc1_.width;
         _loc1_.y = this.currentPos - _loc1_.height;
         _loc1_.txt.text = param1[param1.length - 1].txt;
         _loc1_.x += 17;
         this.mcMenu.addChild(_loc1_);
      }

      private function onClick(param1:MouseEvent) : void
      {
         var _loc1_:Function = null;
         var _loc2_:Array = param1.currentTarget.name.split(".");
         switch(_loc2_.length)
         {
            case 1:
               _loc1_ = this[param1.currentTarget.name];
               break;
            case 2:
               _loc1_ = this.rootClass[_loc2_[1]];
               break;
            case 3:
               _loc1_ = this.rootClass.world[_loc2_[2]];
         }
         _loc1_();
      }

      private function gotoMyHouse() : void
      {
         if(this.rootClass.world.strMapName.toLowerCase() == "house" && Boolean(this.rootClass.world.isMyHouse()))
         {
            this.rootClass.world.moveToCell("Enter","Spawn");
         }
         if(this.rootClass.world.isHouseEquipped())
         {
            this.rootClass.world.gotoHouse(this.rootClass.sfc.myUserName);
         }
         else
         {
            this.rootClass.world.gotoTown("buyhouse","Enter","Spawn");
         }
      }

      private function gotoCentaur() : void
      {
         this.rootClass.world.gotoTown("buyhouse","Enter","Spawn");
      }

      private function toggleHouseInventory() : void
      {
         if(!this.rootClass.world.uiLock)
         {
            if(this.rootClass.ui.mcPopup.currentLabel == "HouseInventory")
            {
               MovieClip(this.rootClass.ui.mcPopup.getChildByName("mcInventory")).fClose();
            }
            else
            {
               this.rootClass.ui.mcPopup.fOpen("HouseInventory");
            }
         }
      }

      private function charPage() : void
      {
         var _loc1_:String = this.rootClass.world.myAvatar.objData.strUsername;
         if(this.rootClass.params.strSourceID == "BBGames")
         {
            navigateToURL(new URLRequest("https://www.aq.com/embed/bbgames/aw-character.asp?id=" + _loc1_),"_blank");
         }
         else
         {
            navigateToURL(new URLRequest("https://www.aq.com/aw-character.asp?id=" + _loc1_),"_blank");
         }
      }

      private function toggleTempInventory() : void
      {
         if(!this.rootClass.world.uiLock)
         {
            if(this.rootClass.ui.mcPopup.currentLabel == "Temp")
            {
               this.rootClass.ui.mcPopup.onClose();
            }
            else
            {
               this.rootClass.ui.mcPopup.fOpen("Temp");
            }
         }
      }

      private function toggleInventory() : void
      {
         if(!this.rootClass.world.uiLock)
         {
            if(this.rootClass.ui.mcPopup.currentLabel == "Inventory" || this.rootClass.ui.mcPopup.currentLabel == "HouseInventory")
            {
               MovieClip(this.rootClass.ui.mcPopup.getChildByName("mcInventory")).fClose();
            }
            else
            {
               this.rootClass.ui.mcPopup.fOpen("Inventory");
            }
         }
      }
   }
}
