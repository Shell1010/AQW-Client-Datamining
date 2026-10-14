package
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol2115")]
   public class LPFElementSimpleItem extends MovieClip
   {

      public static const ROW_H:int = 26;

      public static const ROW_H2:int = 40;

      public static const TWO_LINE_W:int = 200;

      private static const PAD_L:int = 18;

      public var tName:TextField;

      public var tQty:TextField;

      private var rootClass:MovieClip;

      protected var eventType:String = "";

      protected var sMode:String;

      public var fData:Object = {};

      public var fParent:LPFFrame;

      public var rowW:int = 240;

      public var stripe:Boolean = false;

      private var rowH:int = 26;

      private var plate:Shape;

      private var badge:Shape;

      private var hovered:Boolean = false;

      private var pct:Number = 0;

      private var full:Boolean = false;

      public function LPFElementSimpleItem()
      {
         super();
         this.plate = new Shape();
         addChildAt(this.plate,0);
         this.badge = new Shape();
         addChild(this.badge);
         mouseChildren = false;
         addEventListener(MouseEvent.ROLL_OVER,this.onRoll,false,0,true);
         addEventListener(MouseEvent.ROLL_OUT,this.onRoll,false,0,true);
      }

      public function get rowHeight() : int
      {
         return this.rowH;
      }

      private function get twoLine() : Boolean
      {
         return this.rowW < TWO_LINE_W;
      }

      protected function update() : void
      {
      }

      public function fOpen(param1:Object) : void
      {
         this.fData = param1.fData;
         if("eventType" in param1)
         {
            this.eventType = param1.eventType;
         }
         this.rootClass = MovieClip(stage.getChildAt(0));
         this.fDraw();
      }

      public function fClose() : void
      {
         this.fData = null;
         removeEventListener(MouseEvent.ROLL_OVER,this.onRoll);
         removeEventListener(MouseEvent.ROLL_OUT,this.onRoll);
         parent.removeChild(this);
      }

      private function onRoll(param1:MouseEvent) : void
      {
         this.hovered = param1.type == MouseEvent.ROLL_OVER;
         this.drawPlate();
      }

      private function get realQty() : int
      {
         var _loc1_:Number = Number(this.fData.iQty);
         var _loc2_:* = MovieClip(MovieClip(MovieClip(MovieClip(parent).parent).parent).parent);
         if(_loc2_.iQty > 1)
         {
            _loc1_ = this.fData.iQty * Math.floor(_loc2_.iQty / _loc2_.iSel.iQty);
         }
         return _loc1_;
      }

      protected function fDraw() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = "#7CFC00";
         var _loc3_:String = "#FF4444";
         var _loc4_:String = "#999999";
         var _loc5_:Object = this.rootClass.world.invTree[this.fData.ItemID];
         var _loc6_:int = 0;
         var _loc7_:Boolean = false;
         if(_loc5_ != null)
         {
            _loc6_ = int(_loc5_.iQty);
         }
         if(_loc6_ >= this.realQty)
         {
            _loc7_ = true;
         }
         if(_loc7_)
         {
            _loc1_ = "<font color=\'" + _loc2_ + "\'>" + _loc6_ + "/" + this.realQty + "</font>";
         }
         else
         {
            _loc1_ = "<font color=\'" + _loc3_ + "\'>" + _loc6_ + "/" + this.realQty + "</font>";
            if(this.rootClass.world.bankinfo != null && Boolean(this.rootClass.world.bankinfo.isItemInBank(this.fData.ItemID)))
            {
               _loc1_ += "<font color=\'" + _loc4_ + "\'> (+" + this.rootClass.world.bankinfo.getBankItem(this.fData.ItemID).iQty + " in bank)</font>";
            }
         }
         this.tQty.wordWrap = false;
         this.tQty.autoSize = TextFieldAutoSize.LEFT;
         this.tQty.htmlText = _loc1_;
         this.tName.autoSize = TextFieldAutoSize.LEFT;
         this.tName.wordWrap = true;
         this.tName.x = PAD_L;
         if(this.twoLine)
         {
            this.tName.width = this.rowW - 6 - PAD_L;
            this.tName.htmlText = String(this.fData.sName);
            this.tName.y = 3;
            this.tQty.x = PAD_L;
            this.tQty.y = this.tName.y + this.tName.height - 3;
            this.rowH = Math.max(ROW_H2,int(this.tQty.y + this.tQty.height + 4));
         }
         else
         {
            this.tQty.x = this.rowW - 6 - this.tQty.width;
            this.tName.width = this.tQty.x - 6 - PAD_L;
            this.tName.htmlText = String(this.fData.sName);
            this.rowH = Math.max(ROW_H,int(this.tName.height + 8));
            this.tQty.y = Math.round((ROW_H - 2 - this.tQty.height) / 2);
            this.tName.y = Math.round((this.rowH - 2 - this.tName.height) / 2);
         }
         this.pct = this.realQty > 0 ? Math.min(1,_loc6_ / this.realQty) : 1;
         this.full = _loc7_;
         this.drawPlate();
         this.drawBadge();
      }

      private function drawPlate() : void
      {
         var _loc1_:Graphics = this.plate.graphics;
         _loc1_.clear();
         var _loc2_:int = int(this.rowH);
         _loc1_.beginFill(this.stripe ? 2302755 : 1842204);
         _loc1_.drawRect(0,0,this.rowW,_loc2_);
         _loc1_.endFill();
         if(this.hovered)
         {
            _loc1_.beginFill(4862488,0.45);
            _loc1_.drawRect(0,0,this.rowW,_loc2_);
            _loc1_.endFill();
            _loc1_.lineStyle(1,13145646,1,true);
            _loc1_.drawRect(0.5,0.5,this.rowW - 1,_loc2_ - 1);
            _loc1_.lineStyle();
         }
         var _loc3_:int = this.rowW - PAD_L - 6;
         _loc1_.beginFill(3026478);
         _loc1_.drawRect(PAD_L,_loc2_ - 4,_loc3_,2);
         _loc1_.endFill();
         var _loc4_:int = Math.round(_loc3_ * this.pct);
         if(_loc4_ > 0)
         {
            _loc1_.beginFill(this.full ? 4302336 : 13145646);
            _loc1_.drawRect(PAD_L,_loc2_ - 4,_loc4_,2);
            _loc1_.endFill();
         }
      }

      private function drawBadge() : void
      {
         var _loc1_:Graphics = this.badge.graphics;
         _loc1_.clear();
         this.badge.x = 9;
         this.badge.y = Math.round(this.tName.y + Math.min(this.tName.height,18) / 2);
         if(!this.full)
         {
            _loc1_.lineStyle(1.5,5592405,1,true);
            _loc1_.drawCircle(0,0,4.5);
            return;
         }
         _loc1_.beginFill(4302336);
         _loc1_.drawCircle(0,0,6);
         _loc1_.endFill();
         _loc1_.lineStyle(1.8,16777215,1,true);
         _loc1_.moveTo(-2.8,0.2);
         _loc1_.lineTo(-0.8,2.3);
         _loc1_.lineTo(3,-2.4);
      }

      public function subscribeTo(param1:LPFFrame) : void
      {
         this.fParent = param1;
      }

      public function select() : void
      {
      }

      public function deselect() : void
      {
      }

      protected function onClick(param1:MouseEvent) : void
      {
      }

      protected function onMouseOver(param1:MouseEvent) : void
      {
      }

      protected function onMouseOut(param1:MouseEvent) : void
      {
      }
   }
}
