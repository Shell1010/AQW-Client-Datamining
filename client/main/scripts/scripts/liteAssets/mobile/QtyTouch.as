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
         var _loc1_:DisplayObject = null;
         var _loc2_:Rectangle = null;
         var _loc3_:DisplayObjectContainer = param1.parent;
         var _loc4_:Rectangle = param1.getBounds(_loc3_);
         var _loc5_:Rectangle = param2 != null && param2.parent == _loc3_ ? _loc4_.union(param2.getBounds(_loc3_)) : _loc4_;
         var _loc6_:int = int(Mobile.touchPx(9));
         var _loc7_:Number = _loc4_.y + _loc4_.height / 2;
         var _loc8_:Number = _loc7_ - _loc6_ / 2;
         var _loc9_:Number = _loc7_ + _loc6_ / 2;
         var _loc10_:Number = _loc5_.x - _loc6_ / 2;
         var _loc11_:Number = _loc5_.right + _loc6_ / 2;
         var _loc12_:int = 0;
         while(_loc12_ < param3.length)
         {
            _loc1_ = param3[_loc12_] as DisplayObject;
            if(!(_loc1_ == null || _loc1_.parent != _loc3_ || !_loc1_.visible))
            {
               _loc2_ = _loc1_.getBounds(_loc3_);
               if(!(_loc2_.right <= _loc10_ || _loc2_.x >= _loc11_))
               {
                  if(_loc2_.bottom <= _loc5_.y)
                  {
                     _loc8_ = Math.max(_loc8_,(_loc2_.bottom + _loc5_.y) / 2);
                  }
                  else if(_loc2_.y >= _loc5_.bottom)
                  {
                     _loc9_ = Math.min(_loc9_,(_loc2_.y + _loc5_.bottom) / 2);
                  }
                  else if(_loc2_.right <= _loc5_.x)
                  {
                     _loc10_ = Math.max(_loc10_,(_loc2_.right + _loc5_.x) / 2);
                  }
                  else if(_loc2_.x >= _loc5_.right)
                  {
                     _loc11_ = Math.min(_loc11_,(_loc2_.x + _loc5_.right) / 2);
                  }
               }
            }
            _loc12_++;
         }
         return new Rectangle(_loc10_,_loc8_,_loc11_ - _loc10_,_loc9_ - _loc8_);
      }

      public static function strip(param1:DisplayObject, param2:Rectangle) : Rectangle
      {
         var _loc1_:Rectangle = param1.getBounds(param1.parent);
         var _loc2_:Number = Math.max(_loc1_.x,param2.x);
         return new Rectangle(_loc2_,param2.y,Math.max(0,Math.min(_loc1_.right,param2.right) - _loc2_),param2.height);
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
            var _loc2_:Number = par.globalToLocal(new Point(param1.stageX,param1.stageY)).x;
            var _loc3_:Number = bar.x;
            var _loc4_:Number = bar.x + bar.width - handle.width;
            handle.x = Math.max(Math.min(_loc2_ - (_loc1_.x + _loc1_.width / 2),_loc4_),_loc3_);
            handle.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN,false,false,0,0,null,false,false,false,true,0));
         });
         par.addChildAt(s,par.getChildIndex(handle));
      }
   }
}
