package liteAssets.mobile
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.utils.*;

   public class MapTargets
   {

      private static var game:MovieClip;

      private static var stage:Stage;

      private static var lastMap:DisplayObject;

      private static var lastExt:DisplayObject;

      private static const WALK_AREA:String = "btnWalkingArea";

      private static const PAD:String = "__touchPad";

      private static const SIZE_MM:Number = 7;

      private static const SIZE_MAX:Number = 64;

      private static const SETTLE_FRAMES:int = 2;

      private static const AGAIN_MS:int = 1500;

      private static var lastFrame:int = -1;

      private static var settle:int = -1;

      private static var againAt:int = 0;

      private static var padded:Array = [];

      public function MapTargets()
      {
         super();
      }

      public static function start(param1:MovieClip) : void
      {
         stop();
         if(param1 == null || param1.stage == null)
         {
            return;
         }
         game = param1;
         stage = param1.stage;
         stage.addEventListener(Event.ENTER_FRAME,onFrame,false,0,true);
      }

      public static function stop() : void
      {
         if(stage != null)
         {
            stage.removeEventListener(Event.ENTER_FRAME,onFrame);
         }
         unpadAll();
         lastMap = null;
         lastFrame = -1;
         lastExt = null;
         settle = -1;
         againAt = 0;
         stage = null;
         game = null;
      }

      private static function onFrame(param1:Event) : void
      {
         var _loc1_:DisplayObjectContainer = null;
         if(!Mobile.active)
         {
            return;
         }
         var _loc2_:MovieClip = null;
         var _loc3_:DisplayObject = null;
         try
         {
            _loc2_ = game.world.map as MovieClip;
         }
         catch(err:Error)
         {
         }
         try
         {
            _loc1_ = game.mcExtSWF as DisplayObjectContainer;
            if(_loc1_ != null && _loc1_.numChildren > 0)
            {
               _loc3_ = _loc1_.getChildAt(0);
            }
         }
         catch(err2:Error)
         {
         }
         var _loc4_:int = _loc2_ != null ? _loc2_.currentFrame : -1;
         if(_loc2_ != lastMap || _loc4_ != lastFrame || _loc3_ != lastExt)
         {
            lastMap = _loc2_;
            lastFrame = _loc4_;
            lastExt = _loc3_;
            settle = SETTLE_FRAMES;
            againAt = 0;
         }
         if(settle > 0 && --settle == 0)
         {
            scan();
            againAt = getTimer() + AGAIN_MS;
         }
         else if(againAt != 0 && getTimer() >= againAt)
         {
            againAt = 0;
            scan();
         }
      }

      public static function scan() : void
      {
         var found:Array;
         var size:Number;
         var boxes:Array;
         var rooms:Array;
         var o:InteractiveObject = null;
         var i:int = 0;
         var box:Rectangle = null;
         var b:Rectangle = null;
         var mine:Rectangle = null;
         var ok:Boolean = false;
         var j:int = 0;
         var theirs:Rectangle = null;
         unpadAll();
         if(game == null || stage == null || !Mobile.active)
         {
            return;
         }
         found = [];
         try
         {
            if(lastMap is DisplayObjectContainer)
            {
               collect(DisplayObjectContainer(lastMap),found);
            }
            if(lastExt is DisplayObjectContainer)
            {
               collect(DisplayObjectContainer(lastExt),found);
            }
         }
         catch(err:Error)
         {
            return;
         }
         size = Math.min(Mobile.touchPx(SIZE_MM),SIZE_MAX);
         boxes = [];
         rooms = [];
         for each(o in found)
         {
            box = hitBox(o);
            boxes.push(box);
            rooms.push(room(box,size));
         }
         i = 0;
         while(i < found.length)
         {
            b = boxes[i];
            if(!(b == null || b.width <= 0 || b.height <= 0))
            {
               if(!(b.width >= size && b.height >= size))
               {
                  if(shown(found[i],b))
                  {
                     mine = rooms[i];
                     ok = true;
                     j = 0;
                     while(j < found.length && ok)
                     {
                        if(!(j == i || boxes[j] == null || Boolean(related(found[i],found[j]))))
                        {
                           theirs = rooms[j] != null ? Rectangle(rooms[j]).union(boxes[j]) : boxes[j];
                           if(mine.intersects(theirs))
                           {
                              ok = Boolean(keepOff(mine,b,boxes[j]));
                           }
                        }
                        j++;
                     }
                     if(ok)
                     {
                        pad(found[i],mine,size);
                     }
                  }
               }
            }
            i++;
         }
      }

      private static function room(param1:Rectangle, param2:Number) : Rectangle
      {
         if(param1 == null)
         {
            return null;
         }
         return new Rectangle(param1.x - Math.max(0,param2 - param1.width) / 2,param1.y - Math.max(0,param2 - param1.height) / 2,Math.max(param1.width,param2),Math.max(param1.height,param2));
      }

      private static function collect(param1:DisplayObjectContainer, param2:Array) : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:InteractiveObject = null;
         var _loc3_:DisplayObjectContainer = null;
         var _loc4_:int = 0;
         while(_loc4_ < param1.numChildren)
         {
            _loc1_ = param1.getChildAt(_loc4_);
            if(!(_loc1_ == null || !_loc1_.visible || _loc1_.name == PAD))
            {
               _loc2_ = _loc1_ as InteractiveObject;
               if(_loc1_ is SimpleButton)
               {
                  if(_loc2_.mouseEnabled && _loc1_.name != WALK_AREA)
                  {
                     param2.push(_loc2_);
                  }
               }
               else if(_loc2_ != null && _loc2_.mouseEnabled && (_loc2_.hasEventListener(MouseEvent.CLICK) || _loc2_.hasEventListener(MouseEvent.MOUSE_DOWN) || _loc2_.hasEventListener(MouseEvent.MOUSE_UP) || _loc1_ is Sprite && Boolean(Sprite(_loc1_).buttonMode)))
               {
                  param2.push(_loc2_);
               }
               else
               {
                  _loc3_ = _loc1_ as DisplayObjectContainer;
                  if(_loc3_ != null && _loc3_.mouseChildren)
                  {
                     collect(_loc3_,param2);
                  }
               }
            }
            _loc4_++;
         }
      }

      private static function hitBox(param1:InteractiveObject) : Rectangle
      {
         var _loc1_:SimpleButton = param1 as SimpleButton;
         if(_loc1_ == null)
         {
            return param1.getBounds(stage);
         }
         var _loc2_:DisplayObject = _loc1_.hitTestState;
         if(_loc2_ == null)
         {
            return null;
         }
         var _loc3_:Matrix = _loc2_.transform.matrix;
         _loc3_.concat(stageMatrix(_loc1_));
         var _loc4_:Rectangle = _loc2_.getBounds(_loc2_);
         var _loc5_:Point = _loc3_.transformPoint(_loc4_.topLeft);
         var _loc6_:Point = _loc3_.transformPoint(_loc4_.bottomRight);
         return new Rectangle(Math.min(_loc5_.x,_loc6_.x),Math.min(_loc5_.y,_loc6_.y),Math.abs(_loc6_.x - _loc5_.x),Math.abs(_loc6_.y - _loc5_.y));
      }

      private static function shown(param1:InteractiveObject, param2:Rectangle) : Boolean
      {
         var _loc1_:DisplayObject = null;
         if(opacity(param1) <= 0.05)
         {
            return false;
         }
         if(inked(param1,param2))
         {
            return true;
         }
         var _loc2_:DisplayObjectContainer = param1.parent;
         if(!(param1 is SimpleButton) || _loc2_ == null || _loc2_ == lastMap || _loc2_ == lastExt)
         {
            return false;
         }
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.numChildren)
         {
            _loc1_ = _loc2_.getChildAt(_loc3_);
            if(_loc1_ != param1 && _loc1_.visible && Boolean(inked(_loc1_,param2)))
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }

      private static function inked(param1:DisplayObject, param2:Rectangle) : Boolean
      {
         var m:Matrix;
         var seen:Boolean;
         var bmd:BitmapData = null;
         var d:DisplayObject = param1;
         var box:Rectangle = param2;
         var w:int = Math.ceil(box.width);
         var h:int = Math.ceil(box.height);
         if(w <= 0 || h <= 0 || w > 512 || h > 512)
         {
            return true;
         }
         m = stageMatrix(d);
         m.translate(-box.x,-box.y);
         bmd = new BitmapData(w,h,true,0);
         try
         {
            bmd.draw(d,m);
         }
         catch(err:Error)
         {
            bmd.dispose();
            return true;
         }
         seen = !bmd.getColorBoundsRect(4026531840,0,false).isEmpty();
         bmd.dispose();
         return seen;
      }

      private static function opacity(param1:DisplayObject) : Number
      {
         var _loc1_:Number = 1;
         var _loc2_:DisplayObject = param1;
         while(_loc2_ != null && _loc2_ != stage)
         {
            _loc1_ *= _loc2_.alpha;
            _loc2_ = _loc2_.parent;
         }
         return _loc1_;
      }

      private static function stageMatrix(param1:DisplayObject) : Matrix
      {
         var _loc1_:Matrix = new Matrix();
         var _loc2_:DisplayObject = param1;
         while(_loc2_ != null && _loc2_ != stage)
         {
            _loc1_.concat(_loc2_.transform.matrix);
            _loc2_ = _loc2_.parent;
         }
         return _loc1_;
      }

      private static function related(param1:DisplayObject, param2:DisplayObject) : Boolean
      {
         var _loc1_:DisplayObjectContainer = param1 as DisplayObjectContainer;
         var _loc2_:DisplayObjectContainer = param2 as DisplayObjectContainer;
         return _loc1_ != null && _loc1_.contains(param2) || _loc2_ != null && _loc2_.contains(param1);
      }

      private static function keepOff(param1:Rectangle, param2:Rectangle, param3:Rectangle) : Boolean
      {
         var _loc1_:Number = Math.max(param3.left - param2.right,param2.left - param3.right);
         var _loc2_:Number = Math.max(param3.top - param2.bottom,param2.top - param3.bottom);
         if(_loc1_ < 0 && _loc2_ < 0)
         {
            return param3.width <= param1.width && param3.height <= param1.height;
         }
         if(_loc1_ >= _loc2_)
         {
            if(param3.left >= param2.right)
            {
               param1.right = Math.min(param1.right,(param2.right + param3.left) / 2);
            }
            else
            {
               param1.left = Math.max(param1.left,(param3.right + param2.left) / 2);
            }
         }
         else if(param3.top >= param2.bottom)
         {
            param1.bottom = Math.min(param1.bottom,(param2.bottom + param3.top) / 2);
         }
         else
         {
            param1.top = Math.max(param1.top,(param3.bottom + param2.top) / 2);
         }
         return true;
      }

      private static function pad(param1:InteractiveObject, param2:Rectangle, param3:Number) : void
      {
         if(param1.parent == null)
         {
            return;
         }
         var _loc1_:Point = param1.parent.globalToLocal(param2.topLeft);
         var _loc2_:Point = param1.parent.globalToLocal(param2.bottomRight);
         var _loc3_:Rectangle = new Rectangle(Math.min(_loc1_.x,_loc2_.x),Math.min(_loc1_.y,_loc2_.y),Math.abs(_loc2_.x - _loc1_.x),Math.abs(_loc2_.y - _loc1_.y));
         var _loc4_:Matrix = stageMatrix(param1);
         var _loc5_:Number = Math.sqrt(_loc4_.a * _loc4_.a + _loc4_.b * _loc4_.b);
         var _loc6_:Number = Math.sqrt(_loc4_.c * _loc4_.c + _loc4_.d * _loc4_.d);
         if(_loc5_ <= 0 || _loc6_ <= 0)
         {
            return;
         }
         TouchTargets.pad(param1,param3 / _loc5_,param3 / _loc6_,_loc3_);
         padded.push(param1);
      }

      private static function unpadAll() : void
      {
         var _loc1_:InteractiveObject = null;
         for each(_loc1_ in padded)
         {
            try
            {
               TouchTargets.unpad(_loc1_);
            }
            catch(err:Error)
            {
            }
         }
         padded = [];
      }
   }
}
