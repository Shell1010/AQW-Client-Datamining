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
            "x":10,
            "y":80,
            "w":940,
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
         var _loc2_:MovieClip = null;
         this.rootClass.dropStackReset();
         var _loc3_:Array = panels.concat();
         panels.length = 0;
         for each(_loc1_ in _loc3_)
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
            _loc2_ = MovieClip(parent);
            _loc2_.removeChild(this);
            _loc2_.onClose();
         }
      }

      override protected function handleUpdate(param1:Object) : Object
      {
         var _loc1_:Object = null;
         var _loc2_:Array = null;
         var _loc3_:* = undefined;
         var _loc4_:Object = null;
         var _loc5_:String = null;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:Object = null;
         var _loc9_:Boolean = false;
         var _loc10_:Object = this.iSel;
         var _loc11_:Object = null;
         if(param1.eventType == "sModeSet")
         {
            if(sMode != param1.sModeBroadcast)
            {
               sMode = param1.sModeBroadcast;
               this.iSel = null;
               this.eSel = null;
               param1.iSel = this.iSel;
               _loc2_ = this.itemsInv;
               if(sMode == "shopBuy")
               {
                  _loc2_ = this.itemsShop;
               }
               param1.fData = {"list":_loc2_};
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
            if(_loc10_ == this.iSel)
            {
               _loc9_ = true;
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
            _loc3_ = this.iSel != null ? this.iSel : this.eSel;
            if(_loc3_ != null)
            {
               _loc4_ = this.rootClass.world.myAvatar.objData;
               if(InvCat.isQuestLocked(_loc3_,this.rootClass.world))
               {
                  this.rootClass.MsgBox.notify("Item Locked: Quest Requirement not met.");
               }
               else if(InvCat.isToken(_loc3_) && InvCat.tokenHave(_loc3_,this.rootClass.world) < InvCat.tokenNeed(_loc3_,this.iQty))
               {
                  this.rootClass.MsgBox.notify("You need " + InvCat.tokenNeed(_loc3_,this.iQty) + " x " + InvCat.tokenName(_loc3_,this.rootClass.world) + ".");
               }
               else if(Boolean(this.rootClass.isHouseItem(_loc3_)) && this.rootClass.world.myAvatar.houseitems.length >= _loc4_.iHouseSlots)
               {
                  this.rootClass.MsgBox.notify("House Inventory Full!");
               }
               else if(!this.rootClass.isHouseItem(_loc3_) && InvCat.isFullFor(this.rootClass.world.myAvatar.items,_loc3_,_loc4_.iBagSlots,InvCat.freedBy(this.rootClass.world.myAvatar.items,_loc3_,this.iQty)))
               {
                  this.rootClass.MsgBox.notify(InvCat.fullMsg(_loc3_));
               }
               else
               {
                  _loc5_ = "Are you sure you want to buy \'" + _loc3_.sName + "\'?";
                  if(this.iQty > 1)
                  {
                     _loc5_ = "Are you sure you want to buy " + String(this.iQty) + "x \'" + _loc3_.sName + "\'?";
                  }
                  if(InvCat.isToken(_loc3_))
                  {
                     _loc5_ = _loc5_.substr(0,_loc5_.length - 1) + " for " + InvCat.tokenNeed(_loc3_,this.iQty) + " x " + InvCat.tokenName(_loc3_,this.rootClass.world) + "?";
                  }
                  _loc6_ = new ModalMC();
                  _loc7_ = {};
                  _loc7_.strBody = _loc5_;
                  _loc7_.params = {
                     "iSel":_loc3_,
                     "iQty":this.iQty
                  };
                  _loc7_.callback = this.rootClass.world.sendBuyItemRequestWithQuantity;
                  _loc7_.glow = "white,medium";
                  _loc7_.greedy = true;
                  this.rootClass.ui.ModalStack.addChild(_loc6_);
                  _loc6_.init(_loc7_);
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
                  _loc8_ = this.iSel;
               }
               _loc6_ = new ModalMC();
               _loc7_ = {};
               _loc7_.strBody = "Are you sure you want to sell \'" + _loc8_.sName + "\'?";
               _loc7_.params = {"iSel":_loc8_};
               _loc7_.callback = this.onSellRequest;
               _loc7_.glow = "white,medium";
               this.rootClass.ui.ModalStack.addChild(_loc6_);
               _loc6_.init(_loc7_);
            }
         }
         if(param1.eventType == "buyBagSlots")
         {
            _loc9_ = true;
            this.rootClass.bagBuyLabel = this.rootClass.ui.mcPopup.currentLabel;
            this.rootClass.world.loadMovieFront(this.rootClass.bagSpace,"Inline Asset");
            this.fClose();
         }
         if(param1.eventType == "helpAC")
         {
            _loc9_ = true;
            this.rootClass.world.loadMovieFront("interface/goldAC5.swf","Inline Asset");
         }
         this.updatePreviewButtons(_loc11_);
         _loc10_ = null;
         if(!_loc9_)
         {
            return param1;
         }
         return null;
      }

      private function updatePreviewButtons(param1:Object = null, param2:Object = null) : void
      {
         var _loc1_:Object = {};
         if(param1 != null && param2 != null)
         {
            _loc1_ = param2;
         }
         else
         {
            _loc1_.eventType = "previewButton1Update";
            _loc1_.fData = {};
            _loc1_.fData.sText = "";
            _loc1_.sMode = "grey";
            _loc1_.buttonNewEventType = "";
            if(sMode == "shopBuy")
            {
               if(this.iSel != null)
               {
                  if(!this.canMergeItem(this.iSel))
                  {
                     _loc1_.fData.sText = "Missing Materials";
                     _loc1_.buttonNewEventType = "";
                     _loc1_.sMode = "label";
                  }
                  else
                  {
                     _loc1_.fData.sText = "Buy";
                     _loc1_.buttonNewEventType = "buyItem";
                     _loc1_.sMode = "red";
                  }
               }
               else
               {
                  _loc1_.fData.sText = "";
                  _loc1_.buttonNewEventType = "";
               }
            }
            if(sMode == "shopSell")
            {
               if(this.iSel != null)
               {
                  _loc1_.fData.sText = "Sell";
                  _loc1_.buttonNewEventType = "sellItem";
                  _loc1_.sMode = "red";
               }
               else
               {
                  _loc1_.fData.sText = "";
                  _loc1_.buttonNewEventType = "";
               }
            }
         }
         notifyByEventType(_loc1_);
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
         var _loc2_:Object = null;
         var _loc3_:Object = null;
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
            _loc2_ = param1.turnin[_loc1_];
            _loc3_ = this.rootClass.world.invTree[_loc2_.ItemID];
            if(_loc3_ == null || int(_loc3_.iQty) < int(_loc2_.iQty))
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
         var _loc1_:Object = null;
         var _loc2_:Array = [{
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
            "sTag":"Show only classes",
            "icon":"iiclass",
            "state":-1,
            "filter":"cl",
            "mc":{}
         },{
            "sTag":"Show only armor",
            "icon":"iwarmor",
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
            for each(_loc1_ in _loc2_)
            {
               if(_loc1_.filter == param1.sES)
               {
                  return [_loc1_];
               }
            }
            return [_loc2_[0]];
         }
         return _loc2_;
      }
   }
}
