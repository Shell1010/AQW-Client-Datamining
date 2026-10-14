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
         var _loc1_:DisplayObject = null;
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc4_:TextField = null;
         var _loc5_:TextField = null;
         var _loc6_:String = null;
         var _loc7_:TextField = null;
         var _loc8_:String = null;
         var _loc9_:TextField = null;
         var _loc10_:String = null;
         var _loc11_:TextField = null;
         var _loc12_:Boolean = false;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:Object = null;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         var _loc25_:String = null;
         var _loc26_:String = "";
         var _loc27_:int = 0;
         var _loc28_:int = int(w) - 8;
         this.closeTip();
         while(this.mcHeader.numChildren > 0)
         {
            _loc1_ = this.mcHeader.getChildAt(0);
            _loc1_.removeEventListener(MouseEvent.MOUSE_OVER,this.onHeaderMouseOver);
            _loc1_.removeEventListener(MouseEvent.MOUSE_OUT,this.onHeaderMouseOut);
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
                     _loc3_ = this.rootClass.getDisplayEnhName(this.eEnh);
                     if(this.eSel.iRty > 1)
                     {
                        _loc3_ += " +" + (this.eSel.iRty - 1);
                     }
                     if(Boolean(this.eEnh) && Boolean(this.eEnh.hasOwnProperty("DIS")) && Boolean(this.eEnh["DIS"]))
                     {
                        _loc3_ += ", " + this.rootClass.getDisplayEnhTraitName(this.eEnh);
                     }
                     if(this.iEnh != null)
                     {
                        if(this.iEnh.hasOwnProperty("DIS"))
                        {
                           _loc6_ = "Forge";
                        }
                        else
                        {
                           _loc6_ = this.iEnh.sName;
                        }
                        if(this.iSel.EnhRty > 1)
                        {
                           _loc6_ += " +" + (this.iSel.EnhRty - 1);
                        }
                        if(Boolean(this.iEnh.hasOwnProperty("DIS")) && Boolean(this.iEnh["DIS"]))
                        {
                           _loc6_ += ", " + this.rootClass.getDisplayEnhTraitName(this.iEnh);
                        }
                        _loc4_ = this.buildHeaderLine("Current: ",_loc6_,"#999999",0,_loc28_);
                     }
                     else
                     {
                        _loc4_ = this.buildHeaderLine("Current: ","No enhancement","#00CCFF",0,_loc28_);
                     }
                     _loc5_ = this.buildHeaderLine("New: ",_loc3_,this.getEnhNameColor(this.eEnh),_loc4_.y + _loc4_.height + 2,_loc28_);
                     _loc27_ = this.mcHeader.y + _loc5_.y + _loc5_.height;
                  }
                  else
                  {
                     _loc7_ = this.buildHeaderLine("Enhancement: ","Enhancement type must match item slot!","#00CCFF",0,_loc28_);
                     _loc27_ = this.mcHeader.y + _loc7_.y + _loc7_.height;
                  }
               }
               else if(this.iEnh != null)
               {
                  _loc8_ = this.rootClass.getDisplayEnhName(this.iEnh);
                  if("EnhRty" in this.iSel && this.iSel.EnhRty > 1)
                  {
                     _loc8_ += " +" + (this.iSel.EnhRty - 1);
                  }
                  else if("iRty" in this.iSel && this.iSel.iRty < 10 && this.iSel.iRty > 1)
                  {
                     _loc8_ += " +" + (this.iSel.iRty - 1);
                  }
                  if(Boolean(this.iSel.ProcID) && !this.iEnh.hasOwnProperty("DIS"))
                  {
                     switch(this.iSel.ProcID)
                     {
                        case 2:
                           _loc10_ = "Spiral Carve";
                           break;
                        case 3:
                           _loc10_ = "Awe Blast";
                           break;
                        case 4:
                           _loc10_ = "Health Vamp";
                           break;
                        case 5:
                           _loc10_ = "Mana Vamp";
                           break;
                        case 6:
                           _loc10_ = "Powerword DIE";
                           break;
                        case 7:
                           _loc10_ = "Lacerate";
                           break;
                        case 8:
                           _loc10_ = "Smite";
                           break;
                        case 9:
                           _loc10_ = "Valiance";
                           break;
                        case 10:
                           _loc10_ = "Arcana\'s Concerto";
                           break;
                        case 11:
                           _loc10_ = "Acheron";
                           break;
                        case 12:
                           _loc10_ = "Elysium";
                           break;
                        case 13:
                           _loc10_ = "Praxis";
                           break;
                        case 14:
                           _loc10_ = "Dauntless";
                           break;
                        case 15:
                           _loc10_ = "Ravenous";
                           break;
                        default:
                           _loc10_ = "Unknown";
                     }
                     _loc8_ += ", " + _loc10_;
                  }
                  else if(Boolean(this.iEnh.hasOwnProperty("DIS")) && Boolean(this.iEnh["DIS"]))
                  {
                     _loc8_ += ", " + this.rootClass.getDisplayEnhTraitName(this.iEnh);
                  }
                  _loc9_ = this.buildHeaderLine("Enhancement: ",_loc8_,this.getEnhNameColor(this.iEnh),0,_loc28_);
                  _loc27_ = this.mcHeader.y + _loc9_.y + _loc9_.height;
               }
               else
               {
                  _loc11_ = this.buildHeaderLine("Enhancement: ","No enhancement","#00CCFF",0,_loc28_);
                  _loc27_ = this.mcHeader.y + _loc11_.y + _loc11_.height;
               }
               _loc2_ = this.rootClass.copyObj(this.iSel);
               if(this.eSel != null)
               {
                  _loc2_ = this.rootClass.copyObj(this.eSel);
                  if(this.iSel != null)
                  {
                     _loc2_.sType = this.iSel.sType;
                     if("EnhRty" in this.iSel)
                     {
                        _loc2_.EnhRty = this.iSel.EnhRty;
                     }
                     if("iRng" in this.iSel)
                     {
                        _loc2_.iRng = this.iSel.iRng;
                     }
                     else
                     {
                        _loc2_.iRng = 10;
                     }
                  }
               }
               if(_loc2_.sES.toLowerCase() == "weapon")
               {
                  _loc12_ = _loc2_.sType.toLowerCase() == "enhancement";
                  if(_loc12_)
                  {
                     _loc13_ = Number(_loc2_.iDPS);
                  }
                  else if("EnhDPS" in _loc2_)
                  {
                     _loc13_ = Number(_loc2_.EnhDPS);
                  }
                  else if(this.eSel != null && "iDPS" in this.eSel)
                  {
                     _loc13_ = Number(this.eSel.iDPS);
                  }
                  else
                  {
                     _loc13_ = -1;
                  }
                  if(_loc13_ == 0)
                  {
                     _loc13_ = 100;
                  }
                  if(_loc13_ == -1)
                  {
                     _loc13_ = 100;
                  }
                  _loc13_ /= 100;
                  _loc14_ = "iRng" in _loc2_ ? Number(_loc2_.iRng) : 0;
                  _loc14_ = _loc14_ / 100;
                  _loc15_ = 0;
                  if("iRty" in _loc2_)
                  {
                     _loc15_ = _loc2_.iRty - 1;
                  }
                  if("EnhRty" in _loc2_)
                  {
                     _loc15_ = _loc2_.EnhRty - 1;
                  }
                  if(_loc12_)
                  {
                     _loc16_ = int(_loc2_.iLvl);
                  }
                  else if("EnhLvl" in _loc2_)
                  {
                     _loc16_ = int(_loc2_.EnhLvl);
                  }
                  else if(this.eSel != null && "iLvl" in this.eSel)
                  {
                     _loc16_ = int(this.eSel.iLvl);
                  }
                  else
                  {
                     _loc16_ = int(this.iSel.iLvl);
                  }
                  _loc17_ = int(this.rootClass.getBaseHPByLevel(_loc16_ + _loc15_));
                  _loc18_ = 20;
                  _loc19_ = 2;
                  _loc20_ = Math.round(_loc17_ / _loc18_ * _loc13_ * this.rootClass.PCDPSMod);
                  _loc21_ = Math.round(_loc20_ * _loc19_);
                  _loc22_ = this.rootClass.world.getAutoAttack();
                  _loc21_ *= _loc22_.damage;
                  _loc23_ = Math.floor(_loc21_ - _loc21_ * _loc14_);
                  _loc24_ = Math.ceil(_loc21_ + _loc21_ * _loc14_);
                  _loc25_ = "";
                  if(_loc2_.sType.toLowerCase() == "enhancement" || ("EnhLvl" in _loc2_ || this.eSel != null))
                  {
                     _loc25_ += _loc20_ + " DPS";
                  }
                  if(_loc2_.sType.toLowerCase() != "enhancement" && ("EnhLvl" in _loc2_ || this.eSel != null))
                  {
                     _loc25_ += " ( " + _loc23_ + "-" + _loc24_ + ", " + this.rootClass.numToStr(_loc22_.cd / 1000,1) + " speed )";
                  }
                  if(_loc25_ != "")
                  {
                     _loc26_ += "<font size=\'12\' color=\'#DDDDDD\'>" + _loc25_ + "</font>";
                  }
               }
            }
            else
            {
               _loc26_ = "<font size=\'12\' color=\'#BBBBBB\'>Enhancement: </font><font size=\'12\' color=\'#00CCFF\'>This item cannot be enhanced.</font>";
            }
            if(_loc27_ > 0)
            {
               this.tDesc.y = _loc27_ + 2;
            }
            this.tDesc.htmlText = _loc26_;
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
         var _loc1_:ColorTransform = null;
         if(param1 != null && param1.hasOwnProperty("COLOR"))
         {
            _loc1_ = param1.COLOR as ColorTransform;
            if(_loc1_ != null)
            {
               return "#" + this.toHex2(int(_loc1_.redOffset)) + this.toHex2(int(_loc1_.greenOffset)) + this.toHex2(int(_loc1_.blueOffset));
            }
         }
         var _loc2_:String = param1 != null && param1.sDesc != null ? String(param1.sDesc) : "";
         switch(_loc2_)
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
         var _loc1_:String = (param1 & 0xFF).toString(16).toUpperCase();
         if(_loc1_.length < 2)
         {
            _loc1_ = "0" + _loc1_;
         }
         return _loc1_;
      }

      private function buildHeaderLine(param1:String, param2:String, param3:String, param4:int, param5:int) : TextField
      {
         var _loc1_:TextField = new TextField();
         _loc1_.embedFonts = false;
         _loc1_.selectable = false;
         _loc1_.multiline = false;
         _loc1_.wordWrap = false;
         _loc1_.autoSize = TextFieldAutoSize.LEFT;
         _loc1_.mouseEnabled = false;
         _loc1_.x = 0;
         _loc1_.y = param4;
         var _loc2_:* = 13;
         var _loc3_:String = param2;
         var _loc4_:String = param1 + param2;
         _loc1_.htmlText = "<font face=\'Arial\' size=\'" + _loc2_ + "\' color=\'#BBBBBB\'><b>" + param1 + "</b></font><font face=\'Arial\' size=\'" + _loc2_ + "\' color=\'" + param3 + "\'><b>" + _loc3_ + "</b></font>";
         while(_loc1_.textWidth > param5 && _loc2_ > 10)
         {
            _loc2_--;
            _loc1_.htmlText = "<font face=\'Arial\' size=\'" + _loc2_ + "\' color=\'#BBBBBB\'><b>" + param1 + "</b></font><font face=\'Arial\' size=\'" + _loc2_ + "\' color=\'" + param3 + "\'><b>" + _loc3_ + "</b></font>";
         }
         var _loc5_:Boolean = false;
         while(_loc1_.textWidth > param5 && _loc3_.length > 1)
         {
            _loc3_ = _loc3_.substr(0,_loc3_.length - 1);
            _loc5_ = true;
            _loc1_.htmlText = "<font face=\'Arial\' size=\'" + _loc2_ + "\' color=\'#BBBBBB\'><b>" + param1 + "</b></font><font face=\'Arial\' size=\'" + _loc2_ + "\' color=\'" + param3 + "\'><b>" + _loc3_ + "…</b></font>";
         }
         if(_loc5_)
         {
            _loc1_.mouseEnabled = true;
            _loc1_.name = "hdrTT" + this.headerTTIndex;
            this.headerFullText[_loc1_.name] = _loc4_;
            ++this.headerTTIndex;
            _loc1_.addEventListener(MouseEvent.MOUSE_OVER,this.onHeaderMouseOver,false,0,true);
            _loc1_.addEventListener(MouseEvent.MOUSE_OUT,this.onHeaderMouseOut,false,0,true);
         }
         this.mcHeader.addChild(_loc1_);
         return _loc1_;
      }

      private function onHeaderMouseOver(param1:MouseEvent) : void
      {
         var _loc1_:TextField = TextField(param1.currentTarget);
         this.rootClass.ui.ToolTip.openWith({"str":this.headerFullText[_loc1_.name]});
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
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Sprite = null;
         var _loc5_:TextField = null;
         var _loc6_:TextField = null;
         var _loc7_:TextField = null;
         var _loc8_:TextField = null;
         var _loc9_:TextField = null;
         var _loc10_:Boolean = false;
         var _loc11_:Array = null;
         var _loc12_:MovieClip = null;
         var _loc13_:String = null;
         var _loc14_:* = undefined;
         var _loc15_:int = 0;
         var _loc16_:* = undefined;
         var _loc17_:String = null;
         var _loc18_:MovieClip = null;
         var _loc19_:MovieClip = null;
         var _loc20_:MovieClip = null;
         var _loc21_:MovieClip = null;
         var _loc22_:MovieClip = null;
         var _loc23_:MovieClip = null;
         this.closeTip();
         while(this.mcStats.numChildren > 1)
         {
            this.mcStats.removeChildAt(1);
         }
         var _loc24_:Boolean = this.eSel != null;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc27_:int = 0;
         var _loc28_:int = 0;
         var _loc29_:String = "";
         var _loc30_:int = int(w / 3);
         var _loc31_:int = 20;
         var _loc32_:int = 0;
         var _loc33_:int = 0;
         var _loc34_:int = 0;
         var _loc35_:uint = 0;
         var _loc36_:* = 0;
         var _loc37_:* = 0;
         var _loc38_:* = 0;
         var _loc39_:* = 0;
         var _loc40_:int = 0;
         this.mcStats.x = 2;
         if(this.tDesc.text.length > 0)
         {
            this.mcStats.y = int(this.tDesc.y + this.tDesc.height + 3);
         }
         else
         {
            this.mcStats.y = int(this.tDesc.y);
         }
         if(this.iSel != null && ((this.iEnh != null || this.eEnh != null) && (this.eSel == null || this.eSel.sES == this.iSel.sES) || _loc24_ && this.eSel.sES == this.iSel.sES))
         {
            if(_loc24_ && this.iEnh != null)
            {
               _loc1_ = this.rootClass.getStatsA(this.eSel,this.iSel.sES);
               _loc2_ = this.rootClass.getStatsA(this.iSel,this.iSel.sES);
            }
            else
            {
               _loc3_ = this.rootClass.copyObj(this.iSel);
               if(_loc24_)
               {
                  _loc3_.EnhPatternID = this.eSel.PatternID;
                  _loc3_.EnhLvl = this.eSel.iLvl;
                  _loc3_.EnhRty = this.eSel.iRty;
                  _loc24_ = false;
               }
               _loc1_ = this.rootClass.getStatsA(_loc3_,this.iSel.sES);
            }
            _loc25_ = 0;
            while(_loc25_ < this.rootClass.orderedStats.length)
            {
               _loc29_ = this.rootClass.orderedStats[_loc25_];
               _loc28_ = 0;
               if(_loc24_ && _loc2_["$" + _loc29_] != null && _loc1_["$" + _loc29_] == null)
               {
                  _loc1_["$" + _loc29_] = 0;
               }
               if(_loc1_["$" + _loc29_] != null)
               {
                  _loc27_ = int(_loc1_["$" + _loc29_]);
                  _loc4_ = new Sprite();
                  if(_loc24_ && _loc2_["$" + _loc29_] != null)
                  {
                     _loc28_ = int(_loc2_["$" + _loc29_]);
                  }
                  else
                  {
                     _loc28_ = 0;
                  }
                  if(_loc24_)
                  {
                     _loc34_ = _loc27_ - _loc28_;
                     _loc32_ += _loc27_;
                     _loc33_ += _loc28_;
                     _loc35_ = _loc34_ > 0 ? 8190976 : (_loc34_ < 0 ? 16733525 : 16777215);
                  }
                  else
                  {
                     _loc35_ = 16777215;
                  }
                  _loc36_ = 11;
                  _loc37_ = 13;
                  _loc38_ = 12;
                  _loc39_ = 14;
                  _loc5_ = new TextField();
                  _loc5_.autoSize = TextFieldAutoSize.LEFT;
                  _loc5_.embedFonts = false;
                  _loc5_.selectable = false;
                  _loc5_.mouseEnabled = false;
                  _loc5_.defaultTextFormat = new TextFormat("Arial",_loc36_,10066329,true);
                  _loc5_.text = _loc29_.toUpperCase();
                  _loc5_.x = 0;
                  _loc5_.y = 3;
                  _loc4_.addChild(_loc5_);
                  _loc6_ = new TextField();
                  _loc6_.autoSize = TextFieldAutoSize.LEFT;
                  _loc6_.embedFonts = false;
                  _loc6_.selectable = false;
                  _loc6_.mouseEnabled = false;
                  _loc6_.y = 0;
                  _loc6_.defaultTextFormat = new TextFormat("Arial",_loc39_,_loc35_,true);
                  _loc6_.text = String(_loc27_);
                  if(_loc24_)
                  {
                     _loc7_ = new TextField();
                     _loc7_.autoSize = TextFieldAutoSize.LEFT;
                     _loc7_.embedFonts = false;
                     _loc7_.selectable = false;
                     _loc7_.mouseEnabled = false;
                     _loc7_.defaultTextFormat = new TextFormat("Arial",_loc37_,11184810);
                     _loc7_.text = String(_loc28_);
                     _loc8_ = new TextField();
                     _loc8_.autoSize = TextFieldAutoSize.LEFT;
                     _loc8_.embedFonts = false;
                     _loc8_.selectable = false;
                     _loc8_.mouseEnabled = false;
                     _loc8_.defaultTextFormat = new TextFormat("Arial",_loc38_,7829367);
                     _loc8_.text = " → ";
                     _loc7_.x = _loc5_.x + _loc5_.textWidth + 3;
                     _loc7_.y = _loc6_.y + (_loc6_.height - _loc7_.height);
                     _loc8_.x = _loc7_.x + _loc7_.textWidth;
                     _loc8_.y = _loc6_.y + (_loc6_.height - _loc8_.height);
                     _loc6_.x = _loc8_.x + _loc8_.textWidth;
                     _loc40_ = _loc30_ - 4;
                     while(_loc6_.x + _loc6_.textWidth > _loc40_ && (_loc36_ > 10 || _loc37_ > 10 || _loc38_ > 10 || _loc39_ > 10))
                     {
                        if(_loc36_ > 10)
                        {
                           _loc36_--;
                        }
                        if(_loc37_ > 10)
                        {
                           _loc37_--;
                        }
                        if(_loc38_ > 10)
                        {
                           _loc38_--;
                        }
                        if(_loc39_ > 10)
                        {
                           _loc39_--;
                        }
                        _loc5_.setTextFormat(new TextFormat("Arial",_loc36_,10066329,true));
                        _loc7_.setTextFormat(new TextFormat("Arial",_loc37_,11184810));
                        _loc8_.setTextFormat(new TextFormat("Arial",_loc38_,7829367));
                        _loc6_.setTextFormat(new TextFormat("Arial",_loc39_,_loc35_,true));
                        _loc7_.x = _loc5_.x + _loc5_.textWidth + 3;
                        _loc7_.y = _loc6_.y + (_loc6_.height - _loc7_.height);
                        _loc8_.x = _loc7_.x + _loc7_.textWidth;
                        _loc8_.y = _loc6_.y + (_loc6_.height - _loc8_.height);
                        _loc6_.x = _loc8_.x + _loc8_.textWidth;
                     }
                     _loc4_.addChild(_loc7_);
                     _loc4_.addChild(_loc8_);
                  }
                  else
                  {
                     _loc6_.x = 30;
                  }
                  _loc4_.addChild(_loc6_);
                  _loc4_.x = _loc26_ % 3 * _loc30_;
                  _loc4_.y = Math.floor(_loc26_ / 3) * _loc31_;
                  _loc4_.name = "t" + _loc29_;
                  this.mcStats.addChild(_loc4_);
                  _loc26_++;
               }
               _loc25_++;
            }
            if(_loc24_)
            {
               _loc34_ = _loc32_ - _loc33_;
               _loc9_ = new TextField();
               _loc9_.autoSize = TextFieldAutoSize.LEFT;
               _loc9_.embedFonts = false;
               _loc9_.selectable = false;
               _loc9_.mouseEnabled = false;
               _loc9_.defaultTextFormat = new TextFormat("Arial",12,_loc34_ > 0 ? 8190976 : (_loc34_ < 0 ? 16733525 : 16777215),true);
               _loc9_.text = "Total change: " + (_loc34_ >= 0 ? "+" : "") + _loc34_;
               _loc9_.x = 0;
               _loc9_.y = 2 * _loc31_;
               _loc9_.name = "tTotalChange";
               this.mcStats.addChild(_loc9_);
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
            _loc10_ = false;
            switch(this.iSel.sES)
            {
               case "he":
               case "ba":
               case "Weapon":
               case "pe":
               case "co":
               case "mi":
                  _loc10_ = true;
            }
            if(!_loc10_)
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
            _loc11_ = this.iSel.sMeta.split(",");
            _loc12_ = new damageBoost();
            if(!this.boostsObj["dmgBoost"])
            {
               this.boostsObj["dmgBoost"] = "";
            }
            for each(_loc14_ in _loc11_)
            {
               _loc17_ = _loc14_.split(":")[1];
               _loc13_ = Math.round((Number(_loc17_) - 1) * 100).toString();
               switch(_loc14_.split(":")[0].toLowerCase())
               {
                  case "dmgall":
                     this.boostsObj["dmgBoost"] += "All +" + _loc13_ + "%\n";
                     break;
                  case "undead":
                     this.boostsObj["dmgBoost"] += "Undead +" + _loc13_ + "%\n";
                     break;
                  case "human":
                     this.boostsObj["dmgBoost"] += "Human +" + _loc13_ + "%\n";
                     break;
                  case "chaos":
                     this.boostsObj["dmgBoost"] += "Chaos +" + _loc13_ + "%\n";
                     break;
                  case "dragonkin":
                     this.boostsObj["dmgBoost"] += "Dragonkin +" + _loc13_ + "%\n";
                     break;
                  case "orc":
                     this.boostsObj["dmgBoost"] += "Orc +" + _loc13_ + "%\n";
                     break;
                  case "drakath":
                     this.boostsObj["dmgBoost"] += "Drakath +" + _loc13_ + "%\n";
                     break;
                  case "elemental":
                     this.boostsObj["dmgBoost"] += "Elemental +" + _loc13_ + "%\n";
                     break;
                  case "cp":
                     this.boostsObj["classBoost"] = "Class Points +" + _loc13_ + "%";
                     break;
                  case "gold":
                     this.boostsObj["goldBoost"] = "Gold +" + _loc13_ + "%";
                     break;
                  case "rep":
                     this.boostsObj["repBoost"] = "Reputation +" + _loc13_ + "%";
                     break;
                  case "exp":
                     this.boostsObj["xpBoost"] = "Experience +" + _loc13_ + "%";
               }
            }
            _loc15_ = 30;
            for(_loc16_ in this.boostsObj)
            {
               switch(_loc16_)
               {
                  case "dmgBoost":
                     if(this.boostsObj[_loc16_] != "")
                     {
                        this.mcContainer.addChild(_loc12_);
                        _loc12_.width = _loc15_;
                        _loc12_.height = _loc15_;
                        _loc12_.name = "dmgBoost";
                        _loc12_.addEventListener(MouseEvent.MOUSE_OVER,this.onBoostGet,false,0,true);
                        _loc12_.addEventListener(MouseEvent.MOUSE_OUT,this.onBoostOut,false,0,true);
                     }
                     break;
                  case "classBoost":
                     _loc18_ = new classBoost();
                     this.mcContainer.addChild(_loc18_);
                     _loc18_.width = _loc15_;
                     _loc18_.height = _loc15_;
                     _loc18_.name = "classBoost";
                     _loc18_.addEventListener(MouseEvent.MOUSE_OVER,this.onBoostGet,false,0,true);
                     _loc18_.addEventListener(MouseEvent.MOUSE_OUT,this.onBoostOut,false,0,true);
                     break;
                  case "goldBoost":
                     _loc19_ = new goldBoost();
                     this.mcContainer.addChild(_loc19_);
                     _loc19_.width = _loc15_;
                     _loc19_.height = _loc15_;
                     _loc19_.name = "goldBoost";
                     _loc19_.addEventListener(MouseEvent.MOUSE_OVER,this.onBoostGet,false,0,true);
                     _loc19_.addEventListener(MouseEvent.MOUSE_OUT,this.onBoostOut,false,0,true);
                     break;
                  case "repBoost":
                     _loc20_ = new repBoost();
                     this.mcContainer.addChild(_loc20_);
                     _loc20_.width = _loc15_;
                     _loc20_.height = _loc15_;
                     _loc20_.name = "repBoost";
                     _loc20_.addEventListener(MouseEvent.MOUSE_OVER,this.onBoostGet,false,0,true);
                     _loc20_.addEventListener(MouseEvent.MOUSE_OUT,this.onBoostOut,false,0,true);
                     break;
                  case "xpBoost":
                     _loc21_ = new xpBoost();
                     this.mcContainer.addChild(_loc21_);
                     _loc21_.width = _loc15_;
                     _loc21_.height = _loc15_;
                     _loc21_.name = "xpBoost";
                     _loc21_.addEventListener(MouseEvent.MOUSE_OVER,this.onBoostGet,false,0,true);
                     _loc21_.addEventListener(MouseEvent.MOUSE_OUT,this.onBoostOut,false,0,true);
               }
            }
            _loc25_ = 0;
            while(_loc25_ < this.mcContainer.numChildren)
            {
               _loc22_ = this.mcContainer.getChildAt(_loc25_) as MovieClip;
               _loc22_.x = _loc25_ * _loc22_.width + 2;
               _loc25_++;
            }
            if(this.mcContainer.numChildren > 0)
            {
               _loc23_ = new btnMoreInfo();
               _loc23_.addEventListener(MouseEvent.CLICK,this.onBoostsInfo,false,0,true);
               this.mcContainer.addChild(_loc23_);
               _loc23_.x = this.mcContainer.getChildAt(this.mcContainer.numChildren - 2).x + this.mcContainer.getChildAt(this.mcContainer.numChildren - 2).width + 3;
               _loc23_.y = _loc23_.height / 4 + 2;
            }
         }
      }

      private function onBoostsInfo(param1:MouseEvent) : void
      {
         navigateToURL(new URLRequest("https://www.aq.com/lore/Guides/AQWBoosts"),"_blank");
      }

      private function onBoostGet(param1:MouseEvent) : void
      {
         var _loc1_:String = param1.currentTarget.name;
         this.rootClass.ui.ToolTip.openWith({"str":this.boostsObj[_loc1_]});
      }

      private function onBoostOut(param1:MouseEvent) : void
      {
         this.rootClass.ui.ToolTip.close();
      }

      private function onTTFieldMouseOver(param1:MouseEvent) : void
      {
         var _loc1_:String = param1.currentTarget.name;
         var _loc2_:String = "";
         switch(_loc1_)
         {
            case "tAP":
               _loc2_ = "Attack Power increases the effectiveness of your physical damage attacks.";
               break;
            case "tSP":
               _loc2_ = "Magic Power increases the effectiveness of your magical damage attacks.";
               break;
            case "tDmg":
               _loc2_ = "This is the damage you would expect to see on a normal melee hit, before any other modifiers.";
               break;
            case "tHP":
               _loc2_ = "Your total Hit Points.  When these reach zero, you will need to wait a short time before being able to continue playing.";
               break;
            case "tHitTF":
               _loc2_ = "Hit chance determines how likely you are to hit a target, before any other modifiers.";
               break;
            case "tHasteTF":
               _loc2_ = "Haste reduces the cooldown on all of your attacks and spells, including Auto Attack, by a certain percentage (hard capped at 50%).";
               break;
            case "tCritTF":
               _loc2_ = "Critical Strike chance increases the likelihood of dealing additional damage on a any attack.";
               break;
            case "tDodgeTF":
               _loc2_ = "Evasion chance allows you to completely avoid incoming damage.";
               break;
            case "tSTR":
            case "sl1":
               _loc2_ = "Strength increases Attack Power, which boosts physical damage. It also improves Critical Strike chance for melee classes.";
               break;
            case "tINT":
            case "sl2":
               _loc2_ = "Intellect increases Magic Power, which boosts magical damage. It also improve Critical Strike chance for caster classes.";
               break;
            case "tEND":
            case "sl3":
               _loc2_ = "Endurance directly contributes to your total Hit Points.  While very useful for all classes, some abilities work best with very high or very low total HP.";
               break;
            case "tDEX":
            case "sl4":
               _loc2_ = "Dexterity is valuable to melee classes. It increases Haste, Hit chance, and Evasion chance. It increases only Evasion chance for caster classes.";
               break;
            case "tWIS":
            case "sl5":
               _loc2_ = "Wisdom is valuable to caster classes. It increases Hit chance, Crit chance, and Evasion chance. It improves only Evasion chance for melee classes.";
               break;
            case "tLCK":
            case "sl6":
               _loc2_ = "Luck increases your Critical Strike modifier value directly, and may have effects outside of combat.";
         }
         this.rootClass.ui.ToolTip.openWith({"str":_loc2_});
      }

      private function onTTFieldMouseOut(param1:MouseEvent) : void
      {
         this.rootClass.ui.ToolTip.close();
      }
   }
}
