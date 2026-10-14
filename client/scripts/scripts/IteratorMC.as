package
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;

   public class IteratorMC extends MovieClip
   {

      internal var objLogin:Object;

      internal var mcI:MovieClip;

      internal var rootClass:MovieClip;

      internal var iCap:int = 0;

      internal var mHiOnCT:ColorTransform = new ColorTransform();

      internal var mHiPendingCT:ColorTransform = new ColorTransform();

      internal var eventStackCenter:int;

      internal var cheatArr:* = ["/iay Artix@Battle On!","/iteratortest","/clear map","/clear quest","/clear item","/clear shop","/clear report","/moveafk ultra battleon","/killmap","/restartnow","/restart","/boost reset"];

      public function IteratorMC()
      {
         super();
         trace("setting up iterator");
      }

      public function init(param1:MovieClip, param2:MovieClip, param3:Object) : *
      {
         this.rootClass = param1;
         this.mcI = param2;
         this.mcI.cheats.cnt.iproto.visible = false;
         this.mcI.serverStack.cnt.iproto.visible = false;
         this.mcI.eventStack.cnt.iproto.visible = false;
         this.mcI.bgfx.visible = false;
         this.objLogin = param3;
         this.rootClass.serialCmd.servers = [];
         this.mHiOnCT.color = 39423;
         this.mHiPendingCT.color = 16737792;
         this.eventStackCenter = this.mcI.eventStack.y;
         this.mcI.cmd.msgBox.text = "Iterator Loaded\n";
         this.mcI.cmd.btnGo.addEventListener(MouseEvent.CLICK,this.submitClick,false,0,true);
         this.mcI.cmd.btnLogout.addEventListener(MouseEvent.CLICK,this.onLogout,false,0,true);
         this.mcI.cmd.btnSelectAll.addEventListener(MouseEvent.CLICK,this.onSelectAll,false,0,true);
         this.mcI.cmd.btnUnselectAll.addEventListener(MouseEvent.CLICK,this.onUnselectAll,false,0,true);
         this.mcI.cmd.btnSelectAll.buttonMode = true;
         this.mcI.cmd.btnUnselectAll.buttonMode = true;
         this.mcI.cmd.btnLogout.buttonMode = true;
         this.mcI.cmd.btnGo.buttonMode = true;
         this.buildCheats();
         this.buildServers();
         this.initEventStack();
      }

      public function onSelectAll(param1:MouseEvent) : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = int(this.mcI.serverStack.cnt.numChildren);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = this.mcI.serverStack.cnt.getChildAt(_loc3_) as MovieClip;
            this.serverOn(_loc1_);
            _loc3_++;
         }
      }

      public function onUnselectAll(param1:MouseEvent) : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = int(this.mcI.serverStack.cnt.numChildren);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = this.mcI.serverStack.cnt.getChildAt(_loc3_) as MovieClip;
            this.serverOff(_loc1_);
            _loc3_++;
         }
      }

      public function onLogout(param1:MouseEvent) : void
      {
         this.rootClass.serialCmdMode = false;
         (this.mcI.parent as MovieClip).gotoAndPlay("Login");
      }

      private function buildServers() : void
      {
         var _loc4_:Object = null;
         var _loc5_:MovieClip = null;
         var _loc6_:Array = this.objLogin.servers;
         var _loc2_:MovieClip = this.mcI.serverStack.cnt;
         var _loc1_:* = 0;
         var _loc3_:int = 0;
         while(_loc3_ < _loc6_.length)
         {
            _loc4_ = _loc6_[_loc3_];
            _loc5_ = _loc2_.addChild(new itProto()) as MovieClip;
            _loc5_.t1.text = _loc4_.sName;
            _loc5_.t2.text = _loc4_.sIP + ":" + _loc4_.iPort;
            _loc5_.t2.visible = false;
            _loc5_.t3.visible = false;
            _loc5_.isOn = false;
            _loc5_.server = _loc6_[_loc3_];
            _loc5_.name = "i" + _loc3_;
            _loc5_.buttonMode = true;
            _loc5_.addEventListener(MouseEvent.MOUSE_DOWN,this.onServerDown,false,0,true);
            _loc5_.addEventListener(MouseEvent.MOUSE_OVER,this.onServerOver,false,0,true);
            _loc5_.mouseChildren = false;
            _loc5_.y = this.mcI.serverStack.cnt.iproto.y - _loc1_++ * 24;
            if(_loc4_.sName.substr(0,3) == "Dev")
            {
               this.serverOff(_loc5_);
            }
            else
            {
               this.serverOn(_loc5_);
            }
            _loc3_++;
         }
      }

      private function buildCheats() : void
      {
         var _loc2_:MovieClip = null;
         var _loc6_:MovieClip = this.mcI.cheats.cnt;
         var _loc1_:int = 0;
         while(_loc1_ < this.cheatArr.length)
         {
            _loc2_ = _loc6_.addChild(new itCProto()) as MovieClip;
            _loc2_.ti.text = this.cheatArr[_loc1_];
            _loc2_.addEventListener(MouseEvent.CLICK,this.onCheatClick,false,0,true);
            _loc2_.buttonMode = true;
            _loc2_.y = this.mcI.cheats.cnt.iproto.y + _loc1_ * 21;
            _loc1_++;
         }
      }

      private function initEventStack() : void
      {
         this.mcI.eventStack.adder.addEventListener(MouseEvent.CLICK,this.onAdderClick);
         this.mcI.eventStack.adder.buttonMode = true;
      }

      private function updateEventStack() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc3_:int = 0;
         var _loc6_:MovieClip = this.mcI.eventStack.cnt;
         var _loc2_:int = _loc6_.numChildren;
         if(_loc2_ > 1)
         {
            _loc3_ = 1;
            while(_loc3_ < _loc2_)
            {
               _loc1_ = _loc6_.getChildAt(_loc3_);
               _loc1_.y = int(_loc3_ * 26);
               _loc3_++;
            }
         }
      }

      private function addToEventStack() : void
      {
         var _loc6_:MovieClip = this.mcI.eventStack.cnt;
         var _loc2_:MovieClip = _loc6_.iproto;
         var _loc1_:* = _loc2_.constructor;
         var _loc3_:MovieClip = _loc6_.addChild(new itEProto()) as MovieClip;
         _loc3_.btnAdd.addEventListener(MouseEvent.CLICK,this.onVarAddClick,false,0,true);
         _loc3_.btnDel.addEventListener(MouseEvent.CLICK,this.onVarDelClick,false,0,true);
         _loc3_.btnAdd.buttonMode = true;
         _loc3_.btnDel.buttonMode = true;
         this.updateEventStack();
      }

      private function addVarToCmd(param1:String, param2:String, param3:String) : void
      {
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:Array = null;
         var _loc3_:String = this.mcI.cmd.ti.text;
         var _loc4_:Array = this.mcI.cmd.ti.text.split(" ");
         var _loc5_:Boolean = false;
         var _loc10_:Boolean = false;
         if(_loc4_.length > 2 && _loc4_[1].toLowerCase() == param1.toLowerCase() && _loc3_.indexOf("=") > -1)
         {
            _loc7_ = _loc4_[2].split(",");
            _loc8_ = 0;
            while(_loc8_ < _loc7_.length)
            {
               _loc9_ = _loc7_[_loc8_].split("=");
               if(_loc9_[0].toLowerCase() == param2.toLowerCase())
               {
                  _loc10_ = true;
                  _loc9_[1] = param3;
                  _loc7_[_loc8_] = _loc9_.join("=");
               }
               _loc8_++;
            }
            if(!_loc10_)
            {
               _loc7_.push(param2 + "=" + param3);
            }
            _loc4_[2] = _loc7_.join(",");
            this.mcI.cmd.ti.text = "/event " + param1 + " " + _loc4_[2];
         }
         else
         {
            this.mcI.cmd.ti.text = "/event " + param1 + " " + param2 + "=" + param3;
         }
      }

      private function delVarFromCmd(param1:String, param2:String, param3:String) : void
      {
      }

      public function getServerItemByIP(param1:String, param2:Number) : MovieClip
      {
         var _loc3_:MovieClip = null;
         var _loc1_:int = int(this.mcI.serverStack.cnt.numChildren);
         var _loc4_:int = 0;
         while(_loc4_ < _loc1_)
         {
            _loc3_ = this.mcI.serverStack.cnt.getChildAt(_loc4_) as MovieClip;
            if(_loc3_.name.toLowerCase() != "iproto" && _loc3_.server != null && _loc3_.server.sIP == param1 && _loc3_.server.iPort == param2)
            {
               return _loc3_;
            }
            _loc4_++;
         }
         return null;
      }

      private function assignActiveServers() : void
      {
         var _loc1_:MovieClip = null;
         var _loc6_:int = int(this.mcI.serverStack.cnt.numChildren);
         this.rootClass.serialCmd.servers = [];
         var _loc2_:int = 0;
         while(_loc2_ < _loc6_)
         {
            _loc1_ = this.mcI.serverStack.cnt.getChildAt(_loc2_) as MovieClip;
            if(_loc1_.name != "iproto" && Boolean(_loc1_.isOn))
            {
               this.rootClass.serialCmd.servers.push(_loc1_.server);
               this.serverPending(_loc1_);
            }
            _loc2_++;
         }
      }

      private function onCheatClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         this.mcI.cmd.ti.text = _loc2_.ti.text;
      }

      private function toggleServer(param1:MovieClip) : void
      {
         if(param1.isOn)
         {
            this.serverOff(param1);
         }
         else
         {
            this.serverOn(param1);
         }
      }

      public function serverOn(param1:MovieClip) : void
      {
         param1.isOn = true;
         param1.mHi.visible = true;
         param1.mHi.transform.colorTransform = this.mHiOnCT;
      }

      public function serverOff(param1:MovieClip) : void
      {
         param1.isOn = false;
         param1.mHi.visible = false;
         param1.mHi.transform.colorTransform = this.mHiOnCT;
      }

      private function serverPending(param1:MovieClip) : void
      {
         param1.mHi.visible = true;
         param1.mHi.transform.colorTransform = this.mHiPendingCT;
      }

      public function serversOff(param1:MovieClip) : void
      {
         var _loc2_:Array = this.rootClass.serialCmd.servers;
         var _loc1_:int = 0;
         while(_loc1_ < _loc2_.length)
         {
            param1 = this.getServerItemByIP(_loc2_[_loc1_].sIP,_loc2_[_loc1_].iPort);
            if(param1 != null)
            {
               this.serverOff(param1);
            }
            _loc1_++;
         }
      }

      private function onServerDown(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         this.toggleServer(_loc2_);
      }

      private function onServerOver(param1:MouseEvent) : void
      {
         if(param1.buttonDown)
         {
            this.serverOn(param1.currentTarget as MovieClip);
         }
      }

      private function onVarAddClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget.parent as MovieClip;
         this.addVarToCmd(_loc2_.t1.text,_loc2_.t2.text,_loc2_.t3.text);
      }

      private function onVarDelClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget.parent as MovieClip;
         _loc2_.btnAdd.removeEventListener(MouseEvent.CLICK,this.onVarAddClick);
         _loc2_.btnDel.removeEventListener(MouseEvent.CLICK,this.onVarDelClick);
         this.delVarFromCmd(_loc2_.t1.text,_loc2_.t2.text,_loc2_.t3.text);
         this.mcI.eventStack.cnt.removeChild(_loc2_);
         this.updateEventStack();
      }

      private function onAdderClick(param1:MouseEvent) : void
      {
         this.addToEventStack();
      }

      private function submitClick(param1:MouseEvent) : void
      {
         if(!this.rootClass.serialCmd.active)
         {
            this.clearTimes();
            this.mcI.cmd.lastcmd.ti.text = this.mcI.cmd.ti.text;
            if(!this.mcI.cmd.lastcmd.visible)
            {
               this.mcI.cmd.lastcmd.visible = true;
            }
            this.assignActiveServers();
            this.rootClass.serialCmdInit(this.mcI.cmd.ti.text);
         }
         else
         {
            trace("serirlCmd busy!!");
         }
      }

      private function eventStackPos(param1:Event) : void
      {
         if(int(this.mcI.eventStack.y + this.mcI.eventStack.height / 2) != this.eventStackCenter)
         {
            this.mcI.eventStack.y -= (this.mcI.eventStack.y - this.mcI.eventStack.height / 2 - this.eventStackCenter) / 4;
            if(Math.abs(this.mcI.eventStack.y - this.mcI.eventStack.height / 2 - this.eventStackCenter) < 1)
            {
               this.mcI.eventStack.y = int(this.eventStackCenter + this.mcI.eventStack.height / 2);
            }
         }
      }

      private function clearTimes() : void
      {
         var _loc1_:MovieClip = null;
         var _loc6_:int = int(this.mcI.serverStack.cnt.numChildren);
         var _loc2_:int = 0;
         while(_loc2_ < _loc6_)
         {
            _loc1_ = this.mcI.serverStack.cnt.getChildAt(_loc2_) as MovieClip;
            if(_loc1_.name != "iproto" && Boolean(_loc1_.isOn))
            {
               _loc1_.t3.visible = false;
            }
            _loc2_++;
         }
      }
   }
}
