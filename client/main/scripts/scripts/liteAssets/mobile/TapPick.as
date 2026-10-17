package liteAssets.mobile
{
   import flash.display.*;
   import flash.geom.*;

   public class TapPick
   {

      private static var skipA:DisplayObject;

      private static var skipB:DisplayObject;

      private static const PROP:Shape = new Shape();

      private static const HIT_BMD:BitmapData = new BitmapData(1,1,true,0);

      private static const HIT_CT:ColorTransform = new ColorTransform(1,1,1,1,0,0,0,255);

      private static const HIT_M:Matrix = new Matrix();

      private static const probe:Shape = new Shape();

      private static const hot:Point = new Point();

      public function TapPick()
      {
         super();
      }

      public static function at(param1:Stage, param2:Number, param3:Number, param4:DisplayObject = null, param5:DisplayObject = null) : InteractiveObject
      {
         var r:DisplayObject;
         var st:Stage = param1;
         var x:Number = param2;
         var y:Number = param3;
         var a:DisplayObject = param4;
         var b:DisplayObject = param5;
         if(st == null)
         {
            return null;
         }
         hot.x = x;
         hot.y = y;
         skipA = a;
         skipB = b;
         r = null;
         try
         {
            r = kids(st);
         }
         catch(e:Error)
         {
            r = null;
         }
         skipA = null;
         skipB = null;
         return r != null && r != PROP ? InteractiveObject(r) : st;
      }

      private static function kids(param1:DisplayObjectContainer) : DisplayObject
      {
         var prop:Boolean;
         var i:int;
         var j:int = 0;
         var mk:DisplayObject = null;
         var ch:DisplayObject = null;
         var r:DisplayObject = null;
         var c:DisplayObjectContainer = param1;
         var n:int = 0;
         var masks:Array = null;
         try
         {
            n = c.numChildren;
            j = 0;
            while(j < n)
            {
               mk = c.getChildAt(j).mask;
               if(mk != null)
               {
                  if(masks == null)
                  {
                     masks = [];
                  }
                  masks.push(mk);
               }
               j++;
            }
         }
         catch(e:Error)
         {
            return null;
         }
         prop = false;
         i = n - 1;
         while(i >= 0)
         {
            ch = c.getChildAt(i);
            if(!(masks != null && masks.indexOf(ch) >= 0))
            {
               r = hit(ch);
               if(r != null)
               {
                  if(r != PROP)
                  {
                     return r;
                  }
                  if(c.mouseEnabled && !(ch is InteractiveObject))
                  {
                     return PROP;
                  }
                  prop = true;
               }
            }
            i--;
         }
         return prop ? PROP : null;
      }

      private static function hit(param1:DisplayObject) : DisplayObject
      {
         var _loc1_:SimpleButton = null;
         var _loc2_:InteractiveObject = null;
         if(param1 == null || !param1.visible || param1 == skipA || param1 == skipB)
         {
            return null;
         }
         var _loc3_:DisplayObject = param1.mask;
         if(_loc3_ != null && !_loc3_.hitTestPoint(hot.x,hot.y,true))
         {
            return null;
         }
         var _loc4_:DisplayObjectContainer = param1 as DisplayObjectContainer;
         if(_loc4_ == null)
         {
            _loc1_ = param1 as SimpleButton;
            if(_loc1_ != null ? !hitButton(_loc1_) : !param1.hitTestPoint(hot.x,hot.y,true))
            {
               return null;
            }
            _loc2_ = param1 as InteractiveObject;
            return _loc2_ != null && _loc2_.mouseEnabled ? _loc2_ : PROP;
         }
         if(!_loc4_.hitTestPoint(hot.x,hot.y,false) && _loc4_.width > 0 && _loc4_.height > 0)
         {
            return null;
         }
         var _loc5_:DisplayObject = kids(_loc4_);
         if(_loc5_ == null)
         {
            return _loc4_.mouseEnabled && Boolean(own(_loc4_)) ? _loc4_ : null;
         }
         if(_loc5_ == PROP || !_loc4_.mouseChildren)
         {
            return _loc4_.mouseEnabled ? _loc4_ : PROP;
         }
         return _loc5_;
      }

      private static function hitButton(param1:SimpleButton) : Boolean
      {
         var m:Matrix;
         var lp:Point;
         var b:SimpleButton = param1;
         var h:DisplayObject = b.hitTestState;
         if(h == null)
         {
            return false;
         }
         if(h.stage != null)
         {
            return h.hitTestPoint(hot.x,hot.y,true);
         }
         m = h.transform.matrix;
         if(m == null)
         {
            m = new Matrix();
         }
         m.invert();
         lp = m.transformPoint(b.globalToLocal(hot));
         if(!h.getBounds(h).containsPoint(lp))
         {
            return false;
         }
         HIT_M.setTo(1,0,0,1,0.5 - lp.x,0.5 - lp.y);
         try
         {
            HIT_BMD.setPixel32(0,0,0);
            HIT_BMD.draw(h,HIT_M,HIT_CT);
         }
         catch(e:Error)
         {
            return true;
         }
         return HIT_BMD.getPixel32(0,0) >>> 24 != 0;
      }

      private static function own(param1:DisplayObjectContainer) : Boolean
      {
         var pg:Graphics;
         var r:Boolean;
         var lp:Point = null;
         var c:DisplayObjectContainer = param1;
         var s:Sprite = c as Sprite;
         if(s == null)
         {
            return false;
         }
         pg = probe.graphics;
         r = false;
         try
         {
            pg.copyFrom(s.graphics);
            lp = s.globalToLocal(hot);
            r = Boolean(probe.hitTestPoint(lp.x,lp.y,true));
         }
         catch(e:Error)
         {
            r = false;
         }
         pg.clear();
         return r;
      }
   }
}
