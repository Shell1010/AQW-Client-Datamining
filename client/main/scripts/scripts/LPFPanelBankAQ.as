package
{
   import flash.events.*;

   public class LPFPanelBankAQ extends LPFPanel
   {

      public function LPFPanelBankAQ()
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
         addFrame({
            "frame":new LPFFrameBankAQ(),
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
         bg.tTitle.text = "Bank";
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
