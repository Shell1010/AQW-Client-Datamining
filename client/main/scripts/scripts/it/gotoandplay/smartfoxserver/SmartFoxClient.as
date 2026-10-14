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
         var _loc1_:URLLoader = new URLLoader();
         _loc1_.addEventListener(Event.COMPLETE,this.onConfigLoadSuccess);
         _loc1_.addEventListener(IOErrorEvent.IO_ERROR,this.onConfigLoadFailure);
         _loc1_.load(new URLRequest(param1));
      }

      public function getConnectionMode() : String
      {
         var _loc1_:String = CONNECTION_MODE_DISCONNECTED;
         if(this.isConnected)
         {
            if(this.isHttpMode)
            {
               _loc1_ = CONNECTION_MODE_HTTP;
            }
            else
            {
               _loc1_ = CONNECTION_MODE_SOCKET;
            }
         }
         return _loc1_;
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
         var _loc1_:String = null;
         if(param1 != this.myUserName && !this.checkBuddyDuplicates(param1))
         {
            _loc1_ = "<n>" + param1 + "</n>";
            this.send({"t":"sys"},"addB",-1,_loc1_);
         }
      }

      public function autoJoin() : void
      {
         if(!this.checkRoomList())
         {
            return;
         }
         var _loc1_:Object = {"t":"sys"};
         this.send(_loc1_,"autoJoin",this.activeRoomId ? this.activeRoomId : -1,"");
      }

      public function clearBuddyList() : void
      {
         this.buddyList = [];
         this.send({"t":"sys"},"clearB",-1,"");
         var _loc1_:Object = {};
         _loc1_.list = this.buddyList;
         var _loc2_:SFSEvent = new SFSEvent(SFSEvent.onBuddyList,_loc1_);
         dispatchEvent(_loc2_);
      }

      public function createRoom(param1:Object, param2:int = -1) : void
      {
         var _loc1_:String = null;
         if(!this.checkRoomList() || !this.checkJoin())
         {
            return;
         }
         if(param2 == -1)
         {
            param2 = this.activeRoomId;
         }
         var _loc2_:Object = {"t":"sys"};
         var _loc3_:String = param1.isGame ? "1" : "0";
         var _loc4_:String = "1";
         var _loc5_:String = param1.maxUsers == null ? "0" : String(param1.maxUsers);
         var _loc6_:String = param1.maxSpectators == null ? "0" : String(param1.maxSpectators);
         var _loc7_:String = param1.joinAsSpectator ? "1" : "0";
         if(Boolean(param1.isGame) && param1.exitCurrentRoom != null)
         {
            _loc4_ = param1.exitCurrentRoom ? "1" : "0";
         }
         var _loc8_:String = "<room tmp=\'1\' gam=\'" + _loc3_ + "\' spec=\'" + _loc6_ + "\' exit=\'" + _loc4_ + "\' jas=\'" + _loc7_ + "\'>";
         _loc8_ = _loc8_ + ("<name><![CDATA[" + (param1.name == null ? "" : param1.name) + "]]></name>");
         _loc8_ = _loc8_ + ("<pwd><![CDATA[" + (param1.password == null ? "" : param1.password) + "]]></pwd>");
         _loc8_ = _loc8_ + ("<max>" + _loc5_ + "</max>");
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
            for(_loc1_ in param1.vars)
            {
               _loc8_ += this.getXmlRoomVariable(param1.vars[_loc1_]);
            }
            _loc8_ += "</vars>";
         }
         _loc8_ += "</room>";
         this.send(_loc2_,"createRoom",param2,_loc8_);
      }

      public function getAllRooms() : Array
      {
         return this.roomList;
      }

      public function getBuddyByName(param1:String) : Object
      {
         var _loc1_:Object = null;
         for each(_loc1_ in this.buddyList)
         {
            if(_loc1_.name == param1)
            {
               return _loc1_;
            }
         }
         return null;
      }

      public function getBuddyById(param1:int) : Object
      {
         var _loc1_:Object = null;
         for each(_loc1_ in this.buddyList)
         {
            if(_loc1_.id == param1)
            {
               return _loc1_;
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
         var _loc1_:Room = null;
         if(!this.checkRoomList())
         {
            return null;
         }
         var _loc2_:Room = null;
         for each(_loc1_ in this.roomList)
         {
            if(_loc1_.getName() == param1)
            {
               _loc2_ = _loc1_;
               break;
            }
         }
         return _loc2_;
      }

      public function getRoomList() : void
      {
         var _loc1_:Object = {"t":"sys"};
         this.send(_loc1_,"getRmList",this.activeRoomId,"");
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
         var _loc1_:Room = null;
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         if(!this.checkRoomList())
         {
            return;
         }
         var _loc6_:int = -1;
         var _loc7_:int = param3 ? 1 : 0;
         if(!this.changingRoom)
         {
            if(typeof param1 == "number")
            {
               _loc6_ = int(param1);
            }
            else if(typeof param1 == "string")
            {
               for each(_loc1_ in this.roomList)
               {
                  if(_loc1_.getName() == param1)
                  {
                     _loc6_ = _loc1_.getId();
                     break;
                  }
               }
            }
            if(_loc6_ != -1)
            {
               _loc2_ = {"t":"sys"};
               _loc3_ = param4 ? "0" : "1";
               _loc4_ = param5 > -1 ? param5 : this.activeRoomId;
               if(this.activeRoomId == -1)
               {
                  _loc3_ = "0";
                  _loc4_ = -1;
               }
               _loc5_ = "<room id=\'" + _loc6_ + "\' pwd=\'" + param2 + "\' spec=\'" + _loc7_ + "\' leave=\'" + _loc3_ + "\' old=\'" + _loc4_ + "\' />";
               this.send(_loc2_,"joinRoom",this.activeRoomId,_loc5_);
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
         var _loc1_:Object = {"t":"sys"};
         var _loc2_:String = "<rm id=\'" + param1 + "\' />";
         this.send(_loc1_,"leaveRoom",param1,_loc2_);
      }

      public function loadBuddyList() : void
      {
         this.send({"t":"sys"},"loadB",-1,"");
      }

      public function login(param1:String, param2:String, param3:String) : void
      {
         var _loc1_:Object = {"t":"sys"};
         var _loc2_:String = "<login z=\'" + param1 + "\'><nick><![CDATA[" + param2 + "]]></nick><pword><![CDATA[" + param3 + "]]></pword></login>";
         this.send(_loc1_,"login",0,_loc2_);
      }

      public function logout() : void
      {
         var _loc1_:Object = {"t":"sys"};
         this.send(_loc1_,"logout",-1,"");
      }

      public function removeBuddy(param1:String) : void
      {
         var _loc1_:Object = null;
         var _loc2_:String = null;
         var _loc3_:Object = null;
         var _loc4_:String = null;
         var _loc5_:Object = null;
         var _loc6_:SFSEvent = null;
         var _loc7_:Boolean = false;
         for(_loc2_ in this.buddyList)
         {
            _loc1_ = this.buddyList[_loc2_];
            if(_loc1_.name == param1)
            {
               delete this.buddyList[_loc2_];
               _loc7_ = true;
               break;
            }
         }
         if(_loc7_)
         {
            _loc3_ = {"t":"sys"};
            _loc4_ = "<n>" + param1 + "</n>";
            this.send(_loc3_,"remB",-1,_loc4_);
            _loc5_ = {};
            _loc5_.list = this.buddyList;
            _loc6_ = new SFSEvent(SFSEvent.onBuddyList,_loc5_);
            dispatchEvent(_loc6_);
         }
      }

      public function roundTripBench() : void
      {
         this.benchStartTime = getTimer();
         this.send({"t":"sys"},"roundTrip",this.activeRoomId,"");
      }

      public function sendBuddyPermissionResponse(param1:Boolean, param2:String) : void
      {
         var _loc1_:Object = {"t":"sys"};
         var _loc2_:String = "<n res=\'" + (param1 ? "g" : "r") + "\'>" + param2 + "</n>";
         this.send(_loc1_,"bPrm",-1,_loc2_);
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
         var _loc1_:Object = {"t":"sys"};
         var _loc2_:String = "<txt><![CDATA[" + Entities.encodeEntities(param1) + "]]></txt>";
         this.send(_loc1_,"pubMsg",param2,_loc2_);
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
         var _loc1_:Object = {"t":"sys"};
         var _loc2_:String = "<txt rcp=\'" + param2 + "\'><![CDATA[" + Entities.encodeEntities(param1) + "]]></txt>";
         this.send(_loc1_,"prvMsg",param3,_loc2_);
      }

      public function sendModeratorMessage(param1:String, param2:String, param3:int = -1) : void
      {
         if(!this.checkRoomList() || !this.checkJoin())
         {
            return;
         }
         var _loc1_:Object = {"t":"sys"};
         var _loc2_:String = "<txt t=\'" + param2 + "\' id=\'" + param3 + "\'><![CDATA[" + Entities.encodeEntities(param1) + "]]></txt>";
         this.send(_loc1_,"modMsg",this.activeRoomId,_loc2_);
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
         var _loc1_:String = "<![CDATA[" + ObjectSerializer.getInstance().serialize(param1) + "]]>";
         var _loc2_:Object = {"t":"sys"};
         this.send(_loc2_,"asObj",param2,_loc1_);
      }

      public function sendObjectToGroup(param1:Object, param2:Array, param3:int = -1) : void
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         var _loc3_:String = null;
         if(!this.checkRoomList() || !this.checkJoin())
         {
            return;
         }
         if(param3 == -1)
         {
            param3 = this.activeRoomId;
         }
         var _loc4_:String = "";
         for(_loc1_ in param2)
         {
            if(!isNaN(param2[_loc1_]))
            {
               _loc4_ += param2[_loc1_] + ",";
            }
         }
         _loc4_ = _loc4_.substr(0,_loc4_.length - 1);
         param1._$$_ = _loc4_;
         _loc2_ = {"t":"sys"};
         _loc3_ = "<![CDATA[" + ObjectSerializer.getInstance().serialize(param1) + "]]>";
         this.send(_loc2_,"asObjG",param3,_loc3_);
      }

      public function sendXtMessage(param1:String, param2:String, param3:*, param4:String = "xml", param5:int = -1) : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:Number = NaN;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:String = null;
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
            _loc4_ = MSG_STR + "xt" + MSG_STR + param1 + MSG_STR + param2 + MSG_STR + param5 + MSG_STR;
            _loc5_ = 0;
            while(_loc5_ < param3.length)
            {
               _loc4_ += (param3[_loc5_] == null ? "" : param3[_loc5_]) + MSG_STR;
               _loc5_++;
            }
            this.sendString(_loc4_);
         }
         else if(param4 == XTMSG_TYPE_JSON)
         {
            _loc6_ = {};
            _loc6_.x = param1;
            _loc6_.c = param2;
            _loc6_.r = param5;
            _loc6_.p = param3;
            _loc7_ = {};
            _loc7_.t = "xt";
            _loc7_.b = _loc6_;
            _loc8_ = JSON.stringify(_loc7_);
            this.sendJson(_loc8_);
         }
      }

      public function setBuddyBlockStatus(param1:String, param2:Boolean) : void
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         var _loc3_:SFSEvent = null;
         var _loc4_:Object = this.getBuddyByName(param1);
         if(_loc4_ != null)
         {
            if(_loc4_.isBlocked != param2)
            {
               _loc4_.isBlocked = param2;
               _loc1_ = "<n x=\'" + (param2 ? "1" : "0") + "\'>" + param1 + "</n>";
               this.send({"t":"sys"},"setB",-1,_loc1_);
               _loc2_ = {};
               _loc2_.buddy = _loc4_;
               _loc3_ = new SFSEvent(SFSEvent.onBuddyListUpdate,_loc2_);
               dispatchEvent(_loc3_);
            }
         }
      }

      public function setBuddyVariables(param1:Array) : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:Object = {"t":"sys"};
         var _loc4_:String = "<vars>";
         for(_loc1_ in param1)
         {
            _loc2_ = param1[_loc1_];
            if(this.myBuddyVars[_loc1_] != _loc2_)
            {
               this.myBuddyVars[_loc1_] = _loc2_;
               _loc4_ += "<var n=\'" + _loc1_ + "\'><![CDATA[" + _loc2_ + "]]></var>";
            }
         }
         _loc4_ += "</vars>";
         this.send(_loc3_,"setBvars",-1,_loc4_);
      }

      public function setRoomVariables(param1:Array, param2:int = -1, param3:Boolean = true) : void
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         if(!this.checkRoomList() || !this.checkJoin())
         {
            return;
         }
         if(param2 == -1)
         {
            param2 = this.activeRoomId;
         }
         var _loc3_:Object = {"t":"sys"};
         if(param3)
         {
            _loc1_ = "<vars>";
         }
         else
         {
            _loc1_ = "<vars so=\'0\'>";
         }
         for each(_loc2_ in param1)
         {
            _loc1_ += this.getXmlRoomVariable(_loc2_);
         }
         _loc1_ += "</vars>";
         this.send(_loc3_,"setRvars",param2,_loc1_);
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
         var _loc1_:Object = {"t":"sys"};
         var _loc2_:Room = this.getActiveRoom();
         var _loc3_:User = _loc2_.getUser(this.myUserId);
         _loc3_.setVariables(param1);
         var _loc4_:String = this.getXmlUserVariable(param1);
         this.send(_loc1_,"setUvars",param2,_loc4_);
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
         var _loc1_:SFSEvent = null;
         var _loc2_:URLLoader = param1.target as URLLoader;
         var _loc3_:XML = new XML(_loc2_.data);
         this.ipAddress = this.blueBoxIpAddress = _loc3_.ip;
         this.port = int(_loc3_.port);
         this.defaultZone = _loc3_.zone;
         if(_loc3_.blueBoxIpAddress != undefined)
         {
            this.blueBoxIpAddress = _loc3_.blueBoxIpAddress;
         }
         if(_loc3_.blueBoxPort != undefined)
         {
            this.blueBoxPort = _loc3_.blueBoxPort;
         }
         if(_loc3_.debug != undefined)
         {
            this.debug = _loc3_.debug.toLowerCase() == "true" ? true : false;
         }
         if(_loc3_.smartConnect != undefined)
         {
            this.smartConnect = _loc3_.smartConnect.toLowerCase() == "true" ? true : false;
         }
         if(_loc3_.httpPort != undefined)
         {
            this.httpPort = int(_loc3_.httpPort);
         }
         if(_loc3_.httpPollSpeed != undefined)
         {
            this.httpPollSpeed = int(_loc3_.httpPollSpeed);
         }
         if(_loc3_.rawProtocolSeparator != undefined)
         {
            this.rawProtocolSeparator = _loc3_.rawProtocolSeparator;
         }
         if(this.autoConnectOnConfigSuccess)
         {
            this.connect(this.ipAddress,this.port);
         }
         else
         {
            _loc1_ = new SFSEvent(SFSEvent.onConfigLoadSuccess,{});
            dispatchEvent(_loc1_);
         }
      }

      private function onConfigLoadFailure(param1:IOErrorEvent) : void
      {
         var _loc1_:Object = {"message":param1.text};
         var _loc2_:SFSEvent = new SFSEvent(SFSEvent.onConfigLoadFailure,_loc1_);
         dispatchEvent(_loc2_);
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
         var _loc1_:SFSEvent = null;
         if(this.debug)
         {
            trace("[Net] " + param1);
            _loc1_ = new SFSEvent(SFSEvent.onDebugMessage,{"message":param1});
            dispatchEvent(_loc1_);
         }
      }

      private function send(param1:Object, param2:String, param3:Number, param4:String) : void
      {
         var _loc1_:String = this.makeXmlHeader(param1);
         _loc1_ = _loc1_ + ("<body action=\'" + param2 + "\' r=\'" + param3 + "\'>" + param4 + "</body>" + this.closeHeader());
         if(this.debug)
         {
            this.debugMessage("[Sending]: " + _loc1_ + "\n");
         }
         if(this.isHttpMode)
         {
            this.httpConnection.send(_loc1_);
         }
         else
         {
            this.writeToSocket(_loc1_);
         }
      }

      private function writeToSocket(param1:String) : void
      {
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeUTFBytes(param1);
         _loc1_.writeByte(0);
         this.socketConnection.writeBytes(_loc1_);
         this.socketConnection.flush();
      }

      private function writeToSocketLinux(param1:String) : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < param1.length)
         {
            this.socketConnection.writeByte(param1.charCodeAt(_loc1_));
            _loc1_++;
         }
         this.socketConnection.writeByte(0);
         this.socketConnection.flush();
      }

      private function makeXmlHeader(param1:Object) : String
      {
         var _loc1_:String = null;
         var _loc2_:String = "<msg";
         for(_loc1_ in param1)
         {
            _loc2_ += " " + _loc1_ + "=\'" + param1[_loc1_] + "\'";
         }
         return _loc2_ + ">";
      }

      private function closeHeader() : String
      {
         return "</msg>";
      }

      private function checkBuddyDuplicates(param1:String) : Boolean
      {
         var _loc1_:Object = null;
         var _loc2_:Boolean = false;
         for each(_loc1_ in this.buddyList)
         {
            if(_loc1_.name == param1)
            {
               _loc2_ = true;
               break;
            }
         }
         return _loc2_;
      }

      private function xmlReceived(param1:String) : void
      {
         var _loc1_:XML = new XML(param1);
         var _loc2_:String = _loc1_.@t;
         var _loc3_:String = _loc1_.body.@action;
         var _loc4_:int = int(_loc1_.body.@r);
         var _loc5_:IMessageHandler = this.messageHandlers[_loc2_];
         if(_loc5_ != null)
         {
            _loc5_.handleMessage(_loc1_,XTMSG_TYPE_XML);
         }
      }

      private function jsonReceived(param1:String) : void
      {
         var _loc1_:Object = JSON.parse(param1);
         var _loc2_:String = _loc1_["t"];
         var _loc3_:IMessageHandler = this.messageHandlers[_loc2_];
         if(_loc3_ != null)
         {
            _loc3_.handleMessage(_loc1_["b"],XTMSG_TYPE_JSON);
         }
      }

      private function strReceived(param1:String) : void
      {
         var _loc1_:Array = param1.substr(1,param1.length - 2).split(MSG_STR);
         var _loc2_:String = _loc1_[0];
         var _loc3_:IMessageHandler = this.messageHandlers[_loc2_];
         if(_loc3_ != null)
         {
            _loc3_.handleMessage(_loc1_.splice(1,_loc1_.length - 1),XTMSG_TYPE_STR);
         }
      }

      private function getXmlRoomVariable(param1:Object) : String
      {
         var _loc1_:String = param1.name.toString();
         var _loc2_:* = param1.val;
         var _loc3_:String = param1.priv ? "1" : "0";
         var _loc4_:String = param1.persistent ? "1" : "0";
         var _loc5_:String = null;
         var _loc6_:String = typeof _loc2_;
         if(_loc6_ == "boolean")
         {
            _loc5_ = "b";
            _loc2_ = _loc2_ ? "1" : "0";
         }
         else if(_loc6_ == "number")
         {
            _loc5_ = "n";
         }
         else if(_loc6_ == "string")
         {
            _loc5_ = "s";
         }
         else if(_loc2_ == null && _loc6_ == "object" || _loc6_ == "undefined")
         {
            _loc5_ = "x";
            _loc2_ = "";
         }
         if(_loc5_ != null)
         {
            return "<var n=\'" + _loc1_ + "\' t=\'" + _loc5_ + "\' pr=\'" + _loc3_ + "\' pe=\'" + _loc4_ + "\'><![CDATA[" + _loc2_ + "]]></var>";
         }
         return "";
      }

      private function getXmlUserVariable(param1:Object) : String
      {
         var _loc1_:* = undefined;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = "<vars>";
         for(_loc4_ in param1)
         {
            _loc1_ = param1[_loc4_];
            _loc3_ = typeof _loc1_;
            _loc2_ = null;
            if(_loc3_ == "boolean")
            {
               _loc2_ = "b";
               _loc1_ = _loc1_ ? "1" : "0";
            }
            else if(_loc3_ == "number")
            {
               _loc2_ = "n";
            }
            else if(_loc3_ == "string")
            {
               _loc2_ = "s";
            }
            else if(_loc1_ == null && _loc3_ == "object" || _loc3_ == "undefined")
            {
               _loc2_ = "x";
               _loc1_ = "";
            }
            if(_loc2_ != null)
            {
               _loc5_ += "<var n=\'" + _loc4_ + "\' t=\'" + _loc2_ + "\'><![CDATA[" + _loc1_ + "]]></var>";
            }
         }
         return _loc5_ + "</vars>";
      }

      private function checkRoomList() : Boolean
      {
         return true;
      }

      private function checkJoin() : Boolean
      {
         var _loc1_:Boolean = true;
         if(this.activeRoomId < 0)
         {
            _loc1_ = false;
            this.errortrace("You haven\'t joined any rooms!\nIn order to interact with the server you should join at least one room.\nPlease consult the documentation for more infos.");
         }
         return _loc1_;
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
         var _loc1_:SFSEvent = new SFSEvent(SFSEvent.onConnectionLost,{});
         dispatchEvent(_loc1_);
      }

      private function handleHttpData(param1:HttpEvent) : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         var _loc3_:String = param1.params.data as String;
         var _loc4_:Array = _loc3_.split("\n");
         if(_loc4_[0] != "")
         {
            _loc2_ = 0;
            while(_loc2_ < _loc4_.length - 1)
            {
               _loc1_ = _loc4_[_loc2_];
               if(_loc1_.length > 0)
               {
                  this.handleMessage(_loc1_);
               }
               _loc2_++;
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
         var _loc1_:Object = {"t":"sys"};
         var _loc2_:String = "<ver v=\'" + this.majVersion.toString() + this.minVersion.toString() + this.subVersion.toString() + "\' />";
         this.send(_loc1_,"verChk",0,_loc2_);
      }

      private function handleSocketDisconnection(param1:Event) : void
      {
         this.cleanupSocketListeners();
         this.initialize();
         var _loc1_:SFSEvent = new SFSEvent(SFSEvent.onConnectionLost,{"disconnect":true});
         dispatchEvent(_loc1_);
      }

      private function handleIOError(param1:IOErrorEvent) : void
      {
         this.tryBlueBoxConnection(param1);
      }

      private function tryBlueBoxConnection(param1:ErrorEvent) : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         if(!this.connected)
         {
            if(this.smartConnect)
            {
               this.debugMessage("Socket connection failed. Trying BlueBox");
               this.isHttpMode = true;
               _loc1_ = this.blueBoxIpAddress != null ? this.blueBoxIpAddress : this.ipAddress;
               _loc2_ = this.blueBoxPort != 0 ? int(this.blueBoxPort) : this.httpPort;
               this.httpConnection.connect(_loc1_,_loc2_);
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
         var _loc1_:String = param1.charAt(0);
         if(_loc1_ == MSG_XML)
         {
            this.xmlReceived(param1);
         }
         else if(_loc1_ == MSG_STR)
         {
            this.strReceived(param1);
         }
         else if(_loc1_ == MSG_JSON)
         {
            this.jsonReceived(param1);
         }
      }

      private function dispatchConnectionError() : void
      {
         var _loc1_:Object = {};
         _loc1_.success = false;
         _loc1_.error = "I/O Error";
         var _loc2_:SFSEvent = new SFSEvent(SFSEvent.onConnection,_loc1_);
         dispatchEvent(_loc2_);
      }
   }
}
