package org.sepy.ColorPicker
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import liteAssets.draw.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol2662")]
   public class IntInput extends MovieClip
   {

      public var _value:Number;

      private var broadcastMessage:Function;

      private var input:TextField;

      private var tlabel:TextField;

      private var _label:String;

      private var _max:Number;

      public function IntInput(param1:String, param2:String)
      {
         super();
         var _loc1_:TextFormat = MailArt.fmt(10,0);
         this.tlabel = new TextField();
         this.tlabel.width = 31;
         this.tlabel.height = 16;
         this.addChildAt(this.tlabel,1);
         this.tlabel.x = 2;
         this.tlabel.y = 1;
         this.tlabel.embedFonts = MailArt.embedded();
         if(this.tlabel.embedFonts)
         {
            this.tlabel.antiAliasType = AntiAliasType.ADVANCED;
         }
         this.tlabel.defaultTextFormat = _loc1_;
         this.tlabel.text = param1;
         this.input = new TextField();
         this.input.height = 16;
         this.input.width = 31;
         this.input.name = "input";
         this.addChildAt(this.input,2);
         this.input.x = 22;
         this.input.y = 1;
         this.input.type = param2;
         this.input.embedFonts = MailArt.embedded();
         if(this.input.embedFonts)
         {
            this.input.antiAliasType = AntiAliasType.ADVANCED;
         }
         this.input.maxChars = 3;
         this.input.restrict = "[0-9]";
         this.input.defaultTextFormat = _loc1_;
         this.input.addEventListener(Event.CHANGE,this.onChanged,false,0,true);
      }

      public function set value(param1:Number) : *
      {
         this._value = param1;
         this.input.text = this._value.toString(10);
      }

      public function get value() : Number
      {
         return this._value;
      }

      private function onChanged(param1:Event) : *
      {
         var _loc1_:Number = Number(this.input.text);
         if(isNaN(_loc1_))
         {
            this.input.text = "0";
         }
         if(_loc1_ > this._max)
         {
            this.input.text = this._max.toString();
         }
         this._value = Number(this.input.text);
         MovieClip(parent).changed(this,Number(this.input.text));
      }

      public function set label(param1:String) : void
      {
         this._label = param1;
         this.tlabel.text = param1;
      }

      public function get label() : String
      {
         return this._label;
      }

      public function set max(param1:Number) : *
      {
         this._max = param1;
      }

      public function get max() : Number
      {
         return this._max;
      }
   }
}
