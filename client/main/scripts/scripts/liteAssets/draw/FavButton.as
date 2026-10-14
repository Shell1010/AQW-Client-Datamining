package liteAssets.draw
{
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.*;

   public class FavButton extends Sprite
   {

      private var size:int;

      private var item:Object;

      private var rootClass:MovieClip;

      private var allowBank:Boolean = false;

      private var state:int = 0;

      private var hover:Boolean = false;

      public function FavButton(param1:int)
      {
         super();
         this.size = param1;
         visible = false;
         mouseEnabled = true;
         mouseChildren = false;
         buttonMode = true;
         addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
         addEventListener(MouseEvent.MOUSE_OVER,this.onOver,false,0,true);
         addEventListener(MouseEvent.MOUSE_OUT,this.onOut,false,0,true);
         FavStore.addListener(this.refresh);
      }

      public function bind(param1:Object, param2:MovieClip, param3:Boolean) : void
      {
         this.item = param1;
         this.rootClass = param2;
         this.allowBank = param3;
         this.refresh();
      }

      public function dispose() : void
      {
         FavStore.removeListener(this.refresh);
         removeEventListener(MouseEvent.CLICK,this.onClick);
         removeEventListener(MouseEvent.MOUSE_OVER,this.onOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.onOut);
         this.item = null;
         this.rootClass = null;
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }

      private function refresh() : void
      {
         if(this.item == null || this.rootClass == null)
         {
            visible = false;
            return;
         }
         var _loc1_:Boolean = Boolean(FavStore.has(this.item.ItemID));
         var _loc2_:Boolean = Boolean(FavStore.inInventory(this.item,this.rootClass));
         visible = _loc2_ || _loc1_ || Boolean(this.allowBank);
         this.state = _loc1_ ? 1 : (_loc2_ ? 0 : 2);
         buttonMode = this.state != 2;
         this.draw();
         if(this.hover)
         {
            this.showTip();
         }
      }

      private function plate(param1:Graphics, param2:Number, param3:uint) : void
      {
         var _loc1_:Number = this.size - param2 * 2;
         param1.beginFill(param3);
         param1.drawRoundRect(param2,param2,_loc1_,_loc1_,_loc1_ * 0.46,_loc1_ * 0.46);
         param1.endFill();
      }

      private function draw() : void
      {
         var _loc1_:Graphics = graphics;
         _loc1_.clear();
         this.plate(_loc1_,0,0);
         this.plate(_loc1_,this.size * 0.07,1908770);
         this.plate(_loc1_,this.size * 0.14,723981);
         this.plate(_loc1_,this.size * 0.21,1579547);
         var _loc2_:Number = this.size * 0.29;
         var _loc3_:Number = this.size / 2;
         var _loc4_:Number = this.size / 2 + _loc2_ * 0.1;
         if(this.state == 1)
         {
            _loc1_.lineStyle(1,FavStore.GOLD_DARK,1,true);
            _loc1_.beginFill(FavStore.GOLD);
         }
         else
         {
            _loc1_.lineStyle(1.6,Boolean(this.hover) && this.state != 2 ? 16777215 : 14540253,1,true);
         }
         FavStore.drawStar(_loc1_,_loc3_,_loc4_,_loc2_);
         if(this.state == 1)
         {
            _loc1_.endFill();
         }
         alpha = this.state == 2 ? 0.45 : 1;
      }

      private function showTip() : void
      {
         var _loc1_:String = null;
         if(this.rootClass == null || this.rootClass.ui == null)
         {
            return;
         }
         if(this.state == 1)
         {
            _loc1_ = "Unfavorite";
         }
         else if(this.state == 2)
         {
            _loc1_ = "Move this item to your inventory to favorite it.";
         }
         else
         {
            _loc1_ = "Favorite (protects from selling/discarding)";
         }
         this.rootClass.ui.ToolTip.openWith({"str":_loc1_});
      }

      private function onOver(param1:MouseEvent) : void
      {
         this.hover = true;
         this.draw();
         this.showTip();
      }

      private function onOut(param1:MouseEvent) : void
      {
         this.hover = false;
         this.draw();
         if(this.rootClass != null && this.rootClass.ui != null)
         {
            this.rootClass.ui.ToolTip.close();
         }
      }

      private function onClick(param1:MouseEvent) : void
      {
         if(this.item == null || this.rootClass == null)
         {
            return;
         }
         if(this.state == 2)
         {
            this.rootClass.MsgBox.notify("Move this item to your inventory to favorite it.");
            return;
         }
         this.rootClass.mixer.playSound("Click");
         FavStore.toggle(this.item,this.rootClass);
      }
   }
}
