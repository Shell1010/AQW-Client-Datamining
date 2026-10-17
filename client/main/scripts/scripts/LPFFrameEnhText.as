package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import liteAssets.draw.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol1972")]
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

      private var descFmt:TextFormat;

      private var procTip:MovieClip;

      private var procTipID:int = 0;

      internal var mcContainer:MovieClip;

      public function LPFFrameEnhText()
      {
         super();
         this.mcStats.sproto.visible = false;
         this.tDesc.embedFonts = MailArt.embedded();
         if(this.tDesc.embedFonts)
         {
            this.tDesc.antiAliasType = AntiAliasType.ADVANCED;
         }
         this.descFmt = MailArt.fmt(12,14540253);
         this.descFmt.leading = 2;
         this.tDesc.defaultTextFormat = this.descFmt;
         this.tDesc.autoSize = TextFieldAutoSize.LEFT;
         this.mcHeader = new Sprite();
         addChild(this.mcHeader);
      }

      public static function getEnhNameColor(param1:Object) : String
      {
         var _loc1_:ColorTransform = null;
         if(param1 != null && param1.hasOwnProperty("COLOR"))
         {
            _loc1_ = param1.COLOR as ColorTransform;
            if(_loc1_ != null)
            {
               return "#" + toHex2(int(_loc1_.redOffset)) + toHex2(int(_loc1_.greenOffset)) + toHex2(int(_loc1_.blueOffset));
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

      private static function toHex2(param1:int) : String
      {
         var _loc1_:String = (param1 & 0xFF).toString(16).toUpperCase();
         if(_loc1_.length < 2)
         {
            _loc1_ = "0" + _loc1_;
         }
         return _loc1_;
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
         var _loc1_:Object = null;
         var _loc2_:String = null;
         var _loc3_:TextField = null;
         var _loc4_:TextField = null;
         var _loc5_:String = null;
         var _loc6_:TextField = null;
         var _loc7_:String = null;
         var _loc8_:Boolean = false;
         var _loc9_:TextField = null;
         var _loc10_:String = null;
         var _loc11_:Object = null;
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
         var _loc27_:String = "";
         var _loc28_:int = 0;
         var _loc29_:int = int(w) - 8;
         this.closeTip();
         while(this.mcHeader.numChildren > 0)
         {
            this.mcHeader.removeChildAt(0);
         }
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
                     _loc2_ = this.rootClass.getDisplayEnhName(this.eEnh);
                     if(this.eSel.iRty > 1)
                     {
                        _loc2_ += " +" + (this.eSel.iRty - 1);
                     }
                     if(Boolean(this.eEnh) && Boolean(this.eEnh.hasOwnProperty("DIS")) && Boolean(this.eEnh["DIS"]))
                     {
                        _loc2_ += ", " + this.rootClass.getDisplayEnhTraitName(this.eEnh);
                     }
                     if(this.iEnh != null)
                     {
                        if(this.iEnh.hasOwnProperty("DIS"))
                        {
                           _loc5_ = "Forge";
                        }
                        else
                        {
                           _loc5_ = this.iEnh.sName;
                        }
                        if(this.iSel.EnhRty > 1)
                        {
                           _loc5_ += " +" + (this.iSel.EnhRty - 1);
                        }
                        if(Boolean(this.iEnh.hasOwnProperty("DIS")) && Boolean(this.iEnh["DIS"]))
                        {
                           _loc5_ += ", " + this.rootClass.getDisplayEnhTraitName(this.iEnh);
                        }
                        _loc3_ = this.buildHeaderLine("Current: ",_loc5_,"#999999",0,_loc29_);
                     }
                     else
                     {
                        _loc3_ = this.buildHeaderLine("Current: ","No enhancement","#00CCFF",0,_loc29_);
                     }
                     _loc4_ = this.buildHeaderLine("New: ",_loc2_,getEnhNameColor(this.eEnh),_loc3_.y + _loc3_.height + 2,_loc29_);
                     _loc28_ = this.mcHeader.y + _loc4_.y + _loc4_.height;
                  }
                  else
                  {
                     _loc6_ = this.buildHeaderLine("Enhancement: ","Enhancement type must match item slot!","#00CCFF",0,_loc29_);
                     _loc28_ = this.mcHeader.y + _loc6_.y + _loc6_.height;
                  }
               }
               else if(this.iEnh != null)
               {
                  _loc7_ = this.rootClass.getDisplayEnhName(this.iEnh);
                  if("EnhRty" in this.iSel && this.iSel.EnhRty > 1)
                  {
                     _loc7_ += " +" + (this.iSel.EnhRty - 1);
                  }
                  else if("iRty" in this.iSel && this.iSel.iRty < 10 && this.iSel.iRty > 1)
                  {
                     _loc7_ += " +" + (this.iSel.iRty - 1);
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
                     _loc11_ = this.rootClass.procInfo[String(this.iSel.ProcID)];
                     _loc7_ += ", " + (_loc11_ != null && _loc11_.nam != null ? String(_loc11_.nam) : _loc10_);
                  }
                  else if(Boolean(this.iEnh.hasOwnProperty("DIS")) && Boolean(this.iEnh["DIS"]))
                  {
                     _loc7_ += ", " + this.rootClass.getDisplayEnhTraitName(this.iEnh);
                  }
                  _loc8_ = Boolean(this.iSel.ProcID) && !this.iEnh.hasOwnProperty("DIS") && this.rootClass.procInfo[String(this.iSel.ProcID)] != null;
                  _loc9_ = this.buildHeaderLine("Enhancement: ",_loc7_,getEnhNameColor(this.iEnh),0,_loc8_ ? int(_loc29_ - 34) : _loc29_);
                  if(_loc8_)
                  {
                     this.addProcTip(_loc9_,int(this.iSel.ProcID));
                  }
                  _loc28_ = this.mcHeader.y + _loc9_.y + _loc9_.height;
               }
               else
               {
                  _loc12_ = this.buildHeaderLine("Enhancement: ","No enhancement","#00CCFF",0,_loc29_);
                  _loc28_ = this.mcHeader.y + _loc12_.y + _loc12_.height;
               }
               _loc1_ = this.rootClass.copyObj(this.iSel);
               if(this.eSel != null)
               {
                  _loc1_ = this.rootClass.copyObj(this.eSel);
                  if(this.iSel != null)
                  {
                     _loc1_.sType = this.iSel.sType;
                     if("EnhRty" in this.iSel)
                     {
                        _loc1_.EnhRty = this.iSel.EnhRty;
                     }
                     if("iRng" in this.iSel)
                     {
                        _loc1_.iRng = this.iSel.iRng;
                     }
                     else
                     {
                        _loc1_.iRng = 10;
                     }
                  }
               }
               if(_loc1_.sES.toLowerCase() == "weapon")
               {
                  _loc13_ = _loc1_.sType.toLowerCase() == "enhancement";
                  if(_loc13_)
                  {
                     _loc14_ = Number(_loc1_.iDPS);
                  }
                  else if("EnhDPS" in _loc1_)
                  {
                     _loc14_ = Number(_loc1_.EnhDPS);
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
                  _loc15_ = "iRng" in _loc1_ ? Number(_loc1_.iRng) : 0;
                  _loc15_ = _loc15_ / 100;
                  _loc16_ = 0;
                  if("iRty" in _loc1_)
                  {
                     _loc16_ = _loc1_.iRty - 1;
                  }
                  if("EnhRty" in _loc1_)
                  {
                     _loc16_ = _loc1_.EnhRty - 1;
                  }
                  if(_loc13_)
                  {
                     _loc17_ = int(_loc1_.iLvl);
                  }
                  else if("EnhLvl" in _loc1_)
                  {
                     _loc17_ = int(_loc1_.EnhLvl);
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
                  if(_loc1_.sType.toLowerCase() == "enhancement" || ("EnhLvl" in _loc1_ || this.eSel != null))
                  {
                     _loc26_ += _loc21_ + " DPS";
                  }
                  if(_loc1_.sType.toLowerCase() != "enhancement" && ("EnhLvl" in _loc1_ || this.eSel != null))
                  {
                     _loc26_ += " ( " + _loc24_ + "-" + _loc25_ + ", " + this.rootClass.numToStr(_loc23_.cd / 1000,1) + " speed )";
                  }
                  if(_loc26_ != "")
                  {
                     _loc27_ += "<font size=\'12\' color=\'#DDDDDD\'>" + _loc26_ + "</font>";
                  }
               }
            }
            else
            {
               _loc27_ = "<font size=\'12\' color=\'#BBBBBB\'>Enhancement: </font><font size=\'12\' color=\'#00CCFF\'>This item cannot be enhanced.</font>";
            }
            if(_loc28_ > 0)
            {
               this.tDesc.y = _loc28_ + 2;
            }
            this.setHtml(this.tDesc,_loc27_);
            this.showStats();
         }
         else
         {
            if(MovieClip(getLayout()).iSel != null && !this.rootClass.doIHaveEnhancements())
            {
               this.setHtml(this.tDesc,"<font size=\'12\' color=\'#FF0000\'>You need an Enhancement!</font><br>" + "<font size=\'12\' color=\'#FFFFFF\'>No enhancments for this type of item were found in your backpack. Enhancements are used to power up your item. You can buy at shops or find them on monsters.</font>");
            }
            else
            {
               this.setHtml(this.tDesc,"No item selected.");
            }
            this.showStats();
         }
      }

      private function setHtml(param1:TextField, param2:String) : void
      {
         param1.embedFonts = MailArt.embedded();
         if(param1 == this.tDesc)
         {
            param1.defaultTextFormat = this.descFmt;
         }
         param1.htmlText = MailArt.embedHtml(param2);
         MailArt.cover(param1);
      }

      private function buildHeaderLine(param1:String, param2:String, param3:String, param4:int, param5:int) : TextField
      {
         var _loc1_:TextField = new TextField();
         _loc1_.embedFonts = MailArt.embedded();
         if(_loc1_.embedFonts)
         {
            _loc1_.antiAliasType = AntiAliasType.ADVANCED;
         }
         _loc1_.selectable = false;
         _loc1_.multiline = false;
         _loc1_.wordWrap = false;
         _loc1_.autoSize = TextFieldAutoSize.LEFT;
         _loc1_.mouseEnabled = false;
         _loc1_.x = 0;
         _loc1_.y = param4;
         var _loc2_:* = 13;
         this.setHtml(_loc1_,"<font face=\'Arial\' size=\'" + _loc2_ + "\' color=\'#BBBBBB\'><b>" + param1 + "</b></font><font face=\'Arial\' size=\'" + _loc2_ + "\' color=\'" + param3 + "\'><b>" + param2 + "</b></font>");
         while(_loc1_.textWidth > param5 && _loc2_ > 10)
         {
            _loc2_--;
            this.setHtml(_loc1_,"<font face=\'Arial\' size=\'" + _loc2_ + "\' color=\'#BBBBBB\'><b>" + param1 + "</b></font><font face=\'Arial\' size=\'" + _loc2_ + "\' color=\'" + param3 + "\'><b>" + param2 + "</b></font>");
         }
         if(_loc1_.textWidth > param5)
         {
            _loc1_.scaleX = _loc1_.scaleY = param5 / (_loc1_.textWidth + 4);
         }
         this.mcHeader.addChild(_loc1_);
         return _loc1_;
      }

      private function addProcTip(param1:TextField, param2:int) : void
      {
         this.procTip = new btnMoreInfo();
         this.procTipID = param2;
         this.procTip.buttonMode = true;
         this.procTip.x = Math.round(param1.x + param1.width + 4);
         this.procTip.y = param1.y + Math.round((param1.height - this.procTip.height) / 2);
         this.procTip.addEventListener(MouseEvent.MOUSE_OVER,this.onProcTipOver,false,0,true);
         this.procTip.addEventListener(MouseEvent.MOUSE_OUT,this.onProcTipOut,false,0,true);
         this.mcHeader.addChild(this.procTip);
      }

      private function onProcTipOver(param1:MouseEvent) : void
      {
         this.rootClass.ui.ToolTip.openWith({"str":this.rootClass.procTipText(this.procTipID)});
      }

      private function onProcTipOut(param1:MouseEvent) : void
      {
         this.closeTip();
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
         var _loc11_:BoostIcons = null;
         this.closeTip();
         while(this.mcStats.numChildren > 1)
         {
            this.mcStats.removeChildAt(1);
         }
         var _loc12_:Boolean = this.eSel != null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:String = "";
         var _loc18_:int = int(w / 3);
         var _loc19_:int = 20;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         var _loc23_:uint = 0;
         var _loc24_:* = 0;
         var _loc25_:* = 0;
         var _loc26_:* = 0;
         var _loc27_:* = 0;
         var _loc28_:int = 0;
         this.mcStats.x = 2;
         if(this.tDesc.text.length > 0)
         {
            this.mcStats.y = int(this.tDesc.y + this.tDesc.height + 3);
         }
         else
         {
            this.mcStats.y = int(this.tDesc.y);
         }
         if(this.iSel != null && ((this.iEnh != null || this.eEnh != null) && (this.eSel == null || this.eSel.sES == this.iSel.sES) || _loc12_ && this.eSel.sES == this.iSel.sES))
         {
            if(_loc12_ && this.iEnh != null)
            {
               _loc1_ = this.rootClass.getStatsA(this.eSel,this.iSel.sES);
               _loc2_ = this.rootClass.getStatsA(this.iSel,this.iSel.sES);
            }
            else
            {
               _loc3_ = this.rootClass.copyObj(this.iSel);
               if(_loc12_)
               {
                  _loc3_.EnhPatternID = this.eSel.PatternID;
                  _loc3_.EnhLvl = this.eSel.iLvl;
                  _loc3_.EnhRty = this.eSel.iRty;
                  _loc12_ = false;
               }
               _loc1_ = this.rootClass.getStatsA(_loc3_,this.iSel.sES);
            }
            _loc13_ = 0;
            while(_loc13_ < this.rootClass.orderedStats.length)
            {
               _loc17_ = this.rootClass.orderedStats[_loc13_];
               _loc16_ = 0;
               if(_loc12_ && _loc2_["$" + _loc17_] != null && _loc1_["$" + _loc17_] == null)
               {
                  _loc1_["$" + _loc17_] = 0;
               }
               if(_loc1_["$" + _loc17_] != null)
               {
                  _loc15_ = int(_loc1_["$" + _loc17_]);
                  _loc4_ = new Sprite();
                  if(_loc12_ && _loc2_["$" + _loc17_] != null)
                  {
                     _loc16_ = int(_loc2_["$" + _loc17_]);
                  }
                  else
                  {
                     _loc16_ = 0;
                  }
                  if(_loc12_)
                  {
                     _loc22_ = _loc15_ - _loc16_;
                     _loc20_ += _loc15_;
                     _loc21_ += _loc16_;
                     _loc23_ = _loc22_ > 0 ? 8190976 : (_loc22_ < 0 ? 16733525 : 16777215);
                  }
                  else
                  {
                     _loc23_ = 16777215;
                  }
                  _loc24_ = 11;
                  _loc25_ = 13;
                  _loc26_ = 12;
                  _loc27_ = 14;
                  _loc5_ = new TextField();
                  _loc5_.autoSize = TextFieldAutoSize.LEFT;
                  _loc5_.embedFonts = MailArt.embedded();
                  if(_loc5_.embedFonts)
                  {
                     _loc5_.antiAliasType = AntiAliasType.ADVANCED;
                  }
                  _loc5_.selectable = false;
                  _loc5_.mouseEnabled = false;
                  _loc5_.defaultTextFormat = MailArt.fmt(_loc24_,10066329,true);
                  _loc5_.text = _loc17_.toUpperCase();
                  _loc5_.x = 0;
                  _loc5_.y = 3;
                  _loc4_.addChild(_loc5_);
                  _loc6_ = new TextField();
                  _loc6_.autoSize = TextFieldAutoSize.LEFT;
                  _loc6_.embedFonts = MailArt.embedded();
                  if(_loc6_.embedFonts)
                  {
                     _loc6_.antiAliasType = AntiAliasType.ADVANCED;
                  }
                  _loc6_.selectable = false;
                  _loc6_.mouseEnabled = false;
                  _loc6_.y = 0;
                  _loc6_.defaultTextFormat = MailArt.fmt(_loc27_,_loc23_,true);
                  _loc6_.text = String(_loc15_);
                  if(_loc12_)
                  {
                     _loc7_ = new TextField();
                     _loc7_.autoSize = TextFieldAutoSize.LEFT;
                     _loc7_.embedFonts = MailArt.embedded();
                     if(_loc7_.embedFonts)
                     {
                        _loc7_.antiAliasType = AntiAliasType.ADVANCED;
                     }
                     _loc7_.selectable = false;
                     _loc7_.mouseEnabled = false;
                     _loc7_.defaultTextFormat = MailArt.fmt(_loc25_,11184810);
                     _loc7_.text = String(_loc16_);
                     _loc8_ = new TextField();
                     _loc8_.autoSize = TextFieldAutoSize.LEFT;
                     _loc8_.embedFonts = MailArt.embedded();
                     if(_loc8_.embedFonts)
                     {
                        _loc8_.antiAliasType = AntiAliasType.ADVANCED;
                     }
                     _loc8_.selectable = false;
                     _loc8_.mouseEnabled = false;
                     _loc8_.defaultTextFormat = MailArt.fmt(_loc26_,7829367);
                     _loc8_.text = " → ";
                     MailArt.cover(_loc8_);
                     _loc7_.x = _loc5_.x + _loc5_.textWidth + 3;
                     _loc7_.y = _loc6_.y + (_loc6_.height - _loc7_.height);
                     _loc8_.x = _loc7_.x + _loc7_.textWidth;
                     _loc8_.y = _loc6_.y + (_loc6_.height - _loc8_.height);
                     _loc6_.x = _loc8_.x + _loc8_.textWidth;
                     _loc28_ = _loc18_ - 4;
                     while(_loc6_.x + _loc6_.textWidth > _loc28_ && (_loc24_ > 10 || _loc25_ > 10 || _loc26_ > 10 || _loc27_ > 10))
                     {
                        if(_loc24_ > 10)
                        {
                           _loc24_--;
                        }
                        if(_loc25_ > 10)
                        {
                           _loc25_--;
                        }
                        if(_loc26_ > 10)
                        {
                           _loc26_--;
                        }
                        if(_loc27_ > 10)
                        {
                           _loc27_--;
                        }
                        _loc5_.setTextFormat(MailArt.fmt(_loc24_,10066329,true));
                        _loc7_.setTextFormat(MailArt.fmt(_loc25_,11184810));
                        _loc8_.embedFonts = MailArt.embedded();
                        _loc8_.setTextFormat(MailArt.fmt(_loc26_,7829367));
                        MailArt.cover(_loc8_);
                        _loc6_.setTextFormat(MailArt.fmt(_loc27_,_loc23_,true));
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
                  _loc4_.x = _loc14_ % 3 * _loc18_;
                  _loc4_.y = Math.floor(_loc14_ / 3) * _loc19_;
                  _loc4_.name = "t" + _loc17_;
                  this.mcStats.addChild(_loc4_);
                  _loc14_++;
               }
               _loc13_++;
            }
            if(_loc12_)
            {
               _loc22_ = _loc20_ - _loc21_;
               _loc9_ = new TextField();
               _loc9_.autoSize = TextFieldAutoSize.LEFT;
               _loc9_.embedFonts = MailArt.embedded();
               if(_loc9_.embedFonts)
               {
                  _loc9_.antiAliasType = AntiAliasType.ADVANCED;
               }
               _loc9_.selectable = false;
               _loc9_.mouseEnabled = false;
               _loc9_.defaultTextFormat = MailArt.fmt(12,_loc22_ > 0 ? 8190976 : (_loc22_ < 0 ? 16733525 : 16777215),true);
               _loc9_.text = "Total change: " + (_loc22_ >= 0 ? "+" : "") + _loc22_;
               _loc9_.x = 0;
               _loc9_.y = 2 * _loc19_;
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
            this.iEnh = null;
            if(this.iSel.PatternID != null)
            {
               this.iEnh = this.rootClass.world.enhPatternTree[this.iSel.PatternID];
            }
            if(this.iSel.EnhPatternID != null)
            {
               this.iEnh = this.rootClass.world.enhPatternTree[this.iSel.EnhPatternID];
            }
            _loc11_ = new BoostIcons(this.rootClass,this.iSel.sMeta,30);
            if(_loc11_.count == 0)
            {
               return;
            }
            this.mcContainer = _loc11_;
            this.mcContainer.name = "mcContainer";
            if(this.iEnh)
            {
               this.mcContainer.y = this.mcStats.height + 4;
               this.mcStats.addChild(this.mcContainer);
            }
            else
            {
               this.mcContainer.x = 2;
               this.mcContainer.y = 20;
               addChild(this.mcContainer);
            }
         }
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
