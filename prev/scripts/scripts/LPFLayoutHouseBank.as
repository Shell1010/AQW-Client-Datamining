package
{
   import flash.display.*;
   import flash.text.*;

   public class LPFLayoutHouseBank extends LPFLayout
   {

      public var iSel:Object;

      public var bSel:Object;

      public var itemsI:Array;

      public var itemsB:Array;

      public var bankPanel:MovieClip;

      public var rootClass:MovieClip;

      public var previewPanel:MovieClip;

      public function LPFLayoutHouseBank()
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
         _loc2_.panel = new LPFPanelHouseBank();
         _loc2_.fData = {
            "itemsI":this.itemsI,
            "itemsB":this.itemsB,
            "avatar":this.rootClass.world.myAvatar,
            "objData":fData.objData
         };
         _loc2_.r = {
            "x":30,
            "y":80,
            "w":900,
            "h":400
         };
         _loc2_.isOpen = true;
         this.bankPanel = addPanel(_loc2_);
         _loc2_ = {};
         _loc2_.panel = new BankPreview();
         _loc4_ = "Preview";
         _loc2_.fData = {"sName":_loc4_};
         _loc2_.r = {
            "x":357,
            "y":197,
            "w":255,
            "h":204.2
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
         this.rootClass.world.bankinfo.resetSearch();
      }

      override protected function handleUpdate(param1:Object) : Object
      {
         var _loc4_:Object = null;
         var _loc1_:Boolean = false;
         var _loc2_:Object = this.iSel;
         var _loc3_:Object = this.bSel;
         var _loc6_:Object = null;
         if(param1.eventType == "inventorySel")
         {
            this.iSel = param1.fData;
            if(_loc2_ == this.iSel)
            {
               this.iSel = null;
            }
            param1.fData = {"iSel":this.iSel};
            this.previewPanel.Show(this.iSel);
         }
         if(param1.eventType == "bankSel")
         {
            this.bSel = param1.fData;
            if(_loc3_ == this.bSel)
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
            _loc1_ = true;
            this.rootClass.bagBuyLabel = this.rootClass.ui.mcPopup.currentLabel;
            this.rootClass.world.loadMovieFront(this.rootClass.bagSpace,"Inline Asset");
            this.fClose();
         }
         if(param1.eventType == "switchBank")
         {
            this.rootClass.world.toggleBank();
         }
         if(param1.eventType == "helpAC")
         {
            _loc1_ = true;
            this.rootClass.world.loadMovieFront("interface/goldAC5.swf","Inline Asset");
         }
         this.updatePreviewButtons(_loc6_);
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
            if(this.iSel != null && this.bSel == null)
            {
               _loc4_.fData.sText = "< To Bank";
               _loc4_.buttonNewEventType = "sendBankFromInvRequest";
               _loc4_.sMode = "red";
            }
            else if(this.iSel == null && this.bSel != null)
            {
               _loc4_.fData.sText = "To Inventory >";
               _loc4_.buttonNewEventType = "sendBankToInvRequest";
               _loc4_.sMode = "red";
            }
            else if(this.iSel != null && this.bSel != null)
            {
               _loc4_.fData.sText = "< Swap >";
               _loc4_.buttonNewEventType = "sendBankSwapInvRequest";
               _loc4_.sMode = "red";
            }
            else
            {
               _loc4_.fData.sText = "";
               _loc4_.buttonNewEventType = "";
            }
         }
         notifyByEventType(_loc4_);
      }

      public function getTabStates(param1:Object = null, param2:Array = null) : Array
      {
         var _loc2_:String = null;
         var _loc3_:* = 0;
         var _loc6_:Object = null;
         var _loc4_:Array = [{
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
         if(param2 != null)
         {
            for each(_loc2_ in param2)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc4_.length)
               {
                  if(_loc4_[_loc3_].filter == _loc2_)
                  {
                     _loc4_.splice(_loc3_--,1);
                  }
                  _loc3_++;
               }
            }
         }
         if(param1 != null)
         {
            for each(_loc6_ in _loc4_)
            {
               if(_loc6_.filter == param1.sType)
               {
                  return [_loc6_];
               }
            }
            return [_loc4_[0]];
         }
         return _loc4_;
      }
   }
}
