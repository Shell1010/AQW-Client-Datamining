package
{
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;

   public class LPFPanelMergeShop extends LPFPanel
   {

      private static const PV_X:int = 0;

      private static const COMP_X:int = 327;

      private static const COMP_W:int = 240;

      private static const LIST_X:int = 588;

      private static const LIST_W:int = 338;

      public function LPFPanelMergeShop()
      {
         super();
         x = 0;
         y = 0;
         frames = [];
         fData = {};
      }

      override public function fOpen(param1:Object) : void
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         while(frames.length > 0)
         {
            if(frames[0].mc != null && frames[0].mc.fClose != null)
            {
               frames[0].mc.fClose();
            }
            frames.shift();
         }
         fData = param1.fData;
         drawBG(LPFPanelBg2);
         bg.tPane1.text = "Preview";
         bg.tPane2.text = "Components";
         bg.tPane3.text = "Item List";
         bg.tSearch.visible = false;
         bg.mcHouse.visible = false;
         _loc1_ = param1.r;
         x = _loc1_.x;
         if(_loc1_.y > -1)
         {
            y = _loc1_.y;
         }
         else
         {
            _loc2_ = fParent.numChildren;
            if(_loc2_ > 1)
            {
               y = fParent.getChildAt(_loc2_ - 2).y + fParent.getChildAt(_loc2_ - 2).height + 10;
            }
            else
            {
               y = 10;
            }
         }
         var _loc3_:Point = new Point(0,0);
         _loc3_ = bg.localToGlobal(_loc3_);
         bg.y -= int(_loc1_.y - _loc3_.y);
         w = _loc1_.w;
         h = _loc1_.h;
         xo = x;
         yo = y;
         if("closeType" in param1)
         {
            closeType = param1.closeType;
         }
         if("hideDir" in param1)
         {
            hideDir = param1.hideDir;
         }
         if("hidePad" in param1)
         {
            hidePad = param1.hidePad;
         }
         if("xBuffer" in param1)
         {
            xBuffer = param1.xBuffer;
         }
         if("isOpen" in param1)
         {
            isOpen = param1.isOpen;
         }
         var _loc4_:Object = {};
         _loc4_ = {};
         _loc4_.frame = new LPFFrameBackdrop();
         _loc4_.fData = null;
         _loc4_.r = {
            "x":PV_X + 15,
            "y":36,
            "w":290,
            "h":204
         };
         addFrame(_loc4_);
         _loc4_ = {};
         _loc4_.frame = new LPFFrameBackdrop();
         _loc4_.fData = null;
         _loc4_.r = {
            "x":PV_X + 15,
            "y":244,
            "w":290,
            "h":101
         };
         addFrame(_loc4_);
         _loc4_ = {};
         _loc4_.frame = new LPFFrameItemPreview();
         _loc4_.fData = null;
         _loc4_.r = {
            "x":PV_X + 19,
            "y":40,
            "w":284,
            "h":-1
         };
         _loc4_.eventTypes = ["listItemASel"];
         addFrame(_loc4_);
         _loc4_ = {};
         _loc4_.frame = new LPFFrameEnhText();
         _loc4_.fData = null;
         _loc4_.r = {
            "x":PV_X + 19,
            "y":245,
            "w":284,
            "h":-1
         };
         _loc4_.eventTypes = ["listItemASel"];
         addFrame(_loc4_);
         _loc4_ = {};
         _loc4_.frame = new LPFFrameSimpleList();
         _loc4_.fData = {"msg":""};
         _loc4_.r = {
            "x":COMP_X,
            "y":50,
            "w":COMP_W,
            "h":-1,
            "maxH":322,
            "vCenter":true,
            "emptyMsg":"<p align=\'center\'>Select an item from the list to see what it needs.<br><br>Parts must be in your backpack.</p>"
         };
         _loc4_.eventTypes = ["refreshItems","listItemASel","updateQtyValue"];
         addFrame(_loc4_);
         _loc4_ = {};
         _loc4_.frame = new LPFFrameCostDisplay();
         _loc4_.fData = null;
         _loc4_.r = {
            "x":PV_X + 222,
            "y":-66,
            "w":-1,
            "h":-1,
            "xPosRule":"centerOnX"
         };
         _loc4_.eventTypes = ["listItemASel","updateQtyValue"];
         addFrame(_loc4_);
         _loc4_ = {};
         _loc4_.frame = new LPFFrameBackdrop();
         _loc4_.fData = null;
         _loc4_.r = {
            "x":LIST_X - 6,
            "y":36,
            "w":LIST_W + 12,
            "h":344
         };
         addFrame(_loc4_);
         _loc4_ = {};
         _loc4_.frame = new LPFFrameMergeListAQ();
         _loc4_.fData = {"list":fData.items};
         _loc4_.r = {
            "x":LIST_X,
            "y":42,
            "w":LIST_W,
            "h":282
         };
         addFrame(_loc4_);
         _loc4_ = {};
         _loc4_.frame = new LPFFrameGenericButton();
         _loc4_.fData = null;
         _loc4_.r = {
            "x":PV_X + 174,
            "y":-40,
            "w":-1,
            "h":-1
         };
         _loc4_.eventTypes = ["previewButton1Update"];
         addFrame(_loc4_);
         _loc4_ = {};
         _loc4_.frame = new LPFFrameQtySelector();
         _loc4_.fData = null;
         _loc4_.r = {
            "x":PV_X + 41,
            "y":-47.5,
            "w":-1,
            "h":-1
         };
         _loc4_.eventTypes = ["listItemASel"];
         addFrame(_loc4_);
         bg.btnClose.addEventListener(MouseEvent.CLICK,onCloseClick,false,0,true);
         if(!("showDragonLeft" in param1 && param1.showDragonLeft == true))
         {
            bg.dragonLeft.visible = false;
         }
         if(!("showDragonRight" in param1 && param1.showDragonRight == true))
         {
            bg.dragonRight.visible = false;
         }
      }
   }
}
