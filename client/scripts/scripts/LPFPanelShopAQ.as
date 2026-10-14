package
{
   import flash.events.*;

   public class LPFPanelShopAQ extends LPFPanel
   {

      public function LPFPanelShopAQ()
      {
         super();
         x = 0;
         y = 0;
         frames = [];
         fData = {};
      }

      override public function fOpen(param1:Object) : void
      {
         var _loc1_:int = 0;
         while(frames.length > 0)
         {
            if(frames[0].mc != null && frames[0].mc.fClose != null)
            {
               frames[0].mc.fClose();
            }
            frames.shift();
         }
         fData = param1.fData;
         var _loc2_:Object = param1.r;
         x = _loc2_.x;
         if(_loc2_.y > -1)
         {
            y = _loc2_.y;
         }
         else
         {
            _loc1_ = fParent.numChildren;
            if(_loc1_ > 1)
            {
               y = fParent.getChildAt(_loc1_ - 2).y + fParent.getChildAt(_loc1_ - 2).height + 10;
            }
            else
            {
               y = 10;
            }
         }
         w = _loc2_.w;
         h = _loc2_.h;
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
         addFrame({
            "frame":new LPFFrameShopAQ(),
            "fData":fData,
            "r":{
               "x":0,
               "y":0,
               "w":w,
               "h":h
            }
         });
         drawBG();
         bg.btnClose.addEventListener(MouseEvent.CLICK,onCloseClick,false,0,true);
         if(mcSearch != null)
         {
            if(mcSearch.parent)
            {
               mcSearch.parent.removeChild(mcSearch);
            }
            if("dispose" in mcSearch)
            {
               mcSearch.dispose();
            }
            mcSearch = null;
         }
         bg.tTitle.visible = true;
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
