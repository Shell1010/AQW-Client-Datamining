package liteAssets.draw
{
   import fl.controls.TextInput;
   import fl.motion.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.net.*;
   import flash.text.*;
   import flash.utils.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol2314")]
   public class colorPicker extends MovieClip
   {

      public var btnColorPick:SimpleButton;

      public var colorPreview:MovieClip;

      public var txtBlue:TextInput;

      public var txtGreen:TextInput;

      public var txtHex:TextInput;

      public var txtRed:TextInput;

      public var ui:MovieClip;

      private var _stageBitmap:BitmapData;

      private var _stageBitmapW:int = 0;

      private var _stageBitmapH:int = 0;

      public function colorPicker()
      {
         super();
         this.txtRed.text = "255";
         this.txtGreen.text = "255";
         this.txtBlue.text = "255";
         this.txtHex.text = "#ffffff";
         this.ui.addEventListener(MouseEvent.MOUSE_DOWN,this.onDrag,false,0,true);
         this.ui.addEventListener(MouseEvent.MOUSE_UP,this.onMRelease,false,0,true);
         this.ui.btnClose.addEventListener(MouseEvent.CLICK,this.onClose,false,0,true);
         this.btnColorPick.addEventListener(MouseEvent.CLICK,this.onBtColor,false,0,true);
         this.__setProp_txtHex_mcColorPicker_Layer1_0();
         this.__setProp_txtRed_mcColorPicker_Layer1_0();
         this.__setProp_txtBlue_mcColorPicker_Layer1_0();
         this.__setProp_txtGreen_mcColorPicker_Layer1_0();
      }

      public function cleanup() : void
      {
         this.ui.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDrag);
         this.ui.removeEventListener(MouseEvent.MOUSE_UP,this.onMRelease);
         this.ui.btnClose.removeEventListener(MouseEvent.CLICK,this.onClose);
         this.btnColorPick.removeEventListener(MouseEvent.CLICK,this.onBtColor);
         if(this._stageBitmap != null)
         {
            this._stageBitmap.dispose();
            this._stageBitmap = null;
         }
         if(stage != null)
         {
            stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.getColor);
         }
         parent.removeChild(this);
      }

      private function onClose(param1:MouseEvent) : void
      {
         this.cleanup();
      }

      private function onBtColor(param1:MouseEvent) : void
      {
         stage.addEventListener(MouseEvent.MOUSE_DOWN,this.getColor,false,0,true);
      }

      private function getColor(param1:MouseEvent) : void
      {
         var _loc1_:int = stage.stageWidth;
         var _loc2_:int = stage.stageHeight;
         if(this._stageBitmap == null || this._stageBitmapW != _loc1_ || this._stageBitmapH != _loc2_)
         {
            if(this._stageBitmap != null)
            {
               this._stageBitmap.dispose();
            }
            this._stageBitmap = new BitmapData(_loc1_,_loc2_,false,0);
            this._stageBitmapW = _loc1_;
            this._stageBitmapH = _loc2_;
         }
         this._stageBitmap.draw(stage);
         var _loc3_:uint = uint(this._stageBitmap.getPixel(stage.mouseX,stage.mouseY));
         var _loc4_:int = _loc3_ >> 16 & 0xFF;
         var _loc5_:int = _loc3_ >> 8 & 0xFF;
         var _loc6_:int = _loc3_ & 0xFF;
         this.txtRed.text = _loc4_.toString();
         this.txtGreen.text = _loc5_.toString();
         this.txtBlue.text = _loc6_.toString();
         this.txtHex.text = "#" + _loc3_.toString(16);
         var _loc7_:Color = new Color();
         _loc7_.setTint(_loc3_,1);
         this.colorPreview.transform.colorTransform = _loc7_;
         stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.getColor);
      }

      private function onDrag(param1:MouseEvent) : void
      {
         this.startDrag();
      }

      private function onMRelease(param1:MouseEvent) : void
      {
         this.stopDrag();
      }

      internal function __setProp_txtHex_mcColorPicker_Layer1_0() : *
      {
         try
         {
            this.txtHex["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.txtHex.displayAsPassword = false;
         this.txtHex.editable = true;
         this.txtHex.enabled = true;
         this.txtHex.maxChars = 0;
         this.txtHex.restrict = "";
         this.txtHex.text = "#FFFFFF";
         this.txtHex.visible = true;
         try
         {
            this.txtHex["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }

      internal function __setProp_txtRed_mcColorPicker_Layer1_0() : *
      {
         try
         {
            this.txtRed["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.txtRed.displayAsPassword = false;
         this.txtRed.editable = true;
         this.txtRed.enabled = true;
         this.txtRed.maxChars = 0;
         this.txtRed.restrict = "";
         this.txtRed.text = "255";
         this.txtRed.visible = true;
         try
         {
            this.txtRed["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }

      internal function __setProp_txtBlue_mcColorPicker_Layer1_0() : *
      {
         try
         {
            this.txtBlue["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.txtBlue.displayAsPassword = false;
         this.txtBlue.editable = true;
         this.txtBlue.enabled = true;
         this.txtBlue.maxChars = 0;
         this.txtBlue.restrict = "";
         this.txtBlue.text = "255";
         this.txtBlue.visible = true;
         try
         {
            this.txtBlue["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }

      internal function __setProp_txtGreen_mcColorPicker_Layer1_0() : *
      {
         try
         {
            this.txtGreen["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.txtGreen.displayAsPassword = false;
         this.txtGreen.editable = true;
         this.txtGreen.enabled = true;
         this.txtGreen.maxChars = 0;
         this.txtGreen.restrict = "";
         this.txtGreen.text = "255";
         this.txtGreen.visible = true;
         try
         {
            this.txtGreen["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
