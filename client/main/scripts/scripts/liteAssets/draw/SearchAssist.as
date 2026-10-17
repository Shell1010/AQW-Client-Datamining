package liteAssets.draw
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.ui.*;

   public class SearchAssist
   {

      private static var current:SearchAssist;

      private static const CLEAR_W:int = 22;

      private var game:MovieClip;

      private var box:Sprite;

      private var tf:TextField;

      private var clearBtn:Sprite;

      private var st:Stage;

      private var pendingChar:String;

      public function SearchAssist(param1:MovieClip, param2:Sprite, param3:TextField, param4:TextField, param5:Number, param6:Number, param7:uint)
      {
         super();
         this.game = param1;
         this.box = param2;
         this.tf = param3;
         if(param4 != null)
         {
            param4.mouseEnabled = false;
         }
         this.clearBtn = new Sprite();
         this.clearBtn.buttonMode = true;
         var _loc1_:Graphics = this.clearBtn.graphics;
         _loc1_.beginFill(param7);
         _loc1_.drawRect(0,0,CLEAR_W,param6 - 4);
         _loc1_.endFill();
         var _loc2_:Number = CLEAR_W / 2;
         var _loc3_:Number = (param6 - 4) / 2;
         _loc1_.lineStyle(2,10066329,1,true);
         _loc1_.moveTo(_loc2_ - 4,_loc3_ - 4);
         _loc1_.lineTo(_loc2_ + 4,_loc3_ + 4);
         _loc1_.moveTo(_loc2_ + 4,_loc3_ - 4);
         _loc1_.lineTo(_loc2_ - 4,_loc3_ + 4);
         this.clearBtn.x = param5 - CLEAR_W - 2;
         this.clearBtn.y = 2;
         this.clearBtn.visible = param3.length > 0;
         param2.addChild(this.clearBtn);
         param2.addEventListener(MouseEvent.MOUSE_DOWN,this.onBoxDown,false,0,false);
         this.clearBtn.addEventListener(MouseEvent.CLICK,this.onClear,false,0,false);
         param3.addEventListener(Event.CHANGE,this.onChange,false,0,false);
         param3.addEventListener(KeyboardEvent.KEY_DOWN,this.onKey,false,0,false);
         param3.addEventListener(TextEvent.TEXT_INPUT,this.onTextInput,false,100,false);
         param3.addEventListener(FocusEvent.FOCUS_IN,this.onFocusIn,false,0,false);
         param2.addEventListener(Event.ADDED_TO_STAGE,this.onAdded,false,0,false);
         param2.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved,false,0,false);
         if(current == null || !current.live())
         {
            current = this;
         }
         if(param2.stage != null)
         {
            this.onAdded(null);
         }
      }

      public static function attach(param1:MovieClip, param2:Sprite, param3:TextField, param4:TextField, param5:Number, param6:Number, param7:uint) : SearchAssist
      {
         return new SearchAssist(param1,param2,param3,param4,param5,param6,param7);
      }

      private function live() : Boolean
      {
         if(this.box.stage == null)
         {
            return false;
         }
         var _loc1_:DisplayObject = this.box;
         while(_loc1_ != null)
         {
            if(!_loc1_.visible)
            {
               return false;
            }
            _loc1_ = _loc1_.parent;
         }
         return true;
      }

      private function onAdded(param1:Event) : void
      {
         if(this.st != null)
         {
            return;
         }
         this.st = this.box.stage;
         this.st.addEventListener(MouseEvent.MOUSE_DOWN,this.onStageDown,true,0,false);
         this.st.addEventListener(MouseEvent.MOUSE_DOWN,this.onStageDown,false,0,false);
         this.st.addEventListener(KeyboardEvent.KEY_DOWN,this.onStageKey,true,50,false);
         this.st.addEventListener(KeyboardEvent.KEY_DOWN,this.onStageKey,false,50,false);
      }

      private function onRemoved(param1:Event) : void
      {
         if(this.st != null)
         {
            this.st.removeEventListener(MouseEvent.MOUSE_DOWN,this.onStageDown,true);
            this.st.removeEventListener(MouseEvent.MOUSE_DOWN,this.onStageDown,false);
            this.st.removeEventListener(KeyboardEvent.KEY_DOWN,this.onStageKey,true);
            this.st.removeEventListener(KeyboardEvent.KEY_DOWN,this.onStageKey,false);
            if(this.st.focus == this.tf)
            {
               this.st.focus = null;
            }
         }
         this.st = null;
         if(current == this)
         {
            current = null;
         }
      }

      private function onFocusIn(param1:FocusEvent) : void
      {
         current = this;
      }

      private function onBoxDown(param1:MouseEvent) : void
      {
         if(this.st == null || param1.target == this.tf)
         {
            return;
         }
         var _loc1_:DisplayObject = param1.target as DisplayObject;
         if(_loc1_ != null && (_loc1_ == this.clearBtn || Boolean(this.clearBtn.contains(_loc1_))))
         {
            return;
         }
         this.st.focus = this.tf;
         this.tf.setSelection(this.tf.length,this.tf.length);
      }

      private function onChange(param1:Event) : void
      {
         this.clearBtn.visible = this.tf.length > 0;
      }

      private function clearText() : void
      {
         this.tf.text = "";
         this.tf.dispatchEvent(new Event(Event.CHANGE));
      }

      private function onClear(param1:MouseEvent) : void
      {
         this.clearText();
         if(this.st != null)
         {
            this.st.focus = this.tf;
         }
      }

      private function onKey(param1:KeyboardEvent) : void
      {
         if(this.st == null)
         {
            return;
         }
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.st.focus = null;
         }
         else if(param1.keyCode == Keyboard.ESCAPE)
         {
            if(this.tf.length > 0)
            {
               this.clearText();
            }
            else
            {
               this.st.focus = null;
            }
         }
      }

      private function onStageDown(param1:MouseEvent) : void
      {
         if(this.st == null || this.st.focus != this.tf)
         {
            return;
         }
         var _loc1_:DisplayObject = param1.target as DisplayObject;
         if(_loc1_ != null && (Boolean(this.box.contains(_loc1_)) || this.game != null && !this.game.contains(_loc1_)))
         {
            return;
         }
         this.st.focus = null;
      }

      private function onTextInput(param1:TextEvent) : void
      {
         if(this.pendingChar == null)
         {
            return;
         }
         if(param1.text == this.pendingChar)
         {
            param1.preventDefault();
         }
         this.pendingChar = null;
      }

      private function isBoundKey(param1:uint) : Boolean
      {
         var _loc1_:* = undefined;
         var _loc2_:Object = this.game != null && this.game.litePreference != null ? this.game.litePreference.data.keys : null;
         if(_loc2_ == null)
         {
            return false;
         }
         for each(_loc1_ in _loc2_)
         {
            if(_loc1_ != null && uint(_loc1_) == param1)
            {
               return true;
            }
         }
         return false;
      }

      private function onStageKey(param1:KeyboardEvent) : void
      {
         if(current != null && current != this && Boolean(current.live()) || this.st == null || this.st.focus is TextField)
         {
            return;
         }
         if(param1.ctrlKey || param1.altKey)
         {
            return;
         }
         var _loc1_:uint = param1.charCode;
         if(!(_loc1_ >= 48 && _loc1_ <= 57 || _loc1_ >= 65 && _loc1_ <= 90 || _loc1_ >= 97 && _loc1_ <= 122))
         {
            return;
         }
         if(!this.live() || Boolean(this.isBoundKey(param1.keyCode)))
         {
            return;
         }
         param1.stopImmediatePropagation();
         current = this;
         this.st.focus = this.tf;
         if(this.tf.maxChars > 0 && this.tf.length >= this.tf.maxChars)
         {
            return;
         }
         this.pendingChar = String.fromCharCode(_loc1_);
         this.tf.replaceText(this.tf.length,this.tf.length,this.pendingChar);
         this.tf.setSelection(this.tf.length,this.tf.length);
         this.tf.dispatchEvent(new Event(Event.CHANGE));
         this.box.addEventListener(Event.ENTER_FRAME,this.onPendingDone,false,0,false);
      }

      private function onPendingDone(param1:Event) : void
      {
         this.box.removeEventListener(Event.ENTER_FRAME,this.onPendingDone);
         this.pendingChar = null;
      }
   }
}
