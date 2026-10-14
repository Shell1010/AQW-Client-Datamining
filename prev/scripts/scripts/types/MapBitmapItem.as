package types
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;

   public class MapBitmapItem
   {

      public var child:DisplayObject;

      public var x:Number;

      public var bmDO:Bitmap;

      public var bmd:BitmapData;

      public var bm:Bitmap;

      public function MapBitmapItem()
      {
         super();
         this.child = null;
         this.x = 0;
         this.bmDO = null;
         this.bmd = null;
         this.bm = null;
      }
   }
}
