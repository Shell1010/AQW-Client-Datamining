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

   [Embed(source="/_assets/assets.swf", symbol="symbol4073")]
   public dynamic class mcCustomize_413 extends MovieClip
   {

      public var bg:MovieClip;

      public var btnClose:SimpleButton;

      public var btnColor:MovieClip;

      public var btnLeft:SimpleButton;

      public var btnRight:SimpleButton;

      public var cpEye:ColorPicker2;

      public var cpHair:ColorPicker2;

      public var cpSkin:ColorPicker2;

      public var submit:SimpleButton;

      public var txtHair:TextField;

      public var rootClass:*;

      public var avt:Avatar;

      public var backData:*;

      public var HairStyle:Array;

      public var intHairStyleIndex:int;

      public var arrColors:*;

      public var arrEyeColors:*;

      public var mcSets:colorSets;

      public function mcCustomize_413()
      {
         super();
         addFrameScript(0,this.frame1,19,this.frame20,35,this.frame36);
         this.__setProp_cpEye_mcCustomize_cptabs_0();
         this.__setProp_cpSkin_mcCustomize_Layer22_0();
         this.__setProp_cpHair_mcCustomize_Layer23_0();
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
         if(this.avt.objData.HairID != this.backData.HairID)
         {
            this.avt.objData.HairID = this.backData.HairID;
            this.avt.objData.strHairName = this.backData.strHairName;
            this.avt.objData.strHairFilename = this.backData.strHairFilename;
            this.avt.pMC.loadHair();
         }
         this.avt.objData.intColorSkin = this.backData.intColorSkin;
         this.avt.objData.intColorHair = this.backData.intColorHair;
         this.avt.objData.intColorEye = this.backData.intColorEye;
         this.avt.pMC.updateColor();
         MovieClip(Game.root).mixer.playSound("Click");
         gotoAndPlay("out");
      }

      public function onSaveClick(param1:Event) : *
      {
         if(this.backData.HairID != this.avt.objData.HairID || this.backData.intColorSkin != this.avt.objData.intColorSkin || this.backData.intColorHair != this.avt.objData.intColorHair || this.backData.intColorEye != this.avt.objData.intColorEye)
         {
            this.rootClass.world.sendChangeColorRequest(this.avt.objData.intColorSkin,this.avt.objData.intColorHair,this.avt.objData.intColorEye,this.avt.objData.HairID);
         }
         MovieClip(Game.root).mixer.playSound("Click");
         gotoAndPlay("out");
      }

      public function nextHairStyle(param1:Event) : *
      {
         if(param1.currentTarget.name == "btnRight")
         {
            this.intHairStyleIndex = (this.intHairStyleIndex + 1) % this.HairStyle.length;
         }
         else if(param1.currentTarget.name == "btnLeft")
         {
            this.intHairStyleIndex = (this.intHairStyleIndex + this.HairStyle.length - 1) % this.HairStyle.length;
         }
         this.avt.objData.HairID = this.HairStyle[this.intHairStyleIndex].HairID;
         this.avt.objData.strHairName = this.HairStyle[this.intHairStyleIndex].sName;
         this.avt.objData.strHairFilename = this.HairStyle[this.intHairStyleIndex].sFile;
         this.txtHair.text = this.avt.objData.strHairName;
         this.avt.pMC.loadHair();
      }

      public function onColorSelect(param1:Event) : void
      {
         switch(param1.target.name)
         {
            case "cpSkin":
               this.avt.objData.intColorSkin = param1.target.selectedColor;
               break;
            case "cpEye":
               this.avt.objData.intColorEye = param1.target.selectedColor;
               break;
            case "cpHair":
               this.avt.objData.intColorHair = param1.target.selectedColor;
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
            case "cpSkin":
               _loc1_.intColorSkin = param1.target.selectedColor;
               break;
            case "cpEye":
               _loc1_.intColorEye = param1.target.selectedColor;
               break;
            case "cpHair":
               _loc1_.intColorHair = param1.target.selectedColor;
         }
         this.avt.pMC.updateColor(_loc1_);
      }

      public function onItemRollOut(param1:Event) : void
      {
         this.avt.pMC.updateColor();
      }

      internal function __setProp_cpEye_mcCustomize_cptabs_0() : *
      {
         try
         {
            this.cpEye["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.cpEye.allowUserColor = true;
         this.cpEye.selectedColor = 0;
         this.cpEye.columns = 21;
         this.cpEye.direction = "DL";
         this.cpEye.useAdvancedColorSelector = true;
         this.cpEye.useNoColorSelector = false;
         try
         {
            this.cpEye["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }

      internal function __setProp_cpSkin_mcCustomize_Layer22_0() : *
      {
         try
         {
            this.cpSkin["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.cpSkin.allowUserColor = true;
         this.cpSkin.selectedColor = 0;
         this.cpSkin.columns = 21;
         this.cpSkin.direction = "DL";
         this.cpSkin.useAdvancedColorSelector = true;
         this.cpSkin.useNoColorSelector = false;
         try
         {
            this.cpSkin["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }

      internal function __setProp_cpHair_mcCustomize_Layer23_0() : *
      {
         try
         {
            this.cpHair["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.cpHair.allowUserColor = true;
         this.cpHair.selectedColor = 0;
         this.cpHair.columns = 21;
         this.cpHair.direction = "DL";
         this.cpHair.useAdvancedColorSelector = true;
         this.cpHair.useNoColorSelector = false;
         try
         {
            this.cpHair["componentInspectorSetting"] = false;
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
         this.backData.HairID = this.avt.objData.HairID;
         this.backData.strHairName = this.avt.objData.strHairName;
         this.backData.strHairFilename = this.avt.objData.strHairFilename;
         this.backData.intColorSkin = this.avt.objData.intColorSkin;
         this.backData.intColorHair = this.avt.objData.intColorHair;
         this.backData.intColorEye = this.avt.objData.intColorEye;
         this.btnColor.addEventListener(MouseEvent.CLICK,this.onColorClick,false,0,true);
         this.btnClose.addEventListener(MouseEvent.CLICK,this.onCloseClick,false,0,true);
         this.submit.addEventListener(MouseEvent.CLICK,this.onSaveClick,false,0,true);
         this.HairStyle = this.rootClass.world.hairshopinfo.hair;
         this.intHairStyleIndex = -1;
         this.btnLeft.addEventListener(MouseEvent.CLICK,this.nextHairStyle,false,0,true);
         this.btnRight.addEventListener(MouseEvent.CLICK,this.nextHairStyle,false,0,true);
         this.arrColors = [65793,16777215,12767958,9673634,8556972,5398908,4478310,2500663,3422539,4541285,6182021,3618922,2102889,8476790,9319279,4928583,14188924,2436920,6593232,4817850,3366536,3559294,1977414,9622526,10074585,13557484,5220272,7715142,5674563,5668932,4808462,4020272,3560001,4421735,5405282,3433818,3033928,3753268,14019773,10540396,16763904,14922046,11509315,11040791,13597462,14515004,10900510,16777164,16777113,16509316,13026702,8488053,10027008,6684672,4786437,15230291,13382701,12927265,10234126,10053171,7753511,9322016,7746331,8601921,6041135,4465190,13088131,9602663,8218929,15388042,14658389,15982797,15121555,14460011,14121559,13001261,3157797,13092792,5197887,7497554,4008995,6178103,8542790,7027237,3678742,5977124,9265949,5127967,10000828,65535,3381657,26367,2635172,91294,13158,16776960,16777062,16750848,65280,39219,7065902,16711680,11046487,4536088,10040064,16724940,16724869,10432464,4925009,6684876];
         this.arrEyeColors = [65793,16777215,10000828,8556972,5398908,65535,3381657,10074585,4817850,3366536,3559294,26367,2635172,91294,2500663,1977414,16776960,16777062,14922046,11040791,16750848,16763904,65280,39219,7065902,5674563,4808462,3753268,16711680,10027008,8601921,6041135,4465190,11046487,4536088,10053171,7753511,9322016,7746331,10040064,6684672,16724940,10432464,4925009,6684876];
         this.cpSkin.addEventListener("CHANGE",this.onColorSelect,false,0,true);
         this.cpEye.addEventListener("CHANGE",this.onColorSelect,false,0,true);
         this.cpHair.addEventListener("CHANGE",this.onColorSelect,false,0,true);
         this.cpSkin.addEventListener("ROLL_OVER",this.onItemRollOver,false,0,true);
         this.cpEye.addEventListener("ROLL_OVER",this.onItemRollOver,false,0,true);
         this.cpHair.addEventListener("ROLL_OVER",this.onItemRollOver,false,0,true);
         this.cpSkin.addEventListener("ROLL_OUT",this.onItemRollOut,false,0,true);
         this.cpEye.addEventListener("ROLL_OUT",this.onItemRollOut,false,0,true);
         this.cpHair.addEventListener("ROLL_OUT",this.onItemRollOut,false,0,true);
         this.cpSkin.selectedColor = this.avt.objData.intColorSkin;
         this.cpHair.selectedColor = this.avt.objData.intColorHair;
         this.cpEye.selectedColor = this.avt.objData.intColorEye;
         this.txtHair.text = this.avt.objData.strHairName;
         if(!getChildByName("mcColorSets") && Boolean(this.rootClass.litePreference.data.bColorSets))
         {
            this.mcSets = new colorSets(this.rootClass);
            this.mcSets.name = "mcColorSets";
            this.mcSets.mode = "mcCustomize";
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
