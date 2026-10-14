package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.ui.*;
   import liteAssets.mobile.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol1905")]
   public class LPFFrameQtySelector extends LPFFrame
   {

      private static var _active:LPFFrameQtySelector;

      public var bar:MovieClip;

      public var handle:MovieClip;

      public var t1:TextField;

      public var t2:TextField;

      private var _min:int = 1;

      private var _max:int = 1;

      private var isMouseDown:Boolean = false;

      private var _p:Point = new Point();

      private var _n:Number = 0;

      private var _w:int = 0;

      private var _dx:Number = 0;

      private var _strip:Sprite;

      private var _bar:MovieClip;

      private var _hd:MovieClip;

      private var _t2:DisplayObject;

      private var _t1:TextField;

      private var _step:QtyStepper;

      private var rootClass:MovieClip;

      protected var eventType:String = "";

      public function LPFFrameQtySelector()
      {
         super();
         visible = false;
         this._bar = this.bar;
         this._hd = this.handle;
         this._t2 = getChildByName("t2");
         this._t1 = TextField(getChildByName("t1"));
         this._w = this._bar.width - this._hd.width;
         this.t1.restrict = "0123456789";
         this.t1.maxChars = 4;
         this._hd.buttonMode = true;
      }

      public static function commitActive() : Boolean
      {
         var _loc1_:LPFFrameQtySelector = _active;
         if(_loc1_ == null || _loc1_.stage == null || !_loc1_.visible || _loc1_.fData == null)
         {
            return true;
         }
         if(_loc1_.commit())
         {
            return true;
         }
         if(_loc1_.rootClass != null)
         {
            if(_loc1_.rootClass.MsgBox != null)
            {
               _loc1_.rootClass.MsgBox.notify("Enter a quantity first.");
            }
            _loc1_.rootClass.stage.focus = _loc1_._t1;
            _loc1_._t1.setSelection(0,_loc1_._t1.text.length);
         }
         return false;
      }

      private function get qty_container() : *
      {
         return MovieClip(MovieClip(parent).parent);
      }

      public function get _val() : int
      {
         return this.qty_container.iQty;
      }

      public function set _val(param1:int) : void
      {
         this.qty_container.iQty = param1;
         this.t1.text = String(param1);
      }

      public function get val() : int
      {
         var _loc1_:int = int(this.t1.text);
         if(getLayout().sMode == "shopBuy")
         {
            _loc1_ = fData.iQty * Math.floor(_loc1_ / fData.iQty);
         }
         if(this._val != _loc1_)
         {
            this._val = _loc1_;
         }
         this._val = Math.max(Math.min(this._val,this._max),this._min);
         return this._val;
      }

      public function set val(param1:int) : void
      {
         this._val = this.fit(param1);
      }

      private function fit(param1:int) : int
      {
         var _loc1_:int = param1;
         if(getLayout().sMode == "shopBuy")
         {
            _loc1_ = fData.iQty * Math.floor(param1 / fData.iQty);
         }
         return Math.max(Math.min(_loc1_,this._max),this._min);
      }

      private function stepSize() : int
      {
         var _loc1_:int = int(fData.iQty);
         return getLayout().sMode == "shopBuy" && _loc1_ > 1 ? _loc1_ : 1;
      }

      private function onStep(param1:int) : void
      {
         if(fData == null)
         {
            return;
         }
         this.val += param1 * this.stepSize();
         this.updateValues();
         this.updateHandle();
      }

      private function refreshStep() : void
      {
         if(this._step == null || fData == null)
         {
            return;
         }
         var _loc1_:Boolean = this.fit(this._max) > this._min;
         this._step.visible = _loc1_;
         if(this._t2 != null)
         {
            this._t2.visible = !_loc1_;
         }
         if(!_loc1_)
         {
            return;
         }
         var _loc2_:int = int(this.stepSize());
         this._step.refresh(this.fit(this._val - _loc2_) < this._val,this.fit(this._val + _loc2_) > this._val,this.fit(this._max) > this._val);
      }

      private function buildStep(param1:Object) : void
      {
         if(this._step != null)
         {
            this._step.destroy();
         }
         var _loc1_:Number = this._bar.x + this._bar.width / 2;
         this._step = new QtyStepper(this,this.onStep,this.onMax);
         this._w = this._bar.width - this._hd.width;
         if(param1 != null && "center" in param1 && Boolean(param1.center))
         {
            x += Math.round(_loc1_ - this._step.midX);
         }
      }

      private function updateValues() : void
      {
         if(this._val == this._max)
         {
            this.t1.htmlText = "<font color=\'#FFFFFF\'>" + this._val + "</font>";
         }
         else
         {
            this.t1.htmlText = "<font color=\'#999999\'>" + this._val + "</font>";
         }
         update({"eventType":"updateQtyValue"});
         this.refreshStep();
      }

      private function updateHandle() : void
      {
         this._hd.x = Math.round(this._bar.x + this._w * (this._val / this._max));
      }

      private function dragTo(param1:Number, param2:Number) : void
      {
         this._p.x = param1;
         this._p.y = param2;
         this._p = globalToLocal(this._p);
         this._p.x -= this._dx;
         this._hd.x = this._n = Math.max(Math.min(this._p.x,this._bar.x + this._w),this._bar.x);
         this._n -= this._bar.x;
         this._n /= this._w;
         this.val = Math.round(this._n * this._max);
         this.updateValues();
      }

      private function beginDrag() : void
      {
         this.isMouseDown = true;
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMove,false,0,true);
      }

      private function onMove(param1:MouseEvent) : void
      {
         if(this.isMouseDown)
         {
            this.dragTo(param1.stageX,param1.stageY);
         }
      }

      private function onDn(param1:MouseEvent) : void
      {
         this._p.x = param1.stageX;
         this._p.y = param1.stageY;
         this._p = globalToLocal(this._p);
         this._dx = this._p.x - this._hd.x;
         this.beginDrag();
      }

      private function onBarDn(param1:MouseEvent) : void
      {
         var _loc1_:DisplayObject = param1.target as DisplayObject;
         if(_loc1_ == this._hd || _loc1_ != null && Boolean(this._hd.contains(_loc1_)))
         {
            return;
         }
         var _loc2_:Rectangle = this._hd.getBounds(this._hd);
         this._dx = _loc2_.x + _loc2_.width / 2;
         this.beginDrag();
         this.dragTo(param1.stageX,param1.stageY);
      }

      private function onUp(param1:MouseEvent) : void
      {
         this.isMouseDown = false;
         if(stage != null)
         {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMove);
         }
      }

      private function buildTouch() : void
      {
         var _loc1_:DisplayObjectContainer = null;
         if(!Mobile.active)
         {
            return;
         }
         var _loc2_:Rectangle = QtyTouch.band(this._bar,this._hd,[getChildByName("t1"),getChildByName("t2")]);
         if(this._step != null)
         {
            _loc2_ = this._step.trim(_loc2_);
         }
         var _loc3_:Rectangle = QtyTouch.strip(this._bar,_loc2_);
         TouchTargets.pad(this._hd,0,0,_loc2_);
         if(this._strip == null)
         {
            this._strip = new Sprite();
            this._strip.graphics.beginFill(0,0);
            this._strip.graphics.drawRect(0,0,_loc3_.width,_loc3_.height);
            this._strip.graphics.endFill();
            this._strip.addEventListener(MouseEvent.MOUSE_DOWN,this.onBarDn,false,0,true);
            _loc1_ = this._hd.parent;
            _loc1_.addChildAt(this._strip,_loc1_.getChildIndex(this._hd));
         }
         this._strip.x = _loc3_.x;
         this._strip.y = _loc3_.y;
      }

      private function commit() : Boolean
      {
         var _loc1_:Boolean = this._t1.text == "" || int(this._t1.text) <= 0;
         if(!_loc1_)
         {
            this.val;
         }
         this.updateValues();
         this.updateHandle();
         return !_loc1_;
      }

      private function onChange(param1:Event) : void
      {
         if(fData == null || this._t1.text == "")
         {
            return;
         }
         var _loc1_:int = int(this._t1.text);
         if(_loc1_ > this._max)
         {
            this._val = this._max;
            this.updateValues();
         }
         else
         {
            this.qty_container.iQty = this.fit(_loc1_);
            update({"eventType":"updateQtyValue"});
            this.refreshStep();
         }
         this.updateHandle();
      }

      private function onFocusOut(param1:FocusEvent) : void
      {
         if(fData != null)
         {
            this.commit();
         }
      }

      private function onKey(param1:KeyboardEvent) : void
      {
         if(param1.charCode == Keyboard.ENTER || param1.charCode == Keyboard.ESCAPE)
         {
            this.val;
            this.updateValues();
            this.updateHandle();
            this.rootClass.stage.focus = null;
         }
      }

      override public function fOpen(param1:Object) : void
      {
         visible = false;
         this.rootClass = MovieClip(stage.getChildAt(0));
         positionBy(param1.r);
         if("eventTypes" in param1)
         {
            eventTypes = param1.eventTypes;
         }
         if("fData" in param1)
         {
            fData = param1.fData;
         }
         this.buildStep(param1.r);
         getLayout().registerForEvents(this,eventTypes);
         this.fDraw();
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onUp,false,0,true);
         this._bar.addEventListener(MouseEvent.MOUSE_DOWN,this.onBarDn,false,0,true);
         this.buildTouch();
         this._hd.addEventListener(MouseEvent.MOUSE_DOWN,this.onDn,false,0,true);
         this.t1.addEventListener(KeyboardEvent.KEY_DOWN,this.onKey,false,0,true);
         this._t1.addEventListener(Event.CHANGE,this.onChange,false,0,true);
         this._t1.addEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut,false,0,true);
         _active = this;
         this.t2.addEventListener(MouseEvent.CLICK,this.onMax,false,0,true);
      }

      private function onMax(param1:MouseEvent = null) : void
      {
         this.val = this._max;
         this.updateValues();
         this.updateHandle();
      }

      override public function fClose() : void
      {
         this._bar.removeEventListener(MouseEvent.MOUSE_DOWN,this.onBarDn);
         if(this._strip != null)
         {
            this._strip.removeEventListener(MouseEvent.MOUSE_DOWN,this.onBarDn);
            if(this._strip.parent != null)
            {
               this._strip.parent.removeChild(this._strip);
            }
            this._strip = null;
         }
         if(this._step != null)
         {
            this._step.destroy();
            this._step = null;
         }
         TouchTargets.unpad(this._hd);
         this._hd.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDn);
         this.t1.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKey);
         this._t1.removeEventListener(Event.CHANGE,this.onChange);
         this._t1.removeEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
         if(_active == this)
         {
            _active = null;
         }
         this.t2.removeEventListener(MouseEvent.CLICK,this.onMax);
         if(stage != null)
         {
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.onUp);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMove);
         }
         getLayout().unregisterFrame(this);
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }

      protected function fDraw() : void
      {
         if(this._step != null)
         {
            this._step.stop();
         }
         if(fData != null)
         {
            if(getLayout().sMode == "shopSell")
            {
               this._val = this._min = 1;
               this._max = this.rootClass.world.maximumShopSells(fData);
            }
            else
            {
               this._val = this._min = fData.iQty;
               this._max = this.rootClass.world.maximumShopBuys(fData);
            }
            this.val;
            this.updateValues();
            this.updateHandle();
            this.t2.htmlText = "<font color=\'#FFFFFF\'>" + this._max + "</font>";
            visible = true;
         }
         else
         {
            visible = false;
         }
      }

      override public function notify(param1:Object) : void
      {
         if(param1.eventType == "listItemASel")
         {
            if("fData" in param1 && Boolean(param1.fData.hasOwnProperty("iSel")))
            {
               if(this.rootClass.ui.mcPopup.currentLabel == "EnhShop")
               {
                  return;
               }
               if(getLayout().sMode == "shopBuy" && (this.rootClass.world.maximumShopBuys(param1.fData.iSel) < 2 || param1.fData.iSel.bCoins == 1 && param1.fData.iSel.iCost > 0))
               {
                  fData = null;
               }
               else if(getLayout().sMode == "shopSell" && this.rootClass.world.maximumShopSells(param1.fData.iSel) < 2)
               {
                  fData = null;
               }
               else
               {
                  fData = param1.fData.iSel;
               }
            }
            this.fDraw();
         }
      }
   }
}
