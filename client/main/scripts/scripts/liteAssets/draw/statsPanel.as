package liteAssets.draw
{
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.text.TextField;
   import flash.text.TextFormat;

   [Embed(source="/_assets/assets.swf", symbol="symbol2092")]
   public class statsPanel extends MovieClip
   {

      public var bContainer:MovieClip;

      public var bg:MovieClip;

      public var btnExit:MovieClip;

      public var btnHelp:MovieClip;

      public var btnHelp2:MovieClip;

      public var btnHelp3:MovieClip;

      public var tCat:TextField;

      public var tCombat1:TextField;

      public var tCombat2:TextField;

      public var tCore:TextField;

      public var tMod:TextField;

      public var tName:TextField;

      public var tStats:TextField;

      private var r:MovieClip;

      private var world:MovieClip;

      internal var tt:MovieClip;

      private var allocated:Object;

      private var nextMode:String;

      private var uoLeaf:Object;

      private var uoData:Object;

      private var stp:Object;

      private var stg:Object;

      internal var tStatVals:Array = ["STR","INT","DEX","END","WIS","LCK"];

      internal var tStatFormats:Array = [];

      internal var tFormats:Array = [];

      internal var tValues:Array = ["$cai","$cao","$cpi","$cpo","$cmi","$cmo","$chi","$cho","$cdi","$cdo","$cmc"];

      internal var tCombatFormats1:Array = [];

      internal var tCombatFormats2:Array = [];

      internal var tCombat1Vals:Array = ["$ap","$sp","$thi","$tha"];

      internal var tCombat2Vals:Array = ["$tcr","$scm","$tdo"];

      internal var boostsObj:Object = {};

      public function statsPanel(param1:MovieClip)
      {
         super();
         this.r = param1;
         this.world = this.r.world;
         this.uoLeaf = this.world.myLeaf();
         this.uoData = this.world.myAvatar.objData;
         this.stp = new Object();
         this.stg = new Object();
         this.addEventListener(Event.ADDED_TO_STAGE,this.onStage,false,0,true);
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.onDrag,false,0,true);
         this.addEventListener(MouseEvent.MOUSE_UP,this.onStop,false,0,true);
         this.btnHelp.addEventListener(MouseEvent.CLICK,this.onHelp,false,0,true);
         this.btnHelp2.addEventListener(MouseEvent.CLICK,this.onHelp,false,0,true);
         this.btnHelp3.addEventListener(MouseEvent.CLICK,this.onHelp,false,0,true);
         this.btnExit.addEventListener(MouseEvent.CLICK,this.onExit,false,0,true);
         this.tName.mouseEnabled = false;
         this.tCat.mouseEnabled = false;
         this.updateBoosts();
      }

      public function onHelp(param1:MouseEvent) : void
      {
         navigateToURL(new URLRequest("https://www.aq.com/lore/guides/stats"),"_blank");
      }

      public function cleanup() : void
      {
         var _loc1_:MovieClip = null;
         if(parent != null)
         {
            _loc1_ = MovieClip(parent);
            _loc1_.removeChild(this);
            this.r.stage.focus = null;
         }
      }

      public function onExit(param1:MouseEvent) : void
      {
         this.cleanup();
      }

      public function onStage(param1:Event) : void
      {
         this.updateBase();
         this.update();
         this.removeEventListener(Event.ADDED_TO_STAGE,this.onStage);
         this.tt = new ToolTipMC(this.r);
         addChild(this.tt);
      }

      private function getCatDefinition() : String
      {
         switch(this.uoData.sClassCat)
         {
            case "M1":
               return "Tank Melee";
            case "M2":
               return "Dodge Melee";
            case "M3":
               return "Full Hybrid";
            case "M4":
               return "Power Melee";
            case "C1":
               return "Offensive Caster";
            case "C2":
               return "Defensive Caster";
            case "C3":
               return "Power Caster";
            case "S1":
               return "Luck Hybrid";
            default:
               return "Adventurer";
         }
      }

      private function buildStu() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:Object = this.r.getCategoryStats(this.uoData.sClassCat,this.uoLeaf.intLevel);
         var _loc4_:String = "";
         var _loc5_:int = 0;
         _loc5_ = 0;
         while(_loc5_ < this.r.stats.length)
         {
            _loc4_ = this.r.stats[_loc5_];
            this.stg["^" + _loc4_] = 0;
            this.stp["_" + _loc4_] = Math.floor(_loc3_[_loc4_]);
            _loc5_++;
         }
         var _loc6_:* = this.world.uoTree[this.r.sfc.myUserName.toLowerCase()];
         for(_loc1_ in _loc6_.tempSta)
         {
            if(_loc1_ != "innate")
            {
               for(_loc2_ in _loc6_.tempSta[_loc1_])
               {
                  if(this.stg["^" + _loc2_] == null)
                  {
                     this.stg["^" + _loc2_] = 0;
                  }
                  this.stg["^" + _loc2_] += int(_loc6_.tempSta[_loc1_][_loc2_]);
               }
            }
         }
      }

      private function fixValues(param1:String, param2:Number) : Array
      {
         var _loc1_:Array = [param1 == "$chi" || param1 == "$cmc" || param1 == "$tha" ? this.r.coeffToPct(param2) : this.r.coeffToPct(param2 - 1)];
         switch(param1)
         {
            case "$cai":
               _loc1_[0] *= -1;
               return param2 <= 0.2 ? [this.r.coeffToPct(1 - 0.2),"*"] : _loc1_;
            case "$cao":
               return param2 <= 0.1 ? [this.r.coeffToPct(0.1 - 1),"*"] : _loc1_;
            case "$tha":
               return param2 >= 0.5 ? [this.r.coeffToPct(1 - 0.5),"*"] : _loc1_;
            case "$cpi":
               _loc1_[0] *= -1;
               return param2 <= 0.2 ? [this.r.coeffToPct(1 - 0.2),"*"] : _loc1_;
            case "$cmi":
               _loc1_[0] *= -1;
               return param2 <= 0.2 ? [this.r.coeffToPct(1 - 0.2),"*"] : _loc1_;
            case "$cmo":
               return param2 <= 0.2 ? [this.r.coeffToPct(1 - 0.1),"*"] : _loc1_;
            case "$cdi":
               _loc1_[0] *= -1;
               return _loc1_;
            default:
               return _loc1_;
         }
      }

      private function determineColor(param1:String, param2:Number) : *
      {
         if(!this.allocated[param1])
         {
            this.allocated[param1] = param2;
            return 13421772;
         }
         var _loc1_:Number = this.fixValues(param1,param2)[0] - 1;
         var _loc2_:Number = this.fixValues(param1,this.allocated[param1])[0] - 1;
         if(param1 == "$cmc")
         {
            _loc1_ *= -1;
            _loc2_ *= -1;
         }
         if(_loc1_ < _loc2_)
         {
            return 6710886;
         }
         if(_loc1_ > _loc2_)
         {
            return 13408512;
         }
         return 13421772;
      }

      private function determineStatColor(param1:String, param2:Number) : *
      {
         var _loc1_:Number = this.stp["_" + param1] + this.stg["^" + param1];
         var _loc2_:Number = param2;
         if(_loc1_ > _loc2_)
         {
            return 6710886;
         }
         if(_loc1_ < _loc2_)
         {
            return 13408512;
         }
         return 13421772;
      }

      private function allocateBaseValues() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         if(!this.allocated)
         {
            this.allocated = new Object();
         }
         if(this.r.baseClassStats)
         {
            for(_loc2_ in this.r.baseClassStats)
            {
               this.allocated[_loc2_] = this.r.baseClassStats[_loc2_];
            }
            this.allocated["intHPMax"] = this.uoLeaf.intHPMax;
            this.r.baseClassStats = null;
            return;
         }
         var _loc3_:* = this.world.uoTree[this.r.sfc.myUserName.toLowerCase()].sta;
         for each(_loc1_ in this.tValues)
         {
            this.allocated[_loc1_] = _loc3_[_loc1_];
         }
         for each(_loc1_ in this.tCombat1Vals)
         {
            this.allocated[_loc1_] = _loc3_[_loc1_];
         }
         for each(_loc1_ in this.tCombat2Vals)
         {
            this.allocated[_loc1_] = _loc3_[_loc1_];
         }
         this.allocated["intHPMax"] = this.uoLeaf.intHPMax;
      }

      public function updateBase() : void
      {
         this.tName.text = this.uoData.strClassName;
         this.tCat.text = this.getCatDefinition();
         this.allocateBaseValues();
      }

      public function update() : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:Array = null;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:TextFormat = null;
         this.buildStu();
         var _loc12_:* = this.world.uoTree[this.r.sfc.myUserName.toLowerCase()].sta;
         var _loc13_:int = Math.floor(100 - this.world.myAvatar.getEquippedItemBySlot("Weapon").iRng);
         var _loc14_:int = 100 + this.world.myAvatar.getEquippedItemBySlot("Weapon").iRng;
         var _loc15_:Object = this.getEnhances();
         this.tCore.text = _loc13_ + "% - " + _loc14_ + "%\n" + _loc15_["Weapon"][0] + _loc15_["Weapon"][1] + (_loc15_["Weapon"][2] != "" ? ", " + _loc15_["Weapon"][2] : "") + "\n" + _loc15_["ar"][0] + _loc15_["ar"][1] + "\n" + _loc15_["ba"][0] + _loc15_["ba"][1] + (_loc15_["ba"][2] != "" ? ", " + _loc15_["ba"][2] : "") + "\n" + _loc15_["he"][0] + _loc15_["he"][1] + (_loc15_["he"][2] != "" ? ", " + _loc15_["he"][2] : "") + "\n";
         var _loc16_:int = 0;
         this.tStats.text = "";
         for each(_loc3_ in this.tStatVals)
         {
            this.tStats.appendText(this.stp["_" + _loc3_] + this.stg["^" + _loc3_] + " (" + (!_loc12_["$" + _loc3_] ? 0 : _loc12_["$" + _loc3_]) + ")\n");
            this.tStatFormats[_loc16_] = [this.tStats.text.lastIndexOf("(") + 1,this.tStats.text.lastIndexOf(")"),this.determineStatColor(_loc3_,_loc12_["$" + _loc3_])];
            _loc16_++;
         }
         this.tCombat1.text = "";
         _loc16_ = 0;
         for each(_loc4_ in this.tCombat1Vals)
         {
            if(_loc4_ == "$ap" || _loc4_ == "$sp")
            {
               _loc1_ = String(_loc12_[_loc4_]);
            }
            if(_loc4_ == "$thi")
            {
               _loc1_ = this.r.coeffToPct(Number(1 - this.r.baseMiss + _loc12_["$thi"])) + "%";
            }
            if(_loc4_ == "$tha")
            {
               _loc8_ = this.fixValues("$tha",_loc12_["$tha"]);
               _loc1_ = (_loc8_.length == 2 ? _loc8_[1] : "") + _loc8_[0] + "%";
            }
            _loc2_ = this.tCombat1.length;
            this.tCombat1.appendText(_loc1_ + "\n");
            this.tCombatFormats1[_loc16_] = [_loc2_,this.tCombat1.length,this.determineColor(_loc4_,_loc12_[_loc4_])];
            _loc16_++;
         }
         this.tCombat2.text = "";
         _loc16_ = 0;
         for each(_loc5_ in this.tCombat2Vals)
         {
            _loc2_ = this.tCombat2.length;
            this.tCombat2.appendText(this.r.coeffToPct(_loc12_[_loc5_]) + "%\n");
            this.tCombatFormats2[_loc16_] = [_loc2_,this.tCombat2.length,this.determineColor(_loc5_,_loc12_[_loc5_])];
            _loc16_++;
         }
         _loc2_ = this.tCombat2.length;
         this.tCombat2.appendText(String(this.uoLeaf.intHPMax));
         this.tCombatFormats2[_loc16_] = [_loc2_,this.tCombat2.length,this.determineColor("intHPMax",this.uoLeaf.intHPMax)];
         this.tMod.text = "";
         _loc16_ = 0;
         for each(_loc6_ in this.tValues)
         {
            _loc9_ = this.stg["^" + _loc6_] != null ? _loc12_[_loc6_] + this.stg["^" + _loc6_] : _loc12_[_loc6_];
            _loc10_ = this.fixValues(_loc6_,_loc9_);
            _loc2_ = this.tMod.length;
            this.tMod.appendText((_loc10_.length == 2 ? _loc10_[1] + _loc10_[0] : _loc10_[0]) + "%\n");
            this.tFormats[_loc16_] = [_loc2_,this.tMod.length,this.determineColor(_loc6_,_loc9_)];
            _loc16_++;
         }
         for each(_loc7_ in this.tStatFormats)
         {
            _loc11_ = this.tStats.getTextFormat(_loc7_[0],_loc7_[1]);
            _loc11_.color = _loc7_[2];
            _loc11_.leading = 4;
            this.tStats.setTextFormat(_loc11_,_loc7_[0],_loc7_[1]);
         }
         for each(_loc7_ in this.tFormats)
         {
            _loc11_ = this.tMod.getTextFormat(_loc7_[0],_loc7_[1]);
            _loc11_.color = _loc7_[2];
            _loc11_.leading = 2.6;
            this.tMod.setTextFormat(_loc11_,_loc7_[0],_loc7_[1]);
         }
         for each(_loc7_ in this.tCombatFormats1)
         {
            _loc11_ = this.tCombat1.getTextFormat(_loc7_[0],_loc7_[1]);
            _loc11_.color = _loc7_[2];
            _loc11_.leading = 2;
            this.tCombat1.setTextFormat(_loc11_,_loc7_[0],_loc7_[1]);
         }
         for each(_loc7_ in this.tCombatFormats2)
         {
            _loc11_ = this.tCombat2.getTextFormat(_loc7_[0],_loc7_[1]);
            _loc11_.color = _loc7_[2];
            _loc11_.leading = 2;
            this.tCombat2.setTextFormat(_loc11_,_loc7_[0],_loc7_[1]);
         }
         this.tCore.height = this.tCore.textHeight + 4;
         this.tStats.height = this.tStats.textHeight + 4;
         this.tCombat1.height = this.tCombat1.textHeight + 4;
         this.tCombat2.height = this.tCombat2.textHeight + 4;
         this.tMod.height = this.tMod.textHeight + 4;
      }

      private function getProc(param1:Object) : String
      {
         var _loc1_:String = "";
         if(Boolean(param1) && param1.hasOwnProperty("ProcID"))
         {
            switch(param1.ProcID)
            {
               case 2:
                  _loc1_ = "Spiral Carve";
                  break;
               case 3:
                  _loc1_ = "Awe Blast";
                  break;
               case 4:
                  _loc1_ = "Health Vamp";
                  break;
               case 5:
                  _loc1_ = "Mana Vamp";
                  break;
               case 6:
                  _loc1_ = "Powerword DIE";
                  break;
               case 7:
                  _loc1_ = "Lacerate";
                  break;
               case 8:
                  _loc1_ = "Smite";
                  break;
               case 9:
                  _loc1_ = "Valiance";
                  break;
               case 10:
                  _loc1_ = "Arcana\'s Concerto";
                  break;
               case 11:
                  _loc1_ = "Acheron";
                  break;
               case 12:
                  _loc1_ = "Elysium";
                  break;
               case 13:
                  _loc1_ = "Praxis";
                  break;
               case 14:
                  _loc1_ = "Dauntless";
                  break;
               case 15:
                  _loc1_ = "Ravenous";
                  break;
               default:
                  _loc1_ = "None";
            }
         }
         return _loc1_;
      }

      private function getEnh(param1:String) : Array
      {
         var _loc1_:* = undefined;
         var _loc2_:Array = ["None","",""];
         var _loc3_:Object = this.world.myAvatar.getEquippedItemBySlot(param1);
         _loc2_[2] = this.getProc(_loc3_);
         if(!_loc3_)
         {
            return _loc2_;
         }
         if(_loc3_.PatternID != null)
         {
            _loc1_ = this.r.world.enhPatternTree[_loc3_.PatternID];
         }
         if(_loc3_.EnhPatternID != null)
         {
            _loc1_ = this.r.world.enhPatternTree[_loc3_.EnhPatternID];
         }
         if(!_loc1_)
         {
            return _loc2_;
         }
         _loc2_[0] = _loc1_.sName;
         _loc2_[1] = _loc3_.EnhRty > 1 ? " +" + String(_loc3_.EnhRty - 1) : "";
         if(_loc1_.hasOwnProperty("DIS"))
         {
            _loc2_[0] = this.r.getDisplayEnhName(_loc1_);
            _loc2_[2] = this.r.getDisplayEnhTraitName(_loc1_);
         }
         return _loc2_;
      }

      private function getEnhances() : Object
      {
         var _loc1_:* = undefined;
         var _loc2_:Object = {
            "Weapon":[],
            "ar":[],
            "ba":[],
            "he":[]
         };
         this.r.world.initPatternTree();
         for(_loc1_ in _loc2_)
         {
            _loc2_[_loc1_] = this.getEnh(_loc1_);
         }
         return _loc2_;
      }

      private function handleMissing(param1:String) : String
      {
         return param1 == "NaN" ? "100" : param1;
      }

      private function onDrag(param1:MouseEvent) : void
      {
         this.startDrag();
      }

      private function onStop(param1:MouseEvent) : void
      {
         this.stopDrag();
      }

      public function updateBoosts() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:MovieClip = null;
         var _loc3_:* = undefined;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:MovieClip = null;
         var _loc8_:MovieClip = null;
         var _loc9_:MovieClip = null;
         var _loc10_:MovieClip = null;
         var _loc11_:* = undefined;
         while(this.bContainer.numChildren > 1)
         {
            this.bContainer.removeChildAt(1);
         }
         var _loc12_:Object = this.r.world.myAvatar.boosts;
         var _loc13_:Boolean = false;
         for each(_loc1_ in _loc12_)
         {
            if(_loc1_[0] > 0)
            {
               _loc13_ = true;
               break;
            }
         }
         this.bContainer.visible = _loc13_;
         if(!_loc13_)
         {
            return;
         }
         this.boostsObj = {};
         this.boostsObj["dmgBoost"] = "";
         for(_loc1_ in _loc12_)
         {
            _loc5_ = _loc12_[_loc1_][0];
            if(Number(_loc5_) == 0)
            {
               continue;
            }
            _loc6_ = Math.round((Number(_loc5_) - 1) * 100).toString();
            switch(_loc1_)
            {
               case "dmgall":
                  this.boostsObj["dmgBoost"] += "All +" + _loc6_ + "%\n";
                  break;
               case "undead":
                  this.boostsObj["dmgBoost"] += "Undead +" + _loc6_ + "%\n";
                  break;
               case "human":
                  this.boostsObj["dmgBoost"] += "Human +" + _loc6_ + "%\n";
                  break;
               case "chaos":
                  this.boostsObj["dmgBoost"] += "Chaos +" + _loc6_ + "%\n";
                  break;
               case "dragonkin":
                  this.boostsObj["dmgBoost"] += "Dragonkin +" + _loc6_ + "%\n";
                  break;
               case "orc":
                  this.boostsObj["dmgBoost"] += "Orc +" + _loc6_ + "%\n";
                  break;
               case "drakath":
                  this.boostsObj["dmgBoost"] += "Drakath +" + _loc6_ + "%\n";
                  break;
               case "elemental":
                  this.boostsObj["dmgBoost"] += "Elemental +" + _loc6_ + "%\n";
                  break;
               case "cp":
                  this.boostsObj["classBoost"] = "Class Points +" + _loc6_ + "%";
                  break;
               case "gold":
                  this.boostsObj["goldBoost"] = "Gold +" + _loc6_ + "%";
                  break;
               case "rep":
                  this.boostsObj["repBoost"] = "Reputation +" + _loc6_ + "%";
                  break;
               case "exp":
                  this.boostsObj["xpBoost"] = "Experience +" + _loc6_ + "%";
            }
         }
         _loc2_ = new damageBoost();
         for(_loc3_ in this.boostsObj)
         {
            switch(_loc3_)
            {
               case "dmgBoost":
                  if(this.boostsObj[_loc3_] != "")
                  {
                     this.bContainer.addChild(_loc2_);
                     _loc2_.scaleX = 0.043;
                     _loc2_.scaleY = 0.04;
                     _loc2_.name = "dmgBoost";
                     _loc2_.addEventListener(MouseEvent.MOUSE_OVER,this.onBoostGet,false,0,true);
                     _loc2_.addEventListener(MouseEvent.MOUSE_OUT,this.onBoostOut,false,0,true);
                  }
                  break;
               case "classBoost":
                  _loc7_ = new classBoost();
                  this.bContainer.addChild(_loc7_);
                  _loc7_.scaleX = 0.043;
                  _loc7_.scaleY = 0.04;
                  _loc7_.name = "classBoost";
                  _loc7_.addEventListener(MouseEvent.MOUSE_OVER,this.onBoostGet,false,0,true);
                  _loc7_.addEventListener(MouseEvent.MOUSE_OUT,this.onBoostOut,false,0,true);
                  break;
               case "goldBoost":
                  _loc8_ = new goldBoost();
                  this.bContainer.addChild(_loc8_);
                  _loc8_.scaleX = 0.043;
                  _loc8_.scaleY = 0.04;
                  _loc8_.name = "goldBoost";
                  _loc8_.addEventListener(MouseEvent.MOUSE_OVER,this.onBoostGet,false,0,true);
                  _loc8_.addEventListener(MouseEvent.MOUSE_OUT,this.onBoostOut,false,0,true);
                  break;
               case "repBoost":
                  _loc9_ = new repBoost();
                  this.bContainer.addChild(_loc9_);
                  _loc9_.scaleX = 0.043;
                  _loc9_.scaleY = 0.04;
                  _loc9_.name = "repBoost";
                  _loc9_.addEventListener(MouseEvent.MOUSE_OVER,this.onBoostGet,false,0,true);
                  _loc9_.addEventListener(MouseEvent.MOUSE_OUT,this.onBoostOut,false,0,true);
                  break;
               case "xpBoost":
                  _loc10_ = new xpBoost();
                  this.bContainer.addChild(_loc10_);
                  _loc10_.scaleX = 0.043;
                  _loc10_.scaleY = 0.04;
                  _loc10_.name = "xpBoost";
                  _loc10_.addEventListener(MouseEvent.MOUSE_OVER,this.onBoostGet,false,0,true);
                  _loc10_.addEventListener(MouseEvent.MOUSE_OUT,this.onBoostOut,false,0,true);
            }
         }
         _loc4_ = 1;
         while(_loc4_ < this.bContainer.numChildren)
         {
            _loc11_ = this.bContainer.getChildAt(_loc4_);
            if(_loc11_ is MovieClip)
            {
               _loc11_.y = 3;
               _loc11_.x = (_loc4_ - 1) * _loc11_.width + 2;
            }
            _loc4_++;
         }
      }

      private function onBoostGet(param1:MouseEvent) : void
      {
         var _loc1_:String = param1.currentTarget.name;
         this.tt.openWith({
            "str":this.boostsObj[_loc1_],
            "fromlocal":{
               "x":this.bContainer.x + this.bContainer.width / 2,
               "y":this.bContainer.y + this.bContainer.height
            }
         });
      }

      private function onBoostOut(param1:MouseEvent) : void
      {
         this.tt.close();
      }
   }
}
