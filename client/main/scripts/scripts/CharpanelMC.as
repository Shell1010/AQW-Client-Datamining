package
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol2599")]
   public class CharpanelMC extends MovieClip
   {

      public var bg:MovieClip;

      public var cnt:MovieClip;

      private var rootClass:MovieClip = stage.getChildAt(0) as MovieClip;

      private var world:MovieClip;

      private var mcPopup:MovieClip;

      private var nextMode:String;

      private var uoLeaf:Object;

      private var uoData:Object;

      private var sta:Object;

      private var stp:Object = new Object();

      private var stu:Object = new Object();

      private var stg:Object = new Object();

      private var pts:int = -1;

      private var upts:int = -1;

      private var spendStuC:Array = [1595286,1470895,1410498,1349844,1289447,1229821];

      private var spendStpC:Array = [15098368,15432448,15764992,16032000,16364544,16763904];

      private var barVal:int = 150;

      private var spendStat:String = "none";

      private var spendOp:String = "";

      private var spendTicks:int = 0;

      private var spendVals:Array = [{
         "a":0,
         "b":1
      },{
         "a":30,
         "b":3
      },{
         "a":60,
         "b":9
      }];

      private var ttFields:Array = [];

      public function CharpanelMC()
      {
         this.world = this.rootClass.world as MovieClip;
         this.mcPopup = this.rootClass.ui.mcPopup;
         this.uoLeaf = this.world.myLeaf();
         this.uoData = this.world.myAvatar.objData;
         this.sta = this.uoLeaf.sta;
         super();
         addFrameScript(0,this.frame1,4,this.frame5,11,this.frame12,24,this.frame25);
         this.bg.x = 0;
         this.bg.btnClose.addEventListener(MouseEvent.MOUSE_DOWN,this.btnCloseClick,false,0,true);
         this.bg.tTitle.text = "Class Overview";
      }

      public function openWith(param1:Object) : void
      {
         this.nextMode = param1.typ;
         if(this.isValidMode(this.nextMode))
         {
            if(this.currentLabel != "init" && this.currentLabel.indexOf("-out") < 0)
            {
               this.gotoAndPlay(this.currentLabel + "-out");
            }
            else
            {
               this.gotoAndPlay(this.nextMode);
            }
         }
      }

      public function fClose() : void
      {
         var _loc1_:Array = null;
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         if(MovieClip(this).currentLabel.indexOf("overview") > -1)
         {
            try
            {
               _loc1_ = [this.cnt.abilities.a1,this.cnt.abilities.a2,this.cnt.abilities.a3,this.cnt.abilities.a4,this.cnt.abilities.p1,this.cnt.abilities.p2];
               for each(_loc3_ in _loc1_)
               {
                  _loc3_.removeEventListener(MouseEvent.MOUSE_OVER,this.rootClass.actIconOver);
                  _loc3_.removeEventListener(MouseEvent.MOUSE_OUT,this.rootClass.actIconOut);
                  _loc3_.actObj = null;
               }
            }
            catch(e:Error)
            {
            }
         }
         this.bg.btnClose.removeEventListener(MouseEvent.MOUSE_DOWN,this.btnCloseClick);
         if(parent != null)
         {
            _loc4_ = MovieClip(parent);
            _loc4_.removeChild(this);
            _loc4_.onClose();
            this.rootClass.stage.focus = null;
         }
      }

      private function playNextMode() : void
      {
         this.gotoAndPlay(this.nextMode);
      }

      private function isValidMode(param1:String) : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         while(_loc2_ < this.currentLabels.length && !_loc1_)
         {
            if(this.currentLabels[_loc2_].name == param1)
            {
               _loc1_ = true;
            }
            _loc2_++;
         }
         return _loc1_;
      }

      private function update() : void
      {
         if(MovieClip(this).currentLabel.indexOf("overview") > -1)
         {
            this.updateNext();
         }
      }

      private function updateNext() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:MovieClip = MovieClip(this).cnt;
         var _loc5_:Object = {};
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:String = "";
         var _loc9_:Boolean = false;
         _loc4_.tDesc.autoSize = "left";
         _loc4_.tMana.autoSize = "left";
         _loc4_.tClass.text = this.uoData.strClassName + "  (Rank " + this.uoData.iRank + ")";
         _loc4_.tDesc.text = this.uoData.sClassDesc;
         _loc4_.tMana.text = "";
         for each(_loc8_ in this.uoData.aClassMRM)
         {
            if(_loc8_.charAt(0) == "-")
            {
               _loc4_.tMana.text += " * " + _loc8_.substr(1);
            }
            else
            {
               _loc4_.tMana.text += _loc8_;
            }
         }
         _loc4_.tManaHeader.y = Math.round(_loc4_.tDesc.y + _loc4_.tDesc.height + 5);
         _loc4_.tMana.y = Math.round(_loc4_.tManaHeader.y + _loc4_.tManaHeader.height + 2);
         _loc6_ = Math.round(_loc4_.tMana.y + _loc4_.tMana.height);
         _loc4_.abilities.y = Math.round(_loc6_ + (188 - _loc6_) / 2);
         if(_loc4_.abilities.y > 188)
         {
            _loc4_.abilities.y = 188;
         }
         var _loc10_:* = ["aa","a1","a2","a3","a4","p1","p2","p3"];
         _loc6_ = 0;
         while(_loc6_ < _loc10_.length)
         {
            _loc5_ = _loc10_[_loc6_];
            if(_loc5_ == "p3" && this.world.actions.passive.length < 3)
            {
               _loc4_.abilities.x = 46;
               _loc4_.abilities.getChildByName("tRank6").visible = false;
               _loc4_.abilities.getChildByName("p3").visible = false;
            }
            else
            {
               _loc1_ = _loc4_.abilities.getChildByName(_loc5_) as MovieClip;
               _loc1_.actionIndex = _loc6_;
               _loc2_ = this.rootClass.world.getActionByRef(_loc5_);
               if(_loc2_ == null)
               {
                  _loc1_.visible = false;
               }
               else
               {
                  _loc1_.visible = true;
                  _loc1_.tQty.visible = false;
                  this.rootClass.updateIcons([_loc1_],_loc2_.icon.split(","),null);
                  if(!_loc2_.isOK)
                  {
                     _loc1_.alpha = 0.33;
                  }
                  _loc1_.actObj = _loc2_;
                  _loc1_.addEventListener(MouseEvent.MOUSE_OVER,this.rootClass.actIconOver,false,0,true);
                  _loc1_.addEventListener(MouseEvent.MOUSE_OUT,this.rootClass.actIconOut,false,0,true);
               }
            }
            _loc6_++;
         }
         var _loc11_:Graphics = _loc4_.abilities.bg.graphics;
         _loc11_.clear();
         _loc11_.lineStyle(0,0,0);
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:Number = 6710886;
         var _loc15_:String = "#FFFFFF";
         var _loc16_:int = this.world.actions.passive.length < 3 ? 6 : 7;
         _loc12_ = 0;
         while(_loc12_ < _loc16_)
         {
            _loc13_ = _loc12_ * 51;
            _loc14_ = 6710886;
            _loc15_ = "#FFFFFF";
            if(this.uoData.iRank < _loc12_ + 1)
            {
               _loc14_ = 2368548;
               _loc15_ = "#999999";
               _loc11_.beginFill(_loc14_);
               _loc11_.moveTo(_loc13_,19);
               _loc11_.lineTo(_loc13_ + 50,19);
               _loc11_.lineTo(_loc13_ + 50,127);
               _loc11_.lineTo(_loc13_,127);
               _loc11_.lineTo(_loc13_,19);
               _loc11_.endFill();
            }
            _loc11_.beginFill(_loc14_);
            _loc11_.moveTo(_loc13_,0);
            _loc11_.lineTo(_loc13_ + 50,0);
            _loc11_.lineTo(_loc13_ + 50,18);
            _loc11_.lineTo(_loc13_,18);
            _loc11_.lineTo(_loc13_,0);
            _loc11_.endFill();
            _loc11_.beginFill(_loc14_);
            _loc11_.moveTo(_loc13_,128);
            _loc11_.lineTo(_loc13_ + 50,128);
            _loc11_.lineTo(_loc13_ + 50,132);
            _loc11_.lineTo(_loc13_,132);
            _loc11_.lineTo(_loc13_,128);
            _loc11_.endFill();
            _loc3_ = _loc4_.abilities.getChildByName("tRank" + (_loc12_ + 1));
            if(_loc3_ != null)
            {
               TextField(_loc3_).htmlText = "<font color=\'" + _loc15_ + "\'>" + TextField(_loc3_).text + "</font>";
            }
            _loc12_++;
         }
      }

      private function btnCloseClick(param1:MouseEvent) : void
      {
         this.fClose();
      }

      internal function frame1() : *
      {
         this.openWith(MovieClip(parent).fData);
      }

      internal function frame5() : *
      {
         this.update();
      }

      internal function frame12() : *
      {
         stop();
      }

      internal function frame25() : *
      {
         this.playNextMode();
      }
   }
}
