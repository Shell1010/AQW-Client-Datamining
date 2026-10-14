package fl.controls
{
   import fl.core.InvalidationType;
   import fl.core.UIComponent;
   import fl.managers.IFocusManagerComponent;
   import flash.display.DisplayObject;

   [Embed(source="/_assets/assets.swf", symbol="symbol3505")]
   public class Button extends LabelButton implements IFocusManagerComponent
   {

      public static var createAccessibilityImplementation:Function;

      private static var defaultStyles:Object = {
         "emphasizedSkin":"Button_emphasizedSkin",
         "emphasizedPadding":2
      };

      protected var _emphasized:Boolean = false;

      protected var emphasizedBorder:DisplayObject;

      public function Button()
      {
         super();
      }

      public static function getStyleDefinition() : Object
      {
         return UIComponent.mergeStyles(LabelButton.getStyleDefinition(),defaultStyles);
      }

      public function get emphasized() : Boolean
      {
         return _emphasized;
      }

      public function set emphasized(param1:Boolean) : void
      {
         _emphasized = param1;
         invalidate(InvalidationType.STYLES);
      }

      override protected function draw() : void
      {
         if(isInvalid(InvalidationType.STYLES) || isInvalid(InvalidationType.SIZE))
         {
            drawEmphasized();
         }
         super.draw();
         if(emphasizedBorder != null)
         {
            setChildIndex(emphasizedBorder,numChildren - 1);
         }
      }

      protected function drawEmphasized() : void
      {
         var _loc1_:Number = NaN;
         if(emphasizedBorder != null)
         {
            removeChild(emphasizedBorder);
         }
         emphasizedBorder = null;
         if(!_emphasized)
         {
            return;
         }
         var _loc2_:Object = getStyleValue("emphasizedSkin");
         if(_loc2_ != null)
         {
            emphasizedBorder = getDisplayObjectInstance(_loc2_);
         }
         if(emphasizedBorder != null)
         {
            addChildAt(emphasizedBorder,0);
            _loc1_ = Number(getStyleValue("emphasizedPadding"));
            emphasizedBorder.x = emphasizedBorder.y = -_loc1_;
            emphasizedBorder.width = width + _loc1_ * 2;
            emphasizedBorder.height = height + _loc1_ * 2;
         }
      }

      override public function drawFocus(param1:Boolean) : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:* = undefined;
         super.drawFocus(param1);
         if(param1)
         {
            _loc1_ = Number(getStyleValue("emphasizedPadding"));
            if(_loc1_ < 0 || !_emphasized)
            {
               _loc1_ = 0;
            }
            _loc2_ = getStyleValue("focusRectPadding");
            _loc2_ = _loc2_ == null ? 2 : _loc2_;
            _loc2_ += _loc1_;
            uiFocusRect.x = -_loc2_;
            uiFocusRect.y = -_loc2_;
            uiFocusRect.width = width + _loc2_ * 2;
            uiFocusRect.height = height + _loc2_ * 2;
         }
      }

      override protected function initializeAccessibility() : void
      {
         if(Button.createAccessibilityImplementation != null)
         {
            Button.createAccessibilityImplementation(this);
         }
      }
   }
}
