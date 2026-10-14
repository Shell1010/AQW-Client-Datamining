package fl.controls
{
   import fl.core.InvalidationType;
   import fl.core.UIComponent;
   import fl.events.InteractionInputType;
   import fl.events.SliderEvent;
   import fl.events.SliderEventClickTarget;
   import fl.managers.IFocusManagerComponent;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;

   [Embed(source="/_assets/assets.swf", symbol="symbol2352")]
   public class Slider extends UIComponent implements IFocusManagerComponent
   {

      protected static var defaultStyles:Object = {
         "thumbUpSkin":"SliderThumb_upSkin",
         "thumbOverSkin":"SliderThumb_overSkin",
         "thumbDownSkin":"SliderThumb_downSkin",
         "thumbDisabledSkin":"SliderThumb_disabledSkin",
         "sliderTrackSkin":"SliderTrack_skin",
         "sliderTrackDisabledSkin":"SliderTrack_disabledSkin",
         "tickSkin":"SliderTick_skin",
         "focusRectSkin":null,
         "focusRectPadding":null
      };

      protected static const TRACK_STYLES:Object = {
         "upSkin":"sliderTrackSkin",
         "overSkin":"sliderTrackSkin",
         "downSkin":"sliderTrackSkin",
         "disabledSkin":"sliderTrackDisabledSkin"
      };

      protected static const THUMB_STYLES:Object = {
         "upSkin":"thumbUpSkin",
         "overSkin":"thumbOverSkin",
         "downSkin":"thumbDownSkin",
         "disabledSkin":"thumbDisabledSkin"
      };

      protected static const TICK_STYLES:Object = {"upSkin":"tickSkin"};

      protected var _direction:String = SliderDirection.HORIZONTAL;

      protected var _minimum:Number = 0;

      protected var _maximum:Number = 10;

      protected var _value:Number = 0;

      protected var _tickInterval:Number = 0;

      protected var _snapInterval:Number = 0;

      protected var _liveDragging:Boolean = false;

      protected var tickContainer:Sprite;

      protected var thumb:BaseButton;

      protected var track:BaseButton;

      public function Slider()
      {
         super();
         setStyles();
      }

      public static function getStyleDefinition() : Object
      {
         return defaultStyles;
      }

      public function get direction() : String
      {
         return _direction;
      }

      public function set direction(param1:String) : void
      {
         _direction = param1;
         var _loc1_:Boolean = _direction == SliderDirection.VERTICAL;
         if(isLivePreview)
         {
            if(_loc1_)
            {
               setScaleY(-1);
               y = track.height;
            }
            else
            {
               setScaleY(1);
               y = 0;
            }
            positionThumb();
            return;
         }
         if(_loc1_ && componentInspectorSetting)
         {
            if(rotation % 90 == 0)
            {
               setScaleY(-1);
            }
         }
         if(!componentInspectorSetting)
         {
            rotation = _loc1_ ? 90 : 0;
         }
      }

      public function get minimum() : Number
      {
         return _minimum;
      }

      public function set minimum(param1:Number) : void
      {
         _minimum = param1;
         this.value = Math.max(param1,this.value);
         invalidate(InvalidationType.DATA);
      }

      public function get maximum() : Number
      {
         return _maximum;
      }

      public function set maximum(param1:Number) : void
      {
         _maximum = param1;
         this.value = Math.min(param1,this.value);
         invalidate(InvalidationType.DATA);
      }

      public function get tickInterval() : Number
      {
         return _tickInterval;
      }

      public function set tickInterval(param1:Number) : void
      {
         _tickInterval = param1;
         invalidate(InvalidationType.SIZE);
      }

      public function get snapInterval() : Number
      {
         return _snapInterval;
      }

      public function set snapInterval(param1:Number) : void
      {
         _snapInterval = param1;
      }

      public function set liveDragging(param1:Boolean) : void
      {
         _liveDragging = param1;
      }

      public function get liveDragging() : Boolean
      {
         return _liveDragging;
      }

      override public function get enabled() : Boolean
      {
         return super.enabled;
      }

      override public function set enabled(param1:Boolean) : void
      {
         if(enabled == param1)
         {
            return;
         }
         super.enabled = param1;
         track.enabled = thumb.enabled = param1;
      }

      override public function setSize(param1:Number, param2:Number) : void
      {
         if(_direction == SliderDirection.VERTICAL && !isLivePreview)
         {
            super.setSize(param2,param1);
         }
         else
         {
            super.setSize(param1,param2);
         }
         invalidate(InvalidationType.SIZE);
      }

      public function get value() : Number
      {
         return _value;
      }

      public function set value(param1:Number) : void
      {
         doSetValue(param1);
      }

      protected function doSetValue(param1:Number, param2:String = null, param3:String = null, param4:int = undefined) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = _value;
         if(_snapInterval != 0 && _snapInterval != 1)
         {
            _loc2_ = Math.pow(10,getPrecision(snapInterval));
            _loc3_ = _snapInterval * _loc2_;
            _loc4_ = Math.round(param1 * _loc2_);
            _loc5_ = Math.round(_loc4_ / _loc3_) * _loc3_;
            param1 = _loc5_ / _loc2_;
            _value = Math.max(minimum,Math.min(maximum,param1));
         }
         else
         {
            _value = Math.max(minimum,Math.min(maximum,Math.round(param1)));
         }
         if(_loc6_ != _value && (liveDragging && param3 != null || param2 == InteractionInputType.KEYBOARD))
         {
            dispatchEvent(new SliderEvent(SliderEvent.CHANGE,value,param3,param2,param4));
         }
         positionThumb();
      }

      protected function setStyles() : void
      {
         copyStylesToChild(thumb,THUMB_STYLES);
         copyStylesToChild(track,TRACK_STYLES);
      }

      override protected function draw() : void
      {
         if(isInvalid(InvalidationType.STYLES))
         {
            setStyles();
            invalidate(InvalidationType.SIZE,false);
         }
         if(isInvalid(InvalidationType.SIZE))
         {
            track.setSize(_width,track.height);
            track.drawNow();
            thumb.drawNow();
         }
         if(tickInterval > 0)
         {
            drawTicks();
         }
         else
         {
            clearTicks();
         }
         positionThumb();
         super.draw();
      }

      protected function positionThumb() : void
      {
         thumb.x = (_direction == SliderDirection.VERTICAL ? maximum - value : value - minimum) / (maximum - minimum) * _width;
      }

      protected function drawTicks() : void
      {
         var _loc6_:DisplayObject = null;
         clearTicks();
         tickContainer = new Sprite();
         var _loc7_:Number = maximum < 1 ? tickInterval / 100 : tickInterval;
         var _loc1_:Number = (maximum - minimum) / _loc7_;
         var _loc8_:Number = _width / _loc1_;
         var _loc9_:uint = 0;
         while(_loc9_ <= _loc1_)
         {
            _loc6_ = getDisplayObjectInstance(getStyleValue("tickSkin"));
            _loc6_.x = _loc8_ * _loc9_;
            _loc6_.y = track.y - _loc6_.height - 2;
            tickContainer.addChild(_loc6_);
            _loc9_++;
         }
         addChild(tickContainer);
      }

      protected function clearTicks() : void
      {
         if(!tickContainer || !tickContainer.parent)
         {
            return;
         }
         removeChild(tickContainer);
      }

      protected function calculateValue(param1:Number, param2:String, param3:String, param4:int = undefined) : void
      {
         var _loc6_:Number = param1 / _width * (maximum - minimum);
         if(_direction == SliderDirection.VERTICAL)
         {
            _loc6_ = maximum - _loc6_;
         }
         else
         {
            _loc6_ = minimum + _loc6_;
         }
         doSetValue(_loc6_,param2,param3,param4);
      }

      protected function doDrag(param1:MouseEvent) : void
      {
         var _loc1_:Number = _width / snapInterval;
         var _loc8_:Number = track.mouseX;
         calculateValue(_loc8_,InteractionInputType.MOUSE,SliderEventClickTarget.THUMB);
         dispatchEvent(new SliderEvent(SliderEvent.THUMB_DRAG,value,SliderEventClickTarget.THUMB,InteractionInputType.MOUSE));
      }

      protected function thumbPressHandler(param1:MouseEvent) : void
      {
         var _loc1_:DisplayObjectContainer = focusManager.form;
         _loc1_.addEventListener(MouseEvent.MOUSE_MOVE,doDrag,false,0,true);
         _loc1_.addEventListener(MouseEvent.MOUSE_UP,thumbReleaseHandler,false,0,true);
         dispatchEvent(new SliderEvent(SliderEvent.THUMB_PRESS,value,SliderEventClickTarget.THUMB,InteractionInputType.MOUSE));
      }

      protected function thumbReleaseHandler(param1:MouseEvent) : void
      {
         var _loc1_:DisplayObjectContainer = focusManager.form;
         _loc1_.removeEventListener(MouseEvent.MOUSE_MOVE,doDrag);
         _loc1_.removeEventListener(MouseEvent.MOUSE_UP,thumbReleaseHandler);
         dispatchEvent(new SliderEvent(SliderEvent.THUMB_RELEASE,value,SliderEventClickTarget.THUMB,InteractionInputType.MOUSE));
         dispatchEvent(new SliderEvent(SliderEvent.CHANGE,value,SliderEventClickTarget.THUMB,InteractionInputType.MOUSE));
      }

      protected function onTrackClick(param1:MouseEvent) : void
      {
         calculateValue(track.mouseX,InteractionInputType.MOUSE,SliderEventClickTarget.TRACK);
         if(!liveDragging)
         {
            dispatchEvent(new SliderEvent(SliderEvent.CHANGE,value,SliderEventClickTarget.TRACK,InteractionInputType.MOUSE));
         }
      }

      override protected function keyDownHandler(param1:KeyboardEvent) : void
      {
         var _loc8_:Number = NaN;
         if(!enabled)
         {
            return;
         }
         var _loc1_:Number = snapInterval > 0 ? snapInterval : 1;
         var _loc9_:Boolean = direction == SliderDirection.HORIZONTAL;
         if(param1.keyCode == Keyboard.DOWN && !_loc9_ || param1.keyCode == Keyboard.LEFT && _loc9_)
         {
            _loc8_ = value - _loc1_;
         }
         else if(param1.keyCode == Keyboard.UP && !_loc9_ || param1.keyCode == Keyboard.RIGHT && _loc9_)
         {
            _loc8_ = value + _loc1_;
         }
         else if(param1.keyCode == Keyboard.PAGE_DOWN && !_loc9_ || param1.keyCode == Keyboard.HOME && _loc9_)
         {
            _loc8_ = minimum;
         }
         else if(param1.keyCode == Keyboard.PAGE_UP && !_loc9_ || param1.keyCode == Keyboard.END && _loc9_)
         {
            _loc8_ = maximum;
         }
         if(!isNaN(_loc8_))
         {
            param1.stopPropagation();
            doSetValue(_loc8_,InteractionInputType.KEYBOARD,null,param1.keyCode);
         }
      }

      override protected function configUI() : void
      {
         super.configUI();
         thumb = new BaseButton();
         thumb.setSize(13,13);
         thumb.autoRepeat = false;
         addChild(thumb);
         thumb.addEventListener(MouseEvent.MOUSE_DOWN,thumbPressHandler,false,0,true);
         track = new BaseButton();
         track.move(0,0);
         track.setSize(80,4);
         track.autoRepeat = false;
         track.useHandCursor = false;
         track.addEventListener(MouseEvent.CLICK,onTrackClick,false,0,true);
         addChildAt(track,0);
      }

      protected function getPrecision(param1:Number) : Number
      {
         var _loc1_:String = param1.toString();
         if(_loc1_.indexOf(".") == -1)
         {
            return 0;
         }
         return _loc1_.split(".").pop().length;
      }
   }
}
