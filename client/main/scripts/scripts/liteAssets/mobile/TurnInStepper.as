package liteAssets.mobile
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Rectangle;
   import flash.text.*;
   import flash.utils.*;

   public class TurnInStepper extends Sprite
   {

      private static const GAP:Number = 4;

      private static const ROW_GAP:Number = 6;

      private static const FW_K:Number = 1.27;

      private static const MW_K:Number = 1.36;

      private var maxVal:int;

      private var val:int = 1;

      private var label:TextField;

      private var baseLabel:String;

      private var field:TextField;

      private var repeat:Timer;

      private var step:int = 0;

      private var upStage:Stage;

      private var minusB:QuestButton;

      private var plusB:QuestButton;

      private var maxB:QuestButton;

      private var h:Number;

      public function TurnInStepper(param1:int, param2:TextField, param3:Number = 0)
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         super();
         this.maxVal = Math.max(1,param1);
         this.label = param2;
         this.baseLabel = param2 != null ? param2.text : "";
         if(Mobile.active)
         {
            this.h = Mobile.touchPx(7);
            if(param3 > 0 && this.h * (2 + FW_K + MW_K) + GAP * 3 > param3)
            {
               this.h = Math.floor((param3 - GAP * 3) / (2 + FW_K + MW_K));
            }
            _loc1_ = Number(this.h);
            _loc2_ = Math.round(this.h * FW_K);
            _loc3_ = Math.round(this.h * MW_K);
         }
         else
         {
            this.h = 24;
            _loc1_ = 24;
            _loc2_ = 40;
            _loc3_ = 38;
         }
         var _loc4_:int = Math.max(14,Math.round(this.h * 0.5));
         var _loc5_:Number = 0;
         this.minusB = this.makeButton(String.fromCharCode(8722),_loc1_,_loc4_,_loc5_,this.onMinusDown);
         _loc5_ += _loc1_ + GAP;
         this.field = this.makeField(_loc2_,_loc5_);
         addChild(this.field);
         _loc5_ += _loc2_ + GAP;
         this.plusB = this.makeButton("+",_loc1_,_loc4_,_loc5_,this.onPlusDown);
         _loc5_ += _loc1_ + GAP;
         this.maxB = this.makeButton("Max",_loc3_,Math.max(11,Math.round(this.h * 0.32)),_loc5_,null);
         this.maxB.addEventListener(MouseEvent.CLICK,this.onMax,false,0,true);
         this.repeat = new Timer(400,0);
         this.repeat.addEventListener(TimerEvent.TIMER,this.onRepeat,false,0,true);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved,false,0,true);
         this.refresh();
      }

      public static function create(param1:DisplayObjectContainer, param2:DisplayObject, param3:DisplayObject, param4:int, param5:TextField) : TurnInStepper
      {
         var _loc1_:DisplayObjectContainer = param2 as DisplayObjectContainer;
         NativeArt.captureQuestButton(_loc1_);
         var _loc2_:Rectangle = visual(param2,param1);
         var _loc3_:Rectangle = param3 != null ? visual(param3,param1) : null;
         var _loc4_:Number = _loc3_ != null ? _loc3_.x : _loc2_.x;
         var _loc5_:Number = _loc2_.x + _loc2_.width + (_loc2_.x - _loc4_);
         var _loc6_:TurnInStepper = new TurnInStepper(param4,param5,_loc5_ - _loc4_);
         param1.addChild(_loc6_);
         _loc6_.place(_loc2_,_loc4_,_loc5_);
         return _loc6_;
      }

      private static function visual(param1:DisplayObject, param2:DisplayObject) : Rectangle
      {
         var _loc1_:DisplayObjectContainer = param1 as DisplayObjectContainer;
         var _loc2_:Rectangle = _loc1_ != null ? NativeArt.artBounds(_loc1_,param2) : null;
         return _loc2_ != null ? _loc2_ : param1.getBounds(param2);
      }

      public function get value() : int
      {
         this.commit();
         return this.val;
      }

      public function destroy() : void
      {
         this.stopRepeat();
         this.repeat.removeEventListener(TimerEvent.TIMER,this.onRepeat);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
         this.field.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKey);
         this.field.removeEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
         if(stage != null && stage.focus == this.field)
         {
            stage.focus = stage;
         }
         this.minusB.destroy();
         this.plusB.destroy();
         this.maxB.destroy();
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }

      private function place(param1:Rectangle, param2:Number, param3:Number) : void
      {
         var _loc1_:Number = width;
         var _loc2_:Number = Math.round(param1.x + (param1.width - _loc1_) / 2);
         _loc2_ = Math.max(param2,Math.min(param3 - _loc1_,_loc2_));
         x = _loc2_;
         y = Math.round(param1.y - ROW_GAP - this.h);
      }

      private function makeButton(param1:String, param2:Number, param3:int, param4:Number, param5:Function) : QuestButton
      {
         var _loc1_:QuestButton = new QuestButton(param1,int(param2),int(this.h),param3);
         _loc1_.x = param4;
         if(param5 != null)
         {
            _loc1_.addEventListener(MouseEvent.MOUSE_DOWN,param5,false,0,true);
         }
         addChild(_loc1_);
         return _loc1_;
      }

      private function makeField(param1:Number, param2:Number) : TextField
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.lineStyle(1,13673792,0.55,true);
         _loc1_.graphics.beginFill(65793,0.92);
         _loc1_.graphics.drawRoundRect(0.5,0.5,param1 - 1,this.h - 1,10,10);
         _loc1_.graphics.endFill();
         _loc1_.x = param2;
         _loc1_.mouseEnabled = false;
         addChild(_loc1_);
         var _loc2_:TextField = new TextField();
         var _loc3_:TextFormat = new TextFormat("Arial",Mobile.active ? Math.max(16,Math.round(this.h * 0.36)) : 16,16777215,true);
         _loc3_.align = TextFormatAlign.CENTER;
         _loc2_.embedFonts = false;
         _loc2_.defaultTextFormat = _loc3_;
         _loc2_.type = TextFieldType.INPUT;
         _loc2_.restrict = "0-9";
         _loc2_.maxChars = 4;
         _loc2_.text = "Wg";
         _loc2_.width = param1 - 4;
         _loc2_.height = _loc2_.textHeight + 4;
         _loc2_.text = "";
         _loc2_.x = param2 + 2;
         _loc2_.y = Math.round((this.h - _loc2_.height) / 2);
         _loc2_.addEventListener(KeyboardEvent.KEY_DOWN,this.onKey,false,0,true);
         _loc2_.addEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut,false,0,true);
         return _loc2_;
      }

      private function commit() : void
      {
         var _loc1_:int = int(this.field.text);
         if(_loc1_ < 1)
         {
            _loc1_ = 1;
         }
         if(_loc1_ > this.maxVal)
         {
            _loc1_ = int(this.maxVal);
         }
         if(_loc1_ != this.val || this.field.text != String(_loc1_))
         {
            this.val = _loc1_;
            this.refresh();
         }
      }

      private function refresh() : void
      {
         this.field.text = String(this.val);
         this.minusB.enabled = this.val > 1;
         this.plusB.enabled = this.val < this.maxVal;
         this.maxB.enabled = this.val < this.maxVal;
         if(this.label != null)
         {
            this.label.text = this.val > 1 ? "Turn In " + String.fromCharCode(215) + this.val : this.baseLabel;
         }
      }

      private function setVal(param1:int) : void
      {
         this.val = Math.max(1,Math.min(this.maxVal,param1));
         this.refresh();
      }

      private function onKey(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 13)
         {
            this.commit();
            if(stage != null)
            {
               stage.focus = stage;
            }
         }
      }

      private function onFocusOut(param1:FocusEvent) : void
      {
         this.commit();
      }

      private function onMax(param1:MouseEvent) : void
      {
         this.setVal(this.maxVal);
      }

      private function onMinusDown(param1:MouseEvent) : void
      {
         this.startRepeat(-1);
      }

      private function onPlusDown(param1:MouseEvent) : void
      {
         this.startRepeat(1);
      }

      private function startRepeat(param1:int) : void
      {
         this.commit();
         this.step = param1;
         this.setVal(this.val + param1);
         this.repeat.reset();
         this.repeat.delay = 400;
         this.repeat.start();
         if(this.upStage == null && stage != null)
         {
            this.upStage = stage;
            this.upStage.addEventListener(MouseEvent.MOUSE_UP,this.onUp,false,0,true);
         }
      }

      private function onRepeat(param1:TimerEvent) : void
      {
         if(this.repeat.delay != 80)
         {
            this.repeat.delay = 80;
         }
         this.setVal(this.val + this.step);
      }

      private function onUp(param1:MouseEvent) : void
      {
         this.stopRepeat();
      }

      private function stopRepeat() : void
      {
         this.repeat.stop();
         if(this.upStage != null)
         {
            this.upStage.removeEventListener(MouseEvent.MOUSE_UP,this.onUp);
            this.upStage = null;
         }
      }

      private function onRemoved(param1:Event) : void
      {
         this.stopRepeat();
      }
   }
}
