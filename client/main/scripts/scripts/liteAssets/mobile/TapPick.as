package liteAssets.mobile
{
   import flash.display.*;
   import flash.geom.*;

   public class TapPick
   {

      private static var skipA:DisplayObject;

      private static var skipB:DisplayObject;

      private static var deepPick:Boolean;

      private static var btnOnly:Boolean;

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

      public static function at(param1:Stage, param2:Number, param3:Number, param4:DisplayObject = null, param5:DisplayObject = null, param6:Boolean = false) : InteractiveObject
      {
         var r:DisplayObject;
         var st:Stage = param1;
         var x:Number = param2;
         var y:Number = param3;
         var a:DisplayObject = param4;
         var b:DisplayObject = param5;
         var deep:Boolean = param6;
         if(st == null)
         {
            return null;
         }
         hot.x = x;
         hot.y = y;
         skipA = a;
         skipB = b;
         deepPick = deep;
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
         btnOnly = false;
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
         var _loc1_:DisplayObject = null;
         var _loc2_:SimpleButton = null;
         var _loc3_:InteractiveObject = null;
         if(param1 == null || !param1.visible || param1 == skipA || param1 == skipB)
         {
            return null;
         }
         var _loc4_:DisplayObject = param1.mask;
         if(_loc4_ != null && !_loc4_.hitTestPoint(hot.x,hot.y,true))
         {
            return null;
         }
         var _loc5_:DisplayObjectContainer = param1 as DisplayObjectContainer;
         if(_loc5_ == null)
         {
            _loc2_ = param1 as SimpleButton;
            if(_loc2_ != null ? !hitButton(_loc2_) : Boolean(btnOnly) || !param1.hitTestPoint(hot.x,hot.y,true))
            {
               return null;
            }
            _loc3_ = param1 as InteractiveObject;
            return _loc3_ != null && _loc3_.mouseEnabled ? _loc3_ : PROP;
         }
         if(btnOnly)
         {
            if(_loc5_.scrollRect != null && !_loc5_.hitTestPoint(hot.x,hot.y,false))
            {
               return null;
            }
            _loc1_ = kids(_loc5_);
            if(_loc1_ == null)
            {
               return null;
            }
         }
         else if(!_loc5_.hitTestPoint(hot.x,hot.y,false) && _loc5_.width > 0 && _loc5_.height > 0)
         {
            if(!deepPick || _loc5_.scrollRect != null)
            {
               return null;
            }
            btnOnly = true;
            _loc1_ = kids(_loc5_);
            btnOnly = false;
            if(_loc1_ == null)
            {
               return null;
            }
         }
         else
         {
            _loc1_ = kids(_loc5_);
            if(_loc1_ == null)
            {
               return _loc5_.mouseEnabled && Boolean(own(_loc5_)) ? _loc5_ : null;
            }
         }
         if(_loc1_ == PROP || !_loc5_.mouseChildren)
         {
            return _loc5_.mouseEnabled ? _loc5_ : PROP;
         }
         return _loc1_;
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
