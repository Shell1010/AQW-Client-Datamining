package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import liteAssets.mobile.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol1895")]
   public class LPFFrameSimpleList extends LPFFrame
   {

      private static const SB_W:int = 5;

      private static const PAD:int = 8;

      public var bg:MovieClip;

      public var iList:MovieClip;

      public var ti:TextField;

      private var plate:MovieClip;

      private var rootClass:MovieClip;

      private var r:Object;

      private var footMsg:String = "";

      private var listBaseY:Number = 0;

      private var bgBaseY:Number = 0;

      private var maskMC:Shape;

      private var sbTrack:Sprite;

      private var sbThumb:Sprite;

      private var touchScroll:TouchScroll;

      private var wheelStage:Stage;

      private var dragStage:Stage;

      private var scrollY:Number = 0;

      private var maxScroll:Number = 0;

      private var viewH:int = 0;

      private var thumbH:int = 0;

      private var dragOff:Number = 0;

      private var closed:Boolean = false;

      private var lastData:Object;

      public function LPFFrameSimpleList()
      {
         super();
         x = 0;
         y = 0;
         fData = null;
      }

      override public function fOpen(param1:Object) : void
      {
         this.rootClass = MovieClip(stage.getChildAt(0));
         if("fData" in param1)
         {
            fData = param1.fData;
         }
         this.r = param1.r;
         w = int(this.r.w);
         this.listBaseY = this.iList.y;
         this.bgBaseY = this.bg.y;
         if(this.r.vCenter)
         {
            this.plate = new LPFFrameBackdrop();
            this.plate.visible = false;
            addChildAt(this.plate,0);
         }
         this.ti.autoSize = "left";
         if("eventTypes" in param1)
         {
            eventTypes = param1.eventTypes;
         }
         if("msg" in fData && fData.msg.length > 0)
         {
            this.footMsg = fData.msg;
         }
         this.fDraw();
         positionBy(this.r);
         this.wheelStage = stage;
         if(this.wheelStage != null)
         {
            this.wheelStage.addEventListener(MouseEvent.MOUSE_WHEEL,this.onStageWheel,true,0,true);
         }
         getLayout().registerForEvents(this,eventTypes);
      }

      override public function fClose() : void
      {
         this.closed = true;
         this.clearScroll();
         if(this.wheelStage != null)
         {
            this.wheelStage.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onStageWheel,true);
         }
         this.wheelStage = null;
         fData = null;
         getLayout().unregisterFrame(this);
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }

      private function fDraw() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Number = fData != null && fData === this.lastData ? Number(this.scrollY) : 0;
         this.lastData = fData;
         while(this.iList.numChildren > 0)
         {
            this.iList.removeChildAt(0);
         }
         this.clearScroll();
         if(fData != null && fData.turnin != null)
         {
            _loc1_ = InvCat.isToken(fData) ? fData.turnin.concat([{
               "ItemID":int(fData.TokID),
               "sName":InvCat.tokenName(fData,this.rootClass.world),
               "iQty":int(fData.TokQty)
            }]) : fData.turnin;
            _loc2_ = int(this.capHeight());
            _loc3_ = int(this.iList.x) * 2;
            _loc4_ = this.buildRows(_loc1_,int(w) - _loc3_);
            _loc5_ = int(_loc4_[_loc4_.length - 1]);
            _loc6_ = _loc2_ > 0 && _loc5_ + this.listBaseY * 2 > _loc2_;
            if(_loc6_)
            {
               _loc4_ = this.buildRows(_loc1_,int(w) - _loc3_ - SB_W - 3);
               _loc5_ = int(_loc4_[_loc4_.length - 1]);
            }
            _loc7_ = _loc2_;
            if(_loc6_)
            {
               _loc9_ = int(_loc4_[1]);
               for each(_loc10_ in _loc4_)
               {
                  if(_loc10_ + this.listBaseY * 2 <= _loc7_)
                  {
                     _loc9_ = _loc10_;
                  }
               }
               _loc7_ = _loc9_ + int(this.listBaseY * 2);
            }
            this.bg.visible = false;
            this.bg.width = int(w);
            this.bg.height = _loc6_ ? _loc7_ : int(_loc5_ + this.listBaseY * 2) + 1;
            _loc8_ = int(this.centerOffset(_loc6_ ? 0 : int(int(this.bg.height) + PAD * 2)));
            this.iList.y = this.listBaseY + _loc8_;
            this.bg.y = this.bgBaseY + _loc8_;
            this.placePlate(this.bg.y,this.bg.height);
            this.ti.width = int(w - 2);
            this.ti.htmlText = this.footMsg;
            this.ti.visible = this.ti.htmlText.length > 0;
            this.ti.y = this.bg.height + 2;
            visible = true;
            if(_loc6_)
            {
               this.buildScroll(_loc5_);
               this.setScroll(_loc11_);
            }
         }
         else if(this.r != null && "emptyMsg" in this.r)
         {
            this.bg.visible = false;
            this.ti.width = int(w - 2);
            this.ti.htmlText = this.r.emptyMsg;
            this.ti.y = PAD + this.centerOffset(int(this.ti.height) + PAD * 2);
            this.placePlate(this.ti.y - 4,this.ti.height + 8);
            this.ti.visible = true;
            visible = true;
         }
         else
         {
            visible = false;
         }
      }

      private function placePlate(param1:Number, param2:Number) : void
      {
         if(this.plate == null)
         {
            return;
         }
         this.plate.bg.width = int(w);
         this.plate.bg.height = int(param2 + PAD * 2);
         this.plate.x = 0;
         this.plate.y = int(param1 - PAD);
         this.plate.visible = true;
      }

      private function buildRows(param1:Array, param2:int) : Array
      {
         var _loc1_:int = 0;
         var _loc2_:LPFElementSimpleItem = null;
         while(this.iList.numChildren > 0)
         {
            this.iList.removeChildAt(0);
         }
         var _loc3_:Array = [0];
         _loc1_ = 0;
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc2_ = new LPFElementSimpleItem();
            _loc2_.rowW = param2;
            _loc2_.stripe = _loc4_ % 2 == 1;
            this.iList.addChild(_loc2_);
            _loc2_.fOpen({"fData":param1[_loc4_]});
            _loc2_.x = 0;
            _loc2_.y = _loc1_;
            _loc1_ += _loc2_.rowHeight;
            _loc3_.push(_loc1_);
            _loc4_++;
         }
         return _loc3_;
      }

      private function centerOffset(param1:int) : int
      {
         if(param1 <= 0 || this.r == null || !this.r.vCenter || !("maxH" in this.r))
         {
            return 0;
         }
         var _loc1_:int = int(this.capHeight());
         return Math.max(0,Math.floor((_loc1_ - param1) / 2));
      }

      private function capHeight() : int
      {
         return this.r != null && "maxH" in this.r ? int(this.r.maxH) : 0;
      }

      private function buildScroll(param1:int) : void
      {
         this.viewH = int(this.bg.height);
         this.maxScroll = Math.max(0,param1 + this.listBaseY * 2 - this.viewH);
         this.maskMC = new Shape();
         this.maskMC.graphics.beginFill(0);
         this.maskMC.graphics.drawRect(0,0,this.bg.width,this.viewH);
         this.maskMC.graphics.endFill();
         this.maskMC.x = this.bg.x;
         this.maskMC.y = this.bg.y;
         addChild(this.maskMC);
         this.iList.mask = this.maskMC;
         this.sbTrack = new Sprite();
         this.sbTrack.x = this.bg.x + this.bg.width - SB_W - 2;
         this.sbTrack.y = this.bg.y + 2;
         var _loc1_:Graphics = this.sbTrack.graphics;
         _loc1_.beginFill(0,0.35);
         _loc1_.drawRoundRect(0,0,SB_W,this.viewH - 4,SB_W,SB_W);
         _loc1_.endFill();
         this.sbThumb = new Sprite();
         this.sbThumb.buttonMode = true;
         this.sbTrack.addChild(this.sbThumb);
         addChild(this.sbTrack);
         var _loc2_:int = this.viewH - 4;
         this.thumbH = Math.max(24,Math.min(_loc2_,int(_loc2_ * this.viewH / (param1 + this.listBaseY * 2))));
         var _loc3_:Matrix = new Matrix();
         _loc3_.createGradientBox(SB_W,this.thumbH,0,0,0);
         _loc1_ = this.sbThumb.graphics;
         _loc1_.lineStyle(1,13145646,1,true);
         _loc1_.beginGradientFill(GradientType.LINEAR,[8912896,14155776,8912896],[1,1,1],[0,127,255],_loc3_);
         _loc1_.drawRoundRect(0,0,SB_W,this.thumbH,SB_W,SB_W);
         _loc1_.endFill();
         this.sbTrack.addEventListener(MouseEvent.MOUSE_DOWN,this.onTrackDown,false,0,true);
         this.touchScroll = TouchScroll.attach(this.iList,this.touchGetPos,this.setScroll,this.touchGetMax);
         this.setScroll(0);
      }

      private function clearScroll() : void
      {
         this.endDrag();
         if(this.touchScroll != null)
         {
            this.touchScroll.detach();
            this.touchScroll = null;
         }
         if(this.sbTrack != null)
         {
            this.sbTrack.removeEventListener(MouseEvent.MOUSE_DOWN,this.onTrackDown);
            if(this.sbTrack.parent != null)
            {
               this.sbTrack.parent.removeChild(this.sbTrack);
            }
         }
         if(this.maskMC != null && this.maskMC.parent != null)
         {
            this.maskMC.parent.removeChild(this.maskMC);
         }
         this.iList.mask = null;
         this.sbTrack = null;
         this.sbThumb = null;
         this.maskMC = null;
         this.scrollY = 0;
         this.maxScroll = 0;
         this.iList.y = this.listBaseY;
      }

      private function setScroll(param1:Number) : void
      {
         this.scrollY = Math.max(0,Math.min(this.maxScroll,param1));
         this.iList.y = Math.round(this.listBaseY - this.scrollY);
         if(this.sbThumb != null)
         {
            this.sbThumb.y = this.maxScroll > 0 ? Math.round((this.viewH - 4 - this.thumbH) * this.scrollY / this.maxScroll) : 0;
         }
      }

      private function touchGetPos() : Number
      {
         return this.scrollY;
      }

      private function touchGetMax() : Number
      {
         return this.maxScroll;
      }

      private function onStageWheel(param1:MouseEvent) : void
      {
         if(Boolean(this.closed) || this.maskMC == null || !visible || stage == null)
         {
            return;
         }
         if(!this.maskMC.hitTestPoint(param1.stageX,param1.stageY,true))
         {
            return;
         }
         this.setScroll(this.scrollY - param1.delta * 12);
      }

      private function onTrackDown(param1:MouseEvent) : void
      {
         if(this.sbThumb == null)
         {
            return;
         }
         if(param1.target == this.sbThumb)
         {
            this.dragOff = this.sbTrack.mouseY - this.sbThumb.y;
            this.dragStage = stage;
            if(this.dragStage != null)
            {
               this.dragStage.addEventListener(MouseEvent.MOUSE_MOVE,this.onDragMove,false,0,true);
               this.dragStage.addEventListener(MouseEvent.MOUSE_UP,this.onDragUp,false,0,true);
            }
         }
         else
         {
            this.setScroll(this.scrollY + (this.sbTrack.mouseY < this.sbThumb.y ? -this.viewH : this.viewH));
         }
      }

      private function onDragMove(param1:MouseEvent) : void
      {
         if(this.sbTrack == null)
         {
            return;
         }
         var _loc1_:Number = this.viewH - 4 - this.thumbH;
         if(_loc1_ <= 0)
         {
            return;
         }
         this.setScroll((this.sbTrack.mouseY - this.dragOff) / _loc1_ * this.maxScroll);
      }

      private function onDragUp(param1:MouseEvent) : void
      {
         this.endDrag();
      }

      private function endDrag() : void
      {
         if(this.dragStage == null)
         {
            return;
         }
         this.dragStage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onDragMove);
         this.dragStage.removeEventListener(MouseEvent.MOUSE_UP,this.onDragUp);
         this.dragStage = null;
      }

      override public function notify(param1:Object) : void
      {
         if(param1.eventType == "listItemASel")
         {
            fData = null;
            if(param1.fData != null && param1.fData.oSel != null)
            {
               fData = param1.fData.oSel;
            }
            this.fDraw();
            positionBy(this.r);
         }
         if(param1.eventType == "refreshItems")
         {
            this.fDraw();
            positionBy(this.r);
         }
         if(param1.eventType == "updateQtyValue")
         {
            this.fDraw();
            positionBy(this.r);
         }
      }
   }
}
