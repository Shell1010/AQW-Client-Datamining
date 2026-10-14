package liteAssets.mobile
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import liteAssets.draw.*;
   import liteAssets.listOptionsItem.*;

   public class KeybindsPanel extends Sprite
   {

      private static var current:KeybindsPanel;

      private static var keyNames:Object;

      private static const SECTIONS:Array = [["Combat",["Auto Attack","Skill 1","Skill 2","Skill 3","Skill 4","Skill 5","Target Random Monster","Cancel Target","Rest","Dash","Jump"]],["Movement",["Move Up","Move Left","Move Down","Move Right"]],["Interface",["Inventory","Bank","Quest Log","Character Panel","Outfits","Friends List","Friendships UI","Area List","Options","Stats Overview","Player HP Bar","Hide UI","Battle Analyzer","Battle Analyzer Toggle"]],["Drops",["Custom Drops UI","Decline All Drops"]],["World & Camera",["Camera Tool","World Camera","World Camera\'s Hide","Travel Menu\'s Travel","Hide Monsters","Hide Players"]],["Developer",["@ Debugger - Cell Menu","@ Debugger - Packet Logger"]]];

      private static const DESC:Object = {
         "Camera Tool":"Launches Camera Tool",
         "World Camera":"Launches World Camera",
         "Target Random Monster":"Targets a random monster in your room if available",
         "Inventory":"Opens your inventory",
         "Bank":"Opens the bank if you have a bank pet or bank cape in your inventory",
         "Quest Log":"Opens your quest log where you can turn in your completed quests",
         "Friends List":"Opens your friends list",
         "Character Panel":"Opens the character panel",
         "Player HP Bar":"Toggles the appearance of an HP bar above all player heads",
         "Options":"Opens the options",
         "Area List":"Opens up the /who list that shows who\'s in the map",
         "Jump":"Makes your player do the jump animation",
         "Auto Attack":"Activates the attack that every class knows",
         "Skill 1":"Activates the first skill of your class if available",
         "Skill 2":"Activates the second skill of your class if available",
         "Skill 3":"Activates the third skill of your class if available",
         "Skill 4":"Activates the fourth skill of your class if available",
         "Skill 5":"Activates the potion slot if available",
         "Travel Menu\'s Travel":"The keybind used to travel to the next map in the list for the Travel Menu",
         "World Camera\'s Hide":"The keybind used to hide the World Camera\'s ui",
         "Rest":"Your character will start resting to restore HP / MP",
         "Hide Monsters":"Toggles the hide monsters function located on your player portrait",
         "Hide Players":"Toggles the hide players feature",
         "Cancel Target":"Cancels your target if available. Cooldown is your auto attack speed. (Has a minimum cooldown of 2 seconds)",
         "Hide UI":"Hides portraits and map information located on the bottom right",
         "Battle Analyzer":"Launches Battle Analyzer",
         "Decline All Drops":"Declines all the drops on your screen. Be very cautious when binding this to a key",
         "Stats Overview":"Toggle the Stats Panel/Overview!",
         "Battle Analyzer Toggle":"Toggles the Start/Stop of Battle Analyzer",
         "Custom Drops UI":"Toggles the visibility of Custom Drops UI",
         "@ Debugger - Cell Menu":"Toggles the visibility of the Cell Menu",
         "@ Debugger - Packet Logger":"Toggles the visibility of the Packet Logger",
         "Dash":"After activating this keybind, your next movement click will be a dash.",
         "Move Up":"Walks your player up",
         "Move Left":"Walks your player left",
         "Move Down":"Walks your player down",
         "Move Right":"Walks your player right",
         "Outfits":"Opens the Outfits interface",
         "Friendships UI":"Opens the Friendships UI interface"
      };

      private static const NAMES:Object = {
         "BACKQUOTE":"`",
         "MINUS":"-",
         "EQUAL":"=",
         "LEFTBRACKET":"[",
         "RIGHTBRACKET":"]",
         "BACKSLASH":"\\",
         "SEMICOLON":";",
         "QUOTE":"\'",
         "COMMA":",",
         "PERIOD":".",
         "SLASH":"/",
         "SPACE":"Space",
         "TAB":"Tab",
         "ESCAPE":"Esc",
         "SHIFT":"Shift",
         "CONTROL":"Ctrl",
         "ALTERNATE":"Alt",
         "CAPS_LOCK":"Caps Lock",
         "BACKSPACE":"Backspace",
         "DELETE":"Delete",
         "INSERT":"Insert",
         "HOME":"Home",
         "END":"End",
         "PAGE_UP":"Page Up",
         "PAGE_DOWN":"Page Down",
         "UP":"Up",
         "DOWN":"Down",
         "LEFT":"Left",
         "RIGHT":"Right",
         "ENTER":"Enter",
         "NUMPAD_ENTER":"Enter",
         "NUMPAD_ADD":"Num +",
         "NUMPAD_SUBTRACT":"Num -",
         "NUMPAD_MULTIPLY":"Num *",
         "NUMPAD_DIVIDE":"Num /",
         "NUMPAD_DECIMAL":"Num .",
         "COMMAND":"Cmd"
      };

      private static const W:int = 640;

      private static const H:int = 440;

      private static const OUT:int = 16;

      private static const SEARCH_Y:int = 42;

      private static const SEARCH_H:int = 26;

      private static const WELL_Y:int = 76;

      private static const PAD:int = 10;

      private static const COL_GAP:int = 22;

      private static const ROW_H:int = 34;

      private static const PILL_W:int = 104;

      private static const PILL_H:int = 24;

      private static const BAR_W:int = 8;

      private static const BTN_W:int = 112;

      private static const BTN_H:int = 32;

      private static const OPEN_MS:int = 120;

      private static const WHEEL_ROW:Number = 34;

      private static const IDLE_NOTE:String = "Click a key to change it. Backspace clears it.";

      private var game:MovieClip;

      private var bg:MovieClip;

      private var backdrop:Sprite = new Sprite();

      private var pivot:Sprite = new Sprite();

      private var win:Sprite = new Sprite();

      private var content:Sprite = new Sprite();

      private var viewMask:Shape = new Shape();

      private var track:Sprite = new Sprite();

      private var thumb:Sprite = new Sprite();

      private var search:TextField;

      private var placeholder:TextField;

      private var note:TextField;

      private var resetBtn:VolumeButton;

      private var doneBtn:VolumeButton;

      private var scroller:TouchScroll;

      private var pills:Object = {};

      private var m:Boolean = Mobile.active;

      private var rowH:int = 34;

      private var pillH:int = 24;

      private var btnH:int = 32;

      private var wellH:int;

      private var viewH:int;

      private var pos:Number = 0;

      private var contentH:Number = 0;

      private var waiting:String = null;

      private var swallowUp:int = -1;

      private var dragOff:Number = -1;

      private var openAt:int = 0;

      private var cancelledByDown:Boolean = false;

      public function KeybindsPanel(param1:MovieClip)
      {
         super();
         this.game = param1;
         if(this.m)
         {
            this.pillH = Math.max(PILL_H,Mobile.touchPx(7));
            this.rowH = Math.max(ROW_H,this.pillH + 10);
            this.btnH = Math.max(BTN_H,Mobile.touchPx(8));
         }
         this.wellH = H - WELL_Y - this.btnH - 30;
         this.viewH = this.wellH - 2;
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
         current = new KeybindsPanel(param1);
         param1.stage.addChild(current);
         current.layout();
      }

      public static function keyLabel(param1:uint) : String
      {
         var _loc1_:String = null;
         if(param1 >= 48 && param1 <= 57)
         {
            return String(param1 - 48);
         }
         if(param1 >= 65 && param1 <= 90)
         {
            return String.fromCharCode(param1);
         }
         if(param1 >= 96 && param1 <= 105)
         {
            return "Num " + (param1 - 96);
         }
         if(param1 >= 112 && param1 <= 126)
         {
            return "F" + (param1 - 111);
         }
         if(keyNames == null)
         {
            keyNames = {};
            for each(_loc1_ in describeType(Keyboard).constant.@name)
            {
               keyNames[Keyboard[_loc1_]] = _loc1_;
            }
         }
         var _loc2_:String = keyNames[param1];
         if(_loc2_ == null)
         {
            return "Key " + param1;
         }
         if(NAMES[_loc2_] != null)
         {
            return NAMES[_loc2_];
         }
         var _loc3_:Array = _loc2_.toLowerCase().split("_");
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc3_[_loc4_] = String(_loc3_[_loc4_]).charAt(0).toUpperCase() + String(_loc3_[_loc4_]).substr(1);
            _loc4_++;
         }
         return _loc3_.join(" ");
      }

      private static function textShadow() : DropShadowFilter
      {
         return new DropShadowFilter(1,45,0,0.6,2,2,1,1);
      }

      private function onAdded(param1:Event) : void
      {
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown,true,200,true);
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown,false,200,true);
         stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp,true,200,true);
         stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp,false,200,true);
         stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onStageDown,true,0,true);
         stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.onWheel,true,0,true);
         GamePad.suspended = true;
         stage.addEventListener(Event.RESIZE,this.onResize,false,0,true);
      }

      private function onRemoved(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onAnim);
         if(stage != null)
         {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown,true);
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown,false);
            stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp,true);
            stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp,false);
            stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.onStageDown,true);
            stage.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onWheel,true);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onThumbMove);
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.onThumbUp);
            stage.removeEventListener(Event.RESIZE,this.onResize);
            if(stage.focus == this.search)
            {
               stage.focus = null;
            }
         }
         if(this.scroller != null)
         {
            this.scroller.detach();
            this.scroller = null;
         }
         this.closeTip();
         if(current == this)
         {
            current = null;
         }
         GamePad.suspended = GamepadPanel.isOpen;
      }

      private function onResize(param1:Event) : void
      {
         this.place();
      }

      private function onBackdrop(param1:MouseEvent) : void
      {
         if(this.cancelledByDown)
         {
            this.cancelledByDown = false;
            return;
         }
         if(this.waiting == null)
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

      private function keys() : Object
      {
         try
         {
            return this.game.litePreference.data.keys;
         }
         catch(e:Error)
         {
         }
         return {};
      }

      private function isStaff() : Boolean
      {
         var _loc1_:Object = null;
         try
         {
            _loc1_ = getDefinitionByName("Game");
            return int(_loc1_.objLogin.iAccess) >= 30;
         }
         catch(e:Error)
         {
         }
         return false;
      }

      private function layout() : void
      {
         this.buildChrome();
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.lineStyle(1,3815994,1,true);
         _loc1_.graphics.beginFill(657930);
         _loc1_.graphics.drawRoundRect(0,0,W - OUT * 2,SEARCH_H,SEARCH_H,SEARCH_H);
         _loc1_.graphics.endFill();
         _loc1_.x = OUT;
         _loc1_.y = SEARCH_Y;
         this.win.addChild(_loc1_);
         var _loc2_:Shape = new Shape();
         _loc2_.graphics.lineStyle(2,9079434,1,true);
         _loc2_.graphics.drawCircle(15,12,5);
         _loc2_.graphics.moveTo(19,16);
         _loc2_.graphics.lineTo(23,20);
         _loc1_.addChild(_loc2_);
         this.placeholder = MailArt.tf(13,7829367);
         this.placeholder.text = "Search keybinds";
         this.placeholder.x = 30;
         this.placeholder.y = Math.round((SEARCH_H - this.placeholder.height) / 2);
         _loc1_.addChild(this.placeholder);
         this.search = new TextField();
         this.search.type = TextFieldType.INPUT;
         this.search.defaultTextFormat = new TextFormat("Arial",13,16777215);
         this.search.x = 30;
         this.search.width = W - OUT * 2 - 40;
         this.search.height = 20;
         this.search.y = Math.round((SEARCH_H - 20) / 2);
         this.search.addEventListener(Event.CHANGE,this.onSearch,false,0,true);
         _loc1_.addChild(this.search);
         var _loc3_:Shape = new Shape();
         _loc3_.graphics.beginFill(657930);
         _loc3_.graphics.lineStyle(1,2763306,1,true);
         _loc3_.graphics.drawRoundRect(OUT,WELL_Y,W - OUT * 2,this.wellH,12,12);
         _loc3_.graphics.endFill();
         _loc3_.filters = [new DropShadowFilter(2,90,0,0.5,4,4,1,1,true)];
         this.win.addChild(_loc3_);
         this.viewMask.graphics.beginFill(0);
         this.viewMask.graphics.drawRect(OUT + 1,WELL_Y + 1,W - OUT * 2 - 2,this.viewH);
         this.viewMask.graphics.endFill();
         this.win.addChild(this.viewMask);
         this.content.mask = this.viewMask;
         this.win.addChild(this.content);
         _loc3_.visible = true;
         this.track.x = W - OUT - PAD / 2 - BAR_W;
         this.track.y = WELL_Y + 6;
         this.track.addEventListener(MouseEvent.MOUSE_DOWN,this.onTrackDown,false,0,true);
         this.thumb.buttonMode = true;
         this.thumb.addEventListener(MouseEvent.MOUSE_DOWN,this.onThumbDown,false,0,true);
         this.win.addChild(this.track);
         this.track.addChild(this.thumb);
         this.note = MailArt.tf(11,9079434);
         this.note.filters = [textShadow()];
         this.win.addChild(this.note);
         var _loc4_:int = WELL_Y + this.wellH + 10;
         this.resetBtn = new VolumeButton(BTN_W,this.btnH,"Reset All");
         this.resetBtn.x = W - OUT - BTN_W * 2 - 12;
         this.resetBtn.y = _loc4_;
         this.resetBtn.addEventListener(MouseEvent.CLICK,this.onReset,false,0,true);
         this.win.addChild(this.resetBtn);
         this.doneBtn = new VolumeButton(BTN_W,this.btnH,"Done");
         this.doneBtn.x = W - OUT - BTN_W;
         this.doneBtn.y = _loc4_;
         this.doneBtn.addEventListener(MouseEvent.CLICK,this.onCloseClick,false,0,true);
         this.win.addChild(this.doneBtn);
         if(this.m)
         {
            TouchTargets.pad(this.resetBtn);
            TouchTargets.pad(this.doneBtn);
         }
         this.setNote(IDLE_NOTE,9079434);
         this.scroller = TouchScroll.attach(this.content,this.getPos,this.setPos,this.getMax);
         this.build();
         this.place();
         this.startAnim();
      }

      private function setNote(param1:String, param2:uint) : void
      {
         this.note.textColor = param2;
         this.note.text = param1;
         MailArt.fit(this.note,W - OUT * 2 - BTN_W * 2 - 30);
         this.note.x = OUT + 4;
         this.note.y = WELL_Y + this.wellH + 10 + Math.round((this.btnH - this.note.height) / 2);
      }

      private function build() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:RowHeader = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:TextField = null;
         this.closeTip();
         this.stopWaiting(false);
         while(this.content.numChildren > 0)
         {
            this.content.removeChildAt(0);
         }
         this.pills = {};
         var _loc9_:String = this.search != null ? this.search.text.toLowerCase() : "";
         this.placeholder.visible = _loc9_.length == 0;
         var _loc10_:Boolean = Boolean(this.isStaff());
         var _loc11_:int = W - OUT * 2 - PAD * 2 - BAR_W - 6;
         var _loc12_:int = int((_loc11_ - COL_GAP) / 2);
         var _loc13_:int = OUT + PAD;
         var _loc14_:int = WELL_Y + 6;
         var _loc15_:Object = {};
         for each(_loc1_ in SECTIONS)
         {
            _loc2_ = [];
            for each(_loc3_ in _loc1_[1])
            {
               if(_loc15_[_loc3_] != true)
               {
                  if(!(_loc3_.indexOf("@ Debugger") == 0 && !_loc10_))
                  {
                     if(!(_loc9_.length > 0 && _loc3_.toLowerCase().indexOf(_loc9_) < 0))
                     {
                        _loc2_.push(_loc3_);
                        _loc15_[_loc3_] = true;
                     }
                  }
               }
            }
            if(_loc2_.length != 0)
            {
               _loc4_ = new RowHeader(_loc1_[0],_loc11_);
               _loc4_.x = _loc13_;
               _loc4_.y = _loc14_;
               this.content.addChild(_loc4_);
               _loc14_ += RowHeader.H + 2;
               _loc5_ = 0;
               while(_loc5_ < _loc2_.length)
               {
                  _loc6_ = _loc5_ % 2;
                  _loc7_ = _loc14_ + int(_loc5_ / 2) * this.rowH;
                  this.buildRow(_loc2_[_loc5_],_loc13_ + _loc6_ * (_loc12_ + COL_GAP),_loc7_,_loc12_);
                  _loc5_++;
               }
               _loc14_ += int((_loc2_.length + 1) / 2) * this.rowH + 6;
            }
         }
         if(_loc14_ == WELL_Y + 6)
         {
            _loc8_ = MailArt.tf(13,9079434);
            _loc8_.text = "No keybinds match \"" + this.search.text + "\".";
            _loc8_.x = Math.round(W / 2 - _loc8_.width / 2);
            _loc8_.y = WELL_Y + 30;
            this.content.addChild(_loc8_);
            _loc14_ += 60;
         }
         this.contentH = _loc14_ - WELL_Y;
         this.setPos(Math.min(this.pos,this.getMax()));
         this.drawBar();
      }

      private function buildRow(param1:String, param2:int, param3:int, param4:int) : void
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.name = param1;
         _loc1_.x = param2;
         _loc1_.y = param3;
         _loc1_.graphics.beginFill(0,0);
         _loc1_.graphics.drawRect(0,0,param4,this.rowH);
         _loc1_.graphics.endFill();
         _loc1_.addEventListener(MouseEvent.ROLL_OVER,this.onRowOver,false,0,true);
         _loc1_.addEventListener(MouseEvent.ROLL_OUT,this.onRowOut,false,0,true);
         this.content.addChild(_loc1_);
         var _loc2_:TextField = MailArt.tf(13,15919317,true);
         _loc2_.filters = [textShadow()];
         _loc2_.text = param1;
         MailArt.fit(_loc2_,param4 - PILL_W - 12);
         _loc2_.x = 4;
         _loc2_.y = Math.round((this.rowH - _loc2_.height) / 2);
         _loc1_.addChild(_loc2_);
         var _loc3_:VolumeButton = new VolumeButton(PILL_W,this.pillH,"",12);
         _loc3_.name = param1;
         _loc3_.x = param4 - PILL_W;
         _loc3_.y = Math.round((this.rowH - this.pillH) / 2);
         _loc3_.addEventListener(MouseEvent.CLICK,this.onPill,false,0,true);
         if(this.m)
         {
            TouchTargets.pad(_loc3_);
         }
         _loc1_.addChild(_loc3_);
         this.pills[param1] = _loc3_;
         this.showKey(param1);
      }

      private function showKey(param1:String) : void
      {
         var _loc1_:VolumeButton = this.pills[param1];
         if(_loc1_ == null)
         {
            return;
         }
         var _loc2_:* = this.keys()[param1];
         _loc1_.selected = param1 == this.waiting;
         if(param1 == this.waiting)
         {
            _loc1_.label = "Press a key...";
         }
         else
         {
            _loc1_.label = _loc2_ == null || int(_loc2_) == 0 ? "Not set" : keyLabel(uint(_loc2_));
         }
         _loc1_.dim = param1 != this.waiting && (_loc2_ == null || int(_loc2_) == 0);
      }

      private function onRowOver(param1:MouseEvent) : void
      {
         if(this.waiting != null)
         {
            return;
         }
         var _loc1_:String = DESC[DisplayObject(param1.currentTarget).name];
         if(_loc1_ != null)
         {
            this.setNote(_loc1_,13221806);
         }
      }

      private function onRowOut(param1:MouseEvent) : void
      {
         if(this.waiting == null)
         {
            this.setNote(IDLE_NOTE,9079434);
         }
      }

      private function closeTip() : void
      {
         try
         {
            this.game.ui.ToolTip.close();
         }
         catch(err:Error)
         {
         }
      }

      private function onPill(param1:MouseEvent) : void
      {
         var _loc1_:String = DisplayObject(param1.currentTarget).name;
         if(this.waiting == _loc1_)
         {
            this.stopWaiting(true);
            return;
         }
         this.stopWaiting(false);
         this.swallowUp = -1;
         this.waiting = _loc1_;
         this.showKey(_loc1_);
         this.setNote("Press a key for " + _loc1_ + ". Enter cancels; Backspace clears it.",MailArt.GOLD);
         if(stage != null && stage.focus == this.search)
         {
            stage.focus = null;
         }
      }

      private function stopWaiting(param1:Boolean) : void
      {
         if(this.waiting == null)
         {
            return;
         }
         var _loc1_:String = this.waiting;
         this.waiting = null;
         this.showKey(_loc1_);
         if(param1)
         {
            this.setNote(IDLE_NOTE,9079434);
         }
      }

      private function onStageDown(param1:MouseEvent) : void
      {
         if(this.waiting == null)
         {
            return;
         }
         var _loc1_:DisplayObject = param1.target as DisplayObject;
         var _loc2_:VolumeButton = this.pills[this.waiting];
         if(_loc2_ != null && _loc1_ != null && (_loc1_ == _loc2_ || _loc2_.contains(_loc1_)))
         {
            return;
         }
         this.stopWaiting(true);
         this.cancelledByDown = true;
      }

      private function onKeyDown(param1:KeyboardEvent) : void
      {
         var _loc1_:uint = 0;
         var _loc2_:String = null;
         var _loc3_:Object = null;
         var _loc4_:String = null;
         if(this.waiting == null)
         {
            if(this.swallowUp >= 0 && param1.keyCode == this.swallowUp)
            {
               param1.stopImmediatePropagation();
               return;
            }
            if(param1.keyCode == Keyboard.ESCAPE && (stage == null || stage.focus != this.search))
            {
               param1.stopImmediatePropagation();
               this.close();
            }
            return;
         }
         param1.preventDefault();
         param1.stopImmediatePropagation();
         this.swallowUp = param1.keyCode;
         var _loc5_:String = this.waiting;
         if(param1.keyCode == Keyboard.ENTER || param1.keyCode == 191)
         {
            this.stopWaiting(true);
            return;
         }
         this.waiting = null;
         if(param1.keyCode == Keyboard.BACKSPACE || param1.keyCode == Keyboard.DELETE)
         {
            this.saveKey(_loc5_,0);
            this.keys()[_loc5_] = null;
            this.setNote(_loc5_ + " is no longer bound.",9079434);
         }
         else
         {
            _loc1_ = param1.keyCode;
            if(_loc1_ >= 96 && _loc1_ <= 105)
            {
               _loc1_ -= 48;
            }
            this.saveKey(_loc5_,_loc1_);
            _loc2_ = null;
            _loc3_ = this.keys();
            for(_loc4_ in _loc3_)
            {
               if(_loc4_ != _loc5_ && _loc3_[_loc4_] != null && int(_loc3_[_loc4_]) == int(_loc1_))
               {
                  _loc2_ = _loc4_;
                  break;
               }
            }
            if(_loc2_ != null)
            {
               this.setNote(keyLabel(_loc1_) + " is also used by " + _loc2_ + ".",16751226);
            }
            else
            {
               this.setNote(_loc5_ + " set to " + keyLabel(_loc1_) + ".",10477690);
            }
         }
         try
         {
            this.game.litePreference.flush();
         }
         catch(err:Error)
         {
         }
         this.showKey(_loc5_);
      }

      private function saveKey(param1:String, param2:uint) : void
      {
         var oh:Object = null;
         var name:String = param1;
         var code:uint = param2;
         try
         {
            oh = getDefinitionByName("liteAssets.handlers.optionHandler");
            oh.key(this.game,name,code);
         }
         catch(err:Error)
         {
            keys()[name] = code;
         }
      }

      private function onKeyUp(param1:KeyboardEvent) : void
      {
         if(this.swallowUp < 0 || param1.keyCode != this.swallowUp)
         {
            return;
         }
         this.swallowUp = -1;
         param1.stopImmediatePropagation();
      }

      private function onSearch(param1:Event) : void
      {
         this.pos = 0;
         this.build();
      }

      private function onReset(param1:MouseEvent) : void
      {
         var cls:Class;
         var modal:*;
         var e:MouseEvent = param1;
         this.stopWaiting(true);
         cls = null;
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
            this.doReset({"accept":true});
            return;
         }
         modal = new cls();
         this.game.stage.addChild(modal);
         modal.init({
            "strBody":"Reset every keybind to its default?",
            "params":{},
            "callback":this.doReset,
            "glow":"red,medium",
            "greedy":true
         });
      }

      private function doReset(param1:Object) : void
      {
         var _loc1_:int = 0;
         var _loc2_:TextField = null;
         if(param1 == null || !param1.accept)
         {
            return;
         }
         try
         {
            this.game.initKeybindPref(true);
            _loc1_ = 0;
            while(_loc1_ < 6)
            {
               _loc2_ = this.game.ui.mcInterface.getChildByName("keyA" + _loc1_) as TextField;
               if(_loc2_ != null)
               {
                  _loc2_.text = String(_loc1_ + 1);
                  _loc2_.mouseEnabled = false;
               }
               _loc1_++;
            }
            this.game.litePreference.flush();
         }
         catch(err:Error)
         {
         }
         this.setNote("All keybinds reset to default.",10477690);
         this.build();
      }

      private function getMax() : Number
      {
         return Math.max(0,this.contentH - this.viewH);
      }

      private function getPos() : Number
      {
         return this.pos;
      }

      private function setPos(param1:Number) : void
      {
         this.pos = Math.max(0,Math.min(this.getMax(),param1));
         this.content.y = -Math.round(this.pos);
         this.placeThumb();
      }

      private function onWheel(param1:MouseEvent) : void
      {
         if(stage == null || !this.viewMask.getBounds(stage).contains(param1.stageX,param1.stageY))
         {
            return;
         }
         this.setPos(this.pos - param1.delta * WHEEL_ROW / 3);
      }

      private function drawBar() : void
      {
         var _loc1_:int = this.viewH - 12;
         this.track.graphics.clear();
         this.thumb.graphics.clear();
         this.track.visible = this.getMax() > 0;
         if(!this.track.visible)
         {
            return;
         }
         this.track.graphics.beginFill(1710618);
         this.track.graphics.drawRoundRect(0,0,BAR_W,_loc1_,BAR_W,BAR_W);
         this.track.graphics.endFill();
         var _loc2_:int = Math.max(28,int(_loc1_ * this.viewH / this.contentH));
         var _loc3_:Matrix = new Matrix();
         _loc3_.createGradientBox(BAR_W,_loc2_,0,0,0);
         this.thumb.graphics.lineStyle(1,13145646,1,true);
         this.thumb.graphics.beginGradientFill(GradientType.LINEAR,[14827823,9312786],[1,1],[0,255],_loc3_);
         this.thumb.graphics.drawRoundRect(0,0,BAR_W,_loc2_,BAR_W,BAR_W);
         this.thumb.graphics.endFill();
         this.placeThumb();
      }

      private function placeThumb() : void
      {
         if(!this.track.visible || this.getMax() <= 0)
         {
            return;
         }
         var _loc1_:Number = this.viewH - 12 - this.thumb.height;
         this.thumb.y = Math.round(_loc1_ * this.pos / this.getMax());
      }

      private function onThumbDown(param1:MouseEvent) : void
      {
         param1.stopPropagation();
         this.dragOff = this.track.mouseY - this.thumb.y;
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onThumbMove,false,0,true);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onThumbUp,false,0,true);
      }

      private function onThumbMove(param1:MouseEvent) : void
      {
         var _loc1_:Number = this.viewH - 12 - this.thumb.height;
         if(_loc1_ <= 0)
         {
            return;
         }
         this.setPos((this.track.mouseY - this.dragOff) / _loc1_ * this.getMax());
         param1.updateAfterEvent();
      }

      private function onThumbUp(param1:MouseEvent) : void
      {
         this.dragOff = -1;
         if(stage == null)
         {
            return;
         }
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onThumbMove);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onThumbUp);
      }

      private function onTrackDown(param1:MouseEvent) : void
      {
         if(param1.target == this.thumb)
         {
            return;
         }
         this.setPos(this.pos + (this.track.mouseY < this.thumb.y ? -this.viewH : this.viewH) * 0.9);
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
            this.bg.frame.width = W;
            this.bg.frame.height = H;
            this.bg.bg.width = W - 12;
            this.bg.bg.height = H - 10;
            this.bg.btnClose.x = W - 31;
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
            this.bg.tTitle.text = "Keybinds";
            this.bg.tTitle.textColor = 16777215;
            this.bg.tTitle.x = int(W / 2 - this.bg.tTitle.width / 2);
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
         var _loc1_:Shape = new Shape();
         var _loc2_:Graphics = _loc1_.graphics;
         var _loc3_:Matrix = new Matrix();
         _loc3_.createGradientBox(W,H,Math.PI / 2,0,0);
         _loc2_.lineStyle(2,MailArt.TRIM,1,true);
         _loc2_.beginGradientFill(GradientType.LINEAR,[2236962,1315860],[1,1],[0,255],_loc3_);
         _loc2_.drawRoundRect(0,0,W,H,12,12);
         _loc2_.endFill();
         this.win.addChildAt(_loc1_,0);
         var _loc4_:TextField = MailArt.tf(14,16777215,true);
         _loc4_.filters = [textShadow()];
         _loc4_.text = "Keybinds";
         _loc4_.x = int(W / 2 - _loc4_.width / 2);
         _loc4_.y = 10;
         this.win.addChild(_loc4_);
      }

      private function place() : void
      {
         if(stage == null)
         {
            return;
         }
         var _loc1_:Number = stage.stageWidth;
         var _loc2_:Number = stage.stageHeight;
         this.backdrop.graphics.clear();
         this.backdrop.graphics.beginFill(0,0.4);
         this.backdrop.graphics.drawRect(0,0,_loc1_,_loc2_);
         this.backdrop.graphics.endFill();
         var _loc3_:int = Math.round((_loc1_ - W) / 2);
         var _loc4_:int = Math.round((_loc2_ - H) / 2);
         if(_loc4_ + H > 500 && H <= 500)
         {
            _loc4_ = 500 - H;
         }
         this.win.x = -W / 2;
         this.win.y = -H / 2;
         this.pivot.x = _loc3_ + W / 2;
         this.pivot.y = _loc4_ + H / 2;
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
         var _loc1_:Number = Math.min(1,(getTimer() - this.openAt) / OPEN_MS);
         var _loc2_:Number = 1 - (1 - _loc1_) * (1 - _loc1_);
         alpha = _loc2_;
         this.pivot.scaleX = this.pivot.scaleY = 0.96 + 0.04 * _loc2_;
         if(_loc1_ < 1)
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
