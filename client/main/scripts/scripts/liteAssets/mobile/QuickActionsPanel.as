package liteAssets.mobile
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.TextField;
   import flash.utils.*;
   import liteAssets.draw.*;

   public class QuickActionsPanel extends KeybindsPanel
   {

      private static var inst:QuickActionsPanel;

      private static const DIR_ROW:String = "Tray opens toward";

      private static const MODES:Array = ["Off","Tray","Button"];

      private static const SIDES:Array = ["Left","Right"];

      private static const SEG_W:int = 76;

      private static const SEG_GAP:int = 4;

      private var segs:Object = {};

      private var segW:int = 76;

      public function QuickActionsPanel(param1:MovieClip)
      {
         super(param1);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onGone,false,0,true);
         if(m)
         {
            this.segW = Math.max(SEG_W,Math.round(pillH * 1.5));
         }
      }

      public static function open(param1:MovieClip) : void
      {
         if(param1 == null || param1.stage == null)
         {
            return;
         }
         if(inst != null && inst.stage != null)
         {
            inst.parent.setChildIndex(inst,inst.parent.numChildren - 1);
            return;
         }
         inst = new QuickActionsPanel(param1);
         param1.stage.addChild(inst);
         inst.layout();
      }

      private function onGone(param1:Event) : void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onGone);
         if(inst == this)
         {
            inst = null;
         }
      }

      override protected function titleText() : String
      {
         return "Quick Actions";
      }

      override protected function searchHint() : String
      {
         return "Search actions";
      }

      override protected function idleNote() : String
      {
         return "Pick Tray or Button, then press Move.";
      }

      override protected function noteW() : int
      {
         return W - OUT * 2 - BTN_W * 3 - 42;
      }

      override protected function layout() : void
      {
         var _loc1_:VolumeButton = null;
         super.layout();
         _loc1_ = new VolumeButton(BTN_W,btnH,"Move");
         _loc1_.x = resetBtn.x - BTN_W - 12;
         _loc1_.y = resetBtn.y;
         _loc1_.addEventListener(MouseEvent.CLICK,this.onMoveClick,false,0,true);
         if(m)
         {
            TouchTargets.pad(_loc1_);
         }
         win.addChild(_loc1_);
      }

      private function onMoveClick(param1:MouseEvent) : void
      {
         if(!ActionPad.beginMove())
         {
            setNote("Set an action to Tray or Button first.",16751226);
            return;
         }
         try
         {
            if(game.ui.mcPopup.currentLabel == "Option")
            {
               game.ui.mcPopup.onClose();
            }
         }
         catch(err:Error)
         {
         }
         close();
      }

      override protected function resetLabel() : String
      {
         return "Clear All";
      }

      override protected function columns() : int
      {
         return 1;
      }

      override protected function sections() : Array
      {
         return [["Tray",[DIR_ROW]]].concat(KeybindsPanel.SECTIONS);
      }

      override protected function listed(param1:String) : Boolean
      {
         return Boolean(QuickActions.eligible(param1)) || QuickActions.modeOf(param1) != QuickActions.OFF;
      }

      override protected function build() : void
      {
         this.segs = {};
         super.build();
      }

      override protected function buildRow(param1:String, param2:int, param3:int, param4:int) : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:TextField = null;
         var _loc3_:Array = null;
         var _loc4_:VolumeButton = null;
         _loc1_ = new Sprite();
         _loc1_.name = param1;
         _loc1_.x = param2;
         _loc1_.y = param3;
         _loc1_.graphics.beginFill(0,0);
         _loc1_.graphics.drawRect(0,0,param4,rowH);
         _loc1_.graphics.endFill();
         _loc1_.addEventListener(MouseEvent.ROLL_OVER,onRowOver,false,0,true);
         _loc1_.addEventListener(MouseEvent.ROLL_OUT,onRowOut,false,0,true);
         content.addChild(_loc1_);
         var _loc5_:Array = param1 == DIR_ROW ? SIDES : MODES;
         var _loc6_:int = _loc5_.length * this.segW + (_loc5_.length - 1) * SEG_GAP;
         _loc2_ = MailArt.tf(13,15919317,true);
         _loc2_.filters = [textShadow()];
         _loc2_.text = param1;
         MailArt.fit(_loc2_,param4 - _loc6_ - 12);
         _loc2_.x = 4;
         _loc2_.y = Math.round((rowH - _loc2_.height) / 2);
         _loc1_.addChild(_loc2_);
         _loc3_ = [];
         var _loc7_:int = 0;
         while(_loc7_ < _loc5_.length)
         {
            _loc4_ = new VolumeButton(this.segW,pillH,_loc5_[_loc7_],12);
            _loc4_.name = String(_loc7_);
            _loc4_.x = param4 - _loc6_ + _loc7_ * (this.segW + SEG_GAP);
            _loc4_.y = Math.round((rowH - pillH) / 2);
            _loc4_.addEventListener(MouseEvent.CLICK,this.onSeg,false,0,true);
            _loc1_.addChild(_loc4_);
            _loc3_.push(_loc4_);
            _loc7_++;
         }
         this.segs[param1] = _loc3_;
         this.showSeg(param1);
      }

      private function chosen(param1:String) : int
      {
         if(param1 == DIR_ROW)
         {
            return QuickActions.left ? 0 : 1;
         }
         return QuickActions.modeOf(param1);
      }

      private function showSeg(param1:String) : void
      {
         var _loc1_:VolumeButton = null;
         var _loc2_:Array = this.segs[param1];
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:int = int(this.chosen(param1));
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc1_ = _loc2_[_loc4_];
            _loc1_.selected = _loc4_ == _loc3_;
            _loc1_.dim = _loc4_ != _loc3_;
            _loc4_++;
         }
      }

      private function onSeg(param1:MouseEvent) : void
      {
         var _loc1_:DisplayObject = DisplayObject(param1.currentTarget);
         var _loc2_:String = _loc1_.parent.name;
         var _loc3_:int = int(_loc1_.name);
         if(_loc2_ == DIR_ROW)
         {
            QuickActions.left = _loc3_ == 0;
            setNote("The tray opens to the " + SIDES[_loc3_].toLowerCase() + ".",10477690);
         }
         else
         {
            QuickActions.setMode(_loc2_,_loc3_);
            if(_loc3_ == QuickActions.OFF)
            {
               setNote(_loc2_ + " removed.",9079434);
            }
            else
            {
               setNote(_loc2_ + " added as a " + (_loc3_ == QuickActions.TRAY ? "tray action" : "button") + ".",10477690);
            }
         }
         this.showSeg(_loc2_);
      }

      override protected function onReset(param1:MouseEvent) : void
      {
         var modal:*;
         var e:MouseEvent = param1;
         var cls:Class = null;
         try
         {
            cls = getDefinitionByName("ModalMC") as Class;
         }
         catch(err:Error)
         {
            cls = null;
         }
         if(cls == null)
         {
            this.doClear({"accept":true});
            return;
         }
         modal = new cls();
         game.stage.addChild(modal);
         modal.init({
            "strBody":"Remove every quick action?",
            "params":{},
            "callback":this.doClear,
            "glow":"red,medium",
            "greedy":true
         });
      }

      private function doClear(param1:Object) : void
      {
         if(param1 == null || !param1.accept)
         {
            return;
         }
         QuickActions.clear();
         setNote("All quick actions removed.",10477690);
         this.build();
      }
   }
}
