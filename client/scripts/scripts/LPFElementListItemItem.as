package
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.text.*;
   import liteAssets.draw.detailedCheck;

   [Embed(source="/_assets/assets.swf", symbol="symbol2142")]
   public class LPFElementListItemItem extends LPFElementListItem
   {

      public var check:detailedCheck;

      public var eqpBG:MovieClip;

      public var hit:MovieClip;

      public var icon:MovieClip;

      public var iconAC:LPFIconAC;

      public var iconRing:LPFIconRing;

      public var selBG:MovieClip;

      public var tLevel:TextField;

      public var tName:TextField;

      public var wearBG:MovieClip;

      public var sel:Boolean = false;

      private var rootClass:MovieClip;

      private var allowDesel:Boolean = false;

      private var bLimited:Boolean = false;

      private var multiSelect:Boolean = false;

      private const MAX_SELECTED:int = 100;

      private var redCT:ColorTransform = new ColorTransform(1,1,1,1,96,0,0,0);

      private var greenCT:ColorTransform = new ColorTransform(1,1,1,1,0,96,0,0);

      private var blueCT:ColorTransform = new ColorTransform(1,1,1,1,0,0,96,0);

      private var whiteCT:ColorTransform = new ColorTransform(1,1,1,1,64,64,64,0);

      private var orangeCT:ColorTransform = new ColorTransform(1,1,1,1,96,36,0,0);

      private var yellowCT:ColorTransform = new ColorTransform(1,1,1,1,96,64,24,0);

      private var purpleCT:ColorTransform = new ColorTransform(1,1,1,1,96,0,96,0);

      private var greyCT:ColorTransform = new ColorTransform(1,1,1,1,0,0,0,0);

      private var blackoutCT:ColorTransform = new ColorTransform(0,0,0,1,0,0,0,0);

      private var greyoutCT:ColorTransform = new ColorTransform(0,0,0,1,40,40,40,0);

      private var staffFilter:GlowFilter = new GlowFilter(16776960,1,5,5,5,1,false,true);

      private var mispricedFilter:GlowFilter = new GlowFilter(16711680,1,5,5,5,1,false,true);

      public function LPFElementListItemItem()
      {
         super();
         this.check.visible = false;
         this.check.mouseEnabled = false;
         addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver,false,0,true);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut,false,0,true);
      }

      override public function fOpen(param1:Object) : void
      {
         fData = param1.fData;
         if("eventType" in param1)
         {
            eventType = param1.eventType;
         }
         if("allowDesel" in param1)
         {
            this.allowDesel = param1.allowDesel == true;
         }
         if("bLimited" in param1)
         {
            this.bLimited = param1.bLimited == true;
         }
         if("multiSelect" in param1)
         {
            this.multiSelect = param1.multiSelect == true;
         }
         this.rootClass = MovieClip(stage.getChildAt(0));
         this.fDraw();
      }

      override protected function fDraw() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Number = NaN;
         var _loc3_:Class = null;
         var _loc4_:* = undefined;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Object = this.rootClass.world.myAvatar.dataLeaf;
         var _loc8_:int = this.hit.width - 2;
         var _loc9_:String = "<font color=\'#FFFFFF\'>" + fData.sName + "</font>";
         if(fData.bUpg == 1)
         {
            _loc9_ = "<font color=\'#FCC749\'>" + fData.sName + "</font>";
         }
         if(fData.iLvl > _loc7_.intLevel || fData.EnhLvl != null && fData.EnhLvl > _loc7_.intLevel)
         {
            _loc9_ = "<font color=\'#FF0000\'>" + fData.sName + "</font>";
         }
         if(Boolean(this.bLimited) && fData.iQtyRemain <= 0)
         {
            _loc9_ = "<font color=\'#666666\'>" + fData.sName + "</font>";
         }
         this.tName.htmlText = _loc9_;
         if(fData.iRty != null)
         {
         }
         if(this.rootClass.world.enhPatternTree == null)
         {
            this.rootClass.world.initPatternTree();
         }
         if(["Weapon","he","ar","ba"].indexOf(fData.sES) > -1)
         {
            if(fData.PatternID != null)
            {
               _loc1_ = this.rootClass.world.enhPatternTree[fData.PatternID];
            }
            if(fData.EnhPatternID != null)
            {
               _loc1_ = this.rootClass.world.enhPatternTree[fData.EnhPatternID];
            }
            if(_loc1_ != null)
            {
            }
         }
         if(this.bLimited)
         {
            this.tName.htmlText += "<font color=\'#AA0000\'> x" + fData.iQtyRemain + "</font>";
         }
         else if(fData.iStk > 1)
         {
            this.tName.htmlText += "<font color=\'#999999\'> x" + fData.iQty + "</font>";
         }
         if(fData.sES == "ar" && fData.EnhID > 0)
         {
            _loc2_ = Number(this.rootClass.getRankFromPoints(fData.iQty));
            this.tName.htmlText += "<font color=\'#999999\'>, Rank " + _loc2_ + "</font>";
         }
         if(fData.EnhLvl != null && fData.EnhLvl > 0)
         {
            this.tLevel.htmlText = "<font color=\'#00CCFF\'>" + fData.EnhLvl + "</font>";
         }
         else if(fData.iLvl != null && fData.iLvl > 0)
         {
            this.tLevel.htmlText = "<font color=\'#FFFFFF\'>" + fData.iLvl + "</font>";
         }
         else
         {
            this.tLevel.visible = false;
         }
         this.iconAC.visible = false;
         if("bCoins" in fData && fData.bCoins == 1)
         {
            this.iconAC.visible = true;
         }
         var _loc10_:* = 23;
         var _loc11_:* = 19;
         var _loc12_:* = 13;
         var _loc13_:* = 11;
         var _loc14_:* = _loc10_;
         var _loc15_:* = _loc11_;
         var _loc16_:String = "";
         this.icon.removeAllChildren();
         this.icon.visible = false;
         try
         {
            if(fData.sType.toLowerCase() == "enhancement")
            {
               _loc16_ = this.rootClass.getIconBySlot(fData.sES);
            }
            else if(fData.sType.toLowerCase() == "serveruse" || fData.sType.toLowerCase() == "clientuse")
            {
               if("sFile" in fData && fData.sFile.length > 0 && this.rootClass.world.getClass(fData.sFile) != null)
               {
                  _loc16_ = fData.sFile;
               }
               else
               {
                  _loc16_ = fData.sIcon;
               }
            }
            else if(fData.sIcon == null || fData.sIcon == "" || fData.sIcon == "none")
            {
               if(fData.sLink.toLowerCase() != "none")
               {
                  _loc16_ = "iidesign";
               }
               else
               {
                  _loc16_ = "iibag";
               }
            }
            else
            {
               _loc16_ = fData.sIcon;
            }
            try
            {
               _loc3_ = this.rootClass.world.getClass(_loc16_) as Class;
               _loc4_ = this.icon.addChild(new _loc3_());
               _loc14_ = _loc4_.width;
               _loc15_ = _loc4_.height;
               _loc5_ = 0;
               _loc6_ = 0;
               if(fData.sType.toLowerCase() == "enhancement")
               {
                  _loc5_ = (_loc10_ - _loc12_) / 4 - 1;
                  _loc6_ = (_loc11_ - _loc13_) / 4 - 1;
                  _loc10_ = _loc12_;
                  _loc11_ = _loc13_;
               }
               if(_loc14_ > _loc15_)
               {
                  _loc4_.scaleX = _loc4_.scaleY = _loc10_ / _loc14_;
               }
               else
               {
                  _loc4_.scaleX = _loc4_.scaleY = _loc11_ / _loc15_;
               }
               _loc4_.x = -(_loc4_.width / 2) + _loc5_;
               _loc4_.y = -(_loc4_.height / 2) + _loc6_;
               this.icon.visible = true;
            }
            catch(e:Error)
            {
            }
            this.iconRing.visible = true;
            this.iconRing.y = this.iconRing.y = 2;
            this.iconRing.width = this.iconRing.height = 25;
            if(fData.sType.toLowerCase() == "enhancement")
            {
               this.icon.transform.colorTransform = this.blackoutCT;
            }
            else if(fData.EnhLvl != null && fData.EnhLvl > 0)
            {
               this.iconRing.width = this.iconRing.height = 19;
               this.iconRing.x += 3;
               this.iconRing.y += 3;
            }
            else
            {
               this.iconRing.visible = false;
               if(["Weapon","he","ar","ba"].indexOf(fData.sES) > -1)
               {
                  this.icon.transform.colorTransform = this.greyoutCT;
               }
            }
            if(_loc1_ != null)
            {
               if(_loc1_.hasOwnProperty("COLOR"))
               {
                  this.iconRing.bg.transform.colorTransform = _loc1_.COLOR;
               }
               else
               {
                  this.iconRing.bg.transform.colorTransform = this.getCatCT(_loc1_.sDesc);
               }
            }
            this.wearBG.visible = false;
            this.eqpBG.visible = false;
            if(fData.bEquip)
            {
               this.eqpBG.visible = true;
            }
            else if(fData.hasOwnProperty("bWear") && Boolean(fData.bWear))
            {
               this.wearBG.visible = true;
            }
            this.selBG.alpha = 0;
            if(Boolean(this.rootClass.litePreference.data.bDebugger) && !this.rootClass.litePreference.data.dOptions["debugColor"])
            {
               if(Number(fData.bStaff) == 1)
               {
                  this.eqpBG.visible = true;
                  this.eqpBG.filters = [this.staffFilter];
               }
               else
               {
                  this.eqpBG.filters = [];
                  if(Number(fData.iCost) > 12000 && Number(fData.bCoins) == 1)
                  {
                     this.eqpBG.visible = true;
                     this.eqpBG.filters = [this.mispricedFilter];
                  }
                  else if(Number(fData.iCost) == 0)
                  {
                     this.eqpBG.visible = true;
                     this.eqpBG.filters = [this.mispricedFilter];
                  }
               }
            }
            buttonMode = true;
            mouseChildren = false;
         }
         catch(e:*)
         {
         }
      }

      override public function select() : void
      {
         this.sel = true;
         if(this.multiSelect)
         {
            this.check.visible = true;
         }
         else
         {
            this.selBG.alpha = 1;
         }
      }

      override public function deselect() : void
      {
         this.sel = false;
         if(this.multiSelect)
         {
            this.check.visible = false;
         }
         else
         {
            this.selBG.alpha = 0;
         }
      }

      override protected function onClick(param1:MouseEvent) : void
      {
         var _loc8_:MovieClip = null;
         if(!this.rootClass.isGreedyModalInStack())
         {
            if(this.multiSelect)
            {
               if(this.sel)
               {
                  this.deselect();
               }
               else if(LPFFrameListViewTabbed(fParent).getSelected() < this.MAX_SELECTED)
               {
                  this.select();
               }
               else
               {
                  this.rootClass.MsgBox.notify("You can only select up to a maximum of " + this.MAX_SELECTED + " items.");
               }
            }
            else if(!this.sel)
            {
               _loc8_ = LPFFrameListViewTabbed(fParent).getListItemByiSel();
               if(_loc8_ != null)
               {
                  _loc8_.deselect();
               }
               this.select();
            }
            else if(this.allowDesel)
            {
               this.deselect();
            }
            update();
         }
      }

      override protected function onMouseOver(param1:MouseEvent) : void
      {
         if(!this.sel)
         {
            this.selBG.alpha = 0.6;
         }
      }

      override protected function onMouseOut(param1:MouseEvent) : void
      {
         if(!this.sel)
         {
            this.selBG.alpha = 0;
         }
      }

      private function getCatCT(param1:String) : ColorTransform
      {
         var _loc8_:ColorTransform = this.greyCT;
         if(param1 == "M1")
         {
            _loc8_ = this.redCT;
         }
         if(param1 == "M2")
         {
            _loc8_ = this.greenCT;
         }
         if(param1 == "M3")
         {
            _loc8_ = this.yellowCT;
         }
         if(param1 == "C1")
         {
            _loc8_ = this.blueCT;
         }
         if(param1 == "C2")
         {
            _loc8_ = this.whiteCT;
         }
         if(param1 == "C3")
         {
            _loc8_ = this.orangeCT;
         }
         if(param1 == "S1")
         {
            _loc8_ = this.purpleCT;
         }
         if(param1 == "none")
         {
            _loc8_ = this.greyCT;
         }
         return _loc8_;
      }

      override public function fClose() : void
      {
         removeEventListener(MouseEvent.CLICK,this.onClick);
         removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         this.icon.removeAllChildren();
         this.rootClass = null;
         super.fClose();
      }
   }
}
