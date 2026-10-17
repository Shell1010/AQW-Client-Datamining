package spider_fla
{
   import flash.accessibility.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.net.drm.*;
   import flash.system.*;
   import flash.text.*;
   import flash.text.ime.*;
   import flash.ui.*;
   import flash.utils.*;
   import liteAssets.draw.*;
   import org.sepy.ColorPicker.ColorPicker2;

   [Embed(source="/_assets/assets.swf", symbol="symbol4061")]
   public dynamic class mcCustomizeArmor_439 extends MovieClip
   {

      public var bg:MovieClip;

      public var btnClose:SimpleButton;

      public var btnColor:MovieClip;

      public var cpAccessory:ColorPicker2;

      public var cpBase:ColorPicker2;

      public var cpTrim:ColorPicker2;

      public var submit:SimpleButton;

      public var rootClass:*;

      public var avt:Avatar;

      public var backData:*;

      public var mcSets:colorSets;

      public function mcCustomizeArmor_439()
      {
         super();
         addFrameScript(0,this.frame1,19,this.frame20,35,this.frame36);
         this.__setProp_cpAccessory_mcCustomizeArmor_Layer22_0();
         this.__setProp_cpTrim_mcCustomizeArmor_Layer23_0();
         this.__setProp_cpBase_mcCustomizeArmor_Layer24_0();
      }

      public function onColorClick(param1:Event) : *
      {
         if(this.rootClass.stage.getChildByName("mcColorPicker"))
         {
            return;
         }
         var _loc1_:colorPicker = new colorPicker();
         _loc1_.name = "mcColorPicker";
         this.rootClass.stage.addChild(_loc1_);
      }

      public function onCloseClick(param1:Event) : *
      {
         if(this.backData.intColorBase != this.avt.objData.intColorBase || this.backData.intColorTrim != this.avt.objData.intColorTrim || this.backData.intColorAccessory != this.avt.objData.intColorAccessory)
         {
            this.avt.objData.intColorBase = this.backData.intColorBase;
            this.avt.objData.intColorTrim = this.backData.intColorTrim;
            this.avt.objData.intColorAccessory = this.backData.intColorAccessory;
            this.avt.pMC.updateColor();
         }
         MovieClip(Game.root).mixer.playSound("Click");
         gotoAndPlay("out");
      }

      public function onSaveClick(param1:Event) : *
      {
         if(this.backData.intColorBase != this.avt.objData.intColorBase || this.backData.intColorTrim != this.avt.objData.intColorTrim || this.backData.intColorAccessory != this.avt.objData.intColorAccessory)
         {
            this.rootClass.world.sendChangeArmorColorRequest(this.avt.objData.intColorBase,this.avt.objData.intColorTrim,this.avt.objData.intColorAccessory);
         }
         MovieClip(Game.root).mixer.playSound("Click");
         gotoAndPlay("out");
      }

      public function onColorSelect(param1:Event) : void
      {
         switch(param1.target.name)
         {
            case "cpBase":
               this.avt.objData.intColorBase = param1.target.selectedColor;
               break;
            case "cpTrim":
               this.avt.objData.intColorTrim = param1.target.selectedColor;
               break;
            case "cpAccessory":
               this.avt.objData.intColorAccessory = param1.target.selectedColor;
         }
         this.avt.pMC.updateColor();
      }

      public function onItemRollOver(param1:Event) : void
      {
         var _loc1_:* = new Object();
         _loc1_.intColorSkin = this.avt.objData.intColorSkin;
         _loc1_.intColorHair = this.avt.objData.intColorHair;
         _loc1_.intColorEye = this.avt.objData.intColorEye;
         _loc1_.intColorBase = this.avt.objData.intColorBase;
         _loc1_.intColorTrim = this.avt.objData.intColorTrim;
         _loc1_.intColorAccessory = this.avt.objData.intColorAccessory;
         switch(param1.target.name)
         {
            case "cpBase":
               _loc1_.intColorBase = param1.target.selectedColor;
               break;
            case "cpTrim":
               _loc1_.intColorTrim = param1.target.selectedColor;
               break;
            case "cpAccessory":
               _loc1_.intColorAccessory = param1.target.selectedColor;
         }
         this.avt.pMC.updateColor(_loc1_);
      }

      public function onItemRollOut(param1:Event) : void
      {
         this.avt.pMC.updateColor();
      }

      internal function __setProp_cpAccessory_mcCustomizeArmor_Layer22_0() : *
      {
         try
         {
            this.cpAccessory["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.cpAccessory.allowUserColor = true;
         this.cpAccessory.selectedColor = 0;
         this.cpAccessory.columns = 21;
         this.cpAccessory.direction = "DL";
         this.cpAccessory.useAdvancedColorSelector = true;
         this.cpAccessory.useNoColorSelector = false;
         try
         {
            this.cpAccessory["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }

      internal function __setProp_cpTrim_mcCustomizeArmor_Layer23_0() : *
      {
         try
         {
            this.cpTrim["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.cpTrim.allowUserColor = true;
         this.cpTrim.selectedColor = 0;
         this.cpTrim.columns = 21;
         this.cpTrim.direction = "DL";
         this.cpTrim.useAdvancedColorSelector = true;
         this.cpTrim.useNoColorSelector = false;
         try
         {
            this.cpTrim["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }

      internal function __setProp_cpBase_mcCustomizeArmor_Layer24_0() : *
      {
         try
         {
            this.cpBase["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.cpBase.allowUserColor = true;
         this.cpBase.selectedColor = 0;
         this.cpBase.columns = 21;
         this.cpBase.direction = "DL";
         this.cpBase.useAdvancedColorSelector = true;
         this.cpBase.useNoColorSelector = false;
         try
         {
            this.cpBase["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }

      internal function frame1() : *
      {
         this.rootClass = MovieClip(stage.getChildAt(0));
         this.avt = this.rootClass.world.myAvatar;
         this.backData = new Object();
         this.backData.intColorBase = this.avt.objData.intColorBase;
         this.backData.intColorTrim = this.avt.objData.intColorTrim;
         this.backData.intColorAccessory = this.avt.objData.intColorAccessory;
         this.btnColor.addEventListener(MouseEvent.CLICK,this.onColorClick,false,0,true);
         this.btnClose.addEventListener(MouseEvent.CLICK,this.onCloseClick,false,0,true);
         this.submit.addEventListener(MouseEvent.CLICK,this.onSaveClick,false,0,true);
         this.cpBase.addEventListener("CHANGE",this.onColorSelect,false,0,true);
         this.cpBase.addEventListener("ROLL_OVER",this.onItemRollOver,false,0,true);
         this.cpBase.addEventListener("ROLL_OUT",this.onItemRollOut,false,0,true);
         this.cpTrim.addEventListener("CHANGE",this.onColorSelect,false,0,true);
         this.cpTrim.addEventListener("ROLL_OVER",this.onItemRollOver,false,0,true);
         this.cpTrim.addEventListener("ROLL_OUT",this.onItemRollOut,false,0,true);
         this.cpAccessory.addEventListener("CHANGE",this.onColorSelect,false,0,true);
         this.cpAccessory.addEventListener("ROLL_OVER",this.onItemRollOver,false,0,true);
         this.cpAccessory.addEventListener("ROLL_OUT",this.onItemRollOut,false,0,true);
         this.cpBase.selectedColor = this.avt.objData.intColorBase;
         this.cpTrim.selectedColor = this.avt.objData.intColorTrim;
         this.cpAccessory.selectedColor = this.avt.objData.intColorAccessory;
         if(!getChildByName("mcColorSets") && Boolean(this.rootClass.litePreference.data.bColorSets))
         {
            this.mcSets = new colorSets(this.rootClass);
            this.mcSets.name = "mcColorSets";
            this.mcSets.mode = "mcCustomizeArmor";
            this.mcSets.y = 224;
            this.mcSets.onUpdate();
            addChild(this.mcSets);
            setChildIndex(this.mcSets,0);
         }
      }

      internal function frame20() : *
      {
         stop();
      }

      internal function frame36() : *
      {
         MovieClip(parent).onClose();
      }
   }
}
