package
{
   import flash.display.*;
   import flash.text.*;

   public class LPFLayoutBank extends LPFLayout
   {

      public var iSel:Object;

      public var bSel:Object;

      public var itemsI:Array;

      public var itemsB:Array;

      public var bankPanel:MovieClip;

      public var rootClass:MovieClip;

      public var previewPanel:MovieClip;

      public function LPFLayoutBank()
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
         if("itemsI" in fData)
         {
            this.itemsI = fData.itemsI;
         }
         if("itemsB" in fData)
         {
            this.itemsB = fData.itemsB;
         }
         _loc1_ = param1.r;
         var _loc4_:String = "";
         x = _loc1_.x;
         y = _loc1_.y;
         w = _loc1_.w;
         h = _loc1_.h;
         _loc2_ = {};
         _loc2_.panel = new LPFPanelBankAQ();
         _loc2_.fData = {
            "itemsI":this.itemsI,
            "itemsB":this.itemsB,
            "avatar":this.rootClass.world.myAvatar,
            "objData":fData.objData
         };
         _loc2_.r = {
            "x":30,
            "y":20,
            "w":900,
            "h":480
         };
         _loc2_.isOpen = true;
         this.bankPanel = addPanel(_loc2_);
         _loc2_ = {};
         _loc2_.panel = new BankPreview();
         _loc4_ = "Preview";
         _loc2_.fData = {"sName":_loc4_};
         _loc2_.r = {
            "x":352,
            "y":118,
            "w":256,
            "h":234
         };
         _loc2_.closeType = "hide";
         _loc2_.isOpen = false;
         this.previewPanel = addChild(_loc2_.panel) as MovieClip;
         this.previewPanel.Open(_loc2_);
         this.previewPanel.visible = false;
         this.previewPanel.mouseEnabled = false;
         this.previewPanel.mouseChildren = false;
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
         this.rootClass.world.bankinfo.resetSearch();
      }

      override protected function handleUpdate(param1:Object) : Object
      {
         var _loc1_:Object = null;
         var _loc2_:Boolean = false;
         var _loc3_:Object = this.iSel;
         var _loc4_:Object = this.bSel;
         var _loc5_:Object = null;
         if(param1.eventType == "inventorySel")
         {
            this.iSel = param1.fData;
            if(_loc3_ == this.iSel)
            {
               this.iSel = null;
            }
            param1.fData = {"iSel":this.iSel};
            this.previewPanel.Show(this.iSel);
         }
         if(param1.eventType == "bankSel")
         {
            this.bSel = param1.fData;
            if(_loc4_ == this.bSel)
            {
               this.bSel = null;
            }
            param1.fData = {"bSel":this.bSel};
            this.previewPanel.Show(this.bSel);
         }
         if(param1.eventType == "categorySel")
         {
            this.bSel = null;
            param1.eventType = "refreshBank";
         }
         if(param1.eventType == "refreshBank")
         {
         }
         if(param1.eventType == "refreshInventory")
         {
         }
         if(param1.eventType == "refreshItems")
         {
         }
         if(param1.eventType == "sendBankFromInvRequest")
         {
            this.rootClass.world.sendBankFromInvRequest(this.iSel);
            this.iSel = null;
         }
         if(param1.eventType == "sendBankToInvRequest")
         {
            this.rootClass.world.sendBankToInvRequest(this.bSel);
            this.bSel = null;
         }
         if(param1.eventType == "sendBankSwapInvRequest")
         {
            this.rootClass.world.sendBankSwapInvRequest(this.bSel,this.iSel);
            this.iSel = null;
            this.bSel = null;
         }
         if(param1.eventType == "buyBagSlots")
         {
            _loc2_ = true;
            this.rootClass.bagBuyLabel = this.rootClass.ui.mcPopup.currentLabel;
            this.rootClass.world.loadMovieFront(this.rootClass.bagSpace,"Inline Asset");
            this.fClose();
         }
         if(param1.eventType == "switchBank")
         {
            this.rootClass.world.toggleHouseBank();
         }
         if(param1.eventType == "helpAC")
         {
            _loc2_ = true;
            this.rootClass.world.loadMovieFront("interface/goldAC5.swf","Inline Asset");
         }
         this.updatePreviewButtons(_loc5_);
         _loc3_ = null;
         _loc4_ = null;
         if(!_loc2_)
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
            if(this.iSel != null && this.bSel == null)
            {
               _loc1_.fData.sText = "< To Bank";
               _loc1_.buttonNewEventType = "sendBankFromInvRequest";
               _loc1_.sMode = "red";
            }
            else if(this.iSel == null && this.bSel != null)
            {
               _loc1_.fData.sText = "To Inventory >";
               _loc1_.buttonNewEventType = "sendBankToInvRequest";
               _loc1_.sMode = "red";
            }
            else if(this.iSel != null && this.bSel != null)
            {
               _loc1_.fData.sText = "< Swap >";
               _loc1_.buttonNewEventType = "sendBankSwapInvRequest";
               _loc1_.sMode = "red";
            }
            else
            {
               _loc1_.fData.sText = "";
               _loc1_.buttonNewEventType = "";
            }
         }
         notifyByEventType(_loc1_);
      }

      public function getTabStates(param1:Object = null, param2:Array = null) : Array
      {
         var _loc1_:String = null;
         var _loc2_:* = 0;
         var _loc3_:Object = null;
         var _loc4_:Array = [{
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
            "sTag":"Show only enhancements",
            "icon":"iidesign",
            "state":-1,
            "filter":"enh",
            "mc":{}
         }];
         if(param2 != null)
         {
            for each(_loc1_ in param2)
            {
               _loc2_ = 0;
               while(_loc2_ < _loc4_.length)
               {
                  if(_loc4_[_loc2_].filter == _loc1_)
                  {
                     _loc4_.splice(_loc2_--,1);
                  }
                  _loc2_++;
               }
            }
         }
         if(param1 != null)
         {
            for each(_loc3_ in _loc4_)
            {
               if(_loc3_.filter == param1.sES)
               {
                  return [_loc3_];
               }
            }
            return [_loc4_[0]];
         }
         return _loc4_;
      }
   }
}
