package it.gotoandplay.smartfoxserver.handlers
{
   import flash.utils.*;
   import it.gotoandplay.smartfoxserver.*;
   import it.gotoandplay.smartfoxserver.data.*;
   import it.gotoandplay.smartfoxserver.util.*;

   public class SysHandler implements IMessageHandler
   {

      private var sfs:SmartFoxClient;

      private var handlersTable:Array;

      public function SysHandler(param1:SmartFoxClient)
      {
         super();
         this.sfs = param1;
         this.handlersTable = [];
         this.handlersTable["apiOK"] = this.handleApiOK;
         this.handlersTable["apiKO"] = this.handleApiKO;
         this.handlersTable["logOK"] = this.handleLoginOk;
         this.handlersTable["logKO"] = this.handleLoginKo;
         this.handlersTable["logout"] = this.handleLogout;
         this.handlersTable["rmList"] = this.handleRoomList;
         this.handlersTable["uCount"] = this.handleUserCountChange;
         this.handlersTable["joinOK"] = this.handleJoinOk;
         this.handlersTable["joinKO"] = this.handleJoinKo;
         this.handlersTable["uER"] = this.handleUserEnterRoom;
         this.handlersTable["userGone"] = this.handleUserLeaveRoom;
         this.handlersTable["pubMsg"] = this.handlePublicMessage;
         this.handlersTable["prvMsg"] = this.handlePrivateMessage;
         this.handlersTable["dmnMsg"] = this.handleAdminMessage;
         this.handlersTable["modMsg"] = this.handleModMessage;
         this.handlersTable["dataObj"] = this.handleASObject;
         this.handlersTable["rVarsUpdate"] = this.handleRoomVarsUpdate;
         this.handlersTable["roomAdd"] = this.handleRoomAdded;
         this.handlersTable["roomDel"] = this.handleRoomDeleted;
         this.handlersTable["rndK"] = this.handleRandomKey;
         this.handlersTable["roundTripRes"] = this.handleRoundTripBench;
         this.handlersTable["uVarsUpdate"] = this.handleUserVarsUpdate;
         this.handlersTable["createRmKO"] = this.handleCreateRoomError;
         this.handlersTable["bList"] = this.handleBuddyList;
         this.handlersTable["bUpd"] = this.handleBuddyListUpdate;
         this.handlersTable["bAdd"] = this.handleBuddyAdded;
         this.handlersTable["roomB"] = this.handleBuddyRoom;
         this.handlersTable["leaveRoom"] = this.handleLeaveRoom;
         this.handlersTable["swSpec"] = this.handleSpectatorSwitched;
         this.handlersTable["bPrm"] = this.handleAddBuddyPermission;
         this.handlersTable["remB"] = this.handleRemoveBuddy;
      }

      public function handleMessage(param1:Object, param2:String) : void
      {
         var _loc1_:XML = param1 as XML;
         var _loc2_:String = _loc1_.body.@action;
         var _loc3_:Function = this.handlersTable[_loc2_];
         if(_loc3_ != null)
         {
            _loc3_.apply(this,[param1]);
         }
         else
         {
            trace("[Net] ERR unknown sys command: " + _loc2_);
         }
      }

      public function handleApiOK(param1:Object) : void
      {
         this.sfs.isConnected = true;
         var _loc1_:SFSEvent = new SFSEvent(SFSEvent.onConnection,{"success":true});
         this.sfs.dispatchEvent(_loc1_);
      }

      public function handleApiKO(param1:Object) : void
      {
         var _loc1_:Object = {};
         _loc1_.success = false;
         _loc1_.error = "API are obsolete, please upgrade";
         var _loc2_:SFSEvent = new SFSEvent(SFSEvent.onConnection,_loc1_);
         this.sfs.dispatchEvent(_loc2_);
      }

      public function handleLoginOk(param1:Object) : void
      {
         var _loc1_:int = int(param1.body.login.@id);
         var _loc2_:int = int(param1.body.login.@mod);
         var _loc3_:String = param1.body.login.@n;
         this.sfs.amIModerator = _loc2_ == 1;
         this.sfs.myUserId = _loc1_;
         this.sfs.myUserName = _loc3_;
         this.sfs.playerId = -1;
         var _loc4_:Object = {};
         _loc4_.success = true;
         _loc4_.name = _loc3_;
         _loc4_.error = "";
         var _loc5_:SFSEvent = new SFSEvent(SFSEvent.onLogin,_loc4_);
         this.sfs.dispatchEvent(_loc5_);
         this.sfs.getRoomList();
      }

      public function handleLoginKo(param1:Object) : void
      {
         var _loc1_:Object = {};
         _loc1_.success = false;
         _loc1_.error = param1.body.login.@e;
         var _loc2_:SFSEvent = new SFSEvent(SFSEvent.onLogin,_loc1_);
         this.sfs.dispatchEvent(_loc2_);
      }

      public function handleLogout(param1:Object) : void
      {
         this.sfs.__logout();
         var _loc1_:SFSEvent = new SFSEvent(SFSEvent.onLogout,{});
         this.sfs.dispatchEvent(_loc1_);
      }

      public function handleRoomList(param1:Object) : void
      {
         var _loc1_:XML = null;
         var _loc2_:Object = null;
         var _loc3_:SFSEvent = null;
         var _loc4_:int = 0;
         var _loc5_:Room = null;
         this.sfs.clearRoomList();
         var _loc6_:Array = this.sfs.getAllRooms();
         for each(_loc1_ in param1.body.rmList.rm)
         {
            _loc4_ = int(_loc1_.@id);
            _loc5_ = new Room(_loc4_,_loc1_.n,int(_loc1_.@maxu),int(_loc1_.@maxs),_loc1_.@temp == "1",_loc1_.@game == "1",_loc1_.@priv == "1",_loc1_.@lmb == "1",int(_loc1_.@ucnt),int(_loc1_.@scnt));
            if(_loc1_.vars.toString().length > 0)
            {
               this.populateVariables(_loc5_.getVariables(),_loc1_);
            }
            _loc6_[_loc4_] = _loc5_;
         }
         _loc2_ = {};
         _loc2_.roomList = _loc6_;
         _loc3_ = new SFSEvent(SFSEvent.onRoomListUpdate,_loc2_);
         this.sfs.dispatchEvent(_loc3_);
      }

      public function handleUserCountChange(param1:Object) : void
      {
         var _loc1_:Object = null;
         var _loc2_:SFSEvent = null;
         var _loc3_:int = int(param1.body.@u);
         var _loc4_:int = int(param1.body.@s);
         var _loc5_:int = int(param1.body.@r);
         var _loc6_:Room = this.sfs.getAllRooms()[_loc5_];
         if(_loc6_ != null)
         {
            _loc6_.setUserCount(_loc3_);
            _loc6_.setSpectatorCount(_loc4_);
            _loc1_ = {};
            _loc1_.room = _loc6_;
            _loc2_ = new SFSEvent(SFSEvent.onUserCountChange,_loc1_);
            this.sfs.dispatchEvent(_loc2_);
         }
      }

      private function fakeRoomAdd(param1:int) : void
      {
         var _loc1_:int = int(param1);
         var _loc2_:String = String(param1);
         var _loc3_:int = 20;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = true;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:Room = new Room(_loc1_,_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_);
         var _loc10_:Array = this.sfs.getAllRooms();
         _loc10_[_loc1_] = _loc9_;
      }

      public function handleJoinOk(param1:Object) : void
      {
         var _loc1_:XML = null;
         var _loc2_:Object = null;
         var _loc3_:SFSEvent = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         var _loc9_:User = null;
         var _loc10_:int = int(param1.body.@r);
         var _loc11_:XMLList = param1.body;
         var _loc12_:XMLList = param1.body.uLs.u;
         var _loc13_:int = int(param1.body.pid.@id);
         if(_loc10_ != 1)
         {
            this.fakeRoomAdd(_loc10_);
         }
         this.sfs.activeRoomId = _loc10_;
         var _loc14_:Room = this.sfs.getRoom(_loc10_);
         _loc14_.clearUserList();
         this.sfs.playerId = _loc13_;
         _loc14_.setMyPlayerIndex(_loc13_);
         if(_loc11_.vars.toString().length > 0)
         {
            _loc14_.clearVariables();
            this.populateVariables(_loc14_.getVariables(),_loc11_);
         }
         for each(_loc1_ in _loc12_)
         {
            _loc4_ = _loc1_.n;
            _loc5_ = int(_loc1_.@i);
            _loc6_ = _loc1_.@m == "1" ? true : false;
            _loc7_ = _loc1_.@s == "1" ? true : false;
            _loc8_ = _loc1_.@p == null ? -1 : int(_loc1_.@p);
            _loc9_ = new User(_loc5_,_loc4_);
            _loc9_.setModerator(_loc6_);
            _loc9_.setIsSpectator(_loc7_);
            _loc9_.setPlayerId(_loc8_);
            if(_loc1_.vars.toString().length > 0)
            {
               this.populateVariables(_loc9_.getVariables(),_loc1_);
            }
            _loc14_.addUser(_loc9_,_loc5_);
         }
         this.sfs.changingRoom = false;
         _loc2_ = {};
         _loc2_.room = _loc14_;
         _loc3_ = new SFSEvent(SFSEvent.onJoinRoom,_loc2_);
         this.sfs.dispatchEvent(_loc3_);
      }

      public function handleJoinKo(param1:Object) : void
      {
         this.sfs.changingRoom = false;
         var _loc1_:Object = {};
         _loc1_.error = param1.body.error.@msg;
         var _loc2_:SFSEvent = new SFSEvent(SFSEvent.onJoinRoomError,_loc1_);
         this.sfs.dispatchEvent(_loc2_);
      }

      public function handleUserEnterRoom(param1:Object) : void
      {
         var _loc1_:int = int(param1.body.@r);
         var _loc2_:int = int(param1.body.u.@i);
         var _loc3_:String = param1.body.u.n;
         var _loc4_:Boolean = param1.body.u.@m == "1";
         var _loc5_:Boolean = param1.body.u.@s == "1";
         var _loc6_:int = param1.body.u.@p != null ? int(param1.body.u.@p) : -1;
         var _loc7_:XMLList = param1.body.u.vars["var"];
         var _loc8_:Room = this.sfs.getRoom(_loc1_);
         var _loc9_:User = new User(_loc2_,_loc3_);
         _loc9_.setModerator(_loc4_);
         _loc9_.setIsSpectator(_loc5_);
         _loc9_.setPlayerId(_loc6_);
         _loc8_.addUser(_loc9_,_loc2_);
         if(param1.body.u.vars.toString().length > 0)
         {
            this.populateVariables(_loc9_.getVariables(),param1.body.u);
         }
         var _loc10_:Object = {};
         _loc10_.roomId = _loc1_;
         _loc10_.user = _loc9_;
         var _loc11_:SFSEvent = new SFSEvent(SFSEvent.onUserEnterRoom,_loc10_);
         this.sfs.dispatchEvent(_loc11_);
      }

      public function handleUserLeaveRoom(param1:Object) : void
      {
         var _loc1_:User = null;
         var _loc2_:int = int(param1.body.user.@id);
         var _loc3_:int = int(param1.body.@r);
         var _loc4_:Room = this.sfs.getRoom(_loc3_);
         var _loc5_:String = null;
         if(_loc4_ != null)
         {
            _loc1_ = _loc4_.getUser(_loc2_);
            if(_loc1_ != null)
            {
               _loc5_ = _loc1_.getName();
               _loc4_.removeUser(_loc2_);
            }
         }
         var _loc6_:Object = {};
         _loc6_.roomId = _loc3_;
         _loc6_.userId = _loc2_;
         _loc6_.userName = _loc5_;
         var _loc7_:SFSEvent = new SFSEvent(SFSEvent.onUserLeaveRoom,_loc6_);
         this.sfs.dispatchEvent(_loc7_);
      }

      public function handlePublicMessage(param1:Object) : void
      {
         var _loc1_:int = int(param1.body.@r);
         var _loc2_:int = int(param1.body.user.@id);
         var _loc3_:String = param1.body.txt;
         var _loc4_:User = this.sfs.getRoom(_loc1_).getUser(_loc2_);
         var _loc5_:Object = {};
         _loc5_.message = Entities.decodeEntities(_loc3_);
         _loc5_.sender = _loc4_;
         _loc5_.roomId = _loc1_;
         var _loc6_:SFSEvent = new SFSEvent(SFSEvent.onPublicMessage,_loc5_);
         this.sfs.dispatchEvent(_loc6_);
      }

      public function handlePrivateMessage(param1:Object) : void
      {
         var _loc1_:int = int(param1.body.@r);
         var _loc2_:int = int(param1.body.user.@id);
         var _loc3_:String = param1.body.txt;
         var _loc4_:User = this.sfs.getRoom(_loc1_).getUser(_loc2_);
         var _loc5_:Object = {};
         _loc5_.message = Entities.decodeEntities(_loc3_);
         _loc5_.sender = _loc4_;
         _loc5_.roomId = _loc1_;
         _loc5_.userId = _loc2_;
         var _loc6_:SFSEvent = new SFSEvent(SFSEvent.onPrivateMessage,_loc5_);
         this.sfs.dispatchEvent(_loc6_);
      }

      public function handleAdminMessage(param1:Object) : void
      {
         var _loc1_:int = int(param1.body.@r);
         var _loc2_:int = int(param1.body.user.@id);
         var _loc3_:String = param1.body.txt;
         var _loc4_:Object = {};
         _loc4_.message = Entities.decodeEntities(_loc3_);
         var _loc5_:SFSEvent = new SFSEvent(SFSEvent.onAdminMessage,_loc4_);
         this.sfs.dispatchEvent(_loc5_);
      }

      public function handleModMessage(param1:Object) : void
      {
         var _loc1_:int = int(param1.body.@r);
         var _loc2_:int = int(param1.body.user.@id);
         var _loc3_:String = param1.body.txt;
         var _loc4_:User = null;
         var _loc5_:Room = this.sfs.getRoom(_loc1_);
         if(_loc5_ != null)
         {
            _loc4_ = this.sfs.getRoom(_loc1_).getUser(_loc2_);
         }
         var _loc6_:Object = {};
         _loc6_.message = Entities.decodeEntities(_loc3_);
         _loc6_.sender = _loc4_;
         var _loc7_:SFSEvent = new SFSEvent(SFSEvent.onModeratorMessage,_loc6_);
         this.sfs.dispatchEvent(_loc7_);
      }

      public function handleASObject(param1:Object) : void
      {
         var _loc1_:int = int(param1.body.@r);
         var _loc2_:int = int(param1.body.user.@id);
         var _loc3_:String = param1.body.dataObj;
         var _loc4_:User = this.sfs.getRoom(_loc1_).getUser(_loc2_);
         var _loc5_:Object = ObjectSerializer.getInstance().deserialize(new XML(_loc3_));
         var _loc6_:Object = {};
         _loc6_.obj = _loc5_;
         _loc6_.sender = _loc4_;
         var _loc7_:SFSEvent = new SFSEvent(SFSEvent.onObjectReceived,_loc6_);
         this.sfs.dispatchEvent(_loc7_);
      }

      public function handleRoomVarsUpdate(param1:Object) : void
      {
         var _loc1_:int = int(param1.body.@r);
         var _loc2_:int = int(param1.body.user.@id);
         var _loc3_:Room = this.sfs.getRoom(_loc1_);
         var _loc4_:Array = [];
         if(param1.body.vars.toString().length > 0)
         {
            this.populateVariables(_loc3_.getVariables(),param1.body,_loc4_);
         }
         var _loc5_:Object = {};
         _loc5_.room = _loc3_;
         _loc5_.changedVars = _loc4_;
         var _loc6_:SFSEvent = new SFSEvent(SFSEvent.onRoomVariablesUpdate,_loc5_);
         this.sfs.dispatchEvent(_loc6_);
      }

      public function handleUserVarsUpdate(param1:Object) : void
      {
         var _loc1_:Array = null;
         var _loc2_:Room = null;
         var _loc3_:Object = null;
         var _loc4_:SFSEvent = null;
         var _loc5_:int = int(param1.body.user.@id);
         var _loc6_:User = null;
         var _loc7_:User = null;
         if(param1.body.vars.toString().length > 0)
         {
            for each(_loc2_ in this.sfs.getAllRooms())
            {
               _loc6_ = _loc2_.getUser(_loc5_);
               if(_loc6_ != null)
               {
                  if(_loc7_ == null)
                  {
                     _loc7_ = _loc6_;
                  }
                  _loc1_ = [];
                  this.populateVariables(_loc6_.getVariables(),param1.body,_loc1_);
               }
            }
            _loc3_ = {};
            _loc3_.user = _loc7_;
            _loc3_.changedVars = _loc1_;
            _loc4_ = new SFSEvent(SFSEvent.onUserVariablesUpdate,_loc3_);
            this.sfs.dispatchEvent(_loc4_);
         }
      }

      private function handleRoomAdded(param1:Object) : void
      {
         var _loc1_:int = int(param1.body.rm.@id);
         var _loc2_:String = param1.body.rm.name;
         var _loc3_:int = int(param1.body.rm.@max);
         var _loc4_:int = int(param1.body.rm.@spec);
         var _loc5_:Boolean = param1.body.rm.@temp == "1" ? true : false;
         var _loc6_:Boolean = param1.body.rm.@game == "1" ? true : false;
         var _loc7_:Boolean = param1.body.rm.@priv == "1" ? true : false;
         var _loc8_:Boolean = param1.body.rm.@limbo == "1" ? true : false;
         var _loc9_:Room = new Room(_loc1_,_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_);
         var _loc10_:Array = this.sfs.getAllRooms();
         _loc10_[_loc1_] = _loc9_;
         if(param1.body.rm.vars.toString().length > 0)
         {
            this.populateVariables(_loc9_.getVariables(),param1.body.rm);
         }
         var _loc11_:Object = {};
         _loc11_.room = _loc9_;
         var _loc12_:SFSEvent = new SFSEvent(SFSEvent.onRoomAdded,_loc11_);
         this.sfs.dispatchEvent(_loc12_);
      }

      private function handleRoomDeleted(param1:Object) : void
      {
         var _loc1_:int = int(param1.body.rm.@id);
         var _loc2_:Array = this.sfs.getAllRooms();
         var _loc3_:Object = {};
         _loc3_.room = _loc2_[_loc1_];
         delete _loc2_[_loc1_];
         var _loc4_:SFSEvent = new SFSEvent(SFSEvent.onRoomDeleted,_loc3_);
         this.sfs.dispatchEvent(_loc4_);
      }

      private function handleRandomKey(param1:Object) : void
      {
         var _loc1_:String = param1.body.k.toString();
         var _loc2_:Object = {};
         _loc2_.key = _loc1_;
         var _loc3_:SFSEvent = new SFSEvent(SFSEvent.onRandomKey,_loc2_);
         this.sfs.dispatchEvent(_loc3_);
      }

      private function handleRoundTripBench(param1:Object) : void
      {
         var _loc1_:int = int(getTimer());
         var _loc2_:int = _loc1_ - this.sfs.getBenchStartTime();
         var _loc3_:Object = {};
         _loc3_.elapsed = _loc2_;
         var _loc4_:SFSEvent = new SFSEvent(SFSEvent.onRoundTripResponse,_loc3_);
         this.sfs.dispatchEvent(_loc4_);
      }

      private function handleCreateRoomError(param1:Object) : void
      {
         var _loc1_:String = param1.body.room.@e;
         var _loc2_:Object = {};
         _loc2_.error = _loc1_;
         var _loc3_:SFSEvent = new SFSEvent(SFSEvent.onCreateRoomError,_loc2_);
         this.sfs.dispatchEvent(_loc3_);
      }

      private function handleBuddyList(param1:Object) : void
      {
         var _loc1_:Object = null;
         var _loc2_:XML = null;
         var _loc3_:XML = null;
         var _loc4_:XMLList = null;
         var _loc5_:XML = null;
         var _loc6_:XMLList = param1.body.bList;
         var _loc7_:XMLList = param1.body.mv;
         var _loc8_:Object = {};
         var _loc9_:SFSEvent = null;
         if(_loc7_ != null && _loc7_.toString().length > 0)
         {
            for each(_loc2_ in _loc7_.v)
            {
               this.sfs.myBuddyVars[_loc2_.@n.toString()] = _loc2_.toString();
            }
         }
         if(_loc6_ != null && _loc6_.b.length != null)
         {
            if(_loc6_.toString().length > 0)
            {
               for each(_loc3_ in _loc6_.b)
               {
                  _loc1_ = {};
                  _loc1_.isOnline = _loc3_.@s == "1" ? true : false;
                  _loc1_.name = _loc3_.n.toString();
                  _loc1_.id = _loc3_.@i;
                  _loc1_.isBlocked = _loc3_.@x == "1" ? true : false;
                  _loc1_.variables = {};
                  _loc4_ = _loc3_.vs;
                  if(_loc4_.toString().length > 0)
                  {
                     for each(_loc5_ in _loc4_.v)
                     {
                        _loc1_.variables[_loc5_.@n.toString()] = _loc5_.toString();
                     }
                  }
                  this.sfs.buddyList.push(_loc1_);
               }
            }
            _loc8_.list = this.sfs.buddyList;
            _loc9_ = new SFSEvent(SFSEvent.onBuddyList,_loc8_);
            this.sfs.dispatchEvent(_loc9_);
         }
         else
         {
            _loc8_.error = param1.body.err.toString();
            _loc9_ = new SFSEvent(SFSEvent.onBuddyListError,_loc8_);
            this.sfs.dispatchEvent(_loc9_);
         }
      }

      private function handleBuddyListUpdate(param1:Object) : void
      {
         var _loc1_:Object = null;
         var _loc2_:XMLList = null;
         var _loc3_:Object = null;
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         var _loc6_:XML = null;
         var _loc7_:Object = {};
         var _loc8_:SFSEvent = null;
         if(param1.body.b != null)
         {
            _loc1_ = {};
            _loc1_.isOnline = param1.body.b.@s == "1" ? true : false;
            _loc1_.name = param1.body.b.n.toString();
            _loc1_.id = param1.body.b.@i;
            _loc1_.isBlocked = param1.body.b.@x == "1" ? true : false;
            _loc2_ = param1.body.b.vs;
            _loc3_ = null;
            _loc4_ = false;
            for(_loc5_ in this.sfs.buddyList)
            {
               _loc3_ = this.sfs.buddyList[_loc5_];
               if(_loc3_.name == _loc1_.name)
               {
                  this.sfs.buddyList[_loc5_] = _loc1_;
                  _loc1_.isBlocked = _loc3_.isBlocked;
                  _loc1_.variables = _loc3_.variables;
                  if(_loc2_.toString().length > 0)
                  {
                     for each(_loc6_ in _loc2_.v)
                     {
                        _loc1_.variables[_loc6_.@n.toString()] = _loc6_.toString();
                     }
                  }
                  _loc4_ = true;
                  break;
               }
            }
            if(_loc4_)
            {
               _loc7_.buddy = _loc1_;
               _loc8_ = new SFSEvent(SFSEvent.onBuddyListUpdate,_loc7_);
               this.sfs.dispatchEvent(_loc8_);
            }
         }
         else
         {
            _loc7_.error = param1.body.err.toString();
            _loc8_ = new SFSEvent(SFSEvent.onBuddyListError,_loc7_);
            this.sfs.dispatchEvent(_loc8_);
         }
      }

      private function handleAddBuddyPermission(param1:Object) : void
      {
         var _loc1_:Object = {};
         _loc1_.sender = param1.body.n.toString();
         _loc1_.message = "";
         if(param1.body.txt != undefined)
         {
            _loc1_.message = Entities.decodeEntities(param1.body.txt);
         }
         var _loc2_:SFSEvent = new SFSEvent(SFSEvent.onBuddyPermissionRequest,_loc1_);
         this.sfs.dispatchEvent(_loc2_);
      }

      private function handleBuddyAdded(param1:Object) : void
      {
         var _loc1_:XML = null;
         var _loc2_:Object = {};
         _loc2_.isOnline = param1.body.b.@s == "1" ? true : false;
         _loc2_.name = param1.body.b.n.toString();
         _loc2_.id = param1.body.b.@i;
         _loc2_.isBlocked = param1.body.b.@x == "1" ? true : false;
         _loc2_.variables = {};
         var _loc3_:XMLList = param1.body.b.vs;
         if(_loc3_.toString().length > 0)
         {
            for each(_loc1_ in _loc3_.v)
            {
               _loc2_.variables[_loc1_.@n.toString()] = _loc1_.toString();
            }
         }
         this.sfs.buddyList.push(_loc2_);
         var _loc4_:Object = {};
         _loc4_.list = this.sfs.buddyList;
         var _loc5_:SFSEvent = new SFSEvent(SFSEvent.onBuddyList,_loc4_);
         this.sfs.dispatchEvent(_loc5_);
      }

      private function handleRemoveBuddy(param1:Object) : void
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         var _loc3_:SFSEvent = null;
         var _loc4_:String = param1.body.n.toString();
         var _loc5_:Object = null;
         for(_loc1_ in this.sfs.buddyList)
         {
            _loc5_ = this.sfs.buddyList[_loc1_];
            if(_loc5_.name == _loc4_)
            {
               delete this.sfs.buddyList[_loc1_];
               _loc2_ = {};
               _loc2_.list = this.sfs.buddyList;
               _loc3_ = new SFSEvent(SFSEvent.onBuddyList,_loc2_);
               this.sfs.dispatchEvent(_loc3_);
               break;
            }
         }
      }

      private function handleBuddyRoom(param1:Object) : void
      {
         var _loc1_:String = param1.body.br.@r;
         var _loc2_:Array = _loc1_.split(",");
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc2_[_loc3_] = int(_loc2_[_loc3_]);
            _loc3_++;
         }
         var _loc4_:Object = {};
         _loc4_.idList = _loc2_;
         var _loc5_:SFSEvent = new SFSEvent(SFSEvent.onBuddyRoom,_loc4_);
         this.sfs.dispatchEvent(_loc5_);
      }

      private function handleLeaveRoom(param1:Object) : void
      {
         var _loc1_:int = int(param1.body.rm.@id);
         var _loc2_:Object = {};
         _loc2_.roomId = _loc1_;
         var _loc3_:SFSEvent = new SFSEvent(SFSEvent.onRoomLeft,_loc2_);
         this.sfs.dispatchEvent(_loc3_);
      }

      private function handleSpectatorSwitched(param1:Object) : void
      {
         var _loc1_:int = 0;
         var _loc2_:User = null;
         var _loc3_:Object = null;
         var _loc4_:SFSEvent = null;
         var _loc5_:int = int(param1.body.@r);
         var _loc6_:int = int(param1.body.pid.@id);
         var _loc7_:Room = this.sfs.getRoom(_loc5_);
         if(_loc6_ > 0)
         {
            _loc7_.setUserCount(_loc7_.getUserCount() + 1);
            _loc7_.setSpectatorCount(_loc7_.getSpectatorCount() - 1);
         }
         if(param1.body.pid.@u != undefined)
         {
            _loc1_ = int(param1.body.pid.@u);
            _loc2_ = _loc7_.getUser(_loc1_);
            if(_loc2_ != null)
            {
               _loc2_.setIsSpectator(false);
               _loc2_.setPlayerId(_loc6_);
            }
         }
         else
         {
            this.sfs.playerId = _loc6_;
            _loc3_ = {};
            _loc3_.success = this.sfs.playerId > 0;
            _loc3_.newId = this.sfs.playerId;
            _loc3_.room = _loc7_;
            _loc4_ = new SFSEvent(SFSEvent.onSpectatorSwitched,_loc3_);
            this.sfs.dispatchEvent(_loc4_);
         }
      }

      private function populateVariables(param1:Array, param2:Object, param3:Array = null) : void
      {
         var _loc1_:XML = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         for each(_loc1_ in param2.vars["var"])
         {
            _loc2_ = _loc1_.@n;
            _loc3_ = _loc1_.@t;
            _loc4_ = _loc1_;
            if(param3 != null)
            {
               param3.push(_loc2_);
               param3[_loc2_] = true;
            }
            if(_loc3_ == "b")
            {
               param1[_loc2_] = _loc4_ == "1" ? true : false;
            }
            else if(_loc3_ == "n")
            {
               param1[_loc2_] = Number(_loc4_);
            }
            else if(_loc3_ == "s")
            {
               param1[_loc2_] = _loc4_;
            }
            else if(_loc3_ == "x")
            {
               delete param1[_loc2_];
            }
         }
      }

      public function dispatchDisconnection() : void
      {
         var _loc1_:SFSEvent = new SFSEvent(SFSEvent.onConnectionLost,null);
         this.sfs.dispatchEvent(_loc1_);
      }
   }
}
