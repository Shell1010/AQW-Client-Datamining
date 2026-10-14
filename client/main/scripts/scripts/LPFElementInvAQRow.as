package
{
   import flash.display.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;
   import liteAssets.draw.*;

   public class LPFElementInvAQRow extends Sprite
   {

      private static var iconCache:Object = {};

      private static var mtx:Matrix = new Matrix();

      private static var ringClass:Class = null;

      private static var ringClassChecked:Boolean = false;

      private static var acClass:Class = null;

      private static var acClassChecked:Boolean = false;

      private static const RING_COLOR_TYPES:Array = ["Weapon","he","ar","ba"];

      public static const IDENTITY_CT:ColorTransform = new ColorTransform();

      public static const SILHOUETTE_CT:ColorTransform = new ColorTransform(0,0,0,1,34,34,34,0);

      public static const SILHOUETTE_PREVIEW_CT:ColorTransform = new ColorTransform(0,0,0,1,74,74,74,0);

      private static const SILHOUETTE_NAME:uint = 9079434;

      private static const BLACKOUT_CT:ColorTransform = new ColorTransform(0,0,0,1,0,0,0,0);

      private static const GREYOUT_CT:ColorTransform = new ColorTransform(0,0,0,1,40,40,40,0);

      private static const RED_CT:ColorTransform = new ColorTransform(1,1,1,1,96,0,0,0);

      private static const GREEN_CT:ColorTransform = new ColorTransform(1,1,1,1,0,96,0,0);

      private static const YELLOW_CT:ColorTransform = new ColorTransform(1,1,1,1,96,64,24,0);

      private static const BLUE_CT:ColorTransform = new ColorTransform(1,1,1,1,0,0,96,0);

      private static const WHITE_CT:ColorTransform = new ColorTransform(1,1,1,1,64,64,64,0);

      private static const ORANGE_CT:ColorTransform = new ColorTransform(1,1,1,1,96,36,0,0);

      private static const PURPLE_CT:ColorTransform = new ColorTransform(1,1,1,1,96,0,96,0);

      private static const GREY_CT:ColorTransform = new ColorTransform(1,1,1,1,0,0,0,0);

      private static var lvlColW:Number = 0;

      private static var lvlNumW:Number = 0;

      public var item:Object;

      public var rowW:int = 200;

      public var priceText:String = null;

      public var priceCoins:Boolean = false;

      public var locked:Boolean = false;

      public var limitedStock:Boolean = false;

      public var markCheck:Boolean = false;

      public var silhouette:Boolean = false;

      public var lvlLabel:Boolean = true;

      private var rootClass:MovieClip;

      private var selected:Boolean = false;

      private var equipped:Boolean = false;

      private var hovered:Boolean = false;

      private var linkage:String = null;

      private var bg:Shape;

      private var ring:MovieClip;

      private var iconHolder:Sprite;

      private var acIcon:DisplayObject;

      private var acClip:Sprite;

      private var acRect:Rectangle;

      private var checkMC:DisplayObject;

      private var lockIcon:DisplayObject;

      private var favStar:Shape;

      private var tfName:TextField;

      private var tfLvlLabel:TextField;

      private var tfLvl:TextField;

      private var tfPrice:TextField;

      private var fmtName:TextFormat;

      private var fmtSuffix:TextFormat;

      private var fmtPriceWhite:TextFormat;

      private var fmtPriceGoldSuffix:TextFormat;

      public function LPFElementInvAQRow()
      {
         var ringCls:Class;
         var acCls:Class;
         var natH:Number = NaN;
         this.acRect = new Rectangle();
         super();
         mouseChildren = false;
         buttonMode = true;
         this.bg = new Shape();
         addChild(this.bg);
         ringCls = getIconRingClass();
         if(ringCls != null)
         {
            try
            {
               this.ring = new ringCls() as MovieClip;
            }
            catch(e:Error)
            {
               ring = null;
            }
            if(this.ring != null)
            {
               addChild(this.ring);
            }
         }
         this.iconHolder = new Sprite();
         this.iconHolder.mouseEnabled = false;
         this.iconHolder.mouseChildren = false;
         addChild(this.iconHolder);
         this.fmtName = new TextFormat("Arial",12,13421772,true);
         this.fmtSuffix = new TextFormat("Arial",12,10066329,true);
         this.tfName = makeTF(12,13421772,true);
         this.tfName.x = 38;
         addChild(this.tfName);
         acCls = getIconACClass();
         if(acCls != null)
         {
            try
            {
               this.acIcon = new acCls() as DisplayObject;
            }
            catch(e:Error)
            {
               acIcon = null;
            }
            if(this.acIcon != null)
            {
               natH = Number(this.acIcon.height);
               if(natH > 0)
               {
                  this.acIcon.scaleX = this.acIcon.scaleY = LPFFrameInvAQ.ROW_H / natH;
               }
               this.acIcon.alpha = 0.4;
               this.acClip = new Sprite();
               this.acClip.mouseEnabled = this.acClip.mouseChildren = false;
               this.acClip.visible = false;
               this.acClip.addChild(this.acIcon);
               addChild(this.acClip);
            }
         }
         this.tfLvlLabel = makeTF(11,8947848);
         this.tfLvlLabel.text = "Lvl";
         addChild(this.tfLvlLabel);
         this.tfLvl = makeTF(12,16777215,true);
         if(lvlColW <= 0)
         {
            this.tfLvl.text = "999";
            lvlColW = this.tfLvlLabel.width + this.tfLvl.width + 2;
            lvlNumW = this.tfLvl.width;
            this.tfLvl.text = "";
         }
         addChild(this.tfLvl);
         this.fmtPriceWhite = new TextFormat("Arial",12,16777215,true);
         this.fmtPriceGoldSuffix = new TextFormat("Arial",12,14725888,true);
         this.tfPrice = makeTF(12,16777215,true);
         this.tfPrice.visible = false;
         addChild(this.tfPrice);
         this.favStar = new Shape();
         this.favStar.graphics.lineStyle(1,FavStore.GOLD_DARK,1,true);
         this.favStar.graphics.beginFill(FavStore.GOLD);
         FavStore.drawStar(this.favStar.graphics,33,7,4.6);
         this.favStar.graphics.endFill();
         this.favStar.visible = false;
         addChild(this.favStar);
      }

      private static function getIconRingClass() : Class
      {
         if(!ringClassChecked)
         {
            ringClassChecked = true;
            try
            {
               ringClass = getDefinitionByName("LPFIconRing") as Class;
            }
            catch(e:Error)
            {
               ringClass = null;
            }
         }
         return ringClass;
      }

      private static function getIconACClass() : Class
      {
         if(!acClassChecked)
         {
            acClassChecked = true;
            try
            {
               acClass = getDefinitionByName("LPFIconAC") as Class;
            }
            catch(e:Error)
            {
               acClass = null;
            }
         }
         return acClass;
      }

      public static function makeTF(param1:int, param2:uint, param3:Boolean = false, param4:Boolean = false) : TextField
      {
         var _loc1_:TextField = new TextField();
         _loc1_.embedFonts = false;
         _loc1_.selectable = false;
         _loc1_.mouseEnabled = false;
         _loc1_.multiline = false;
         _loc1_.wordWrap = false;
         _loc1_.autoSize = TextFieldAutoSize.LEFT;
         _loc1_.defaultTextFormat = new TextFormat("Arial",param1,param2,param3,param4);
         return _loc1_;
      }

      public static function setRuns(param1:TextField, param2:String, param3:TextFormat, param4:String, param5:TextFormat) : void
      {
         param1.text = param2 + param4;
         if(param2.length > 0)
         {
            param1.setTextFormat(param3,0,param2.length);
         }
         if(param4.length > 0)
         {
            param1.setTextFormat(param5,param2.length,param2.length + param4.length);
         }
      }

      public static function centerAt(param1:DisplayObject, param2:Number, param3:Number) : void
      {
         param1.x = 0;
         param1.y = 0;
         var _loc1_:Rectangle = param1.getBounds(param1.parent);
         param1.x = Math.round(param2 - _loc1_.x - _loc1_.width / 2);
         param1.y = Math.round(param3 - _loc1_.y - _loc1_.height / 2);
      }

      private static function getCatCT(param1:String) : ColorTransform
      {
         switch(param1)
         {
            case "M1":
               return RED_CT;
            case "M2":
               return GREEN_CT;
            case "M3":
               return YELLOW_CT;
            case "C1":
               return BLUE_CT;
            case "C2":
               return WHITE_CT;
            case "C3":
               return ORANGE_CT;
            case "S1":
               return PURPLE_CT;
            default:
               return GREY_CT;
         }
      }

      public function bind(param1:Object, param2:MovieClip, param3:Boolean, param4:Boolean) : void
      {
         this.item = param1;
         this.rootClass = param2;
         this.selected = param3;
         this.equipped = param4;
         this.drawBG();
         var _loc1_:String = this.resolveLinkage(param1);
         if(_loc1_ != this.linkage)
         {
            this.linkage = _loc1_;
            this.drawIcon();
         }
         this.drawRing();
         this.drawCheck();
         this.drawLock();
         this.drawText();
         this.favStar.visible = this.priceText == null && Boolean(FavStore.has(param1.ItemID));
      }

      public function setHover(param1:Boolean) : void
      {
         if(this.hovered == param1)
         {
            return;
         }
         this.hovered = param1;
         if(this.item != null)
         {
            this.drawBG();
         }
      }

      public function destroy() : void
      {
         if(parent != null)
         {
            parent.removeChild(this);
         }
         while(this.iconHolder.numChildren > 0)
         {
            this.iconHolder.removeChildAt(0);
         }
         this.bg.graphics.clear();
         this.item = null;
         this.rootClass = null;
         this.checkMC = null;
         this.lockIcon = null;
         this.linkage = null;
      }

      private function drawBG() : void
      {
         var _loc1_:Graphics = this.bg.graphics;
         var _loc2_:int = LPFFrameInvAQ.ROW_H;
         _loc1_.clear();
         mtx.createGradientBox(this.rowW,_loc2_,Math.PI / 2,0,0);
         _loc1_.beginGradientFill(GradientType.LINEAR,[1776411,986895],[1,1],[0,255],mtx);
         _loc1_.drawRect(0,0,this.rowW,_loc2_);
         _loc1_.endFill();
         _loc1_.beginFill(2500134);
         _loc1_.drawRect(0,_loc2_ - 1,this.rowW,1);
         _loc1_.endFill();
         var _loc3_:Boolean = Boolean(this.equipped) && (int(this.item.bEquip) == 1 || this.item.bEquip === true);
         var _loc4_:Boolean = Boolean(this.equipped) && !_loc3_ && (int(this.item.bWear) == 1 || this.item.bWear === true);
         if(_loc3_)
         {
            mtx.createGradientBox(this.rowW,_loc2_,0,0,0);
            _loc1_.beginGradientFill(GradientType.LINEAR,[7340172,7340172],[0,1],[0,255],mtx);
            _loc1_.drawRect(0,0,this.rowW,_loc2_);
            _loc1_.endFill();
         }
         else if(_loc4_)
         {
            mtx.createGradientBox(this.rowW,_loc2_,0,0,0);
            _loc1_.beginGradientFill(GradientType.LINEAR,[10773,4302336],[0,1],[0,255],mtx);
            _loc1_.drawRect(0,0,this.rowW,_loc2_);
            _loc1_.endFill();
         }
         if(this.selected)
         {
            mtx.createGradientBox(this.rowW,_loc2_,0,0,0);
            _loc1_.beginGradientFill(GradientType.LINEAR,[26265,24720],[1,0],[0,255],mtx);
            _loc1_.drawRect(0,0,this.rowW,_loc2_);
            _loc1_.endFill();
         }
         else if(this.hovered)
         {
            mtx.createGradientBox(this.rowW,_loc2_,0,0,0);
            _loc1_.beginGradientFill(GradientType.LINEAR,[26265,24720],[0.6,0],[0,255],mtx);
            _loc1_.drawRect(0,0,this.rowW,_loc2_);
            _loc1_.endFill();
         }
      }

      private function getCls(param1:String) : Class
      {
         if(param1 == null || param1.length == 0 || this.rootClass == null)
         {
            return null;
         }
         var _loc1_:Class = iconCache[param1] as Class;
         if(_loc1_ != null)
         {
            return _loc1_;
         }
         _loc1_ = this.rootClass.world.getClass(param1);
         if(_loc1_ != null)
         {
            iconCache[param1] = _loc1_;
         }
         return _loc1_;
      }

      private function resolveLinkage(param1:Object) : String
      {
         var t:String = null;
         var o:Object = param1;
         var s:String = "";
         try
         {
            t = String(o.sType).toLowerCase();
            if(t == "enhancement")
            {
               s = this.rootClass.getIconBySlot(String(o.sES));
            }
            else if(t == "serveruse" || t == "clientuse")
            {
               if(o.sFile != null && String(o.sFile).length > 0 && this.getCls(String(o.sFile)) != null)
               {
                  s = String(o.sFile);
               }
               else
               {
                  s = String(o.sIcon);
               }
            }
            else if(o.sIcon == null || o.sIcon == "" || o.sIcon == "none")
            {
               s = o.sLink != null && String(o.sLink).toLowerCase() != "none" ? "iidesign" : "iibag";
            }
            else
            {
               s = String(o.sIcon);
            }
         }
         catch(e:Error)
         {
            s = "";
         }
         return s;
      }

      private function drawIcon() : void
      {
         var c:Class;
         var d:DisplayObject = null;
         var aw:Number = NaN;
         var ah:Number = NaN;
         var dx:Number = NaN;
         var dy:Number = NaN;
         var bw:Number = NaN;
         var bh:Number = NaN;
         while(this.iconHolder.numChildren > 0)
         {
            this.iconHolder.removeChildAt(0);
         }
         c = this.getCls(this.linkage);
         if(c == null)
         {
            this.linkage = null;
            return;
         }
         try
         {
            d = new c() as DisplayObject;
            if(d != null)
            {
               this.iconHolder.addChild(d);
               aw = 23;
               ah = 19;
               dx = 0;
               dy = 0;
               if(this.item != null && String(this.item.sType).toLowerCase() == "enhancement")
               {
                  dx = (23 - 13) / 4 - 1;
                  dy = (19 - 11) / 4 - 1;
                  aw = 13;
                  ah = 11;
               }
               bw = d.width;
               bh = d.height;
               if(bw > bh)
               {
                  if(bw > 0)
                  {
                     d.scaleX = d.scaleY = aw / bw;
                  }
               }
               else if(bh > 0)
               {
                  d.scaleX = d.scaleY = ah / bh;
               }
               d.x = 18 - d.width / 2 + dx;
               d.y = LPFFrameInvAQ.ROW_H / 2 - d.height / 2 + dy;
            }
         }
         catch(e:Error)
         {
            while(iconHolder.numChildren > 0)
            {
               iconHolder.removeChildAt(0);
            }
         }
      }

      private function fitCenter(param1:DisplayObject, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc1_:Number = param1.width > param1.height ? param1.width : param1.height;
         if(_loc1_ > 0)
         {
            param1.scaleX = param1.scaleY = param2 / _loc1_;
         }
         centerAt(param1,param3,param4);
      }

      private function setRingSize(param1:Number) : void
      {
         this.ring.width = param1;
         this.ring.height = param1;
         centerAt(this.ring,18,LPFFrameInvAQ.ROW_H / 2);
      }

      private function drawRing() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = this.item;
         var _loc3_:String = _loc2_.sType != null ? String(_loc2_.sType).toLowerCase() : "";
         var _loc4_:String = _loc2_.sES != null ? String(_loc2_.sES) : "";
         var _loc5_:Number = _loc2_.EnhLvl != null ? Number(_loc2_.EnhLvl) : 0;
         this.iconHolder.transform.colorTransform = IDENTITY_CT;
         if(this.ring != null)
         {
            this.ring.visible = true;
            this.setRingSize(25);
            if(this.ring.bg != null)
            {
               this.ring.bg.transform.colorTransform = IDENTITY_CT;
            }
         }
         if(_loc3_ == "enhancement")
         {
            this.iconHolder.transform.colorTransform = BLACKOUT_CT;
         }
         else if(_loc5_ > 0)
         {
            if(this.ring != null)
            {
               this.setRingSize(19);
            }
         }
         else
         {
            if(this.ring != null)
            {
               this.ring.visible = false;
            }
            if(RING_COLOR_TYPES.indexOf(_loc4_) > -1)
            {
               this.iconHolder.transform.colorTransform = GREYOUT_CT;
            }
         }
         if(RING_COLOR_TYPES.indexOf(_loc4_) > -1)
         {
            if(this.rootClass.world.enhPatternTree == null)
            {
               this.rootClass.world.initPatternTree();
            }
            _loc1_ = null;
            if(_loc2_.PatternID != null)
            {
               _loc1_ = this.rootClass.world.enhPatternTree[_loc2_.PatternID];
            }
            if(_loc2_.EnhPatternID != null)
            {
               _loc1_ = this.rootClass.world.enhPatternTree[_loc2_.EnhPatternID];
            }
            if(_loc1_ != null && this.ring != null && this.ring.bg != null)
            {
               this.ring.bg.transform.colorTransform = _loc1_.hasOwnProperty("COLOR") ? _loc1_.COLOR : getCatCT(String(_loc1_.sDesc));
            }
         }
         if(this.silhouette)
         {
            this.iconHolder.transform.colorTransform = SILHOUETTE_CT;
         }
      }

      private function drawCheck() : void
      {
         var c:Class = null;
         if(this.markCheck)
         {
            if(this.checkMC == null)
            {
               c = this.getCls("iCheck");
               if(c != null)
               {
                  try
                  {
                     this.checkMC = new c() as DisplayObject;
                  }
                  catch(e:Error)
                  {
                     checkMC = null;
                  }
                  if(this.checkMC != null)
                  {
                     addChild(this.checkMC);
                     this.fitCenter(this.checkMC,10,29,LPFFrameInvAQ.ROW_H / 2 + 9);
                  }
               }
            }
            if(this.checkMC != null)
            {
               this.checkMC.visible = true;
            }
         }
         else if(this.checkMC != null)
         {
            this.checkMC.visible = false;
         }
      }

      private function drawLock() : void
      {
         var c:Class = null;
         if(this.locked)
         {
            if(this.lockIcon == null)
            {
               c = this.getCls("iLock");
               if(c != null)
               {
                  try
                  {
                     this.lockIcon = new c() as DisplayObject;
                  }
                  catch(e:Error)
                  {
                     lockIcon = null;
                  }
                  if(this.lockIcon != null)
                  {
                     addChild(this.lockIcon);
                     this.fitCenter(this.lockIcon,12,7,LPFFrameInvAQ.ROW_H / 2 + 9);
                  }
               }
            }
            if(this.lockIcon != null)
            {
               this.lockIcon.visible = true;
            }
         }
         else if(this.lockIcon != null)
         {
            this.lockIcon.visible = false;
         }
      }

      private function playerLevel() : int
      {
         var _loc1_:Object = null;
         try
         {
            _loc1_ = this.rootClass.world.myAvatar;
            if(_loc1_.dataLeaf != null && _loc1_.dataLeaf.intLevel != null)
            {
               return int(_loc1_.dataLeaf.intLevel);
            }
            return int(_loc1_.objData.intLevel);
         }
         catch(e:Error)
         {
         }
         return int.MAX_VALUE;
      }

      private function applyName(param1:String, param2:String) : void
      {
         setRuns(this.tfName,param1,this.fmtName,param2,this.fmtSuffix);
      }

      private function drawPrice(param1:Number) : void
      {
         this.tfPrice.visible = true;
         var _loc1_:Boolean = false;
         if(this.priceText == "Free")
         {
            this.tfPrice.text = "Free";
            this.tfPrice.textColor = 8190976;
         }
         else if(this.priceText == "Sold Out")
         {
            this.tfPrice.text = "Sold Out";
            this.tfPrice.textColor = 8947848;
         }
         else if(this.priceCoins)
         {
            this.tfPrice.text = this.priceText;
            this.tfPrice.textColor = 16777215;
            _loc1_ = this.acIcon != null;
         }
         else
         {
            setRuns(this.tfPrice,this.priceText,this.fmtPriceWhite,"g",this.fmtPriceGoldSuffix);
         }
         this.tfPrice.x = Math.round(param1 - 6 - this.tfPrice.width);
         this.tfPrice.y = Math.round((LPFFrameInvAQ.ROW_H - this.tfPrice.height) / 2);
         if(this.acIcon != null)
         {
            this.acClip.visible = _loc1_;
            if(_loc1_)
            {
               this.placeAC(this.tfPrice.x + this.tfPrice.width / 2 - this.acIcon.width / 2,LPFFrameInvAQ.ROW_H);
            }
         }
      }

      private function drawText() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Object = this.item;
         var _loc7_:int = LPFFrameInvAQ.ROW_H;
         var _loc8_:String = _loc6_.sName != null ? String(_loc6_.sName) : "";
         var _loc9_:uint = this.selected ? 16777215 : 13421772;
         if(int(_loc6_.bUpg) == 1)
         {
            _loc9_ = 16566089;
         }
         var _loc10_:int = int(this.playerLevel());
         if(int(_loc6_.iLvl) > _loc10_ || _loc6_.EnhLvl != null && int(_loc6_.EnhLvl) > _loc10_)
         {
            _loc9_ = 16729156;
         }
         var _loc11_:Boolean = this.priceText != null;
         var _loc12_:Boolean = this.limitedStock && _loc6_.iQtyRemain != null;
         var _loc13_:String = "";
         if(_loc12_)
         {
            _loc13_ = " x" + _loc6_.iQtyRemain;
            this.fmtSuffix.color = 11141120;
            if(Number(_loc6_.iQtyRemain) <= 0)
            {
               _loc9_ = 6710886;
            }
         }
         else
         {
            this.fmtSuffix.color = 10066329;
            if(int(_loc6_.iStk) > 1)
            {
               _loc13_ += " x" + _loc6_.iQty;
            }
            if(_loc6_.sES == "ar" && int(_loc6_.EnhID) > 0)
            {
               _loc13_ += ", Rank " + this.rootClass.getRankFromPoints(int(_loc6_.iQty));
            }
         }
         if(this.silhouette)
         {
            _loc9_ = uint(SILHOUETTE_NAME);
         }
         this.fmtName.color = _loc9_;
         var _loc14_:Boolean = _loc6_.EnhLvl != null && int(_loc6_.EnhLvl) > 0;
         var _loc15_:int = _loc14_ ? int(_loc6_.EnhLvl) : int(_loc6_.iLvl);
         var _loc16_:Boolean = _loc15_ > 0;
         var _loc17_:Number = this.rowW - 8 - (this.lvlLabel ? lvlColW : lvlNumW);
         if(_loc16_)
         {
            this.tfLvl.text = String(_loc15_);
            this.tfLvl.textColor = _loc14_ ? 52479 : 16777215;
            this.tfLvl.x = this.rowW - 8 - this.tfLvl.width;
            this.tfLvl.y = Math.round((_loc7_ - this.tfLvl.height) / 2);
            this.tfLvlLabel.x = this.tfLvl.x - this.tfLvlLabel.width + 1;
            this.tfLvlLabel.y = this.tfLvl.y + this.tfLvl.height - this.tfLvlLabel.height - 1;
            this.tfLvl.visible = true;
            this.tfLvlLabel.visible = this.lvlLabel;
         }
         else
         {
            this.tfLvl.visible = false;
            this.tfLvlLabel.visible = false;
         }
         var _loc18_:Boolean = !_loc11_ && this.acIcon != null && int(_loc6_.bCoins) == 1;
         var _loc19_:Number = this.acIcon != null ? _loc17_ - 6 - this.acIcon.width : _loc17_ - 6;
         if(_loc11_)
         {
            this.drawPrice(_loc17_);
            _loc1_ = this.tfPrice.x - 6 - 38;
         }
         else
         {
            this.tfPrice.visible = false;
            _loc1_ = (_loc18_ ? _loc19_ - 4 : _loc17_ - 6) - 38;
         }
         this.applyName(_loc8_,_loc13_);
         if(this.tfName.textWidth > _loc1_ && _loc8_.length > 0)
         {
            _loc2_ = 0;
            _loc3_ = _loc8_.length - 1;
            _loc4_ = 0;
            while(_loc2_ <= _loc3_)
            {
               _loc5_ = _loc2_ + _loc3_ >> 1;
               this.applyName(_loc8_.substr(0,_loc5_) + "…",_loc13_);
               if(this.tfName.textWidth <= _loc1_)
               {
                  _loc4_ = _loc5_;
                  _loc2_ = _loc5_ + 1;
               }
               else
               {
                  _loc3_ = _loc5_ - 1;
               }
            }
            this.applyName(_loc8_.substr(0,_loc4_) + "…",_loc13_);
         }
         this.tfName.y = Math.round((_loc7_ - this.tfName.height) / 2);
         if(this.acIcon != null && !_loc11_)
         {
            this.acClip.visible = _loc18_;
            if(_loc18_)
            {
               this.placeAC(_loc19_,_loc7_);
            }
         }
      }

      private function placeAC(param1:Number, param2:int) : void
      {
         var _loc1_:int = Math.ceil(this.acIcon.width);
         this.acClip.x = Math.round(param1);
         this.acClip.y = 0;
         centerAt(this.acIcon,_loc1_ / 2,param2 / 2);
         this.acRect.setTo(0,0,_loc1_,param2 - 1);
         this.acClip.scrollRect = this.acRect;
      }
   }
}
