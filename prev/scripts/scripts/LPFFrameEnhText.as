package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.net.*;
   import flash.text.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol1983")]
   public class LPFFrameEnhText extends LPFFrame
   {

      public var mcStats:MovieClip;

      public var tDesc:TextField;

      private var iSel:Object;

      private var eSel:Object;

      private var iEnh:Object;

      private var eEnh:Object;

      private var rootClass:MovieClip;

      private var curItem:Object;

      private var mcHeader:Sprite;

      private var headerFullText:Object = {};

      private var headerTTIndex:int = 0;

      internal var mcContainer:MovieClip;

      internal var boostsObj:Object;

      public function LPFFrameEnhText()
      {
         super();
         this.mcStats.sproto.visible = false;
         this.tDesc.embedFonts = false;
         this.tDesc.defaultTextFormat = new TextFormat("Arial",12,14540253,null,null,null,null,null,null,null,null,null,2);
         this.tDesc.autoSize = TextFieldAutoSize.LEFT;
         this.mcHeader = new Sprite();
         addChild(this.mcHeader);
      }

      override public function fOpen(param1:Object) : void
      {
         this.rootClass = MovieClip(stage.getChildAt(0));
         positionBy(param1.r);
         this.iEnh = null;
         this.eEnh = null;
         if("eventTypes" in param1)
         {
            eventTypes = param1.eventTypes;
         }
         this.fDraw();
         getLayout().registerForEvents(this,eventTypes);
      }

      private function closeTip() : void
      {
         if(this.rootClass != null && this.rootClass.ui != null && this.rootClass.ui.ToolTip != null)
         {
            this.rootClass.ui.ToolTip.close();
         }
      }

      override public function fClose() : void
      {
         var _loc1_:DisplayObject = null;
         this.closeTip();
         while(this.mcStats.numChildren > 1)
         {
            _loc1_ = this.mcStats.getChildAt(1);
            this.mcStats.removeChildAt(1);
         }
         getLayout().unregisterFrame(this);
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }

      protected function fDraw() : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:Object = null;
         var _loc4_:String = null;
         var _loc5_:TextField = null;
         var _loc6_:TextField = null;
         var _loc7_:String = null;
         var _loc8_:TextField = null;
         var _loc9_:String = null;
         var _loc10_:TextField = null;
         var _loc11_:String = null;
         var _loc12_:TextField = null;
         var _loc13_:Boolean = false;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         var _loc23_:Object = null;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc26_:String = null;
         var _loc1_:String = "";
         var _loc27_:int = 0;
         var _loc28_:int = int(w) - 8;
         this.closeTip();
         while(this.mcHeader.numChildren > 0)
         {
            _loc2_ = this.mcHeader.getChildAt(0);
            _loc2_.removeEventListener(MouseEvent.MOUSE_OVER,this.onHeaderMouseOver);
            _loc2_.removeEventListener(MouseEvent.MOUSE_OUT,this.onHeaderMouseOut);
            this.mcHeader.removeChildAt(0);
         }
         this.headerFullText = {};
         this.mcHeader.x = 2;
         this.mcHeader.y = 3;
         this.tDesc.x = 2;
         this.tDesc.y = 7;
         if(this.iSel != null)
         {
            if(["Weapon","he","ar","ba"].indexOf(this.iSel.sES) > -1)
            {
               this.rootClass.world.initPatternTree();
               this.iEnh = null;
               this.eEnh = null;
               if(this.iSel.PatternID != null)
               {
                  this.iEnh = this.rootClass.world.enhPatternTree[this.iSel.PatternID];
               }
               if(this.iSel.EnhPatternID != null)
               {
                  this.iEnh = this.rootClass.world.enhPatternTree[this.iSel.EnhPatternID];
               }
               if(this.eSel != null)
               {
                  if(this.eSel.sES == this.iSel.sES)
                  {
                     if(this.eSel.PatternID != null)
                     {
                        this.eEnh = this.rootClass.world.enhPatternTree[this.eSel.PatternID];
                     }
                     if(this.eSel.EnhPatternID != null)
                     {
                        this.eEnh = this.rootClass.world.enhPatternTree[this.eSel.EnhPatternID];
                     }
                     _loc4_ = this.rootClass.getDisplayEnhName(this.eEnh);
                     if(this.eSel.iRty > 1)
                     {
                        _loc4_ += " +" + (this.eSel.iRty - 1);
                     }
                     if(Boolean(this.eEnh) && Boolean(this.eEnh.hasOwnProperty("DIS")) && Boolean(this.eEnh["DIS"]))
                     {
                        _loc4_ += ", " + this.rootClass.getDisplayEnhTraitName(this.eEnh);
                     }
                     if(this.iEnh != null)
                     {
                        if(this.iEnh.hasOwnProperty("DIS"))
                        {
                           _loc7_ = "Forge";
                        }
                        else
                        {
                           _loc7_ = this.iEnh.sName;
                        }
                        if(this.iSel.EnhRty > 1)
                        {
                           _loc7_ += " +" + (this.iSel.EnhRty - 1);
                        }
                        if(Boolean(this.iEnh.hasOwnProperty("DIS")) && Boolean(this.iEnh["DIS"]))
                        {
                           _loc7_ += ", " + this.rootClass.getDisplayEnhTraitName(this.iEnh);
                        }
                        _loc5_ = this.buildHeaderLine("Current: ",_loc7_,"#999999",0,_loc28_);
                     }
                     else
                     {
                        _loc5_ = this.buildHeaderLine("Current: ","No enhancement","#00CCFF",0,_loc28_);
                     }
                     _loc6_ = this.buildHeaderLine("New: ",_loc4_,this.getEnhNameColor(this.eEnh),_loc5_.y + _loc5_.height + 2,_loc28_);
                     _loc27_ = this.mcHeader.y + _loc6_.y + _loc6_.height;
                  }
                  else
                  {
                     _loc8_ = this.buildHeaderLine("Enhancement: ","Enhancement type must match item slot!","#00CCFF",0,_loc28_);
                     _loc27_ = this.mcHeader.y + _loc8_.y + _loc8_.height;
                  }
               }
               else if(this.iEnh != null)
               {
                  _loc9_ = this.rootClass.getDisplayEnhName(this.iEnh);
                  if("EnhRty" in this.iSel && this.iSel.EnhRty > 1)
                  {
                     _loc9_ += " +" + (this.iSel.EnhRty - 1);
                  }
                  else if("iRty" in this.iSel && this.iSel.iRty < 10 && this.iSel.iRty > 1)
                  {
                     _loc9_ += " +" + (this.iSel.iRty - 1);
                  }
                  if(Boolean(this.iSel.ProcID) && !this.iEnh.hasOwnProperty("DIS"))
                  {
                     switch(this.iSel.ProcID)
                     {
                        case 2:
                           _loc11_ = "Spiral Carve";
                           break;
                        case 3:
                           _loc11_ = "Awe Blast";
                           break;
                        case 4:
                           _loc11_ = "Health Vamp";
                           break;
                        case 5:
                           _loc11_ = "Mana Vamp";
                           break;
                        case 6:
                           _loc11_ = "Powerword DIE";
                           break;
                        case 7:
                           _loc11_ = "Lacerate";
                           break;
                        case 8:
                           _loc11_ = "Smite";
                           break;
                        case 9:
                           _loc11_ = "Valiance";
                           break;
                        case 10:
                           _loc11_ = "Arcana\'s Concerto";
                           break;
                        case 11:
                           _loc11_ = "Acheron";
                           break;
                        case 12:
                           _loc11_ = "Elysium";
                           break;
                        case 13:
                           _loc11_ = "Praxis";
                           break;
                        case 14:
                           _loc11_ = "Dauntless";
                           break;
                        case 15:
                           _loc11_ = "Ravenous";
                           break;
                        default:
                           _loc11_ = "Unknown";
                     }
                     _loc9_ += ", " + _loc11_;
                  }
                  else if(Boolean(this.iEnh.hasOwnProperty("DIS")) && Boolean(this.iEnh["DIS"]))
                  {
                     _loc9_ += ", " + this.rootClass.getDisplayEnhTraitName(this.iEnh);
                  }
                  _loc10_ = this.buildHeaderLine("Enhancement: ",_loc9_,this.getEnhNameColor(this.iEnh),0,_loc28_);
                  _loc27_ = this.mcHeader.y + _loc10_.y + _loc10_.height;
               }
               else
               {
                  _loc12_ = this.buildHeaderLine("Enhancement: ","No enhancement","#00CCFF",0,_loc28_);
                  _loc27_ = this.mcHeader.y + _loc12_.y + _loc12_.height;
               }
               _loc3_ = this.rootClass.copyObj(this.iSel);
               if(this.eSel != null)
               {
                  _loc3_ = this.rootClass.copyObj(this.eSel);
                  if(this.iSel != null)
                  {
                     _loc3_.sType = this.iSel.sType;
                     if("EnhRty" in this.iSel)
                     {
                        _loc3_.EnhRty = this.iSel.EnhRty;
                     }
                     if("iRng" in this.iSel)
                     {
                        _loc3_.iRng = this.iSel.iRng;
                     }
                     else
                     {
                        _loc3_.iRng = 10;
                     }
                  }
               }
               if(_loc3_.sES.toLowerCase() == "weapon")
               {
                  _loc13_ = _loc3_.sType.toLowerCase() == "enhancement";
                  if(_loc13_)
                  {
                     _loc14_ = Number(_loc3_.iDPS);
                  }
                  else if("EnhDPS" in _loc3_)
                  {
                     _loc14_ = Number(_loc3_.EnhDPS);
                  }
                  else if(this.eSel != null && "iDPS" in this.eSel)
                  {
                     _loc14_ = Number(this.eSel.iDPS);
                  }
                  else
                  {
                     _loc14_ = -1;
                  }
                  if(_loc14_ == 0)
                  {
                     _loc14_ = 100;
                  }
                  if(_loc14_ == -1)
                  {
                     _loc14_ = 100;
                  }
                  _loc14_ /= 100;
                  _loc15_ = "iRng" in _loc3_ ? Number(_loc3_.iRng) : 0;
                  _loc15_ = _loc15_ / 100;
                  _loc16_ = 0;
                  if("iRty" in _loc3_)
                  {
                     _loc16_ = _loc3_.iRty - 1;
                  }
                  if("EnhRty" in _loc3_)
                  {
                     _loc16_ = _loc3_.EnhRty - 1;
                  }
                  if(_loc13_)
                  {
                     _loc17_ = int(_loc3_.iLvl);
                  }
                  else if("EnhLvl" in _loc3_)
                  {
                     _loc17_ = int(_loc3_.EnhLvl);
                  }
                  else if(this.eSel != null && "iLvl" in this.eSel)
                  {
                     _loc17_ = int(this.eSel.iLvl);
                  }
                  else
                  {
                     _loc17_ = int(this.iSel.iLvl);
                  }
                  _loc18_ = int(this.rootClass.getBaseHPByLevel(_loc17_ + _loc16_));
                  _loc19_ = 20;
                  _loc20_ = 2;
                  _loc21_ = Math.round(_loc18_ / _loc19_ * _loc14_ * this.rootClass.PCDPSMod);
                  _loc22_ = Math.round(_loc21_ * _loc20_);
                  _loc23_ = this.rootClass.world.getAutoAttack();
                  _loc22_ *= _loc23_.damage;
                  _loc24_ = Math.floor(_loc22_ - _loc22_ * _loc15_);
                  _loc25_ = Math.ceil(_loc22_ + _loc22_ * _loc15_);
                  _loc26_ = "";
                  if(_loc3_.sType.toLowerCase() == "enhancement" || ("EnhLvl" in _loc3_ || this.eSel != null))
                  {
                     _loc26_ += _loc21_ + " DPS";
                  }
                  if(_loc3_.sType.toLowerCase() != "enhancement" && ("EnhLvl" in _loc3_ || this.eSel != null))
                  {
                     _loc26_ += " ( " + _loc24_ + "-" + _loc25_ + ", " + this.rootClass.numToStr(_loc23_.cd / 1000,1) + " speed )";
                  }
                  if(_loc26_ != "")
                  {
                     _loc1_ += "<font size=\'12\' color=\'#DDDDDD\'>" + _loc26_ + "</font>";
                  }
               }
            }
            else
            {
               _loc1_ = "<font size=\'12\' color=\'#BBBBBB\'>Enhancement: </font><font size=\'12\' color=\'#00CCFF\'>This item cannot be enhanced.</font>";
            }
            if(_loc27_ > 0)
            {
               this.tDesc.y = _loc27_ + 2;
            }
            this.tDesc.htmlText = _loc1_;
            this.showStats();
         }
         else
         {
            if(MovieClip(getLayout()).iSel != null && !this.rootClass.doIHaveEnhancements())
            {
               this.tDesc.htmlText = "<font size=\'12\' color=\'#FF0000\'>You need an Enhancement!</font><br>";
               this.tDesc.htmlText += "<font size=\'12\' color=\'#FFFFFF\'>No enhancments for this type of item were found in your backpack. Enhancements are used to power up your item. You can buy at shops or find them on monsters.</font>";
            }
            else
            {
               this.tDesc.htmlText = "No item selected.";
            }
            this.showStats();
         }
      }

      private function getEnhNameColor(param1:Object) : String
      {
         var _loc28_:ColorTransform = null;
         if(param1 != null && param1.hasOwnProperty("COLOR"))
         {
            _loc28_ = param1.COLOR as ColorTransform;
            if(_loc28_ != null)
            {
               return "#" + this.toHex2(int(_loc28_.redOffset)) + this.toHex2(int(_loc28_.greenOffset)) + this.toHex2(int(_loc28_.blueOffset));
            }
         }
         var _loc27_:String = param1 != null && param1.sDesc != null ? String(param1.sDesc) : "";
         switch(_loc27_)
         {
            case "M1":
               return "#FF6B6B";
            case "M2":
               return "#7CFC00";
            case "M3":
               return "#FFD24A";
            case "C1":
               return "#6FB7FF";
            case "C2":
               return "#FFFFFF";
            case "C3":
               return "#FFA64D";
            case "S1":
               return "#C792EA";
            default:
               return "#CCCCCC";
         }
      }

      private function toHex2(param1:int) : String
      {
         var _loc27_:String = (param1 & 0xFF).toString(16).toUpperCase();
         if(_loc27_.length < 2)
         {
            _loc27_ = "0" + _loc27_;
         }
         return _loc27_;
      }

      private function buildHeaderLine(param1:String, param2:String, param3:String, param4:int, param5:int) : TextField
      {
         var _loc4_:TextField = new TextField();
         _loc4_.embedFonts = false;
         _loc4_.selectable = false;
         _loc4_.multiline = false;
         _loc4_.wordWrap = false;
         _loc4_.autoSize = TextFieldAutoSize.LEFT;
         _loc4_.mouseEnabled = false;
         _loc4_.x = 0;
         _loc4_.y = param4;
         var _loc5_:* = 13;
         var _loc6_:String = param2;
         var _loc7_:String = param1 + param2;
         _loc4_.htmlText = "<font face=\'Arial\' size=\'" + _loc5_ + "\' color=\'#BBBBBB\'><b>" + param1 + "</b></font><font face=\'Arial\' size=\'" + _loc5_ + "\' color=\'" + param3 + "\'><b>" + _loc6_ + "</b></font>";
         while(_loc4_.textWidth > param5 && _loc5_ > 10)
         {
            _loc5_--;
            _loc4_.htmlText = "<font face=\'Arial\' size=\'" + _loc5_ + "\' color=\'#BBBBBB\'><b>" + param1 + "</b></font><font face=\'Arial\' size=\'" + _loc5_ + "\' color=\'" + param3 + "\'><b>" + _loc6_ + "</b></font>";
         }
         var _loc8_:Boolean = false;
         while(_loc4_.textWidth > param5 && _loc6_.length > 1)
         {
            _loc6_ = _loc6_.substr(0,_loc6_.length - 1);
            _loc8_ = true;
            _loc4_.htmlText = "<font face=\'Arial\' size=\'" + _loc5_ + "\' color=\'#BBBBBB\'><b>" + param1 + "</b></font><font face=\'Arial\' size=\'" + _loc5_ + "\' color=\'" + param3 + "\'><b>" + _loc6_ + "…</b></font>";
         }
         if(_loc8_)
         {
            _loc4_.mouseEnabled = true;
            _loc4_.name = "hdrTT" + this.headerTTIndex;
            this.headerFullText[_loc4_.name] = _loc7_;
            ++this.headerTTIndex;
            _loc4_.addEventListener(MouseEvent.MOUSE_OVER,this.onHeaderMouseOver,false,0,true);
            _loc4_.addEventListener(MouseEvent.MOUSE_OUT,this.onHeaderMouseOut,false,0,true);
         }
         this.mcHeader.addChild(_loc4_);
         return _loc4_;
      }

      private function onHeaderMouseOver(param1:MouseEvent) : void
      {
         var _loc27_:TextField = TextField(param1.currentTarget);
         this.rootClass.ui.ToolTip.openWith({"str":this.headerFullText[_loc27_.name]});
      }

      private function onHeaderMouseOut(param1:MouseEvent) : void
      {
         this.rootClass.ui.ToolTip.close();
      }

      override public function notify(param1:Object) : void
      {
         if(param1.eventType != "showItemListB")
         {
            if(param1.eventType == "refreshItems")
            {
               if(this.iSel != param1.fData.iSel && this.iSel != param1.fData.eSel)
               {
                  this.iSel = null;
                  this.eSel = null;
               }
            }
            else if(param1.eventType == "clearState")
            {
               this.iSel = null;
               this.eSel = null;
            }
            else
            {
               this.iSel = param1.fData.iSel;
               this.eSel = param1.fData.eSel;
               if(this.iSel == null && this.eSel != null)
               {
                  this.iSel = this.eSel;
                  this.eSel = null;
               }
            }
         }
         this.fDraw();
      }

      private function showStats() : void
      {
         var _loc27_:Object = null;
         var _loc28_:Object = null;
         var _loc7_:Object = null;
         var _loc13_:Sprite = null;
         var _loc14_:TextField = null;
         var _loc15_:TextField = null;
         var _loc16_:TextField = null;
         var _loc17_:TextField = null;
         var _loc24_:TextField = null;
         var _loc25_:Boolean = false;
         var _loc26_:Array = null;
         var _loc29_:MovieClip = null;
         var _loc30_:String = null;
         var _loc31_:* = undefined;
         var _loc32_:int = 0;
         var _loc33_:* = undefined;
         var _loc34_:String = null;
         var _loc35_:MovieClip = null;
         var _loc36_:MovieClip = null;
         var _loc37_:MovieClip = null;
         var _loc38_:MovieClip = null;
         var _loc39_:MovieClip = null;
         var _loc40_:MovieClip = null;
         this.closeTip();
         while(this.mcStats.numChildren > 1)
         {
            this.mcStats.removeChildAt(1);
         }
         var _loc1_:Boolean = this.eSel != null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = "";
         var _loc8_:int = int(w / 3);
         var _loc9_:int = 20;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc18_:uint = 0;
         var _loc19_:* = 0;
         var _loc20_:* = 0;
         var _loc21_:* = 0;
         var _loc22_:* = 0;
         var _loc23_:int = 0;
         this.mcStats.x = 2;
         if(this.tDesc.text.length > 0)
         {
            this.mcStats.y = int(this.tDesc.y + this.tDesc.height + 3);
         }
         else
         {
            this.mcStats.y = int(this.tDesc.y);
         }
         if(this.iSel != null && ((this.iEnh != null || this.eEnh != null) && (this.eSel == null || this.eSel.sES == this.iSel.sES) || _loc1_ && this.eSel.sES == this.iSel.sES))
         {
            if(_loc1_ && this.iEnh != null)
            {
               _loc27_ = this.rootClass.getStatsA(this.eSel,this.iSel.sES);
               _loc28_ = this.rootClass.getStatsA(this.iSel,this.iSel.sES);
            }
            else
            {
               _loc7_ = this.rootClass.copyObj(this.iSel);
               if(_loc1_)
               {
                  _loc7_.EnhPatternID = this.eSel.PatternID;
                  _loc7_.EnhLvl = this.eSel.iLvl;
                  _loc7_.EnhRty = this.eSel.iRty;
                  _loc1_ = false;
               }
               _loc27_ = this.rootClass.getStatsA(_loc7_,this.iSel.sES);
            }
            _loc2_ = 0;
            while(_loc2_ < this.rootClass.orderedStats.length)
            {
               _loc6_ = this.rootClass.orderedStats[_loc2_];
               _loc5_ = 0;
               if(_loc1_ && _loc28_["$" + _loc6_] != null && _loc27_["$" + _loc6_] == null)
               {
                  _loc27_["$" + _loc6_] = 0;
               }
               if(_loc27_["$" + _loc6_] != null)
               {
                  _loc4_ = int(_loc27_["$" + _loc6_]);
                  _loc13_ = new Sprite();
                  if(_loc1_ && _loc28_["$" + _loc6_] != null)
                  {
                     _loc5_ = int(_loc28_["$" + _loc6_]);
                  }
                  else
                  {
                     _loc5_ = 0;
                  }
                  if(_loc1_)
                  {
                     _loc12_ = _loc4_ - _loc5_;
                     _loc10_ += _loc4_;
                     _loc11_ += _loc5_;
                     _loc18_ = _loc12_ > 0 ? 8190976 : (_loc12_ < 0 ? 16733525 : 16777215);
                  }
                  else
                  {
                     _loc18_ = 16777215;
                  }
                  _loc19_ = 11;
                  _loc20_ = 13;
                  _loc21_ = 12;
                  _loc22_ = 14;
                  _loc14_ = new TextField();
                  _loc14_.autoSize = TextFieldAutoSize.LEFT;
                  _loc14_.embedFonts = false;
                  _loc14_.selectable = false;
                  _loc14_.mouseEnabled = false;
                  _loc14_.defaultTextFormat = new TextFormat("Arial",_loc19_,10066329,true);
                  _loc14_.text = _loc6_.toUpperCase();
                  _loc14_.x = 0;
                  _loc14_.y = 3;
                  _loc13_.addChild(_loc14_);
                  _loc15_ = new TextField();
                  _loc15_.autoSize = TextFieldAutoSize.LEFT;
                  _loc15_.embedFonts = false;
                  _loc15_.selectable = false;
                  _loc15_.mouseEnabled = false;
                  _loc15_.y = 0;
                  _loc15_.defaultTextFormat = new TextFormat("Arial",_loc22_,_loc18_,true);
                  _loc15_.text = String(_loc4_);
                  if(_loc1_)
                  {
                     _loc16_ = new TextField();
                     _loc16_.autoSize = TextFieldAutoSize.LEFT;
                     _loc16_.embedFonts = false;
                     _loc16_.selectable = false;
                     _loc16_.mouseEnabled = false;
                     _loc16_.defaultTextFormat = new TextFormat("Arial",_loc20_,11184810);
                     _loc16_.text = String(_loc5_);
                     _loc17_ = new TextField();
                     _loc17_.autoSize = TextFieldAutoSize.LEFT;
                     _loc17_.embedFonts = false;
                     _loc17_.selectable = false;
                     _loc17_.mouseEnabled = false;
                     _loc17_.defaultTextFormat = new TextFormat("Arial",_loc21_,7829367);
                     _loc17_.text = " → ";
                     _loc16_.x = _loc14_.x + _loc14_.textWidth + 3;
                     _loc16_.y = _loc15_.y + (_loc15_.height - _loc16_.height);
                     _loc17_.x = _loc16_.x + _loc16_.textWidth;
                     _loc17_.y = _loc15_.y + (_loc15_.height - _loc17_.height);
                     _loc15_.x = _loc17_.x + _loc17_.textWidth;
                     _loc23_ = _loc8_ - 4;
                     while(_loc15_.x + _loc15_.textWidth > _loc23_ && (_loc19_ > 10 || _loc20_ > 10 || _loc21_ > 10 || _loc22_ > 10))
                     {
                        if(_loc19_ > 10)
                        {
                           _loc19_--;
                        }
                        if(_loc20_ > 10)
                        {
                           _loc20_--;
                        }
                        if(_loc21_ > 10)
                        {
                           _loc21_--;
                        }
                        if(_loc22_ > 10)
                        {
                           _loc22_--;
                        }
                        _loc14_.setTextFormat(new TextFormat("Arial",_loc19_,10066329,true));
                        _loc16_.setTextFormat(new TextFormat("Arial",_loc20_,11184810));
                        _loc17_.setTextFormat(new TextFormat("Arial",_loc21_,7829367));
                        _loc15_.setTextFormat(new TextFormat("Arial",_loc22_,_loc18_,true));
                        _loc16_.x = _loc14_.x + _loc14_.textWidth + 3;
                        _loc16_.y = _loc15_.y + (_loc15_.height - _loc16_.height);
                        _loc17_.x = _loc16_.x + _loc16_.textWidth;
                        _loc17_.y = _loc15_.y + (_loc15_.height - _loc17_.height);
                        _loc15_.x = _loc17_.x + _loc17_.textWidth;
                     }
                     _loc13_.addChild(_loc16_);
                     _loc13_.addChild(_loc17_);
                  }
                  else
                  {
                     _loc15_.x = 30;
                  }
                  _loc13_.addChild(_loc15_);
                  _loc13_.x = _loc3_ % 3 * _loc8_;
                  _loc13_.y = Math.floor(_loc3_ / 3) * _loc9_;
                  _loc13_.name = "t" + _loc6_;
                  this.mcStats.addChild(_loc13_);
                  _loc3_++;
               }
               _loc2_++;
            }
            if(_loc1_)
            {
               _loc12_ = _loc10_ - _loc11_;
               _loc24_ = new TextField();
               _loc24_.autoSize = TextFieldAutoSize.LEFT;
               _loc24_.embedFonts = false;
               _loc24_.selectable = false;
               _loc24_.mouseEnabled = false;
               _loc24_.defaultTextFormat = new TextFormat("Arial",12,_loc12_ > 0 ? 8190976 : (_loc12_ < 0 ? 16733525 : 16777215),true);
               _loc24_.text = "Total change: " + (_loc12_ >= 0 ? "+" : "") + _loc12_;
               _loc24_.x = 0;
               _loc24_.y = 2 * _loc9_;
               _loc24_.name = "tTotalChange";
               this.mcStats.addChild(_loc24_);
            }
            this.mcStats.visible = true;
         }
         else
         {
            this.mcStats.visible = false;
         }
         if(Boolean(this.mcContainer) && Boolean(getChildByName("mcContainer")))
         {
            removeChild(getChildByName("mcContainer"));
         }
         if(Boolean(this.mcContainer) && Boolean(this.mcStats.getChildByName("mcContainer")))
         {
            this.mcStats.removeChild(this.mcStats.getChildByName("mcContainer"));
         }
         if(this.iSel != null && this.iSel.sMeta != null && !(this.iSel.sMeta is Number) && this.iSel.sMeta.indexOf(":") > -1)
         {
            _loc25_ = false;
            switch(this.iSel.sES)
            {
               case "he":
               case "ba":
               case "Weapon":
               case "pe":
               case "co":
               case "mi":
                  _loc25_ = true;
            }
            if(!_loc25_)
            {
               return;
            }
            this.boostsObj = {};
            this.mcContainer = new boostsContainer();
            this.iEnh = null;
            if(this.iSel.PatternID != null)
            {
               this.iEnh = this.rootClass.world.enhPatternTree[this.iSel.PatternID];
            }
            if(this.iSel.EnhPatternID != null)
            {
               this.iEnh = this.rootClass.world.enhPatternTree[this.iSel.EnhPatternID];
            }
            if(this.iEnh)
            {
               this.mcStats.addChild(this.mcContainer);
               this.mcContainer.name = "mcContainer";
               this.mcContainer.x = -13;
               this.mcContainer.y = this.mcStats.height - 8;
            }
            else
            {
               addChild(this.mcContainer);
               this.mcContainer.name = "mcContainer";
               this.mcContainer.x = -2;
               this.mcContainer.y = 20;
            }
            while(this.mcContainer.numChildren > 0)
            {
               this.mcContainer.removeChildAt(0);
            }
            _loc26_ = this.iSel.sMeta.split(",");
            _loc29_ = new damageBoost();
            if(!this.boostsObj["dmgBoost"])
            {
               this.boostsObj["dmgBoost"] = "";
            }
            for each(_loc31_ in _loc26_)
            {
               _loc34_ = _loc31_.split(":")[1];
               _loc30_ = Math.round((Number(_loc34_) - 1) * 100).toString();
               switch(_loc31_.split(":")[0].toLowerCase())
               {
                  case "dmgall":
                     this.boostsObj["dmgBoost"] += "All +" + _loc30_ + "%\n";
                     break;
                  case "undead":
                     this.boostsObj["dmgBoost"] += "Undead +" + _loc30_ + "%\n";
                     break;
                  case "human":
                     this.boostsObj["dmgBoost"] += "Human +" + _loc30_ + "%\n";
                     break;
                  case "chaos":
                     this.boostsObj["dmgBoost"] += "Chaos +" + _loc30_ + "%\n";
                     break;
                  case "dragonkin":
                     this.boostsObj["dmgBoost"] += "Dragonkin +" + _loc30_ + "%\n";
                     break;
                  case "orc":
                     this.boostsObj["dmgBoost"] += "Orc +" + _loc30_ + "%\n";
                     break;
                  case "drakath":
                     this.boostsObj["dmgBoost"] += "Drakath +" + _loc30_ + "%\n";
                     break;
                  case "elemental":
                     this.boostsObj["dmgBoost"] += "Elemental +" + _loc30_ + "%\n";
                     break;
                  case "cp":
                     this.boostsObj["classBoost"] = "Class Points +" + _loc30_ + "%";
                     break;
                  case "gold":
                     this.boostsObj["goldBoost"] = "Gold +" + _loc30_ + "%";
                     break;
                  case "rep":
                     this.boostsObj["repBoost"] = "Reputation +" + _loc30_ + "%";
                     break;
                  case "exp":
                     this.boostsObj["xpBoost"] = "Experience +" + _loc30_ + "%";
               }
            }
            _loc32_ = 30;
            for(_loc33_ in this.boostsObj)
            {
               switch(_loc33_)
               {
                  case "dmgBoost":
                     if(this.boostsObj[_loc33_] != "")
                     {
                        this.mcContainer.addChild(_loc29_);
                        _loc29_.width = _loc32_;
                        _loc29_.height = _loc32_;
                        _loc29_.name = "dmgBoost";
                        _loc29_.addEventListener(MouseEvent.MOUSE_OVER,this.onBoostGet,false,0,true);
                        _loc29_.addEventListener(MouseEvent.MOUSE_OUT,this.onBoostOut,false,0,true);
                     }
                     break;
                  case "classBoost":
                     _loc35_ = new classBoost();
                     this.mcContainer.addChild(_loc35_);
                     _loc35_.width = _loc32_;
                     _loc35_.height = _loc32_;
                     _loc35_.name = "classBoost";
                     _loc35_.addEventListener(MouseEvent.MOUSE_OVER,this.onBoostGet,false,0,true);
                     _loc35_.addEventListener(MouseEvent.MOUSE_OUT,this.onBoostOut,false,0,true);
                     break;
                  case "goldBoost":
                     _loc36_ = new goldBoost();
                     this.mcContainer.addChild(_loc36_);
                     _loc36_.width = _loc32_;
                     _loc36_.height = _loc32_;
                     _loc36_.name = "goldBoost";
                     _loc36_.addEventListener(MouseEvent.MOUSE_OVER,this.onBoostGet,false,0,true);
                     _loc36_.addEventListener(MouseEvent.MOUSE_OUT,this.onBoostOut,false,0,true);
                     break;
                  case "repBoost":
                     _loc37_ = new repBoost();
                     this.mcContainer.addChild(_loc37_);
                     _loc37_.width = _loc32_;
                     _loc37_.height = _loc32_;
                     _loc37_.name = "repBoost";
                     _loc37_.addEventListener(MouseEvent.MOUSE_OVER,this.onBoostGet,false,0,true);
                     _loc37_.addEventListener(MouseEvent.MOUSE_OUT,this.onBoostOut,false,0,true);
                     break;
                  case "xpBoost":
                     _loc38_ = new xpBoost();
                     this.mcContainer.addChild(_loc38_);
                     _loc38_.width = _loc32_;
                     _loc38_.height = _loc32_;
                     _loc38_.name = "xpBoost";
                     _loc38_.addEventListener(MouseEvent.MOUSE_OVER,this.onBoostGet,false,0,true);
                     _loc38_.addEventListener(MouseEvent.MOUSE_OUT,this.onBoostOut,false,0,true);
               }
            }
            _loc2_ = 0;
            while(_loc2_ < this.mcContainer.numChildren)
            {
               _loc39_ = this.mcContainer.getChildAt(_loc2_) as MovieClip;
               _loc39_.x = _loc2_ * _loc39_.width + 2;
               _loc2_++;
            }
            if(this.mcContainer.numChildren > 0)
            {
               _loc40_ = new btnMoreInfo();
               _loc40_.addEventListener(MouseEvent.CLICK,this.onBoostsInfo,false,0,true);
               this.mcContainer.addChild(_loc40_);
               _loc40_.x = this.mcContainer.getChildAt(this.mcContainer.numChildren - 2).x + this.mcContainer.getChildAt(this.mcContainer.numChildren - 2).width + 3;
               _loc40_.y = _loc40_.height / 4 + 2;
            }
         }
      }

      private function onBoostsInfo(param1:MouseEvent) : void
      {
         navigateToURL(new URLRequest("https://www.aq.com/lore/Guides/AQWBoosts"),"_blank");
      }

      private function onBoostGet(param1:MouseEvent) : void
      {
         var _loc27_:String = param1.currentTarget.name;
         this.rootClass.ui.ToolTip.openWith({"str":this.boostsObj[_loc27_]});
      }

      private function onBoostOut(param1:MouseEvent) : void
      {
         this.rootClass.ui.ToolTip.close();
      }

      private function onTTFieldMouseOver(param1:MouseEvent) : void
      {
         var _loc27_:String = param1.currentTarget.name;
         var _loc28_:String = "";
         switch(_loc27_)
         {
            case "tAP":
               _loc28_ = "Attack Power increases the effectiveness of your physical damage attacks.";
               break;
            case "tSP":
               _loc28_ = "Magic Power increases the effectiveness of your magical damage attacks.";
               break;
            case "tDmg":
               _loc28_ = "This is the damage you would expect to see on a normal melee hit, before any other modifiers.";
               break;
            case "tHP":
               _loc28_ = "Your total Hit Points.  When these reach zero, you will need to wait a short time before being able to continue playing.";
               break;
            case "tHitTF":
               _loc28_ = "Hit chance determines how likely you are to hit a target, before any other modifiers.";
               break;
            case "tHasteTF":
               _loc28_ = "Haste reduces the cooldown on all of your attacks and spells, including Auto Attack, by a certain percentage (hard capped at 50%).";
               break;
            case "tCritTF":
               _loc28_ = "Critical Strike chance increases the likelihood of dealing additional damage on a any attack.";
               break;
            case "tDodgeTF":
               _loc28_ = "Evasion chance allows you to completely avoid incoming damage.";
               break;
            case "tSTR":
            case "sl1":
               _loc28_ = "Strength increases Attack Power, which boosts physical damage. It also improves Critical Strike chance for melee classes.";
               break;
            case "tINT":
            case "sl2":
               _loc28_ = "Intellect increases Magic Power, which boosts magical damage. It also improve Critical Strike chance for caster classes.";
               break;
            case "tEND":
            case "sl3":
               _loc28_ = "Endurance directly contributes to your total Hit Points.  While very useful for all classes, some abilities work best with very high or very low total HP.";
               break;
            case "tDEX":
            case "sl4":
               _loc28_ = "Dexterity is valuable to melee classes. It increases Haste, Hit chance, and Evasion chance. It increases only Evasion chance for caster classes.";
               break;
            case "tWIS":
            case "sl5":
               _loc28_ = "Wisdom is valuable to caster classes. It increases Hit chance, Crit chance, and Evasion chance. It improves only Evasion chance for melee classes.";
               break;
            case "tLCK":
            case "sl6":
               _loc28_ = "Luck increases your Critical Strike modifier value directly, and may have effects outside of combat.";
         }
         this.rootClass.ui.ToolTip.openWith({"str":_loc28_});
      }

      private function onTTFieldMouseOut(param1:MouseEvent) : void
      {
         this.rootClass.ui.ToolTip.close();
      }
   }
}
