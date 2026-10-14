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
         var _loc4_:SFSEvent = new SFSEvent(SFSEvent.onConnection,{"success":true});
         this.sfs.dispatchEvent(_loc4_);
      }

      public function handleApiKO(param1:Object) : void
      {
         var _loc4_:Object = {};
         _loc4_.success = false;
         _loc4_.error = "API are obsolete, please upgrade";
         var _loc1_:SFSEvent = new SFSEvent(SFSEvent.onConnection,_loc4_);
         this.sfs.dispatchEvent(_loc1_);
      }

      public function handleLoginOk(param1:Object) : void
      {
         var _loc4_:int = int(param1.body.login.@id);
         var _loc1_:int = int(param1.body.login.@mod);
         var _loc2_:String = param1.body.login.@n;
         this.sfs.amIModerator = _loc1_ == 1;
         this.sfs.myUserId = _loc4_;
         this.sfs.myUserName = _loc2_;
         this.sfs.playerId = -1;
         var _loc3_:Object = {};
         _loc3_.success = true;
         _loc3_.name = _loc2_;
         _loc3_.error = "";
         var _loc5_:SFSEvent = new SFSEvent(SFSEvent.onLogin,_loc3_);
         this.sfs.dispatchEvent(_loc5_);
         this.sfs.getRoomList();
      }

      public function handleLoginKo(param1:Object) : void
      {
         var _loc4_:Object = {};
         _loc4_.success = false;
         _loc4_.error = param1.body.login.@e;
         var _loc1_:SFSEvent = new SFSEvent(SFSEvent.onLogin,_loc4_);
         this.sfs.dispatchEvent(_loc1_);
      }

      public function handleLogout(param1:Object) : void
      {
         this.sfs.__logout();
         var _loc4_:SFSEvent = new SFSEvent(SFSEvent.onLogout,{});
         this.sfs.dispatchEvent(_loc4_);
      }

      public function handleRoomList(param1:Object) : void
      {
         var _loc1_:XML = null;
         var _loc2_:Object = null;
         var _loc3_:SFSEvent = null;
         var _loc5_:int = 0;
         var _loc6_:Room = null;
         this.sfs.clearRoomList();
         var _loc4_:Array = this.sfs.getAllRooms();
         for each(_loc1_ in param1.body.rmList.rm)
         {
            _loc5_ = int(_loc1_.@id);
            _loc6_ = new Room(_loc5_,_loc1_.n,int(_loc1_.@maxu),int(_loc1_.@maxs),_loc1_.@temp == "1",_loc1_.@game == "1",_loc1_.@priv == "1",_loc1_.@lmb == "1",int(_loc1_.@ucnt),int(_loc1_.@scnt));
            if(_loc1_.vars.toString().length > 0)
            {
               this.populateVariables(_loc6_.getVariables(),_loc1_);
            }
            _loc4_[_loc5_] = _loc6_;
         }
         _loc2_ = {};
         _loc2_.roomList = _loc4_;
         _loc3_ = new SFSEvent(SFSEvent.onRoomListUpdate,_loc2_);
         this.sfs.dispatchEvent(_loc3_);
      }

      public function handleUserCountChange(param1:Object) : void
      {
         var _loc5_:Object = null;
         var _loc6_:SFSEvent = null;
         var _loc4_:int = int(param1.body.@u);
         var _loc1_:int = int(param1.body.@s);
         var _loc2_:int = int(param1.body.@r);
         var _loc3_:Room = this.sfs.getAllRooms()[_loc2_];
         if(_loc3_ != null)
         {
            _loc3_.setUserCount(_loc4_);
            _loc3_.setSpectatorCount(_loc1_);
            _loc5_ = {};
            _loc5_.room = _loc3_;
            _loc6_ = new SFSEvent(SFSEvent.onUserCountChange,_loc5_);
            this.sfs.dispatchEvent(_loc6_);
         }
      }

      private function fakeRoomAdd(param1:int) : void
      {
         var _loc4_:int = int(param1);
         var _loc1_:String = String(param1);
         var _loc2_:int = 20;
         var _loc3_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = true;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:Room = new Room(_loc4_,_loc1_,_loc2_,_loc3_,_loc5_,_loc6_,_loc7_,_loc8_);
         var _loc10_:Array = this.sfs.getAllRooms();
         _loc10_[_loc4_] = _loc9_;
      }

      public function handleJoinOk(param1:Object) : void
      {
         var _loc6_:XML = null;
         var _loc7_:Object = null;
         var _loc8_:SFSEvent = null;
         var _loc9_:String = null;
         var _loc10_:int = 0;
         var _loc11_:Boolean = false;
         var _loc12_:Boolean = false;
         var _loc13_:int = 0;
         var _loc14_:User = null;
         var _loc4_:int = int(param1.body.@r);
         var _loc1_:XMLList = param1.body;
         var _loc2_:XMLList = param1.body.uLs.u;
         var _loc3_:int = int(param1.body.pid.@id);
         if(_loc4_ != 1)
         {
            this.fakeRoomAdd(_loc4_);
         }
         this.sfs.activeRoomId = _loc4_;
         var _loc5_:Room = this.sfs.getRoom(_loc4_);
         _loc5_.clearUserList();
         this.sfs.playerId = _loc3_;
         _loc5_.setMyPlayerIndex(_loc3_);
         if(_loc1_.vars.toString().length > 0)
         {
            _loc5_.clearVariables();
            this.populateVariables(_loc5_.getVariables(),_loc1_);
         }
         for each(_loc6_ in _loc2_)
         {
            _loc9_ = _loc6_.n;
            _loc10_ = int(_loc6_.@i);
            _loc11_ = _loc6_.@m == "1" ? true : false;
            _loc12_ = _loc6_.@s == "1" ? true : false;
            _loc13_ = _loc6_.@p == null ? -1 : int(_loc6_.@p);
            _loc14_ = new User(_loc10_,_loc9_);
            _loc14_.setModerator(_loc11_);
            _loc14_.setIsSpectator(_loc12_);
            _loc14_.setPlayerId(_loc13_);
            if(_loc6_.vars.toString().length > 0)
            {
               this.populateVariables(_loc14_.getVariables(),_loc6_);
            }
            _loc5_.addUser(_loc14_,_loc10_);
         }
         this.sfs.changingRoom = false;
         _loc7_ = {};
         _loc7_.room = _loc5_;
         _loc8_ = new SFSEvent(SFSEvent.onJoinRoom,_loc7_);
         this.sfs.dispatchEvent(_loc8_);
      }

      public function handleJoinKo(param1:Object) : void
      {
         this.sfs.changingRoom = false;
         var _loc4_:Object = {};
         _loc4_.error = param1.body.error.@msg;
         var _loc1_:SFSEvent = new SFSEvent(SFSEvent.onJoinRoomError,_loc4_);
         this.sfs.dispatchEvent(_loc1_);
      }

      public function handleUserEnterRoom(param1:Object) : void
      {
         var _loc4_:int = int(param1.body.@r);
         var _loc1_:int = int(param1.body.u.@i);
         var _loc2_:String = param1.body.u.n;
         var _loc3_:Boolean = param1.body.u.@m == "1";
         var _loc5_:Boolean = param1.body.u.@s == "1";
         var _loc6_:int = param1.body.u.@p != null ? int(param1.body.u.@p) : -1;
         var _loc7_:XMLList = param1.body.u.vars["var"];
         var _loc8_:Room = this.sfs.getRoom(_loc4_);
         var _loc9_:User = new User(_loc1_,_loc2_);
         _loc9_.setModerator(_loc3_);
         _loc9_.setIsSpectator(_loc5_);
         _loc9_.setPlayerId(_loc6_);
         _loc8_.addUser(_loc9_,_loc1_);
         if(param1.body.u.vars.toString().length > 0)
         {
            this.populateVariables(_loc9_.getVariables(),param1.body.u);
         }
         var _loc10_:Object = {};
         _loc10_.roomId = _loc4_;
         _loc10_.user = _loc9_;
         var _loc11_:SFSEvent = new SFSEvent(SFSEvent.onUserEnterRoom,_loc10_);
         this.sfs.dispatchEvent(_loc11_);
      }

      public function handleUserLeaveRoom(param1:Object) : void
      {
         var _loc7_:User = null;
         var _loc4_:int = int(param1.body.user.@id);
         var _loc1_:int = int(param1.body.@r);
         var _loc2_:Room = this.sfs.getRoom(_loc1_);
         var _loc3_:String = null;
         if(_loc2_ != null)
         {
            _loc7_ = _loc2_.getUser(_loc4_);
            if(_loc7_ != null)
            {
               _loc3_ = _loc7_.getName();
               _loc2_.removeUser(_loc4_);
            }
         }
         var _loc5_:Object = {};
         _loc5_.roomId = _loc1_;
         _loc5_.userId = _loc4_;
         _loc5_.userName = _loc3_;
         var _loc6_:SFSEvent = new SFSEvent(SFSEvent.onUserLeaveRoom,_loc5_);
         this.sfs.dispatchEvent(_loc6_);
      }

      public function handlePublicMessage(param1:Object) : void
      {
         var _loc4_:int = int(param1.body.@r);
         var _loc1_:int = int(param1.body.user.@id);
         var _loc2_:String = param1.body.txt;
         var _loc3_:User = this.sfs.getRoom(_loc4_).getUser(_loc1_);
         var _loc5_:Object = {};
         _loc5_.message = Entities.decodeEntities(_loc2_);
         _loc5_.sender = _loc3_;
         _loc5_.roomId = _loc4_;
         var _loc6_:SFSEvent = new SFSEvent(SFSEvent.onPublicMessage,_loc5_);
         this.sfs.dispatchEvent(_loc6_);
      }

      public function handlePrivateMessage(param1:Object) : void
      {
         var _loc4_:int = int(param1.body.@r);
         var _loc1_:int = int(param1.body.user.@id);
         var _loc2_:String = param1.body.txt;
         var _loc3_:User = this.sfs.getRoom(_loc4_).getUser(_loc1_);
         var _loc5_:Object = {};
         _loc5_.message = Entities.decodeEntities(_loc2_);
         _loc5_.sender = _loc3_;
         _loc5_.roomId = _loc4_;
         _loc5_.userId = _loc1_;
         var _loc6_:SFSEvent = new SFSEvent(SFSEvent.onPrivateMessage,_loc5_);
         this.sfs.dispatchEvent(_loc6_);
      }

      public function handleAdminMessage(param1:Object) : void
      {
         var _loc4_:int = int(param1.body.@r);
         var _loc1_:int = int(param1.body.user.@id);
         var _loc2_:String = param1.body.txt;
         var _loc3_:Object = {};
         _loc3_.message = Entities.decodeEntities(_loc2_);
         var _loc5_:SFSEvent = new SFSEvent(SFSEvent.onAdminMessage,_loc3_);
         this.sfs.dispatchEvent(_loc5_);
      }

      public function handleModMessage(param1:Object) : void
      {
         var _loc4_:int = int(param1.body.@r);
         var _loc1_:int = int(param1.body.user.@id);
         var _loc2_:String = param1.body.txt;
         var _loc3_:User = null;
         var _loc5_:Room = this.sfs.getRoom(_loc4_);
         if(_loc5_ != null)
         {
            _loc3_ = this.sfs.getRoom(_loc4_).getUser(_loc1_);
         }
         var _loc6_:Object = {};
         _loc6_.message = Entities.decodeEntities(_loc2_);
         _loc6_.sender = _loc3_;
         var _loc7_:SFSEvent = new SFSEvent(SFSEvent.onModeratorMessage,_loc6_);
         this.sfs.dispatchEvent(_loc7_);
      }

      public function handleASObject(param1:Object) : void
      {
         var _loc4_:int = int(param1.body.@r);
         var _loc1_:int = int(param1.body.user.@id);
         var _loc2_:String = param1.body.dataObj;
         var _loc3_:User = this.sfs.getRoom(_loc4_).getUser(_loc1_);
         var _loc5_:Object = ObjectSerializer.getInstance().deserialize(new XML(_loc2_));
         var _loc6_:Object = {};
         _loc6_.obj = _loc5_;
         _loc6_.sender = _loc3_;
         var _loc7_:SFSEvent = new SFSEvent(SFSEvent.onObjectReceived,_loc6_);
         this.sfs.dispatchEvent(_loc7_);
      }

      public function handleRoomVarsUpdate(param1:Object) : void
      {
         var _loc4_:int = int(param1.body.@r);
         var _loc1_:int = int(param1.body.user.@id);
         var _loc2_:Room = this.sfs.getRoom(_loc4_);
         var _loc3_:Array = [];
         if(param1.body.vars.toString().length > 0)
         {
            this.populateVariables(_loc2_.getVariables(),param1.body,_loc3_);
         }
         var _loc5_:Object = {};
         _loc5_.room = _loc2_;
         _loc5_.changedVars = _loc3_;
         var _loc6_:SFSEvent = new SFSEvent(SFSEvent.onRoomVariablesUpdate,_loc5_);
         this.sfs.dispatchEvent(_loc6_);
      }

      public function handleUserVarsUpdate(param1:Object) : void
      {
         var _loc1_:Array = null;
         var _loc5_:Room = null;
         var _loc6_:Object = null;
         var _loc7_:SFSEvent = null;
         var _loc4_:int = int(param1.body.user.@id);
         var _loc2_:User = null;
         var _loc3_:User = null;
         if(param1.body.vars.toString().length > 0)
         {
            for each(_loc5_ in this.sfs.getAllRooms())
            {
               _loc2_ = _loc5_.getUser(_loc4_);
               if(_loc2_ != null)
               {
                  if(_loc3_ == null)
                  {
                     _loc3_ = _loc2_;
                  }
                  _loc1_ = [];
                  this.populateVariables(_loc2_.getVariables(),param1.body,_loc1_);
               }
            }
            _loc6_ = {};
            _loc6_.user = _loc3_;
            _loc6_.changedVars = _loc1_;
            _loc7_ = new SFSEvent(SFSEvent.onUserVariablesUpdate,_loc6_);
            this.sfs.dispatchEvent(_loc7_);
         }
      }

      private function handleRoomAdded(param1:Object) : void
      {
         var _loc4_:int = int(param1.body.rm.@id);
         var _loc1_:String = param1.body.rm.name;
         var _loc2_:int = int(param1.body.rm.@max);
         var _loc3_:int = int(param1.body.rm.@spec);
         var _loc5_:Boolean = param1.body.rm.@temp == "1" ? true : false;
         var _loc6_:Boolean = param1.body.rm.@game == "1" ? true : false;
         var _loc7_:Boolean = param1.body.rm.@priv == "1" ? true : false;
         var _loc8_:Boolean = param1.body.rm.@limbo == "1" ? true : false;
         var _loc9_:Room = new Room(_loc4_,_loc1_,_loc2_,_loc3_,_loc5_,_loc6_,_loc7_,_loc8_);
         var _loc10_:Array = this.sfs.getAllRooms();
         _loc10_[_loc4_] = _loc9_;
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
         var _loc4_:int = int(param1.body.rm.@id);
         var _loc1_:Array = this.sfs.getAllRooms();
         var _loc2_:Object = {};
         _loc2_.room = _loc1_[_loc4_];
         delete _loc1_[_loc4_];
         var _loc3_:SFSEvent = new SFSEvent(SFSEvent.onRoomDeleted,_loc2_);
         this.sfs.dispatchEvent(_loc3_);
      }

      private function handleRandomKey(param1:Object) : void
      {
         var _loc4_:String = param1.body.k.toString();
         var _loc1_:Object = {};
         _loc1_.key = _loc4_;
         var _loc2_:SFSEvent = new SFSEvent(SFSEvent.onRandomKey,_loc1_);
         this.sfs.dispatchEvent(_loc2_);
      }

      private function handleRoundTripBench(param1:Object) : void
      {
         var _loc4_:int = int(getTimer());
         var _loc1_:int = _loc4_ - this.sfs.getBenchStartTime();
         var _loc2_:Object = {};
         _loc2_.elapsed = _loc1_;
         var _loc3_:SFSEvent = new SFSEvent(SFSEvent.onRoundTripResponse,_loc2_);
         this.sfs.dispatchEvent(_loc3_);
      }

      private function handleCreateRoomError(param1:Object) : void
      {
         var _loc4_:String = param1.body.room.@e;
         var _loc1_:Object = {};
         _loc1_.error = _loc4_;
         var _loc2_:SFSEvent = new SFSEvent(SFSEvent.onCreateRoomError,_loc1_);
         this.sfs.dispatchEvent(_loc2_);
      }

      private function handleBuddyList(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc6_:XML = null;
         var _loc7_:XML = null;
         var _loc8_:XMLList = null;
         var _loc9_:XML = null;
         var _loc4_:XMLList = param1.body.bList;
         var _loc1_:XMLList = param1.body.mv;
         var _loc3_:Object = {};
         var _loc5_:SFSEvent = null;
         if(_loc1_ != null && _loc1_.toString().length > 0)
         {
            for each(_loc6_ in _loc1_.v)
            {
               this.sfs.myBuddyVars[_loc6_.@n.toString()] = _loc6_.toString();
            }
         }
         if(_loc4_ != null && _loc4_.b.length != null)
         {
            if(_loc4_.toString().length > 0)
            {
               for each(_loc7_ in _loc4_.b)
               {
                  _loc2_ = {};
                  _loc2_.isOnline = _loc7_.@s == "1" ? true : false;
                  _loc2_.name = _loc7_.n.toString();
                  _loc2_.id = _loc7_.@i;
                  _loc2_.isBlocked = _loc7_.@x == "1" ? true : false;
                  _loc2_.variables = {};
                  _loc8_ = _loc7_.vs;
                  if(_loc8_.toString().length > 0)
                  {
                     for each(_loc9_ in _loc8_.v)
                     {
                        _loc2_.variables[_loc9_.@n.toString()] = _loc9_.toString();
                     }
                  }
                  this.sfs.buddyList.push(_loc2_);
               }
            }
            _loc3_.list = this.sfs.buddyList;
            _loc5_ = new SFSEvent(SFSEvent.onBuddyList,_loc3_);
            this.sfs.dispatchEvent(_loc5_);
         }
         else
         {
            _loc3_.error = param1.body.err.toString();
            _loc5_ = new SFSEvent(SFSEvent.onBuddyListError,_loc3_);
            this.sfs.dispatchEvent(_loc5_);
         }
      }

      private function handleBuddyListUpdate(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:XMLList = null;
         var _loc5_:Object = null;
         var _loc6_:Boolean = false;
         var _loc7_:String = null;
         var _loc8_:XML = null;
         var _loc4_:Object = {};
         var _loc1_:SFSEvent = null;
         if(param1.body.b != null)
         {
            _loc2_ = {};
            _loc2_.isOnline = param1.body.b.@s == "1" ? true : false;
            _loc2_.name = param1.body.b.n.toString();
            _loc2_.id = param1.body.b.@i;
            _loc2_.isBlocked = param1.body.b.@x == "1" ? true : false;
            _loc3_ = param1.body.b.vs;
            _loc5_ = null;
            _loc6_ = false;
            for(_loc7_ in this.sfs.buddyList)
            {
               _loc5_ = this.sfs.buddyList[_loc7_];
               if(_loc5_.name == _loc2_.name)
               {
                  this.sfs.buddyList[_loc7_] = _loc2_;
                  _loc2_.isBlocked = _loc5_.isBlocked;
                  _loc2_.variables = _loc5_.variables;
                  if(_loc3_.toString().length > 0)
                  {
                     for each(_loc8_ in _loc3_.v)
                     {
                        _loc2_.variables[_loc8_.@n.toString()] = _loc8_.toString();
                     }
                  }
                  _loc6_ = true;
                  break;
               }
            }
            if(_loc6_)
            {
               _loc4_.buddy = _loc2_;
               _loc1_ = new SFSEvent(SFSEvent.onBuddyListUpdate,_loc4_);
               this.sfs.dispatchEvent(_loc1_);
            }
         }
         else
         {
            _loc4_.error = param1.body.err.toString();
            _loc1_ = new SFSEvent(SFSEvent.onBuddyListError,_loc4_);
            this.sfs.dispatchEvent(_loc1_);
         }
      }

      private function handleAddBuddyPermission(param1:Object) : void
      {
         var _loc4_:Object = {};
         _loc4_.sender = param1.body.n.toString();
         _loc4_.message = "";
         if(param1.body.txt != undefined)
         {
            _loc4_.message = Entities.decodeEntities(param1.body.txt);
         }
         var _loc1_:SFSEvent = new SFSEvent(SFSEvent.onBuddyPermissionRequest,_loc4_);
         this.sfs.dispatchEvent(_loc1_);
      }

      private function handleBuddyAdded(param1:Object) : void
      {
         var _loc5_:XML = null;
         var _loc4_:Object = {};
         _loc4_.isOnline = param1.body.b.@s == "1" ? true : false;
         _loc4_.name = param1.body.b.n.toString();
         _loc4_.id = param1.body.b.@i;
         _loc4_.isBlocked = param1.body.b.@x == "1" ? true : false;
         _loc4_.variables = {};
         var _loc1_:XMLList = param1.body.b.vs;
         if(_loc1_.toString().length > 0)
         {
            for each(_loc5_ in _loc1_.v)
            {
               _loc4_.variables[_loc5_.@n.toString()] = _loc5_.toString();
            }
         }
         this.sfs.buddyList.push(_loc4_);
         var _loc2_:Object = {};
         _loc2_.list = this.sfs.buddyList;
         var _loc3_:SFSEvent = new SFSEvent(SFSEvent.onBuddyList,_loc2_);
         this.sfs.dispatchEvent(_loc3_);
      }

      private function handleRemoveBuddy(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         var _loc5_:SFSEvent = null;
         var _loc4_:String = param1.body.n.toString();
         var _loc1_:Object = null;
         for(_loc2_ in this.sfs.buddyList)
         {
            _loc1_ = this.sfs.buddyList[_loc2_];
            if(_loc1_.name == _loc4_)
            {
               delete this.sfs.buddyList[_loc2_];
               _loc3_ = {};
               _loc3_.list = this.sfs.buddyList;
               _loc5_ = new SFSEvent(SFSEvent.onBuddyList,_loc3_);
               this.sfs.dispatchEvent(_loc5_);
               break;
            }
         }
      }

      private function handleBuddyRoom(param1:Object) : void
      {
         var _loc4_:String = param1.body.br.@r;
         var _loc1_:Array = _loc4_.split(",");
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc1_[_loc2_] = int(_loc1_[_loc2_]);
            _loc2_++;
         }
         var _loc3_:Object = {};
         _loc3_.idList = _loc1_;
         var _loc5_:SFSEvent = new SFSEvent(SFSEvent.onBuddyRoom,_loc3_);
         this.sfs.dispatchEvent(_loc5_);
      }

      private function handleLeaveRoom(param1:Object) : void
      {
         var _loc4_:int = int(param1.body.rm.@id);
         var _loc1_:Object = {};
         _loc1_.roomId = _loc4_;
         var _loc2_:SFSEvent = new SFSEvent(SFSEvent.onRoomLeft,_loc1_);
         this.sfs.dispatchEvent(_loc2_);
      }

      private function handleSpectatorSwitched(param1:Object) : void
      {
         var _loc3_:int = 0;
         var _loc5_:User = null;
         var _loc6_:Object = null;
         var _loc7_:SFSEvent = null;
         var _loc4_:int = int(param1.body.@r);
         var _loc1_:int = int(param1.body.pid.@id);
         var _loc2_:Room = this.sfs.getRoom(_loc4_);
         if(_loc1_ > 0)
         {
            _loc2_.setUserCount(_loc2_.getUserCount() + 1);
            _loc2_.setSpectatorCount(_loc2_.getSpectatorCount() - 1);
         }
         if(param1.body.pid.@u != undefined)
         {
            _loc3_ = int(param1.body.pid.@u);
            _loc5_ = _loc2_.getUser(_loc3_);
            if(_loc5_ != null)
            {
               _loc5_.setIsSpectator(false);
               _loc5_.setPlayerId(_loc1_);
            }
         }
         else
         {
            this.sfs.playerId = _loc1_;
            _loc6_ = {};
            _loc6_.success = this.sfs.playerId > 0;
            _loc6_.newId = this.sfs.playerId;
            _loc6_.room = _loc2_;
            _loc7_ = new SFSEvent(SFSEvent.onSpectatorSwitched,_loc6_);
            this.sfs.dispatchEvent(_loc7_);
         }
      }

      private function populateVariables(param1:Array, param2:Object, param3:Array = null) : void
      {
         var _loc2_:XML = null;
         var _loc3_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         for each(_loc2_ in param2.vars["var"])
         {
            _loc3_ = _loc2_.@n;
            _loc5_ = _loc2_.@t;
            _loc6_ = _loc2_;
            if(param3 != null)
            {
               param3.push(_loc3_);
               param3[_loc3_] = true;
            }
            if(_loc5_ == "b")
            {
               param1[_loc3_] = _loc6_ == "1" ? true : false;
            }
            else if(_loc5_ == "n")
            {
               param1[_loc3_] = Number(_loc6_);
            }
            else if(_loc5_ == "s")
            {
               param1[_loc3_] = _loc6_;
            }
            else if(_loc5_ == "x")
            {
               delete param1[_loc3_];
            }
         }
      }

      public function dispatchDisconnection() : void
      {
         var _loc15_:SFSEvent = new SFSEvent(SFSEvent.onConnectionLost,null);
         this.sfs.dispatchEvent(_loc15_);
      }
   }
}
