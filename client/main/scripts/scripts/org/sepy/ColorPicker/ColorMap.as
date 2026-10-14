package org.sepy.ColorPicker
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol2689")]
   public class ColorMap extends MovieClip
   {

      private var mc:Sprite;

      private var cross_Mc:MovieClip;

      private var cross_Mask:MovieClip;

      public var newMC:*;

      private var b:Bitmap;

      private var bmp:BitmapData;

      private var _color:Number;

      private var down:Boolean = false;

      public var m_fillType:String = "linear";

      public var m_colors:Array = [16711680,16776960,65280,65535,255,16711935,16711680];

      public var m_alphas:Array = [100,100,100,100,100,100,100];

      public var m_ratios:Array = [0,42,64,127,184,215,255];

      public var m_matrix:Matrix = new Matrix();

      public function ColorMap()
      {
         super();
         addFrameScript(0,this.frame1);
         this.mc = new Sprite();
         this.mc.name = "mc";
         this.addChild(this.mc);
         this.mc.x = 1;
         this.mc.y = 1;
         this.cross_Mc = new cross_mc() as MovieClip;
         this.cross_Mc.name = "cross_mc";
         this.addChild(this.cross_Mc);
         this.cross_Mask = new cross_mask() as MovieClip;
         this.cross_Mask.name = "cross_mask";
         this.addChild(this.cross_Mask);
         this.cross_Mc.mask = this.cross_Mask;
         this.init();
      }

      private function init() : void
      {
         var _loc1_:String = "linear";
         var _loc2_:Array = [16777215,0,0];
         var _loc3_:Array = [0,0,100];
         var _loc4_:Array = [0,127,255];
         var _loc5_:Matrix = new Matrix();
         _loc5_.createGradientBox(175,187,90 * Math.PI / 180);
         this.m_matrix.createGradientBox(175,187);
         this.mc.graphics.beginGradientFill(this.m_fillType,this.m_colors,this.m_alphas,this.m_ratios,this.m_matrix as Matrix);
         this.mc.graphics.moveTo(0,0);
         this.mc.graphics.lineTo(175,0);
         this.mc.graphics.lineTo(175,187);
         this.mc.graphics.lineTo(0,187);
         this.mc.graphics.lineTo(0,0);
         this.mc.graphics.endFill();
         this.newMC = new MovieClip();
         this.newMC.name = "upper";
         this.mc.addChild(this.newMC);
         this.newMC.graphics.beginGradientFill(_loc1_,_loc2_,_loc3_,_loc4_,_loc5_ as Matrix);
         this.newMC.graphics.moveTo(0,0);
         this.newMC.graphics.lineTo(175,0);
         this.newMC.graphics.lineTo(175,187);
         this.newMC.graphics.lineTo(0,187);
         this.newMC.graphics.lineTo(0,0);
         this.newMC.graphics.endFill();
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.onDown,false,0,true);
         this.addEventListener(MouseEvent.MOUSE_UP,this.onUp,false,0,true);
         this.addEventListener(MouseEvent.MOUSE_MOVE,this.onMove,false,0,true);
         this.draw();
      }

      private function onDown(param1:MouseEvent) : void
      {
         this.down = true;
         this.onMove(param1);
      }

      private function onUp(param1:MouseEvent) : void
      {
         this.down = false;
      }

      private function onMove(param1:MouseEvent) : void
      {
         var _loc1_:Number = NaN;
         if(this.down)
         {
            _loc1_ = Number(this.bmp.getPixel(mouseX - this.mc.x - 1,mouseY - this.mc.y));
            this.cross_Mc.x = mouseX;
            this.cross_Mc.y = mouseY;
            MovieClip(parent).change(this,_loc1_);
         }
      }

      private function draw() : void
      {
         if(this.bmp != null)
         {
            this.bmp.dispose();
         }
         this.bmp = new BitmapData(this.mc.width,this.mc.height);
         this.bmp.draw(this.mc);
      }

      private function change(param1:MovieClip, param2:Number) : *
      {
         this._color = param2;
      }

      public function set color(param1:Number) : void
      {
         this._color = param1;
      }

      public function get color() : Number
      {
         return this._color;
      }

      public function findTheColor(param1:Number) : Boolean
      {
         var _loc1_:Rectangle = this.bmp.getColorBoundsRect(4294967295,4278190080 + param1,true);
         this.cross_Mc.x = _loc1_.x + _loc1_.width / 2 + 2;
         this.cross_Mc.y = _loc1_.y + _loc1_.height / 2 + 2;
         return !(_loc1_.x == 0 && _loc1_.y == 0 && _loc1_.width == this.bmp.width && _loc1_.width == this.bmp.height);
      }

      internal function frame1() : *
      {
         stop();
      }
   }
}
