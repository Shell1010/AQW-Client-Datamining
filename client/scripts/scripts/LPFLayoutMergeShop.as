package
{
   import flash.display.*;
   import flash.text.*;
   import liteAssets.draw.*;

   public class LPFLayoutMergeShop extends LPFLayout
   {

      public var iQty:int = 1;

      private var aSel:String = "";

      private var bSel:String = "";

      public var iSel:Object;

      public var eSel:Object;

      public var itemsInv:Array;

      public var itemsShop:Array;

      public var mergePanel:MovieClip;

      public var rootClass:MovieClip;

      public function LPFLayoutMergeShop()
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
         _loc1_ = param1.r;
         var _loc4_:String = "";
         x = _loc1_.x;
         y = _loc1_.y;
         w = _loc1_.w;
         h = _loc1_.h;
         _loc2_ = {};
         _loc2_.panel = new LPFPanelMergeShop();
         _loc4_ = this.rootClass.world.shopinfo.sName;
         _loc2_.fData = {
            "items":this.itemsShop,
            "itemsInv":this.itemsInv,
            "sName":_loc4_,
            "objData":fData.objData
         };
         _loc2_.r = {
            "x":30,
            "y":80,
            "w":900,
            "h":400
         };
         _loc2_.isOpen = true;
         this.mergePanel = addPanel(_loc2_);
         this.updatePreviewButtons();
         this.rootClass.dropStackBoost();
      }

      override public function fClose() : void
      {
         var _loc1_:Object = null;
         var _loc4_:MovieClip = null;
         this.rootClass.dropStackReset();
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
         var _loc3_:Object = null;
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
            }
         }
         if(param1.eventType == "listItemASel")
         {
            this.iQty = 1;
            this.iSel = null;
            this.aSel = param1.fData.sType.toLowerCase();
            this.iSel = param1.fData;
            param1.fData = {
               "iSel":this.iSel,
               "oSel":param1.fData
            };
            if(_loc2_ == this.iSel)
            {
               _loc1_ = true;
            }
         }
         if(param1.eventType == "refreshItems")
         {
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
               _loc8_ = this.rootClass.world.myAvatar.objData;
               if(InvCat.isQuestLocked(_loc7_,this.rootClass.world))
               {
                  this.rootClass.MsgBox.notify("Item Locked: Quest Requirement not met.");
               }
               else if(InvCat.isToken(_loc7_) && InvCat.tokenHave(_loc7_,this.rootClass.world) < InvCat.tokenNeed(_loc7_,this.iQty))
               {
                  this.rootClass.MsgBox.notify("You need " + InvCat.tokenNeed(_loc7_,this.iQty) + " x " + InvCat.tokenName(_loc7_,this.rootClass.world) + ".");
               }
               else if(Boolean(this.rootClass.isHouseItem(_loc7_)) && this.rootClass.world.myAvatar.houseitems.length >= _loc8_.iHouseSlots)
               {
                  this.rootClass.MsgBox.notify("House Inventory Full!");
               }
               else if(!this.rootClass.isHouseItem(_loc7_) && InvCat.isFullFor(this.rootClass.world.myAvatar.items,_loc7_,_loc8_.iBagSlots,InvCat.freedBy(this.rootClass.world.myAvatar.items,_loc7_,this.iQty)))
               {
                  this.rootClass.MsgBox.notify(InvCat.fullMsg(_loc7_));
               }
               else
               {
                  _loc9_ = "Are you sure you want to buy \'" + _loc7_.sName + "\'?";
                  if(this.iQty > 1)
                  {
                     _loc9_ = "Are you sure you want to buy " + String(this.iQty) + "x \'" + _loc7_.sName + "\'?";
                  }
                  if(InvCat.isToken(_loc7_))
                  {
                     _loc9_ = _loc9_.substr(0,_loc9_.length - 1) + " for " + InvCat.tokenNeed(_loc7_,this.iQty) + " x " + InvCat.tokenName(_loc7_,this.rootClass.world) + "?";
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
                  _loc11_.greedy = true;
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
            if(this.iSel != null && Boolean(FavStore.has(this.iSel.ItemID)))
            {
               FavStore.notifyLocked(this.rootClass,"selling");
            }
            else
            {
               if(this.iSel != null)
               {
                  _loc12_ = this.iSel;
               }
               _loc10_ = new ModalMC();
               _loc11_ = {};
               _loc11_.strBody = "Are you sure you want to sell \'" + _loc12_.sName + "\'?";
               _loc11_.params = {"iSel":_loc12_};
               _loc11_.callback = this.onSellRequest;
               _loc11_.glow = "white,medium";
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
         if(param1.eventType == "helpAC")
         {
            _loc1_ = true;
            this.rootClass.world.loadMovieFront("interface/goldAC5.swf","Inline Asset");
         }
         this.updatePreviewButtons(_loc3_);
         _loc2_ = null;
         if(!_loc1_)
         {
            return param1;
         }
         return null;
      }

      private function updatePreviewButtons(param1:Object = null, param2:Object = null) : void
      {
         var _loc4_:Object = {};
         if(param1 != null && param2 != null)
         {
            _loc4_ = param2;
         }
         else
         {
            _loc4_.eventType = "previewButton1Update";
            _loc4_.fData = {};
            _loc4_.fData.sText = "";
            _loc4_.sMode = "grey";
            _loc4_.buttonNewEventType = "";
            if(sMode == "shopBuy")
            {
               if(this.iSel != null)
               {
                  if(!this.canMergeItem(this.iSel))
                  {
                     _loc4_.fData.sText = "Missing Materials";
                     _loc4_.buttonNewEventType = "";
                     _loc4_.sMode = "label";
                  }
                  else
                  {
                     _loc4_.fData.sText = "Buy";
                     _loc4_.buttonNewEventType = "buyItem";
                     _loc4_.sMode = "red";
                  }
               }
               else
               {
                  _loc4_.fData.sText = "";
                  _loc4_.buttonNewEventType = "";
               }
            }
            if(sMode == "shopSell")
            {
               if(this.iSel != null)
               {
                  _loc4_.fData.sText = "Sell";
                  _loc4_.buttonNewEventType = "sellItem";
                  _loc4_.sMode = "red";
               }
               else
               {
                  _loc4_.fData.sText = "";
                  _loc4_.buttonNewEventType = "";
               }
            }
         }
         notifyByEventType(_loc4_);
      }

      private function onSellRequest(param1:Object) : void
      {
         if(param1.accept)
         {
            this.rootClass.world.sendSellItemRequest(param1.iSel);
         }
      }

      private function canMerge(param1:Object) : Boolean
      {
         var _loc1_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:Object = null;
         if(param1 == null)
         {
            return true;
         }
         if(InvCat.isToken(param1) && InvCat.tokenHave(param1,this.rootClass.world) < int(param1.TokQty))
         {
            return false;
         }
         if(param1.turnin == null)
         {
            return true;
         }
         _loc1_ = 0;
         while(_loc1_ < param1.turnin.length)
         {
            _loc4_ = param1.turnin[_loc1_];
            _loc2_ = this.rootClass.world.invTree[_loc4_.ItemID];
            if(_loc2_ == null || int(_loc2_.iQty) < int(_loc4_.iQty))
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }

      public function canMergeItem(param1:Object) : Boolean
      {
         return this.canMerge(param1);
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
         },{
            "sTag":"Show only house items",
            "icon":"ihhouse",
            "state":-1,
            "filter":"houseitems",
            "mc":{}
         }];
         if(param1 != null)
         {
            for each(_loc4_ in _loc1_)
            {
               if(_loc4_.filter == param1.sES)
               {
                  return [_loc4_];
               }
            }
            return [_loc1_[0]];
         }
         return _loc1_;
      }
   }
}
