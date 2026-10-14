package
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import liteAssets.draw.*;

   public class LPFLayoutHouseInvShop extends LPFLayout
   {

      public var iQty:int = 1;

      private var aSel:String = "";

      private var bSel:String = "";

      public var iSel:Object;

      public var eSel:Object;

      public var shopinfo:Object;

      public var itemsInv:Array;

      public var itemsShop:Array;

      public var multiPanel:MovieClip;

      public var splitPanel:MovieClip;

      public var previewPanel:MovieClip;

      public var rootClass:MovieClip;

      public function LPFLayoutHouseInvShop()
      {
         super();
         x = 0;
         y = 0;
         panels = [];
         fData = {};
      }

      override public function fOpen(param1:Object) : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:MovieClip = null;
         this.rootClass = MovieClip(stage.getChildAt(0));
         fData = param1.fData;
         sMode = param1.sMode;
         if("itemsInv" in fData)
         {
            this.itemsInv = fData.itemsInv;
         }
         if("itemsShop" in fData)
         {
            this.itemsShop = fData.itemsShop;
         }
         if("shopinfo" in fData)
         {
            this.shopinfo = fData.shopinfo;
         }
         _loc1_ = param1.r;
         var _loc4_:String = "";
         x = _loc1_.x;
         y = _loc1_.y;
         w = _loc1_.w;
         h = _loc1_.h;
         tempFill();
         _loc2_ = {};
         _loc2_.panel = new LPFPanelListShopInvB();
         _loc4_ = "House Inventory";
         _loc2_.fData = {
            "items":this.itemsInv,
            "sName":_loc4_
         };
         _loc2_.r = {
            "x":322,
            "y":3,
            "w":316,
            "h":495
         };
         _loc2_.closeType = "hide";
         _loc2_.hideDir = "right";
         _loc2_.hidePad = 3;
         _loc2_.isOpen = false;
         this.splitPanel = addPanel(_loc2_);
         this.splitPanel.visible = false;
         this.splitPanel.fHide();
         _loc2_ = {};
         _loc2_.panel = new LPFPanelHousePreview();
         _loc4_ = "Preview";
         _loc2_.fData = {"sName":_loc4_};
         _loc2_.r = {
            "x":322,
            "y":78,
            "w":316,
            "h":420
         };
         _loc2_.closeType = "hide";
         _loc2_.xBuffer = 3;
         _loc2_.showDragonLeft = true;
         _loc2_.isOpen = false;
         this.previewPanel = addPanel(_loc2_);
         this.previewPanel.visible = false;
         this.previewPanel.addEventListener(Event.ENTER_FRAME,this.previewPanelEF,false,0,true);
         _loc2_ = {};
         _loc2_.panel = new LPFPanelListShopInvA();
         _loc4_ = sMode.toLowerCase().indexOf("shop") > -1 ? this.rootClass.world.shopinfo.sName : "House Inventory";
         _loc2_.fData = {
            "items":(this.itemsShop != null ? this.itemsShop : this.itemsInv),
            "itemsInv":this.itemsInv,
            "objData":fData.objData,
            "sName":_loc4_
         };
         if(this.shopinfo != null)
         {
            _loc2_.fData.shopinfo = this.shopinfo;
         }
         _loc2_.r = {
            "x":641,
            "y":3,
            "w":316,
            "h":495
         };
         _loc2_.closeType = "close";
         _loc2_.showDragonRight = true;
         _loc2_.isOpen = true;
         this.multiPanel = addPanel(_loc2_);
         this.updatePreviewButtons();
         this.rootClass.dropStackBoost();
      }

      override public function fClose() : void
      {
         var _loc1_:Object = null;
         var _loc4_:MovieClip = null;
         this.rootClass.dropStackReset();
         this.previewPanel.removeEventListener(Event.ENTER_FRAME,this.previewPanelEF);
         var _loc5_:Array = panels.concat();
         panels.length = 0;
         for each(_loc1_ in _loc5_)
         {
            try
            {
               _loc1_.mc.fClose();
            }
            catch(ce:Error)
            {
            }
         }
         if(parent != null)
         {
            _loc4_ = MovieClip(parent);
            _loc4_.removeChild(this);
            _loc4_.onClose();
         }
      }

      override protected function handleUpdate(param1:Object) : Object
      {
         var _loc4_:Object = null;
         var _loc6_:Array = null;
         var _loc7_:* = undefined;
         var _loc8_:Object = null;
         var _loc9_:String = null;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:Object = null;
         var _loc1_:Boolean = false;
         var _loc2_:Object = this.iSel;
         var _loc3_:Object = this.eSel;
         var _loc13_:Object = null;
         var _loc14_:Object = null;
         if(this.iSel != null && this.eSel != null)
         {
            this.previewPanel.bg.tTitle.text = "Create";
         }
         else
         {
            this.previewPanel.bg.tTitle.text = "Preview";
         }
         if(param1.eventType == "equipHouse")
         {
            if(!this.rootClass.isGreedyModalInStack())
            {
               if(this.iSel != null)
               {
                  this.rootClass.world.equipHouse(this.iSel);
                  this.splitPanel.fHide();
                  this.previewPanel.fHide();
               }
            }
            else
            {
               _loc1_ = true;
            }
         }
         if(param1.eventType == "sModeSet")
         {
            if(sMode != param1.sModeBroadcast)
            {
               sMode = param1.sModeBroadcast;
               this.iSel = null;
               this.eSel = null;
               param1.iSel = this.iSel;
               _loc6_ = this.itemsInv;
               if(sMode == "shopBuy")
               {
                  _loc6_ = this.itemsShop;
               }
               param1.fData = {"list":_loc6_};
               this.splitPanel.fHide();
               this.previewPanel.fHide();
            }
         }
         if(param1.eventType == "listItemASel")
         {
            if(!this.rootClass.isGreedyModalInStack())
            {
               this.iQty = 1;
               this.eSel = null;
               this.iSel = param1.fData;
               this.aSel = param1.fData.sType.toLowerCase();
               this.bSel = "";
               param1.fData = {
                  "iSel":this.iSel,
                  "eSel":this.eSel,
                  "oSel":param1.fData
               };
               this.previewPanel.fShow();
            }
            else
            {
               _loc1_ = true;
            }
         }
         if(param1.eventType == "listItemBSel")
         {
            if(!this.rootClass.isGreedyModalInStack())
            {
               _loc4_ = this.rootClass.copyObj(param1);
               _loc4_.eventType = "listItemBSolo";
               _loc4_.fData = {
                  "iSel":_loc4_.fData,
                  "eSel":null
               };
               this.iSel = null;
               this.bSel = param1.fData.sType.toLowerCase();
               this.iSel = param1.fData;
               param1.fData = {
                  "iSel":this.iSel,
                  "eSel":this.eSel
               };
               if(_loc2_ != this.iSel || _loc3_ != this.eSel)
               {
                  notifyByEventType(_loc4_);
               }
               this.previewPanel.fShow();
            }
            else
            {
               _loc1_ = true;
            }
         }
         if(param1.eventType == "refreshItems")
         {
            if(this.itemsInv.indexOf(this.iSel) == -1)
            {
               this.iSel = null;
            }
            if(this.itemsInv.indexOf(this.eSel) == -1)
            {
               this.eSel = null;
            }
            param1.fData = {
               "iSel":this.iSel,
               "eSel":this.eSel
            };
            if("sInstruction" in param1)
            {
               if(param1.sInstruction == "closeWindows")
               {
                  this.splitPanel.fHide();
                  this.previewPanel.fHide();
               }
               if(param1.sInstruction == "previewEquipOnly")
               {
                  this.splitPanel.fHide();
                  if(this.iSel != null && this.iSel.bEquip != 1)
                  {
                     _loc13_ = {};
                     _loc13_.eventType = "previewButton1Update";
                     _loc13_.fData = {};
                     _loc13_.fData.sText = "Equip";
                     _loc13_.sMode = "red";
                     _loc13_.r = {
                        "x":-1,
                        "y":-40,
                        "w":-1,
                        "h":-1
                     };
                     _loc13_.buttonNewEventType = "equipItem";
                     _loc14_ = {};
                     _loc14_.eventType = "previewButton2Update";
                     _loc14_.fData = {};
                     _loc14_.fData.sText = "";
                     _loc14_.sMode = "grey";
                     _loc14_.r = {
                        "x":173,
                        "y":-40,
                        "w":-1,
                        "h":-1
                     };
                  }
                  else
                  {
                     this.previewPanel.fHide();
                  }
               }
            }
            if(this.iSel == null && this.eSel == null)
            {
               this.splitPanel.fHide();
               this.previewPanel.fHide();
            }
         }
         if(param1.eventType == "refreshShop")
         {
            this.rootClass.world.sendReloadShopRequest(this.shopinfo.ShopID);
            _loc1_ = true;
         }
         if(param1.eventType == "showItemListB")
         {
            if(!this.rootClass.isGreedyModalInStack())
            {
               this.splitPanel.fShow();
            }
            else
            {
               _loc1_ = true;
            }
         }
         if(param1.eventType == "showItemListBNoBtns")
         {
            if(!this.rootClass.isGreedyModalInStack())
            {
               _loc13_ = {};
               _loc13_.eventType = "previewButton1Update";
               _loc13_.fData = {};
               _loc13_.fData.sText = "";
               _loc14_ = {};
               param1.eventType = "showItemListB";
               this.splitPanel.fShow();
            }
            else
            {
               _loc1_ = true;
            }
         }
         if(param1.eventType == "buyItem")
         {
            if(!LPFFrameQtySelector.commitActive())
            {
               return null;
            }
            _loc7_ = this.iSel != null ? this.iSel : this.eSel;
            if(_loc7_ != null)
            {
               if(_loc7_.iCost <= 0)
               {
                  _loc8_ = {
                     "accept":true,
                     "iSel":_loc7_,
                     "iQty":this.iQty
                  };
                  this.rootClass.world.sendBuyItemRequestWithQuantity(_loc8_);
               }
               else
               {
                  _loc9_ = "Are you sure you want to buy \'" + _loc7_.sName + "\'?";
                  if(this.iQty > 1)
                  {
                     _loc9_ = "Are you sure you want to buy " + String(this.iQty) + "x \'" + _loc7_.sName + "\'?";
                  }
                  _loc10_ = new ModalMC();
                  _loc11_ = {};
                  _loc11_.strBody = _loc9_;
                  _loc11_.params = {
                     "iSel":_loc7_,
                     "iQty":this.iQty
                  };
                  _loc11_.callback = this.rootClass.world.sendBuyItemRequestWithQuantity;
                  _loc11_.glow = "white,medium";
                  _loc11_.greedy = false;
                  this.rootClass.ui.ModalStack.addChild(_loc10_);
                  _loc10_.init(_loc11_);
               }
            }
         }
         if(param1.eventType == "sellItem")
         {
            if(!LPFFrameQtySelector.commitActive())
            {
               return null;
            }
            if(this.iSel != null)
            {
               _loc12_ = this.iSel;
            }
            else if(this.eSel != null)
            {
               _loc12_ = this.eSel;
            }
            if(_loc12_ != null && Boolean(FavStore.has(_loc12_.ItemID)))
            {
               FavStore.notifyLocked(this.rootClass,"selling");
            }
            else if(Boolean(_loc12_.bEquip && _loc12_.sType != "Floor Item") && Boolean(_loc12_.sType != "Wall Item") || _loc12_.bEquip >= _loc12_.iQty)
            {
               if(_loc12_.sType == "Floor Item" || _loc12_.sType == "Wall Item")
               {
                  this.rootClass.MsgBox.notify("Item is currently placed in your house!");
               }
               else
               {
                  this.rootClass.MsgBox.notify("Item is currently equipped!");
               }
            }
            else if(_loc12_.bCoins == 1 && _loc12_.iHrs == null && _loc12_.ItemID != 8939 && _loc12_.iCost != 0)
            {
               this.rootClass.MsgBox.notify("Cannot be sold, free storage in your bank!");
            }
            else if(Boolean(_loc12_) && Boolean(_loc12_.hasOwnProperty("sMeta")) && _loc12_.sMeta.toString().indexOf("NoSell") > -1)
            {
               this.rootClass.MsgBox.notify("This item cannot be sold!");
            }
            else
            {
               _loc9_ = "Are you sure you want to sell \'" + _loc12_.sName + "\'?";
               if(this.iQty > 1)
               {
                  _loc9_ = "Are you sure you want to sell " + String(this.iQty) + "x \'" + _loc12_.sName + "\'?";
               }
               _loc10_ = new ModalMC();
               _loc11_ = {};
               _loc11_.strBody = _loc9_;
               _loc11_.params = {
                  "iSel":_loc12_,
                  "iQty":this.iQty
               };
               _loc11_.callback = this.rootClass.world.sendSellItemRequestWithQuantity;
               _loc11_.glow = "white,medium";
               _loc11_.greedy = false;
               this.rootClass.ui.ModalStack.addChild(_loc10_);
               _loc10_.init(_loc11_);
            }
         }
         if(param1.eventType == "buyBagSlots")
         {
            _loc1_ = true;
            this.rootClass.bagBuyLabel = this.rootClass.ui.mcPopup.currentLabel;
            this.rootClass.world.loadMovieFront(this.rootClass.bagSpace,"Inline Asset");
            this.fClose();
         }
         if(param1.eventType == "toggleHouseInventory")
         {
            if(!this.rootClass.world.uiLock)
            {
               this.rootClass.ui.mcPopup.fOpen("Inventory");
            }
         }
         if(param1.eventType == "helpAC")
         {
            _loc1_ = true;
            this.rootClass.world.loadMovieFront("interface/goldAC5.swf","Inline Asset");
         }
         this.updatePreviewButtons(_loc13_,_loc14_);
         _loc2_ = null;
         _loc3_ = null;
         if(!_loc1_)
         {
            return param1;
         }
         return null;
      }

      private function updatePreviewButtons(param1:Object = null, param2:Object = null) : void
      {
         var _loc4_:Object = {};
         var _loc2_:Object = {};
         if(param1 != null && param2 != null)
         {
            _loc4_ = param1;
            _loc2_ = param2;
         }
         else
         {
            _loc4_.eventType = "previewButton1Update";
            _loc4_.fData = {};
            _loc4_.fData.sText = "";
            _loc4_.sMode = "grey";
            _loc4_.r = {
               "x":46,
               "y":-40,
               "w":-1,
               "h":-1
            };
            _loc4_.buttonNewEventType = "";
            _loc2_.eventType = "previewButton2Update";
            _loc2_.fData = {};
            _loc2_.fData.sText = "";
            _loc2_.sMode = "grey";
            _loc2_.r = {
               "x":173,
               "y":-40,
               "w":-1,
               "h":-1
            };
            _loc2_.buttonNewEventType = "";
            if(sMode == "inventory")
            {
               if(this.iSel == null && this.eSel == null)
               {
                  _loc4_.fData.sText = "";
                  _loc4_.buttonNewEventType = "";
                  _loc2_.fData.sText = "";
                  _loc2_.buttonNewEventType = "";
               }
               else if(this.iSel != null)
               {
                  if(this.iSel.sES == "ho")
                  {
                     if(this.iSel.bEquip != 1)
                     {
                        _loc2_.fData.sText = "Equip";
                        _loc2_.buttonNewEventType = "equipHouse";
                     }
                     _loc2_.sMode = "red";
                  }
               }
            }
            if(sMode == "shopBuy")
            {
               if(this.iSel == null && this.eSel == null)
               {
                  _loc4_.fData.sText = "";
                  _loc4_.buttonNewEventType = "";
                  _loc2_.fData.sText = "";
                  _loc2_.buttonNewEventType = "";
               }
               else if(this.iSel != null && this.eSel != null)
               {
                  _loc4_.fData.sText = "";
                  _loc4_.buttonNewEventType = "";
                  _loc2_.fData.sText = "Enhance!";
                  _loc2_.buttonNewEventType = "enhanceItem";
                  _loc2_.sMode = "red";
               }
               else if(this.eSel != null)
               {
                  _loc4_.fData.sText = "Buy and Hold";
                  _loc4_.buttonNewEventType = "buyItem";
                  _loc2_.fData.sText = "Apply Now";
                  _loc2_.buttonNewEventType = "showItemListBNoBtns";
                  _loc2_.sMode = "red";
               }
               else if(this.iSel != null)
               {
                  if(Boolean("bLimited" in this.shopinfo) && Boolean(this.shopinfo.bLimited) && this.iSel.iQtyRemain <= 0)
                  {
                     _loc4_.fData.sText = "";
                     _loc4_.buttonNewEventType = "";
                     _loc2_.fData.sText = "Sold Out!";
                     _loc2_.buttonNewEventType = "none";
                     _loc2_.sMode = "grey";
                  }
                  else
                  {
                     _loc4_.fData.sText = "";
                     _loc4_.buttonNewEventType = "";
                     _loc2_.fData.sText = "Buy";
                     _loc2_.buttonNewEventType = "buyItem";
                     _loc2_.sMode = "red";
                  }
               }
            }
            if(sMode == "shopSell")
            {
               if(this.iSel == null && this.eSel == null)
               {
                  _loc4_.fData.sText = "";
                  _loc4_.buttonNewEventType = "";
                  _loc2_.fData.sText = "";
                  _loc2_.buttonNewEventType = "";
               }
               else
               {
                  _loc4_.fData.sText = "";
                  _loc4_.buttonNewEventType = "";
                  _loc2_.fData.sText = "Sell";
                  _loc2_.buttonNewEventType = "sellItem";
                  _loc2_.sMode = "red";
               }
            }
         }
         notifyByEventType(_loc4_);
         notifyByEventType(_loc2_);
      }

      private function onSellRequest(param1:Object) : void
      {
         if(param1.accept)
         {
            this.rootClass.world.sendSellItemRequest(param1.iSel);
         }
      }

      public function getTabStates(param1:Object = null) : Array
      {
         var _loc4_:Object = null;
         var _loc1_:Array = [{
            "sTag":"Show All",
            "icon":"iipack",
            "state":-1,
            "filter":"*",
            "mc":{}
         },{
            "sTag":"Show only houses",
            "icon":"ihhouse",
            "state":-1,
            "filter":"House",
            "mc":{}
         },{
            "sTag":"Show only walls",
            "icon":"ihwall",
            "state":-1,
            "filter":"Wall Item",
            "mc":{}
         },{
            "sTag":"Show only floors",
            "icon":"ihfloor",
            "state":-1,
            "filter":"Floor Item",
            "mc":{}
         }];
         if(param1 != null)
         {
            for each(_loc4_ in _loc1_)
            {
               if(_loc4_.filter == param1.sType)
               {
                  return [_loc4_];
               }
            }
            return [_loc1_[0]];
         }
         return _loc1_;
      }

      private function previewPanelEF(param1:Event) : void
      {
         var _loc1_:Number = this.previewPanel.x;
         var _loc4_:Number = this.splitPanel.x - this.previewPanel.w - this.previewPanel.xBuffer;
         var _loc2_:Number = _loc4_ - _loc1_;
         if(_loc2_ > 20 || this.splitPanel.visible)
         {
            this.previewPanel.x = this.splitPanel.x - this.previewPanel.w - this.previewPanel.xBuffer;
         }
      }
   }
}
