package it.gotoandplay.smartfoxserver
{
   import flash.events.*;
   import flash.net.*;
   import flash.system.*;
   import flash.utils.*;
   import it.gotoandplay.smartfoxserver.data.Room;
   import it.gotoandplay.smartfoxserver.data.User;
   import it.gotoandplay.smartfoxserver.handlers.*;
   import it.gotoandplay.smartfoxserver.http.*;
   import it.gotoandplay.smartfoxserver.util.*;

   public class SmartFoxClient extends EventDispatcher
   {

      private static var b64:Vector.<int>;

      private static const EOM:int = 0;

      private static const MSG_XML:String = "<";

      private static const MSG_JSON:String = "{";

      private static var MSG_STR:String = "%";

      private static var MIN_POLL_SPEED:Number = 0;

      private static var DEFAULT_POLL_SPEED:Number = 750;

      private static var MAX_POLL_SPEED:Number = 10000;

      private static var HTTP_POLL_REQUEST:String = "poll";

      public static const MODMSG_TO_USER:String = "u";

      public static const MODMSG_TO_ROOM:String = "r";

      public static const MODMSG_TO_ZONE:String = "z";

      public static const XTMSG_TYPE_XML:String = "xml";

      public static const XTMSG_TYPE_STR:String = "str";

      public static const XTMSG_TYPE_JSON:String = "json";

      public static const CONNECTION_MODE_DISCONNECTED:String = "disconnected";

      public static const CONNECTION_MODE_SOCKET:String = "socket";

      public static const CONNECTION_MODE_HTTP:String = "http";

      public var sfsOS:String = Capabilities.os.toLowerCase();

      public var onLinux:Boolean = this.sfsOS.indexOf("linux") > -1 ? true : false;

      private var roomList:Array;

      private var connected:Boolean;

      private var discGen:int = 0;

      private var benchStartTime:int;

      private var sysHandler:SysHandler;

      private var extHandler:ExtHandler;

      private var majVersion:Number;

      private var minVersion:Number;

      private var subVersion:Number;

      private var messageHandlers:Array;

      private var socketConnection:Socket;

      private var byteBuffer:ByteArray;

      private var socketChunk:ByteArray = new ByteArray();

      private var autoConnectOnConfigSuccess:Boolean = false;

      public var ipAddress:String;

      public var port:int = 9339;

      public var defaultZone:String;

      private var isHttpMode:Boolean = false;

      private var _httpPollSpeed:int = DEFAULT_POLL_SPEED;

      private var httpConnection:HttpConnection;

      public var blueBoxIpAddress:String;

      public var blueBoxPort:Number = 0;

      public var smartConnect:Boolean = true;

      public var buddyList:Array;

      public var myBuddyVars:Array;

      public var debug:Boolean;

      public var myUserId:int;

      public var myUserName:String;

      public var playerId:int;

      public var amIModerator:Boolean;

      public var activeRoomId:int;

      public var changingRoom:Boolean;

      public var httpPort:int = 8080;

      public var properties:Object = null;

      public function SmartFoxClient(param1:Boolean = false)
      {
         super();
         this.majVersion = 1;
         this.minVersion = 5;
         this.subVersion = 7;
         this.activeRoomId = -1;
         this.debug = param1;
         this.messageHandlers = [];
         this.setupMessageHandlers();
         this.socketConnection = new Socket();
         this.socketConnection.addEventListener(Event.CONNECT,this.handleSocketConnection);
         this.socketConnection.addEventListener(Event.CLOSE,this.handleSocketDisconnection);
         this.socketConnection.addEventListener(ProgressEvent.SOCKET_DATA,this.handleSocketData);
         this.socketConnection.addEventListener(IOErrorEvent.IO_ERROR,this.handleIOError);
         this.socketConnection.addEventListener(IOErrorEvent.NETWORK_ERROR,this.handleIOError);
         this.socketConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleSecurityError);
         this.httpConnection = new HttpConnection();
         this.httpConnection.addEventListener(HttpEvent.onHttpConnect,this.handleHttpConnect);
         this.httpConnection.addEventListener(HttpEvent.onHttpClose,this.handleHttpClose);
         this.httpConnection.addEventListener(HttpEvent.onHttpData,this.handleHttpData);
         this.httpConnection.addEventListener(HttpEvent.onHttpError,this.handleHttpError);
         this.byteBuffer = new ByteArray();
      }

      private static function unpack(param1:String) : String
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         var _loc3_:int = 0;
         if(b64 == null)
         {
            b64 = new Vector.<int>(256,true);
            _loc2_ = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
            _loc3_ = 0;
            while(_loc3_ < 64)
            {
               b64[_loc2_.charCodeAt(_loc3_)] = _loc3_;
               _loc3_++;
            }
         }
         var _loc4_:* = param1.length;
         while(_loc4_ > 1 && param1.charCodeAt(_loc4_ - 1) == 61)
         {
            _loc4_--;
         }
         var _loc5_:ByteArray = new ByteArray();
         _loc5_.length = int((_loc4_ - 1) * 3 / 4) + 3;
         var _loc6_:* = 0;
         var _loc7_:int = 1;
         while(_loc7_ + 3 < _loc4_)
         {
            _loc1_ = b64[param1.charCodeAt(_loc7_)] << 18 | b64[param1.charCodeAt(_loc7_ + 1)] << 12 | b64[param1.charCodeAt(_loc7_ + 2)] << 6 | b64[param1.charCodeAt(_loc7_ + 3)];
            var _loc8_:Number;
            _loc5_[_loc8_ = _loc6_++] = _loc1_ >> 16;
            var _loc9_:Number;
            _loc5_[_loc9_ = _loc6_++] = _loc1_ >> 8 & 0xFF;
            var _loc10_:Number;
            _loc5_[_loc10_ = _loc6_++] = _loc1_ & 0xFF;
            _loc7_ += 4;
         }
         if(_loc4_ - _loc7_ == 2)
         {
            _loc1_ = b64[param1.charCodeAt(_loc7_)] << 18 | b64[param1.charCodeAt(_loc7_ + 1)] << 12;
            _loc5_[_loc8_ = _loc6_++] = _loc1_ >> 16;
         }
         else if(_loc4_ - _loc7_ == 3)
         {
            _loc1_ = b64[param1.charCodeAt(_loc7_)] << 18 | b64[param1.charCodeAt(_loc7_ + 1)] << 12 | b64[param1.charCodeAt(_loc7_ + 2)] << 6;
            _loc5_[_loc8_ = _loc6_++] = _loc1_ >> 16;
            _loc5_[_loc9_ = _loc6_++] = _loc1_ >> 8 & 0xFF;
         }
         _loc5_.length = _loc6_;
         _loc5_.uncompress();
         _loc5_.position = 0;
         return _loc5_.readUTFBytes(_loc5_.length);
      }

      public function get rawProtocolSeparator() : String
      {
         return MSG_STR;
      }

      public function set rawProtocolSeparator(param1:String) : void
      {
         if(param1 != "<" && param1 != "{")
         {
            MSG_STR = param1;
         }
      }

      public function get isConnected() : Boolean
      {
         return this.connected;
      }

      public function set isConnected(param1:Boolean) : void
      {
         this.connected = param1;
      }

      public function get httpPollSpeed() : int
      {
         return this._httpPollSpeed;
      }

      public function set httpPollSpeed(param1:int) : void
      {
         if(param1 >= 0 && param1 <= 10000)
         {
            this._httpPollSpeed = param1;
         }
      }

      public function loadConfig(param1:String = "config.xml", param2:Boolean = true) : void
      {
         this.autoConnectOnConfigSuccess = param2;
         var _loc5_:URLLoader = new URLLoader();
         _loc5_.addEventListener(Event.COMPLETE,this.onConfigLoadSuccess);
         _loc5_.addEventListener(IOErrorEvent.IO_ERROR,this.onConfigLoadFailure);
         _loc5_.load(new URLRequest(param1));
      }

      public function getConnectionMode() : String
      {
         var _loc11_:String = CONNECTION_MODE_DISCONNECTED;
         if(this.isConnected)
         {
            if(this.isHttpMode)
            {
               _loc11_ = CONNECTION_MODE_HTTP;
            }
            else
            {
               _loc11_ = CONNECTION_MODE_SOCKET;
            }
         }
         return _loc11_;
      }

      public function connect(param1:String, param2:int = 9339) : void
      {
         if(!this.connected)
         {
            this.initialize();
            this.ipAddress = param1;
            this.port = param2;
            this.setupSocketListeners();
            this.socketConnection.connect(param1,param2);
         }
         else
         {
            this.debugMessage("*** ALREADY CONNECTED ***");
         }
      }

      private function setupSocketListeners() : void
      {
         this.socketConnection.removeEventListener(Event.CONNECT,this.handleSocketConnection);
         this.socketConnection.removeEventListener(Event.CLOSE,this.handleSocketDisconnection);
         this.socketConnection.removeEventListener(ProgressEvent.SOCKET_DATA,this.handleSocketData);
         this.socketConnection.removeEventListener(IOErrorEvent.IO_ERROR,this.handleIOError);
         this.socketConnection.removeEventListener(IOErrorEvent.NETWORK_ERROR,this.handleIOError);
         this.socketConnection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleSecurityError);
         this.socketConnection.addEventListener(Event.CONNECT,this.handleSocketConnection);
         this.socketConnection.addEventListener(Event.CLOSE,this.handleSocketDisconnection);
         this.socketConnection.addEventListener(ProgressEvent.SOCKET_DATA,this.handleSocketData);
         this.socketConnection.addEventListener(IOErrorEvent.IO_ERROR,this.handleIOError);
         this.socketConnection.addEventListener(IOErrorEvent.NETWORK_ERROR,this.handleIOError);
         this.socketConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleSecurityError);
      }

      public function disconnect() : void
      {
         this.connected = false;
         ++this.discGen;
         if(!this.isHttpMode)
         {
            this.socketConnection.close();
         }
         else
         {
            this.httpConnection.close();
         }
         this.cleanupSocketListeners();
         this.sysHandler.dispatchDisconnection();
      }

      private function cleanupSocketListeners() : void
      {
         if(this.socketConnection != null)
         {
            this.socketConnection.removeEventListener(Event.CONNECT,this.handleSocketConnection);
            this.socketConnection.removeEventListener(Event.CLOSE,this.handleSocketDisconnection);
            this.socketConnection.removeEventListener(ProgressEvent.SOCKET_DATA,this.handleSocketData);
            this.socketConnection.removeEventListener(IOErrorEvent.IO_ERROR,this.handleIOError);
            this.socketConnection.removeEventListener(IOErrorEvent.NETWORK_ERROR,this.handleIOError);
            this.socketConnection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleSecurityError);
         }
         if(this.httpConnection != null)
         {
            this.httpConnection.removeEventListener(HttpEvent.onHttpConnect,this.handleHttpConnect);
            this.httpConnection.removeEventListener(HttpEvent.onHttpClose,this.handleHttpClose);
            this.httpConnection.removeEventListener(HttpEvent.onHttpData,this.handleHttpData);
            this.httpConnection.removeEventListener(HttpEvent.onHttpError,this.handleHttpError);
         }
      }

      public function addBuddy(param1:String) : void
      {
         var _loc4_:String = null;
         if(param1 != this.myUserName && !this.checkBuddyDuplicates(param1))
         {
            _loc4_ = "<n>" + param1 + "</n>";
            this.send({"t":"sys"},"addB",-1,_loc4_);
         }
      }

      public function autoJoin() : void
      {
         if(!this.checkRoomList())
         {
            return;
         }
         var _loc11_:Object = {"t":"sys"};
         this.send(_loc11_,"autoJoin",this.activeRoomId ? this.activeRoomId : -1,"");
      }

      public function clearBuddyList() : void
      {
         this.buddyList = [];
         this.send({"t":"sys"},"clearB",-1,"");
         var _loc11_:Object = {};
         _loc11_.list = this.buddyList;
         var _loc4_:SFSEvent = new SFSEvent(SFSEvent.onBuddyList,_loc11_);
         dispatchEvent(_loc4_);
      }

      public function createRoom(param1:Object, param2:int = -1) : void
      {
         var _loc9_:String = null;
         if(!this.checkRoomList() || !this.checkJoin())
         {
            return;
         }
         if(param2 == -1)
         {
            param2 = this.activeRoomId;
         }
         var _loc5_:Object = {"t":"sys"};
         var _loc6_:String = param1.isGame ? "1" : "0";
         var _loc7_:String = "1";
         var _loc1_:String = param1.maxUsers == null ? "0" : String(param1.maxUsers);
         var _loc2_:String = param1.maxSpectators == null ? "0" : String(param1.maxSpectators);
         var _loc3_:String = param1.joinAsSpectator ? "1" : "0";
         if(Boolean(param1.isGame) && param1.exitCurrentRoom != null)
         {
            _loc7_ = param1.exitCurrentRoom ? "1" : "0";
         }
         var _loc8_:String = "<room tmp=\'1\' gam=\'" + _loc6_ + "\' spec=\'" + _loc2_ + "\' exit=\'" + _loc7_ + "\' jas=\'" + _loc3_ + "\'>";
         _loc8_ = _loc8_ + ("<name><![CDATA[" + (param1.name == null ? "" : param1.name) + "]]></name>");
         _loc8_ = _loc8_ + ("<pwd><![CDATA[" + (param1.password == null ? "" : param1.password) + "]]></pwd>");
         _loc8_ = _loc8_ + ("<max>" + _loc1_ + "</max>");
         if(param1.uCount != null)
         {
            _loc8_ += "<uCnt>" + (param1.uCount ? "1" : "0") + "</uCnt>";
         }
         if(param1.extension != null)
         {
            _loc8_ += "<xt n=\'" + param1.extension.name;
            _loc8_ = _loc8_ + ("\' s=\'" + param1.extension.script + "\' />");
         }
         if(param1.vars == null)
         {
            _loc8_ += "<vars></vars>";
         }
         else
         {
            _loc8_ += "<vars>";
            for(_loc9_ in param1.vars)
            {
               _loc8_ += this.getXmlRoomVariable(param1.vars[_loc9_]);
            }
            _loc8_ += "</vars>";
         }
         _loc8_ += "</room>";
         this.send(_loc5_,"createRoom",param2,_loc8_);
      }

      public function getAllRooms() : Array
      {
         return this.roomList;
      }

      public function getBuddyByName(param1:String) : Object
      {
         var _loc4_:Object = null;
         for each(_loc4_ in this.buddyList)
         {
            if(_loc4_.name == param1)
            {
               return _loc4_;
            }
         }
         return null;
      }

      public function getBuddyById(param1:int) : Object
      {
         var _loc4_:Object = null;
         for each(_loc4_ in this.buddyList)
         {
            if(_loc4_.id == param1)
            {
               return _loc4_;
            }
         }
         return null;
      }

      public function getBuddyRoom(param1:Object) : void
      {
         if(param1.id != -1)
         {
            this.send({"t":"sys"},"roomB",-1,"<b id=\'" + param1.id + "\' />");
         }
      }

      public function getRoom(param1:int) : Room
      {
         if(!this.checkRoomList())
         {
            return null;
         }
         return this.roomList[param1];
      }

      public function getRoomByName(param1:String) : Room
      {
         var _loc5_:Room = null;
         if(!this.checkRoomList())
         {
            return null;
         }
         var _loc4_:Room = null;
         for each(_loc5_ in this.roomList)
         {
            if(_loc5_.getName() == param1)
            {
               _loc4_ = _loc5_;
               break;
            }
         }
         return _loc4_;
      }

      public function getRoomList() : void
      {
         var _loc11_:Object = {"t":"sys"};
         this.send(_loc11_,"getRmList",this.activeRoomId,"");
      }

      public function getActiveRoom() : Room
      {
         if(!this.checkRoomList() || !this.checkJoin())
         {
            return null;
         }
         return this.roomList[this.activeRoomId];
      }

      public function getRandomKey() : void
      {
         this.send({"t":"sys"},"rndK",-1,"");
      }

      public function getUploadPath() : String
      {
         return "https://" + this.ipAddress + ":" + this.httpPort + "/default/uploads/";
      }

      public function getVersion() : String
      {
         return this.majVersion + "." + this.minVersion + "." + this.subVersion;
      }

      public function joinRoom(param1:*, param2:String = "", param3:Boolean = false, param4:Boolean = false, param5:int = -1) : void
      {
         var _loc3_:Room = null;
         var _loc8_:Object = null;
         var _loc9_:String = null;
         var _loc10_:int = 0;
         var _loc12_:String = null;
         if(!this.checkRoomList())
         {
            return;
         }
         var _loc1_:int = -1;
         var _loc2_:int = param3 ? 1 : 0;
         if(!this.changingRoom)
         {
            if(typeof param1 == "number")
            {
               _loc1_ = int(param1);
            }
            else if(typeof param1 == "string")
            {
               for each(_loc3_ in this.roomList)
               {
                  if(_loc3_.getName() == param1)
                  {
                     _loc1_ = _loc3_.getId();
                     break;
                  }
               }
            }
            if(_loc1_ != -1)
            {
               _loc8_ = {"t":"sys"};
               _loc9_ = param4 ? "0" : "1";
               _loc10_ = param5 > -1 ? param5 : this.activeRoomId;
               if(this.activeRoomId == -1)
               {
                  _loc9_ = "0";
                  _loc10_ = -1;
               }
               _loc12_ = "<room id=\'" + _loc1_ + "\' pwd=\'" + param2 + "\' spec=\'" + _loc2_ + "\' leave=\'" + _loc9_ + "\' old=\'" + _loc10_ + "\' />";
               this.send(_loc8_,"joinRoom",this.activeRoomId,_loc12_);
               this.changingRoom = true;
            }
            else
            {
               this.debugMessage("SmartFoxError: requested room to join does not exist!");
            }
         }
      }

      public function leaveRoom(param1:int) : void
      {
         if(!this.checkRoomList() || !this.checkJoin())
         {
            return;
         }
         var _loc4_:Object = {"t":"sys"};
         var _loc5_:String = "<rm id=\'" + param1 + "\' />";
         this.send(_loc4_,"leaveRoom",param1,_loc5_);
      }

      public function loadBuddyList() : void
      {
         this.send({"t":"sys"},"loadB",-1,"");
      }

      public function login(param1:String, param2:String, param3:String) : void
      {
         var _loc6_:Object = {"t":"sys"};
         var _loc7_:String = "<login z=\'" + param1 + "\'><nick><![CDATA[" + param2 + "]]></nick><pword><![CDATA[" + param3 + "]]></pword></login>";
         this.send(_loc6_,"login",0,_loc7_);
      }

      public function logout() : void
      {
         var _loc11_:Object = {"t":"sys"};
         this.send(_loc11_,"logout",-1,"");
      }

      public function removeBuddy(param1:String) : void
      {
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc7_:Object = null;
         var _loc1_:String = null;
         var _loc2_:Object = null;
         var _loc3_:SFSEvent = null;
         var _loc4_:Boolean = false;
         for(_loc6_ in this.buddyList)
         {
            _loc5_ = this.buddyList[_loc6_];
            if(_loc5_.name == param1)
            {
               delete this.buddyList[_loc6_];
               _loc4_ = true;
               break;
            }
         }
         if(_loc4_)
         {
            _loc7_ = {"t":"sys"};
            _loc1_ = "<n>" + param1 + "</n>";
            this.send(_loc7_,"remB",-1,_loc1_);
            _loc2_ = {};
            _loc2_.list = this.buddyList;
            _loc3_ = new SFSEvent(SFSEvent.onBuddyList,_loc2_);
            dispatchEvent(_loc3_);
         }
      }

      public function roundTripBench() : void
      {
         this.benchStartTime = getTimer();
         this.send({"t":"sys"},"roundTrip",this.activeRoomId,"");
      }

      public function sendBuddyPermissionResponse(param1:Boolean, param2:String) : void
      {
         var _loc5_:Object = {"t":"sys"};
         var _loc6_:String = "<n res=\'" + (param1 ? "g" : "r") + "\'>" + param2 + "</n>";
         this.send(_loc5_,"bPrm",-1,_loc6_);
      }

      public function sendPublicMessage(param1:String, param2:int = -1) : void
      {
         if(!this.checkRoomList() || !this.checkJoin())
         {
            return;
         }
         if(param2 == -1)
         {
            param2 = this.activeRoomId;
         }
         var _loc5_:Object = {"t":"sys"};
         var _loc6_:String = "<txt><![CDATA[" + Entities.encodeEntities(param1) + "]]></txt>";
         this.send(_loc5_,"pubMsg",param2,_loc6_);
      }

      public function sendPrivateMessage(param1:String, param2:int, param3:int = -1) : void
      {
         if(!this.checkRoomList() || !this.checkJoin())
         {
            return;
         }
         if(param3 == -1)
         {
            param3 = this.activeRoomId;
         }
         var _loc6_:Object = {"t":"sys"};
         var _loc7_:String = "<txt rcp=\'" + param2 + "\'><![CDATA[" + Entities.encodeEntities(param1) + "]]></txt>";
         this.send(_loc6_,"prvMsg",param3,_loc7_);
      }

      public function sendModeratorMessage(param1:String, param2:String, param3:int = -1) : void
      {
         if(!this.checkRoomList() || !this.checkJoin())
         {
            return;
         }
         var _loc6_:Object = {"t":"sys"};
         var _loc7_:String = "<txt t=\'" + param2 + "\' id=\'" + param3 + "\'><![CDATA[" + Entities.encodeEntities(param1) + "]]></txt>";
         this.send(_loc6_,"modMsg",this.activeRoomId,_loc7_);
      }

      public function sendObject(param1:Object, param2:int = -1) : void
      {
         if(!this.checkRoomList() || !this.checkJoin())
         {
            return;
         }
         if(param2 == -1)
         {
            param2 = this.activeRoomId;
         }
         var _loc5_:String = "<![CDATA[" + ObjectSerializer.getInstance().serialize(param1) + "]]>";
         var _loc6_:Object = {"t":"sys"};
         this.send(_loc6_,"asObj",param2,_loc5_);
      }

      public function sendObjectToGroup(param1:Object, param2:Array, param3:int = -1) : void
      {
         var _loc7_:String = null;
         var _loc1_:Object = null;
         var _loc2_:String = null;
         if(!this.checkRoomList() || !this.checkJoin())
         {
            return;
         }
         if(param3 == -1)
         {
            param3 = this.activeRoomId;
         }
         var _loc6_:String = "";
         for(_loc7_ in param2)
         {
            if(!isNaN(param2[_loc7_]))
            {
               _loc6_ += param2[_loc7_] + ",";
            }
         }
         _loc6_ = _loc6_.substr(0,_loc6_.length - 1);
         param1._$$_ = _loc6_;
         _loc1_ = {"t":"sys"};
         _loc2_ = "<![CDATA[" + ObjectSerializer.getInstance().serialize(param1) + "]]>";
         this.send(_loc1_,"asObjG",param3,_loc2_);
      }

      public function sendXtMessage(param1:String, param2:String, param3:*, param4:String = "xml", param5:int = -1) : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc8_:String = null;
         var _loc9_:Number = NaN;
         var _loc10_:Object = null;
         var _loc12_:Object = null;
         var _loc13_:String = null;
         if(!this.isConnected)
         {
            trace("[Net] ERR sendXtMessage: not connected, cmd " + param2);
            return;
         }
         if(!this.checkRoomList())
         {
            return;
         }
         if(param5 == -1)
         {
            param5 = this.activeRoomId;
         }
         if(param4 == XTMSG_TYPE_XML)
         {
            _loc1_ = {"t":"xt"};
            _loc2_ = {
               "name":param1,
               "cmd":param2,
               "param":param3
            };
            _loc3_ = "<![CDATA[" + ObjectSerializer.getInstance().serialize(_loc2_) + "]]>";
            this.send(_loc1_,"xtReq",param5,_loc3_);
         }
         else if(param4 == XTMSG_TYPE_STR)
         {
            _loc8_ = MSG_STR + "xt" + MSG_STR + param1 + MSG_STR + param2 + MSG_STR + param5 + MSG_STR;
            _loc9_ = 0;
            while(_loc9_ < param3.length)
            {
               _loc8_ += (param3[_loc9_] == null ? "" : param3[_loc9_]) + MSG_STR;
               _loc9_++;
            }
            this.sendString(_loc8_);
         }
         else if(param4 == XTMSG_TYPE_JSON)
         {
            _loc10_ = {};
            _loc10_.x = param1;
            _loc10_.c = param2;
            _loc10_.r = param5;
            _loc10_.p = param3;
            _loc12_ = {};
            _loc12_.t = "xt";
            _loc12_.b = _loc10_;
            _loc13_ = JSON.stringify(_loc12_);
            this.sendJson(_loc13_);
         }
      }

      public function setBuddyBlockStatus(param1:String, param2:Boolean) : void
      {
         var _loc6_:String = null;
         var _loc7_:Object = null;
         var _loc1_:SFSEvent = null;
         var _loc5_:Object = this.getBuddyByName(param1);
         if(_loc5_ != null)
         {
            if(_loc5_.isBlocked != param2)
            {
               _loc5_.isBlocked = param2;
               _loc6_ = "<n x=\'" + (param2 ? "1" : "0") + "\'>" + param1 + "</n>";
               this.send({"t":"sys"},"setB",-1,_loc6_);
               _loc7_ = {};
               _loc7_.buddy = _loc5_;
               _loc1_ = new SFSEvent(SFSEvent.onBuddyListUpdate,_loc7_);
               dispatchEvent(_loc1_);
            }
         }
      }

      public function setBuddyVariables(param1:Array) : void
      {
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc4_:Object = {"t":"sys"};
         var _loc5_:String = "<vars>";
         for(_loc6_ in param1)
         {
            _loc7_ = param1[_loc6_];
            if(this.myBuddyVars[_loc6_] != _loc7_)
            {
               this.myBuddyVars[_loc6_] = _loc7_;
               _loc5_ += "<var n=\'" + _loc6_ + "\'><![CDATA[" + _loc7_ + "]]></var>";
            }
         }
         _loc5_ += "</vars>";
         this.send(_loc4_,"setBvars",-1,_loc5_);
      }

      public function setRoomVariables(param1:Array, param2:int = -1, param3:Boolean = true) : void
      {
         var _loc7_:String = null;
         var _loc1_:Object = null;
         if(!this.checkRoomList() || !this.checkJoin())
         {
            return;
         }
         if(param2 == -1)
         {
            param2 = this.activeRoomId;
         }
         var _loc6_:Object = {"t":"sys"};
         if(param3)
         {
            _loc7_ = "<vars>";
         }
         else
         {
            _loc7_ = "<vars so=\'0\'>";
         }
         for each(_loc1_ in param1)
         {
            _loc7_ += this.getXmlRoomVariable(_loc1_);
         }
         _loc7_ += "</vars>";
         this.send(_loc6_,"setRvars",param2,_loc7_);
      }

      public function setUserVariables(param1:Object, param2:int = -1) : void
      {
         if(!this.checkRoomList() || !this.checkJoin())
         {
            return;
         }
         if(param2 == -1)
         {
            param2 = this.activeRoomId;
         }
         var _loc5_:Object = {"t":"sys"};
         var _loc6_:Room = this.getActiveRoom();
         var _loc7_:User = _loc6_.getUser(this.myUserId);
         _loc7_.setVariables(param1);
         var _loc1_:String = this.getXmlUserVariable(param1);
         this.send(_loc5_,"setUvars",param2,_loc1_);
      }

      public function switchSpectator(param1:int = -1) : void
      {
         if(!this.checkRoomList() || !this.checkJoin())
         {
            return;
         }
         if(param1 == -1)
         {
            param1 = this.activeRoomId;
         }
         this.send({"t":"sys"},"swSpec",param1,"");
      }

      public function uploadFile(param1:FileReference, param2:int = -1, param3:String = "", param4:int = -1) : void
      {
         if(param2 == -1)
         {
            param2 = this.myUserId;
         }
         if(param3 == "")
         {
            param3 = this.myUserName;
         }
         if(param4 == -1)
         {
            param4 = this.httpPort;
         }
         param1.upload(new URLRequest("https://" + this.ipAddress + ":" + param4 + "/default/Upload.py?id=" + param2 + "&nick=" + param3));
         this.debugMessage("[UPLOAD]: https://" + this.ipAddress + ":" + param4 + "/default/Upload.py?id=" + param2 + "&nick=" + param3);
      }

      public function __logout() : void
      {
         this.initialize(true);
      }

      public function sendString(param1:String) : void
      {
         if(this.debug)
         {
            this.debugMessage("[Sending - STR]: " + param1 + "\n");
         }
         if(this.isHttpMode)
         {
            this.httpConnection.send(param1);
         }
         else
         {
            this.writeToSocket(param1);
         }
      }

      public function sendJson(param1:String) : void
      {
         if(this.debug)
         {
            this.debugMessage("[Sending - JSON]: " + param1 + "\n");
         }
         if(this.isHttpMode)
         {
            this.httpConnection.send(param1);
         }
         else
         {
            this.writeToSocket(param1);
         }
      }

      public function getBenchStartTime() : int
      {
         return this.benchStartTime;
      }

      public function clearRoomList() : void
      {
         this.roomList = [];
      }

      private function initialize(param1:Boolean = false) : void
      {
         this.changingRoom = false;
         this.amIModerator = false;
         this.playerId = -1;
         this.activeRoomId = -1;
         this.myUserId = -1;
         this.myUserName = "";
         this.roomList = [];
         this.buddyList = [];
         this.myBuddyVars = [];
         if(!param1)
         {
            this.connected = false;
            this.isHttpMode = false;
         }
      }

      private function onConfigLoadSuccess(param1:Event) : void
      {
         var _loc6_:SFSEvent = null;
         var _loc4_:URLLoader = param1.target as URLLoader;
         var _loc5_:XML = new XML(_loc4_.data);
         this.ipAddress = this.blueBoxIpAddress = _loc5_.ip;
         this.port = int(_loc5_.port);
         this.defaultZone = _loc5_.zone;
         if(_loc5_.blueBoxIpAddress != undefined)
         {
            this.blueBoxIpAddress = _loc5_.blueBoxIpAddress;
         }
         if(_loc5_.blueBoxPort != undefined)
         {
            this.blueBoxPort = _loc5_.blueBoxPort;
         }
         if(_loc5_.debug != undefined)
         {
            this.debug = _loc5_.debug.toLowerCase() == "true" ? true : false;
         }
         if(_loc5_.smartConnect != undefined)
         {
            this.smartConnect = _loc5_.smartConnect.toLowerCase() == "true" ? true : false;
         }
         if(_loc5_.httpPort != undefined)
         {
            this.httpPort = int(_loc5_.httpPort);
         }
         if(_loc5_.httpPollSpeed != undefined)
         {
            this.httpPollSpeed = int(_loc5_.httpPollSpeed);
         }
         if(_loc5_.rawProtocolSeparator != undefined)
         {
            this.rawProtocolSeparator = _loc5_.rawProtocolSeparator;
         }
         if(this.autoConnectOnConfigSuccess)
         {
            this.connect(this.ipAddress,this.port);
         }
         else
         {
            _loc6_ = new SFSEvent(SFSEvent.onConfigLoadSuccess,{});
            dispatchEvent(_loc6_);
         }
      }

      private function onConfigLoadFailure(param1:IOErrorEvent) : void
      {
         var _loc4_:Object = {"message":param1.text};
         var _loc5_:SFSEvent = new SFSEvent(SFSEvent.onConfigLoadFailure,_loc4_);
         dispatchEvent(_loc5_);
      }

      private function setupMessageHandlers() : void
      {
         this.sysHandler = new SysHandler(this);
         this.extHandler = new ExtHandler(this);
         this.addMessageHandler("sys",this.sysHandler);
         this.addMessageHandler("xt",this.extHandler);
      }

      private function addMessageHandler(param1:String, param2:IMessageHandler) : void
      {
         if(this.messageHandlers[param1] == null)
         {
            this.messageHandlers[param1] = param2;
         }
         else
         {
            this.debugMessage("Warning, message handler called: " + param1 + " already exist!");
         }
      }

      private function debugMessage(param1:String) : void
      {
         var _loc4_:SFSEvent = null;
         if(this.debug)
         {
            trace("[Net] " + param1);
            _loc4_ = new SFSEvent(SFSEvent.onDebugMessage,{"message":param1});
            dispatchEvent(_loc4_);
         }
      }

      private function send(param1:Object, param2:String, param3:Number, param4:String) : void
      {
         var _loc7_:String = this.makeXmlHeader(param1);
         _loc7_ = _loc7_ + ("<body action=\'" + param2 + "\' r=\'" + param3 + "\'>" + param4 + "</body>" + this.closeHeader());
         if(this.debug)
         {
            this.debugMessage("[Sending]: " + _loc7_ + "\n");
         }
         if(this.isHttpMode)
         {
            this.httpConnection.send(_loc7_);
         }
         else
         {
            this.writeToSocket(_loc7_);
         }
      }

      private function writeToSocket(param1:String) : void
      {
         var _loc4_:ByteArray = new ByteArray();
         _loc4_.writeUTFBytes(param1);
         _loc4_.writeByte(0);
         this.socketConnection.writeBytes(_loc4_);
         this.socketConnection.flush();
      }

      private function writeToSocketLinux(param1:String) : void
      {
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            this.socketConnection.writeByte(param1.charCodeAt(_loc4_));
            _loc4_++;
         }
         this.socketConnection.writeByte(0);
         this.socketConnection.flush();
      }

      private function makeXmlHeader(param1:Object) : String
      {
         var _loc5_:String = null;
         var _loc4_:String = "<msg";
         for(_loc5_ in param1)
         {
            _loc4_ += " " + _loc5_ + "=\'" + param1[_loc5_] + "\'";
         }
         return _loc4_ + ">";
      }

      private function closeHeader() : String
      {
         return "</msg>";
      }

      private function checkBuddyDuplicates(param1:String) : Boolean
      {
         var _loc5_:Object = null;
         var _loc4_:Boolean = false;
         for each(_loc5_ in this.buddyList)
         {
            if(_loc5_.name == param1)
            {
               _loc4_ = true;
               break;
            }
         }
         return _loc4_;
      }

      private function xmlReceived(param1:String) : void
      {
         var _loc4_:XML = new XML(param1);
         var _loc5_:String = _loc4_.@t;
         var _loc6_:String = _loc4_.body.@action;
         var _loc7_:int = int(_loc4_.body.@r);
         var _loc1_:IMessageHandler = this.messageHandlers[_loc5_];
         if(_loc1_ != null)
         {
            _loc1_.handleMessage(_loc4_,XTMSG_TYPE_XML);
         }
      }

      private function jsonReceived(param1:String) : void
      {
         var _loc4_:Object = JSON.parse(param1);
         var _loc5_:String = _loc4_["t"];
         var _loc6_:IMessageHandler = this.messageHandlers[_loc5_];
         if(_loc6_ != null)
         {
            _loc6_.handleMessage(_loc4_["b"],XTMSG_TYPE_JSON);
         }
      }

      private function strReceived(param1:String) : void
      {
         var _loc4_:Array = param1.substr(1,param1.length - 2).split(MSG_STR);
         var _loc5_:String = _loc4_[0];
         var _loc6_:IMessageHandler = this.messageHandlers[_loc5_];
         if(_loc6_ != null)
         {
            _loc6_.handleMessage(_loc4_.splice(1,_loc4_.length - 1),XTMSG_TYPE_STR);
         }
      }

      private function getXmlRoomVariable(param1:Object) : String
      {
         var _loc4_:String = param1.name.toString();
         var _loc5_:* = param1.val;
         var _loc6_:String = param1.priv ? "1" : "0";
         var _loc7_:String = param1.persistent ? "1" : "0";
         var _loc1_:String = null;
         var _loc2_:String = typeof _loc5_;
         if(_loc2_ == "boolean")
         {
            _loc1_ = "b";
            _loc5_ = _loc5_ ? "1" : "0";
         }
         else if(_loc2_ == "number")
         {
            _loc1_ = "n";
         }
         else if(_loc2_ == "string")
         {
            _loc1_ = "s";
         }
         else if(_loc5_ == null && _loc2_ == "object" || _loc2_ == "undefined")
         {
            _loc1_ = "x";
            _loc5_ = "";
         }
         if(_loc1_ != null)
         {
            return "<var n=\'" + _loc4_ + "\' t=\'" + _loc1_ + "\' pr=\'" + _loc6_ + "\' pe=\'" + _loc7_ + "\'><![CDATA[" + _loc5_ + "]]></var>";
         }
         return "";
      }

      private function getXmlUserVariable(param1:Object) : String
      {
         var _loc5_:* = undefined;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc1_:String = null;
         var _loc4_:String = "<vars>";
         for(_loc1_ in param1)
         {
            _loc5_ = param1[_loc1_];
            _loc7_ = typeof _loc5_;
            _loc6_ = null;
            if(_loc7_ == "boolean")
            {
               _loc6_ = "b";
               _loc5_ = _loc5_ ? "1" : "0";
            }
            else if(_loc7_ == "number")
            {
               _loc6_ = "n";
            }
            else if(_loc7_ == "string")
            {
               _loc6_ = "s";
            }
            else if(_loc5_ == null && _loc7_ == "object" || _loc7_ == "undefined")
            {
               _loc6_ = "x";
               _loc5_ = "";
            }
            if(_loc6_ != null)
            {
               _loc4_ += "<var n=\'" + _loc1_ + "\' t=\'" + _loc6_ + "\'><![CDATA[" + _loc5_ + "]]></var>";
            }
         }
         return _loc4_ + "</vars>";
      }

      private function checkRoomList() : Boolean
      {
         return true;
      }

      private function checkJoin() : Boolean
      {
         var _loc11_:Boolean = true;
         if(this.activeRoomId < 0)
         {
            _loc11_ = false;
            this.errortrace("You haven\'t joined any rooms!\nIn order to interact with the server you should join at least one room.\nPlease consult the documentation for more infos.");
         }
         return _loc11_;
      }

      private function errortrace(param1:String) : void
      {
         trace("[Net] ERR " + param1);
      }

      private function handleHttpConnect(param1:HttpEvent) : void
      {
         this.handleSocketConnection(null);
         this.connected = true;
         this.httpConnection.send(HTTP_POLL_REQUEST);
      }

      private function handleHttpClose(param1:HttpEvent) : void
      {
         this.initialize();
         var _loc4_:SFSEvent = new SFSEvent(SFSEvent.onConnectionLost,{});
         dispatchEvent(_loc4_);
      }

      private function handleHttpData(param1:HttpEvent) : void
      {
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc4_:String = param1.params.data as String;
         var _loc5_:Array = _loc4_.split("\n");
         if(_loc5_[0] != "")
         {
            _loc7_ = 0;
            while(_loc7_ < _loc5_.length - 1)
            {
               _loc6_ = _loc5_[_loc7_];
               if(_loc6_.length > 0)
               {
                  this.handleMessage(_loc6_);
               }
               _loc7_++;
            }
            if(this._httpPollSpeed > 0)
            {
               setTimeout(this.handleDelayedPoll,this._httpPollSpeed);
            }
            else
            {
               this.handleDelayedPoll();
            }
         }
      }

      private function handleDelayedPoll() : void
      {
         this.httpConnection.send(HTTP_POLL_REQUEST);
      }

      private function handleHttpError(param1:HttpEvent) : void
      {
         trace("[Net] ERR handleHttpError");
         if(!this.connected)
         {
            this.dispatchConnectionError();
         }
      }

      private function handleSocketConnection(param1:Event) : void
      {
         var _loc4_:Object = {"t":"sys"};
         var _loc5_:String = "<ver v=\'" + this.majVersion.toString() + this.minVersion.toString() + this.subVersion.toString() + "\' />";
         this.send(_loc4_,"verChk",0,_loc5_);
      }

      private function handleSocketDisconnection(param1:Event) : void
      {
         this.cleanupSocketListeners();
         this.initialize();
         var _loc4_:SFSEvent = new SFSEvent(SFSEvent.onConnectionLost,{"disconnect":true});
         dispatchEvent(_loc4_);
      }

      private function handleIOError(param1:IOErrorEvent) : void
      {
         this.tryBlueBoxConnection(param1);
      }

      private function tryBlueBoxConnection(param1:ErrorEvent) : void
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         if(!this.connected)
         {
            if(this.smartConnect)
            {
               this.debugMessage("Socket connection failed. Trying BlueBox");
               this.isHttpMode = true;
               _loc4_ = this.blueBoxIpAddress != null ? this.blueBoxIpAddress : this.ipAddress;
               _loc5_ = this.blueBoxPort != 0 ? int(this.blueBoxPort) : this.httpPort;
               this.httpConnection.connect(_loc4_,_loc5_);
            }
            else
            {
               this.dispatchConnectionError();
            }
         }
         else
         {
            dispatchEvent(param1);
            this.debugMessage("[WARN] Connection error: " + param1.text);
         }
      }

      private function handleSocketError(param1:SecurityErrorEvent) : void
      {
         this.debugMessage("Socket Error: " + param1.text);
      }

      private function handleSecurityError(param1:SecurityErrorEvent) : void
      {
         this.tryBlueBoxConnection(param1);
      }

      private function handleSocketData(param1:Event) : void
      {
         var gen:int;
         var chunk:ByteArray;
         var start:int;
         var i:int;
         var msgStr:String = null;
         var evt:Event = param1;
         var bytes:int = int(this.socketConnection.bytesAvailable);
         if(bytes <= 0)
         {
            return;
         }
         gen = int(this.discGen);
         chunk = this.socketChunk;
         chunk.length = 0;
         this.socketConnection.readBytes(chunk,0,bytes);
         start = 0;
         i = 0;
         while(i < bytes)
         {
            if(chunk[i] == 0)
            {
               if(this.byteBuffer.length > 0)
               {
                  if(i > start)
                  {
                     this.byteBuffer.writeBytes(chunk,start,i - start);
                  }
                  this.byteBuffer.position = 0;
                  msgStr = this.byteBuffer.readUTFBytes(this.byteBuffer.length);
                  this.byteBuffer.length = 0;
               }
               else
               {
                  chunk.position = start;
                  msgStr = chunk.readUTFBytes(i - start);
               }
               start = i + 1;
               try
               {
                  this.handleMessage(msgStr);
               }
               catch(err:Error)
               {
                  if(!debug)
                  {
                     trace("[Net] handleMessage error: " + err.message);
                  }
                  debugMessage("handleMessage error: " + err.message);
               }
               if(gen != this.discGen)
               {
                  this.byteBuffer.length = 0;
                  chunk.length = 0;
                  return;
               }
            }
            i++;
         }
         if(start < bytes)
         {
            this.byteBuffer.writeBytes(chunk,start,bytes - start);
         }
         chunk.length = 0;
      }

      private function handleMessage(param1:String) : void
      {
         if(param1.charCodeAt(0) == 90)
         {
            param1 = unpack(param1);
         }
         if(this.debug && param1 != "ok")
         {
            this.debugMessage("[ RECEIVED ]: " + param1 + ", (len: " + param1.length + ")");
         }
         var _loc4_:String = param1.charAt(0);
         if(_loc4_ == MSG_XML)
         {
            this.xmlReceived(param1);
         }
         else if(_loc4_ == MSG_STR)
         {
            this.strReceived(param1);
         }
         else if(_loc4_ == MSG_JSON)
         {
            this.jsonReceived(param1);
         }
      }

      private function dispatchConnectionError() : void
      {
         var _loc11_:Object = {};
         _loc11_.success = false;
         _loc11_.error = "I/O Error";
         var _loc4_:SFSEvent = new SFSEvent(SFSEvent.onConnection,_loc11_);
         dispatchEvent(_loc4_);
      }
   }
}
