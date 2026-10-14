package liteAssets.mobile
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.TextField;
   import liteAssets.draw.*;

   public class QuestButton extends Sprite
   {

      private static const IDENT:ColorTransform = new ColorTransform();

      private static const DARK:ColorTransform = new ColorTransform(0.7,0.7,0.7);

      private static const LIT:ColorTransform = new ColorTransform(1,1,1,1,26,26,26);

      private var bw:int;

      private var bh:int;

      private var face:Shape;

      private var tf:TextField;

      private var _enabled:Boolean = true;

      private var hover:Boolean = false;

      private var down:Boolean = false;

      private var st:Stage;

      public function QuestButton(param1:String, param2:int, param3:int, param4:int)
      {
         super();
         this.bw = param2;
         this.bh = param3;
         buttonMode = true;
         useHandCursor = true;
         mouseChildren = false;
         this.face = new Shape();
         NativeArt.questFace(this.face.graphics,param2,param3);
         addChild(this.face);
         this.tf = MailArt.tf(param4,16777215,true);
         this.tf.text = param1;
         addChild(this.tf);
         addEventListener(MouseEvent.ROLL_OVER,this.onOver,false,0,true);
         addEventListener(MouseEvent.ROLL_OUT,this.onOut,false,0,true);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onDown,false,0,true);
         this.redraw();
      }

      public function get enabled() : Boolean
      {
         return this._enabled;
      }

      public function set enabled(param1:Boolean) : void
      {
         if(param1 == this._enabled)
         {
            return;
         }
         this._enabled = param1;
         mouseEnabled = param1;
         this.redraw();
      }

      public function destroy() : void
      {
         this.endPress();
         removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
         removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
         removeEventListener(MouseEvent.MOUSE_DOWN,this.onDown);
      }

      private function onOver(param1:MouseEvent) : void
      {
         if(this.hover)
         {
            return;
         }
         this.hover = true;
         this.redraw();
      }

      private function onOut(param1:MouseEvent) : void
      {
         if(!this.hover)
         {
            return;
         }
         this.hover = false;
         this.redraw();
      }

      private function onDown(param1:MouseEvent) : void
      {
         if(stage == null)
         {
            return;
         }
         this.endPress();
         this.down = true;
         this.st = stage;
         this.st.addEventListener(MouseEvent.MOUSE_UP,this.onUp,false,0,true);
         this.redraw();
      }

      private function onUp(param1:MouseEvent) : void
      {
         this.endPress();
         this.redraw();
      }

      private function endPress() : void
      {
         if(this.st != null)
         {
            this.st.removeEventListener(MouseEvent.MOUSE_UP,this.onUp);
            this.st = null;
         }
         this.down = false;
      }

      private function redraw() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Boolean = Boolean(this.down) && Boolean(this._enabled);
         _loc1_ = _loc2_ ? 1 : 0;
         this.face.transform.colorTransform = _loc2_ ? DARK : (Boolean(this.hover) && Boolean(this._enabled) && !Mobile.active ? LIT : IDENT);
         this.face.y = _loc1_;
         alpha = this._enabled ? 1 : 0.4;
         buttonMode = this._enabled;
         this.tf.x = Math.round((this.bw - this.tf.width) / 2);
         this.tf.y = Math.round((this.bh - this.tf.height) / 2) + _loc1_;
      }
   }
}
