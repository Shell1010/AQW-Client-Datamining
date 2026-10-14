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

   [Embed(source="/_assets/assets.swf", symbol="symbol4052")]
   public dynamic class mcReport_389 extends MovieClip
   {

      public var bg:MovieClip;

      public var btnClose:SimpleButton;

      public var i0:MovieClip;

      public var i1:MovieClip;

      public var i2:MovieClip;

      public var i3:MovieClip;

      public var submit:MovieClip;

      public var tDesc:TextField;

      public var ti:TextField;

      public var iSel:*;

      public var mc:*;

      public var defaultDesc:String;

      public var tDetailTemplate:*;

      public var rootClass:MovieClip;

      public function mcReport_389()
      {
         super();
         addFrameScript(0,this.frame1,4,this.frame5,9,this.frame10,14,this.frame15,19,this.frame20);
      }

      public function itemClick(param1:MouseEvent) : *
      {
         this.iSel = int(MovieClip(param1.currentTarget).name.substr(1));
         var _loc1_:* = 0;
         while(_loc1_ < 4)
         {
            if(this.mc["i" + _loc1_] != null)
            {
               this.mc["i" + _loc1_].d.f1.visible = _loc1_ == this.iSel;
            }
            _loc1_++;
         }
         this.mc.submit.visible = true;
         if(this.tDetailTemplate.indexOf(this.tDesc.text) > -1 || this.tDesc.text == this.defaultDesc || this.tDesc.text == " " || this.tDesc.text == "")
         {
            this.tDesc.text = this.tDetailTemplate[this.iSel];
         }
      }

      public function submitClick(param1:MouseEvent) : *
      {
         var _loc1_:* = MovieClip(stage.getChildAt(0));
         var _loc2_:* = MovieClip(parent);
         var _loc3_:String = " ";
         if(this.tDesc.text.length > 3 && this.tDesc.text != this.defaultDesc)
         {
            _loc3_ = this.tDesc.text;
         }
         _loc1_.world.sendReport(["reportlang",_loc2_.fData.unm,this.iSel,_loc3_]);
         _loc2_.onClose(null);
      }

      public function onClose(param1:Event = null) : void
      {
         if(MovieClip(parent).currentLabel != "Init")
         {
            this.rootClass.mixer.playSound("Click");
            MovieClip(parent).gotoAndPlay("Init");
         }
      }

      internal function frame1() : *
      {
         this.iSel = -1;
         this.mc = MovieClip(this);
         this.defaultDesc = "Type reason for report here.";
         this.tDetailTemplate = [this.defaultDesc,this.defaultDesc,this.defaultDesc,this.defaultDesc];
         this.rootClass = stage.getChildAt(0) as MovieClip;
         gotoAndPlay("full");
      }

      internal function frame5() : *
      {
         this.i0.addEventListener(MouseEvent.CLICK,this.itemClick,false,0,true);
         this.i1.addEventListener(MouseEvent.CLICK,this.itemClick,false,0,true);
         this.i2.addEventListener(MouseEvent.CLICK,this.itemClick,false,0,true);
         this.i3.addEventListener(MouseEvent.CLICK,this.itemClick,false,0,true);
         this.submit.addEventListener(MouseEvent.CLICK,this.submitClick,false,0,true);
         this.btnClose.addEventListener(MouseEvent.CLICK,this.onClose,false,0,true);
         this.i0.buttonMode = true;
         this.i1.buttonMode = true;
         this.i2.buttonMode = true;
         this.i3.buttonMode = true;
         this.submit.buttonMode = true;
         this.i0.d.f1.visible = false;
         this.i1.d.f1.visible = false;
         this.i2.d.f1.visible = false;
         this.i3.d.f1.visible = false;
         this.submit.visible = false;
         this.ti.text = MovieClip(parent).fData.unm;
      }

      internal function frame10() : *
      {
         stop();
      }

      internal function frame15() : *
      {
         this.i1.addEventListener(MouseEvent.CLICK,this.itemClick,false,0,true);
         this.submit.addEventListener(MouseEvent.CLICK,this.submitClick,false,0,true);
         this.btnClose.addEventListener(MouseEvent.CLICK,this.onClose,false,0,true);
         this.i1.buttonMode = true;
         this.submit.buttonMode = true;
         this.i1.d.f1.visible = false;
         this.submit.visible = false;
         this.ti.text = MovieClip(parent).fData.unm;
      }

      internal function frame20() : *
      {
         stop();
      }
   }
}
