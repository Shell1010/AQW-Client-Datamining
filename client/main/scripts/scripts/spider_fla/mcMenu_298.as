package spider_fla
{
   import flash.accessibility.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.net.drm.*;
   import flash.system.*;
   import flash.text.*;
   import flash.text.ime.*;
   import flash.ui.*;
   import flash.utils.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol3961")]
   public dynamic class mcMenu_298 extends MovieClip
   {

      public var btnBag:SimpleButton;

      public var btnBook:SimpleButton;

      public var btnChar:MovieClip;

      public var btnHouse:MovieClip;

      public var btnMap:SimpleButton;

      public var btnMenu:SimpleButton;

      public var btnOption:SimpleButton;

      public var btnQuest:MovieClip;

      public var btnRest:SimpleButton;

      public var menu:*;

      public function mcMenu_298()
      {
         super();
         addFrameScript(0,this.frame1);
      }

      public function onMouseOver(param1:MouseEvent) : *
      {
         var _loc1_:MovieClip = stage ? stage.getChildAt(0) as MovieClip : null;
         if(!_loc1_ || !_loc1_.ui || !_loc1_.ui.ToolTip)
         {
            return;
         }
         var _loc2_:* = _loc1_.ui.ToolTip;
         switch(param1.currentTarget.name)
         {
            case "btnRest":
               _loc2_.openWith({"str":"Rest"});
               break;
            case "btnBag":
               _loc2_.openWith({"str":"Inventory"});
               break;
            case "btnTemp":
               _loc2_.openWith({"str":"Temp Inventory"});
               break;
            case "btnMenu":
               _loc2_.openWith({"str":"Game Menu"});
               break;
            case "btnMap":
               _loc2_.openWith({"str":"Map"});
               break;
            case "btnOption":
               _loc2_.openWith({"str":"Options"});
               break;
            case "btnQuest":
               _loc2_.openWith({"str":"Quests"});
               break;
            case "btnBook":
               _loc2_.openWith({"str":"Book of Lore"});
               break;
            case "btnHouse":
               _loc2_.openWith({"str":"House"});
               break;
            case "btnChar":
               if(this.menu == null)
               {
                  _loc2_.openWith({"str":"Character"});
               }
         }
      }

      public function onMouseOut(param1:MouseEvent) : *
      {
         var _loc1_:MovieClip = stage ? stage.getChildAt(0) as MovieClip : null;
         if(!_loc1_ || !_loc1_.ui || !_loc1_.ui.ToolTip)
         {
            return;
         }
         _loc1_.ui.ToolTip.close();
      }

      public function onMouseClick(param1:MouseEvent) : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = stage ? stage.getChildAt(0) as MovieClip : null;
         if(!_loc4_)
         {
            return;
         }
         if(MovieClip(Game.root) != null && MovieClip(Game.root).mixer != null)
         {
            MovieClip(Game.root).mixer.playSound("Click");
         }
         if(param1.currentTarget.name != "btnMenu")
         {
            if(_loc4_.menuClose != null)
            {
               _loc4_.menuClose();
            }
         }
         switch(param1.currentTarget.name)
         {
            case "btnRest":
               this.handleMenu(null);
               _loc1_ = parent;
               _loc2_ = _loc1_ ? _loc1_.parent : null;
               _loc3_ = _loc2_ ? _loc2_.parent as MovieClip : null;
               if((Boolean(_loc3_)) && Boolean(_loc3_.world) && _loc3_.world.rest != null)
               {
                  _loc3_.world.rest();
               }
               break;
            case "btnBag":
               this.handleMenu(null);
               this.toggleInventory();
               break;
            case "btnMenu":
               this.handleMenu(null);
               _loc4_.MenuShow();
               break;
            case "btnMap":
               if(Boolean(_loc4_.ui) && Boolean(_loc4_.ui.mcPopup))
               {
                  if(_loc4_.ui.mcPopup.currentLabel == "Map")
                  {
                     _loc4_.ui.mcPopup.onClose();
                  }
                  else
                  {
                     this.handleMenu(null);
                     _loc4_.ui.mcPopup.fOpen("Map");
                  }
               }
               break;
            case "btnBook":
               if(Boolean(_loc4_.ui) && Boolean(_loc4_.ui.mcPopup))
               {
                  if(_loc4_.ui.mcPopup.currentLabel == "Book")
                  {
                     _loc4_.ui.mcPopup.onClose();
                  }
                  else
                  {
                     this.handleMenu(null);
                     _loc4_.ui.mcPopup.fOpen("Book");
                  }
               }
               break;
            case "btnOption":
               if(Boolean(_loc4_.ui) && Boolean(_loc4_.ui.mcPopup))
               {
                  if(_loc4_.ui.mcPopup.currentLabel == "Option")
                  {
                     _loc4_.ui.mcPopup.onClose();
                  }
                  else
                  {
                     this.handleMenu(null);
                     _loc4_.ui.mcPopup.fOpen("Option");
                  }
               }
               break;
            case "btnQuest":
               this.handleMenu(MovieClip(param1.currentTarget));
               break;
            case "btnHouse":
               if(_loc4_.world)
               {
                  if(Boolean(_loc4_.world.strMapName && _loc4_.world.strMapName.toLowerCase() == "house") && Boolean(_loc4_.world.isMyHouse != null) && Boolean(_loc4_.world.isMyHouse()))
                  {
                     if(_loc4_.world.moveToCell != null)
                     {
                        _loc4_.world.moveToCell("Enter","Spawn");
                     }
                     break;
                  }
                  if(_loc4_.world.isHouseEquipped != null && Boolean(_loc4_.world.isHouseEquipped()))
                  {
                     if(Boolean(_loc4_.world.gotoHouse != null) && Boolean(_loc4_.sfc) && Boolean(_loc4_.sfc.myUserName))
                     {
                        _loc4_.world.gotoHouse(_loc4_.sfc.myUserName);
                     }
                  }
                  else if(_loc4_.world.gotoTown != null)
                  {
                     _loc4_.world.gotoTown("buyhouse","Enter","Spawn");
                  }
               }
               break;
            case "btnChar":
               this.handleMenu(MovieClip(param1.currentTarget));
         }
      }

      public function handleMenu(param1:MovieClip) : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         if(param1 == null)
         {
            if(this.menu == null)
            {
               return;
            }
            _loc1_ = MovieClip(this.getChildByName(this.menu.btnOpen));
            if(Boolean(_loc1_) && Boolean(this.menu.mcMenu))
            {
               _loc1_.removeChild(this.menu.mcMenu);
            }
            this.menu = null;
            return;
         }
         if(this.menu == null)
         {
            _loc2_ = stage ? stage.getChildAt(0) as MovieClip : null;
            if(_loc2_)
            {
               this.menu = new interfaceMenu(param1.buttons,param1.name,_loc2_);
               if(Boolean(this.menu) && Boolean(this.menu.mcMenu))
               {
                  param1.addChild(this.menu.mcMenu);
               }
            }
         }
         else if(param1 == null || this.menu.btnOpen == param1.name)
         {
            if(Boolean(this.menu) && Boolean(this.menu.mcMenu))
            {
               param1.removeChild(this.menu.mcMenu);
            }
            this.menu = null;
         }
         else
         {
            _loc3_ = MovieClip(this.getChildByName(this.menu.btnOpen));
            if((Boolean(_loc3_)) && Boolean(this.menu) && Boolean(this.menu.mcMenu))
            {
               _loc3_.removeChild(this.menu.mcMenu);
            }
            this.menu = null;
            _loc4_ = stage ? stage.getChildAt(0) as MovieClip : null;
            if(_loc4_)
            {
               this.menu = new interfaceMenu(param1.buttons,param1.name,_loc4_);
               if(Boolean(this.menu) && Boolean(this.menu.mcMenu))
               {
                  param1.addChild(this.menu.mcMenu);
               }
            }
         }
      }

      public function toggleTempInventory() : void
      {
         var _loc1_:MovieClip = stage ? stage.getChildAt(0) as MovieClip : null;
         if(!_loc1_ || !_loc1_.world || !_loc1_.ui || !_loc1_.ui.mcPopup)
         {
            return;
         }
         if(!_loc1_.world.uiLock)
         {
            if(_loc1_.ui.mcPopup.currentLabel == "Temp")
            {
               if(_loc1_.ui.mcPopup.onClose != null)
               {
                  _loc1_.ui.mcPopup.onClose();
               }
            }
            else if(_loc1_.ui.mcPopup.fOpen != null)
            {
               _loc1_.ui.mcPopup.fOpen("Temp");
            }
         }
      }

      public function toggleInventory() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:MovieClip = stage ? stage.getChildAt(0) as MovieClip : null;
         if(!_loc2_ || !_loc2_.world || !_loc2_.ui || !_loc2_.ui.mcPopup)
         {
            return;
         }
         if(!_loc2_.world.uiLock)
         {
            if(_loc2_.ui.mcPopup.currentLabel == "Inventory" || _loc2_.ui.mcPopup.currentLabel == "HouseInventory")
            {
               _loc1_ = _loc2_.ui.mcPopup.getChildByName("mcInventory") as MovieClip;
               if(Boolean(_loc1_) && _loc1_.fClose != null)
               {
                  _loc1_.fClose();
               }
            }
            else if(_loc2_.ui.mcPopup.fOpen != null)
            {
               _loc2_.ui.mcPopup.fOpen("Inventory");
            }
         }
      }

      internal function frame1() : *
      {
         this.btnRest.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver,false,0,true);
         this.btnRest.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut,false,0,true);
         this.btnBag.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver,false,0,true);
         this.btnBag.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut,false,0,true);
         this.btnMenu.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver,false,0,true);
         this.btnMenu.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut,false,0,true);
         this.btnMap.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver,false,0,true);
         this.btnMap.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut,false,0,true);
         this.btnOption.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver,false,0,true);
         this.btnOption.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut,false,0,true);
         this.btnQuest.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver,false,0,true);
         this.btnQuest.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut,false,0,true);
         this.btnRest.addEventListener(MouseEvent.CLICK,this.onMouseClick,false,0,true);
         this.btnBag.addEventListener(MouseEvent.CLICK,this.onMouseClick,false,0,true);
         this.btnMenu.addEventListener(MouseEvent.CLICK,this.onMouseClick,false,0,true);
         this.btnOption.addEventListener(MouseEvent.CLICK,this.onMouseClick,false,0,true);
         this.btnMap.addEventListener(MouseEvent.CLICK,this.onMouseClick,false,0,true);
         this.btnQuest.addEventListener(MouseEvent.CLICK,this.onMouseClick,false,0,true);
         this.btnBook.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver,false,0,true);
         this.btnBook.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut,false,0,true);
         this.btnBook.addEventListener(MouseEvent.CLICK,this.onMouseClick,false,0,true);
         this.btnHouse.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver,false,0,true);
         this.btnHouse.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut,false,0,true);
         this.btnHouse.addEventListener(MouseEvent.CLICK,this.onMouseClick,false,0,true);
         this.btnChar.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver,false,0,true);
         this.btnChar.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut,false,0,true);
         this.btnChar.addEventListener(MouseEvent.CLICK,this.onMouseClick,false,0,true);
      }
   }
}
