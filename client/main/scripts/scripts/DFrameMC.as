package
{
   import flash.display.*;
   import flash.events.MouseEvent;
   import flash.filters.*;
   import flash.geom.Rectangle;
   import flash.text.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol1018")]
   public class DFrameMC extends MovieClip
   {

      private static const RARITY_GLOWS:Array = [new GlowFilter(6710886,1,8,8,2,1,false,false),new GlowFilter(16777215,1,8,8,2,1,false,false),new GlowFilter(6749952,1,8,8,2,1,false,false),new GlowFilter(2663679,1,8,8,2,1,false,false),new GlowFilter(16711935,1,8,8,2,1,false,false),new GlowFilter(16763904,1,8,8,2,1,false,false),new GlowFilter(16711680,1,8,8,2,1,false,false)];

      public var cnt:DFrameMCcnt;

      internal var world:MovieClip;

      internal var rootClass:MovieClip;

      internal var fData:Object = null;

      internal var isOpen:Boolean = false;

      internal var iniFrameT:int = 0;

      internal var iniFrameC:int = 0;

      internal var durFrameT:int = 35;

      internal var durFrameC:int = 0;

      internal var mc:MovieClip;

      internal var rarityCA:Array = [6710886,16777215,6749952,2663679,16711935,16763904,16711680];

      public var fWidth:int = 175;

      public var fHeight:int = 38;

      public var fX:int = 0;

      public var fY:int = 0;

      public function DFrameMC(param1:Object)
      {
         super();
         addFrameScript(0,this.frame1,2,this.frame3,3,this.frame4,8,this.frame9,12,this.frame13);
         this.fData = param1;
      }

      public function init() : *
      {
         var _loc1_:Number = NaN;
         this.mc = MovieClip(this);
         this.rootClass = MovieClip(stage.getChildAt(0));
         this.mc.cnt.strName.autoSize = "left";
         this.mc.cnt.strName.text = this.fData.sName;
         if(this.mc.cnt.strName.height > 20)
         {
            this.mc.cnt.strName.y -= int(this.mc.cnt.strName.height / 2);
            if(this.mc.cnt.strName.y < 3)
            {
               this.mc.cnt.strName.y = 3;
            }
         }
         this.mc.cnt.strType.text = this.rootClass.getDisplaysType(this.fData) + (Boolean(this.fData.bBank) ? " added to Bank" : "");
         if(this.fData.virtual)
         {
            this.mc.cnt.strType.text = "Gold Donation";
         }
         this.mc.cnt.strType.width = int(this.mc.cnt.strType.textWidth) + 50;
         if(this.fData.iQty > 1 && this.fData.sES != "ar")
         {
            this.mc.cnt.strQ.text = "x" + this.fData.iQty;
            this.mc.cnt.strQ.x = this.mc.cnt.bg.width - this.mc.cnt.strQ.width - 7;
            this.mc.cnt.strQ.visible = true;
            this.mc.cnt.bg.width = int(this.mc.cnt.strName.textWidth) + 75;
         }
         else
         {
            this.mc.cnt.strQ.x = 0;
            this.mc.cnt.strQ.visible = false;
            this.mc.cnt.bg.width = int(this.mc.cnt.strName.textWidth) + 50;
         }
         if(this.fData.iQty > 1 && this.fData.sES != "ar")
         {
            this.mc.cnt.bg.width = int(this.mc.cnt.strName.textWidth) + 50;
            this.mc.cnt.bg.width += this.mc.cnt.strQ.textWidth + 2;
            this.mc.cnt.fx1.width = this.mc.cnt.bg.width;
            this.mc.fWidth = this.mc.cnt.bg.width;
         }
         else if(this.mc.cnt.strName.textWidth < this.mc.cnt.strType.textWidth)
         {
            this.mc.cnt.bg.width = int(this.mc.cnt.strType.textWidth) + 50;
            this.mc.cnt.fx1.width = this.mc.cnt.bg.width;
            this.mc.fWidth = this.mc.cnt.bg.width;
         }
         if(this.mc.cnt.strType.width > this.mc.cnt.bg.width)
         {
            this.mc.cnt.bg.width = int(this.mc.cnt.strType.textWidth) + 50;
         }
         this.mc.cnt.strQ.x = this.mc.cnt.bg.width - 65;
         this.mc.cnt.fx1.width = this.mc.cnt.bg.width;
         this.fWidth = this.mc.cnt.bg.width;
         var _loc2_:int = this.fData.iRty >= 0 && this.fData.iRty < RARITY_GLOWS.length ? int(this.fData.iRty) : 0;
         this.mc.cnt.bg.filters = [RARITY_GLOWS[_loc2_]];
         this.mc.cnt.icon.removeAllChildren();
         var _loc3_:String = "";
         if(this.fData.sType.toLowerCase() == "enhancement")
         {
            _loc3_ = this.rootClass.getIconBySlot(this.fData.sES);
         }
         else if(this.fData.sType.toLowerCase() == "serveruse" || this.fData.sType.toLowerCase() == "clientuse")
         {
            if("sFile" in this.fData && this.fData.sFile.length > 0 && this.rootClass.world.getClass(this.fData.sFile) != null)
            {
               _loc3_ = this.fData.sFile;
            }
            else
            {
               _loc3_ = this.fData.sIcon;
            }
         }
         else if(this.fData.sIcon == null || this.fData.sIcon == "" || this.fData.sIcon == "none")
         {
            if(this.fData.sLink.toLowerCase() != "none")
            {
               _loc3_ = "iidesign";
            }
            else
            {
               _loc3_ = "iibag";
            }
         }
         else
         {
            _loc3_ = this.fData.sIcon;
         }
         var _loc4_:Class = this.rootClass.world.getClass(_loc3_) as Class;
         var _loc5_:* = this.mc.cnt.icon.addChild(new _loc4_());
         _loc5_.scaleX = _loc5_.scaleY = String(this.fData.sType).toLowerCase() == "misc" ? 0.25 : 0.5;
         var _loc6_:Rectangle = _loc5_.getBounds(this.mc.cnt.icon);
         if(_loc6_.width > 30 || _loc6_.height > 30)
         {
            _loc1_ = 30 / Math.max(_loc6_.width,_loc6_.height);
            _loc5_.scaleX *= _loc1_;
            _loc5_.scaleY *= _loc1_;
         }
         this.mc.cnt.icon.filters = [RARITY_GLOWS[_loc2_]];
         this.mc.cnt.fadedAC.visible = false;
         this.mc.cnt.icon.detailedCheck.visible = false;
      }

      private function closeClick(param1:MouseEvent) : *
      {
      }

      internal function frame1() : *
      {
         visible = false;
      }

      internal function frame3() : *
      {
         ++this.iniFrameC;
         if(this.iniFrameC <= MovieClip(parent).getChildIndex(this) * 2)
         {
            this.gotoAndPlay(currentFrame - 1);
         }
      }

      internal function frame4() : *
      {
         visible = true;
      }

      internal function frame9() : *
      {
         ++this.durFrameC;
         if(this.durFrameC <= this.durFrameT + 5)
         {
            this.gotoAndPlay(currentFrame - 1);
         }
      }

      internal function frame13() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
