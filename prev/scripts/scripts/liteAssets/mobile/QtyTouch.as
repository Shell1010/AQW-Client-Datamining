package liteAssets.mobile
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.utils.*;

   public class QtyTouch
   {

      private static var stack:DisplayObjectContainer;

      private static const NAME:String = "__qtyStrip";

      private static const seen:Dictionary = new Dictionary(true);

      public function QtyTouch()
      {
         super();
      }

      public static function init(param1:Object) : void
      {
         if(param1 == null || param1.ui == null || param1.ui.ModalStack == null)
         {
            return;
         }
         stack = param1.ui.ModalStack as DisplayObjectContainer;
         if(stack == null)
         {
            return;
         }
         stack.removeEventListener(Event.ADDED,onAdded);
         stack.addEventListener(Event.ADDED,onAdded);
      }

      private static function onAdded(param1:Event) : void
      {
         if(!Mobile.active)
         {
            return;
         }
         var _loc1_:DisplayObjectContainer = param1.target as DisplayObjectContainer;
         if(_loc1_ == null || Boolean(seen[_loc1_]))
         {
            return;
         }
         if(!isSelector(_loc1_))
         {
            return;
         }
         seen[_loc1_] = true;
         patch(_loc1_);
      }

      private static function isSelector(param1:Object) : Boolean
      {
         try
         {
            return "handle" in param1 && "bar" in param1 && "t1" in param1 && param1.handle is DisplayObject && param1.bar is DisplayObject && param1.t1 != null;
         }
         catch(e:Error)
         {
         }
         return false;
      }

      public static function band(param1:DisplayObject, param2:DisplayObject, param3:Array) : Rectangle
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:Rectangle = null;
         var _loc4_:DisplayObjectContainer = param1.parent;
         var _loc5_:Rectangle = param1.getBounds(_loc4_);
         var _loc6_:Rectangle = param2 != null && param2.parent == _loc4_ ? _loc5_.union(param2.getBounds(_loc4_)) : _loc5_;
         var _loc7_:int = int(Mobile.touchPx(9));
         var _loc8_:Number = _loc5_.y + _loc5_.height / 2;
         var _loc9_:Number = _loc8_ - _loc7_ / 2;
         var _loc10_:Number = _loc8_ + _loc7_ / 2;
         var _loc11_:Number = _loc6_.x - _loc7_ / 2;
         var _loc12_:Number = _loc6_.right + _loc7_ / 2;
         var _loc13_:int = 0;
         while(_loc13_ < param3.length)
         {
            _loc2_ = param3[_loc13_] as DisplayObject;
            if(!(_loc2_ == null || _loc2_.parent != _loc4_ || !_loc2_.visible))
            {
               _loc3_ = _loc2_.getBounds(_loc4_);
               if(!(_loc3_.right <= _loc11_ || _loc3_.x >= _loc12_))
               {
                  if(_loc3_.bottom <= _loc6_.y)
                  {
                     _loc9_ = Math.max(_loc9_,(_loc3_.bottom + _loc6_.y) / 2);
                  }
                  else if(_loc3_.y >= _loc6_.bottom)
                  {
                     _loc10_ = Math.min(_loc10_,(_loc3_.y + _loc6_.bottom) / 2);
                  }
                  else if(_loc3_.right <= _loc6_.x)
                  {
                     _loc11_ = Math.max(_loc11_,(_loc3_.right + _loc6_.x) / 2);
                  }
                  else if(_loc3_.x >= _loc6_.right)
                  {
                     _loc12_ = Math.min(_loc12_,(_loc3_.x + _loc6_.right) / 2);
                  }
               }
            }
            _loc13_++;
         }
         return new Rectangle(_loc11_,_loc9_,_loc12_ - _loc11_,_loc10_ - _loc9_);
      }

      public static function strip(param1:DisplayObject, param2:Rectangle) : Rectangle
      {
         var _loc14_:Rectangle = param1.getBounds(param1.parent);
         var _loc4_:Number = Math.max(_loc14_.x,param2.x);
         return new Rectangle(_loc4_,param2.y,Math.max(0,Math.min(_loc14_.right,param2.right) - _loc4_),param2.height);
      }

      private static function patch(param1:Object) : void
      {
         var clip:Rectangle;
         var r:Rectangle;
         var s:Sprite;
         var handle:DisplayObject = null;
         var bar:DisplayObject = null;
         var par:DisplayObjectContainer = null;
         var c:Object = param1;
         handle = c.handle as DisplayObject;
         bar = c.bar as DisplayObject;
         par = handle.parent;
         if(par == null || bar.parent != par)
         {
            return;
         }
         clip = band(bar,handle,[c.t1,"t2" in c ? c.t2 : null,"t3" in c ? c.t3 : null]);
         TouchTargets.pad(handle as InteractiveObject,0,0,clip);
         if(par.getChildByName(NAME) != null)
         {
            return;
         }
         r = strip(bar,clip);
         s = new Sprite();
         s.name = NAME;
         s.graphics.beginFill(0,0);
         s.graphics.drawRect(0,0,r.width,r.height);
         s.graphics.endFill();
         s.x = r.x;
         s.y = r.y;
         s.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            var _loc1_:Rectangle = handle.getBounds(handle);
            var _loc14_:Number = par.globalToLocal(new Point(param1.stageX,param1.stageY)).x;
            var _loc4_:Number = bar.x;
            var _loc5_:Number = bar.x + bar.width - handle.width;
            handle.x = Math.max(Math.min(_loc14_ - (_loc1_.x + _loc1_.width / 2),_loc5_),_loc4_);
            handle.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN,false,false,0,0,null,false,false,false,true,0));
         });
         par.addChildAt(s,par.getChildIndex(handle));
      }
   }
}
