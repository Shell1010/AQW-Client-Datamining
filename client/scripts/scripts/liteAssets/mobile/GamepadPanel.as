package liteAssets.mobile
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.text.TextField;
   import flash.ui.*;
   import flash.utils.*;
   import liteAssets.draw.*;

   public class GamepadPanel extends Sprite
   {

      private static var current:GamepadPanel;

      private static const NAMES:Array = ["Auto Attack","Skill 1","Skill 2","Skill 3","Skill 4","Potion","Target Monster","Cancel Target","Options","Inventory","Dash"];

      private static const ROWS:int = 6;

      private static const W:int = 534;

      private static const OUT:int = 16;

      private static const WELL_Y:int = 66;

      private static const WELL_PAD:int = 8;

      private static const COL_GAP:int = 18;

      private static const ROW_H:int = 38;

      private static const PILL_W:int = 92;

      private static const PILL_H:int = 28;

      private static const BTN_W:int = 112;

      private static const BTN_H:int = 32;

      private static const OPEN_MS:int = 120;

      private var game:MovieClip;

      private var pills:Array = [];

      private var status:TextField;

      private var defaultsBtn:VolumeButton;

      private var doneBtn:VolumeButton;

      private var bg:MovieClip;

      private var backdrop:Sprite = new Sprite();

      private var pivot:Sprite = new Sprite();

      private var win:Sprite = new Sprite();

      private var m:Boolean = Mobile.active;

      private var pw:int = 534;

      private var ph:int = 0;

      private var rowH:int = 38;

      private var pillH:int = 28;

      private var btnH:int = 32;

      private var waiting:int = -1;

      private var openAt:int = 0;

      private var noteUntil:int = 0;

      public function GamepadPanel(param1:MovieClip)
      {
         super();
         this.game = param1;
         if(this.m)
         {
            this.pillH = Math.max(PILL_H,Mobile.touchPx(8));
            this.rowH = Math.max(ROW_H,this.pillH + 8);
            this.btnH = Math.max(BTN_H,Mobile.touchPx(8));
            this.rowH = Math.min(this.rowH,int((544 - (WELL_Y + WELL_PAD * 2 + 14 + this.btnH + 18)) / ROWS));
            this.pillH = Math.min(this.pillH,this.rowH - 6);
         }
         this.ph = WELL_Y + WELL_PAD * 2 + this.rowH * ROWS + 14 + this.btnH + 18;
         addChild(this.backdrop);
         addChild(this.pivot);
         this.pivot.addChild(this.win);
         this.backdrop.addEventListener(MouseEvent.CLICK,this.onBackdrop,false,0,true);
         addEventListener(Event.ADDED_TO_STAGE,this.onAdded,false,0,true);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved,false,0,true);
      }

      public static function get isOpen() : Boolean
      {
         return current != null && current.stage != null;
      }

      public static function open(param1:MovieClip) : void
      {
         if(param1 == null || param1.stage == null)
         {
            return;
         }
         if(current != null)
         {
            if(current.parent != null)
            {
               current.parent.setChildIndex(current,current.parent.numChildren - 1);
            }
            return;
         }
         current = new GamepadPanel(param1);
         param1.stage.addChild(current);
         current.layout();
      }

      private static function textShadow() : DropShadowFilter
      {
         return new DropShadowFilter(1,45,0,0.6,2,2,1,1);
      }

      private function onAdded(param1:Event) : void
      {
         GamePad.suspended = true;
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKey,true,200,true);
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKey,false,200,true);
         stage.addEventListener(Event.RESIZE,this.onResize,false,0,true);
         addEventListener(Event.ENTER_FRAME,this.onTick,false,0,true);
      }

      private function onRemoved(param1:Event) : void
      {
         GamePad.suspended = KeybindsPanel.isOpen;
         GamePad.cancelCapture();
         removeEventListener(Event.ENTER_FRAME,this.onAnim);
         removeEventListener(Event.ENTER_FRAME,this.onTick);
         if(stage != null)
         {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKey,true);
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKey,false);
            stage.removeEventListener(Event.RESIZE,this.onResize);
         }
         if(current == this)
         {
            current = null;
         }
      }

      private function onResize(param1:Event) : void
      {
         this.place();
      }

      private function onKey(param1:KeyboardEvent) : void
      {
         if(param1.keyCode != 27)
         {
            return;
         }
         param1.stopImmediatePropagation();
         if(this.waiting >= 0)
         {
            this.stopWaiting();
         }
         else
         {
            this.close();
         }
      }

      private function onBackdrop(param1:MouseEvent) : void
      {
         if(this.waiting >= 0)
         {
            this.stopWaiting();
         }
         else
         {
            this.close();
         }
      }

      public function close() : void
      {
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }

      private function layout() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.buildChrome();
         this.status = MailArt.tf(12,12303291,true);
         this.status.filters = [textShadow()];
         this.win.addChild(this.status);
         var _loc3_:int = WELL_PAD * 2 + this.rowH * ROWS;
         var _loc4_:Shape = new Shape();
         _loc4_.graphics.beginFill(657930);
         _loc4_.graphics.lineStyle(1,2763306,1,true);
         _loc4_.graphics.drawRoundRect(OUT,WELL_Y,this.pw - OUT * 2,_loc3_,12,12);
         _loc4_.graphics.endFill();
         _loc4_.filters = [new DropShadowFilter(2,90,0,0.5,4,4,1,1,true)];
         this.win.addChild(_loc4_);
         var _loc5_:int = int((this.pw - OUT * 2 - WELL_PAD * 2 - COL_GAP) / 2);
         var _loc6_:int = 0;
         while(_loc6_ < NAMES.length)
         {
            _loc1_ = _loc6_ < ROWS ? 0 : 1;
            _loc2_ = _loc6_ % ROWS;
            this.buildRow(_loc6_,OUT + WELL_PAD + _loc1_ * (_loc5_ + COL_GAP),WELL_Y + WELL_PAD + _loc2_ * this.rowH,_loc5_);
            _loc6_++;
         }
         var _loc7_:Shape = new Shape();
         _loc7_.graphics.beginFill(MailArt.TRIM,0.4);
         _loc7_.graphics.drawRect(int(this.pw / 2),WELL_Y + WELL_PAD + 4,1,this.rowH * ROWS - 8);
         _loc7_.graphics.endFill();
         this.win.addChild(_loc7_);
         var _loc8_:int = WELL_Y + _loc3_ + 14;
         this.defaultsBtn = new VolumeButton(BTN_W,this.btnH,"Defaults");
         this.defaultsBtn.x = int(this.pw / 2 - BTN_W - 10);
         this.defaultsBtn.y = _loc8_;
         this.defaultsBtn.addEventListener(MouseEvent.CLICK,this.onDefaults,false,0,true);
         this.win.addChild(this.defaultsBtn);
         this.doneBtn = new VolumeButton(BTN_W,this.btnH,"Done");
         this.doneBtn.x = int(this.pw / 2 + 10);
         this.doneBtn.y = _loc8_;
         this.doneBtn.addEventListener(MouseEvent.CLICK,this.onCloseClick,false,0,true);
         this.win.addChild(this.doneBtn);
         if(this.m)
         {
            TouchTargets.pad(this.defaultsBtn);
            TouchTargets.pad(this.doneBtn);
         }
         this.refresh();
         this.place();
         this.startAnim();
      }

      private function buildRow(param1:int, param2:int, param3:int, param4:int) : void
      {
         var _loc7_:int = 0;
         _loc7_ = param3 + int(this.rowH / 2);
         var _loc8_:TextField = MailArt.tf(13,15919317,true);
         _loc8_.filters = [textShadow()];
         _loc8_.text = NAMES[param1];
         MailArt.fit(_loc8_,param4 - PILL_W - 16);
         _loc8_.x = param2 + 8;
         _loc8_.y = Math.round(_loc7_ - _loc8_.textHeight / 2) - 2;
         this.win.addChild(_loc8_);
         var _loc1_:VolumeButton = new VolumeButton(PILL_W,this.pillH,"",13);
         _loc1_.name = String(param1);
         _loc1_.x = param2 + param4 - PILL_W - 6;
         _loc1_.y = _loc7_ - this.pillH / 2;
         _loc1_.addEventListener(MouseEvent.CLICK,this.onPill,false,0,true);
         if(this.m)
         {
            TouchTargets.pad(_loc1_);
         }
         this.win.addChild(_loc1_);
         this.pills[param1] = _loc1_;
      }

      private function onPill(param1:MouseEvent) : void
      {
         var _loc4_:int = int(param1.currentTarget.name);
         if(this.waiting == _loc4_)
         {
            this.stopWaiting();
            return;
         }
         if(GamePad.connectedName == null)
         {
            this.note("Connect a controller to change its buttons.",16751226);
            return;
         }
         this.stopWaiting();
         this.waiting = _loc4_;
         VolumeButton(this.pills[_loc4_]).selected = true;
         VolumeButton(this.pills[_loc4_]).label = "Press...";
         this.note("Press a button on your controller for " + NAMES[_loc4_] + ". Esc to cancel.",MailArt.GOLD);
         GamePad.capture(this.onCaptured);
      }

      private function onCaptured(param1:String) : void
      {
         var _loc4_:int = int(this.waiting);
         this.waiting = -1;
         if(_loc4_ < 0)
         {
            return;
         }
         GamePad.setBind(_loc4_,param1);
         this.noteUntil = 0;
         this.refresh();
      }

      private function stopWaiting() : void
      {
         if(this.waiting < 0)
         {
            return;
         }
         GamePad.cancelCapture();
         this.waiting = -1;
         this.noteUntil = 0;
         this.refresh();
      }

      private function onDefaults(param1:MouseEvent) : void
      {
         this.stopWaiting();
         GamePad.resetBinds();
         this.refresh();
      }

      private function note(param1:String, param2:uint) : void
      {
         this.status.textColor = param2;
         this.status.text = param1;
         MailArt.fit(this.status,this.pw - OUT * 2);
         this.status.x = int(this.pw / 2 - this.status.width / 2);
         this.status.y = WELL_Y - this.status.height - 4;
         this.noteUntil = getTimer() + 3000;
      }

      private function onTick(param1:Event) : void
      {
         if(this.waiting >= 0 && GamePad.connectedName == null)
         {
            this.stopWaiting();
            this.note("Controller disconnected.",16751226);
            return;
         }
         if(this.waiting >= 0 || this.noteUntil == 0 || getTimer() < this.noteUntil)
         {
            return;
         }
         this.noteUntil = 0;
         this.showStatus();
      }

      private function showStatus() : void
      {
         if(this.status == null)
         {
            return;
         }
         var _loc3_:String = GamePad.connectedName;
         if(!GameInput.isSupported)
         {
            this.status.textColor = 10066329;
            this.status.text = "Controllers aren\'t supported on this device.";
         }
         else if(_loc3_ == null)
         {
            this.status.textColor = 10066329;
            this.status.text = "No controller connected. Connect one to change its buttons.";
         }
         else
         {
            this.status.textColor = 10477690;
            this.status.text = "Connected: " + _loc3_;
         }
         MailArt.fit(this.status,this.pw - OUT * 2);
         this.status.x = int(this.pw / 2 - this.status.width / 2);
         this.status.y = WELL_Y - this.status.height - 4;
      }

      private function refresh() : void
      {
         var _loc4_:VolumeButton = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.pills.length)
         {
            _loc4_ = this.pills[_loc3_];
            _loc4_.selected = _loc3_ == this.waiting;
            _loc4_.label = _loc3_ == this.waiting ? "Press..." : GamePad.label(GamePad.bindOf(_loc3_));
            _loc3_++;
         }
         if(this.waiting < 0 && this.noteUntil == 0)
         {
            this.showStatus();
         }
      }

      private function buildChrome() : void
      {
         var cls:Class = null;
         try
         {
            cls = getDefinitionByName("LPFPanelBg") as Class;
         }
         catch(e:Error)
         {
            cls = null;
         }
         if(cls != null)
         {
            try
            {
               this.bg = new cls() as MovieClip;
            }
            catch(e2:Error)
            {
               bg = null;
            }
         }
         if(this.bg == null)
         {
            this.buildFallbackChrome();
            return;
         }
         this.win.addChildAt(this.bg,0);
         try
         {
            this.bg.frame.width = this.pw;
            this.bg.frame.height = this.ph;
            this.bg.bg.width = this.pw - 12;
            this.bg.bg.height = this.ph - 10;
            this.bg.btnClose.x = this.pw - 31;
         }
         catch(e3:Error)
         {
         }
         try
         {
            if("dragonLeft" in this.bg)
            {
               this.bg.dragonLeft.visible = false;
            }
         }
         catch(e4:Error)
         {
         }
         try
         {
            if("dragonRight" in this.bg)
            {
               this.bg.dragonRight.visible = false;
            }
         }
         catch(e5:Error)
         {
         }
         try
         {
            this.bg.tTitle.text = "Gamepad Controls";
            this.bg.tTitle.textColor = 16777215;
            this.bg.tTitle.x = int(this.pw / 2 - this.bg.tTitle.width / 2);
         }
         catch(e6:Error)
         {
         }
         try
         {
            this.bg.btnClose.addEventListener(MouseEvent.CLICK,this.onCloseClick,false,0,true);
            if(this.m)
            {
               TouchTargets.pad(this.bg.btnClose as InteractiveObject);
            }
         }
         catch(e7:Error)
         {
         }
      }

      private function buildFallbackChrome() : void
      {
         var _loc3_:Shape = new Shape();
         var _loc4_:Graphics = _loc3_.graphics;
         var _loc5_:Matrix = new Matrix();
         _loc5_.createGradientBox(this.pw,this.ph,Math.PI / 2,0,0);
         _loc4_.lineStyle(2,MailArt.TRIM,1,true);
         _loc4_.beginGradientFill(GradientType.LINEAR,[2236962,1315860],[1,1],[0,255],_loc5_);
         _loc4_.drawRoundRect(0,0,this.pw,this.ph,12,12);
         _loc4_.endFill();
         this.win.addChildAt(_loc3_,0);
         var _loc6_:TextField = MailArt.tf(14,16777215,true);
         _loc6_.filters = [textShadow()];
         _loc6_.text = "Gamepad Controls";
         _loc6_.x = int(this.pw / 2 - _loc6_.width / 2);
         _loc6_.y = 10;
         this.win.addChild(_loc6_);
      }

      private function place() : void
      {
         if(stage == null)
         {
            return;
         }
         var _loc3_:Number = stage.stageWidth;
         var _loc4_:Number = stage.stageHeight;
         this.backdrop.graphics.clear();
         this.backdrop.graphics.beginFill(0,0.4);
         this.backdrop.graphics.drawRect(0,0,_loc3_,_loc4_);
         this.backdrop.graphics.endFill();
         var _loc5_:int = Math.round((_loc3_ - this.pw) / 2);
         var _loc6_:int = Math.round((_loc4_ - this.ph) / 2);
         if(_loc6_ + this.ph > 500 && this.ph <= 500)
         {
            _loc6_ = 500 - this.ph;
         }
         this.win.x = -this.pw / 2;
         this.win.y = -this.ph / 2;
         this.pivot.x = _loc5_ + this.pw / 2;
         this.pivot.y = _loc6_ + this.ph / 2;
      }

      private function startAnim() : void
      {
         this.openAt = getTimer();
         alpha = 0;
         this.pivot.scaleX = this.pivot.scaleY = 0.96;
         addEventListener(Event.ENTER_FRAME,this.onAnim,false,0,true);
      }

      private function onAnim(param1:Event) : void
      {
         var _loc4_:Number = Math.min(1,(getTimer() - this.openAt) / OPEN_MS);
         var _loc5_:Number = 1 - (1 - _loc4_) * (1 - _loc4_);
         alpha = _loc5_;
         this.pivot.scaleX = this.pivot.scaleY = 0.96 + 0.04 * _loc5_;
         if(_loc4_ < 1)
         {
            return;
         }
         alpha = 1;
         this.pivot.scaleX = this.pivot.scaleY = 1;
         removeEventListener(Event.ENTER_FRAME,this.onAnim);
      }

      private function onCloseClick(param1:MouseEvent) : void
      {
         this.close();
      }
   }
}
