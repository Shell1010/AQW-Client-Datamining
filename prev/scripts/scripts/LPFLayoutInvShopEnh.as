package
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import liteAssets.draw.*;

   public class LPFLayoutInvShopEnh extends LPFLayout
   {

      private var aSel:String = "";

      private var bSel:String = "";

      public var iQty:int = 1;

      public var iSel:Object;

      public var eSel:Object;

      public var shopinfo:Object;

      public var itemsInv:Array;

      public var itemsShop:Array;

      public var multiPanel:MovieClip;

      public var splitPanel:MovieClip;

      public var previewPanel:MovieClip;

      public var rootClass:MovieClip;

      public function LPFLayoutInvShopEnh()
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
         var _loc4_:DisplayObject = null;
         if(stage != null && stage.numChildren > 0)
         {
            this.rootClass = MovieClip(stage.getChildAt(0));
         }
         else if(parent != null)
         {
            _loc4_ = parent;
            while(_loc4_ != null && _loc4_.parent != null)
            {
               _loc4_ = _loc4_.parent;
            }
            this.rootClass = _loc4_ as MovieClip;
         }
         if(this.rootClass == null)
         {
            trace("[UI] ERR LPFLayoutInvShopEnh.fOpen: cannot find rootClass, stage: " + (stage != null) + ", parent: " + (parent != null));
            return;
         }
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
         var _loc5_:String = "";
         x = _loc1_.x;
         y = _loc1_.y;
         w = _loc1_.w;
         h = _loc1_.h;
         tempFill();
         _loc2_ = {};
         _loc2_.panel = new LPFPanelListShopInvB();
         _loc5_ = "EnhInventory";
         _loc2_.fData = {
            "items":this.itemsInv,
            "sName":_loc5_
         };
         _loc2_.r = {
            "x":957 - LPFFrameInvAQ.LIST_W - 319,
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
         _loc2_.panel = new LPFPanelPreview();
         _loc5_ = "Preview";
         _loc2_.fData = {"sName":_loc5_};
         _loc2_.r = {
            "x":957 - LPFFrameInvAQ.LIST_W - 319,
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
         _loc2_.panel = sMode == "inventory" ? new LPFPanelInvAQ() : new LPFPanelShopAQ();
         _loc5_ = sMode.toLowerCase().indexOf("shop") > -1 && this.rootClass.world != null && this.rootClass.world.shopinfo != null ? this.rootClass.world.shopinfo.sName : "Inventory";
         _loc2_.fData = {
            "items":(this.itemsShop != null ? this.itemsShop : this.itemsInv),
            "itemsInv":this.itemsInv,
            "objData":fData.objData,
            "sName":_loc5_
         };
         if(this.shopinfo != null)
         {
            _loc2_.fData.shopinfo = this.shopinfo;
         }
         _loc2_.r = {
            "x":957 - LPFFrameInvAQ.LIST_W,
            "y":3,
            "w":LPFFrameInvAQ.LIST_W,
            "h":495
         };
         _loc2_.closeType = "close";
         _loc2_.showDragonRight = true;
         _loc2_.isOpen = true;
         this.multiPanel = addPanel(_loc2_);
         this.updatePreviewButtons();
         if(this.rootClass != null && this.rootClass.dropStackBoost != null)
         {
            this.rootClass.dropStackBoost();
         }
      }

      override public function fClose() : void
      {
         var _loc1_:Object = null;
         var _loc5_:MovieClip = null;
         if(this.rootClass != null)
         {
            this.rootClass.dropStackReset();
         }
         if(this.previewPanel != null)
         {
            this.previewPanel.removeEventListener(Event.ENTER_FRAME,this.previewPanelEF);
         }
         var _loc6_:Array = panels.concat();
         panels.length = 0;
         for each(_loc1_ in _loc6_)
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
            _loc5_ = MovieClip(parent);
            _loc5_.removeChild(this);
            _loc5_.onClose();
         }
      }

      override protected function handleUpdate(param1:Object) : Object
      {
         var _loc5_:Object = null;
         var _loc7_:Array = null;
         var _loc8_:* = undefined;
         var _loc9_:Boolean = false;
         var _loc10_:Object = null;
         var _loc11_:String = null;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:String = null;
         var _loc15_:int = 0;
         var _loc16_:String = null;
         var _loc17_:Object = null;
         var _loc1_:Boolean = false;
         var _loc2_:Object = this.iSel;
         var _loc3_:Object = this.eSel;
         var _loc4_:Object = null;
         var _loc18_:Object = null;
         if(this.iSel != null && this.eSel != null)
         {
            this.previewPanel.bg.tTitle.text = "Create";
         }
         else
         {
            this.previewPanel.bg.tTitle.text = "Preview";
         }
         if(param1.eventType == "sModeSet")
         {
            if(sMode != param1.sModeBroadcast)
            {
               sMode = param1.sModeBroadcast;
               this.iSel = null;
               this.eSel = null;
               param1.iSel = this.iSel;
               _loc7_ = this.itemsInv;
               if(sMode == "shopBuy")
               {
                  _loc7_ = this.itemsShop;
               }
               param1.fData = {"list":_loc7_};
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
               this.iSel = null;
               this.aSel = param1.fData.sType.toLowerCase();
               this.bSel = "";
               if(this.aSel == "enhancement")
               {
                  this.eSel = param1.fData;
               }
               else
               {
                  this.iSel = param1.fData;
               }
               if(param1.fData.sType.toLowerCase() == "enhancement")
               {
                  param1.tabStates = this.getTabStates(param1.fData);
               }
               else
               {
                  param1.tabStates = this.getTabStates({"sES":"enh"});
               }
               param1.fData = {
                  "iSel":this.iSel,
                  "eSel":this.eSel,
                  "oSel":param1.fData
               };
               this.splitPanel.fHide();
               this.previewPanel.fShow();
               if(this.iSel != null && this.eSel == null)
               {
                  this.splitPanel.bg.tTitle.text = "Select Enhancement to Apply";
               }
               if(this.iSel == null && this.eSel != null)
               {
                  this.splitPanel.bg.tTitle.text = sMode == "shopBuy" ? "Select Items to Enhance" : "Select Item to Enhance";
               }
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
               _loc5_ = this.rootClass.copyObj(param1);
               _loc5_.eventType = "listItemBSolo";
               if(param1.fData.sType.toLowerCase() == "enhancement")
               {
                  _loc5_.fData = {
                     "iSel":null,
                     "eSel":_loc5_.fData
                  };
               }
               else
               {
                  _loc5_.fData = {
                     "iSel":_loc5_.fData,
                     "eSel":null
                  };
               }
               if(this.bSel == "enhancement")
               {
                  this.eSel = null;
               }
               else if(this.bSel != "")
               {
                  this.iSel = null;
               }
               this.bSel = param1.fData.sType.toLowerCase();
               if(this.bSel == "enhancement")
               {
                  this.eSel = param1.fData;
               }
               else
               {
                  this.iSel = param1.fData;
               }
               param1.fData = {
                  "iSel":this.iSel,
                  "eSel":this.eSel
               };
               if(_loc2_ != this.iSel || _loc3_ != this.eSel)
               {
                  notifyByEventType(_loc5_);
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
            if(this.itemsInv.indexOf(this.iSel) == -1 && !(this.rootClass.world != null && this.rootClass.world.myAvatar != null && this.rootClass.world.myAvatar.houseitems != null && this.rootClass.world.myAvatar.houseitems.indexOf(this.iSel) > -1))
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
                     _loc4_ = {};
                     _loc4_.eventType = "previewButton1Update";
                     _loc4_.fData = {};
                     _loc4_.fData.sText = "Equip";
                     _loc4_.sMode = "red";
                     _loc4_.r = {
                        "x":-1,
                        "y":-40,
                        "w":-1,
                        "h":-1
                     };
                     _loc4_.buttonNewEventType = "equipItem";
                     _loc18_ = {};
                     _loc18_.eventType = "previewButton2Update";
                     _loc18_.fData = {};
                     _loc18_.fData.sText = "";
                     _loc18_.sMode = "grey";
                     _loc18_.r = {
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
         if(param1.eventType == "showEnhListForItem")
         {
            if(!this.rootClass.isGreedyModalInStack())
            {
               this.splitPanel.bg.tTitle.text = "Choose an Enhancement";
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
               _loc4_ = {};
               _loc4_.eventType = "previewButton1Update";
               _loc4_.fData = {};
               _loc4_.fData.sText = "";
               _loc18_ = {};
               param1.eventType = "showItemListB";
               this.splitPanel.fShow();
            }
            else
            {
               _loc1_ = true;
            }
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
         if(param1.eventType == "equipItem" || param1.eventType == "unequipItem")
         {
            if(!this.rootClass.isGreedyModalInStack())
            {
               if(this.iSel != null)
               {
                  if(this.iSel.sES == "Weapon" && param1.eventType == "unequipItem")
                  {
                     if(this.rootClass.world.myAvatar.getItemByID(156) != null)
                     {
                        this.rootClass.toggleItemEquip(this.rootClass.world.myAvatar.getItemByID(156));
                        this.splitPanel.fHide();
                        this.previewPanel.fHide();
                     }
                     else
                     {
                        this.rootClass.MsgBox.notify("Selected Item cannot be unequipped!");
                     }
                  }
                  else if(Boolean(this.rootClass.toggleItemEquip(this.iSel)) && param1.eventType == "equipItem")
                  {
                     this.splitPanel.fHide();
                     this.previewPanel.fHide();
                  }
               }
            }
            else
            {
               _loc1_ = true;
            }
         }
         if(param1.eventType == "consumePotion")
         {
            if(this.iSel.bEquip == 1 || Boolean(this.rootClass.toggleItemEquip(this.iSel)))
            {
               this.rootClass.equipPotionOnSeia = true;
               this.splitPanel.fHide();
               this.previewPanel.fHide();
            }
         }
         if(param1.eventType == "enhanceItem")
         {
            if(!this.rootClass.isGreedyModalInStack())
            {
               if(this.iSel != null && this.eSel != null)
               {
                  this.rootClass.tryEnhance(this.splitPanel.frames[2].mc.getSelectedItems(),this.eSel,sMode == "shopBuy");
               }
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
            _loc8_ = this.iSel != null ? this.iSel : this.eSel;
            if(_loc8_ != null)
            {
               _loc9_ = InvCat.isToken(_loc8_);
               if(InvCat.isQuestLocked(_loc8_,this.rootClass.world))
               {
                  this.rootClass.MsgBox.notify("Item Locked: Quest Requirement not met.");
               }
               else if(_loc9_ && InvCat.tokenHave(_loc8_,this.rootClass.world) < InvCat.tokenNeed(_loc8_,this.iQty))
               {
                  this.rootClass.MsgBox.notify("You need " + InvCat.tokenNeed(_loc8_,this.iQty) + " x " + InvCat.tokenName(_loc8_,this.rootClass.world) + ".");
               }
               else if(_loc8_.iCost <= 0 && !_loc9_)
               {
                  _loc10_ = {
                     "accept":true,
                     "iSel":_loc8_,
                     "iQty":this.iQty
                  };
                  this.rootClass.world.sendBuyItemRequestWithQuantity(_loc10_);
               }
               else
               {
                  _loc11_ = "Are you sure you want to buy \'" + _loc8_.sName + "\'?";
                  if(this.iQty > 1)
                  {
                     _loc11_ = "Are you sure you want to buy " + String(this.iQty) + "x \'" + _loc8_.sName + "\'?";
                  }
                  if(_loc9_)
                  {
                     _loc14_ = InvCat.tokenName(_loc8_,this.rootClass.world);
                     _loc15_ = InvCat.tokenNeed(_loc8_,this.iQty);
                     _loc11_ = "Are you sure you want to buy \'" + _loc8_.sName + "\' for " + _loc15_ + " x " + _loc14_;
                     if(this.iQty > 1)
                     {
                        _loc11_ = "Are you sure you want to buy " + String(this.iQty) + "x \'" + _loc8_.sName + "\' for " + _loc15_ + " x " + _loc14_;
                     }
                     if(_loc8_.iCost > 0)
                     {
                        _loc11_ += " and " + this.rootClass.strNumWithCommas(_loc8_.bCoins == 1 ? _loc8_.iCost : Math.ceil(_loc8_.iCost / Math.max(1,Number(_loc8_.iQty)) * this.iQty)) + (_loc8_.bCoins == 1 ? " AC" : " gold");
                     }
                     _loc11_ += "?";
                  }
                  _loc12_ = new ModalMC();
                  _loc13_ = {};
                  _loc13_.strBody = _loc11_;
                  _loc13_.params = {
                     "iSel":_loc8_,
                     "iQty":this.iQty
                  };
                  _loc13_.callback = this.rootClass.world.sendBuyItemRequestWithQuantity;
                  _loc13_.glow = "white,medium";
                  _loc13_.greedy = false;
                  this.rootClass.ui.ModalStack.addChild(_loc12_);
                  _loc12_.init(_loc13_);
               }
            }
         }
         if(param1.eventType == "useItem")
         {
            if(this.iSel != null)
            {
               _loc16_ = String(this.iSel.sLink).toLowerCase();
               if(_loc16_ == "elixir" || _loc16_ == "tonic")
               {
                  this.rootClass.world.sendUseItemRequest(this.iSel);
                  this.rootClass.mixer.playSound("Good");
               }
               else
               {
                  this.rootClass.world.tryUseItem(this.iSel);
               }
               this.splitPanel.fHide();
               this.previewPanel.fHide();
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
               _loc17_ = this.iSel;
            }
            else if(this.eSel != null)
            {
               _loc17_ = this.eSel;
            }
            if(_loc17_ != null && Boolean(FavStore.has(_loc17_.ItemID)))
            {
               FavStore.notifyLocked(this.rootClass,"selling");
            }
            else if(Boolean(_loc17_.bEquip && _loc17_.sType != "Floor Item") && Boolean(_loc17_.sType != "Wall Item") || _loc17_.bEquip >= _loc17_.iQty)
            {
               if(_loc17_.sType == "Floor Item" || _loc17_.sType == "Wall Item")
               {
                  this.rootClass.MsgBox.notify("Item is currently placed in your house!");
               }
               else
               {
                  this.rootClass.MsgBox.notify("Item is currently equipped!");
               }
            }
            else if(_loc17_.bCoins == 1 && _loc17_.iHrs == null && _loc17_.ItemID != 8939 && _loc17_.iCost != 0)
            {
               this.rootClass.MsgBox.notify("Cannot be sold, free storage in your bank!");
            }
            else if(Boolean(_loc17_) && Boolean(_loc17_.hasOwnProperty("sMeta")) && _loc17_.sMeta.toString().indexOf("NoSell") > -1)
            {
               this.rootClass.MsgBox.notify("This item cannot be sold!");
            }
            else
            {
               _loc11_ = "Are you sure you want to sell \'" + _loc17_.sName + "\'?";
               if(this.iQty > 1)
               {
                  _loc11_ = "Are you sure you want to sell " + String(this.iQty) + "x \'" + _loc17_.sName + "\'?";
               }
               _loc12_ = new ModalMC();
               _loc13_ = {};
               _loc13_.strBody = _loc11_;
               _loc13_.params = {
                  "iSel":_loc17_,
                  "iQty":this.iQty
               };
               _loc13_.callback = this.rootClass.world.sendSellItemRequestWithQuantity;
               _loc13_.glow = "white,medium";
               _loc13_.greedy = false;
               this.rootClass.ui.ModalStack.addChild(_loc12_);
               _loc12_.init(_loc13_);
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
               this.rootClass.ui.mcPopup.fOpen("HouseInventory");
            }
         }
         if(param1.eventType == "helpAC")
         {
            _loc1_ = true;
            this.rootClass.world.loadMovieFront("interface/goldAC5.swf","Inline Asset");
         }
         if(param1.eventType == "hideItem")
         {
            if(this.rootClass.world.coolDown("unwearItem"))
            {
               this.rootClass.sfc.sendXtMessage("zm","unwearItem",[this.iSel.sES],"str",this.rootClass.world.curRoom);
            }
            this.splitPanel.fHide();
            this.previewPanel.fHide();
         }
         if(param1.eventType == "showItem")
         {
            if(this.iSel.bUpg == 1 && !this.rootClass.world.myAvatar.isUpgraded())
            {
               this.rootClass.showUpgradeWindow();
            }
            else
            {
               if(this.rootClass.world.coolDown("wearItem"))
               {
                  this.rootClass.sfc.sendXtMessage("zm","wearItem",[this.iSel.ItemID],"str",this.rootClass.world.curRoom);
               }
               this.splitPanel.fHide();
               this.previewPanel.fHide();
            }
         }
         this.updatePreviewButtons(_loc4_,_loc18_);
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
         var _loc4_:Object = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:Boolean = false;
         var _loc5_:Object = {};
         var _loc2_:Object = {};
         var _loc3_:Object = {};
         var _loc18_:Boolean = false;
         if(param1 != null && param2 != null)
         {
            _loc5_ = param1;
            _loc2_ = param2;
         }
         else
         {
            _loc5_.eventType = "previewButton1Update";
            _loc5_.fData = {};
            _loc5_.fData.sText = "";
            _loc5_.sMode = "grey";
            _loc5_.r = {
               "x":46,
               "y":-40,
               "w":-1,
               "h":-1
            };
            _loc5_.buttonNewEventType = "";
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
                  _loc5_.fData.sText = "";
                  _loc5_.buttonNewEventType = "";
                  _loc2_.fData.sText = "";
                  _loc2_.buttonNewEventType = "";
               }
               else if(this.iSel != null && this.eSel != null)
               {
                  _loc5_.fData.sText = "Enhance!";
                  _loc5_.buttonNewEventType = "enhanceItem";
                  _loc5_.sMode = "red";
                  if(this.iSel.bEquip == 1)
                  {
                     _loc2_.fData.sText = "Unequip";
                     _loc2_.buttonNewEventType = "unequipItem";
                  }
                  else
                  {
                     _loc2_.fData.sText = "Equip";
                     _loc2_.buttonNewEventType = "equipItem";
                     if(_loc5_.sMode != "red")
                     {
                        _loc2_.sMode = "red";
                     }
                  }
               }
               else if(this.eSel != null)
               {
                  _loc5_.fData.sText = "";
                  _loc5_.buttonNewEventType = "";
                  _loc2_.fData.sText = "Apply Now";
                  _loc2_.buttonNewEventType = "showItemListB";
                  _loc2_.sMode = "red";
               }
               else if(this.iSel != null)
               {
                  if(["Weapon","he","ar","ba"].indexOf(this.iSel.sES) > -1)
                  {
                     if(Boolean(this.iSel.bUpg == 1) && Boolean(this.rootClass.world.myAvatar.isUpgraded()) || this.iSel.bUpg == 0)
                     {
                        if(this.iSel.sES != "ar")
                        {
                           if(this.iSel.bWear)
                           {
                              _loc5_.fData.sText = "Hide";
                              _loc5_.buttonNewEventType = "hideItem";
                           }
                           else
                           {
                              _loc5_.fData.sText = "Show";
                              _loc5_.buttonNewEventType = "showItem";
                           }
                        }
                     }
                     if(!("EnhLvl" in this.iSel))
                     {
                        _loc5_.sMode = "red";
                     }
                     else
                     {
                        _loc2_.sMode = "red";
                     }
                     if(this.iSel.bEquip == 1)
                     {
                        _loc2_.fData.sText = "Unequip";
                        _loc2_.buttonNewEventType = "unequipItem";
                     }
                     else
                     {
                        _loc2_.fData.sText = "Equip";
                        _loc2_.buttonNewEventType = "equipItem";
                     }
                     _loc5_.sMode = "red";
                  }
                  else
                  {
                     _loc7_ = String(this.iSel.sLink).toLowerCase();
                     _loc8_ = String(this.iSel.sType).toLowerCase();
                     _loc9_ = _loc8_ == "item" && _loc7_.length > 0 && _loc7_ != "none";
                     if(this.iSel.sType.toLowerCase() == "pet" || _loc9_ || this.iSel.sES == "co" || this.iSel.sES == "am" || this.iSel.sES == "mi")
                     {
                        if(Boolean(this.iSel.bUpg == 1) && Boolean(this.rootClass.world.myAvatar.isUpgraded()) || this.iSel.bUpg == 0)
                        {
                           if(this.iSel.sES == "co")
                           {
                              if(this.iSel.bWear)
                              {
                                 _loc5_.fData.sText = "Hide";
                                 _loc5_.buttonNewEventType = "hideItem";
                              }
                              else
                              {
                                 _loc5_.fData.sText = "Show";
                                 _loc5_.buttonNewEventType = "showItem";
                              }
                              _loc5_.sMode = "red";
                           }
                           if(this.iSel.sType.toLowerCase() == "item" && this.iSel.sName != "Treasure Potion" && this.iSel.sName.indexOf(" Item of Digital Awesomeness") == -1 && _loc7_ != "elixir" && _loc7_ != "tonic")
                           {
                              _loc5_.fData.sText = "Consume";
                              _loc5_.buttonNewEventType = "consumePotion";
                              _loc5_.sMode = "red";
                           }
                        }
                        if(this.iSel.sName.indexOf(" Item of Digital Awesomeness") == -1)
                        {
                           _loc2_.sMode = "red";
                           if(_loc7_ == "elixir" || _loc7_ == "tonic")
                           {
                              _loc2_.fData.sText = "Use";
                              _loc2_.buttonNewEventType = "useItem";
                           }
                           else if(this.iSel.bEquip == 1)
                           {
                              _loc2_.fData.sText = "Unequip";
                              _loc2_.buttonNewEventType = "unequipItem";
                           }
                           else
                           {
                              _loc2_.fData.sText = "Equip";
                              _loc2_.buttonNewEventType = "equipItem";
                           }
                        }
                     }
                     if(this.iSel.sType.toLowerCase() == "serveruse" || this.iSel.sType.toLowerCase() == "clientuse")
                     {
                        _loc2_.sMode = "red";
                        _loc2_.fData.sText = "Use";
                        _loc2_.buttonNewEventType = "useItem";
                     }
                     if(this.iSel.sES == "ho" && this.iSel.bEquip != 1)
                     {
                        _loc2_.sMode = "red";
                        _loc2_.fData.sText = "Equip";
                        _loc2_.buttonNewEventType = "equipHouse";
                     }
                  }
               }
            }
            if(sMode == "shopBuy")
            {
               if(this.iSel == null && this.eSel == null)
               {
                  _loc5_.fData.sText = "";
                  _loc5_.buttonNewEventType = "";
                  _loc2_.fData.sText = "";
                  _loc2_.buttonNewEventType = "";
               }
               else if(this.iSel != null && this.eSel != null)
               {
                  _loc5_.fData.sText = "";
                  _loc5_.buttonNewEventType = "";
                  _loc2_.fData.sText = "Enhance!";
                  _loc2_.buttonNewEventType = "enhanceItem";
                  _loc2_.sMode = "red";
               }
               else if(this.eSel != null)
               {
                  _loc5_.fData.sText = "Buy and Hold";
                  _loc5_.buttonNewEventType = "buyItem";
                  _loc2_.fData.sText = "Apply Now";
                  _loc2_.buttonNewEventType = "showItemListBNoBtns";
                  _loc2_.sMode = "red";
               }
               else if(this.iSel != null)
               {
                  if(Boolean("bLimited" in this.shopinfo) && Boolean(this.shopinfo.bLimited) && this.iSel.iQtyRemain <= 0)
                  {
                     _loc5_.fData.sText = "";
                     _loc5_.buttonNewEventType = "";
                     _loc2_.fData.sText = "Sold Out!";
                     _loc2_.buttonNewEventType = "none";
                     _loc2_.sMode = "grey";
                  }
                  else
                  {
                     _loc5_.fData.sText = "";
                     _loc5_.buttonNewEventType = "";
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
                  _loc5_.fData.sText = "";
                  _loc5_.buttonNewEventType = "";
                  _loc2_.fData.sText = "";
                  _loc2_.buttonNewEventType = "";
               }
               else
               {
                  _loc5_.fData.sText = "";
                  _loc5_.buttonNewEventType = "";
                  _loc2_.fData.sText = "Sell";
                  _loc2_.buttonNewEventType = "sellItem";
                  _loc2_.sMode = "red";
               }
            }
         }
         _loc3_.eventType = "previewButton3Update";
         _loc3_.fData = {};
         _loc3_.fData.sText = "";
         _loc3_.sMode = "grey";
         _loc3_.r = {
            "x":-1,
            "y":-80,
            "w":-1,
            "h":-1,
            "center":true
         };
         _loc3_.buttonNewEventType = "";
         if(sMode == "inventory" && this.iSel != null && this.eSel == null && int(this.iSel.EnhID) <= 0 && ["Weapon","he","ar","ba"].indexOf(this.iSel.sES) > -1)
         {
            for each(_loc4_ in this.itemsInv)
            {
               if(_loc4_ != null && _loc4_.sType != null && _loc4_.sType.toLowerCase() == "enhancement" && _loc4_.sES == this.iSel.sES)
               {
                  _loc18_ = true;
                  break;
               }
            }
            if(_loc18_)
            {
               _loc3_.fData.sText = "Enhance";
               _loc3_.buttonNewEventType = "showEnhListForItem";
               _loc3_.sMode = "red";
            }
         }
         notifyByEventType(_loc5_);
         notifyByEventType(_loc2_);
         notifyByEventType(_loc3_);
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
         var _loc1_:Array = null;
         var _loc5_:Object = null;
         var _loc2_:Object = null;
         if(this.shopinfo != null && this.shopinfo.bHouse == 1)
         {
            _loc1_ = [{
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
               for each(_loc5_ in _loc1_)
               {
                  if(_loc5_.filter == param1.sES)
                  {
                     return [_loc5_];
                  }
               }
               return [_loc1_[0]];
            }
            return _loc1_;
         }
         _loc1_ = [{
            "sTag":"Show All",
            "icon":"iipack",
            "state":-1,
            "filter":"*",
            "mc":{}
         },{
            "sTag":"Show only weapons",
            "icon":"iwsword",
            "state":-1,
            "filter":"Weapon",
            "mc":{}
         },{
            "sTag":"Show only armor",
            "icon":"iiclass",
            "state":-1,
            "filter":"ar",
            "mc":{}
         },{
            "sTag":"Show only helms",
            "icon":"iihelm",
            "state":-1,
            "filter":"he",
            "mc":{}
         },{
            "sTag":"Show only capes",
            "icon":"iicape",
            "state":-1,
            "filter":"ba",
            "mc":{}
         },{
            "sTag":"Show only pets",
            "icon":"iipet",
            "state":-1,
            "filter":"pe",
            "mc":{}
         },{
            "sTag":"Show only amulets",
            "icon":"iin1",
            "state":-1,
            "filter":"am",
            "mc":{}
         },{
            "sTag":"Show only items",
            "icon":"iibag",
            "state":-1,
            "filter":"it",
            "mc":{}
         }];
         if(this.itemsShop == null)
         {
            _loc1_.push({
               "sTag":"Show only potions & elixirs",
               "icon":"ich1",
               "state":-1,
               "filter":"pots",
               "mc":{}
            });
         }
         else
         {
            _loc1_.push({
               "sTag":"Show only house items",
               "icon":"ihhouse",
               "state":-1,
               "filter":"houseitems",
               "mc":{}
            });
         }
         if(param1 != null)
         {
            for each(_loc2_ in _loc1_)
            {
               if(_loc2_.filter == param1.sES)
               {
                  return [_loc2_];
               }
            }
            return [_loc1_[0]];
         }
         return _loc1_;
      }

      private function previewPanelEF(param1:Event) : void
      {
         var _loc1_:Number = NaN;
         if(this.splitPanel.visible)
         {
            _loc1_ = 5 + this.previewPanel.w + this.previewPanel.xBuffer;
            if(this.splitPanel.x != _loc1_)
            {
               this.splitPanel.x = _loc1_;
               if(this.splitPanel.parent == this)
               {
                  setChildIndex(this.splitPanel,numChildren - 1);
               }
            }
            this.previewPanel.x = 5;
         }
         else if(this.previewPanel.x != this.previewPanel.xo)
         {
            this.previewPanel.x = this.previewPanel.xo;
         }
      }
   }
}
