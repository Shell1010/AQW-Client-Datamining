package
{
   import fl.motion.*;
   import flash.display.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import it.gotoandplay.smartfoxserver.*;
   import liteAssets.draw.*;
   import liteAssets.handlers.*;
   import liteAssets.mobile.*;
   import types.*;

   [SWF(width="960", height="550", backgroundColor="#282828", frameRate="24")]
   public class Game extends MovieClip
   {

      public static var root:DisplayObject;

      public static var serverName:String;

      public static var objLogin:Object;

      public static var mcUpgradeWindow:MovieClip;

      public static var mcACWindow:MovieClip;

      public static var strToken:String;

      public static var vParam:String = "5.21";

      public static var ISWEB:Boolean = true;

      public static var serverPort:int = 5588;

      public static var serverIP:String = "";

      public static var serverGamePath:String = "";

      public static var serverFilePath:String = "";

      public static var serverURL:String = "";

      public static var cLoginZone:String = "zone_master";

      public static var clientToken:String = "SPIDER#0001";

      public static var bPTR:Boolean = false;

      public static var loginInfo:Object = new Object();

      public static const ASSETS_LOADED:String = "main_assets_loaded";

      public static var ASSETS_READY:String = "";

      public static const FB_APP_NAME:String = "AQW";

      public static const FB_APP_URL:String = "www.aq.com";

      public static const FB_APP_ID:String = "51356733862";

      public static const FB_APP_SEC:String = "This should never be stored in the client";

      private static const PROC_SLOTS:Object = {
         "aa":"Auto Attack",
         "a1":"Skill 1",
         "a2":"Skill 2",
         "a3":"Skill 3",
         "a4":"Skill 4"
      };

      MovieClip.prototype.removeAllChildren = function():void
      {
         var _loc1_:* = this.numChildren - 1;
         while(_loc1_ >= 0)
         {
            this.removeChildAt(_loc1_);
            _loc1_--;
         }
      };

      public var MsgBox:MovieClip;

      public var ctr_watermark:MovieClip;

      public var mcAccount:MovieClip;

      public var mcExtSWF:MovieClip;

      public var mcLogin:MovieClip;

      public var ui:MovieClip;

      public var loader:mcLoader;

      public var csLoader:Loader;

      public var fileUrl:String;

      public var csbLoaded:Number;

      public var csbTotal:Number;

      public var clientVersion:Number;

      public var cVersion:String;

      public var sToken:String;

      public var failedServers:*;

      public var world:World;

      public var bagSpace:String = "interface/bagspace_2025.swf";

      public var bagBuyLabel:String = null;

      public var iMaxBagSlots:* = 400;

      public var iMaxBankSlots:* = 450;

      public var iMaxHouseSlots:* = 250;

      public var iMaxFriends:* = 225;

      public var iMaxLoadoutSlots:* = 20;

      private var swfObj:String = "AQWGame";

      private var _colorCache:Dictionary;

      public var showFB:Boolean = false;

      public var fbL:fbLinkWindow;

      public var titleDomain:ApplicationDomain;

      public var mcO:MovieClip;

      private var rn:RandomNumber;

      public var elmType:String;

      public var assetsDomain:ApplicationDomain;

      public var assetsContext:LoaderContext;

      public var handleSessionEvent:Function;

      public const EMAIL_REGEX:RegExp;

      public var mixer:SoundFX;

      public var sfc:SmartFoxClient;

      public var chatF:*;

      public var mailHub:* = null;

      public var sFilePath:String = "";

      public var params:Object;

      public var userPreference:SharedObject;

      public var litePreference:SharedObject;

      public var uoPref:Object;

      public var litePref:Array;

      public var loginLoader:URLLoader;

      public var objServerInfo:Object;

      public var sfcSocial:Boolean = false;

      public var ldrMC:LoaderMC;

      public var mcConnDetail:ConnDetailMC;

      public var querystring:Object;

      public var ts_login_server:Number;

      public var ts_login_client:Number;

      public var aaaloop:int = 0;

      public var totalPingTime:Number = 0;

      public var pingCount:int = 0;

      public var arrRanks:Vector.<int>;

      public var iRankMax:int = 10;

      public var arrHP:Vector.<int>;

      private var aswc:Apop;

      public var hasPreviewed:Boolean;

      public var intLevelCap:int;

      public var PCstBase:int;

      public var PCstRatio:Number;

      public var PCstGoal:int;

      public var GstBase:int;

      public var GstRatio:Number;

      public var GstGoal:int;

      public var PChpBase1:int;

      public var PChpBase100:int;

      public var PChpGoal1:int;

      public var PChpGoal100:int;

      public var PChpDelta:int;

      public var intHPperEND:int;

      public var intAPtoDPS:int;

      public var intSPtoDPS:int;

      public var bigNumberBase:int;

      public var resistRating:Number;

      public var modRating:Number;

      public var baseDodge:Number;

      public var baseBlock:Number;

      public var baseParry:Number;

      public var baseCrit:Number;

      public var baseHit:Number;

      public var baseHaste:Number;

      public var baseMiss:Number;

      public var baseResist:Number;

      public var baseCritValue:Number;

      public var baseBlockValue:Number;

      public var baseResistValue:Number;

      public var baseEventValue:Number;

      public var PCDPSMod:Number = 0.85;

      public var curveExponent:Number = 0.66;

      public var statsExponent:Number = 1.33;

      public var stats:Vector.<String>;

      public var orderedStats:Vector.<String>;

      public var ratiosBySlot:Object;

      public var I0pct:Number = 0.8;

      public var I2pct:Number = 1.25;

      public var classCatMap:Object;

      private var coreValues:Object;

      private var travelMapData:Object;

      private var WorldMapData:worldMap;

      private var skipR2:Boolean = false;

      private var apop_:apopCore;

      public var apopTree:Object;

      public var curID:String;

      public var serialCmdMode:Boolean = false;

      public var serialCmd:Object;

      private var conn:*;

      public var confirmTime:int = 0;

      public var quests:Boolean = false;

      public var bits:Vector.<uint>;

      private var fbc:MovieClip;

      public var mcGameMenu:MovieClip;

      public var firstMenu:Boolean = true;

      public var bPassword:Boolean = true;

      public var flushPendingSelfInitData:Function;

      public var pDash:Boolean;

      internal var cancelTargetTimer:Timer;

      public var keyDict:Dictionary;

      private var travelLoaderMC:*;

      public var TRAVEL_DATA_READY:Boolean = false;

      private var mapUILoader:Loader;

      private var bLoaded:Number = 0;

      private var bTotal:Number = 0;

      private var weakPass:Array;

      private var gameMenuLoader:Loader;

      private var gameMenuURL:String;

      private var gameMenuRetried:Boolean = false;

      private var gameMenuBuildPending:Boolean = false;

      public var extCall:ExternalCalls;

      public var FBConnectCallback:Function;

      public var sBG:String = "generic2.swf";

      public var IsEU:Boolean = false;

      public var TempLoginName:* = "";

      public var TempLoginPass:* = "";

      public var mtcidNow:Number;

      public var intChatMode:int;

      public var serverPath:String;

      private var focusGuardPending:Boolean = false;

      public var playerPollData:Object;

      private var characters:SharedObject;

      public var csShowServers:Boolean = false;

      public var mcCharSelect:*;

      private var pendingAssetsFile:String = "";

      private var assetsLoader:Loader;

      internal var interfaceQueue:Array;

      internal var visualLoader:*;

      public var interfaceRef:Object;

      internal var interfaceLoaded:Number = 0;

      internal var interfaceTotal:Number = 0;

      public var BOOK_DATA_READY:* = null;

      private var bookInfo:Object = null;

      public var bolLoader:Loader;

      public var bolContent:MovieClip;

      private var bookLoaderMC:*;

      private var uncaughtSeen:Object;

      private var uncaughtCount:int = 0;

      public var equipPotionOnSeia:Boolean;

      public var lastPing:Number = 0;

      public var lastPingTime:uint = 0;

      public var lastPingValues:Array;

      public var bankFiltersMC:bankFilters;

      public var pLoggerUI:packetlogger;

      public var cMenuUI:cellMenu;

      public var cDropsUI:customDrops;

      public var pAurasUI:playerAuras;

      public var tAurasUI:targetAuras;

      public var partyDrag:HudDrag;

      public var bAnalyzer:battleAnalyzer;

      private var authoredFPS:Number = 0;

      public var crowdOn:Boolean = false;

      private var crowdLow:int = 0;

      private var crowdN0:int = 0;

      private var crowdCell:String = "";

      public var cameraToolMC:cameraTool;

      private var csFontName:String = null;

      private var csFontChecked:Boolean = false;

      internal var petDisable:Timer;

      public var portraitsCnt:Array;

      public var pinnedQuests:String;

      internal var disableTimer:Timer;

      public var regExLineSpace:RegExp;

      public var procInfo:Object;

      public var showServers:Boolean = false;

      public var baseClassStats:Object;

      private var statsNewClass:Boolean = false;

      private var mcStatsPanel:MovieClip;

      private var pvpQueueMins:Number = NaN;

      public function Game()
      {
         var isWarned:*;
         var closeBankBatch:*;
         var onMultiConnectionHandler:*;
         var onMultiConnectionLostHandler:*;
         var onMultiLogoutHandler:*;
         var onMultiLoginHandler:*;
         var onJoinRoomHandler:*;
         var onUserEnterRoomHandler:*;
         var onUserVariablesUpdateHandler:*;
         var onRoomListUpdateHandler:*;
         var onRoomVariablesUpdateHandler:*;
         var onRoomAddedHandler:*;
         var onPublicMessageHandler:*;
         var onPrivateMessageHandler:*;
         var onModeratorMessage:*;
         var applyInitUserData:*;
         var gameSelf:Game = null;
         var onConnectionHandler:* = undefined;
         var onConnectionLostHandler:* = undefined;
         var onLoginHandler:* = undefined;
         var onLogoutHandler:* = undefined;
         var onUserLeaveRoomHandler:* = undefined;
         var onObjectReceivedHandler:* = undefined;
         var onRoundTripResponseHandler:* = undefined;
         var isNewClass:Boolean = false;
         var pendingSelfGuild:Object = null;
         var pendingSelfInitData:Object = null;
         var applyPendingSelfInitData:* = undefined;
         var onExtensionResponseHandler:* = undefined;
         this.clientVersion = Number(vParam);
         this.cVersion = vParam;
         this.failedServers = {};
         this._colorCache = new Dictionary(true);
         this.rn = new RandomNumber();
         this.assetsDomain = new ApplicationDomain();
         this.assetsContext = new LoaderContext(false,this.assetsDomain);
         this.EMAIL_REGEX = /^[A-Z0-9._%+-]+@(?:[A-Z0-9-]+\.)+[A-Z]{2,4}$/i;
         this.mixer = new SoundFX(this.assetsDomain);
         this.params = {};
         this.uoPref = {};
         this.litePref = [];
         this.loginLoader = new URLLoader();
         this.ldrMC = new LoaderMC(MovieClip(this));
         this.querystring = {};
         this.arrRanks = new <int>[0];
         this.arrHP = new Vector.<int>();
         this.stats = new <String>["STR","END","DEX","INT","WIS","LCK"];
         this.orderedStats = new <String>["STR","INT","DEX","WIS","END","LCK"];
         this.ratiosBySlot = {
            "he":0.25,
            "ar":0.25,
            "ba":0.2,
            "Weapon":0.33
         };
         this.classCatMap = {
            "M1":{},
            "M2":{},
            "M3":{},
            "M4":{},
            "C1":{},
            "C2":{},
            "C3":{},
            "S1":{}
         };
         this.coreValues = {
            "PCstRatio":7.47,
            "PChpDelta":1640,
            "PChpBase1":360,
            "baseHit":0,
            "intSPtoDPS":10,
            "resistRating":17,
            "curveExponent":0.66,
            "baseCritValue":1.5,
            "PChpGoal100":4000,
            "intLevelCap":100,
            "baseMiss":0.1,
            "baseParry":0.03,
            "GstBase":12,
            "modRating":3,
            "baseResistValue":0.7,
            "baseBlockValue":0.7,
            "intHPperEND":5,
            "baseHaste":0,
            "baseBlock":0,
            "statsExponent":1,
            "PChpBase100":2000,
            "intAPtoDPS":10,
            "PCstBase":15,
            "baseCrit":0.05,
            "baseEventValue":0.05,
            "GstGoal":572,
            "PChpGoal1":400,
            "GstRatio":5.6,
            "intLevelMax":100,
            "bigNumberBase":8,
            "PCstGoal":762,
            "baseDodge":0.04,
            "PCDPSMod":0.85
         };
         this.apopTree = new Object();
         this.serialCmd = {
            "cmd":"",
            "si":0,
            "servers":[],
            "callBack":this.serialCmdDone,
            "active":false
         };
         this.bits = new <uint>[1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768,65536,131072,262144,524288,1048576,2097152,4194304,8388608,16777216,33554432,67108864,134217728,268435456,536870912,1073741824,2147483648];
         this.cancelTargetTimer = new Timer(5000,1);
         this.weakPass = new Array("0","1111","11111","111111","11111111","112233","1212","121212","123123","1234","12345","123456","1234567","12345678","1313","131313","2000","2112","2222","232323","3333","4128","4321","4444","5150","5555","654321","6666","666666","6969","696969","7777","777777","7777777","8675309","987654","aaaa","aaaaaa","abc123","abgrtyu","access","access14","action","albert","alex","alexis","amanda","amateur","andrea","andrew","angel","angela","angels","animal","anthony","apollo","apple","apples","arsenal","arthur","asdf","asdfgh","ashley","asshole","august","austin","baby","badboy","bailey","banana","barney","baseball","batman","beach","bear","beaver","beavis","beer","bigcock","bigdaddy","bigdick","bigdog","bigtits","bill","billy","birdie","bitch","bitches","biteme","black","blazer","blonde","blondes","blowjob","blowme","blue","bond007","bonnie","booboo","boobs","booger","boomer","booty","boston","brandon","brandy","braves","brazil","brian","bronco","broncos","bubba","buddy"
         ,"bulldog","buster","butter","butthead","calvin","camaro","cameron","canada","captain","carlos","carter","casper","charles","charlie","cheese","chelsea","chester","chevy","chicago","chicken","chris","cocacola","cock","coffee","college","compaq","computer","cookie","cool","cooper","corvette","cowboy","cowboys","cream","crystal","cumming","cumshot","cunt","dakota","dallas","daniel","danielle","dave","david","debbie","dennis","diablo","diamond","dick","dirty","doctor","doggie","dolphin","dolphins","donald","dragon","dreams","driver","eagle","eagle1","eagles","edward","einstein","enjoy","enter","eric","erotic","extreme","falcon","fender","ferrari","fire","firebird","fish","fishing","florida","flower","flyers","football","ford","forever","frank","fred","freddy","freedom","fuck","fucked","fucker","fucking","fuckme","fuckyou","gandalf","gateway","gators","gemini","george","giants","ginger","girl","girls","golden","golf","golfer","gordon","great","green","gregory","guitar","gunner","hammer","hannah"
         ,"happy","hardcore","harley","heather","hello","helpme","hentai","hockey","hooters","horney","horny","hotdog","house","hunter","hunting","iceman","iloveyou","internet","iwantu","jack","jackie","jackson","jaguar","jake","james","japan","jasmine","jason","jasper","jennifer","jeremy","jessica","john","johnny","johnson","jordan","joseph","joshua","juice","junior","justin","kelly","kevin","killer","king","kitty","knight","ladies","lakers","lauren","leather","legend","letmein","little","london","love","lover","lovers","lucky","maddog","madison","maggie","magic","magnum","marine","mark","marlboro","martin","marvin","master","matrix","matt","matthew","maverick","maxwell","melissa","member","mercedes","merlin","michael","michelle","mickey","midnight","mike","miller","mine","mistress","money","monica","monkey","monster","morgan","mother","mountain","movie","muffin","murphy","music","mustang","naked","nascar","nathan","naughty","ncc1701","newyork","nicholas","nicole","nipple","nipples","oliver","orange"
         ,"ou812","packers","panther","panties","paris","parker","pass","password","patrick","paul","peaches","peanut","penis","pepper","peter","phantom","phoenix","player","please","pookie","porn","porno","porsche","power","prince","princess","private","purple","pussies","pussy","qazwsx","qwert","qwerty","qwertyui","rabbit","rachel","pokemon","racing","raiders","rainbow","ranger","rangers","rebecca","redskins","redsox","redwings","richard","robert","rock","rocket","rosebud","runner","rush2112","russia","samantha","sammy","samson","sandra","saturn","scooby","scooter","scorpio","scorpion","scott","secret","sexsex","sexy","shadow","shannon","shaved","shit","sierra","silver","skippy","slayer","slut","smith","smokey","snoopy","soccer","sophie","spanky","sparky","spider","squirt","srinivas","star","stars","startrek","starwars","steelers","steve","steven","sticky","stupid","success","suckit","summer","sunshine","super","superman","surfer","swimming","sydney","taylor","teens","tennis","teresa","test","tester"
         ,"testing","theman","thomas","thunder","thx1138","tiffany","tiger","tigers","tigger","time","tits","tomcat","topgun","toyota","travis","trouble","trustno1","tucker","turtle","united","vagina","victor","victoria","video","viking","viper","voodoo","voyager","walter","warrior","welcome","whatever","white","william","willie","wilson","winner","winston","winter","wizard","wolf","women","xavier","xxxx","xxxxx","xxxxxx","xxxxxxxx","yamaha","yankee","yankees","yellow","young","zxcvbn","zxcvbnm","zzzzzz","artix","aqworlds","adventure","mechquest","dragonfable","123456789","1234567890","987654321","0123456789","12345678910","qwertyuiop","123123123","asdfghjkl","123321","0987654321","147258369","789456123","159753","741852963","minecraft","147852369","0123456","qwerty123","123654789","naruto","9876543210","12341234","123qwe","159357","123654","gabriel","123456789a");
         this.characters = getCharStore();
         this.interfaceQueue = [];
         this.interfaceRef = new Object();
         this.uncaughtSeen = {};
         this.lastPingValues = [];
         this.petDisable = new Timer(0);
         this.portraitsCnt = [];
         this.disableTimer = new Timer(50,1);
         this.regExLineSpace = /(\r\n)/gi;
         this.procInfo = {};
         super();
         onConnectionHandler = function(param1:SFSEvent):*
         {
            if(param1.params.success)
            {
               sfc.login(cLoginZone,clientToken + "~" + loginInfo.strUsername + "~" + clientVersion,loginInfo.strToken);
               if(world != null)
               {
                  world.uiLock = true;
               }
            }
            else
            {
               trace("[Net] ERR connection failed");
               if(serialCmdMode)
               {
                  serialCmdNext();
               }
            }
         };
         isWarned = function():Boolean
         {
            var curTS:Number = NaN;
            var iDiff:Number = NaN;
            if("logoutWarningTS" in userPreference.data)
            {
               curTS = new Date().getTime();
               iDiff = userPreference.data.logoutWarningTS + userPreference.data.logoutWarningDur * 1000 - curTS;
               if(iDiff > 60000)
               {
                  userPreference.data.logoutWarningDur = 60;
                  userPreference.data.logoutWarningTS = curTS;
                  try
                  {
                     userPreference.flush();
                  }
                  catch(e:Error)
                  {
                     trace("[Net] ERR isWarned flush: " + e.message);
                  }
               }
               if(iDiff > 1000)
               {
                  return true;
               }
            }
            return false;
         };
         onConnectionLostHandler = function(param1:SFSEvent):*
         {
            var e:SFSEvent = param1;
            var wasDisconnected:Boolean = false;
            closeBankBatch();
            mailStop();
            FavStore.reset();
            if(!serialCmdMode)
            {
               if(world != null)
               {
                  cleanupInterfaces();
                  world.exitCombat();
                  world.setTarget(null);
                  world.killTimers();
                  world.killListeners();
                  world.clearLoaders(true);
                  world.clearMonstersAndProps();
                  world.destroyAllAvatars();
                  try
                  {
                     world.removeChild(world.map);
                  }
                  catch(e:Error)
                  {
                     trace("[Net] ERR onConnectionLostHandler.removeMap: " + e.message);
                  }
                  removeChild(world);
                  world = null;
                  pendingSelfInitData = null;
                  pendingSelfGuild = null;
                  hasPreviewed = false;
                  SoundMixer.stopAll();
                  firstMenu = true;
                  resetGameMenu();
                  if(mcCharSelect)
                  {
                     if(mcCharSelect.parent != null)
                     {
                        MovieClip(mcCharSelect.parent).removeChild(mcCharSelect);
                     }
                     mcCharSelect = null;
                  }
               }
               if(sfc.isConnected)
               {
                  sfc.disconnect();
               }
               if(e.params != null)
               {
                  if(e.params.disconnect == true)
                  {
                     mcConnDetail.showDisconnect("Communication with server has been lost. Please check your internet connection and try again.");
                     wasDisconnected = true;
                  }
               }
               if(!wasDisconnected)
               {
                  if(showServers)
                  {
                     gotoAndPlay("Login");
                  }
                  else
                  {
                     gotoAndPlay(Boolean(charCount() > 0) && Boolean(litePreference.data.bCharSelect) && !isWarned() ? "Select" : "Login");
                  }
               }
            }
         };
         onLoginHandler = function(param1:SFSEvent):*
         {
         };
         closeBankBatch = function():void
         {
            try
            {
               if(LPFFrameBankAQ.active != null)
               {
                  LPFFrameBankAQ.active.fClose();
               }
            }
            catch(eBB:Error)
            {
               LPFFrameBankAQ.active = null;
            }
         };
         onLogoutHandler = function(param1:SFSEvent):*
         {
            var e:SFSEvent = param1;
            closeBankBatch();
            mailStop();
            FavStore.reset();
            if(!serialCmdMode)
            {
               if(world != null)
               {
                  cleanupInterfaces();
                  world.exitCombat();
                  world.setTarget(null);
                  world.killTimers();
                  world.killListeners();
                  world.clearLoaders(true);
                  world.clearMonstersAndProps();
                  world.destroyAllAvatars();
                  try
                  {
                     world.removeChild(world.map);
                  }
                  catch(e:Error)
                  {
                     trace("[Net] ERR onLogoutHandler.removeMap: " + e.message);
                  }
                  removeChild(world);
                  world = null;
                  pendingSelfInitData = null;
                  pendingSelfGuild = null;
                  hasPreviewed = false;
                  SoundMixer.stopAll();
                  firstMenu = true;
                  resetGameMenu();
                  if(mcCharSelect)
                  {
                     if(mcCharSelect.parent != null)
                     {
                        MovieClip(mcCharSelect.parent).removeChild(mcCharSelect);
                     }
                     mcCharSelect = null;
                  }
               }
               if(sfc.isConnected)
               {
                  sfc.disconnect();
               }
               if(FacebookConnect.isLoggedIn)
               {
                  FacebookConnect.Logout();
               }
               if(showServers)
               {
                  gotoAndPlay("Login");
               }
               else
               {
                  gotoAndPlay(Boolean(charCount() > 0) && Boolean(litePreference.data.bCharSelect) && !isWarned() ? "Select" : "Login");
               }
            }
            else
            {
               if(sfc.isConnected)
               {
                  sfc.disconnect();
               }
               serialCmdNext();
            }
         };
         onMultiConnectionHandler = function(param1:SFSEvent):*
         {
            if(param1.params.success)
            {
               this.sfc.login(cLoginZone,clientToken + "~" + this.sLogin,loginInfo.strToken);
            }
            else
            {
               trace("[Net] ERR multi connection failed: " + this.sLogin);
            }
         };
         onMultiConnectionLostHandler = function(param1:SFSEvent):*
         {
            trace("[Net] multi connection lost");
         };
         onMultiLogoutHandler = function(param1:SFSEvent):*
         {
            trace("[Net] multi connection logged out");
         };
         onMultiLoginHandler = function(param1:SFSEvent):*
         {
         };
         onJoinRoomHandler = function(param1:SFSEvent):*
         {
         };
         onUserEnterRoomHandler = function(param1:SFSEvent):*
         {
         };
         onUserLeaveRoomHandler = function(param1:SFSEvent):*
         {
            var _loc1_:int = 0;
            var _loc2_:* = undefined;
            _loc1_ = int(param1.params.userId);
            if(world == null || world.avatars == null)
            {
               return;
            }
            _loc2_ = world.avatars[_loc1_];
            if(_loc2_ != null)
            {
               if(world.myAvatar != null && _loc2_ == world.myAvatar.target)
               {
                  world.setTarget(null);
               }
               world.destroyAvatar(_loc1_);
            }
         };
         onUserVariablesUpdateHandler = function(param1:SFSEvent):*
         {
         };
         onRoomListUpdateHandler = function(param1:SFSEvent):*
         {
         };
         onRoomVariablesUpdateHandler = function(param1:SFSEvent):*
         {
         };
         onRoomAddedHandler = function(param1:SFSEvent):*
         {
         };
         onPublicMessageHandler = function(param1:SFSEvent):*
         {
         };
         onPrivateMessageHandler = function(param1:SFSEvent):*
         {
         };
         onModeratorMessage = function(param1:SFSEvent):*
         {
            var _loc1_:* = param1.params.message;
            var _loc2_:* = param1.params.sender;
         };
         onObjectReceivedHandler = function(param1:SFSEvent):*
         {
            var _loc1_:* = undefined;
            var _loc2_:* = undefined;
            var _loc3_:MovieClip = null;
            var _loc4_:* = undefined;
            var _loc5_:* = undefined;
            if(sfcSocial)
            {
               _loc1_ = param1.params.sender;
               _loc2_ = param1.params.obj;
               switch(_loc2_.typ)
               {
                  case "flourish":
                     if(world.CHARS.getChildByName(_loc2_.oName) != null)
                     {
                        MovieClip(world.CHARS.getChildByName(_loc2_.oName)).userName = _loc1_.getName();
                        MovieClip(world.CHARS.getChildByName(_loc2_.oName)).gotoAndPlay(_loc2_.oFrame);
                     }
                     break;
                  case "danceRequest":
                     if(_loc2_.cell == world.strFrame)
                     {
                        _loc4_ = new ModalMC();
                        _loc5_ = {};
                        _loc5_.strBody = "Would you care to dance?";
                        _loc5_.params = {};
                        _loc5_.params.emote1 = "/dance";
                        _loc5_.params.sender = _loc1_;
                        _loc5_.callback = world.danceRequest;
                        ui.ModalStack.addChild(_loc4_);
                        _loc4_.init(_loc5_);
                     }
                     break;
                  case "danceDenied":
                     if(_loc2_.cell == world.strFrame)
                     {
                        chatF.submitMsg("/cry","emotea",sfc.myUserName);
                     }
               }
            }
         };
         onRoundTripResponseHandler = function(param1:SFSEvent):void
         {
            var _loc1_:int = 0;
            _loc1_ = int(param1.params.elapsed);
            if(mcO)
            {
               mcO.averageLatency(_loc1_ / 2);
            }
         };
         applyPendingSelfInitData = function():void
         {
            var _loc6_:Object = null;
            if(pendingSelfInitData == null)
            {
               return;
            }
            _loc6_ = pendingSelfInitData;
            pendingSelfInitData = null;
            trace("[Resp] applying deferred initUserData");
            applyInitUserData(_loc6_);
         };
         applyInitUserData = function(param1:Object):void
         {
            var avt:* = undefined;
            var uoLeaf:Object = null;
            var resObj:Object = param1;
            try
            {
               avt = world.getAvatarByUserID(resObj.uid);
               uoLeaf = avt != null ? avt.dataLeaf : null;
               if(avt == null || uoLeaf == null)
               {
                  if(resObj.uid == sfc.myUserId)
                  {
                     pendingSelfInitData = resObj;
                     trace("[Resp] initUserData deferred: self avatar not ready uid " + resObj.uid);
                  }
                  return;
               }
               avt.initAvatar({"data":resObj.data});
               if(avt.isMyAvatar)
               {
                  avt.objData.strHomeTown = avt.objData.strMapName;
                  trace("[Resp] initUserData self uid: " + resObj.uid);
                  world.getInventory(resObj.uid);
                  try
                  {
                     world.initAchievements();
                     readIA1Preferences();
                     loadGameMenu();
                     try
                     {
                        if(avt.objData.guild == null && pendingSelfGuild != null)
                        {
                           avt.initGuild(pendingSelfGuild);
                        }
                        pendingSelfGuild = null;
                        if(avt.objData.guild == null)
                        {
                           sfc.sendXtMessage("zm","cmd",["guildrefresh"],"str",1);
                        }
                     }
                     catch(eG:Error)
                     {
                        trace("[Resp] ERR initUserData guild: " + eG.message);
                     }
                     if(avt.objData.guild != null)
                     {
                        chatF.chn.guild.act = 1;
                        if(String(avt.objData.guild.MOTD) != "undefined")
                        {
                           chatF.pushMsg("guild","Message of the day: " + String(avt.objData.guild.MOTD),"SERVER","",0);
                        }
                     }
                     if(Game.serverFilePath.indexOf("content.aq.com") == -1)
                     {
                        world.rootClass.extCall.showIt("login");
                     }
                     if(avt.objData.iUpg > 0)
                     {
                        if(avt.objData.iUpgDays < 0)
                        {
                           chatF.pushMsg("moderator","Your membership has expired. Please visit our website to renew your membership.","SERVER","",0);
                        }
                        else if(avt.objData.iUpgDays < 7)
                        {
                           chatF.pushMsg("moderator","Your membership will expire in " + (Number(avt.objData.iUpgDays) + 1) + " days. Please visit our website to renew your membership.","SERVER","",0);
                        }
                     }
                     updateXPBar();
                     setGoldDisplay(avt.objData.intGold);
                     if(ui.mcPopup.currentLabel == "Inventory" || ui.mcPopup.currentLabel == "HouseInventory")
                     {
                        MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshCoins"});
                     }
                  }
                  catch(eUI:Error)
                  {
                     debugMessage("initUserData ui: " + eUI.message);
                  }
               }
            }
            catch(e:Error)
            {
               trace("[Resp] ERR initUserData uid " + resObj.uid + ": " + e.message);
            }
         };
         onExtensionResponseHandler = function(param1:SFSEvent):*
         {
            var resObj:* = undefined;
            var protocol:* = undefined;
            var i:int = 0;
            var s:String = null;
            var j:int = 0;
            var o:Object = null;
            var a:Array = null;
            var b:Array = null;
            var mc:MovieClip = null;
            var tuo:* = undefined;
            var typ:String = null;
            var nam:String = null;
            var val:* = undefined;
            var msg:String = null;
            var msgT:String = null;
            var snd:String = null;
            var rcp:String = null;
            var org:* = undefined;
            var cmd:String = null;
            var anims:Array = null;
            var animIndex:uint = 0;
            var monAvt:Avatar = null;
            var avtAvt:Avatar = null;
            var Mon:Avatar = null;
            var avt:Avatar = null;
            var pMC:MovieClip = null;
            var unm:String = null;
            var uid:int = 0;
            var rmId:int = 0;
            var MonMapID:int = 0;
            var MonID:int = 0;
            var prop:String = null;
            var uoName:* = undefined;
            var uoLeaf:Object = null;
            var monLeaf:Object = null;
            var cLeaf:Object = null;
            var tLeaf:Object = null;
            var actObj:Object = null;
            var cell:String = null;
            var st:int = 0;
            var sta:String = null;
            var evt:String = null;
            var modal:MovieClip = null;
            var modalO:Object = null;
            var modalRR:* = undefined;
            var modalORR:Object = null;
            var silentMute:int = 0;
            var filter:int = 0;
            var updateID:String = null;
            var updateA:Array = null;
            var updateN:String = null;
            var updateO:Object = null;
            var iSel:Object = null;
            var kv:Array = null;
            var eSel:Object = null;
            var dat:Date = null;
            var now:Number = NaN;
            var res:* = undefined;
            var newmon:Object = null;
            var cluster:* = undefined;
            var strMsg:* = undefined;
            var strLabel:* = undefined;
            var str:* = undefined;
            var slots:int = 0;
            var dest:* = undefined;
            var dt:* = undefined;
            var motd:* = undefined;
            var vars:Array = null;
            var MonMapIDs:* = undefined;
            var id:* = undefined;
            var strMonName:String = null;
            var rand:int = 0;
            var clMon:* = undefined;
            var tAvt:Avatar = null;
            var cAvt:Avatar = null;
            var strF:String = null;
            var intf:* = undefined;
            var mcQFrame:* = undefined;
            var ulo:* = undefined;
            var myLeaf:* = undefined;
            var wasInvLoaded:Boolean = false;
            var adShown:Boolean = false;
            var testDate:Date = null;
            var mDropsPanel:* = undefined;
            var dropItem:* = undefined;
            var keptAuras:Array = null;
            var droppedAuras:Array = null;
            var anim:Object = null;
            var POTION_SLOT:int = 0;
            var updateCtr:int = 0;
            var ai:int = 0;
            var supressMupltiples:* = undefined;
            var isYou:* = undefined;
            var sMsg:* = undefined;
            var arrWearableSpots:* = undefined;
            var spot:String = null;
            var costumeItem:* = undefined;
            var auD:String = null;
            var bi:int = 0;
            var branchA:Object = null;
            var seedAu:Array = null;
            var uAura:Object = null;
            var mID:String = null;
            var mi:int = 0;
            var psES:* = undefined;
            var deltaXP:int = 0;
            var xp:* = undefined;
            var xpB:* = undefined;
            var deltaGold:int = 0;
            var gold:* = undefined;
            var deltaCP:int = 0;
            var iRank:* = undefined;
            var txtBonusCP:String = null;
            var flo:* = undefined;
            var friend:* = undefined;
            var fct:Function = null;
            var item:* = undefined;
            var sMeta:String = null;
            var dID:* = undefined;
            var dItem:* = undefined;
            var iData:* = undefined;
            var isOK:Boolean = false;
            var bItem:* = undefined;
            var mdID:* = undefined;
            var dropitem:* = undefined;
            var ItemID:* = undefined;
            var itemObj:* = undefined;
            var fi:* = undefined;
            var iobj:* = undefined;
            var itemArr:* = undefined;
            var dropindex:* = undefined;
            var dropID:* = undefined;
            var dropQty:int = 0;
            var qi:String = null;
            var qr:String = null;
            var qj:String = null;
            var qk:String = null;
            var qat:Array = null;
            var ri:* = undefined;
            var fgWin:* = undefined;
            var m:* = undefined;
            var clrAura:Object = null;
            var k:* = undefined;
            var bpObj:* = undefined;
            var bpAvt:* = undefined;
            var oldActions:* = undefined;
            var tempActionMap:Vector.<Object> = null;
            var blanki:* = undefined;
            var actBar:* = undefined;
            var delIcon:* = undefined;
            var uiSlot:int = 0;
            var actIconClass:Class = null;
            var actIcon:* = undefined;
            var actIconMC:* = undefined;
            var blankMC:* = undefined;
            var isNotUnlocked:Boolean = false;
            var existing:* = undefined;
            var c:Color = null;
            var stuS:String = null;
            var hasteCoeff:Number = NaN;
            var cd:* = undefined;
            var stu:String = null;
            var mcPath:* = undefined;
            var e:SFSEvent = param1;
            resObj = e.params.dataObj;
            protocol = e.params.type;
            i = 0;
            s = "";
            j = 0;
            prop = "";
            var updated:Object = {};
            silentMute = 0;
            filter = 0;
            var cInf:String = "";
            var tInf:String = "";
            var cTyp:String = "";
            var cID:int = -1;
            var tTyp:String = "";
            var tID:int = -1;
            var ul:Array = [];
            dat = new Date();
            now = dat.getTime();
            if(protocol == "str")
            {
               cmd = resObj[0];
               if(sfc.debug)
               {
                  trace("[Resp] str: " + cmd);
               }
               switch(cmd)
               {
                  case "dungeonCompleted":
                     world.mapEventTrigger({"cmd":"DungeonComplete"});
                     break;
                  case "dungeonMTC":
                     res = resObj[2] == "true";
                     if(res)
                     {
                        dest = String(resObj[3]).split(",");
                        world.moveToCell(dest[0],dest[1],true);
                     }
                     break;
                  case "hi":
                     if(mcO)
                     {
                        mcO.latency -= new Date().getTime();
                        mcO.latency = Math.ceil(Math.abs(mcO.latency) / 2);
                        mcO.updateLatency();
                     }
                     break;
                  case "loginResponse":
                     showTracking("5");
                     if(resObj[2] == 1 || resObj[2] == "true" || resObj[2] == "True")
                     {
                        ctr_watermark.visible = objServerInfo.sName == "Class Test Realm";
                        mcConnDetail.showConn("Loading Character Data...");
                        pendingSelfGuild = null;
                        sfc.myUserId = Number(resObj[3]);
                        sfc.myUserName = String(resObj[4]);
                        ts_login_client = now;
                        dt = stringToDate(resObj[6]);
                        ts_login_server = dt.getTime();
                        motd = "Message of The Day: Staff will never ask for your password! If someone asks for your password, report them for Griefing. NEVER share your password!";
                        chatF.pushMsg("moderator",motd,"SERVER","",0);
                        chatF.pushMsg("server","The server time is now " + dt.toString(),"SERVER","",0);
                        vars = resObj[7].split(",");
                        retrieveInfo(vars);
                        confirmTime = getTimer();
                     }
                     else
                     {
                        mcConnDetail.showError(resObj[5]);
                     }
                     break;
                  case "loginIterator":
                     if(resObj[2] == 1 || resObj[2] == "true")
                     {
                        sfc.myUserId = Number(resObj[3]);
                        sfc.myUserName = String(resObj[4]);
                        chatF.submitMsg(serialCmd.cmd,"serialCmd",serialCmdMode ? "iterator" : sfc.myUserName);
                     }
                     else
                     {
                        mcConnDetail.showError("Login Failed!");
                     }
                     break;
                  case "iterator":
                     sfc.logout();
                     break;
                  case "loginMulti":
                     if(!(resObj[2] == 1 || resObj[2] == "true"))
                     {
                        mcConnDetail.showError("Login Failed!");
                     }
                     break;
                  case "notify":
                     typ = "server";
                     msg = resObj[2];
                     msg = chatF.cleanChars(msg);
                     msg = chatF.cleanStr(msg);
                     chatF.pushMsg(typ,msg,"SERVER","",0);
                     MsgBox.notify(msg);
                     break;
                  case "logoutWarning":
                     userPreference.data.logoutWarning = String(resObj[2]);
                     userPreference.data.logoutWarningDur = Number(resObj[3]);
                     userPreference.data.logoutWarningTS = now;
                     try
                     {
                        userPreference.flush();
                     }
                     catch(e:Error)
                     {
                        trace("[Resp] ERR logoutWarning flush: " + e.message);
                     }
                     break;
                  case "multiLoginWarning":
                     mcConnDetail.showError("Your AQWorlds game account has been logged on from another window session or computer, or you made changes in Manage Account.");
                     break;
                  case "server":
                     if(serialCmdMode)
                     {
                        msg = resObj[2];
                        mcLogin.il.cmd.msgBox.text += "[" + serialCmd.servers[serialCmd.si - 1].sName + "]: " + msg + "\n";
                        mcLogin.il.cmd.msgBox.scrollV = mcLogin.il.cmd.msgBox.maxScrollV;
                        break;
                     }
                     typ = "server";
                     msg = resObj[2];
                     msg = chatF.cleanChars(msg);
                     msg = chatF.cleanStr(msg);
                     chatF.pushMsg(typ,msg,"SERVER","",0);
                     break;
                  case "serverf":
                     msg = String(resObj[2]);
                     typ = "server";
                     str = chatF.cleanStr(msg);
                     unm = String(resObj[3]);
                     uid = int(resObj[4]);
                     rmId = int(resObj[5]);
                     msg = chatF.cleanChars(msg);
                     msgT = stripWhite(msg.toLowerCase());
                     if(chatF.strContains(msgT,chatF.illegalStrings))
                     {
                        silentMute = 1;
                     }
                     msgT = stripWhiteStrict(msg.toLowerCase());
                     if(chatF.strContains(msgT,["email","password"]))
                     {
                        silentMute = 1;
                     }
                     if(!silentMute)
                     {
                        chatF.pushMsg(typ,msg,"SERVER","",0);
                     }
                     break;
                  case "popup":
                     switch(resObj[2])
                     {
                        case "moderator":
                        case "warning":
                        case "server":
                           typ = resObj[2];
                           msg = resObj[3];
                           msg = chatF.cleanChars(msg);
                           msg = chatF.cleanStr(msg);
                           chatF.pushMsg(typ,msg,"SERVER","",0);
                           break;
                        case "blackbanner":
                           MsgBox.notify(resObj[3]);
                           break;
                        case "update":
                           addUpdate(resObj[3]);
                           break;
                        case "messagebox":
                           showMessageBox(resObj[3]);
                     }
                     break;
                  case "moderator":
                     typ = "moderator";
                     msg = resObj[2];
                     msg = chatF.cleanChars(msg);
                     msg = chatF.cleanStr(msg);
                     chatF.pushMsg(typ,msg,"SERVER","",0);
                     break;
                  case "wheel":
                     if(sfcSocial)
                     {
                        typ = "wheel";
                        msg = resObj[2];
                        msg = chatF.cleanChars(msg);
                        msg = chatF.cleanStr(msg);
                        chatF.pushMsg(typ,msg,"SERVER","",0);
                     }
                     break;
                  case "gsupdate":
                     try
                     {
                        world.map.killCount(resObj[2]);
                     }
                     catch(e:*)
                     {
                        trace("[Resp] ERR gsupdate: " + e);
                     }
                     break;
                  case "frostupdate":
                     try
                     {
                        world.map.frostWar(resObj[2],resObj[3]);
                     }
                     catch(e:*)
                     {
                        trace("[Resp] ERR frostupdate: " + e);
                     }
                     break;
                  case "warning":
                     typ = "warning";
                     msg = resObj[2];
                     msg = chatF.cleanChars(msg);
                     msg = chatF.cleanStr(msg);
                     chatF.pushMsg(typ,msg,"SERVER","",0);
                     if(LPFFrameBankAQ.active != null)
                     {
                        LPFFrameBankAQ.active.serverWarning(String(resObj[2]));
                     }
                     break;
                  case "respawnMon":
                     if(world.strMapName == "caroling" && world.CarolingMonsterKillCount >= 5)
                     {
                        break;
                     }
                     if(sfcSocial)
                     {
                        MonMapIDs = resObj[2].split(",");
                        for(id in MonMapIDs)
                        {
                           Mon = world.getMonster(MonMapIDs[id]);
                           monLeaf = world.monTree[MonMapIDs[id]];
                           if(Mon != null && Mon.pMC != null && monLeaf != null && Mon.objData != null && Mon.objData.strFrame == world.strFrame)
                           {
                              monLeaf.targets = {};
                              strMonName = "";
                              if(Number(world.objExtra["bMonName"]) == 1)
                              {
                                 rand = Math.round(Math.random() * (world.chaosNames.length - 1));
                                 if(world.chaosNames[rand] == world.myAvatar.objData.strUsername)
                                 {
                                    rand = rand == 0 ? ++rand : --rand;
                                 }
                                 strMonName = world.chaosNames[rand];
                              }
                              Mon.pMC.respawn(strMonName);
                              Mon.pMC.x = Mon.pMC.ox;
                              Mon.pMC.y = Mon.pMC.oy;
                              if(Mon.objData.bRed == 1 && world.myAvatar.dataLeaf.intState > 0)
                              {
                                 world.aggroMon(MonMapIDs[id]);
                              }
                           }
                        }
                     }
                     break;
                  case "resTimed":
                     if(resObj.length > 2 && String(resObj[2]) != null && String(resObj[3]) != null)
                     {
                        world.moveToCell(String(resObj[2]),String(resObj[3]));
                     }
                     else
                     {
                        world.moveToCell(world.spawnPoint.strFrame,world.spawnPoint.strPad);
                     }
                     world.map.transform.colorTransform = world.defaultCT;
                     world.CHARS.transform.colorTransform = world.defaultCT;
                     break;
                  case "exitArea":
                     uid = int(resObj[2]);
                     unm = String(resObj[3]);
                     avt = world.avatars[uid];
                     delete world.uoTree[unm];
                     if(avt != null)
                     {
                        if(world.myAvatar != null && avt == world.myAvatar.target)
                        {
                           world.setTarget(null);
                        }
                        world.destroyAvatar(uid);
                     }
                     try
                     {
                        world.manageAreaUser(unm,"-");
                        if(world.isPartyMember(unm))
                        {
                           world.updatePartyFrame({
                              "unm":unm,
                              "range":false
                           });
                        }
                        if(ui.mcInterface.areaList.currentLabel == "hold")
                        {
                           areaListGet();
                        }
                     }
                     catch(eEA:Error)
                     {
                        trace("[Resp] ERR exitArea post: " + eEA.message);
                     }
                     break;
                  case "uotls":
                     o = {};
                     a = resObj[3].split(",");
                     i = 0;
                     while(i < a.length)
                     {
                        kv = a[i].split(":");
                        o[kv[0]] = kv[1];
                        i++;
                     }
                     userTreeWrite(String(resObj[2]),o);
                     if(ui.mcInterface.areaList.currentLabel == "hold")
                     {
                        areaListGet();
                     }
                     break;
                  case "mtls":
                     o = {};
                     a = resObj[3].split(",");
                     i = 0;
                     while(i < a.length)
                     {
                        kv = a[i].split(":");
                        o[kv[0]] = kv[1];
                        i++;
                     }
                     monsterTreeWrite(int(resObj[2]),o);
                     break;
                  case "spcs":
                     MonMapID = int(resObj[2]);
                     MonID = int(resObj[3]);
                     monLeaf = world.monTree[MonMapID];
                     newmon = {};
                     i = 0;
                     while(i < world.mondef.length)
                     {
                        if(world.mondef[i].MonID == MonID)
                        {
                           newmon = world.mondef[i];
                           i = int(world.mondef.length);
                        }
                        i++;
                     }
                     monLeaf.intHP = 0;
                     monLeaf.intMP = 0;
                     monLeaf.intHPMax = newmon.intHPMax;
                     monLeaf.intMPMax = newmon.intMPMax;
                     monLeaf.intState = 0;
                     monLeaf.iLvl = newmon.iLvl;
                     monLeaf.MonID = MonID;
                     cluster = world.getMonsterCluster(MonMapID);
                     i = 0;
                     while(i < cluster.length)
                     {
                        clMon = cluster[i];
                        if(monLeaf.MonID == clMon.objData.MonID)
                        {
                           if(monLeaf.strFrame == world.strFrame && clMon.pMC != null)
                           {
                              world.CHARS.addChild(clMon.pMC);
                           }
                           clMon.dataLeaf = monLeaf;
                        }
                        else
                        {
                           if(monLeaf.strFrame == world.strFrame && clMon.pMC != null)
                           {
                              world.TRASH.addChild(clMon.pMC);
                           }
                           clMon.dataLeaf = null;
                        }
                        i++;
                     }
                     break;
                  case "cc":
                     strMsg = chatF.getCCText(resObj[2]);
                     unm = String(resObj[3]);
                     if(chatF.ignoreList.data.users != undefined)
                     {
                        if(chatF.ignoreList.data.users.indexOf(unm) > -1)
                        {
                           filter = 1;
                        }
                     }
                     if(filter == 0)
                     {
                        chatF.pushMsg("zone",strMsg,unm,"",0);
                     }
                     break;
                  case "emotea":
                     strLabel = String(resObj[2]);
                     uid = int(resObj[3]);
                     pMC = world.getMCByUserID(uid);
                     if(pMC != null)
                     {
                        pMC.mcChar.gotoAndPlay(strToProperCase(strLabel));
                     }
                     break;
                  case "em":
                     unm = String(resObj[2]);
                     msg = chatF.cleanStr(String(resObj[3]));
                     while(msg.indexOf("  ") > -1)
                     {
                        msg = msg.split("  ").join(" ");
                     }
                     msg = chatF.cleanChars(msg);
                     trace("[Resp] em recv: " + unm + " :: " + msg);
                     msgT = stripWhiteStrict(msg.toLowerCase());
                     if(chatF.strContains(msgT,chatF.illegalStrings))
                     {
                        silentMute = 1;
                     }
                     if(!silentMute && msg.length > 0)
                     {
                        chatF.pushMsg("event",msg,unm,"",0);
                     }
                     break;
                  case "chatm":
                     str = String(resObj[2]);
                     str = chatF.cleanStr(str,true,false,Boolean(int(resObj[6])));
                     unm = String(resObj[3]);
                     uid = int(resObj[4]);
                     rmId = int(resObj[5]);
                     typ = str.substr(0,str.indexOf("~"));
                     msg = str.substr(str.indexOf("~") + 1);
                     msg = chatF.cleanChars(msg);
                     if(chatF.ignoreList.data.users != undefined)
                     {
                        if(chatF.ignoreList.data.users.indexOf(unm.toLowerCase()) > -1)
                        {
                           filter = 1;
                        }
                     }
                     if(!filter)
                     {
                        chatF.pushMsg(typ,msg,unm.toLowerCase() == unm ? unm.charAt(0).toUpperCase() + unm.slice(1) : unm,uid,0,int(resObj[6]));
                     }
                     break;
                  case "whisper":
                     typ = "whisper";
                     msg = resObj[2];
                     snd = String(resObj[3]);
                     rcp = String(resObj[4]);
                     org = resObj[5];
                     msg = chatF.cleanStr(msg);
                     msg = chatF.cleanChars(msg);
                     silentMute = 0;
                     if(msg.indexOf(":=sm") > -1)
                     {
                        msg = msg.substr(0,msg.indexOf(":=sm"));
                        if(unm != sfc.myUserName)
                        {
                           silentMute = 1;
                        }
                     }
                     if(chatF.ignoreList.data.users != undefined)
                     {
                        if(chatF.ignoreList.data.users.indexOf(snd.toLowerCase()) > -1)
                        {
                           filter = 1;
                        }
                     }
                     if(!filter && (Boolean(!silentMute) || Boolean(silentMute && snd == rcp)))
                     {
                        if(snd.toLowerCase() != sfc.myUserName.toLowerCase())
                        {
                           chatF.pmSourceA = [snd];
                           if(chatF.pmSourceA.length > 20)
                           {
                              chatF.pmSourceA.splice(0,chatF.pmSourceA.length - 20);
                           }
                        }
                        if(org == 1)
                        {
                           chatF.pushMsg(typ,msg,snd,rcp,0);
                           chatF.pushMsg(typ,msg,snd,rcp,1);
                        }
                        else
                        {
                           chatF.pushMsg(typ,msg,snd,rcp,org,int(resObj[6]));
                        }
                     }
                     break;
                  case "mute":
                     chatF.muteMe(int(resObj[2]));
                     break;
                  case "unmute":
                     chatF.unmuteMe();
                     break;
                  case "mvna":
                     if(world.uoTree[sfc.myUserName].freeze == null || !world.uoTree[sfc.myUserName].freeze)
                     {
                        world.uoTree[sfc.myUserName].freeze = true;
                     }
                     break;
                  case "mvnb":
                     if(world.uoTree[sfc.myUserName].freeze != null)
                     {
                        delete world.uoTree[sfc.myUserName].freeze;
                     }
                     break;
                  case "gtc":
                     if(String(resObj[2]) != null && String(resObj[3]) != null)
                     {
                        world.moveToCell(String(resObj[2]),String(resObj[3]));
                     }
                     break;
                  case "mtcid":
                     if(resObj.length > 2)
                     {
                        world.moveToCellByIDb(Number(resObj[2]));
                     }
                     if(resObj[3] != null)
                     {
                        mtcidNow = Number(resObj[3]);
                        trace("[Resp] mtcid: " + mtcidNow);
                     }
                     break;
                  case "hi":
                     trace("[Resp] ping response: unlocking actions, canceling logout timer");
                     world.connMsgOut = false;
                     world.connTestTimer.reset();
                     world.unlockActions();
                     break;
                  case "Dragon Buff":
                     world.map.doDragonBuff();
                     break;
                  case "trap door":
                     world.map.doTrapDoor(resObj[2]);
                     break;
                  case "gMOTD":
                     world.myAvatar.objData.guild.MOTD = resObj[2];
                     break;
                  case "buyGSlots":
                     slots = int(resObj[2]);
                     if(!isNaN(slots))
                     {
                        world.myAvatar.objData.intCoins -= slots * 200;
                     }
                     if(world.myAvatar.objData != null)
                     {
                        world.myAvatar.updateGuildInfo();
                     }
                     break;
                  case "gRename":
                     world.myAvatar.objData.intCoins -= 1000;
                     break;
                  case "fbRes":
                     if(resObj[4] != null)
                     {
                        typ = "warning";
                        msg = resObj[4];
                        msg = chatF.cleanChars(msg);
                        msg = chatF.cleanStr(msg);
                        chatF.pushMsg(typ,msg,"SERVER","",0);
                     }
                     break;
                  case "elmSwitch":
                     try
                     {
                        world.map.setupElement(String(resObj[2]));
                     }
                     catch(e:*)
                     {
                        trace("[Resp] ERR elmSwitch: " + e);
                     }
               }
            }
            if(protocol == "json")
            {
               cmd = resObj.cmd;
               if(resObj.procs != null)
               {
                  mergeProcs(resObj.procs);
               }
               if(sfc.debug)
               {
                  trace("[Resp] json: " + cmd);
               }
               strF = "";
               switch(cmd)
               {
                  default:
                     trace("[Resp] ERR unhandled json cmd: " + cmd);
                     break;
                  case "friendshipStats":
                     intf = getInterface("friendship_ui");
                     if(intf != null)
                     {
                        intf = intf.getChildAt(0);
                        intf.InitInterface(resObj);
                     }
                     break;
                  case "friendshipInfo":
                     intf = getInterface("friendship_engine");
                     if(intf != null)
                     {
                        intf = intf.getChildAt(0);
                        intf.FinalizeConvo(resObj);
                     }
                     break;
                  case "friendshipGift":
                     intf = getInterface("friendship_engine");
                     if(intf != null)
                     {
                        intf = intf.getChildAt(0);
                        intf.FinalizeGift(resObj);
                     }
                     break;
                  case "friendshipTalk":
                     intf = getInterface("friendship_engine");
                     if(intf != null)
                     {
                        intf = intf.getChildAt(0);
                        intf.FinalizeTalk(resObj);
                     }
                     break;
                  case "friendshipChoice":
                     intf = getInterface("friendship_engine");
                     if(intf != null)
                     {
                        intf = intf.getChildAt(0);
                        intf.FinalizeChoice(resObj);
                     }
                     break;
                  case "addLoadout":
                     if(!resObj.success)
                     {
                        MsgBox.notify(resObj.msg);
                     }
                     else
                     {
                        intf = getInterface("outfitSets");
                        if(intf != null)
                        {
                           intf = intf.getChildAt(0);
                           intf.onServerResponseUpdate();
                        }
                     }
                     break;
                  case "removeLoadout":
                     if(!resObj.success)
                     {
                        MsgBox.notify(resObj.msg);
                     }
                     else
                     {
                        intf = getInterface("outfitSets");
                        if(intf != null)
                        {
                           intf = intf.getChildAt(0);
                           intf.onServerResponseRemove(resObj.setName);
                        }
                     }
                     break;
                  case "wearItem":
                     avt = world.getAvatarByUserID(resObj.uid);
                     if(avt != null)
                     {
                        if(avt.pMC != null && avt.objData != null)
                        {
                           if(!avt.objData.eqp[resObj.sES])
                           {
                              avt.objData.eqp[resObj.sES] = {};
                           }
                           avt.objData.eqp[resObj.sES].sFile = resObj.sFile == "undefined" ? "" : resObj.sFile;
                           avt.objData.eqp[resObj.sES].sLink = resObj.sLink;
                           avt.objData.eqp[resObj.sES].sType = resObj.ItemID == 156 || resObj.ItemID == 12583 ? "Unarmed" : resObj.sType;
                           avt.loadMovieAtES(resObj.sES,avt.objData.eqp[resObj.sES].sFile,avt.objData.eqp[resObj.sES].sLink);
                        }
                        if(avt.isMyAvatar)
                        {
                           if(!resObj.success)
                           {
                              MsgBox.notify(resObj.msg);
                           }
                           avt.wearItem(resObj.ItemID);
                           if(MovieClip(ui.mcPopup.getChildByName("mcInventory")) != null)
                           {
                              MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshItems"});
                           }
                        }
                     }
                     break;
                  case "unwearItem":
                     avt = world.getAvatarByUserID(resObj.uid);
                     if(avt != null)
                     {
                        if(avt.pMC != null && avt.objData != null)
                        {
                           if(avt.isMyAvatar)
                           {
                              avt.unwearItem(resObj.ItemID);
                           }
                           if(resObj.hasOwnProperty("bRemove"))
                           {
                              delete avt.objData.eqp[resObj.sES];
                              avt.unloadMovieAtES(resObj.sES);
                           }
                           else
                           {
                              avt.objData.eqp[resObj.sES].sFile = resObj.sFile == "undefined" ? "" : resObj.sFile;
                              avt.objData.eqp[resObj.sES].sLink = resObj.sLink;
                              avt.objData.eqp[resObj.sES].sType = resObj.sType;
                              avt.loadMovieAtES(resObj.sES,avt.objData.eqp[resObj.sES].sFile,avt.objData.eqp[resObj.sES].sLink);
                           }
                        }
                        if(avt.isMyAvatar)
                        {
                           if(!resObj.success)
                           {
                              MsgBox.notify(resObj.msg);
                           }
                           if(MovieClip(ui.mcPopup.getChildByName("mcInventory")) != null)
                           {
                              MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshItems"});
                           }
                        }
                     }
                     break;
                  case "wearLoadout":
                     avt = world.getAvatarByUserID(resObj.uid);
                     if(avt != null)
                     {
                        if(avt.pMC != null && avt.objData != null)
                        {
                           arrWearableSpots = ["Weapon","he","ba","co"];
                           for each(spot in arrWearableSpots)
                           {
                              if(avt.isMyAvatar)
                              {
                                 avt.unwearItemAtES(spot);
                              }
                              costumeItem = resObj.costume[spot];
                              if(costumeItem)
                              {
                                 if(!avt.objData.eqp[spot])
                                 {
                                    avt.objData.eqp[spot] = {};
                                 }
                                 avt.objData.eqp[spot].sFile = costumeItem.sFile == "undefined" ? "" : costumeItem.sFile;
                                 avt.objData.eqp[spot].sLink = costumeItem.sLink;
                                 avt.objData.eqp[spot].sType = costumeItem.sType;
                                 avt.loadMovieAtES(spot,avt.objData.eqp[spot].sFile,avt.objData.eqp[spot].sLink);
                                 if(avt.isMyAvatar)
                                 {
                                    avt.wearItem(costumeItem.ItemID);
                                 }
                              }
                           }
                        }
                        if(avt.isMyAvatar)
                        {
                           if(!resObj.success)
                           {
                              MsgBox.notify(resObj.msg);
                           }
                        }
                     }
                     break;
                  case "savePrefs":
                     if(resObj.msg != "")
                     {
                        MsgBox.notify(resObj.msg);
                     }
                     switch(resObj.section)
                     {
                        case "boosts":
                        case "loadouts":
                        case "prefs":
                     }
                     break;
                  case "loadPrefs":
                     if(resObj.success)
                     {
                        world.objInfo["customs"] = resObj.result;
                     }
                     break;
                  case "acceptQuest":
                     mcQFrame = getInstanceFromModalStack("QFrameMC");
                     if(!resObj.bSuccess)
                     {
                        MsgBox.notify(resObj.msg);
                        world.abandonQuest(resObj.QuestID);
                        mcQFrame = getInstanceFromModalStack("QFrameMC");
                        if(mcQFrame)
                        {
                           mcQFrame.mc.cnt.gotoAndPlay("intro");
                        }
                     }
                     else if(mcQFrame)
                     {
                        mcQFrame.mc.cnt.gotoAndPlay("back");
                     }
                     break;
                  case "afkGameResponse":
                     world.objResponse["afkGameResponse"] = resObj;
                     world.dispatchEvent(new Event("afkGameResponse"));
                     break;
                  case "who":
                     ulo = {};
                     ulo.typ = "userListA";
                     ulo.ul = resObj.users;
                     ui.mcOFrame.fOpenWith(ulo);
                     break;
                  case "al":
                     areaListShow(resObj);
                     break;
                  case "getinfo":
                     for(prop in resObj)
                     {
                        if(prop != "cmd")
                        {
                           trace("[Resp] getinfo " + prop + ": " + resObj[prop]);
                        }
                     }
                     break;
                  case "reloadmap":
                     if(world.strMapName == resObj.sName)
                     {
                        world.setMapEvents(null);
                        world.strMapFileName = resObj.sFileName;
                        world.reloadCurrentMap();
                     }
                     break;
                  case "moveToArea":
                     if(world.ldr_House.hasEventListener(Event.COMPLETE))
                     {
                        world.ldr_House.close();
                        world.ldr_House.contentLoaderInfo.removeEventListener(Event.COMPLETE,world.onHouseItemComplete);
                        world.ldr_House.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,world.onHouseItemError);
                     }
                     if(resObj.areaName.toLowerCase().indexOf("battleodium") == 0 || resObj.areaName.toLowerCase().indexOf("greyguard") == 0)
                     {
                        if(getInterface("friendship_engine") == null)
                        {
                           trace("[Resp] loading friendship engine");
                           requestInterface("friendship/friendship_engine.swf","friendship_engine");
                        }
                     }
                     if(resObj.areaName.toLowerCase().indexOf("magicmeadow") == 0 || resObj.areaName.toLowerCase().indexOf("magicmeaderp") == 0)
                     {
                        if(getInterface("pony_engine") == null)
                        {
                           trace("[Resp] loading pony engine");
                           requestInterface("ponyvspony/pony_engine.swf","pony_engine");
                        }
                        else
                        {
                           world.myAvatar.swapMorphs(true);
                        }
                     }
                     else if(getInterface("pony_engine") != null)
                     {
                        world.myAvatar.swapMorphs(false);
                     }
                     if(resObj.areaName.indexOf("battleon") > -1 && resObj.areaName.indexOf("battleontown") < 0)
                     {
                        world.rootClass.openMenu();
                        world.rootClass.firstMenu = false;
                     }
                     else if(!world.rootClass.firstMenu)
                     {
                        world.rootClass.menuClose();
                     }
                     if(resObj.strMapName == "trickortreat")
                     {
                        world.TrickOrTreatMonsterDead = false;
                     }
                     else if(resObj.strMapName == "caroling")
                     {
                        world.CarolingMonsterKillCount = 0;
                     }
                     world.mapLoadInProgress = true;
                     world.strAreaName = resObj.areaName;
                     world.initObjExtra(resObj.sExtra);
                     world.areaUsers = new Vector.<String>();
                     myLeaf = null;
                     world.modID = -1;
                     if(world.uoTreeLeaf(sfc.myUserName) != null)
                     {
                        myLeaf = copyObj(world.uoTreeLeaf(sfc.myUserName));
                     }
                     world.uoTree = new Dictionary(true);
                     if(myLeaf != null)
                     {
                        world.uoTree[sfc.myUserName] = myLeaf;
                     }
                     if(resObj.monName != null)
                     {
                        world.chaosNames = resObj.monName.split(",");
                     }
                     if(resObj.pvpTeam != null)
                     {
                        if(myLeaf != null)
                        {
                           myLeaf.pvpTeam = resObj.pvpTeam;
                        }
                        world.bPvP = true;
                        ui.mcPortrait.pvpIcon.visible = true;
                        ui.mcPortrait.partyLead.y = 18;
                        world.setPVPFactionData(resObj.PVPFactions);
                        if(world.objExtra["bChaos"] == null)
                        {
                           updatePVPScore(resObj.pvpScore);
                           showPVPScore();
                        }
                     }
                     else
                     {
                        ui.mcPortrait.pvpIcon.visible = false;
                        ui.mcPortrait.partyLead.y = 0;
                        if(myLeaf != null)
                        {
                           delete myLeaf.pvpTeam;
                        }
                        world.bPvP = false;
                        hidePVPScore();
                        world.setPVPFactionData(null);
                     }
                     if(resObj.pvpScore != null)
                     {
                        updatePVPScore(resObj.pvpScore);
                     }
                     if(resObj.auDesc != null)
                     {
                        for(auD in resObj.auDesc)
                        {
                           world.auraDescs[auD] = resObj.auDesc[auD];
                        }
                     }
                     bi = 0;
                     while(bi < resObj.uoBranch.length)
                     {
                        branchA = resObj.uoBranch[bi];
                        unm = branchA.uoName;
                        uoLeaf = {};
                        for(s in branchA)
                        {
                           nam = s;
                           val = branchA[s];
                           if(nam.toLowerCase().indexOf("int") > -1 || nam.toLowerCase() == "tx" || nam.toLowerCase() == "ty" || nam.toLowerCase() == "sp" || nam.toLowerCase() == "pvpTeam")
                           {
                              val = int(val);
                           }
                           uoLeaf[nam] = val;
                        }
                        if(unm != sfc.myUserName)
                        {
                           for each(uAura in uoLeaf.auras)
                           {
                              uAura.casterType = null;
                              uAura.casterId = null;
                           }
                           uoLeaf.auras = [];
                        }
                        uoLeaf.targets = {};
                        seedAu = uoLeaf.au as Array;
                        delete uoLeaf.au;
                        world.uoTreeLeafSet(unm,uoLeaf);
                        world.hudAuraSeed(world.uoTree[String(unm).toLowerCase()],seedAu);
                        world.manageAreaUser(unm,"+");
                        bi++;
                     }
                     world.monTree = {};
                     world.monsters = new Vector.<Avatar>();
                     bi = 0;
                     while(bi < resObj.monBranch.length)
                     {
                        branchA = resObj.monBranch[bi];
                        monLeaf = {};
                        mID = "1";
                        for(s in branchA)
                        {
                           nam = s;
                           val = branchA[s];
                           if(nam.toLowerCase().indexOf("monmapid") > -1)
                           {
                              mID = val;
                           }
                           if(nam.toLowerCase().indexOf("int") > -1 || nam.toLowerCase().indexOf("monid") > -1 || nam.toLowerCase().indexOf("monmapid") > -1)
                           {
                              val = Number(val);
                           }
                           monLeaf[nam] = val;
                        }
                        monLeaf.auras = [];
                        monLeaf.targets = {};
                        monLeaf.strBehave = "walk";
                        if(monLeaf.au != null)
                        {
                           world.hudAuraSeed(monLeaf,monLeaf.au as Array);
                           delete monLeaf.au;
                        }
                        world.monTree[mID] = monLeaf;
                        bi++;
                     }
                     if("event" in resObj)
                     {
                        world.setMapEvents(resObj.event);
                     }
                     else
                     {
                        world.setMapEvents(null);
                     }
                     if("cellMap" in resObj)
                     {
                        world.setCellMap(resObj.cellMap);
                     }
                     else
                     {
                        world.setCellMap(null);
                     }
                     try
                     {
                        if(world.strFrame != "")
                        {
                           world.exitCell();
                        }
                     }
                     catch(e:Error)
                     {
                        trace("[Resp] ERR moveToArea exitCell: " + e.message);
                     }
                     try
                     {
                        world.cleanupMap();
                     }
                     catch(e:Error)
                     {
                        trace("[Resp] ERR moveToArea cleanupMap: " + e.message);
                     }
                     try
                     {
                        world.killLoaders();
                     }
                     catch(e:Error)
                     {
                        trace("[Resp] ERR moveToArea killLoaders: " + e.message);
                     }
                     try
                     {
                        world.clearMonstersAndProps();
                     }
                     catch(e:Error)
                     {
                        trace("[Resp] ERR moveToArea clearMonstersAndProps: " + e.message);
                     }
                     try
                     {
                        world.clearAllAvatars();
                     }
                     catch(e:Error)
                     {
                        trace("[Resp] ERR moveToArea clearAllAvatars: " + e.message);
                     }
                     try
                     {
                        ldrMC.closeHistory();
                     }
                     catch(e:Error)
                     {
                        trace("[Resp] ERR moveToArea closeHistory: " + e.message);
                     }
                     try
                     {
                        if(mcExtSWF != null && mcExtSWF.numChildren > 0)
                        {
                           clearExternamSWF();
                        }
                     }
                     catch(e:Error)
                     {
                        trace("[Resp] ERR moveToArea clearExternamSWF: " + e.message);
                     }
                     pendingSelfInitData = null;
                     world.avatars[sfc.myUserId] = world.myAvatar;
                     world.strMapName = resObj.strMapName;
                     world.strMapFileName = resObj.strMapFileName;
                     world.intType = resObj.intType;
                     world.intKillCount = resObj.intKillCount;
                     world.objLock = resObj.objLock != null ? resObj.objLock : null;
                     world.mondef = resObj.mondef;
                     world.mondefMap = {};
                     if(resObj.mondef != null)
                     {
                        mi = 0;
                        while(mi < resObj.mondef.length)
                        {
                           world.mondefMap[resObj.mondef[mi].MonID] = resObj.mondef[mi];
                           mi++;
                        }
                     }
                     world.monmap = resObj.monmap;
                     world.curRoom = Number(resObj.areaId);
                     world.actionResultsMon = new Vector.<Object>();
                     world.actionResults = new Vector.<Object>();
                     world.actionResultsAura = new Vector.<Object>();
                     world.mapBoundsMC = null;
                     chatF.chn.zone.rid = world.curRoom;
                     try
                     {
                        if("houseData" in resObj)
                        {
                           world.initHouseData(resObj.houseData);
                        }
                        else
                        {
                           world.initHouseData(null);
                        }
                     }
                     catch(e:Error)
                     {
                        trace("[Resp] ERR moveToArea initHouseData: " + e.message);
                     }
                     try
                     {
                        world.updatePartyFrame();
                     }
                     catch(e:Error)
                     {
                        trace("[Resp] ERR moveToArea updatePartyFrame: " + e.message);
                     }
                     try
                     {
                        world.clearLoaders();
                     }
                     catch(e:Error)
                     {
                        trace("[Resp] ERR moveToArea clearLoaders: " + e.message);
                     }
                     s = String(resObj.strMapFileName).toLowerCase();
                     world.loadMap(s);
                     elmType = resObj.elmType;
                     if(world.rootClass.hasPreviewed)
                     {
                        for(psES in world.myAvatar.objData.eqp)
                        {
                           if(world.myAvatar.objData.eqp[psES].wasCreated)
                           {
                              delete world.myAvatar.objData.eqp[psES];
                              world.myAvatar.unloadMovieAtES(psES);
                           }
                           else if(world.myAvatar.objData.eqp[psES].isPreview)
                           {
                              if(psES == "pe")
                              {
                                 if(world.myAvatar.objData.eqp["pe"])
                                 {
                                    world.myAvatar.unloadPet();
                                 }
                              }
                              world.myAvatar.objData.eqp[psES].sType = world.myAvatar.objData.eqp[psES].oldType;
                              world.myAvatar.objData.eqp[psES].sFile = world.myAvatar.objData.eqp[psES].oldFile;
                              world.myAvatar.objData.eqp[psES].sLink = world.myAvatar.objData.eqp[psES].oldLink;
                              world.myAvatar.loadMovieAtES(psES,world.myAvatar.objData.eqp[psES].oldFile,world.myAvatar.objData.eqp[psES].oldLink);
                              world.myAvatar.objData.eqp[psES].isPreview = null;
                           }
                        }
                        world.rootClass.hasPreviewed = false;
                     }
                     if(Boolean(world.myAvatar && world.myAvatar.items) && Boolean(world.myAvatar.items.length > 0) && Boolean(litePreference.data.bCharSelect))
                     {
                        saveChar();
                     }
                     break;
                  case "initUserData":
                     applyInitUserData(resObj);
                     break;
                  case "initUserDatas":
                     a = resObj.a;
                     i = 0;
                     while(i < a.length)
                     {
                        o = a[i];
                        try
                        {
                           avt = world.getAvatarByUserID(o.uid);
                           uoLeaf = avt != null ? avt.dataLeaf : null;
                           if(avt != null && uoLeaf != null)
                           {
                              avt.initAvatar({"data":o.data});
                              if(avt.isMyAvatar && (avt.items == null || avt.items.length < 1))
                              {
                                 avt.objData.strHomeTown = avt.objData.strMapName;
                                 world.getInventory(o.uid);
                                 try
                                 {
                                    world.initAchievements();
                                    readIA1Preferences();
                                    loadGameMenu();
                                    if(avt.objData.guild != null)
                                    {
                                       chatF.chn.guild.act = 1;
                                       if(String(avt.objData.guild.MOTD) != "undefined")
                                       {
                                          chatF.pushMsg("guild","Message of the day: " + String(avt.objData.guild.MOTD),"SERVER","",0);
                                       }
                                    }
                                    if(Game.serverFilePath.indexOf("content.aq.com") == -1)
                                    {
                                       world.rootClass.extCall.showIt("login");
                                    }
                                    if(avt.objData.iUpg > 0)
                                    {
                                       if(avt.objData.iUpgDays < 0)
                                       {
                                          chatF.pushMsg("moderator","Your membership has expired. Please visit our website to renew your membership.","SERVER","",0);
                                       }
                                       else if(avt.objData.iUpgDays < 7)
                                       {
                                          chatF.pushMsg("moderator","Your membership will expire in " + (Number(avt.objData.iUpgDays) + 1) + " days. Please visit our website to renew your membership.","SERVER","",0);
                                       }
                                    }
                                    if(avt.objData.dRefReset != null && (avt.objData.iRefGold > 0 || avt.objData.iRefExp > 0))
                                    {
                                       modalRR = new ModalMC();
                                       modalORR = {};
                                       modalORR.strBody = "You earned <font color=\'#FFCC00\'><b>" + Math.ceil(avt.objData.iRefGold) + " Gold</b></font> and <font color=\'#990099\'><b>" + Math.ceil(avt.objData.iRefExp) + " XP</b></font><br/> from Referred Friends.";
                                       modalORR.callback = world.sendRewardReferralRequest;
                                       modalORR.btns = "mono";
                                       ui.ModalStack.addChild(modalRR);
                                       modalRR.init(modalORR);
                                    }
                                    updateXPBar();
                                    setGoldDisplay(avt.objData.intGold);
                                    if(ui.mcPopup.currentLabel == "Inventory" || ui.mcPopup.currentLabel == "HouseInventory")
                                    {
                                       MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshCoins"});
                                    }
                                 }
                                 catch(eUI2:Error)
                                 {
                                    debugMessage("initUserDatas ui: " + eUI2.message);
                                 }
                              }
                           }
                        }
                        catch(e:Error)
                        {
                           trace("[Resp] ERR initUserDatas: " + e.message);
                        }
                        i++;
                     }
                     break;
                  case "changeColor":
                     avt = world.getAvatarByUserID(resObj.uid);
                     if(avt != null && avt.bitData)
                     {
                        if(avt.isMyAvatar)
                        {
                           showPortrait(avt);
                        }
                        if(resObj.HairID != null)
                        {
                           avt.objData.HairID = resObj.HairID;
                           avt.objData.strHairName = resObj.strHairName;
                           avt.objData.strHairFilename = resObj.strHairFilename;
                           if(avt.pMC != null && avt.pMC.stage != null)
                           {
                              avt.pMC.loadHair();
                           }
                        }
                        avt.objData.intColorSkin = resObj.intColorSkin;
                        avt.objData.intColorHair = resObj.intColorHair;
                        avt.objData.intColorEye = resObj.intColorEye;
                        if(avt.pMC != null && avt.pMC.stage != null)
                        {
                           avt.pMC.updateColor();
                        }
                     }
                     else
                     {
                        trace("[Resp] ERR changeColor: avatar not ready, uid " + resObj.uid);
                     }
                     break;
                  case "changeArmorColor":
                     avt = world.getAvatarByUserID(resObj.uid);
                     if(avt != null && avt.bitData)
                     {
                        avt.objData.intColorBase = resObj.intColorBase;
                        avt.objData.intColorTrim = resObj.intColorTrim;
                        avt.objData.intColorAccessory = resObj.intColorAccessory;
                        if(avt.pMC != null && avt.pMC.stage != null)
                        {
                           avt.pMC.updateColor();
                        }
                     }
                     else
                     {
                        trace("[Resp] ERR changeArmorColor: avatar not ready, uid " + resObj.uid);
                     }
                     break;
                  case "balance":
                     if(resObj.intExp != null)
                     {
                        world.myAvatar.objData.intExp = resObj.intExp;
                        updateXPBar();
                     }
                     if(resObj.intGold != null)
                     {
                        world.myAvatar.objData.intGold = resObj.intGold;
                        setGoldDisplay(world.myAvatar.objData.intGold);
                        if(ui.mcPopup.currentLabel == "Inventory" || ui.mcPopup.currentLabel == "HouseInventory")
                        {
                           MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshCoins"});
                        }
                     }
                     if(resObj.intCoins != null)
                     {
                        world.myAvatar.objData.intCoins = resObj.intCoins;
                        if(ui.mcPopup.currentLabel == "Inventory" || ui.mcPopup.currentLabel == "HouseInventory")
                        {
                           MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshCoins"});
                        }
                     }
                     break;
                  case "addGoldExp":
                     if(resObj.intExp != null && resObj.intExp > 0)
                     {
                        if(bAnalyzer)
                        {
                           if(bAnalyzer.isRunning())
                           {
                              bAnalyzer.addExp(resObj.intExp);
                           }
                        }
                        deltaXP = int(resObj.intExp);
                        world.myAvatar.objData.intExp += deltaXP;
                        updateXPBar();
                        xp = new xpDisplay();
                        xp.t.ti.text = deltaXP + " xp";
                        xpB = null;
                        if("bonusExp" in resObj)
                        {
                           xpB = new xpDisplayBonus();
                           xpB.t.ti.text = String("+ " + resObj.bonusExp + " xp!");
                           xp.t.ti.text = deltaXP - resObj.bonusExp + " xp";
                        }
                        if(resObj.typ != null && resObj.typ == "m")
                        {
                           Mon = world.getMonster(resObj.id);
                           xp.x = Mon.pMC.mcChar.x;
                           xp.y = Mon.pMC.mcChar.y - 40;
                           Mon.pMC.addChild(xp);
                           if(xpB != null)
                           {
                              xpB.x = xp.x;
                              xpB.y = xp.y;
                              Mon.pMC.addChild(xpB);
                           }
                        }
                        else
                        {
                           xp.x = world.myAvatar.pMC.mcChar.x;
                           xp.y = world.myAvatar.pMC.pname.y + 10;
                           world.myAvatar.pMC.addChild(xp);
                           if(xpB != null)
                           {
                              xpB.x = xp.x;
                              xpB.y = xp.y;
                              world.myAvatar.pMC.addChild(xpB);
                           }
                        }
                     }
                     if(resObj.intGold != null && resObj.intGold > 0)
                     {
                        if(bAnalyzer)
                        {
                           if(bAnalyzer.isRunning())
                           {
                              bAnalyzer.addGold(resObj.intGold);
                           }
                        }
                        mixer.playSound("Coins");
                        deltaGold = int(resObj.intGold);
                        world.myAvatar.objData.intGold += resObj.intGold;
                        setGoldDisplay(world.myAvatar.objData.intGold);
                        if(ui.mcPopup.currentLabel == "Inventory" || ui.mcPopup.currentLabel == "HouseInventory")
                        {
                           MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshCoins"});
                        }
                        gold = new goldDisplay();
                        gold.t.ti.text = deltaGold + " g";
                        gold.tMask.ti.text = deltaGold + " g";
                        if(resObj.typ != null && resObj.typ == "m")
                        {
                           Mon = world.getMonster(resObj.id);
                           gold.x = Mon.pMC.mcChar.x;
                           gold.y = Mon.pMC.mcChar.y - 20;
                           Mon.pMC.addChild(gold);
                        }
                        else
                        {
                           gold.x = world.myAvatar.pMC.mcChar.x;
                           gold.y = world.myAvatar.pMC.pname.y - 30;
                           world.myAvatar.pMC.addChild(gold);
                        }
                     }
                     if(resObj.iCP != null)
                     {
                        deltaCP = int(resObj.iCP);
                        world.myAvatar.objData.iCP += deltaCP;
                        world.myAvatar.updateArmorRep();
                        iRank = world.myAvatar.objData.iRank;
                        world.myAvatar.updateRep();
                        if(iRank != world.myAvatar.objData.iRank)
                        {
                           world.myAvatar.rankUp(world.myAvatar.objData.strClassName,world.myAvatar.objData.iRank);
                           FB_showFeedDialog("Rank Up!","reached Rank " + world.myAvatar.objData.iRank + " " + world.myAvatar.objData.strClassName + " in AQWorlds!","aqw-rankup.jpg");
                        }
                        txtBonusCP = "";
                        if(resObj.bonusCP == null)
                        {
                           resObj.bonusCP = 0;
                        }
                        else
                        {
                           txtBonusCP = " + " + resObj.bonusCP + "(Bonus)";
                        }
                        chatF.pushMsg("server","Class Points for " + world.myAvatar.objData.strClassName + " increased by " + (deltaCP - resObj.bonusCP) + txtBonusCP + ".","SERVER","",0);
                     }
                     if(resObj.FactionID != null)
                     {
                        if(resObj.bonusRep == null)
                        {
                           resObj.bonusRep = 0;
                        }
                        world.myAvatar.addRep(resObj.FactionID,resObj.iRep,resObj.bonusRep);
                     }
                     break;
                  case "levelUp":
                     world.myAvatar.objData.intLevel = resObj.intLevel;
                     world.myAvatar.objData.intExpToLevel = resObj.intExpToLevel;
                     world.myAvatar.objData.intExp = resObj.xp;
                     updateXPBar();
                     showPortraitBox(world.myAvatar,ui.mcPortrait);
                     world.myAvatar.levelUp();
                     if(resObj.intLevel == 10)
                     {
                        world.rootClass.extCall.showIt("level10");
                     }
                     if("updatePStats" in world.map)
                     {
                        world.map.updatePStats();
                     }
                     break;
                  case "loadInventoryBig":
                     trace("[Resp] loadInventoryBig");
                     applyPendingSelfInitData();
                     if(world.myAvatar == null)
                     {
                        world.myAvatar = world.getAvatarByUserID(sfc.myUserId);
                     }
                     if(world.myAvatar == null)
                     {
                        break;
                     }
                     wasInvLoaded = world.myAvatar.invLoaded;
                     try
                     {
                        world.myAvatar.iBankCount = int(resObj.bankCount);
                     }
                     catch(e:Error)
                     {
                        debugMessage("loadInventoryBig bankCount: " + e.message);
                     }
                     try
                     {
                        world.myAvatar.initInventory(resObj.items);
                     }
                     catch(e:Error)
                     {
                        debugMessage("loadInventoryBig initInventory: " + e.message);
                     }
                     if(world.myAvatar.items == null)
                     {
                        world.myAvatar.items = [];
                     }
                     FavStore.load(gameSelf);
                     try
                     {
                        world.initHouseInventory({
                           "sHouseInfo":world.myAvatar.objData.sHouseInfo,
                           "items":resObj.hitems
                        });
                     }
                     catch(e:Error)
                     {
                        debugMessage("loadInventoryBig house: " + e.message);
                     }
                     try
                     {
                        world.myAvatar.initFactions(resObj.factions);
                     }
                     catch(e:Error)
                     {
                        debugMessage("loadInventoryBig factions: " + e.message);
                     }
                     try
                     {
                        world.myAvatar.initGuild(resObj.guild);
                     }
                     catch(e:Error)
                     {
                        debugMessage("loadInventoryBig guild: " + e.message);
                     }
                     world.uiLock = false;
                     world.myAvatar.invLoaded = true;
                     if(world.myAvatar.FirstLoad)
                     {
                        world.myAvatar.checkLoadComplete();
                     }
                     try
                     {
                        world.myAvatar.calculateIntoBoosts();
                     }
                     catch(e:Error)
                     {
                        trace("[Resp] ERR loadInventoryBig calculateIntoBoosts: " + e.message);
                     }
                     if(!wasInvLoaded)
                     {
                        world.mapEventTrigger({"cmd":"userLoaded"});
                     }
                     world.myAvatar.checkItemAnimation();
                     adShown = false;
                     testDate = new Date();
                     if(FacebookConnect.isLoggedIn)
                     {
                     }
                     if(world.myAvatar.objData.iUpg < 1 && world.map.noPopup != true)
                     {
                        testDate.setDate(testDate.getDate() - 3);
                        if(world.myAvatar.objData.dCreated > testDate && world.myAvatar.objData.intHits > 1 && Math.random() < 0.2)
                        {
                           adShown = true;
                           world.loadMovieFront("interface/DragonHeroOffer-28Feb13.swf","Inline Asset");
                        }
                     }
                     if(world.myAvatar.objData.intActivationFlag == 1 && world.myAvatar.objData.intHits < 16 && world.map.noPopup != true)
                     {
                        if(world.myAvatar.objData.intHits == 5 || world.myAvatar.objData.intHits == 15)
                        {
                           world.loadMovieFront("interface/ConfirmedEmailPopup.swf","Inline Asset");
                        }
                     }
                     break;
                  case "friends":
                     world.myAvatar.initFriendsList(resObj.friends);
                     if(resObj.showList)
                     {
                        flo = {};
                        flo.typ = "userListFriends";
                        for each(friend in world.myAvatar.friends)
                        {
                           friend.bOffline = friend.sServer == objServerInfo.sName ? 0 : (friend.sServer == "Offline" ? 2 : 1);
                        }
                        world.myAvatar.friends.sortOn("sName",Array.CASEINSENSITIVE);
                        world.myAvatar.friends.sortOn(["bOffline","sServer","sName"],[Array.NUMERIC,Array.CASEINSENSITIVE,Array.CASEINSENSITIVE]);
                        flo.ul = world.myAvatar.friends;
                        ui.mcOFrame.fOpenWith(flo);
                        mcO.fClose();
                     }
                     break;
                  case "initInventory":
                     world.myAvatar.initInventory(resObj.items);
                     world.mapEventTrigger({"cmd":"userLoaded"});
                     break;
                  case "loadHouseInventory":
                     world.initHouseInventory(resObj);
                     break;
                  case "house":
                     MsgBox.notify(resObj.msg);
                     break;
                  case "buyBagSlots":
                     world.dispatchEvent(new Event("buyBagSlots"));
                     if(resObj.bitSuccess == 1)
                     {
                        mixer.playSound("Heal");
                        world.myAvatar.objData.iBagSlots += Number(resObj.iSlots);
                        world.myAvatar.objData.intCoins -= Number(resObj.iSlots) * 200;
                        MsgBox.notify("You now have " + world.myAvatar.objData.iBagSlots + " inventory spaces!");
                        if(ui.mcPopup.currentLabel == "Inventory" || ui.mcPopup.currentLabel == "HouseInventory")
                        {
                           MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshSlots"});
                        }
                        if(ui != null && ui.mcPopup != null)
                        {
                           if(ui.mcPopup.currentLabel == "Shop")
                           {
                              MovieClip(ui.mcPopup.getChildByName("mcShop")).update({"eventType":"refreshItems"});
                           }
                           else if((bagBuyLabel == "Shop" || bagBuyLabel == "Bank" || bagBuyLabel == "HouseBank" || bagBuyLabel == "Inventory" || bagBuyLabel == "HouseInventory") && ui.mcPopup.currentLabel != bagBuyLabel)
                           {
                              ui.mcPopup.fOpen(bagBuyLabel);
                           }
                        }
                        bagBuyLabel = null;
                     }
                     break;
                  case "buyBankSlots":
                     world.dispatchEvent(new Event("buyBankSlots"));
                     if(resObj.bitSuccess == 1)
                     {
                        mixer.playSound("Heal");
                        world.myAvatar.objData.iBankSlots += Number(resObj.iSlots);
                        world.myAvatar.objData.intCoins -= Number(resObj.iSlots) * 200;
                        MsgBox.notify("You now have " + world.myAvatar.objData.iBankSlots + " bank spaces!");
                        if(ui.mcPopup.currentLabel == "Inventory" || ui.mcPopup.currentLabel == "HouseInventory")
                        {
                           MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshSlots"});
                        }
                        if(ui.mcPopup.currentLabel == "Shop")
                        {
                           MovieClip(ui.mcPopup.getChildByName("mcShop")).update({"eventType":"refreshSlots"});
                        }
                     }
                     break;
                  case "buyHouseSlots":
                     world.dispatchEvent(new Event("buyHouseSlots"));
                     if(resObj.bitSuccess == 1)
                     {
                        mixer.playSound("Heal");
                        world.myAvatar.objData.iHouseSlots += Number(resObj.iSlots);
                        world.myAvatar.objData.intCoins -= Number(resObj.iSlots) * 200;
                        MsgBox.notify("You now have " + world.myAvatar.objData.iHouseSlots + " house inventory spaces!");
                        if(ui.mcPopup.currentLabel == "Inventory" || ui.mcPopup.currentLabel == "HouseInventory")
                        {
                           MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshSlots"});
                        }
                        if(ui.mcPopup.currentLabel == "Shop")
                        {
                           MovieClip(ui.mcPopup.getChildByName("mcShop")).update({"eventType":"refreshSlots"});
                        }
                     }
                     break;
                  case "buyLoadoutSlots":
                     if(resObj.bitSuccess == 1)
                     {
                        mixer.playSound("Heal");
                        world.myAvatar.objData.iLoadoutSlots += Number(resObj.iSlots);
                        world.myAvatar.objData.intCoins -= Number(resObj.iSlots) * 200;
                        world.dispatchEvent(new Event("buyLoadoutSlots"));
                     }
                     break;
                  case "callfct":
                     try
                     {
                        fct = world.map[resObj.fctNam];
                        fct(resObj.fctParams);
                     }
                     catch(e:*)
                     {
                        trace("[Resp] ERR callfct " + resObj.fctNam + ": " + e);
                     }
                     break;
                  case "genderSwap":
                     avt = world.getAvatarByUserID(resObj.uid);
                     if(avt != null && avt.bitData)
                     {
                        if(resObj.bitSuccess == 1)
                        {
                           if(avt.isMyAvatar)
                           {
                              MsgBox.notify("Your gender has been successfully changed.");
                              avt.objData.intCoins -= resObj.intCoins;
                           }
                           avt.objData.strGender = resObj.gender;
                           avt.objData.HairID = resObj.HairID;
                           avt.objData.strHairName = resObj.strHairName;
                           avt.objData.strHairFilename = resObj.strHairFilename;
                           avt.initAvatar({"data":avt.objData});
                           if(avt.objData.eqp != null)
                           {
                              if(avt.objData.eqp.co != null)
                              {
                                 avt.loadMovieAtES("co",avt.objData.eqp.co.sFile,avt.objData.eqp.co.sLink);
                              }
                              else if(avt.objData.eqp.ar != null)
                              {
                                 avt.loadMovieAtES("ar",avt.objData.eqp.ar.sFile,avt.objData.eqp.ar.sLink);
                              }
                           }
                           avt.pMC.loadHair();
                        }
                     }
                     break;
                  case "loadBank":
                     if(resObj.bitSuccess)
                     {
                        if(resObj.items != null && resObj.items != "undefined")
                        {
                           world.addItemsToBank(resObj.items);
                        }
                        if(ui != null && ui.mcPopup != null)
                        {
                           if(ui.mcPopup.currentLabel == "Bank")
                           {
                              MovieClip(ui.mcPopup.getChildByName("mcBank")).update({"eventType":"refreshBank"});
                           }
                           else
                           {
                              ui.mcPopup.fOpen("Bank");
                           }
                        }
                     }
                     else
                     {
                        modal = new ModalMC();
                        modalO = {};
                        modalO.strBody = "Error loading bank items!  Try logging out and back in to fix this problem.";
                        modalO.params = {};
                        modalO.glow = "red,medium";
                        modalO.btns = "mono";
                        ui.ModalStack.addChild(modal);
                        modal.init(modalO);
                     }
                     break;
                  case "bankFromInv":
                     if("bSuccess" in resObj && resObj.bSuccess == 1)
                     {
                        world.myAvatar.bankFromInv(resObj.ItemID);
                        world.checkAllQuestStatus();
                        if(ui.mcPopup.currentLabel == "Bank" || ui.mcPopup.currentLabel == "HouseBank")
                        {
                           MovieClip(ui.mcPopup.getChildByName("mcBank")).update({"eventType":"refreshItems"});
                        }
                        if(ui.mcPopup.currentLabel == "Inventory" || ui.mcPopup.currentLabel == "HouseInventory")
                        {
                           MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshItems"});
                        }
                     }
                     else if(LPFFrameBankAQ.active == null || !LPFFrameBankAQ.active.serverFailed(resObj.msg,int(resObj.ItemID)))
                     {
                        modal = new ModalMC();
                        modalO = {};
                        modalO.strBody = resObj.msg;
                        modalO.params = {};
                        modalO.glow = "red,medium";
                        modalO.btns = "mono";
                        ui.ModalStack.addChild(modal);
                        modal.init(modalO);
                     }
                     break;
                  case "bankToInv":
                     world.myAvatar.bankToInv(resObj.ItemID);
                     world.checkAllQuestStatus();
                     if(ui.mcPopup.currentLabel == "Bank" || ui.mcPopup.currentLabel == "HouseBank")
                     {
                        MovieClip(ui.mcPopup.getChildByName("mcBank")).update({"eventType":"refreshItems"});
                     }
                     if(ui.mcPopup.currentLabel == "Inventory" || ui.mcPopup.currentLabel == "HouseInventory")
                     {
                        MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshItems"});
                     }
                     break;
                  case "bankSwapInv":
                     world.myAvatar.bankSwapInv(resObj.invItemID,resObj.bankItemID);
                     world.checkAllQuestStatus();
                     if(ui.mcPopup.currentLabel == "Bank" || ui.mcPopup.currentLabel == "HouseBank")
                     {
                        MovieClip(ui.mcPopup.getChildByName("mcBank")).update({"eventType":"refreshItems"});
                     }
                     if(ui.mcPopup.currentLabel == "Inventory" || ui.mcPopup.currentLabel == "HouseInventory")
                     {
                        MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshItems"});
                     }
                     break;
                  case "loadShop":
                     if(world.shopinfo != null && "ShopID" in world.shopinfo && world.shopinfo.ShopID == resObj.shopinfo.ShopID && "bLimited" in world.shopinfo && Boolean(world.shopinfo.bLimited))
                     {
                        trace("[Resp] loadShop reload: ShopID " + resObj.shopinfo.ShopID);
                        i = 0;
                        while(i < resObj.shopinfo.items.length)
                        {
                           world.shopinfo.items.push(resObj.shopinfo.items[i]);
                           world.shopinfo.items.shift();
                           i++;
                        }
                        if(ui != null && ui.mcPopup != null)
                        {
                           if(ui.mcPopup.currentLabel == "Shop")
                           {
                              MovieClip(ui.mcPopup.getChildByName("mcShop")).update({"eventType":"refreshItems"});
                           }
                           else
                           {
                              ui.mcPopup.fOpen("Shop");
                           }
                        }
                     }
                     else
                     {
                        world.shopinfo = resObj.shopinfo;
                        if(ui != null && ui.mcPopup != null)
                        {
                           if(resObj.shopinfo.bHouse == 1)
                           {
                              ui.mcPopup.fOpen("Shop");
                           }
                           else if(isMergeShop(resObj.shopinfo))
                           {
                              ui.mcPopup.fOpen("MergeShop");
                           }
                           else
                           {
                              ui.mcPopup.fOpen("Shop");
                           }
                        }
                     }
                     break;
                  case "loadEnhShop":
                     world.enhShopID = resObj.shopinfo.ShopID;
                     world.enhShopItems = resObj.shopinfo.items;
                     if(ui != null && ui.mcPopup != null)
                     {
                        ui.mcPopup.fOpen("EnhShop");
                     }
                     break;
                  case "enhanceItemShop":
                     if(resObj.iCost != null)
                     {
                        world.myAvatar.objData.intGold -= Number(resObj.iCost);
                        setGoldDisplay(world.myAvatar.objData.intGold);
                        if(ui.mcPopup.currentLabel == "Inventory")
                        {
                           MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshCoins"});
                        }
                        if(ui.mcPopup.currentLabel == "Shop")
                        {
                           MovieClip(ui.mcPopup.getChildByName("mcShop")).update({"eventType":"refreshCoins"});
                        }
                     }
                     for each(o in world.myAvatar.items)
                     {
                        if(resObj.ItemIDs.indexOf(Number(o.ItemID)) != -1)
                        {
                           o.iEnh = resObj.EnhID;
                           o.EnhID = resObj.EnhID;
                           o.EnhPatternID = resObj.EnhPID;
                           o.EnhLvl = resObj.EnhLvl;
                           o.EnhDPS = resObj.EnhDPS;
                           o.EnhRng = resObj.EnhRng;
                           o.EnhRty = resObj.EnhRty;
                           o.ProcID = resObj.ProcID;
                        }
                     }
                     mixer.playSound("Good");
                     if(ui.mcPopup.currentLabel == "Inventory")
                     {
                        MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({
                           "eventType":"refreshItems",
                           "sInstruction":"previewEquipOnly"
                        });
                     }
                     if(ui.mcPopup.currentLabel == "Shop")
                     {
                        MovieClip(ui.mcPopup.getChildByName("mcShop")).update({
                           "eventType":"refreshItems",
                           "sInstruction":"closeWindows"
                        });
                     }
                     modal = new ModalMC();
                     modalO = {};
                     modalO.strBody = "You have upgraded your items with <b>" + resObj.EnhName + "</b>, level <b>" + resObj.EnhLvl + "</b>!";
                     modalO.params = {};
                     modalO.glow = "white,medium";
                     modalO.btns = "mono";
                     ui.ModalStack.addChild(modal);
                     modal.init(modalO);
                     break;
                  case "enhanceItemLocal":
                     iSel = null;
                     eSel = null;
                     for each(o in world.myAvatar.items)
                     {
                        if(o.ItemID == resObj.ItemID)
                        {
                           iSel = o;
                        }
                     }
                     iSel.iEnh = resObj.EnhID;
                     iSel.EnhID = resObj.EnhID;
                     iSel.EnhPatternID = resObj.EnhPID;
                     iSel.EnhLvl = resObj.EnhLvl;
                     iSel.EnhDPS = resObj.EnhDPS;
                     iSel.EnhRng = resObj.EnhRng;
                     iSel.EnhRty = resObj.EnhRty;
                     iSel.ProcID = resObj.ProcID;
                     mixer.playSound("Good");
                     if(ui.mcPopup.currentLabel == "Inventory")
                     {
                        MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({
                           "eventType":"refreshItems",
                           "sInstruction":"previewEquipOnly"
                        });
                     }
                     if(ui.mcPopup.currentLabel == "Shop")
                     {
                        MovieClip(ui.mcPopup.getChildByName("mcShop")).update({
                           "eventType":"refreshItems",
                           "sInstruction":"closeWindows"
                        });
                     }
                     modal = new ModalMC();
                     modalO = {};
                     modalO.strBody = "You have upgraded " + iSel.sName + " with " + resObj.EnhName + ", level " + resObj.EnhLvl + "!";
                     modalO.params = {};
                     modalO.glow = "white,medium";
                     modalO.btns = "mono";
                     ui.ModalStack.addChild(modal);
                     modal.init(modalO);
                     break;
                  case "loadHairShop":
                     world.hairshopinfo = resObj;
                     openCharacterCustomize();
                     break;
                  case "buyItem":
                     if(resObj.bitSuccess == 0)
                     {
                        if("bSoldOut" in resObj && Boolean(resObj.bSoldOut))
                        {
                           if(world.shopinfo.bLimited)
                           {
                              MovieClip(ui.mcPopup.getChildByName("mcShop")).update({
                                 "eventType":"refreshShop",
                                 "sInstruction":"closeWindows"
                              });
                           }
                           modal = new ModalMC();
                           modalO = {};
                           modalO.strBody = resObj.strMessage + " is no longer in stock.";
                           modalO.params = {};
                           modalO.glow = "red,medium";
                           modalO.btns = "mono";
                           ui.ModalStack.addChild(modal);
                           modal.init(modalO);
                        }
                        else if(resObj.strMessage != null)
                        {
                           MsgBox.notify(resObj.strMessage);
                        }
                     }
                     else
                     {
                        if(resObj.strMessage != null)
                        {
                           MsgBox.notify(resObj.strMessage);
                        }
                        item = copyObj(world.shopBuyItem);
                        item.iQty = resObj.iQty;
                        item.CharItemID = resObj.CharItemID;
                        item.bBank = resObj.bBank;
                        if(item.bCoins == 0)
                        {
                           world.myAvatar.objData.intGold -= Number(item.iCost * resObj.iQty);
                           setGoldDisplay(world.myAvatar.objData.intGold);
                           if(ui.mcPopup.currentLabel == "Inventory" || ui.mcPopup.currentLabel == "HouseInventory")
                           {
                              MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshCoins"});
                           }
                        }
                        else
                        {
                           item.iHrs = 0;
                           item.tPurchase = new Date().getTime();
                           world.myAvatar.objData.intCoins -= Number(item.iCost * resObj.iQty);
                        }
                        if(resObj.virtual)
                        {
                           item.virtual = resObj.virtual;
                        }
                        showItemDrop(item,false);
                        if(world.invTree[item.ItemID] == null)
                        {
                           world.invTree[item.ItemID] = copyObj(resObj);
                           world.invTree[item.ItemID].iQty = 0;
                        }
                        if(!resObj.virtual)
                        {
                           world.myAvatar.addItem(item);
                        }
                        if(item.bHouse == 1)
                        {
                           if(item.sType == "House" && !world.isHouseEquipped())
                           {
                              world.sendEquipItemRequest(item);
                              world.myAvatar.getItemByID(item.ItemID).bEquip = 1;
                           }
                           MovieClip(ui.mcPopup.getChildByName("mcShop")).update({"eventType":"refreshCoins"});
                           MovieClip(ui.mcPopup.getChildByName("mcShop")).update({
                              "eventType":"refreshItems",
                              "sInstruction":"closeWindows"
                           });
                           if(world.shopinfo.bLimited)
                           {
                              MovieClip(ui.mcPopup.getChildByName("mcShop")).update({"eventType":"refreshShop"});
                           }
                           if(ui.mcPopup.currentLabel == "HouseInventory")
                           {
                              MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshCoins"});
                              MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({
                                 "eventType":"refreshItems",
                                 "sInstruction":"closeWindows"
                              });
                           }
                        }
                        else if(ui.mcPopup.currentLabel == "Shop")
                        {
                           MovieClip(ui.mcPopup.getChildByName("mcShop")).update({"eventType":"refreshCoins"});
                           MovieClip(ui.mcPopup.getChildByName("mcShop")).update({
                              "eventType":"refreshItems",
                              "sInstruction":"closeWindows"
                           });
                           if(world.shopinfo.bLimited)
                           {
                              MovieClip(ui.mcPopup.getChildByName("mcShop")).update({"eventType":"refreshShop"});
                           }
                        }
                        else if(ui.mcPopup.currentLabel == "MergeShop")
                        {
                           MovieClip(ui.mcPopup.getChildByName("mcShop")).update({"eventType":"refreshCoins"});
                           MovieClip(ui.mcPopup.getChildByName("mcShop")).update({"eventType":"refreshItems"});
                        }
                        else if(ui.mcPopup.currentLabel == "Inventory")
                        {
                           MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshCoins"});
                           MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({
                              "eventType":"refreshItems",
                              "sInstruction":"closeWindows"
                           });
                        }
                        world.updateQuestProgress("item",item);
                        if(item.sType == "Item")
                        {
                           updateItemSkill();
                        }
                     }
                     break;
                  case "sellItem":
                     world.myAvatar.removeItem({
                        "CharItemID":resObj.CharItemID,
                        "iQty":resObj.iQty
                     });
                     if(resObj.bCoins == 1)
                     {
                        world.myAvatar.objData.intCoins += resObj.intAmount;
                     }
                     else if(world.myAvatar.objData.intGold < 100000000)
                     {
                        world.myAvatar.objData.intGold += resObj.intAmount;
                        setGoldDisplay(world.myAvatar.objData.intGold);
                     }
                     if(ui.mcPopup.currentLabel == "Shop")
                     {
                        MovieClip(ui.mcPopup.getChildByName("mcShop")).update({"eventType":"refreshCoins"});
                        MovieClip(ui.mcPopup.getChildByName("mcShop")).update({
                           "eventType":"refreshItems",
                           "sInstruction":"closeWindows"
                        });
                     }
                     else if(ui.mcPopup.currentLabel == "Inventory" || ui.mcPopup.currentLabel == "HouseInventory")
                     {
                        MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshCoins"});
                        MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({
                           "eventType":"refreshItems",
                           "sInstruction":"closeWindows"
                        });
                     }
                     world.checkAllQuestStatus();
                     break;
                  case "removeItem":
                     world.myAvatar.removeItem(resObj);
                     if(ui.mcPopup.currentLabel == "Inventory" || ui.mcPopup.currentLabel == "HouseInventory")
                     {
                        MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshItems"});
                     }
                     if(ui.mcPopup.currentLabel == "Bank" || ui.mcPopup.currentLabel == "HouseBank")
                     {
                        MovieClip(ui.mcPopup.getChildByName("mcBank")).update({"eventType":"refreshBank"});
                     }
                     world.checkAllQuestStatus();
                     break;
                  case "updateClass":
                     isNewClass = true;
                     statsNewClass = true;
                     avt = world.getAvatarByUserID(resObj.uid);
                     if(avt != null && avt.objData != null)
                     {
                        avt.objData.strClassName = resObj.sClassName;
                        avt.objData.iCP = resObj.iCP;
                        avt.objData.sClassCat = resObj.sClassCat;
                        avt.updateRep();
                        if(resObj.uid == sfc.myUserId)
                        {
                           if("sDesc" in resObj)
                           {
                              avt.objData.sClassDesc = resObj.sDesc;
                           }
                           if("sStats" in resObj)
                           {
                              avt.objData.sClassStats = resObj.sStats;
                           }
                           if("aMRM" in resObj)
                           {
                              avt.objData.aClassMRM = resObj.aMRM;
                           }
                        }
                     }
                     break;
                  case "equipItem":
                     avt = world.getAvatarByUserID(resObj.uid);
                     tLeaf = world.getUoLeafById(resObj.uid);
                     if(avt != null)
                     {
                        if(avt.isMyAvatar)
                        {
                           sMeta = world.myAvatar.getItemByEquipSlot(resObj.strES) ? world.myAvatar.getItemByEquipSlot(resObj.strES).sMeta : "";
                           if(Boolean(sMeta) && sMeta.length > 0)
                           {
                              if(world.myAvatar.invLoaded)
                              {
                                 avt.calculateIntoBoosts();
                              }
                           }
                        }
                        if(avt.pMC != null && avt.objData != null)
                        {
                           avt.objData.eqp[resObj.strES] = {};
                           avt.objData.eqp[resObj.strES].sFile = resObj.sFile == "undefined" ? "" : resObj.sFile;
                           avt.objData.eqp[resObj.strES].sLink = resObj.sLink;
                           if("sType" in resObj)
                           {
                              avt.objData.eqp[resObj.strES].sType = resObj.sType;
                           }
                           if("ItemID" in resObj)
                           {
                              avt.objData.eqp[resObj.strES].ItemID = resObj.ItemID;
                           }
                           if("sMeta" in resObj)
                           {
                              avt.objData.eqp[resObj.strES].sMeta = resObj.sMeta;
                           }
                           avt.loadMovieAtES(resObj.strES,resObj.sFile,resObj.sLink);
                        }
                        if(avt.isMyAvatar && avt.getItemByID(resObj.ItemID) != null)
                        {
                           avt.equipItem(resObj.ItemID);
                           if(MovieClip(ui.mcPopup.getChildByName("mcInventory")) != null)
                           {
                              MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshItems"});
                           }
                           if(ui.mcPopup.mcTempInventory != null)
                           {
                              ui.mcPopup.mcTempInventory.mcItemList.refreshList();
                              ui.mcPopup.mcTempInventory.refreshDetail();
                           }
                           if("sMeta" in resObj && String(resObj.sMeta).length > 0)
                           {
                              if(world.myAvatar.invLoaded)
                              {
                                 avt.calculateIntoBoosts();
                              }
                           }
                        }
                     }
                     break;
                  case "unequipItem":
                     avt = world.getAvatarByUserID(resObj.uid);
                     if(avt != null)
                     {
                        if(avt.pMC != null && avt.objData != null && Boolean(resObj.bUnload))
                        {
                           delete avt.objData.eqp[resObj.strES];
                           avt.unloadMovieAtES(resObj.strES);
                        }
                        if(avt.isMyAvatar)
                        {
                           avt.unequipItem(resObj.ItemID);
                           if(ui.mcPopup.currentLabel == "Inventory")
                           {
                              MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshItems"});
                           }
                           if(ui.mcPopup.mcTempInventory != null)
                           {
                              ui.mcPopup.mcTempInventory.mcItemList.refreshList();
                              ui.mcPopup.mcTempInventory.refreshDetail();
                           }
                           sMeta = world.myAvatar.getItemByID(resObj.ItemID) ? world.myAvatar.getItemByID(resObj.ItemID).sMeta : "";
                           if(Boolean(sMeta) && sMeta.length > 0)
                           {
                              if(world.myAvatar.invLoaded)
                              {
                                 avt.calculateIntoBoosts();
                              }
                           }
                        }
                     }
                     break;
                  case "dropItem":
                     for(dID in resObj.items)
                     {
                        dItem = null;
                        if(world.invTree[dID] == null)
                        {
                           world.invTree[dID] = copyObj(resObj.items[dID]);
                           world.invTree[dID].iQty = 0;
                           dItem = resObj.items[dID];
                        }
                        else
                        {
                           dItem = copyObj(world.invTree[dID]);
                           for(iData in resObj.items[dID])
                           {
                              if(resObj.items[dID][iData] != dItem[iData])
                              {
                                 dItem[iData] = resObj.items[dID][iData];
                                 if(iData != "iQty")
                                 {
                                    world.invTree[dID][iData] = resObj.items[dID][iData];
                                 }
                              }
                           }
                        }
                        if(resObj.Wheel != null)
                        {
                           try
                           {
                              world.map.doWheelDrop(dItem);
                           }
                           catch(e:Error)
                           {
                              trace("[Resp] ERR dropItem doWheelDrop: " + e.message);
                           }
                        }
                        else
                        {
                           dItem.dID = dID;
                           dItem.dQty = int(resObj.items[dID].iQty);
                           isOK = true;
                           if(litePreference.data.blackList)
                           {
                              for each(bItem in litePreference.data.blackList)
                              {
                                 if(isNaN(parseInt(bItem.value)))
                                 {
                                    litePreference.data.blackList.splice(litePreference.data.blackList.indexOf(bItem.value),1);
                                 }
                                 else if(dItem.ItemID == parseInt(bItem.value))
                                 {
                                    isOK = false;
                                 }
                              }
                              litePreference.flush();
                           }
                           if(isOK)
                           {
                              showItemDrop(dItem,true);
                           }
                        }
                     }
                     break;
                  case "monsterDrops":
                     for(mdID in resObj.items)
                     {
                        if(world.invTree[mdID] == null)
                        {
                           world.invTree[mdID] = copyObj(resObj.items[mdID]);
                           world.invTree[mdID].iQty = 0;
                        }
                     }
                     mDropsPanel = ui.getChildByName("monsterDropsPanel");
                     if(mDropsPanel != null)
                     {
                        mDropsPanel.populate(resObj);
                     }
                     break;
                  case "referralReward":
                     for(dID in resObj.items)
                     {
                        dItem = null;
                        if(world.invTree[dID] == null)
                        {
                           world.invTree[dID] = copyObj(resObj.items[dID]);
                           world.invTree[dID].iQty = 0;
                           dItem = resObj.items[dID];
                        }
                        else
                        {
                           dItem = copyObj(world.invTree[dID]);
                           dItem.iQty = int(resObj.items[dID].iQty);
                        }
                     }
                     dropItem = new DFrameMC(dItem);
                     ui.dropStack.addChild(dropItem);
                     dropItem.init();
                     dropItem.fY = dropItem.y = -(dropItem.fHeight + 8);
                     dropItem.fX = dropItem.x = -(dropItem.fWidth / 2);
                     cleanDropStack();
                     break;
                  case "getDrop":
                     i = 0;
                     while(i < ui.dropStack.numChildren)
                     {
                        mc = ui.dropStack.getChildAt(i) as MovieClip;
                        if(mc.fData != null && mc.fData.ItemID == resObj.ItemID)
                        {
                           if(resObj.bSuccess == 1)
                           {
                              mc.gotoAndPlay("out");
                           }
                           else
                           {
                              modal = new ModalMC();
                              modalO = {};
                              modalO.strBody = "Item could not be added to your inventory! Please make sure your inventory is not full or the item is already present in your inventory/bank.";
                              modalO.params = {};
                              modalO.glow = "red,medium";
                              modalO.btns = "mono";
                              ui.ModalStack.addChild(modal);
                              modal.init(modalO);
                              mc.cnt.ybtn.mouseEnabled = true;
                              mc.cnt.ybtn.mouseChildren = true;
                              if(mc is DFrame2MC)
                              {
                                 mc.isClosing = false;
                              }
                           }
                        }
                        i++;
                     }
                     if(resObj.bSuccess == 1)
                     {
                        dropitem = copyObj(world.invTree[resObj.ItemID]);
                        dropitem.CharItemID = resObj.CharItemID;
                        dropitem.bBank = resObj.bBank;
                        dropitem.iQty = int(resObj.iQty);
                        if(resObj.iQtyNow != null)
                        {
                           dropitem.iQtyNow = int(resObj.iQtyNow);
                        }
                        if(resObj.EnhID != null)
                        {
                           dropitem.EnhID = int(resObj.EnhID);
                           dropitem.EnhLvl = int(resObj.EnhLvl);
                           dropitem.EnhPatternID = int(resObj.EnhPatternID);
                           dropitem.EnhRty = int(resObj.EnhRty);
                        }
                        world.myAvatar.addItem(dropitem);
                        world.updateQuestProgress("item",dropitem);
                        if(resObj.showDrop == 1)
                        {
                           showItemDrop(dropitem,false);
                        }
                        if(ui.mcPopup.currentLabel == "Inventory" || ui.mcPopup.currentLabel == "HouseInventory")
                        {
                           MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshItems"});
                        }
                        if(ui.mcPopup.currentLabel == "Bank" || ui.mcPopup.currentLabel == "HouseBank")
                        {
                           MovieClip(ui.mcPopup.getChildByName("mcBank")).update({"eventType":"refreshBank"});
                        }
                        if(ui.mcPopup.currentLabel == "Shop" || ui.mcPopup.currentLabel == "MergeShop")
                        {
                           MovieClip(ui.mcPopup.getChildByName("mcShop")).update({"eventType":"refreshItems"});
                        }
                        if(dropitem.sType == "Item")
                        {
                           updateItemSkill();
                        }
                        if(resObj.pendingID != null)
                        {
                           world.myAvatar.updatePending(int(resObj.pendingID));
                        }
                        if(Boolean(cDropsUI) && Boolean(litePreference.data.bCustomDrops))
                        {
                           cDropsUI.acceptDrop(dropitem);
                        }
                     }
                     break;
                  case "addItems":
                     for(ItemID in resObj.items)
                     {
                        if(world.invTree[ItemID] == null)
                        {
                           itemObj = copyObj(resObj.items[ItemID]);
                        }
                        else
                        {
                           itemObj = copyObj(world.invTree[ItemID]);
                           for(iData in resObj.items[ItemID])
                           {
                              if(resObj.items[ItemID][iData] != itemObj[iData])
                              {
                                 itemObj[iData] = resObj.items[ItemID][iData];
                                 if(iData != "iQty")
                                 {
                                    world.invTree[ItemID][iData] = resObj.items[ItemID][iData];
                                 }
                              }
                           }
                        }
                        showItemDrop(itemObj,false);
                        if(Number(itemObj.bTemp) == 0)
                        {
                           world.myAvatar.addItem(itemObj);
                        }
                        else
                        {
                           world.myAvatar.addTempItem(itemObj);
                        }
                        world.updateQuestProgress("item",itemObj);
                        if(itemObj.sMeta == "doUpdate")
                        {
                           try
                           {
                              world.map.doUpdate();
                           }
                           catch(e:Error)
                           {
                              trace("[Resp] ERR addItems doUpdate: " + e.message);
                           }
                        }
                        if(itemObj.sType == "Item")
                        {
                           updateItemSkill();
                        }
                        if(ui.mcPopup.currentLabel == "Inventory" || ui.mcPopup.currentLabel == "HouseInventory")
                        {
                           MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshItems"});
                        }
                        if(ui.mcPopup.currentLabel == "Bank" || ui.mcPopup.currentLabel == "HouseBank")
                        {
                           MovieClip(ui.mcPopup.getChildByName("mcBank")).update({"eventType":"refreshBank"});
                        }
                     }
                     break;
                  case "Wheel":
                     dropItem = copyObj(resObj.dropItems["18927"]);
                     dropItem.CharItemID = resObj.charItem1;
                     if(world.invTree["18927"] == null)
                     {
                        dropItem.bBank = 0;
                     }
                     dropItem.iQty = resObj.dropQty != null ? Number(resObj.dropQty) : 1;
                     world.myAvatar.addItem(dropItem);
                     dropItem = copyObj(resObj.dropItems["19189"]);
                     dropItem.CharItemID = resObj.charItem2;
                     if(world.invTree["19189"] == null)
                     {
                        dropItem.bBank = 0;
                     }
                     dropItem.iQty = 1;
                     world.myAvatar.addItem(dropItem);
                     if(resObj.Item != null)
                     {
                        dropItem = copyObj(resObj.Item);
                        dropItem.CharItemID = resObj.CharItemID;
                        dropItem.bBank = 0;
                        dropItem.iQty = 1;
                        world.myAvatar.addItem(dropItem);
                     }
                     if(ui.mcPopup.currentLabel == "Inventory" || ui.mcPopup.currentLabel == "HouseInventory")
                     {
                        MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshItems"});
                     }
                     try
                     {
                        world.map.doWheelDrop(resObj.Item,resObj.dropQty);
                     }
                     catch(e:*)
                     {
                        trace("[Resp] ERR Wheel doWheelDrop: " + e);
                     }
                  case "powerGem":
                     for(ItemID in resObj.items)
                     {
                        if(world.invTree[ItemID] == null)
                        {
                           itemObj = copyObj(resObj.items[ItemID]);
                        }
                        else
                        {
                           itemObj = copyObj(world.invTree[ItemID]);
                           itemObj.iQty = int(resObj.items[ItemID].iQty);
                        }
                        showItemDrop(itemObj,false);
                        world.myAvatar.addItem(itemObj);
                     }
                     break;
                  case "forceAddItem":
                     for(fi in resObj.items)
                     {
                        iobj = copyObj(resObj.items[fi]);
                        world.myAvatar.addItem(iobj);
                     }
                     break;
                  case "warvalues":
                     world.map.updateWarValues(resObj.wars);
                     break;
                  case "turnIn":
                     if(resObj.sItems != null && resObj.sItems.length >= 3)
                     {
                        itemArr = resObj.sItems.split(",");
                        dropindex = 0;
                        while(dropindex < itemArr.length)
                        {
                           dropID = itemArr[dropindex].split(":")[0];
                           dropQty = int(itemArr[dropindex].split(":")[1]);
                           if(world.invTree[dropID].bTemp == 0)
                           {
                              world.myAvatar.removeItemByID(dropID,dropQty);
                           }
                           else
                           {
                              world.myAvatar.removeTempItem(dropID,dropQty);
                           }
                           dropindex++;
                        }
                     }
                     if(ui.mcPopup.currentLabel == "HouseInventory" || ui.mcPopup.currentLabel == "Inventory")
                     {
                        MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshItems"});
                     }
                     break;
                  case "getQuest":
                     break;
                  case "getQuests":
                     for(qi in resObj.quests)
                     {
                        if(world.questTree[qi] == null)
                        {
                           o = resObj.quests[qi];
                           world.questTree[qi] = o;
                           for(qr in o.oReqd)
                           {
                              if(world.invTree[qr] == null)
                              {
                                 world.invTree[qr] = o.oReqd[qr];
                                 world.invTree[qr].iQty = 0;
                              }
                           }
                           for(qj in o.oItems)
                           {
                              if(world.invTree[qj] == null)
                              {
                                 world.invTree[qj] = o.oItems[qj];
                                 world.invTree[qj].iQty = 0;
                              }
                           }
                           qk = "";
                           qat = ["itemsS","itemsC","itemsR","itemsrand"];
                           i = 0;
                           while(i < qat.length)
                           {
                              s = qat[i];
                              if(o.oRewards[s] != null)
                              {
                                 for(ri in o.oRewards[s])
                                 {
                                    if(isNaN(ri))
                                    {
                                       qk = ri.ItemID;
                                    }
                                    else
                                    {
                                       qk = o.oRewards[s][ri].ItemID;
                                    }
                                    if(world.invTree[qk] == null)
                                    {
                                       world.invTree[qk] = copyObj(o.oRewards[s][ri]);
                                       world.invTree[qk].iQty = 0;
                                    }
                                 }
                              }
                              i++;
                           }
                        }
                     }
                     if(ui.ModalStack.numChildren > 0)
                     {
                        MovieClip(ui.ModalStack.getChildAt(0)).open();
                     }
                     break;
                  case "getQuests2":
                     for(qi in resObj.quests)
                     {
                        if(world.questTree[qi] == null)
                        {
                           o = resObj.quests[qi];
                           world.questTree[qi] = o;
                           for(qr in o.oReqd)
                           {
                              if(world.invTree[qr] == null)
                              {
                                 world.invTree[qr] = o.oReqd[qr];
                                 world.invTree[qr].iQty = 0;
                              }
                           }
                           for(qj in o.oItems)
                           {
                              if(world.invTree[qj] == null)
                              {
                                 world.invTree[qj] = o.oItems[qj];
                                 world.invTree[qj].iQty = 0;
                              }
                           }
                           qk = "";
                           qat = ["itemsS","itemsC","itemsR","itemsrand"];
                           i = 0;
                           while(i < qat.length)
                           {
                              s = qat[i];
                              if(o.oRewards[s] != null)
                              {
                                 for(ri in o.oRewards[s])
                                 {
                                    if(isNaN(ri))
                                    {
                                       qk = ri.ItemID;
                                    }
                                    else
                                    {
                                       qk = o.oRewards[s][ri].ItemID;
                                    }
                                    if(world.invTree[qk] == null)
                                    {
                                       world.invTree[qk] = copyObj(o.oRewards[s][ri]);
                                       world.invTree[qk].iQty = 0;
                                    }
                                 }
                              }
                              i++;
                           }
                        }
                     }
                     createApop();
                     break;
                  case "ccqr":
                     if(resObj.bSuccess == 0)
                     {
                        if(Boolean(resObj.hasOwnProperty("msg")) && resObj.msg != null)
                        {
                           MsgBox.notify("Quest Complete Failed: " + resObj.msg);
                        }
                        else
                        {
                           MsgBox.notify("Quest Complete Failed!");
                        }
                     }
                     else
                     {
                        world.mapEventTrigger({
                           "cmd":"questComplete",
                           "args":resObj.QuestID
                        });
                        world.completeQuest(resObj.QuestID);
                        if(ui.ModalStack.numChildren)
                        {
                           fgWin = ui.ModalStack.getChildAt(0);
                           if(fgWin != null && fgWin.toString().indexOf("QFrameMC") > -1)
                           {
                              fgWin.turninResult(resObj.QuestID);
                           }
                        }
                        showQuestpopup(resObj);
                        if(apop_ != null)
                        {
                           apop_.questComplete(int(resObj.QuestID));
                        }
                        if(world.rootClass.litePreference.data.bReaccept)
                        {
                           if(world.questTree[resObj.QuestID])
                           {
                              if(world.questTree[resObj.QuestID].hasOwnProperty("bOnce"))
                              {
                                 if(world.questTree[resObj.QuestID].bOnce > 0)
                                 {
                                    break;
                                 }
                              }
                              if(getQuestValidationString(world.questTree[resObj.QuestID]) == "")
                              {
                                 world.acceptQuest(int(resObj.QuestID));
                              }
                           }
                        }
                     }
                     break;
                  case "updateQuest":
                     world.setQuestValue(resObj.iIndex,resObj.iValue);
                     break;
                  case "showQuestLink":
                     world.showQuestLink(resObj);
                     break;
                  case "dailylogin":
                     break;
                  case "initMonData":
                     for(m in resObj.mon)
                     {
                        world.updateMonster(resObj.mon[m]);
                     }
                     break;
                  case "aura+":
                  case "aura*":
                  case "aura-":
                  case "aura--":
                  case "aura++":
                  case "aura+p":
                     world.handleAuraEvent(cmd,resObj);
                     break;
                  case "clearAuras":
                     tAvt = world.myAvatar;
                     tLeaf = tAvt.dataLeaf;
                     keptAuras = [];
                     droppedAuras = [];
                     for each(clrAura in tLeaf.auras)
                     {
                        if(clrAura.persist)
                        {
                           keptAuras.push(clrAura);
                        }
                        else
                        {
                           droppedAuras.push(clrAura);
                        }
                     }
                     if(droppedAuras.length > 0)
                     {
                        world.showAuraChange({
                           "cmd":"aura-",
                           "auras":droppedAuras
                        },tAvt,tLeaf);
                     }
                     for each(clrAura in droppedAuras)
                     {
                        clrAura.casterType = null;
                        clrAura.casterId = null;
                     }
                     tLeaf.auras = keptAuras;
                     world.hudAuraClear(tLeaf,true);
                     break;
                  case "uotls":
                     userTreeWrite(resObj.unm,resObj.o);
                     break;
                  case "auSnap":
                     world.hudAuraSnap(resObj);
                     break;
                  case "mtls":
                     monsterTreeWrite(resObj.id,resObj.o,resObj.targets);
                     break;
                  case "cb":
                     if(resObj.m != null)
                     {
                        for(updateID in resObj.m)
                        {
                           monsterTreeWrite(int(updateID),resObj.m[updateID]);
                        }
                     }
                     if(resObj.p != null)
                     {
                        for(updateID in resObj.p)
                        {
                           userTreeWrite(updateID,resObj.p[updateID]);
                        }
                     }
                     if(resObj.anims != null)
                     {
                        if(sfcSocial)
                        {
                           for each(o in resObj.anims)
                           {
                              if(resObj.isProc)
                              {
                                 doAnim(o,resObj.isProc);
                              }
                              else
                              {
                                 doAnim(o);
                              }
                           }
                        }
                     }
                     if(resObj.a != null)
                     {
                        i = 0;
                        while(i < resObj.a.length)
                        {
                           world.handleAuraEvent(resObj.a[i].cmd,resObj.a[i]);
                           i++;
                        }
                     }
                     break;
                  case "ct":
                     anim = new Object();
                     if(resObj.m != null)
                     {
                        for(updateID in resObj.m)
                        {
                           monsterTreeWrite(int(updateID),resObj.m[updateID]);
                        }
                     }
                     if(resObj.p != null)
                     {
                        for(updateID in resObj.p)
                        {
                           userTreeWrite(updateID,resObj.p[updateID]);
                        }
                     }
                     if(resObj.a != null)
                     {
                        j = 0;
                        while(j < resObj.a.length)
                        {
                           try
                           {
                              if(resObj.a[j].auras != null)
                              {
                                 k = 0;
                                 while(k < resObj.a[j].auras.length)
                                 {
                                    if(resObj.a[j].auras[k].spellOn != null)
                                    {
                                       anim[resObj.a[j].auras[k].spellOn] = resObj.a[j].auras[k].dur;
                                    }
                                    k++;
                                 }
                              }
                           }
                           catch(e:Error)
                           {
                              trace("[Resp] ERR ct auraSpellOn: " + e.message);
                           }
                           world.handleAuraEvent(resObj.a[j].cmd,resObj.a[j]);
                           j++;
                        }
                     }
                     if(resObj.sara != null)
                     {
                        for each(o in resObj.sara)
                        {
                           world.handleSAR(o);
                        }
                     }
                     if(resObj.sarsa != null)
                     {
                        for each(o in resObj.sarsa)
                        {
                           world.handleSARS(o);
                        }
                     }
                     if(resObj.anims != null)
                     {
                        if(sfcSocial)
                        {
                           for each(o in resObj.anims)
                           {
                              if(resObj.isProc)
                              {
                                 doAnim(o,resObj.isProc,anim[o.strl]);
                              }
                              else
                              {
                                 doAnim(o,false,anim[o.strl]);
                              }
                           }
                        }
                     }
                     if(resObj.pvp != null)
                     {
                        switch(resObj.pvp.cmd)
                        {
                           case "PVPS":
                              updatePVPScore(resObj.pvp.pvpScore);
                              break;
                           case "PVPC":
                              world.PVPResults.pvpScore = resObj.pvp.pvpScore;
                              world.PVPResults.team = resObj.pvp.team;
                              world.PVPResults.ts = new Date().getTime();
                              updatePVPScore(resObj.pvp.pvpScore);
                              togglePVPPanel("results");
                        }
                     }
                     if(Boolean(world.myAvatar != null && world.myAvatar.objData != null) && Boolean(world.myAvatar.objData.eqp["pe"]) && Boolean(world.rootClass.litePreference.data.bBattlepet))
                     {
                        for each(bpObj in resObj.anims)
                        {
                           try
                           {
                              if(bpObj.tInf != null && bpObj.cInf != null && bpObj.tInf.indexOf("m:") > -1 && bpObj.cInf.indexOf("p:") > -1)
                              {
                                 bpAvt = world.getAvatarByUserID(Number(bpObj.cInf.split(":")[1]));
                                 if(bpAvt != null && Boolean(bpAvt.isMyAvatar))
                                 {
                                    if(bpObj.animStr == world.actions.active[0].anim)
                                    {
                                       world.myAvatar.pMC.queueAnim("PetAttack");
                                    }
                                 }
                              }
                           }
                           catch(eBP:Error)
                           {
                           }
                        }
                     }
                     break;
                  case "sar":
                     world.handleSAR(resObj);
                     break;
                  case "sars":
                     world.handleSARS(resObj);
                     break;
                  case "showAuraResult":
                     world.showAuraImpact(resObj);
                     break;
                  case "anim":
                     if(sfcSocial)
                     {
                        doAnim(resObj);
                     }
                     break;
                  case "sAct":
                     trace("[Resp] sAct isNewClass: " + isNewClass);
                     POTION_SLOT = 5;
                     if(isNewClass)
                     {
                        oldActions = null;
                        if(world.actions != null && world.actions.active != null)
                        {
                           for each(actObj in world.actions.active)
                           {
                              if(actObj != null)
                              {
                                 if(actObj.ref == "i1")
                                 {
                                    oldActions = copyObj(actObj);
                                 }
                              }
                           }
                        }
                        world.actions = {};
                        world.actions.active = oldActions != null ? [null,null,null,null,null,oldActions] : [];
                        world.actions.passive = [];
                        tempActionMap = new Vector.<Object>(6,true);
                        if(world.actionMap != null && world.actionMap.length > POTION_SLOT)
                        {
                           tempActionMap[POTION_SLOT] = world.actionMap[POTION_SLOT];
                        }
                        world.actionMap = tempActionMap;
                        blanki = 0;
                        while(blanki < 5)
                        {
                           ui.mcInterface.actBar.getChildByName("blank" + blanki).visible = true;
                           actBar = ui.mcInterface.actBar;
                           delIcon = actBar.getChildByName("i" + (blanki + 1));
                           if(delIcon != null)
                           {
                              delIcon.removeEventListener(MouseEvent.CLICK,actIconClick);
                              delIcon.removeEventListener(MouseEvent.MOUSE_OVER,actIconOver);
                              delIcon.removeEventListener(MouseEvent.MOUSE_OUT,actIconOut);
                              if(delIcon.icon2 != null)
                              {
                                 delIcon.removeEventListener(Event.ENTER_FRAME,world.countDownAct);
                                 if(delIcon.icon2.mask != null)
                                 {
                                    actBar.removeChild(delIcon.icon2.mask);
                                    delIcon.icon2.mask = null;
                                 }
                                 actBar.removeChild(delIcon.icon2);
                              }
                              actBar.removeChild(delIcon);
                           }
                           ui.mcInterface.actBar.getChildByName("txtCD" + blanki).visible = false;
                           ui.mcInterface.actBar.getChildByName("txtCD" + blanki).mouseEnabled = false;
                           blanki++;
                        }
                     }
                     updateCtr = int(resObj.actions.active.length);
                     if(world.actions.active[POTION_SLOT] != null)
                     {
                        updateCtr--;
                        delIcon = ui.mcInterface.actBar.getChildByName("i6");
                        if(delIcon)
                        {
                           if(delIcon.icon2 != null)
                           {
                              delIcon.ts = 0;
                           }
                           delIcon.actObj = world.actions.active[POTION_SLOT];
                        }
                        world.actions.active[POTION_SLOT].ts = 0;
                        world.lockdownPots = false;
                     }
                     ai = 0;
                     ai = 0;
                     while(ai < updateCtr)
                     {
                        actObj = resObj.actions.active[ai];
                        uiSlot = actObj.ref == "i1" ? POTION_SLOT : ai;
                        if(!isNewClass)
                        {
                           isNotUnlocked = ui.mcInterface.actBar.getChildByName("i" + (uiSlot + 1)).cnt.transform.colorTransform.toString().indexOf("0.09765625") > -1;
                           if(Boolean(resObj.actions.active[uiSlot].isOK) && isNotUnlocked)
                           {
                              existing = ui.mcInterface.actBar.getChildByName("i" + (uiSlot + 1));
                              existing.addEventListener(MouseEvent.CLICK,actIconClick,false,0,true);
                              existing.buttonMode = true;
                              existing.cnt.transform.colorTransform = new ColorTransform();
                              world.getActionByRef(String(world.actionMap[uiSlot])).isOK = true;
                           }
                        }
                        else
                        {
                           actObj.sArg1 = "";
                           actObj.sArg2 = "";
                           world.actions.active[uiSlot] = actObj;
                           actObj.ts = 0;
                           actObj.actID = -1;
                           actObj.lock = false;
                           world.actionMap[uiSlot] = actObj.ref;
                           if(!ApplicationDomain.currentDomain.hasDefinition("ib2"))
                           {
                              trace("[Load] ERR missing linkage ib2 sAct slot " + uiSlot);
                           }
                           else
                           {
                              actIconClass = getDefinitionByName("ib2") as Class;
                              actIcon = new actIconClass();
                              actIconMC = ui.mcInterface.actBar.addChild(actIcon);
                              blankMC = ui.mcInterface.actBar.getChildByName("blank" + uiSlot);
                              actIconMC.x = blankMC.x;
                              actIconMC.width = 42;
                              actIconMC.height = 39;
                              actIconMC.name = String("i" + (uiSlot + 1));
                              actIconMC.actionIndex = uiSlot;
                              actIconMC.actObj = actObj;
                              actIconMC.icon2 = null;
                              actIconMC.tQty.visible = false;
                              actIconMC.y -= 6;
                              updateIcons([actIconMC],actObj.icon.split(","),null);
                              blankMC.visible = false;
                              actIconMC.addEventListener(MouseEvent.MOUSE_OVER,actIconOver,false,0,true);
                              actIconMC.addEventListener(MouseEvent.MOUSE_OUT,actIconOut,false,0,true);
                              actIconMC.mouseChildren = false;
                              if(actObj.auto != null && actObj.auto == true)
                              {
                                 world.actions.auto = world.actions.active[uiSlot];
                              }
                              else
                              {
                                 world.actions.active[uiSlot].auto = false;
                              }
                              if(actObj.isOK)
                              {
                                 actIconMC.addEventListener(MouseEvent.CLICK,actIconClick,false,0,true);
                                 actIconMC.buttonMode = true;
                              }
                              else
                              {
                                 c = new Color();
                                 c.setTint(3355443,0.9);
                                 actIconMC.cnt.transform.colorTransform = c;
                              }
                           }
                        }
                        ai++;
                     }
                     world.myAvatar.dataLeaf.passives = [];
                     if(resObj.actions.passive != null)
                     {
                        ai = 0;
                        while(ai < resObj.actions.passive.length)
                        {
                           actObj = copyObj(resObj.actions.passive[ai]);
                           actObj.sArg1 = "";
                           actObj.sArg2 = "";
                           world.actions.passive.push(actObj);
                           if(actObj.auras != null)
                           {
                              i = 0;
                              while(i < actObj.auras.length)
                              {
                                 world.myAvatar.dataLeaf.passives.push(actObj.auras[i]);
                                 i++;
                              }
                           }
                           ai++;
                        }
                     }
                     if(isNewClass && Boolean(litePreference.data.bAuras))
                     {
                        pAurasUI.classChanged();
                        tAurasUI.classChanged();
                     }
                     isNewClass = false;
                     break;
                  case "seia":
                     world.lockdownPots = false;
                     if(resObj.iRes == 1)
                     {
                        ai = 0;
                        while(ai < world.actions.active.length)
                        {
                           o = world.actions.active[ai];
                           if(o)
                           {
                              if(o.ref == "i1")
                              {
                                 if("tgtMax" in o)
                                 {
                                    delete o.tgtMax;
                                 }
                                 if("tgtMin" in o)
                                 {
                                    delete o.tgtMin;
                                 }
                                 if("auras" in o)
                                 {
                                    delete o.auras;
                                 }
                                 if(!world.actionTimeCheck(o,true))
                                 {
                                    if(o.OldCD == null)
                                    {
                                       o.OldCD = o.cd;
                                    }
                                 }
                                 else if(world.actionTimeCheck(o,true))
                                 {
                                    o.ts = 0;
                                 }
                                 for(s in resObj.o)
                                 {
                                    if(s != "nam" && s != "ref" && s != "desc" && s != "typ")
                                    {
                                       o[s] = resObj.o[s];
                                    }
                                 }
                                 world.lockdownPots = false;
                              }
                           }
                           ai++;
                        }
                     }
                     if(equipPotionOnSeia)
                     {
                        world.testAction(world.getActionByRef(String(world.actionMap[5])));
                        equipPotionOnSeia = false;
                     }
                     break;
                  case "stu":
                     avt = world.myAvatar;
                     unm = sfc.myUserName;
                     uoLeaf = world.uoTreeLeaf(unm);
                     if(resObj.wDPS != null)
                     {
                        uoLeaf.wDPS = resObj.wDPS;
                     }
                     if(resObj.mDPS != null)
                     {
                        uoLeaf.mDPS = resObj.mDPS;
                     }
                     if(uoLeaf.sta == null)
                     {
                        uoLeaf.sta = {};
                     }
                     for(stuS in resObj.sta)
                     {
                        uoLeaf.sta[stuS] = resObj.sta[stuS];
                        if(stats.indexOf(stuS.substr(1)) > -1)
                        {
                           uoLeaf.sta[stuS] = int(uoLeaf.sta[stuS]);
                        }
                        else
                        {
                           uoLeaf.sta[stuS] = Number(uoLeaf.sta[stuS]);
                        }
                        if(stuS.toLowerCase().indexOf("$tha") > -1)
                        {
                           actObj = world.getAutoAttack();
                           if(actObj != null && uoLeaf != null && uoLeaf.sta != null)
                           {
                              cd = Math.round(actObj.cd * (1 - Math.min(Math.max(uoLeaf.sta.$tha,-1),0.5)));
                              if(world.autoActionTimer.running)
                              {
                                 world.autoActionTimer.delay -= world.autoActionTimer.delay - cd;
                                 world.autoActionTimer.delay += 100;
                                 world.autoActionTimer.reset();
                                 world.autoActionTimer.start();
                              }
                              else
                              {
                                 world.autoActionTimer.delay = cd;
                              }
                           }
                           else
                           {
                              trace("[Resp] ERR stu: login event order error");
                           }
                           hasteCoeff = 1 - Math.min(Math.max(uoLeaf.sta.$tha,-1),0.5);
                           world.GCD = Math.round(hasteCoeff * world.GCDO);
                           for each(actObj in world.actions.active)
                           {
                              if(actObj != null)
                              {
                                 if(Boolean(actObj.isOK && world.getActIcons(actObj)[0] != null) && Boolean(world.getActIcons(actObj)[0].icon2 == null) && now - actObj.ts < actObj.cd * hasteCoeff)
                                 {
                                    world.coolDownAct(actObj,actObj.cd * hasteCoeff - (now - actObj.ts),now);
                                 }
                              }
                           }
                        }
                        if(stuS.toLowerCase().indexOf("$cmc") > -1)
                        {
                           world.updateActBar();
                        }
                     }
                     if(resObj.tempSta != null)
                     {
                        uoLeaf.tempSta = resObj.tempSta;
                        if("updatePStats" in world.map)
                        {
                           world.map.updatePStats();
                        }
                     }
                     if(avt != null)
                     {
                        world.updatePortrait(avt);
                     }
                     if(statsNewClass)
                     {
                        baseClassStats = new Object();
                        for(stu in resObj.sta)
                        {
                           baseClassStats[stu] = resObj.sta[stu];
                        }
                        if(mcStatsPanel)
                        {
                           mcStatsPanel.updateBase();
                        }
                        statsNewClass = false;
                     }
                     if(mcStatsPanel)
                     {
                        mcStatsPanel.update();
                     }
                     break;
                  case "event":
                     world.mapEventTrigger(resObj);
                     break;
                  case "modinfo":
                     world.map.showModInfo(resObj);
                     break;
                  case "modinc":
                     if(resObj.bSuccess)
                     {
                        world.map.hideLoading();
                        world.map.show(resObj.events);
                        world.modID = int(resObj.mID);
                     }
                     else
                     {
                        chatF.pushMsg("warning",resObj.msg,"SERVER","",0);
                     }
                     break;
                  case "ia":
                     if("iaPathMC" in resObj)
                     {
                        try
                        {
                           mc = world;
                           mcPath = resObj.iaPathMC.split(".");
                           while(mcPath.length > 0)
                           {
                              s = String(mcPath.shift());
                              if(mc.getChildByName(s) != null)
                              {
                                 mc = mc.getChildByName(s) as MovieClip;
                              }
                              else
                              {
                                 mc = mc[s];
                              }
                           }
                        }
                        catch(e:Error)
                        {
                           trace("[Resp] ERR ia path " + resObj.iaPathMC + ": " + e.message);
                        }
                     }
                     else if(resObj.str != null)
                     {
                        avt = world.getAvatarByUserID(int(resObj.str));
                        if(avt != null)
                        {
                           mc = avt.pMC;
                        }
                     }
                     else
                     {
                        mc = MovieClip(world.CHARS.getChildByName(resObj.oName));
                     }
                     if(mc != null && mc != world)
                     {
                        try
                        {
                           switch(resObj.typ)
                           {
                              case "rval":
                                 mc.userName = resObj.unm;
                                 mc.iaF(resObj);
                                 break;
                              case "str":
                                 if(resObj.str == null)
                                 {
                                    mc.userName = resObj.unm;
                                 }
                                 mc.iaF(resObj);
                                 break;
                              case "flourish":
                                 mc.userName = resObj.unm;
                                 if(resObj.oFrame != null)
                                 {
                                    mc.gotoAndPlay(resObj.oFrame);
                                 }
                                 else if("iaFrame" in mc && mc.iaFrame != null)
                                 {
                                    mc.gotoAndPlay(mc.iaFrame);
                                 }
                           }
                        }
                        catch(e:Error)
                        {
                           trace("[Resp] ERR ia: " + e.message);
                        }
                     }
                     break;
                  case "siau":
                     world.updateCellMap(resObj);
                     break;
                  case "umsg":
                     addUpdate(resObj.s);
                     break;
                  case "gi":
                     modal = null;
                     modalO = null;
                     modal = new ModalMC();
                     modalO = {};
                     modalO.strBody = resObj.owner + " has invited you to join the guild " + resObj.gName + ". Do you accept?";
                     modalO.callback = world.doGuildAccept;
                     modalO.params = {
                        "guildID":resObj.guildID,
                        "owner":resObj.owner
                     };
                     modalO.btns = "dual";
                     ui.ModalStack.addChild(modal);
                     modal.init(modalO);
                     chatF.pushMsg("server",resObj.owner + " has invited you to join the guild " + resObj.gName,"SERVER","",0);
                     break;
                  case "gd":
                     chatF.pushMsg("server",resObj.unm + " has declined your invitation.","SERVER","",0);
                     break;
                  case "ga":
                     avt = world.getAvatarByUserName(resObj.unm);
                     if(avt != null)
                     {
                        avt.updateGuild(resObj.guild);
                        if(avt.isMyAvatar)
                        {
                           chatF.chn.guild.act = 1;
                           chatF.pushMsg("server","You have joined the guild.","SERVER","",0);
                        }
                        else if(world.myAvatar != null && world.myAvatar.objData != null && world.myAvatar.objData.guild != null && resObj.guild != null && world.myAvatar.objData.guild.Name == resObj.guild.Name)
                        {
                           chatF.pushMsg("server",avt.pnm + " has joined the guild.","SERVER","",0);
                           world.myAvatar.updateGuild(resObj.guild);
                        }
                     }
                     else if(world.myAvatar != null && world.myAvatar.objData != null && world.myAvatar.objData.guild != null && resObj.guild != null && resObj.guild.Name == world.myAvatar.objData.guild.Name)
                     {
                        chatF.pushMsg("server",resObj.unm + " has joined the guild.","SERVER","",0);
                        world.myAvatar.updateGuild(resObj.guild);
                     }
                     break;
                  case "gr":
                     avt = world.getAvatarByUserName(resObj.unm);
                     if(avt != null)
                     {
                        avt.updateGuild(null);
                        if(avt.isMyAvatar)
                        {
                           chatF.chn.guild.act = 0;
                           chatF.pushMsg("server","You have been removed from the guild.","SERVER","",0);
                        }
                     }
                     break;
                  case "guildDelete":
                     avt = world.getAvatarByUserName(resObj.unm);
                     if(avt != null)
                     {
                        avt.updateGuild(null);
                        if(avt.isMyAvatar)
                        {
                           chatF.chn.guild.act = 0;
                           chatF.pushMsg("server",resObj.msg,"SERVER","",0);
                        }
                     }
                     break;
                  case "gMOTD":
                     if(world.myAvatar != null && world.myAvatar.objData != null && world.myAvatar.objData.guild != null)
                     {
                        world.myAvatar.objData.guild.MOTD = resObj.MOTD[0];
                     }
                     break;
                  case "updateGuild":
                     try
                     {
                        if(world.myAvatar != null && world.myAvatar.objData != null)
                        {
                           world.myAvatar.updateGuild(resObj.guild);
                           if(resObj.guild != null)
                           {
                              chatF.chn.guild.act = 1;
                           }
                        }
                        else
                        {
                           pendingSelfGuild = resObj.guild;
                        }
                     }
                     catch(e:Error)
                     {
                        trace("[Resp] ERR siau updateGuild: " + e.message);
                     }
                     if(resObj.msg != null)
                     {
                        chatF.pushMsg("server",resObj.msg,"SERVER","",0);
                     }
                     break;
                  case "gc":
                     avt = world.getAvatarByUserID(resObj.uid);
                     if(avt != null)
                     {
                        avt.initGuild(resObj.guild);
                     }
                     break;
                  case "interior":
                  case "guildhall":
                  case "guildinv":
                     break;
                  case "pi":
                     modal = null;
                     modalO = null;
                     modal = new ModalMC();
                     modalO = {};
                     modalO.strBody = resObj.owner + " has invited you to join their group.  Do you accept?";
                     modalO.callback = world.doPartyAccept;
                     modalO.params = {"pid":resObj.pid};
                     modalO.btns = "dual";
                     ui.ModalStack.addChild(modal);
                     modal.init(modalO);
                     chatF.pushMsg("server",resObj.owner + " has invited you to a group.","SERVER","",0);
                     break;
                  case "pa":
                     if(world.partyOwner == "")
                     {
                        world.partyOwner = resObj.owner;
                     }
                     supressMupltiples = false;
                     if(world.partyID == -1)
                     {
                        world.partyID = resObj.pid;
                        chatF.chn.party.act = 1;
                        if(resObj.owner.toLowerCase() != sfc.myUserName)
                        {
                           chatF.pushMsg("server","You have joined the party.","SERVER","",0);
                           supressMupltiples = true;
                        }
                     }
                     i = 0;
                     while(i < resObj.ul.length)
                     {
                        unm = resObj.ul[i];
                        if(unm.toLowerCase() != sfc.myUserName)
                        {
                           world.addPartyMember(unm);
                           if(!supressMupltiples)
                           {
                              chatF.pushMsg("server",unm + " has joined the party.","SERVER","",0);
                           }
                        }
                        i++;
                     }
                     break;
                  case "pr":
                     isYou = false;
                     nam = world.partyOwner;
                     world.partyOwner = resObj.owner;
                     if(nam != world.partyOwner)
                     {
                        chatF.pushMsg("server",world.partyOwner + " is now the party leader.","SERVER","",0);
                     }
                     if(resObj.unm.toLowerCase() == sfc.myUserName.toLowerCase())
                     {
                        isYou = true;
                        chatF.chn.party.act = 0;
                     }
                     if(resObj.typ == "k")
                     {
                        if(isYou)
                        {
                           chatF.pushMsg("server","You have been removed from the party","SERVER","",0);
                        }
                        else
                        {
                           chatF.pushMsg("server",resObj.unm + " has been removed from the party","SERVER","",0);
                        }
                     }
                     else if(resObj.typ == "l")
                     {
                        if(isYou)
                        {
                           chatF.pushMsg("server","You have left the party","SERVER","",0);
                        }
                        else
                        {
                           chatF.pushMsg("server",resObj.unm + " has left the party","SERVER","",0);
                        }
                     }
                     world.removePartyMember(String(resObj.unm).toLowerCase());
                     break;
                  case "pp":
                     nam = world.partyOwner;
                     world.partyOwner = resObj.owner;
                     if(nam != world.partyOwner)
                     {
                        chatF.pushMsg("server",world.partyOwner + " is now the party leader.","SERVER","",0);
                     }
                     world.updatePartyFrame();
                     break;
                  case "ps":
                     modal = null;
                     modalO = null;
                     modal = new ModalMC();
                     modalO = {};
                     modalO.strBody = resObj.unm + " wants to summon you to them.  Do you accept?";
                     modalO.callback = world.acceptPartySummon;
                     modalO.params = resObj;
                     modalO.btns = "dual";
                     ui.ModalStack.addChild(modal);
                     modal.init(modalO);
                     chatF.pushMsg("server",resObj.unm + " is trying to summon you to them.","SERVER","",0);
                     break;
                  case "pd":
                     chatF.pushMsg("server",resObj.unm + " has declined your invitation.","SERVER","",0);
                     break;
                  case "pc":
                     if(world.partyID > -1)
                     {
                        chatF.pushMsg("server","Your party has been disbanded","SERVER","",0);
                     }
                     world.partyID = -1;
                     world.partyOwner = "";
                     world.partyMembers = new Vector.<String>();
                     world.updatePartyFrame();
                     chatF.chn.party.act = 0;
                     if(chatF.chn.cur == chatF.chn.party)
                     {
                        chatF.chn.cur = chatF.chn.zone;
                     }
                     if(chatF.chn.lastPublic == chatF.chn.party)
                     {
                        chatF.chn.lastPublic = chatF.chn.zone;
                     }
                     break;
                  case "PVPQ":
                     world.handlePVPQueue(resObj);
                     break;
                  case "PVPI":
                     world.receivePVPInvite(resObj);
                     break;
                  case "PVPE":
                     relayPVPEvent(resObj);
                     break;
                  case "PVPS":
                     updatePVPScore(resObj.pvpScore);
                     break;
                  case "PVPC":
                     world.PVPResults.pvpScore = resObj.pvpScore;
                     world.PVPResults.team = resObj.team;
                     world.PVPResults.ts = new Date().getTime();
                     updatePVPScore(resObj.pvpScore);
                     togglePVPPanel("results");
                     break;
                  case "pvpbreakdown":
                     break;
                  case "di":
                     modal = null;
                     modalO = null;
                     modal = new ModalMC();
                     modalO = {};
                     modalO.strBody = resObj.owner + " has challenged you to a duel.  Do you accept?";
                     modalO.callback = world.doDuelAccept;
                     modalO.params = {"unm":resObj.owner};
                     modalO.btns = "dual";
                     ui.ModalStack.addChild(modal);
                     modal.init(modalO);
                     chatF.pushMsg("server",resObj.owner + " has challenged you to a duel.","SERVER","",0);
                     break;
                  case "DuelEX":
                     world.duelExpire();
                     break;
                  case "loadFactions":
                     world.myAvatar.initFactions(resObj.factions);
                     break;
                  case "addFaction":
                     world.myAvatar.addFaction(resObj.faction);
                     break;
                  case "loadFriendsList":
                     world.myAvatar.initFriendsList(resObj.friends);
                     break;
                  case "requestFriend":
                     modal = null;
                     modalO = null;
                     modal = new ModalMC();
                     modalO = {};
                     modalO.strBody = resObj.unm + " has invited you to be friends. Do you accept?";
                     modalO.callback = world.addFriend;
                     modalO.params = {
                        "ID":resObj.ID,
                        "unm":resObj.unm
                     };
                     modalO.btns = "dual";
                     ui.ModalStack.addChild(modal);
                     modal.init(modalO);
                     chatF.pushMsg("server",resObj.unm + " has invited you to be friends.","SERVER","",0);
                     break;
                  case "addFriend":
                     world.myAvatar.addFriend(resObj.friend);
                     break;
                  case "updateFriend":
                     world.myAvatar.updateFriend(resObj.friend);
                     break;
                  case "deleteFriend":
                     world.myAvatar.deleteFriend(resObj.ID);
                     break;
                  case "isModerator":
                     modal = null;
                     modalO = null;
                     modal = new ModalMC();
                     modalO = {};
                     modalO.btns = "mono";
                     if(resObj.val)
                     {
                        modalO.strBody = resObj.unm + " is staff!";
                        modalO.glow = "gold,medium";
                        chatF.pushMsg("server",resObj.unm + " is staff!","SERVER","",0);
                     }
                     else
                     {
                        modalO.strBody = resObj.unm + " is NOT staff!";
                        modalO.glow = "red,medium";
                        chatF.pushMsg("warning",resObj.unm + " is NOT staff!","SERVER","",0);
                     }
                     ui.ModalStack.addChild(modal);
                     modal.init(modalO);
                     break;
                  case "loadWarVars":
                     world.objResponse["loadWarVars"] = resObj;
                     world.dispatchEvent(new Event("loadWarVars"));
                     break;
                  case "setAchievement":
                     world.updateAchievement(resObj.field,resObj.index,resObj.value);
                     break;
                  case "loadQuestStringData":
                     world.objQuestString = resObj.obj;
                     world.dispatchEvent(new Event("QuestStringData_Complete"));
                     break;
                  case "getAdData":
                     if(resObj.bSuccess == 1)
                     {
                        world.adData = resObj.bh;
                        world.dispatchEvent(new Event("getAdData"));
                     }
                     break;
                  case "getAdReward":
                     world.myAvatar.objData.iDailyAds += 1;
                     world.adData = null;
                     if(world.myAvatar.objData.iDailyAds < world.myAvatar.objData.iDailyAdCap)
                     {
                        world.sendGetAdDataRequest();
                     }
                     world.myAvatar.objData.intGold += int(resObj.iGold);
                     setGoldDisplay(world.myAvatar.objData.intGold);
                     if(ui.mcPopup.currentLabel == "HouseInventory" || ui.mcPopup.currentLabel == "Inventory")
                     {
                        MovieClip(ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshCoins"});
                     }
                     world.myAvatar.objData.intCoins += int(resObj.iCoins);
                     sMsg = "Congratulations! You just received <font color=\'#FFCC00\'><b>" + resObj.iGold + " Gold</b></font>";
                     if(resObj.iCoins > 0)
                     {
                        sMsg += " and <font color=\'#990099\'><b>" + resObj.iCoins + " Adventure Coins</b></font>";
                     }
                     sMsg += " from Ballyhoo.";
                     showMessageBox(sMsg);
                     break;
                  case "xpboost":
                     manageXPBoost(resObj);
                     break;
                  case "gboost":
                     manageGBoost(resObj);
                     break;
                  case "repboost":
                     manageRepBoost(resObj);
                     break;
                  case "cpboost":
                     manageCPBoost(resObj);
                     break;
                  case "gettimes":
                     a = [];
                     for(s in resObj.o)
                     {
                        o = resObj.o[s];
                        o.s = s;
                        a.push(o);
                     }
                     a.sortOn("t",Array.NUMERIC | Array.DESCENDING);
                     i = 0;
                     while(i < a.length)
                     {
                        o = a[i];
                        trace("[Resp] gettimes: " + o.s + "," + o.t + "," + o.n + "," + numToStr(o.t / o.n) + "," + Math.round(o.d));
                        i++;
                     }
                     break;
                  case "clockTick":
                     world.mapEventTrigger(resObj);
                     break;
                  case "castWait":
                     try
                     {
                        world.map.fishGame.castingWait(resObj.wait,resObj.derp);
                     }
                     catch(e:Error)
                     {
                        trace("[Resp] ERR castWait: " + e.message);
                     }
                     break;
                  case "CatchResult":
                     world.myAvatar.addRep(20,resObj.catchResult.myRep);
                     try
                     {
                        world.map.fishGame.showCatch(resObj);
                     }
                     catch(e:Error)
                     {
                        trace("[Resp] ERR CatchResult showCatch: " + e.message);
                     }
                     break;
                  case "alchOnStart":
                     world.map.alchemyGame.onStart(resObj);
                     break;
                  case "alchComplete":
                     world.map.alchemyGame.checkComplete(resObj);
                     break;
                  case "spellOnStart":
                     world.map.mcGame.spellOnStart(resObj);
                     break;
                  case "spellComplete":
                     world.map.mcGame.spellComplete(resObj);
                     break;
                  case "spellWaitTimer":
                     world.map.mcGame.spellWaitTimer(resObj);
                     break;
                  case "playerDeath":
                     world.mapEventTrigger(resObj);
                     break;
                  case "getScrolls":
                     try
                     {
                        world.scrollData = resObj.scrolls;
                        world.map.initScrollData();
                     }
                     catch(e:*)
                     {
                        trace("[Resp] ERR getScrolls initScrollData: " + e);
                     }
                     break;
                  case "turninscroll":
                     if(resObj.IDs != null)
                     {
                        i = 0;
                        while(i < resObj.IDs.length)
                        {
                           world.myAvatar.updateScrolls(int(resObj.IDs[i]));
                           i++;
                        }
                        s = "";
                        i = 0;
                        while(i < 500)
                        {
                           s += String.fromCharCode(0);
                           i++;
                        }
                        world.myAvatar.objData.pending = s;
                        try
                        {
                           world.map.displayTurnins(resObj.IDs);
                        }
                        catch(e:*)
                        {
                           trace("[Resp] ERR turninscroll displayTurnins: " + e);
                        }
                     }
                     break;
                  case "getapop":
                     if(resObj.apopData != null)
                     {
                        apopTree[String(resObj.apopData.apopID)] = resObj.apopData;
                        if(!resObj.bQuests)
                        {
                           createApop();
                        }
                     }
                     break;
                  case "mailList":
                  case "mailNew":
                  case "mailClaim":
                  case "mailBody":
                     if(mailHub != null)
                     {
                        mailHub.onPacket(resObj);
                     }
               }
            }
            try
            {
               if(world.map.Events != null)
               {
                  if(world.map.Events[cmd] != null)
                  {
                     trace("[Resp] map event: " + cmd);
                     world.map.responseEvent(cmd,resObj);
                  }
               }
            }
            catch(e:*)
            {
               trace("[Resp] ERR responseEvent " + cmd + ": " + e);
            }
         };
         addFrameScript(0,this.frame1,11,this.frame12,12,this.frame13,22,this.frame23,32,this.frame33,42,this.frame43);
         try
         {
            Security.allowDomain("*.aq.com");
         }
         catch(e:Error)
         {
         }
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.sfc = new SmartFoxClient();
         this.sfc.debug = false;
         this.sfc.smartConnect = false;
         gameSelf = this;
         this.sfc.addEventListener(SFSEvent.onConnection,onConnectionHandler);
         this.sfc.addEventListener(SFSEvent.onConnectionLost,onConnectionLostHandler);
         this.sfc.addEventListener(SFSEvent.onLogin,onLoginHandler);
         this.sfc.addEventListener(SFSEvent.onLogout,onLogoutHandler);
         this.sfc.addEventListener(SFSEvent.onObjectReceived,onObjectReceivedHandler);
         this.sfc.addEventListener(SFSEvent.onRoundTripResponse,onRoundTripResponseHandler);
         this.sfc.addEventListener(SFSEvent.onUserLeaveRoom,onUserLeaveRoomHandler);
         this.flushPendingSelfInitData = applyPendingSelfInitData;
         this.sfc.addEventListener(SFSEvent.onExtensionResponse,onExtensionResponseHandler);
         this.classCatMap.M1.ratios = [0.27,0.3,0.22,0.05,0.1,0.06];
         this.classCatMap.M2.ratios = [0.2,0.22,0.33,0.05,0.1,0.1];
         this.classCatMap.M3.ratios = [0.24,0.2,0.2,0.24,0.07,0.05];
         this.classCatMap.M4.ratios = [0.3,0.18,0.3,0.02,0.06,0.14];
         this.classCatMap.C1.ratios = [0.06,0.2,0.11,0.33,0.15,0.15];
         this.classCatMap.C2.ratios = [0.08,0.27,0.1,0.3,0.1,0.15];
         this.classCatMap.C3.ratios = [0.06,0.23,0.05,0.28,0.28,0.1];
         this.classCatMap.S1.ratios = [0.22,0.18,0.21,0.08,0.08,0.23];
         this.userPreference = SharedObject.getLocal("AQWUserPref","/");
         this.litePreference = SharedObject.getLocal("AQLite_Data","/");
         this.inituoPref();
         this.initlitePref();
         this.initKeybindPref();
         if(this.userPreference.data.quality == null)
         {
            this.userPreference.data.quality = "AUTO";
         }
         this.initArrRep();
         if(this.litePreference.data.bChatUI)
         {
            this.chatF = new Chat2(this);
            this.intChatMode = 1;
         }
         else
         {
            this.chatF = new Chat();
            this.chatF.rootClass = this;
            this.intChatMode = 0;
         }
      }

      public static function vurl(param1:String) : String
      {
         if(param1 == null)
         {
            return param1;
         }
         param1 = param1.replace(/^\s+|\s+$/g,"");
         if(param1.length == 0 || param1.indexOf("file://") == 0 || param1.indexOf("?v=") >= 0 || param1.indexOf("&v=") >= 0)
         {
            return param1;
         }
         return param1 + (param1.indexOf("?") < 0 ? "?v=" : "&v=") + vParam;
      }

      public static function gTrace(param1:*) : *
      {
         if(Game.ISWEB)
         {
            if(!ExternalInterface.available)
            {
               return;
            }
            ExternalInterface.call("console.log",param1);
         }
         else
         {
            trace(param1);
         }
      }

      public static function trim(param1:String) : String
      {
         if(param1 == null)
         {
            return "";
         }
         return param1.replace(/^\s+|\s+$/g,"");
      }

      public static function XMLtoObject(param1:XML) : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = {};
         for(_loc1_ in param1.attributes())
         {
            _loc4_[String(param1.attributes()[_loc1_].name())] = String(param1.attributes()[_loc1_]);
         }
         for(_loc2_ in param1.children())
         {
            _loc3_ = param1.children()[_loc2_].name();
            if(_loc4_[_loc3_] == undefined)
            {
               _loc4_[_loc3_] = [];
            }
            _loc4_[_loc3_].push(XMLtoObject(param1.children()[_loc2_]));
         }
         return _loc4_;
      }

      public static function convertXMLtoObject(param1:XML) : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:XML = null;
         var _loc4_:* = undefined;
         var _loc5_:* = {};
         for(_loc1_ in param1.attributes())
         {
            _loc5_[String(param1.attributes()[_loc1_].name())] = String(param1.attributes()[_loc1_]);
         }
         for(_loc2_ in param1.children())
         {
            _loc3_ = param1.children()[_loc2_];
            if(_loc3_.nodeKind() == "text")
            {
               if(_loc3_ == parseFloat(_loc3_).toString())
               {
                  return parseFloat(_loc3_);
               }
               return _loc3_;
            }
            if(_loc3_.nodeKind() == "element")
            {
               _loc4_ = param1.children()[_loc2_].name();
               if(_loc5_[_loc4_] == null)
               {
                  _loc5_[_loc4_] = convertXMLtoObject(param1.children()[_loc2_]);
               }
               else
               {
                  if(!(_loc5_[_loc4_] is Array))
                  {
                     _loc5_[_loc4_] = [_loc5_[_loc4_]];
                  }
                  _loc5_[_loc4_].push(convertXMLtoObject(param1.children()[_loc2_]));
               }
            }
         }
         return _loc5_;
      }

      private static function makeGrayscale(param1:DisplayObject, param2:int = 0, param3:Number = 0.33) : void
      {
         var _loc1_:Color = null;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:Array = [param3,param3,param3,0,0,param3,param3,param3,0,0,param3,param3,param3,0,0,param3,param3,param3,1,0];
         var _loc3_:ColorMatrixFilter = new ColorMatrixFilter(_loc2_);
         param1.filters = [_loc3_];
         if(param2 != 0)
         {
            _loc1_ = new Color();
            _loc1_.brightness = -(param2 / 100);
            param1.transform.colorTransform = _loc1_;
         }
      }

      private static function getCharStore() : SharedObject
      {
         try
         {
            return SharedObject.getLocal("AQWChars","/",true);
         }
         catch(e:Error)
         {
         }
         try
         {
            return SharedObject.getLocal("AQWChars","/");
         }
         catch(e:Error)
         {
         }
         return null;
      }

      public function loadAccountCreation(param1:String) : *
      {
         this.mcAccount.removeChildAt(0);
         var _loc1_:Loader = new AirLoader();
         trace("newchar " + Game.serverFilePath + param1);
         _loc1_.load(new URLRequest(Game.serverFilePath + param1),new LoaderContext(false,new ApplicationDomain(null)));
         this.mcAccount.addChild(_loc1_);
      }

      public function onCSComplete(param1:Event) : void
      {
         trace("Character select loaded");
         if(param1 == null || param1.currentTarget == null)
         {
            return;
         }
         this.mcCharSelect = param1.currentTarget.content as MovieClip;
         if(this.mcCharSelect != null)
         {
            this.addChildAt(this.mcCharSelect,1);
         }
         if(this.csLoader != null && this.csLoader.contentLoaderInfo != null)
         {
            this.csLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onCSComplete);
            this.csLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.onCSProgress);
            this.csLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onCSError);
         }
         if(this.loader != null && this.loader.parent != null)
         {
            this.loader.parent.removeChild(this.loader);
            this.loader = null;
         }
      }

      public function onCSProgress(param1:ProgressEvent) : void
      {
         var _loc1_:int = 0;
         if(param1 == null)
         {
            return;
         }
         this.csbLoaded = param1.bytesLoaded;
         this.csbTotal = param1.bytesTotal;
         if(this.csbTotal > 0 && this.loader != null)
         {
            _loc1_ = int(this.csbLoaded / this.csbTotal * 100);
            if(this.loader.mcPct != null && this.loader.mcPct.hasOwnProperty("text"))
            {
               this.loader.mcPct.text = _loc1_ + "%";
            }
         }
      }

      public function onCSError(param1:IOErrorEvent) : void
      {
         trace("Charselect load failed: " + (param1 != null ? String(param1) : "unknown error"));
         if(this.csLoader != null && this.csLoader.contentLoaderInfo != null)
         {
            this.csLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onCSComplete);
            this.csLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.onCSProgress);
            this.csLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onCSError);
         }
         if(this.loader != null && this.loader.parent != null)
         {
            this.loader.parent.removeChild(this.loader);
            this.loader = null;
         }
         gotoAndPlay("Login");
      }

      public function vswf(param1:String) : String
      {
         return vurl(param1);
      }

      public function monsterTreeWrite(param1:int, param2:Object, param3:* = null) : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:* = undefined;
         var _loc4_:Avatar = null;
         var _loc5_:Avatar = null;
         var _loc6_:Avatar = null;
         var _loc7_:Avatar = null;
         var _loc8_:MovieClip = null;
         var _loc9_:int = 0;
         var _loc10_:String = null;
         var _loc11_:int = 0;
         var _loc12_:Object = null;
         var _loc13_:String = null;
         var _loc14_:Object = null;
         var _loc15_:* = undefined;
         var _loc16_:* = undefined;
         var _loc17_:int = 0;
         var _loc18_:String = "";
         var _loc19_:Object = {};
         var _loc20_:Object = this.world.monTree[param1];
         if(_loc20_ != null)
         {
            _loc9_ = -1;
            if(_loc20_ != null && _loc20_.intState != null)
            {
               _loc9_ = int(_loc20_.intState);
            }
            for(_loc10_ in param2)
            {
               _loc2_ = _loc10_;
               _loc3_ = param2[_loc10_];
               _loc19_[_loc2_] = _loc3_;
               if(_loc2_.toLowerCase().indexOf("int") > -1)
               {
                  _loc3_ = Number(_loc3_);
               }
               if(_loc2_ == "react")
               {
                  _loc3_ = _loc3_.split(",");
                  _loc11_ = 0;
                  while(_loc11_ < _loc3_.length)
                  {
                     _loc3_[_loc11_] = Number(_loc3_[_loc11_]);
                     _loc11_++;
                  }
               }
               _loc20_[_loc2_] = _loc3_;
            }
            if(_loc19_.intState != null && Number(_loc19_.intState) != 2)
            {
               this.world.hudAuraClear(_loc20_,false);
            }
            _loc18_ = "";
            for(_loc18_ in _loc19_)
            {
               _loc2_ = _loc18_;
               _loc3_ = _loc19_[_loc18_];
               if(_loc2_.toLowerCase().indexOf("evt:") < 0)
               {
                  _loc6_ = this.world.getMonster(param1);
                  if(_loc6_ != null)
                  {
                     if(_loc2_.toLowerCase().indexOf("hp") > -1)
                     {
                        if(_loc6_ != null && _loc6_.objData != null)
                        {
                           _loc3_ = Number(_loc3_);
                           _loc6_.objData[_loc18_] = _loc3_;
                           if(this.world.myAvatar.target == _loc6_)
                           {
                              this.world.updatePortrait(_loc6_);
                           }
                           if(this.world.objLock != null && (_loc2_ == "intHP" && _loc3_ <= 0))
                           {
                              ++this.world.intKillCount;
                              this.world.updatePadNames();
                           }
                           if(_loc6_.objData != null && _loc6_.objData.strFrame != undefined)
                           {
                              if(_loc6_.objData.strFrame == this.world.strFrame)
                              {
                                 if(_loc3_ <= 0)
                                 {
                                    if(Boolean(this.bAnalyzer) && (Boolean(param3) || Boolean(_loc19_["targets"] != null && _loc19_["targets"].length > 0)))
                                    {
                                       if(this.bAnalyzer.isRunning())
                                       {
                                          for each(_loc13_ in param3 ? param3 : _loc19_["targets"])
                                          {
                                             if(this.world.myAvatar.objData.strUsername.toLowerCase() == _loc13_.toLowerCase())
                                             {
                                                this.bAnalyzer.addKill();
                                             }
                                          }
                                       }
                                    }
                                    if(Boolean(this.litePreference.data.bDisSelfMAnim) && Boolean(this.world.myAvatar.target != null) && this.world.myAvatar.target.dataLeaf.intState == 0)
                                    {
                                       this.world.cancelTarget();
                                    }
                                    _loc6_.pMC.stopWalking();
                                    this.world.removeAuraFX(_loc6_.pMC,"all");
                                    _loc6_.pMC.die();
                                    for each(_loc12_ in _loc20_.auras)
                                    {
                                       _loc12_.casterType = null;
                                       _loc12_.casterId = null;
                                    }
                                    _loc20_.auras = [];
                                    _loc20_.targets = {};
                                    _loc6_.target = null;
                                    if("eventTrigger" in MovieClip(this.world.map))
                                    {
                                       this.world.map.eventTrigger({
                                          "cmd":"monDeath",
                                          "args":param1,
                                          "targets":param2.targets
                                       });
                                    }
                                    if(this.world.myAvatar.dataLeaf.targets[_loc6_.objData.MonMapID] != null)
                                    {
                                       delete this.world.myAvatar.dataLeaf.targets[_loc6_.objData.MonMapID];
                                    }
                                    if(this.world.strMapName == "trickortreat" && this.world.strFrame == "Enter")
                                    {
                                       this.world.TrickOrTreatMonsterDead = true;
                                       this.world.loadPlayerNPC();
                                    }
                                    if(this.world.strMapName == "caroling" && this.world.strFrame == "Enter")
                                    {
                                       this.world.CarolingMonsterKillCount += 1;
                                       if(this.world.CarolingMonsterKillCount >= 5)
                                       {
                                          this.world.setTarget(null);
                                          this.world.loadPlayerNPC();
                                       }
                                    }
                                 }
                              }
                           }
                        }
                     }
                     if(_loc2_.toLowerCase().indexOf("state") > -1)
                     {
                        if(_loc6_ != null && _loc6_.objData != null)
                        {
                           _loc3_ = Number(_loc3_);
                           _loc6_.objData[_loc18_] = _loc3_;
                           if(_loc3_ != 2)
                           {
                              for each(_loc14_ in _loc6_.dataLeaf.auras)
                              {
                                 _loc14_.casterType = null;
                                 _loc14_.casterId = null;
                              }
                              _loc6_.dataLeaf.auras = [];
                           }
                           if(_loc6_.objData.strFrame != null && _loc6_.objData.strFrame == this.world.strFrame)
                           {
                              if(_loc3_ == 1 && _loc6_.pMC != null && (_loc6_.pMC.x != _loc6_.pMC.ox || _loc6_.pMC.y != _loc6_.pMC.oy))
                              {
                                 _loc6_.pMC.walkTo(_loc6_.pMC.ox,_loc6_.pMC.oy,this.world.WALKSPEED);
                              }
                           }
                           if(_loc3_ != 2)
                           {
                              _loc20_.targets = {};
                           }
                        }
                     }
                     if(_loc2_.toLowerCase().indexOf("dx") > -1)
                     {
                        _loc3_ = Number(_loc3_);
                        if(_loc6_.objData != null && _loc6_.objData.strFrame != null && _loc6_.objData.strFrame == this.world.strFrame)
                        {
                           _loc15_ = int(this.world.monTree[param1].dx);
                           _loc16_ = int(this.world.monTree[param1].dy);
                           _loc6_.pMC.walkTo(_loc15_,_loc16_,this.world.WALKSPEED);
                        }
                     }
                  }
               }
            }
         }
      }

      public function userTreeWrite(param1:String, param2:Object) : void
      {
         var uoLeafSet:Object;
         var uoLeaf:Object;
         var typ:String = null;
         var nam:String = null;
         var val:* = undefined;
         var monAvt:Avatar = null;
         var avtAvt:Avatar = null;
         var Mon:Avatar = null;
         var avt:Avatar = null;
         var pMC:MovieClip = null;
         var s:String = null;
         var intStateO:int = 0;
         var healIcon:MovieClip = null;
         var su:* = undefined;
         var healIcon2:MovieClip = null;
         var uoName:String = param1;
         var uoLeafO:Object = param2;
         var i:int = 0;
         var prop:String = "";
         var updated:Object = {};
         if(uoName == null || uoLeafO == null)
         {
            return;
         }
         uoLeafSet = {};
         uoLeaf = this.world.uoTree[uoName.toLowerCase()];
         avt = this.world.getAvatarByUserName(uoName);
         for(s in uoLeafO)
         {
            nam = s;
            val = uoLeafO[s];
            if(nam.toLowerCase().indexOf("int") > -1 || nam.toLowerCase() == "tx" || nam.toLowerCase() == "ty" || nam.toLowerCase() == "sp" || nam.toLowerCase() == "pvpTeam")
            {
               val = int(val);
            }
            if(this.sfcSocial && uoLeaf != null && this.world.myAvatar != null && this.world.myAvatar.dataLeaf != null && nam.toLowerCase() == "inthp" && uoName.toLowerCase() != this.sfc.myUserName && uoLeaf.strFrame == this.world.myAvatar.dataLeaf.strFrame && (!this.world.bPvP || uoLeaf.pvpTeam == this.world.myAvatar.dataLeaf.pvpTeam) && val > 0 && this.world.getFirstHeal() != null)
            {
               if(val <= uoLeaf.intHP && (uoLeaf.intHP - val >= uoLeaf.intHPMax * 0.15 || val <= uoLeaf.intHPMax * 0.5))
               {
                  try
                  {
                     avt.pMC.showHealIcon();
                  }
                  catch(e:Error)
                  {
                     trace("[Combat] ERR showHealIcon: " + e.message);
                  }
               }
               if(val > Math.round(uoLeaf.intHPMax * 0.5))
               {
                  try
                  {
                     healIcon = avt.pMC.getChildByName("HealIconMC") as MovieClip;
                     if(healIcon != null)
                     {
                        healIcon.fClose();
                     }
                  }
                  catch(e:Error)
                  {
                     trace("[Combat] ERR hideHealIcon: " + e.message);
                  }
               }
            }
            if(nam.toLowerCase() == "afk")
            {
               val = val == "true";
            }
            updated[nam] = val;
            uoLeafSet[nam] = val;
         }
         intStateO = -1;
         if(this.world.uoTree[uoName.toLowerCase()] != null)
         {
            intStateO = int(this.world.uoTree[uoName.toLowerCase()].intState);
         }
         this.world.uoTreeLeafSet(uoName,uoLeafSet);
         uoLeaf = this.world.uoTree[uoName.toLowerCase()];
         if(this.world.isPartyMember(uoName))
         {
            this.world.updatePartyFrame({"unm":uoLeaf.strUsername});
         }
         prop = "";
         for(prop in updated)
         {
            val = updated[prop];
            if(prop.toLowerCase() == "strframe")
            {
               this.world.manageAreaUser(uoName,"+");
               su = this.world.getUserByName(uoName);
               pMC = su != null ? this.world.getMCByUserID(su.getId()) : null;
               if(updated[prop] != this.world.strFrame)
               {
                  if(pMC != null && pMC.stage != null)
                  {
                     if(this.world.bPvP)
                     {
                        pMC.px = updated.px;
                        pMC.py = updated.py;
                        pMC.mvtd = updated.mvtd;
                        pMC.mvts = updated.mvts;
                        pMC.sp = updated.sp;
                        pMC.walkTo(updated.tx,updated.ty,updated.sp);
                     }
                     if(pMC.pAV != null)
                     {
                        pMC.pAV.hideMC();
                     }
                     if(this.world.myAvatar != null && pMC.pAV == this.world.myAvatar.target)
                     {
                        this.world.setTarget(null);
                     }
                  }
               }
               else if(updated.sp != null)
               {
                  if(pMC != null)
                  {
                     pMC.walkTo(updated.tx,updated.ty,updated.sp);
                  }
               }
               else
               {
                  this.world.objectByID(uoLeaf.entID);
               }
            }
            if(prop.toLowerCase() == "sp")
            {
               if(updated.strFrame == this.world.strFrame)
               {
               }
            }
            if(avt != null)
            {
               if(prop.toLowerCase().indexOf("inthp") > -1 || prop.toLowerCase().indexOf("intmp") > -1)
               {
                  val = Number(val);
                  if(avt.objData != null)
                  {
                     avt.objData[prop] = val;
                  }
                  if(avt.isMyAvatar || this.world.myAvatar.target == avt)
                  {
                     this.world.updatePortrait(avt);
                  }
                  if(avt.isMyAvatar)
                  {
                     this.world.updateActBar();
                  }
                  if(avt.pMC != null && this.world.showHPBar)
                  {
                     avt.pMC.updateHPBar();
                  }
               }
               if(avt.isMyAvatar)
               {
                  if(prop.toLowerCase().indexOf("intsp") > -1)
                  {
                     val = Number(val);
                     if(avt.objData != null)
                     {
                        avt.objData[prop] = val;
                     }
                     if(avt.isMyAvatar || this.world.myAvatar.target == avt)
                     {
                        this.world.updatePortrait(avt);
                     }
                     if(avt.isMyAvatar)
                     {
                        this.world.updateActBar();
                     }
                     if(avt.pMC != null && this.world.showHPBar)
                     {
                        avt.pMC.updateHPBar();
                     }
                  }
               }
               if(prop.toLowerCase().indexOf("intlevel") > -1)
               {
                  val = Number(val);
                  if(avt.objData != null)
                  {
                     avt.objData[prop] = val;
                     if(!avt.isMyAvatar && this.world.myAvatar.target == avt)
                     {
                        this.showPortraitBox(avt,this.ui.mcPortraitTarget);
                     }
                  }
               }
               if(prop.toLowerCase().indexOf("intstate") > -1)
               {
                  val = int(val);
                  if(avt.objData != null && avt.pMC != null && this.world.uoTree[uoName.toLowerCase()].strFrame == this.world.strFrame)
                  {
                     if(val == 1 && intStateO == 0)
                     {
                        if(avt.pMC.mcChar != null)
                        {
                           avt.pMC.mcChar.gotoAndStop("Idle");
                        }
                        avt.pMC.scale(this.world.SCALE);
                     }
                     if(val == 1 && intStateO == 2)
                     {
                        if("eventTrigger" in MovieClip(this.world.map))
                        {
                        }
                     }
                  }
                  if(avt.objData != null)
                  {
                     avt.objData[prop] = val;
                  }
                  if(val == 0 && this.world.uoTree[uoName.toLowerCase()].strFrame == this.world.strFrame && avt.pMC != null)
                  {
                     avt.pMC.stopWalking();
                     avt.pMC.mcChar.gotoAndPlay("Feign");
                     this.world.removeAuraFX(avt.pMC,"all");
                     healIcon2 = avt.pMC.getChildByName("HealIconMC") as MovieClip;
                     if(healIcon2 != null)
                     {
                        healIcon2.fClose();
                     }
                     if(avt.isMyAvatar)
                     {
                        this.world.cancelAutoAttack();
                        this.world.actionReady = false;
                        this.world.bitWalk = false;
                        if(this.world.map != null)
                        {
                           this.world.map.transform.colorTransform = this.world.deathCT;
                        }
                        this.world.CHARS.transform.colorTransform = this.world.deathCT;
                        avt.pMC.transform.colorTransform = this.world.defaultCT;
                        this.world.showResCounter();
                     }
                  }
                  if(val != 2)
                  {
                     uoLeaf.targets = {};
                  }
               }
               if(prop.toLowerCase().indexOf("afk") > -1)
               {
                  if(avt.pMC != null)
                  {
                     avt.pMC.updateName();
                  }
               }
               if(prop == "showCloak")
               {
                  if(avt.pMC != null)
                  {
                     avt.pMC.setCloakVisibility(val);
                  }
               }
               if(prop == "showHelm")
               {
                  if(avt.pMC != null)
                  {
                     avt.pMC.setHelmVisibility(val);
                  }
               }
               if(prop.toLowerCase().indexOf("cast") > -1)
               {
                  if(avt.pMC != null)
                  {
                     if(val != null && val.t > -1)
                     {
                        avt.pMC.stopWalking();
                        avt.pMC.queueAnim("Use");
                     }
                     else
                     {
                        avt.pMC.endAction();
                        if(avt == this.world.myAvatar)
                        {
                           this.ui.mcCastBar.fClose();
                        }
                     }
                  }
               }
            }
         }
      }

      public function doAnim(param1:Object, param2:Boolean = false, param3:* = null) : void
      {
         var anims:Array = null;
         var animIndex:uint = 0;
         var animStr:String = null;
         var pMC:MovieClip = null;
         var cLeaf:Object = null;
         var tLeaf:Object = null;
         var tAvt:Avatar = null;
         var cAvt:Avatar = null;
         var aura:Object = null;
         var sCat:String = null;
         var buffer:* = undefined;
         var xBuffer:* = undefined;
         var yBuffer:* = undefined;
         var animString:String = null;
         var anim:Object = param1;
         var isProc:Boolean = param2;
         var dur:* = param3;
         var i:int = 0;
         var cTyp:String = "";
         var cID:int = -1;
         var tTyp:String = "";
         var tID:int = -1;
         var tAvts:Array = [];
         var tInfA:Array = [];
         var strF:String = "";
         cAvt = null;
         tAvt = null;
         var cReg:Point = new Point(0,0);
         var tReg:Point = new Point(0,0);
         if(anim.cInf != null && anim.tInf != null)
         {
            cTyp = String(anim.cInf.split(":")[0]);
            cID = int(anim.cInf.split(":")[1]);
            switch(cTyp)
            {
               case "p":
                  cAvt = this.world.getAvatarByUserID(cID);
                  cLeaf = this.world.getUoLeafById(cID);
                  break;
               case "m":
                  cAvt = this.world.getMonster(cID);
                  cLeaf = this.world.monTree[cID];
                  if(anim.msg != null)
                  {
                     if(anim.msg.indexOf("<mon>") > -1)
                     {
                        anim.msg = anim.msg.split("<mon>").join(cAvt.objData.strMonName);
                     }
                     this.addUpdate(anim.msg);
                  }
            }
            tInfA = anim.tInf.split(",");
            i = 0;
            while(i < tInfA.length)
            {
               tTyp = String(tInfA[i].split(":")[0]);
               tID = int(tInfA[i].split(":")[1]);
               switch(tTyp)
               {
                  case "p":
                     tAvt = this.world.getAvatarByUserID(tID);
                     tLeaf = this.world.getUoLeafById(tID);
                     break;
                  case "m":
                     tAvt = this.world.getMonster(tID);
                     tLeaf = this.world.monTree[tID];
               }
               tAvts.push(tAvt);
               i++;
            }
            if(tAvts[0] != null)
            {
               tAvt = tAvts[0];
            }
            if(tAvt != null)
            {
               tLeaf = tAvt.dataLeaf;
            }
            if(cAvt != null && cAvt.pMC != null && tAvt != null && tAvt.pMC != null && cLeaf != null && tLeaf != null)
            {
               aura = {};
               for each(aura in cLeaf.auras)
               {
                  try
                  {
                     sCat = this.world.auraCatOf(aura);
                     if(sCat == "stun" || sCat == "stone" || sCat == "paralyze" || sCat == "disable" || sCat == "disabled")
                     {
                        return;
                     }
                  }
                  catch(e:Error)
                  {
                     trace("[Combat] ERR doAnim: " + e.message);
                  }
               }
               animStr = anim.animStr;
               switch(cTyp)
               {
                  case "p":
                     if(cAvt.objData != null)
                     {
                        if(cAvt != this.world.myAvatar)
                        {
                           cAvt.target = tAvt;
                        }
                        strF = String(cLeaf.strFrame);
                        if(strF != null && strF == this.world.strFrame && cLeaf.intState > 0)
                        {
                           if(cAvt != tAvt)
                           {
                              if(tAvt.pMC.x - cAvt.pMC.x >= 0)
                              {
                                 cAvt.pMC.turn("right");
                              }
                              else
                              {
                                 cAvt.pMC.turn("left");
                              }
                           }
                           cAvt.pMC.queueSpFX({
                              "strl":anim.strl,
                              "fx":anim.fx,
                              "avts":tAvts
                           });
                           if(!isNaN(dur))
                           {
                              cAvt.pMC.spellDur = dur;
                           }
                           if(animStr != null)
                           {
                              if(animStr.indexOf(",") > -1)
                              {
                                 animStr = animStr.split(",")[Math.round(Math.random() * (animStr.split(",").length - 1))];
                              }
                              if(animStr != "Thrash" || cAvt.pMC.mcChar.currentLabel != "Thrash")
                              {
                                 cAvt.pMC.queueAnim(animStr);
                              }
                              if(isProc && Boolean(cAvt.pMC.mcChar.weapon.mcWeapon.isProc))
                              {
                                 cAvt.pMC.mcChar.weapon.mcWeapon.gotoAndPlay("Proc");
                              }
                           }
                        }
                     }
                     break;
                  case "m":
                     if(cAvt.objData != null)
                     {
                        if(cAvt != this.world.myAvatar)
                        {
                           cAvt.target = tAvt;
                        }
                        strF = String(cLeaf.strFrame);
                        cReg = cAvt.pMC.mcChar.localToGlobal(new Point(0,0));
                        tReg = tAvt.pMC.mcChar.localToGlobal(new Point(0,0));
                        cReg = this.world.CHARS.globalToLocal(cReg);
                        tReg = this.world.CHARS.globalToLocal(tReg);
                        if(strF != null && strF == this.world.strFrame && cLeaf.intState > 0)
                        {
                           if(cAvt != tAvt)
                           {
                              if(tReg.x - cReg.x >= 0)
                              {
                                 cAvt.pMC.turn("right");
                              }
                              else
                              {
                                 cAvt.pMC.turn("left");
                              }
                           }
                           if(anim.fx != "p" && anim.fx != "w" && anim.fx != "" && (Math.abs(cReg.x - tReg.x) * this.world.SCALE > 160 || Math.abs(cReg.y - tReg.y) * this.world.SCALE > 15))
                           {
                              buffer = int(110 + Math.random() * 50);
                              xBuffer = tReg.x - cReg.x >= 0 ? -buffer : buffer;
                              xBuffer = int(xBuffer * this.world.SCALE);
                              if(tReg.x + xBuffer < 0 || tReg.x + xBuffer > 960)
                              {
                                 xBuffer *= -1;
                              }
                              buffer = int(Math.random() * 30 - 15);
                              yBuffer = tReg.y - cReg.y >= 0 ? -buffer : buffer;
                              yBuffer = int(yBuffer * this.world.SCALE);
                              cAvt.pMC.walkTo(tReg.x + xBuffer,tReg.y + yBuffer,32);
                           }
                           if(cAvt.pMC.spFX != null)
                           {
                              cAvt.pMC.spFX.avt = cAvt.target;
                           }
                           cReg = cAvt.pMC.mcChar.localToGlobal(new Point(0,0));
                           tReg = tAvt.pMC.mcChar.localToGlobal(new Point(0,0));
                           if(cAvt != tAvt)
                           {
                              if(tReg.x - cReg.x >= 0)
                              {
                                 cAvt.pMC.turn("right");
                              }
                              else
                              {
                                 cAvt.pMC.turn("left");
                              }
                           }
                           if(this.litePreference.data.bDisMonAnim)
                           {
                              return;
                           }
                           if(animStr.length > 1)
                           {
                              if(animStr.indexOf(",") > -1)
                              {
                                 if(this.world.objExtra["bChar"] == 1)
                                 {
                                    animString = cAvt.pMC.Animation;
                                    MovieClip(cAvt.pMC.getChildAt(1)).gotoAndPlay(animString);
                                 }
                                 else
                                 {
                                    anims = animStr.split(",");
                                    animIndex = Math.round(Math.random() * (anims.length - 1));
                                    MovieClip(cAvt.pMC.getChildAt(1)).gotoAndPlay(anims[animIndex]);
                                 }
                              }
                              else if(this.world.objExtra["bChar"] == 1)
                              {
                                 animString = cAvt.pMC.Animation;
                                 MovieClip(cAvt.pMC.getChildAt(1)).gotoAndPlay(animString);
                              }
                              else
                              {
                                 MovieClip(cAvt.pMC.getChildAt(1)).gotoAndPlay(animStr);
                              }
                           }
                        }
                     }
               }
            }
         }
      }

      public function key_StageLogin(param1:KeyboardEvent) : *
      {
         if(param1.target == stage)
         {
            if(param1.keyCode == Keyboard.ENTER)
            {
               stage.focus = this.mcLogin.ni;
            }
         }
      }

      public function hasBankItem() : Boolean
      {
         var _loc1_:* = undefined;
         for each(_loc1_ in this.world.myAvatar.items)
         {
            if(_loc1_.sMeta != null && _loc1_.sMeta.length > 0 && _loc1_.sMeta.toLowerCase().indexOf("bank") > -1)
            {
               return true;
            }
         }
         return false;
      }

      public function key_StageGame(param1:KeyboardEvent) : *
      {
         var _loc1_:Array = null;
         var _loc2_:String = null;
         var _loc3_:uint = 0;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         var _loc6_:int = 0;
         if(GameKeys.firing)
         {
            return;
         }
         if(Boolean(param1.target) && param1.target.name == "btnSetKeybindActive")
         {
            return;
         }
         if(!(param1.target is TextField || param1.currentTarget is TextField))
         {
            if(param1.keyCode == Keyboard.ENTER || String.fromCharCode(param1.charCode) == "/")
            {
               this.chatF.openMsgEntry();
            }
            if(this.isNumpadKey(param1.keyCode))
            {
               param1.keyCode -= 48;
            }
            if(param1.keyCode == this.litePreference.data.keys["Target Random Monster"])
            {
               if(!this.isInputFocused())
               {
                  _loc1_ = this.world.getMonstersByCell(this.world.strFrame);
                  _loc2_ = this.world.strFrame;
                  if(_loc1_.length > 0)
                  {
                     _loc3_ = Math.round(Math.random() * (_loc1_.length - 1));
                     while(_loc1_.length > 1 && !_loc1_[_loc3_] && !_loc1_[_loc3_].pMC && _loc1_[_loc3_].dataLeaf.intState == 0 && this.world.myAvatar.target == _loc1_[_loc3_])
                     {
                        if(this.world.strFrame != _loc2_)
                        {
                           break;
                        }
                        _loc3_ = Math.round(Math.random() * (_loc1_.length - 1));
                     }
                     if(this.world.strFrame == _loc2_)
                     {
                        if(Boolean(_loc1_[_loc3_] && _loc1_[_loc3_].pMC) && Boolean(_loc1_[_loc3_].dataLeaf.strFrame == this.world.strFrame) && _loc1_[_loc3_].dataLeaf.intState != 0)
                        {
                           this.world.setTarget(_loc1_[_loc3_]);
                        }
                     }
                  }
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Travel Menu\'s Travel"])
            {
               if(!this.isInputFocused())
               {
                  if(this.ui.getChildByName("mcTravelMenu"))
                  {
                     (this.ui.getChildByName("mcTravelMenu") as MovieClip).dispatchTravel();
                  }
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Camera Tool"])
            {
               if(!this.isInputFocused())
               {
                  if(Boolean(stage.getChildByName("worldCameraMC")) || Boolean(getChildByName("cameraToolMC")))
                  {
                     return;
                  }
                  _loc4_ = new cameraTool(this);
                  _loc4_.name = "cameraToolMC";
                  _loc4_.x = -7;
                  addChild(_loc4_);
                  this.world.visible = false;
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["World Camera"])
            {
               if(!this.isInputFocused())
               {
                  if(Boolean(stage.getChildByName("worldCameraMC")) || Boolean(getChildByName("cameraToolMC")))
                  {
                     if(stage.getChildByName("worldCameraMC"))
                     {
                        MovieClip(stage.getChildByName("worldCameraMC")).dispatchExit();
                     }
                     return;
                  }
                  _loc5_ = new worldCamera(this);
                  _loc5_.name = "worldCameraMC";
                  stage.addChild(_loc5_);
               }
            }
            if(String.fromCharCode(param1.charCode) == ">")
            {
               if(!this.isInputFocused())
               {
                  if(this.chatF.pmSourceA[0] != null && this.chatF.pmSourceA[0].length >= 1)
                  {
                     this.chatF.openPMsg(this.chatF.pmSourceA[0]);
                     if(this.intChatMode)
                     {
                        this.ui.mcInterface.ncText.text = "> ";
                     }
                     else
                     {
                        this.ui.mcInterface.te.text = "> ";
                     }
                  }
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Inventory"])
            {
               if(!this.isInputFocused())
               {
                  this.ui.mcInterface.mcMenu.toggleInventory();
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Bank"] && (this.world.myAvatar.isStaff() || this.hasBankItem()))
            {
               if(!this.isInputFocused())
               {
                  this.world.toggleBank();
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Quest Log"])
            {
               if(stage.focus != this.ui.mcInterface.te && stage.focus != this.ui.mcInterface.ncText && stage.focus != this.ui.mcInterface.ncText)
               {
                  this.world.toggleQuestLog();
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Friends List"])
            {
               if(!this.isInputFocused())
               {
                  if(this.ui.mcOFrame.isOpen)
                  {
                     this.ui.mcOFrame.fClose();
                  }
                  else
                  {
                     this.world.showFriendsList();
                  }
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Character Panel"])
            {
               if(!this.isInputFocused())
               {
                  this.toggleCharpanel("overview");
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Player HP Bar"])
            {
               if(!this.isInputFocused())
               {
                  this.world.toggleHPBar();
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Options"])
            {
               if(!this.isInputFocused())
               {
                  if(this.ui.mcPopup.currentLabel == "Option")
                  {
                     this.ui.mcPopup.onClose();
                  }
                  else
                  {
                     this.ui.mcPopup.fOpen("Option");
                  }
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Area List"])
            {
               if(!this.isInputFocused())
               {
                  if(!this.ui.mcOFrame.isOpen)
                  {
                     this.world.sendWhoRequest();
                  }
                  else
                  {
                     this.ui.mcOFrame.fClose();
                  }
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Jump"])
            {
               if(stage.focus != this.ui.mcInterface.te && stage.focus != this.ui.mcInterface.ncText)
               {
                  this.world.myAvatar.pMC.mcChar.gotoAndPlay("Jump");
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Rest"])
            {
               if(param1.target != this.ui.mcInterface.te && param1.target != this.ui.mcInterface.ncText)
               {
                  this.world.rest();
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Hide Monsters"])
            {
               if(param1.target != this.ui.mcInterface.te && param1.target != this.ui.mcInterface.ncText)
               {
                  this.world.toggleMonsters();
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Hide Players"])
            {
               if(param1.target != this.ui.mcInterface.te && param1.target != this.ui.mcInterface.ncText)
               {
                  optionHandler.cmd(MovieClip(this),"Hide Players");
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Cancel Target"])
            {
               if(param1.target != this.ui.mcInterface.te && param1.target != this.ui.mcInterface.ncText)
               {
                  if(this.cancelTargetTimer.running)
                  {
                     return;
                  }
                  if(this.world.autoActionTimer != null && this.world.autoActionTimer.running)
                  {
                     this.world.cancelAutoAttack();
                     this.world.myAvatar.pMC.mcChar.gotoAndStop("Idle");
                  }
                  if(this.world.myAvatar.target != null)
                  {
                     this.world.setTarget(null);
                  }
                  if(!this.cancelTargetTimer.hasEventListener(TimerEvent.TIMER))
                  {
                     this.cancelTargetTimer.addEventListener(TimerEvent.TIMER,this.hasCanceledAlready,false,0,true);
                  }
                  _loc6_ = int(parseInt(this.world.getActionByRef(String(this.world.actionMap[0])).cd));
                  this.cancelTargetTimer.delay = _loc6_ < 2000 ? 2000 : _loc6_;
                  this.cancelTargetTimer.start();
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Hide UI"])
            {
               if(param1.target != this.ui.mcInterface.te && param1.target != this.ui.mcInterface.ncText)
               {
                  optionHandler.cmd(MovieClip(this),"Hide UI");
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Battle Analyzer"])
            {
               if(param1.target != this.ui.mcInterface.te && param1.target != this.ui.mcInterface.ncText)
               {
                  optionHandler.cmd(MovieClip(this),"Battle Analyzer");
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Decline All Drops"])
            {
               if(param1.target != this.ui.mcInterface.te && param1.target != this.ui.mcInterface.ncText)
               {
                  optionHandler.cmd(MovieClip(this),"Decline All Drops");
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Stats Overview"])
            {
               if(param1.target != this.ui.mcInterface.te && param1.target != this.ui.mcInterface.ncText)
               {
                  this.toggleStatspanel();
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Battle Analyzer Toggle"])
            {
               if(param1.target != this.ui.mcInterface.te && param1.target != this.ui.mcInterface.ncText)
               {
                  if(this.bAnalyzer)
                  {
                     this.bAnalyzer.toggle();
                  }
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Custom Drops UI"])
            {
               if(param1.target != this.ui.mcInterface.te && param1.target != this.ui.mcInterface.ncText)
               {
                  if(Boolean(this.ui.mcPortrait.iconDrops) && Boolean(this.ui.mcPortrait.iconDrops.visible))
                  {
                     this.ui.mcPortrait.iconDrops.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  }
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["@ Debugger - Cell Menu"])
            {
               if(Boolean(this.ui && this.ui.mcInterface && this.ui.mcInterface.te) && Boolean(param1.target != this.ui.mcInterface.te) && param1.target != this.ui.mcInterface.ncText)
               {
                  if(this.cMenuUI)
                  {
                     this.cMenuUI.toggle();
                  }
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["@ Debugger - Packet Logger"])
            {
               if(Boolean(this.ui && this.ui.mcInterface && this.ui.mcInterface.te) && Boolean(param1.target != this.ui.mcInterface.te) && param1.target != this.ui.mcInterface.ncText)
               {
                  if(Boolean(this.pLoggerUI) && Boolean(this.litePreference.data.dOptions["debugPacket"]))
                  {
                     this.pLoggerUI.visible = !this.pLoggerUI.visible;
                     this.pLoggerUI.toggle();
                  }
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Dash"])
            {
               if(Boolean(this.ui && this.ui.mcInterface && this.ui.mcInterface.te) && Boolean(param1.target != this.ui.mcInterface.te) && param1.target != this.ui.mcInterface.ncText)
               {
                  if(!this.world.uoTree[this.world.myAvatar.pnm].sta.$dsh)
                  {
                     this.world.uoTree[this.world.myAvatar.pnm].sta.$dsh = 100;
                  }
                  if(this.world.myAvatar.dataLeaf.intSP >= this.world.uoTree[this.world.myAvatar.pnm].sta.$dsh)
                  {
                     this.pDash = true;
                  }
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Outfits"])
            {
               if(Boolean(this.ui && this.ui.mcInterface && this.ui.mcInterface.te) && Boolean(param1.target != this.ui.mcInterface.te) && param1.target != this.ui.mcInterface.ncText)
               {
                  if(!this.getInterface("outfitSets"))
                  {
                     this.toggleOutfits();
                  }
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Friendships UI"])
            {
               if(Boolean(this.ui && this.ui.mcInterface && this.ui.mcInterface.te) && Boolean(param1.target != this.ui.mcInterface.te) && param1.target != this.ui.mcInterface.ncText)
               {
                  if(!this.getInterface("Friendships UI"))
                  {
                     this.showFriendshipUI();
                  }
               }
            }
         }
      }

      private function hasCanceledAlready(param1:TimerEvent) : void
      {
         this.cancelTargetTimer.removeEventListener(TimerEvent.TIMER,this.hasCanceledAlready);
         stage.focus = null;
      }

      public function key_TextLogin(param1:KeyboardEvent) : *
      {
         if(param1.target != stage)
         {
            if(param1.keyCode == Keyboard.ENTER)
            {
               this.onLoginClick(null);
            }
         }
      }

      public function key_ChatEntry(param1:KeyboardEvent) : *
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.chatF.submitMsg(this.intChatMode ? this.ui.mcInterface.ncText.text : this.ui.mcInterface.te.text,this.chatF.chn.cur.typ,this.chatF.pmNm);
         }
         if(param1.keyCode == Keyboard.ESCAPE)
         {
            this.chatF.closeMsgEntry();
         }
      }

      public function talk(param1:*) : *
      {
         if(param1.accept)
         {
            this.chatF.submitMsg(param1.emote1,"emote",this.sfc.myUserName);
         }
         else
         {
            this.chatF.submitMsg(param1.emote2,"emote",this.sfc.myUserName);
         }
      }

      public function isNumpadKey(param1:uint) : Boolean
      {
         return param1 >= 96 && param1 <= 105;
      }

      public function key_actBar(param1:KeyboardEvent) : *
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         var _loc3_:* = undefined;
         if(GameKeys.firing)
         {
            return;
         }
         if(Boolean(param1.target) && param1.target.name == "btnSetKeybindActive")
         {
            return;
         }
         if(!this.isInputFocused())
         {
            if(this.isNumpadKey(param1.keyCode))
            {
               param1.keyCode -= 48;
            }
            switch(param1.keyCode)
            {
               case this.litePreference.data.keys["Auto Attack"]:
                  _loc1_ = 0;
                  if(this.world.actionMap[_loc1_] != null)
                  {
                     _loc3_ = this.world.getActionByRef(String(this.world.actionMap[_loc1_]));
                     if(_loc3_.auto != null && _loc3_.auto == true)
                     {
                        this.world.approachTarget();
                     }
                     else
                     {
                        this.world.testAction(_loc3_);
                     }
                  }
                  return;
               case this.litePreference.data.keys["Skill 1"]:
                  _loc1_ = 1;
                  if(this.world.actionMap[_loc1_] != null)
                  {
                     _loc3_ = this.world.getActionByRef(String(this.world.actionMap[_loc1_]));
                     if(_loc3_.isOK)
                     {
                        this.world.testAction(_loc3_);
                     }
                  }
                  break;
               case this.litePreference.data.keys["Skill 2"]:
                  _loc1_ = 2;
                  if(this.world.actionMap[_loc1_] != null)
                  {
                     _loc3_ = this.world.getActionByRef(String(this.world.actionMap[_loc1_]));
                     if(_loc3_.isOK)
                     {
                        this.world.testAction(_loc3_);
                     }
                  }
                  break;
               case this.litePreference.data.keys["Skill 3"]:
                  _loc1_ = 3;
                  if(this.world.actionMap[_loc1_] != null)
                  {
                     _loc3_ = this.world.getActionByRef(String(this.world.actionMap[_loc1_]));
                     if(_loc3_.isOK)
                     {
                        this.world.testAction(_loc3_);
                     }
                  }
                  break;
               case this.litePreference.data.keys["Skill 4"]:
                  _loc1_ = 4;
                  if(this.world.actionMap[_loc1_] != null)
                  {
                     _loc3_ = this.world.getActionByRef(String(this.world.actionMap[_loc1_]));
                     if(_loc3_.isOK)
                     {
                        this.world.testAction(_loc3_);
                     }
                  }
                  break;
               case this.litePreference.data.keys["Skill 5"]:
                  _loc1_ = 5;
                  if(this.world.actionMap[_loc1_] != null)
                  {
                     _loc3_ = this.world.getActionByRef(String(this.world.actionMap[_loc1_]));
                     if(_loc3_.isOK)
                     {
                        this.world.testAction(_loc3_);
                     }
                  }
            }
         }
      }

      public function isInputFocused() : Boolean
      {
         return stage.focus != null && "text" in stage.focus;
      }

      public function getKeyboardDict() : Dictionary
      {
         var _loc1_:String = null;
         var _loc2_:XML = describeType(Keyboard);
         var _loc3_:XMLList = _loc2_.constant.@name;
         var _loc4_:Dictionary = new Dictionary();
         var _loc5_:int = _loc3_.length();
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc1_ = _loc3_[_loc6_];
            if(_loc3_[_loc6_].indexOf("NUMBER_") > -1 || _loc3_[_loc6_].indexOf("STRING_") > -1 || _loc3_[_loc6_].indexOf("KEYNAME_") > -1)
            {
               _loc1_ = _loc3_[_loc6_].split("_")[1];
            }
            _loc4_[Keyboard[_loc3_[_loc6_]]] = _loc1_;
            _loc6_++;
         }
         return _loc4_;
      }

      public function decHex(param1:*) : *
      {
         return param1.toString(16);
      }

      public function hexDec(param1:*) : *
      {
         return parseInt(param1,16);
      }

      public function modColor(param1:*, param2:*, param3:*) : String
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = "";
         var _loc5_:* = 0;
         while(_loc5_ < 3)
         {
            _loc1_ = this.hexDec(param1.substr(_loc5_ * 2,2));
            _loc2_ = this.hexDec(param2.substr(_loc5_ * 2,2));
            switch(param3)
            {
               case "-":
                  _loc3_ = _loc1_ - _loc2_;
                  if(_loc3_ < 0)
                  {
                     _loc3_ = 0;
                  }
                  _loc3_ = this.decHex(_loc3_);
                  break;
               case "+":
                  _loc3_ = _loc1_ + _loc2_;
                  if(_loc3_ > 255)
                  {
                     _loc3_ = 255;
                  }
                  _loc3_ = this.decHex(_loc3_);
            }
            _loc4_ += String(_loc3_.length < 2 ? "0" + _loc3_ : _loc3_);
            _loc5_++;
         }
         return _loc4_;
      }

      internal function replaceString(param1:String, param2:String, param3:String) : String
      {
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         var _loc3_:String = "";
         while(true)
         {
            _loc1_ = param1.indexOf(param2,_loc1_);
            if(_loc1_ == -1)
            {
               break;
            }
            _loc3_ += param1.substring(_loc2_,_loc1_) + param3;
            _loc2_ = _loc1_ = _loc1_ + param2.length;
         }
         return _loc3_ == "" ? param1 : _loc3_;
      }

      public function stripWhite(param1:String) : String
      {
         param1 = param1.split("\r").join("");
         param1 = param1.split("\t").join("");
         return param1.split(" ").join("");
      }

      public function stripWhiteStrict(param1:String) : String
      {
         param1 = this.stripWhite(param1);
         var _loc1_:int = 0;
         while(_loc1_ < this.chatF.strictComparisonChars.length)
         {
            param1 = param1.split(this.chatF.strictComparisonChars.substr(_loc1_,1)).join("");
            _loc1_++;
         }
         return param1;
      }

      public function stripWhiteStrictB(param1:String) : String
      {
         param1 = this.stripWhite(param1);
         var _loc1_:int = 0;
         while(_loc1_ < this.chatF.strictComparisonCharsB.length)
         {
            param1 = param1.split(this.chatF.strictComparisonCharsB.substr(_loc1_,1)).join("");
            _loc1_++;
         }
         return param1;
      }

      public function stripMarks(param1:String) : String
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.chatF.markChars.length)
         {
            param1 = param1.split(this.chatF.markChars.substr(_loc1_,1)).join("");
            _loc1_++;
         }
         return param1;
      }

      public function stripDuplicateVowels(param1:String) : String
      {
         param1 = param1.replace(this.chatF.regExpA,"a");
         param1 = param1.replace(this.chatF.regExpE,"e");
         param1 = param1.replace(this.chatF.regExpI,"i");
         param1 = param1.replace(this.chatF.regExpO,"o");
         param1 = param1.replace(this.chatF.regExpU,"u");
         return param1.replace(this.chatF.regExpSPACE," ");
      }

      public function maskStringBetween(param1:String, param2:Array) : String
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:String = "";
         if(param2.length > 0 && param2.length % 2 == 0)
         {
            _loc1_ = 0;
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               if(_loc2_ >= param2[_loc1_] && _loc2_ <= param2[_loc1_ + 1])
               {
                  if(param1.charAt(_loc2_) == " ")
                  {
                     _loc3_ += " ";
                  }
                  else
                  {
                     _loc3_ += "*";
                  }
                  if(_loc2_ == param2[_loc1_ + 1])
                  {
                     _loc1_ += 2;
                  }
               }
               else
               {
                  _loc3_ += param1.charAt(_loc2_);
               }
               _loc2_++;
            }
         }
         else
         {
            trace("[Game] ERR maskStringBetween: malformed indeces array");
         }
         return _loc3_;
      }

      public function arraySort(param1:String, param2:String) : int
      {
         if(param1 > param2)
         {
            return 1;
         }
         if(param1 < param2)
         {
            return -1;
         }
         return 0;
      }

      public function convertBubbleText(param1:String) : String
      {
         var _loc1_:String = null;
         _loc1_ = this.world.myAvatar.objData.strUsername;
         if(param1.indexOf("@name"))
         {
            param1 = param1.split("@name").join(_loc1_);
         }
         _loc1_ = String(this.world.myAvatar.objData.intLevel);
         if(param1.indexOf("@level"))
         {
            param1 = param1.split("@level").join(_loc1_);
         }
         _loc1_ = this.world.myAvatar.objData.strClassName;
         if(param1.indexOf("@class"))
         {
            param1 = param1.split("@class").join(_loc1_);
         }
         _loc1_ = this.world.myAvatar.objData.strGender.toLowerCase() == "m" ? "Mr." : "Mrs.";
         if(param1.indexOf("@prefix"))
         {
            param1 = param1.split("@prefix").join(_loc1_);
         }
         _loc1_ = this.world.myAvatar.objData.strGender.toLowerCase() == "m" ? "He" : "She";
         if(param1.indexOf("@He"))
         {
            param1 = param1.split("@prefix").join(_loc1_);
         }
         _loc1_ = this.world.myAvatar.objData.strGender.toLowerCase() == "m" ? "Him" : "Her";
         if(param1.indexOf("@Him"))
         {
            param1 = param1.split("@prefix").join(_loc1_);
         }
         _loc1_ = this.world.myAvatar.objData.strGender.toLowerCase() == "m" ? "His" : "Her";
         if(param1.indexOf("@His"))
         {
            param1 = param1.split("@prefix").join(_loc1_);
         }
         _loc1_ = this.world.myAvatar.objData.strGender.toLowerCase() == "m" ? "he" : "she";
         if(param1.indexOf("@he"))
         {
            param1 = param1.split("@prefix").join(_loc1_);
         }
         _loc1_ = this.world.myAvatar.objData.strGender.toLowerCase() == "m" ? "him" : "her";
         if(param1.indexOf("@him"))
         {
            param1 = param1.split("@prefix").join(_loc1_);
         }
         _loc1_ = this.world.myAvatar.objData.strGender.toLowerCase() == "m" ? "his" : "her";
         if(param1.indexOf("@his"))
         {
            param1 = param1.split("@prefix").join(_loc1_);
         }
         return param1;
      }

      public function strToProperCase(param1:String) : String
      {
         return param1.slice(0,1).toUpperCase() + param1.slice(1,param1.length).toLowerCase();
      }

      public function strSetCharAt(param1:String, param2:int, param3:String) : String
      {
         return param1.substring(0,param2) + param3 + param1.substring(param2 + 1,param1.length);
      }

      public function strNumWithCommas(param1:Number) : String
      {
         var _loc1_:String = "";
         var _loc2_:String = param1.toString();
         var _loc3_:* = 0;
         var _loc4_:int = 0;
         _loc3_ = int(_loc2_.length - 1);
         while(_loc3_ > -1)
         {
            if(_loc4_ == 3)
            {
               _loc4_ = 0;
               _loc1_ = _loc2_.charAt(_loc3_) + "," + _loc1_;
            }
            else
            {
               _loc1_ = _loc2_.charAt(_loc3_) + _loc1_;
            }
            _loc4_++;
            _loc3_--;
         }
         return _loc1_;
      }

      public function numToStr(param1:Number, param2:int = 2) : String
      {
         var _loc1_:String = param1.toString();
         if(_loc1_.indexOf(".") == -1)
         {
            _loc1_ += ".";
         }
         var _loc2_:Array = _loc1_.split(".");
         while(_loc2_[1].length < param2)
         {
            _loc2_[1] += "0";
         }
         if(_loc2_[1].length > param2)
         {
            _loc2_[1] = _loc2_[1].substr(0,param2);
         }
         if(param2 > 0)
         {
            _loc1_ = _loc2_[0] + "." + _loc2_[1];
         }
         else
         {
            _loc1_ = _loc2_[0];
         }
         return _loc1_;
      }

      public function copyObj(param1:Object) : Object
      {
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeObject(param1);
         _loc1_.position = 0;
         return _loc1_.readObject();
      }

      public function copyConstructor(param1:*) : *
      {
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeObject(param1);
         _loc1_.position = 0;
         return _loc1_.readObject() as Class;
      }

      public function distanceO(param1:*, param2:*) : Number
      {
         return Math.sqrt(Math.pow(int(param2.x - param1.x),2) + Math.pow(int(param2.y - param1.y),2));
      }

      public function distanceP(param1:*, param2:*, param3:*, param4:*) : Number
      {
         return Math.sqrt(Math.pow(param3 - param1,2) + Math.pow(param4 - param2,2));
      }

      public function distanceXY(param1:*, param2:*, param3:*, param4:*) : Object
      {
         return {
            "dx":param3 - param1,
            "dy":param4 - param2
         };
      }

      public function isHouseItem(param1:Object) : Boolean
      {
         return param1.sType == "House" || param1.sType == "Floor Item" || param1.sType == "Wall Item";
      }

      internal function validateArmor(param1:*) : *
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:Array = [];
         var _loc4_:Object = {};
         var _loc5_:int = 0;
         var _loc6_:int = 10;
         var _loc7_:Boolean = true;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc10_:int = int(param1.ItemID);
         switch(_loc10_)
         {
            case 319:
            case 2083:
               _loc8_ = true;
               _loc3_ = [16,15654,407,20,15651,409];
               break;
            case 409:
               _loc9_ = true;
               _loc3_ = [20,15651];
               break;
            case 408:
               _loc9_ = true;
               _loc3_ = [17,15653];
               break;
            case 410:
               _loc9_ = true;
               _loc3_ = [18,15652];
               break;
            case 407:
               _loc9_ = true;
               _loc3_ = [16,15654];
         }
         if(_loc8_)
         {
            _loc1_ = 0;
            while(_loc1_ < _loc3_.length)
            {
               if(this.world.myAvatar.getCPByID(_loc3_[_loc1_]) < 302500)
               {
                  _loc7_ = false;
               }
               else
               {
                  _loc7_ = true;
                  if(_loc1_ < 2)
                  {
                     _loc1_ = 2;
                  }
                  if(_loc1_ < 5 && _loc1_ > 2)
                  {
                     break;
                  }
               }
               _loc1_++;
            }
            return _loc7_;
         }
         if(_loc9_)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc3_.length)
            {
               if(this.world.myAvatar.getCPByID(_loc3_[_loc2_]) >= param1.iReqCP)
               {
                  return true;
               }
               _loc2_++;
            }
            return false;
         }
         return !(Number(param1.iClass) > 0 && this.world.myAvatar.getCPByID(param1.iClass) < param1.iReqCP);
      }

      public function getItemInfoString(param1:Object) : String
      {
         var _loc1_:int = 0;
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = "<font size=\'14\'><b>" + param1.sName + "</b></font><br>";
         if(!this.validateArmor(param1) && param1.iClass > 0)
         {
            _loc14_ += "<font size=\'11\' color=\'#CC0000\'>";
            _loc1_ = this.getRankFromPoints(param1.iReqCP);
            _loc2_ = param1.iReqCP - this.arrRanks[_loc1_ - 1];
            if(_loc2_ > 0)
            {
               _loc14_ += "Requires " + _loc2_ + " Class Points on " + param1.sClass + ", Rank " + _loc1_ + ".";
            }
            else
            {
               _loc14_ += "Requires " + param1.sClass + ", Rank " + _loc1_ + ".";
            }
            _loc14_ += "</font><br>";
         }
         if(param1.FactionID > 1 && this.world.myAvatar.getRep(param1.FactionID) < param1.iReqRep)
         {
            _loc14_ += "<font size=\'11\' color=\'#CC0000\'>";
            _loc3_ = this.getRankFromPoints(param1.iReqRep);
            _loc4_ = param1.iReqRep - this.arrRanks[_loc3_ - 1];
            if(_loc4_ > 0)
            {
               _loc14_ += "Requires " + _loc4_ + " Reputation on " + param1.sFaction + ", Rank " + _loc3_ + ".";
            }
            else
            {
               _loc14_ += "Requires " + param1.sFaction + ", Rank " + _loc3_ + ".";
            }
            _loc14_ += "</font><br>";
         }
         if(param1.iQSindex >= 0 && this.world.getQuestValue(param1.iQSindex) < int(param1.iQSvalue))
         {
            _loc14_ += "<font size=\'11\' color=\'#CC0000\'>Requires completion of quest \"" + param1.sQuest + "\".</font><br>";
         }
         _loc14_ += "<font color=\'#009900\'><b>" + this.getDisplaysType(param1);
         if(param1.sES != "None" && param1.sES != "co" && param1.sES != "mi")
         {
            if(param1.EnhID > 0)
            {
               _loc14_ += ", Lvl " + param1.EnhLvl;
               if(param1.sES == "Weapon")
               {
                  _loc5_ = this.getBaseHPByLevel(param1.EnhLvl);
                  _loc6_ = 20;
                  _loc7_ = 1;
                  _loc8_ = param1.iRng / 100;
                  _loc9_ = 2;
                  _loc10_ = Math.round(_loc5_ / _loc6_ * _loc7_);
                  _loc11_ = Math.round(_loc10_ * _loc9_);
                  _loc12_ = Math.floor(_loc11_ - _loc11_ * _loc8_);
                  _loc13_ = Math.ceil(_loc11_ + _loc11_ * _loc8_);
                  _loc14_ += "<br>" + _loc12_ + " - " + _loc13_ + " " + param1.sElmt;
               }
            }
            else
            {
               _loc14_ += " Design";
            }
         }
         param1.sDesc = param1.sDesc.replace(this.regExLineSpace,"\n");
         return _loc14_ + ("</b></font>" + (this.litePreference.data.bDebugger ? "Item ID: " + param1.ItemID + "<br>" : "") + "<br>" + param1.sDesc + "<br>");
      }

      public function getItemInfoStringB(param1:Object) : String
      {
         var _loc1_:int = 0;
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         var _loc4_:* = undefined;
         var _loc5_:int = param1.iRty == 0 ? 25 : int(param1.iRty);
         var _loc6_:* = "<font size=\'12\'><b>" + param1.sName + "</b></font><br>";
         if(!this.validateArmor(param1) && param1.iClass > 0)
         {
            _loc6_ += "<font size=\'10\' color=\'#CC0000\'>";
            _loc1_ = this.getRankFromPoints(param1.iReqCP);
            _loc2_ = param1.iReqCP - this.arrRanks[_loc1_ - 1];
            if(_loc2_ > 0)
            {
               _loc6_ += "Requires " + _loc2_ + " Class Points on " + param1.sClass + ", Rank " + _loc1_ + ".";
            }
            else
            {
               _loc6_ += "Requires " + param1.sClass + ", Rank " + _loc1_ + ".";
            }
            _loc6_ += "</font><br>";
         }
         if(param1.FactionID > 1 && this.world.myAvatar.getRep(param1.FactionID) < param1.iReqRep)
         {
            _loc6_ += "<font size=\'10\' color=\'#CC0000\'>";
            _loc3_ = this.getRankFromPoints(param1.iReqRep);
            _loc4_ = param1.iReqRep - this.arrRanks[_loc3_ - 1];
            if(_loc4_ > 0)
            {
               _loc6_ += "Requires " + _loc4_ + " Reputation on " + param1.sFaction + ", Rank " + _loc3_ + ".";
            }
            else
            {
               _loc6_ += "Requires " + param1.sFaction + ", Rank " + _loc3_ + ".";
            }
            _loc6_ += "</font><br>";
         }
         if(param1.iQSindex >= 0 && this.world.getQuestValue(param1.iQSindex) < int(param1.iQSvalue))
         {
            _loc6_ += "<font size=\'11\' color=\'#CC0000\'>Requires completion of quest \"" + param1.sQuest + "\".</font><br>";
         }
         if(param1.sMeta != null && this.getDisplaysType(param1) == "Pet" && param1.sMeta.indexOf("Necromancer") > -1)
         {
            _loc6_ += "<font color=\'#00CCFF\'><b>Battle " + this.getDisplaysType(param1);
         }
         else
         {
            _loc6_ += "<font color=\'#00CCFF\'><b>" + this.getDisplaysType(param1);
         }
         if(param1.sType.toLowerCase() == "enhancement")
         {
            _loc6_ += ", Level " + param1.iLvl;
         }
         if(param1.sES != "None" && param1.sES != "co" && param1.sES != "pe" && param1.sES != "mi")
         {
            if(param1.EnhID > 0)
            {
               _loc6_ += ", Level " + param1.EnhLvl;
               if(param1.sES == "ar")
               {
                  _loc6_ += "<br>Rank " + this.getRankFromPoints(param1.iQty);
               }
            }
            else if(param1.sType.toLowerCase() != "enhancement")
            {
               _loc6_ += " Design";
            }
         }
         if(param1.iStk > 1)
         {
            _loc6_ += " - " + param1.iQty + "/" + param1.iStk;
         }
         if(param1.sES == "Weapon" || param1.sES == "co" || param1.sES == "he" || param1.sES == "ba" || param1.sES == "pe" || param1.sES == "am" || param1.sES == "mi" || param1.sES == "hi" || param1.sES == "ho")
         {
            if(param1.sType.toLowerCase() != "enhancement")
            {
               _loc6_ += "<br>" + this.getRarityString(_loc5_) + " Rarity";
            }
         }
         if(param1.sType.toLowerCase() != "enhancement")
         {
            param1.sDesc = param1.sDesc.replace(this.regExLineSpace,"\n");
            _loc6_ += "</b></font><br><font size=\'10\' color=\'#FFFFFF\'>" + (this.litePreference.data.bDebugger ? "Item ID: " + param1.ItemID + "<br>" : "") + param1.sDesc + "<br></font>";
         }
         else
         {
            _loc6_ += "</b></font><br><font size=\'10\' color=\'#FFFFFF\'>";
            _loc6_ += "Enhancements are special items which can apply stats to your weapons and armor. Select a weapon or armor item from the list on the right, and click the <font color=\'#00CCFF\'>\"Enhancements\"</font> button that appears below its preview.";
         }
         return _loc6_;
      }

      public function getIconByType(param1:String) : String
      {
         var _loc1_:String = "";
         switch(param1.toLowerCase())
         {
            case "axe":
            case "bow":
            case "dagger":
            case "gun":
            case "mace":
            case "polearm":
            case "staff":
            case "sword":
            case "wand":
            case "armor":
               _loc1_ = "iw" + param1.toLowerCase();
               break;
            case "cape":
            case "helm":
            case "pet":
            case "class":
               _loc1_ = "ii" + param1.toLowerCase();
               break;
            default:
               _loc1_ = "iibag";
         }
         return _loc1_;
      }

      public function getIconBySlot(param1:String) : String
      {
         var _loc1_:String = "";
         switch(param1.toLowerCase())
         {
            case "weapon":
               _loc1_ = "iwsword";
               break;
            case "back":
            case "ba":
               _loc1_ = "iicape";
               break;
            case "head":
            case "he":
               _loc1_ = "iihelm";
               break;
            case "armor":
            case "ar":
               _loc1_ = "iiclass";
               break;
            case "class":
               _loc1_ = "iiclass";
               break;
            case "pet":
            case "pe":
               _loc1_ = "iipet";
               break;
            default:
               _loc1_ = "iibag";
         }
         return _loc1_;
      }

      public function getDisplaysType(param1:Object) : *
      {
         var _loc1_:String = param1.sType != null ? param1.sType : "Unknown";
         var _loc2_:String = _loc1_.toLowerCase();
         if(_loc2_ == "clientuse" || _loc2_ == "serveruse")
         {
            _loc1_ = "Item";
         }
         if(_loc2_ == "misc")
         {
            _loc1_ = "Ground";
         }
         return _loc1_;
      }

      public function stringToDate(param1:String) : Date
      {
         var _loc1_:* = Number(param1.substr(0,4));
         var _loc2_:* = Number(param1.substr(5,2)) - 1;
         var _loc3_:* = Number(param1.substr(8,2));
         var _loc4_:* = Number(param1.substr(11,2));
         var _loc5_:* = Number(param1.substr(14,2));
         var _loc6_:* = Number(param1.substr(17));
         return new Date(_loc1_,_loc2_,_loc3_,_loc4_,_loc5_,_loc6_);
      }

      internal function traceObject(param1:*, param2:* = 1) : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = "";
         while(_loc3_.length < param2)
         {
            _loc3_ += " ";
         }
         param2++;
         if(typeof param1 == "object" && param1.length != null)
         {
            _loc1_ = 0;
            while(_loc1_ < param1.length)
            {
               trace(_loc3_ + _loc1_ + ": " + param1[_loc1_]);
               _loc1_++;
            }
         }
         else
         {
            for(_loc2_ in param1)
            {
               trace(_loc3_ + _loc2_ + ": " + param1[_loc2_]);
               if(typeof param1[_loc2_] == "object")
               {
                  this.traceObject(param1[_loc2_],param2);
               }
            }
         }
      }

      public function max(param1:int, param2:int) : int
      {
         if(param1 > param2)
         {
            return param1;
         }
         return param2;
      }

      public function clamp(param1:Number, param2:Number, param3:Number) : Number
      {
         if(param1 < param2)
         {
            return param2;
         }
         if(param1 > param3)
         {
            return param3;
         }
         return param1;
      }

      public function isValidEmail(param1:String) : Boolean
      {
         return Boolean(param1.match(this.EMAIL_REGEX));
      }

      public function closeToolTip() : void
      {
         var _loc1_:* = undefined;
         try
         {
            _loc1_ = MovieClip(stage.getChildAt(0)).ui.ToolTip;
            _loc1_.close();
         }
         catch(e:Error)
         {
         }
      }

      public function updateIcons(param1:Array, param2:Array, param3:Object = null) : *
      {
         var _loc1_:MovieClip = null;
         var _loc2_:Class = null;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         _loc9_ = 0;
         while(_loc9_ < param1.length)
         {
            _loc1_ = param1[_loc9_];
            _loc1_.cnt.removeChildAt(0);
            _loc1_.item = param3;
            if(_loc1_.item == null)
            {
               _loc1_.tQty.visible = false;
            }
            while(_loc10_ < param2.length)
            {
               _loc2_ = this.world.getClass(param2[_loc10_]) as Class;
               _loc3_ = new _loc2_();
               _loc4_ = _loc1_.cnt.addChild(_loc3_);
               _loc5_ = int(42 - 8 + 4 * _loc10_);
               _loc6_ = int(39 - 8 + 4 * _loc10_);
               _loc7_ = _loc4_.width;
               _loc8_ = _loc4_.height;
               if(_loc7_ > _loc8_)
               {
                  _loc4_.scaleX = _loc4_.scaleY = _loc5_ / _loc7_;
               }
               else
               {
                  _loc4_.scaleX = _loc4_.scaleY = _loc6_ / _loc8_;
               }
               _loc4_.x = _loc1_.bg.width / 2 - _loc4_.width / 2;
               _loc4_.y = _loc1_.bg.height / 2 - _loc4_.height / 2;
               _loc10_++;
            }
            _loc9_++;
         }
      }

      public function updateItemSkill() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.world.actions.active.length)
         {
            if(Boolean(this.world.actions.active[_loc1_]) && this.world.actions.active[_loc1_].ref == "i1")
            {
               this.updateActionObjIcon(this.world.actions.active[_loc1_]);
               break;
            }
            _loc1_++;
         }
      }

      public function updateActionObjIcon(param1:Object) : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Array = this.world.getActIcons(param1);
         var _loc6_:* = 0;
         while(_loc6_ < _loc5_.length)
         {
            _loc1_ = _loc5_[_loc6_];
            _loc2_ = _loc1_.item;
            if(_loc2_ != null)
            {
               _loc3_ = 0;
               while(_loc4_ < this.world.myAvatar.items.length)
               {
                  if(this.world.myAvatar.items[_loc4_].ItemID == _loc2_.ItemID)
                  {
                     _loc3_ = int(this.world.myAvatar.items[_loc4_].iQty);
                  }
                  _loc4_++;
               }
               if(_loc3_ > 0)
               {
                  _loc1_.tQty.visible = true;
                  _loc1_.tQty.text = _loc3_;
               }
               else
               {
                  this.world.unequipUseableItem(_loc2_);
               }
            }
            _loc6_++;
         }
      }

      public function drawChainsSmooth(param1:Array, param2:int, param3:MovieClip) : void
      {
         var _loc1_:Point = null;
         var _loc2_:Point = null;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Point = null;
         var _loc9_:Array = null;
         var _loc10_:MovieClip = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         _loc3_ = 1;
         while(_loc3_ < param1.length)
         {
            _loc1_ = new Point(0,0);
            _loc2_ = new Point(0,0);
            _loc1_ = param1[_loc3_ - 1].localToGlobal(_loc1_);
            _loc2_ = param1[_loc3_].localToGlobal(_loc2_);
            _loc4_ = [];
            _loc5_ = 0;
            _loc6_ = 0;
            _loc7_ = Math.ceil(Point.distance(_loc1_,_loc2_) / param2);
            if(_loc7_ % 2 == 1)
            {
               _loc7_ += 1;
            }
            _loc8_ = new Point();
            _loc9_ = [param3.fx0,param3.fx1,param3.fx2];
            _loc11_ = -1;
            _loc5_ = 0;
            while(_loc5_ < _loc9_.length)
            {
               _loc4_ = [];
               _loc11_ = Math.random() > 0.5 ? 1 : -1;
               _loc12_ = 0;
               _loc6_ = 1;
               while(_loc6_ < _loc7_)
               {
                  _loc8_ = Point.interpolate(_loc1_,_loc2_,1 - _loc6_ / _loc7_);
                  if(++_loc12_ % 2 == 1)
                  {
                     _loc8_.x += _loc11_ * Math.round(Math.random() * 30);
                     _loc8_.y += _loc11_ * Math.round(Math.random() * 30);
                     _loc11_ = -_loc11_;
                  }
                  _loc4_.push(_loc8_);
                  _loc6_++;
               }
               _loc4_.push(_loc2_);
               _loc10_ = _loc9_[_loc5_];
               _loc10_.graphics.lineStyle(2,16777215,1);
               _loc10_.graphics.moveTo(_loc1_.x,_loc1_.y);
               _loc6_ = 0;
               while(_loc6_ < _loc4_.length)
               {
                  _loc10_.graphics.curveTo(_loc4_[_loc6_].x,_loc4_[_loc6_].y,_loc4_[_loc6_ + 1].x,_loc4_[_loc6_ + 1].y);
                  _loc6_ += 2;
               }
               _loc5_++;
            }
            _loc3_++;
         }
      }

      public function drawChainsLinear(param1:Array, param2:int, param3:MovieClip) : void
      {
         var _loc1_:Point = null;
         var _loc2_:Point = null;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Point = null;
         var _loc11_:Array = null;
         var _loc12_:MovieClip = null;
         _loc5_ = 1;
         while(_loc5_ < param1.length)
         {
            _loc3_ = param1[_loc5_ - 1];
            _loc4_ = param1[_loc5_];
            _loc1_ = new Point(0,-_loc3_.height * 0.5);
            _loc2_ = new Point(0,-_loc4_.height * 0.5);
            _loc1_ = _loc3_.localToGlobal(_loc1_);
            _loc2_ = _loc4_.localToGlobal(_loc2_);
            _loc6_ = [];
            _loc7_ = 0;
            _loc8_ = 0;
            _loc9_ = Math.ceil(Point.distance(_loc1_,_loc2_) / param2);
            _loc10_ = new Point();
            _loc11_ = [param3.fx0,param3.fx1,param3.fx2];
            _loc7_ = 0;
            while(_loc7_ < _loc11_.length)
            {
               _loc6_ = [];
               _loc8_ = 1;
               while(_loc8_ < _loc9_)
               {
                  _loc10_ = Point.interpolate(_loc1_,_loc2_,1 - _loc8_ / (_loc9_ + 1));
                  _loc10_.x += Math.round(Math.random() * 25 - 13);
                  _loc10_.y += Math.round(Math.random() * 25 - 13);
                  _loc6_.push(_loc10_);
                  _loc8_++;
               }
               _loc12_ = _loc11_[_loc7_];
               _loc12_.graphics.clear();
               _loc12_.graphics.lineStyle(5,16777215,1);
               _loc12_.graphics.moveTo(_loc1_.x,_loc1_.y);
               _loc8_ = 0;
               while(_loc8_ < _loc6_.length)
               {
                  _loc12_.graphics.lineTo(_loc6_[_loc8_].x,_loc6_[_loc8_].y);
                  _loc8_++;
               }
               _loc12_.graphics.lineTo(_loc2_.x,_loc2_.y);
               _loc7_++;
            }
            _loc5_++;
         }
      }

      public function drawFunnel(param1:Array, param2:MovieClip) : void
      {
         var _loc1_:MovieClip = null;
         param2.numLines = 3;
         param2.lineThickness = 3;
         param2.lineColors = [10027178,0,2228326];
         param2.glowColors = [0];
         param2.glowStrength = 4;
         param2.glowSize = 4;
         param2.dur = 500;
         param2.del = 100;
         param2.p1StartingValue = 0.12;
         param2.p2StartingValue = 0.24;
         param2.p3StartingValue = 0.36;
         param2.p1EndingValue = 0.66;
         param2.p2EndingValue = 0.825;
         param2.p3EndingValue = 0.99;
         param2.p1ScaleFactor = 0.5;
         param2.p3ScaleFactor = 0.5;
         param2.easingExponent = 1.5;
         param2.targetMCs = param1;
         param2.filterArr = [];
         param2.fxArr = [];
         param2.ts = new Date().getTime();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < param2.glowColors.length)
         {
            param2.filterArr.push([new GlowFilter(param2.glowColors[_loc2_],1,param2.glowSize,param2.glowSize,param2.glowStrength,1,false,false)]);
            _loc2_++;
         }
         _loc2_ = 0;
         _loc3_ = 0;
         var _loc4_:int = 0;
         while(_loc4_ < param2.numLines)
         {
            _loc1_ = param2.addChild(new MovieClip()) as MovieClip;
            _loc1_.filters = param2.filterArr[_loc2_];
            if(++_loc2_ >= param2.glowColors.length)
            {
               _loc2_ = 0;
            }
            _loc1_.lineColor = param2.lineColors[_loc3_];
            if(++_loc3_ >= param2.lineColors.length)
            {
               _loc3_ = 0;
            }
            param2.fxArr.push(_loc1_);
            _loc4_++;
         }
         param2.addEventListener(Event.ENTER_FRAME,this.funnelEF,false,0,true);
      }

      internal function funnelEF(param1:Event) : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Point = null;
         var _loc5_:Point = null;
         var _loc6_:Point = null;
         var _loc7_:Point = null;
         var _loc8_:Point = null;
         var _loc9_:Point = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:MovieClip = MovieClip(param1.currentTarget);
         var _loc14_:Number = new Date().getTime();
         var _loc15_:Point = new Point();
         var _loc16_:Point = new Point();
         var _loc17_:Point = new Point();
         var _loc18_:int = 1;
         var _loc19_:MovieClip = _loc13_.targetMCs[0];
         var _loc20_:MovieClip = _loc13_.targetMCs[1];
         var _loc21_:Point = _loc19_.localToGlobal(new Point(0,-_loc19_.height / 2));
         var _loc22_:Point = _loc20_.localToGlobal(new Point(0,-_loc20_.height / 2));
         var _loc23_:* = _loc20_.width;
         var _loc24_:* = _loc20_.height;
         var _loc25_:int = -1;
         var _loc26_:int = 0;
         var _loc27_:int = 0;
         var _loc28_:Number = Math.atan2(_loc21_.y - _loc22_.y,_loc21_.x - _loc22_.x);
         _loc28_ = _loc28_ - Math.PI / 2;
         var _loc29_:int = 0;
         while(_loc29_ < _loc13_.fxArr.length)
         {
            _loc1_ = _loc13_.fxArr[_loc29_];
            _loc3_ = Number(_loc13_.ts);
            _loc2_ = _loc14_ - _loc29_ * _loc13_.del;
            if(_loc2_ > _loc3_ + _loc13_.dur)
            {
               if(_loc1_.visible)
               {
                  _loc1_.visible = false;
                  _loc1_.graphics.clear();
               }
               if(_loc29_ == _loc13_.fxArr.length - 1)
               {
                  _loc13_.removeEventListener(Event.ENTER_FRAME,this.funnelEF);
                  if(_loc13_.parent != null)
                  {
                     _loc13_.parent.removeChild(_loc13_);
                  }
               }
            }
            else if(_loc2_ >= _loc13_.ts)
            {
               _loc11_ = (_loc2_ - _loc3_) / _loc13_.dur;
               _loc11_ = Math.pow(1 - _loc11_,_loc13_.easingExponent);
               _loc18_ = _loc29_ % 2 == 0 ? 1 : -1;
               _loc4_ = new Point(Point.interpolate(_loc21_,_loc22_,_loc13_.p1StartingValue).x + Point.polar(_loc18_ * (_loc20_.height / _loc13_.p1ScaleFactor),_loc28_).x,Point.interpolate(_loc21_,_loc22_,_loc13_.p1StartingValue).y + Point.polar(_loc18_ * (_loc20_.height / _loc13_.p1ScaleFactor),_loc28_).y);
               _loc5_ = new Point(Point.interpolate(_loc21_,_loc22_,_loc13_.p1EndingValue).x,Point.interpolate(_loc21_,_loc22_,_loc13_.p1EndingValue).y);
               _loc6_ = new Point(Point.interpolate(_loc21_,_loc22_,_loc13_.p2StartingValue).x,_loc22_.y);
               _loc7_ = new Point(Point.interpolate(_loc21_,_loc22_,_loc13_.p2EndingValue).x,Point.interpolate(_loc21_,_loc22_,_loc13_.p2EndingValue).y);
               _loc8_ = new Point(Point.interpolate(_loc21_,_loc22_,_loc13_.p3StartingValue).x + Point.polar(-_loc18_ * (_loc20_.height / _loc13_.p3ScaleFactor),_loc28_).x,Point.interpolate(_loc21_,_loc22_,_loc13_.p3StartingValue).y + Point.polar(-_loc18_ * (_loc20_.height / _loc13_.p3ScaleFactor),_loc28_).y);
               _loc9_ = new Point(Point.interpolate(_loc21_,_loc22_,_loc13_.p3EndingValue).x,Point.interpolate(_loc21_,_loc22_,_loc13_.p3EndingValue).y);
               _loc15_ = Point.interpolate(_loc4_,_loc5_,_loc11_);
               _loc16_ = Point.interpolate(_loc6_,_loc7_,_loc11_);
               _loc17_ = Point.interpolate(_loc8_,_loc9_,_loc11_);
               _loc10_ = Number(_loc1_.lineColor);
               _loc1_.graphics.clear();
               _loc1_.graphics.lineStyle(_loc13_.lineThickness,_loc10_,1);
               _loc1_.graphics.moveTo(_loc22_.x,_loc22_.y);
               _loc1_.graphics.curveTo(_loc15_.x,_loc15_.y,_loc16_.x,_loc16_.y);
               _loc1_.graphics.curveTo(_loc17_.x,_loc17_.y,_loc21_.x,_loc21_.y);
               _loc12_ = Math.cos((_loc2_ - _loc3_) / _loc13_.dur * Math.PI * 2);
               _loc12_ = _loc12_ / 2 + 0.5;
               _loc12_ = 1 - _loc12_;
               _loc1_.alpha = _loc12_;
            }
            _loc29_++;
         }
      }

      public function updateCoreValues(param1:Object) : void
      {
         if(param1.intLevelCap != null)
         {
            this.intLevelCap = param1.intLevelCap;
         }
         if(param1.PCstBase != null)
         {
            this.PCstBase = param1.PCstBase;
         }
         if(param1.PCstRatio != null)
         {
            this.PCstRatio = param1.PCstRatio;
         }
         if(param1.PCstGoal != null)
         {
            this.PCstGoal = param1.PCstGoal;
         }
         if(param1.GstBase != null)
         {
            this.GstBase = param1.GstBase;
         }
         if(param1.GstRatio != null)
         {
            this.GstRatio = param1.GstRatio;
         }
         if(param1.GstGoal != null)
         {
            this.GstGoal = param1.GstGoal;
         }
         if(param1.PChpBase1 != null)
         {
            this.PChpBase1 = param1.PChpBase1;
         }
         if(param1.PChpBase100 != null)
         {
            this.PChpBase100 = param1.PChpBase100;
         }
         if(param1.PChpGoal1 != null)
         {
            this.PChpGoal1 = param1.PChpGoal1;
         }
         if(param1.PChpGoal100 != null)
         {
            this.PChpGoal100 = param1.PChpGoal100;
         }
         if(param1.PChpDelta != null)
         {
            this.PChpDelta = param1.PChpDelta;
         }
         if(param1.intHPperEND != null)
         {
            this.intHPperEND = param1.intHPperEND;
         }
         if(param1.intAPtoDPS != null)
         {
            this.intAPtoDPS = param1.intAPtoDPS;
         }
         if(param1.intSPtoDPS != null)
         {
            this.intSPtoDPS = param1.intSPtoDPS;
         }
         if(param1.bigNumberBase != null)
         {
            this.bigNumberBase = param1.bigNumberBase;
         }
         if(param1.resistRating != null)
         {
            this.resistRating = param1.resistRating;
         }
         if(param1.modRating != null)
         {
            this.modRating = param1.modRating;
         }
         if(param1.baseDodge != null)
         {
            this.baseDodge = param1.baseDodge;
         }
         if(param1.baseBlock != null)
         {
            this.baseBlock = param1.baseBlock;
         }
         if(param1.baseParry != null)
         {
            this.baseParry = param1.baseParry;
         }
         if(param1.baseCrit != null)
         {
            this.baseCrit = param1.baseCrit;
         }
         if(param1.baseHit != null)
         {
            this.baseHit = param1.baseHit;
         }
         if(param1.baseHaste != null)
         {
            this.baseHaste = param1.baseHaste;
         }
         if(param1.baseMiss != null)
         {
            this.baseMiss = param1.baseMiss;
         }
         if(param1.baseResist != null)
         {
            this.baseResist = param1.baseResist;
         }
         if(param1.baseCritValue != null)
         {
            this.baseCritValue = param1.baseCritValue;
         }
         if(param1.baseBlockValue != null)
         {
            this.baseBlockValue = param1.baseBlockValue;
         }
         if(param1.baseResistValue != null)
         {
            this.baseResistValue = param1.baseResistValue;
         }
         if(param1.baseEventValue != null)
         {
            this.baseEventValue = param1.baseEventValue;
         }
         if(param1.PCDPSMod != null)
         {
            this.PCDPSMod = param1.PCDPSMod;
         }
         if(param1.curveExponent != null)
         {
            this.curveExponent = param1.curveExponent;
         }
         if(param1.statsExponent != null)
         {
            this.statsExponent = param1.statsExponent;
         }
      }

      internal function spaceBy(param1:int, param2:int) : String
      {
         var _loc1_:String = String(param1);
         while(_loc1_.length < param2)
         {
            _loc1_ += " ";
         }
         return _loc1_;
      }

      internal function spaceNumBy(param1:Number, param2:int) : String
      {
         var _loc1_:String = param1.toString();
         _loc1_ = _loc1_.substr(0,param2);
         while(_loc1_.length < param2)
         {
            _loc1_ += " ";
         }
         return _loc1_;
      }

      internal function showRatings() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = this.world.myAvatar.dataLeaf;
         var _loc13_:* = "";
         var _loc14_:* = 1;
         var _loc15_:* = 0;
         var _loc16_:* = 0;
         _loc14_ = 1;
         while(_loc14_ <= 35)
         {
            if(_loc14_ == 0)
            {
               _loc14_ = 1;
            }
            _loc1_ = this.getInnateStats(_loc14_);
            _loc2_ = this.getIBudget(_loc14_,1);
            _loc3_ = -1;
            _loc4_ = -1;
            _loc5_ = -1;
            _loc6_ = -1;
            _loc7_ = _loc12_.sCat;
            _loc8_ = this.copyObj(_loc12_.sta);
            this.resetTableValues(_loc8_);
            _loc9_ = this.getBaseHPByLevel(_loc14_);
            _loc10_ = _loc9_ / 20 * 0.7;
            _loc11_ = 2.25 * _loc10_ / (100 / this.intAPtoDPS) / 2;
            _loc15_ = 0;
            while(_loc15_ < this.stats.length)
            {
               _loc13_ = this.stats[_loc15_];
               _loc6_ = _loc8_["$" + _loc13_];
               switch(_loc13_)
               {
                  case "STR":
                     _loc3_ = _loc11_;
                     _loc8_.$ap += _loc6_ * 2;
                     _loc8_.$tcr += _loc6_ / _loc3_ / 100 * 0.4;
               }
               _loc15_++;
            }
            _loc14_ += 1;
         }
      }

      public function applyCoreStatRatings(param1:Object, param2:Object) : void
      {
         var _loc1_:int = 1;
         var _loc2_:* = 100;
         var _loc3_:Object = this.world.myAvatar.getEquippedItemBySlot("Weapon");
         if(_loc3_ != null)
         {
            if(_loc3_.EnhLvl != null)
            {
               _loc1_ = int(_loc3_.EnhLvl);
            }
            if(_loc3_.EnhDPS != null)
            {
               _loc2_ = Number(_loc3_.EnhDPS);
            }
            if(_loc2_ == 0)
            {
               _loc2_ = 100;
            }
         }
         _loc2_ /= 100;
         var _loc4_:int = int(param2.intLevel);
         var _loc5_:String = "";
         var _loc6_:int = this.getInnateStats(_loc4_);
         var _loc7_:Number = -1;
         var _loc8_:Number = -1;
         var _loc9_:Number = -1;
         var _loc10_:int = -1;
         var _loc11_:String = this.world.myAvatar.objData.sClassCat;
         var _loc12_:int = this.getBaseHPByLevel(_loc4_);
         var _loc13_:int = 20;
         var _loc14_:* = _loc12_ / 20 * 0.7;
         var _loc15_:Number = 2.25 * _loc14_ / (100 / this.intAPtoDPS) / 2;
         this.resetTableValues(param1);
         var _loc16_:int = 0;
         while(_loc16_ < this.stats.length)
         {
            _loc5_ = this.stats[_loc16_];
            _loc10_ = param1["_" + _loc5_] + param1["^" + _loc5_];
            switch(_loc5_)
            {
               case "STR":
                  _loc7_ = _loc15_;
                  if(_loc11_ == "M1")
                  {
                     param1.$sbm -= _loc10_ / _loc7_ / 100 * 0.3;
                  }
                  if(_loc11_ == "S1")
                  {
                     param1.$ap += Math.round(_loc10_ * 1.4);
                  }
                  else
                  {
                     param1.$ap += _loc10_ * 2;
                  }
                  if(_loc11_ == "M1" || _loc11_ == "M2" || _loc11_ == "M3" || _loc11_ == "M4" || _loc11_ == "S1")
                  {
                     if(_loc11_ == "M4")
                     {
                        param1.$tcr += _loc10_ / _loc7_ / 100 * 0.7;
                     }
                     else
                     {
                        param1.$tcr += _loc10_ / _loc7_ / 100 * 0.4;
                     }
                  }
                  break;
               case "INT":
                  _loc7_ = _loc15_;
                  param1.$cmi -= _loc10_ / _loc7_ / 100;
                  if(_loc11_.substr(0,1) == "C" || _loc11_ == "M3")
                  {
                     param1.$cmo += _loc10_ / _loc7_ / 100;
                  }
                  if(_loc11_ == "S1")
                  {
                     param1.$sp += Math.round(_loc10_ * 1.4);
                  }
                  else
                  {
                     param1.$sp += _loc10_ * 2;
                  }
                  if(_loc11_ == "C1" || _loc11_ == "C2" || _loc11_ == "C3" || _loc11_ == "M3" || _loc11_ == "S1")
                  {
                     if(_loc11_ == "C2")
                     {
                        param1.$tha += _loc10_ / _loc7_ / 100 * 0.5;
                     }
                     else
                     {
                        param1.$tha += _loc10_ / _loc7_ / 100 * 0.3;
                     }
                  }
                  break;
               case "DEX":
                  _loc7_ = _loc15_;
                  if(_loc11_ == "M1" || _loc11_ == "M2" || _loc11_ == "M3" || _loc11_ == "M4" || _loc11_ == "S1")
                  {
                     if(_loc11_.substr(0,1) != "C")
                     {
                        param1.$thi += _loc10_ / _loc7_ / 100 * 0.2;
                     }
                     if(_loc11_ == "M2" || _loc11_ == "M4")
                     {
                        param1.$tha += _loc10_ / _loc7_ / 100 * 0.5;
                     }
                     else
                     {
                        param1.$tha += _loc10_ / _loc7_ / 100 * 0.3;
                     }
                     if(_loc11_ == "M1")
                     {
                        if(param1._tbl > 0.01)
                        {
                           param1.$tbl += _loc10_ / _loc7_ / 100 * 0.5;
                        }
                     }
                  }
                  if(_loc11_ != "M2" && _loc11_ != "M3")
                  {
                     param1.$tdo += _loc10_ / _loc7_ / 100 * 0.3;
                  }
                  else
                  {
                     param1.$tdo += _loc10_ / _loc7_ / 100 * 0.5;
                  }
                  break;
               case "WIS":
                  _loc7_ = _loc15_;
                  if(_loc11_ == "C1" || _loc11_ == "C2" || _loc11_ == "C3" || _loc11_ == "S1")
                  {
                     if(_loc11_ == "C1")
                     {
                        param1.$tcr += _loc10_ / _loc7_ / 100 * 0.7;
                     }
                     else
                     {
                        param1.$tcr += _loc10_ / _loc7_ / 100 * 0.4;
                     }
                     param1.$thi += _loc10_ / _loc7_ / 100 * 0.2;
                  }
                  param1.$tdo += _loc10_ / _loc7_ / 100 * 0.3;
                  break;
               case "LCK":
                  _loc7_ = _loc15_;
                  param1.$sem += _loc10_ / _loc7_ / 100 * 2;
                  if(_loc11_ == "S1")
                  {
                     param1.$ap += Math.round(_loc10_ * 1);
                     param1.$sp += Math.round(_loc10_ * 1);
                     param1.$tcr += _loc10_ / _loc7_ / 100 * 0.3;
                     param1.$thi += _loc10_ / _loc7_ / 100 * 0.1;
                     param1.$tha += _loc10_ / _loc7_ / 100 * 0.3;
                     param1.$tdo += _loc10_ / _loc7_ / 100 * 0.25;
                     param1.$scm += _loc10_ / _loc7_ / 100 * 2.5;
                  }
                  else
                  {
                     if(_loc11_ == "M1" || _loc11_ == "M2" || _loc11_ == "M3" || _loc11_ == "M4")
                     {
                        param1.$ap += Math.round(_loc10_ * 0.7);
                     }
                     if(_loc11_ == "C1" || _loc11_ == "C2" || _loc11_ == "C3" || _loc11_ == "M3")
                     {
                        param1.$sp += Math.round(_loc10_ * 0.7);
                     }
                     param1.$tcr += _loc10_ / _loc7_ / 100 * 0.2;
                     param1.$thi += _loc10_ / _loc7_ / 100 * 0.1;
                     param1.$tha += _loc10_ / _loc7_ / 100 * 0.1;
                     param1.$tdo += _loc10_ / _loc7_ / 100 * 0.1;
                     param1.$scm += _loc10_ / _loc7_ / 100 * 5;
                  }
            }
            _loc16_++;
         }
         param1.wDPS = Math.round(this.getBaseHPByLevel(_loc1_) / _loc13_ * _loc2_ * this.PCDPSMod) + Math.round(param1.$ap / this.intAPtoDPS);
         param1.mDPS = Math.round(this.getBaseHPByLevel(_loc1_) / _loc13_ * _loc2_ * this.PCDPSMod) + Math.round(param1.$sp / this.intSPtoDPS);
      }

      public function coeffToPct(param1:Number) : String
      {
         return Number(param1 * 100).toFixed(2);
      }

      public function getIBudget(param1:int, param2:int) : int
      {
         if(param1 < 1)
         {
            param1 = 1;
         }
         if(param1 > this.intLevelCap)
         {
            param1 = this.intLevelCap;
         }
         if(param2 < 1)
         {
            param2 = 1;
         }
         param1 = Math.round(param1 + param2 - 1);
         return int(Math.round(this.GstBase + Math.pow((param1 - 1) / (this.intLevelCap - 1),this.statsExponent) * (this.GstGoal - this.GstBase)));
      }

      public function getInnateStats(param1:int) : int
      {
         if(param1 < 1)
         {
            param1 = 1;
         }
         if(param1 > this.intLevelCap)
         {
            param1 = this.intLevelCap;
         }
         return Math.round(this.PCstBase + Math.pow((param1 - 1) / (this.intLevelCap - 1),this.statsExponent) * (this.PCstGoal - this.PCstBase));
      }

      public function getBaseHPByLevel(param1:*) : *
      {
         if(param1 < 1)
         {
            param1 = 1;
         }
         if(param1 > this.intLevelCap)
         {
            param1 = this.intLevelCap;
         }
         return Math.round(this.PChpBase1 + Math.pow((param1 - 1) / (this.intLevelCap - 1),this.curveExponent) * this.PChpDelta);
      }

      public function catCodeToName(param1:String) : String
      {
         switch(param1)
         {
            case "M1":
               return "Fighter";
            case "M2":
               return "Thief";
            case "M3":
               return "Hybrid";
            case "M4":
               return "Armsman";
            case "C1":
               return "Wizard";
            case "C2":
               return "Healer";
            case "C3":
               return "spellbreaker";
            case "S1":
               return "Lucky";
            default:
               return null;
         }
      }

      public function resetTableValues(param1:Object) : void
      {
         param1._ap = 0;
         param1.$ap = 0;
         param1._sp = 0;
         param1.$sp = 0;
         param1._tbl = 0;
         param1._tpa = 0;
         param1._tdo = 0;
         param1._tcr = 0;
         param1._thi = 0;
         param1._tha = 0;
         param1._tre = 0;
         param1.$tbl = this.baseBlock;
         param1.$tpa = this.baseParry;
         param1.$tdo = this.baseDodge;
         param1.$tcr = this.baseCrit;
         param1.$thi = this.baseHit;
         param1.$tha = this.baseHaste;
         param1.$tre = this.baseResist;
         param1._cpo = 1;
         param1._cpi = 1;
         param1._cao = 1;
         param1._cai = 1;
         param1._cmo = 1;
         param1._cmi = 1;
         param1._cdo = 1;
         param1._cdi = 1;
         param1._cho = 1;
         param1._chi = 1;
         param1._cmc = 1;
         param1.$cpo = 1;
         param1.$cpi = 1;
         param1.$cao = 1;
         param1.$cai = 1;
         param1.$cmo = 1;
         param1.$cmi = 1;
         param1.$cdo = 1;
         param1.$cdi = 1;
         param1.$cho = 1;
         param1.$chi = 1;
         param1.$cmc = 1;
         param1._scm = this.baseCritValue;
         param1._sbm = this.baseBlockValue;
         param1._srm = this.baseResistValue;
         param1._sem = this.baseEventValue;
         param1.$scm = this.baseCritValue;
         param1.$sbm = this.baseBlockValue;
         param1.$srm = this.baseResistValue;
         param1.$sem = this.baseEventValue;
         param1._shb = 0;
         param1._smb = 0;
         param1.$shb = 0;
         param1.$smb = 0;
      }

      public function getCategoryStats(param1:String, param2:int) : Object
      {
         var _loc1_:* = this.getInnateStats(param2);
         var _loc2_:* = this.classCatMap[param1].ratios;
         var _loc3_:* = {};
         var _loc4_:* = "";
         var _loc5_:int = 0;
         while(_loc5_ < this.stats.length)
         {
            _loc4_ = this.stats[_loc5_];
            _loc3_[_loc4_] = Math.round(_loc2_[_loc5_] * _loc1_);
            _loc5_++;
         }
         return _loc3_;
      }

      public function applyAuraEffect(param1:*, param2:*) : *
      {
         switch(param1.typ)
         {
            case "+":
               param2["$" + param1.sta] += Number(param1.val);
               break;
            case "-":
               param2["$" + param1.sta] -= Number(param1.val);
               break;
            case "*":
               param2["$" + param1.sta] = Math.round(param2["$" + param1.sta] * Number(param1.val));
         }
      }

      public function removeAuraEffect(param1:*, param2:*) : *
      {
         switch(param1.typ)
         {
            case "+":
               param2["$" + param1.sta] -= Number(param1.val);
               break;
            case "-":
               param2["$" + param1.sta] += Number(param1.val);
               break;
            case "*":
               param2["$" + param1.sta] = Math.round(param2["$" + param1.sta] / Number(param1.val));
         }
      }

      public function getStatsA(param1:Object, param2:String) : Object
      {
         var _loc1_:Object = null;
         var _loc2_:int = param1.sType.toLowerCase() == "enhancement" ? int(param1.iLvl) : int(param1.EnhLvl);
         var _loc3_:int = param1.sType.toLowerCase() == "enhancement" ? int(param1.iRty) : int(param1.EnhRty);
         var _loc4_:int = Math.round(this.getIBudget(_loc2_,_loc3_) * this.ratiosBySlot[param2]);
         var _loc5_:* = -1;
         var _loc6_:* = ["iEND","iSTR","iINT","iDEX","iWIS","iLCK"];
         var _loc7_:* = 0;
         var _loc8_:* = "";
         var _loc9_:* = {};
         var _loc10_:* = 0;
         var _loc11_:int = 0;
         var _loc12_:Object = {};
         this.world.initPatternTree();
         if(param1.PatternID != null)
         {
            _loc1_ = this.world.enhPatternTree[param1.PatternID];
         }
         if(param1.EnhPatternID != null)
         {
            _loc1_ = this.world.enhPatternTree[param1.EnhPatternID];
         }
         if(_loc1_ != null)
         {
            _loc11_ = 0;
            while(_loc11_ < this.stats.length)
            {
               _loc8_ = "i" + this.stats[_loc11_];
               if(_loc1_[_loc8_] != null)
               {
                  _loc9_[_loc8_] = Math.round(_loc4_ * _loc1_[_loc8_] / 100);
                  _loc10_ += _loc9_[_loc8_];
               }
               _loc11_++;
            }
            _loc7_ = 0;
            while(_loc10_ < _loc4_)
            {
               _loc8_ = _loc6_[_loc7_];
               if(_loc9_[_loc8_] != null)
               {
                  ++_loc9_[_loc8_];
                  _loc10_++;
               }
               if(++_loc7_ > _loc6_.length - 1)
               {
                  _loc7_ = 0;
               }
            }
            _loc11_ = 0;
            while(_loc11_ < this.stats.length)
            {
               _loc5_ = _loc9_["i" + this.stats[_loc11_]];
               if(_loc5_ != null && _loc5_ != "0")
               {
                  _loc12_["$" + this.stats[_loc11_]] = _loc5_;
               }
               _loc11_++;
            }
         }
         return _loc12_;
      }

      public function getDisplayEnhName(param1:Object) : String
      {
         if(!(Boolean(param1) && param1.hasOwnProperty("DIS")))
         {
            if(param1)
            {
               return param1.sName;
            }
            return "";
         }
         switch(param1.sName)
         {
            case "Vim":
            case "Examen":
            case "Pneuma":
            case "Anima":
               return param1.sName;
            case "Hearty":
               return "Grimskull";
            default:
               return "Forge";
         }
      }

      public function getDisplayEnhTraitName(param1:Object) : String
      {
         switch(param1.sName)
         {
            case "Vim":
            case "Examen":
               return "Ether";
            case "Pneuma":
            case "Anima":
               return "Clairvoyance";
            default:
               return param1.sName;
         }
      }

      public function getFullStatName(param1:String) : String
      {
         var _loc1_:String = "";
         param1 = param1.toLowerCase();
         if(param1.indexOf("str") > -1)
         {
            _loc1_ = "Strength";
         }
         if(param1.indexOf("int") > -1)
         {
            _loc1_ = "Intellect";
         }
         if(param1.indexOf("dex") > -1)
         {
            _loc1_ = "Dexterity";
         }
         if(param1.indexOf("wis") > -1)
         {
            _loc1_ = "Wisdom";
         }
         if(param1.indexOf("end") > -1)
         {
            _loc1_ = "Endurance";
         }
         if(param1.indexOf("lck") > -1)
         {
            _loc1_ = "Luck";
         }
         if(param1.indexOf("tha") > -1)
         {
            _loc1_ = "Haste";
         }
         if(param1.indexOf("thi") > -1)
         {
            _loc1_ = "Hit";
         }
         if(param1.indexOf("tcr") > -1)
         {
            _loc1_ = "Critcal Hit";
         }
         if(param1.indexOf("tcm") > -1)
         {
            _loc1_ = "Crit Value";
         }
         if(param1.indexOf("tdo") > -1)
         {
            _loc1_ = "Evasion";
         }
         return _loc1_;
      }

      public function getRarityString(param1:int) : String
      {
         switch(param1)
         {
            case 0:
            case 10:
               return "Unknown";
            case 1:
               return "Enhancement +0";
            case 2:
               return "Enhancement +1";
            case 3:
               return "Enhancement +2";
            case 4:
               return "Enhancement +3";
            case 5:
               return "Enhancement +4";
            case 6:
               return "Enhancement +5";
            case 7:
               return "Enhancement +6";
            case 8:
               return "Enhancement +100";
            case 9:
               return "Enhancement +200";
            case 11:
               return "Common";
            case 12:
               return "Weird";
            case 13:
               return "Awesome";
            case 14:
               return "1% Drop";
            case 15:
               return "5% Drop";
            case 16:
               return "Boss Drop";
            case 17:
               return "Hidden Secret";
            case 18:
               return "Junk";
            case 19:
               return "Impossible";
            case 20:
               return "Artifact";
            case 21:
               return "Limited Time Drop";
            case 23:
               return "Crazy";
            case 24:
               return "Expensive";
            case 25:
               return "Placeholder";
            case 30:
               return "Rare";
            case 35:
               return "Epic";
            case 36:
               return "Champion";
            case 40:
               return "Verification Shop";
            case 50:
               return "Seasonal";
            case 55:
               return "Seasonal Rare";
            case 60:
               return "Event";
            case 65:
               return "Event Rare";
            case 67:
               return "Infinity";
            case 68:
               return "New Collection Chest";
            case 70:
               return "Limited Rare";
            case 75:
               return "Collector";
            case 80:
               return "Promo";
            case 81:
               return "Founder";
            case 88:
               return "Benevolent";
            case 90:
               return "Ultra Rare";
            case 91:
               return "Achievement Tracker";
            case 92:
               return "Upgrade Pack";
            case 93:
               return "Limited Quantity";
            case 94:
               return "Frostval Gifting";
            case 95:
               return "Super Ultra Rare";
            case 96:
               return "Kickstarter Backer";
            case 99:
               return "Custom Item";
            case 100:
               return "Legendary";
            default:
               return "Unknown";
         }
      }

      public function toggleItemEquip(param1:Object) : Boolean
      {
         var _loc1_:* = this.world.getUoLeafById(this.world.myAvatar.uid);
         var _loc2_:Boolean = false;
         if(_loc1_.intState != 1)
         {
            this.MsgBox.notify("Action cannot be performed during combat!");
         }
         else if(this.world.bPvP)
         {
            this.MsgBox.notify("Items may not be equipped or unequipped during a PvP match!");
         }
         else if(param1.bEquip == 1)
         {
            if(param1.sES == "Weapon" || param1.sES == "ar")
            {
               this.MsgBox.notify("Selected Item cannot be unequipped!");
            }
            else
            {
               _loc2_ = true;
               if(param1.sType.toLowerCase() != "item")
               {
                  this.world.sendUnequipItemRequest(param1);
               }
               else
               {
                  this.world.unequipUseableItem(param1);
               }
            }
         }
         else if(param1.bUpg == 1 && !this.world.myAvatar.isUpgraded())
         {
            this.showUpgradeWindow();
         }
         else if(int(param1.EnhLvl) > int(this.world.myAvatar.objData.intLevel))
         {
            this.MsgBox.notify("Level requirement not met!");
         }
         else if(param1.sType.toLowerCase() != "item" && (param1.sES != "mi" && param1.sES != "co" && param1.sES != "pe" && param1.sES != "am" && param1.EnhID <= 0))
         {
            this.MsgBox.notify("Selected item requires enhancement!");
         }
         else if(param1.sType.toLowerCase() != "item")
         {
            _loc2_ = this.world.sendEquipItemRequest(param1);
         }
         else
         {
            _loc2_ = true;
            this.world.equipUseableItem(param1);
         }
         return _loc2_;
      }

      public function tryEnhance(param1:Array, param2:Object, param3:Boolean = false) : void
      {
         if(param1 != null && param2 != null)
         {
            if(param2.iLvl > this.world.myAvatar.objData.intLevel)
            {
               this.MsgBox.notify("Level requirement not met!");
            }
            else if(param1.EnhID == param2.ItemID)
            {
               this.MsgBox.notify("Selected Enhancement already applied to item!");
            }
            else if(param3)
            {
               this.world.sendEnhItemRequestShop(param1,param2);
            }
            else
            {
               this.world.sendEnhItemRequestLocal(param1,param2);
            }
         }
      }

      public function doIHaveEnhancements() : Boolean
      {
         var _loc1_:Object = null;
         for each(_loc1_ in this.world.myAvatar.items)
         {
            if(_loc1_.sType.toLowerCase() == "enhancement")
            {
               return true;
            }
         }
         return false;
      }

      public function isItemEnhanceable(param1:Object) : Boolean
      {
         return ["Weapon","he","ba","pe","ar"].indexOf(param1.sES) >= 0;
      }

      public function resetInvTreeByItemID(param1:int) : *
      {
         var item:Object = null;
         var ItemID:int = param1;
         try
         {
            item = this.world.invTree[ItemID];
            if("EnhID" in item)
            {
               item.EnhID = -1;
            }
            if("EnhRty" in item)
            {
               item.EnhRty = -1;
            }
            if("EnhDPS" in item)
            {
               item.EnhDPS = -1;
            }
            if("EnhRng" in item)
            {
               item.EnhRng = -1;
            }
            if("EnhLvl" in item)
            {
               item.EnhLvl = -1;
            }
            if("EnhPatternID" in item)
            {
               item.EnhPatternID = -1;
            }
         }
         catch(e:Error)
         {
            trace("[Game] ERR resetInvTreeByItemID: " + e.message);
         }
      }

      public function isMergeShop(param1:Object) : Boolean
      {
         var _loc1_:Object = null;
         for each(_loc1_ in param1.items)
         {
            if("turnin" in _loc1_)
            {
               return true;
            }
         }
         return false;
      }

      public function recursiveStop(param1:MovieClip) : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = 0;
         var _loc3_:DisplayObject = null;
         var _loc4_:MovieClip = null;
         var _loc5_:Array = [param1];
         while(_loc5_.length > 0)
         {
            _loc1_ = _loc5_.pop();
            _loc2_ = 0;
            while(_loc2_ < _loc1_.numChildren)
            {
               _loc3_ = _loc1_.getChildAt(_loc2_);
               if(_loc3_ is MovieClip)
               {
                  _loc4_ = MovieClip(_loc3_);
                  if(_loc4_.totalFrames > 1)
                  {
                     _loc4_.gotoAndStop(_loc4_.totalFrames);
                  }
                  else
                  {
                     _loc4_.stop();
                  }
                  _loc5_.push(_loc4_);
               }
               _loc2_++;
            }
         }
      }

      public function recursiveStopSafe(param1:MovieClip) : void
      {
         var current:MovieClip = null;
         var i:int = 0;
         var child:DisplayObject = null;
         var mc:MovieClip = param1;
         var stack:Array = [mc];
         while(stack.length > 0)
         {
            current = stack.pop();
            try
            {
               current.stop();
            }
            catch(e:Error)
            {
            }
            i = current.numChildren - 1;
            while(i >= 0)
            {
               child = null;
               child = current.getChildAt(i);
               if(child is MovieClip)
               {
                  stack.push(MovieClip(child));
               }
               i--;
            }
         }
      }

      public function getTravelMapData() : void
      {
         if(this.travelMapData != null)
         {
            this.showMapUI();
            return;
         }
         if(this.ui.getChildByName("travelLoaderMC"))
         {
            return;
         }
         this.travelLoaderMC = new (this.world.getClass("mcLoader") as Class)();
         this.travelLoaderMC.x = 400;
         this.travelLoaderMC.y = 211;
         this.travelLoaderMC.name = "travelLoaderMC";
         this.ui.addChild(this.travelLoaderMC);
         var _loc1_:String = "api/data/travelmap?v=" + this.world.objInfo["sVersion"];
         var _loc2_:URLLoader = new URLLoader();
         if(String(this.loaderInfo.url).toLowerCase().indexOf("file://") >= 0 || String(this.loaderInfo.url).toLowerCase().indexOf("cdn.aq.com") >= 0 || String(this.loaderInfo.url).toLowerCase().indexOf("aqworldscdn.aq.com") >= 0)
         {
            _loc1_ = "https://game.aq.com/game/" + _loc1_;
         }
         else
         {
            _loc1_ = this.params.sURL + _loc1_;
         }
         var _loc3_:URLRequest = new URLRequest(_loc1_);
         _loc3_.method = URLRequestMethod.GET;
         _loc2_.addEventListener(Event.COMPLETE,this.onTravelMapComplete,false,0,true);
         _loc2_.addEventListener(ProgressEvent.PROGRESS,this.onTravelMapProgress,false,0,true);
         _loc2_.addEventListener(IOErrorEvent.IO_ERROR,this.onTravelError,false,0,true);
         _loc2_.load(_loc3_);
      }

      private function onTravelMapComplete(param1:Event) : void
      {
         this.dropTravelLoader();
         var _loc1_:String = String(param1.target.data);
         var _loc2_:Object = JSON.parse(_loc1_);
         this.travelMapData = _loc2_;
         this.WorldMapData = new worldMap(this.travelMapData);
         this.showMapUI();
      }

      private function showMapUI() : void
      {
         var _loc1_:MovieClip = this.ui.mcPopup.currentLabel == "Map" ? this.ui.mcPopup.mcMap as MovieClip : null;
         if(_loc1_ == null)
         {
            return;
         }
         if(this.mapUILoader != null)
         {
            try
            {
               this.mapUILoader.close();
            }
            catch(errC:Error)
            {
            }
            try
            {
               this.mapUILoader.unloadAndStop();
            }
            catch(err:Error)
            {
            }
            this.mapUILoader = null;
         }
         if(_loc1_.numChildren > 0)
         {
            _loc1_.removeChildAt(0);
         }
         this.mapUILoader = new AirLoader();
         this.mapUILoader.load(new URLRequest(vurl(serverFilePath + this.world.objInfo.sMap)),new LoaderContext(false,AirLoader.trust(ApplicationDomain.currentDomain)));
         _loc1_.addChild(this.mapUILoader);
      }

      private function dropTravelLoader() : void
      {
         if(this.travelLoaderMC != null && this.travelLoaderMC.parent != null)
         {
            this.travelLoaderMC.parent.removeChild(this.travelLoaderMC);
         }
         this.travelLoaderMC = null;
      }

      private function onTravelMapProgress(param1:ProgressEvent) : void
      {
         this.bLoaded = param1.bytesLoaded;
         this.bTotal = param1.bytesTotal;
         var _loc1_:int = this.bLoaded / this.bTotal * 100;
         var _loc2_:Number = this.bLoaded / this.bTotal;
         if(this.travelLoaderMC == null)
         {
            return;
         }
         this.travelLoaderMC.mcPct.text = _loc1_ + "%";
         if(this.bLoaded >= this.bTotal)
         {
            if(this.travelLoaderMC.parent != null)
            {
               this.travelLoaderMC.parent.removeChild(this.travelLoaderMC);
            }
            this.travelLoaderMC = null;
         }
      }

      private function onTravelError(param1:IOErrorEvent) : void
      {
         trace("[Load] ERR travel map load failed: " + param1.text);
         this.dropTravelLoader();
      }

      public function checkPasswordStrength(param1:String) : int
      {
         var _loc1_:Number = 0;
         var _loc2_:Array = param1.split("");
         var _loc3_:Array = [];
         var _loc4_:uint = 0;
         var _loc5_:String = _loc2_[0];
         var _loc6_:Boolean = false;
         var _loc7_:String = param1.toLowerCase();
         var _loc8_:uint = 0;
         while(_loc8_ < this.weakPass.length)
         {
            if(_loc7_ == this.weakPass[_loc8_])
            {
               return -1;
            }
            _loc8_++;
         }
         var _loc9_:uint = 0;
         while(_loc9_ < _loc2_.length)
         {
            if(!_loc6_ && _loc5_ != _loc2_[_loc9_])
            {
               _loc6_ = true;
            }
            if(_loc9_ == 0)
            {
               _loc1_ += 4;
               _loc3_.push(_loc2_[_loc9_]);
            }
            else if(_loc9_ < 8)
            {
               if(!this.isRepeat(_loc3_,_loc2_[_loc9_]))
               {
                  _loc3_.push(_loc2_[_loc9_]);
                  _loc1_ += 2;
               }
               else
               {
                  _loc1_ += 2;
               }
            }
            else if(_loc9_ < 21)
            {
               if(!this.isRepeat(_loc3_,_loc2_[_loc9_]))
               {
                  _loc3_.push(_loc2_[_loc9_]);
                  _loc1_ += 1.5;
               }
               else
               {
                  _loc1_ += 1.5;
               }
            }
            else if(!this.isRepeat(_loc3_,_loc2_[_loc9_]))
            {
               _loc3_.push(_loc2_[_loc9_]);
               _loc1_ += 1;
            }
            else
            {
               _loc1_ += 1;
            }
            if(_loc4_ < 6 && !this.isAlphaChar(_loc2_[_loc9_]))
            {
               _loc1_++;
               _loc4_++;
            }
            _loc9_++;
         }
         return _loc6_ ? int(_loc1_) : -1;
      }

      private function isAlphaChar(param1:String) : Boolean
      {
         var _loc1_:uint = param1.charCodeAt(0);
         return _loc1_ >= 65 && _loc1_ < 123 || _loc1_ >= 48 && _loc1_ < 58 ? true : false;
      }

      private function isRepeat(param1:Array, param2:String) : Boolean
      {
         var _loc1_:uint = 0;
         while(_loc1_ < param1.length)
         {
            if(param1[_loc1_] == param2)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }

      public function loadGameMenu() : void
      {
         if(this.gameMenuLoader != null || this.mcGameMenu != null)
         {
            return;
         }
         if(this.world == null || this.world.objInfo == null || this.world.objInfo.gMenu == null)
         {
            return;
         }
         if(Boolean(this.gameMenuBuildPending) && this.assetsDomain != null && this.assetsDomain.hasDefinition("GameMenu"))
         {
            this.buildGameMenuInstance();
            return;
         }
         this.gameMenuURL = vurl(serverFilePath + this.world.objInfo.gMenu);
         this.gameMenuRetried = false;
         this.startGameMenuLoad(this.gameMenuURL);
      }

      private function startGameMenuLoad(param1:String) : void
      {
         var sURL:String = param1;
         trace("[UI] loadGameMenu: " + sURL);
         this.gameMenuLoader = new AirLoader();
         this.gameMenuLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.gameMenuCallBack,false,0,true);
         this.gameMenuLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.gameMenuErrorHandler,false,0,true);
         this.gameMenuLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.gameMenuErrorHandler,false,0,true);
         try
         {
            this.gameMenuLoader.load(new URLRequest(sURL),this.assetsContext);
         }
         catch(e:Error)
         {
            trace("[UI] ERR loadGameMenu: " + e.message);
            gameMenuLoader = null;
         }
      }

      private function buildGameMenuInstance() : void
      {
         try
         {
            if(this.mcGameMenu != null && this.mcGameMenu.parent != null)
            {
               this.mcGameMenu.parent.removeChild(this.mcGameMenu);
            }
         }
         catch(eR:Error)
         {
         }
         this.mcGameMenu = null;
         if(this.ui == null || this.world == null)
         {
            return;
         }
         if(this.world.myAvatar == null || this.world.myAvatar.objData == null)
         {
            this.gameMenuBuildPending = true;
            trace("[UI] gameMenu build deferred: avatar not ready");
            return;
         }
         this.gameMenuBuildPending = false;
         if(!this.assetsDomain.hasDefinition("GameMenu"))
         {
            trace("[Load] ERR missing linkage GameMenu");
            return;
         }
         try
         {
            if(this.world.objInfo != null)
            {
               delete this.world.objInfo["gameNewsJSON"];
               delete this.world.objInfo["gameNewsVersion"];
            }
         }
         catch(eN:Error)
         {
         }
         var _loc1_:* = this.assetsDomain.getDefinition("GameMenu") as Class;
         this.mcGameMenu = MovieClip(new _loc1_());
         this.mcGameMenu.name = "gameMenu";
         this.mcGameMenu.visible = this.world.strMapName != "reenstest";
         this.mcGameMenu.x = 750;
         this.ui.addChild(this.mcGameMenu);
      }

      private function gameMenuReady() : Boolean
      {
         if(this.mcGameMenu == null)
         {
            return false;
         }
         if(!("menuBG" in this.mcGameMenu))
         {
            return true;
         }
         return this.mcGameMenu.menuBG != null && this.mcGameMenu.menuBG.getChildByName("mc") != null;
      }

      public function resetGameMenu() : void
      {
         if(this.gameMenuLoader != null)
         {
            try
            {
               this.gameMenuLoader.close();
            }
            catch(eC:Error)
            {
            }
            this.gameMenuLoader = null;
         }
         this.gameMenuURL = null;
         this.gameMenuBuildPending = false;
         try
         {
            if(this.mcGameMenu != null && this.mcGameMenu.parent != null)
            {
               this.mcGameMenu.parent.removeChild(this.mcGameMenu);
            }
         }
         catch(eR:Error)
         {
         }
         this.mcGameMenu = null;
      }

      public function MenuShow() : void
      {
         try
         {
            if(this.mcGameMenu == null)
            {
               this.loadGameMenu();
               return;
            }
            if(this.mcGameMenu.currentLabel == "Open")
            {
               if(this.mcGameMenu.visible && Boolean(this.gameMenuReady()))
               {
                  this.mcGameMenu.gotoAndPlay("Close");
               }
               else
               {
                  this.buildGameMenuInstance();
               }
            }
            else
            {
               this.mcGameMenu.gotoAndStop("Open");
            }
         }
         catch(e:Error)
         {
            trace("[UI] ERR MenuShow: " + e.message);
         }
      }

      private function gameMenuCallBack(param1:Event) : void
      {
         this.gameMenuLoader = null;
         this.buildGameMenuInstance();
      }

      private function gameMenuErrorHandler(param1:ErrorEvent) : void
      {
         trace("[UI] ERR gameMenu load failed: " + param1.text);
         this.gameMenuLoader = null;
         if(!this.gameMenuRetried && this.gameMenuURL != null)
         {
            this.gameMenuRetried = true;
            this.startGameMenuLoad(this.gameMenuURL + (this.gameMenuURL.indexOf("?") < 0 ? "?r=" : "&r=") + getTimer());
         }
      }

      public function menuClose() : void
      {
         try
         {
            if(this.firstMenu)
            {
               this.firstMenu = false;
            }
            else
            {
               if(this.mcGameMenu == null || !this.gameMenuReady())
               {
                  return;
               }
               if(this.mcGameMenu.currentLabel != "Close")
               {
                  this.mcGameMenu.gotoAndPlay("Close");
               }
            }
         }
         catch(e:Error)
         {
            trace("[UI] ERR menuClose: " + e.message);
         }
      }

      public function openMenu() : void
      {
         try
         {
            if(this.mcGameMenu == null)
            {
               this.loadGameMenu();
               return;
            }
            if(this.mcGameMenu.currentLabel == "Open")
            {
               if(!this.mcGameMenu.visible || !this.gameMenuReady())
               {
                  this.buildGameMenuInstance();
               }
            }
            else
            {
               this.mcGameMenu.gotoAndStop("Open");
            }
         }
         catch(e:Error)
         {
            trace("[UI] ERR openMenu: " + e.message);
         }
      }

      public function getFilePath() : String
      {
         return serverFilePath;
      }

      public function getGamePath() : String
      {
         return serverGamePath;
      }

      public function initWorld() : void
      {
         if(this.world != null)
         {
            this.world.killTimers();
            this.world.killListeners();
            this.world.clearLoaders(true);
            this.world.clearMonstersAndProps();
            this.world.destroyAllAvatars();
            this.removeChild(this.world);
            this.world = null;
         }
         this.world = new World(MovieClip(this));
         if(this.ui != null && this.ui.parent == this)
         {
            this.addChildAt(this.world,getChildIndex(this.ui));
         }
         else
         {
            this.addChild(this.world);
         }
      }

      public function grayAll(param1:DisplayObjectContainer) : void
      {
         var _loc1_:DisplayObjectContainer = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(param1 == null)
         {
            return;
         }
         if(param1 is MovieClip && param1 != this)
         {
            (param1 as MovieClip).stop();
         }
         if(param1.numChildren)
         {
            _loc3_ = param1.numChildren;
            while(_loc2_ < _loc3_)
            {
               if(param1.getChildAt(_loc2_) is DisplayObjectContainer)
               {
                  _loc1_ = param1.getChildAt(_loc2_) as DisplayObjectContainer;
                  if(_loc1_.numChildren)
                  {
                     makeGrayscale(_loc1_);
                  }
                  else if(_loc1_ is MovieClip)
                  {
                     makeGrayscale(_loc1_ as MovieClip);
                  }
               }
               _loc2_++;
            }
         }
      }

      public function testJSCallback() : void
      {
         trace("[Game] testJSCallback: callback received from webpage");
      }

      public function onAddedToStage(param1:Event) : void
      {
         Game.root = this;
         this.registerErrorSuppression();
         this.stage.showDefaultContextMenu = false;
         stage.stageFocusRect = false;
         this.mcConnDetail = new ConnDetailMC(this);
         serverFilePath = this.params.sFilePath != null ? String(this.params.sFilePath) : this.loaderInfo.url.substring(0,this.loaderInfo.url.lastIndexOf("/") + 1);
         serverGamePath = serverFilePath.slice(0,serverFilePath.lastIndexOf("/gamefiles")) + "/";
         this.sFilePath = serverFilePath;
         trace("[Game] serverFilePath: " + serverFilePath);
         gotoAndPlay(this.charCount() > 0 && Boolean(this.litePreference.data.bCharSelect) ? "Select" : "Login");
         if(this.userPreference.data.quality != "AUTO")
         {
            stage.quality = this.userPreference.data.quality;
         }
         this.applyMaxFPS();
      }

      public function init() : void
      {
         var _loc1_:* = undefined;
         ISWEB = this.params.isWeb;
         this.extCall = new ExternalCalls(true,this.params.strSourceID,this as MovieClip);
         for(_loc1_ in this.params)
         {
         }
         if(this.MsgBox)
         {
            this.MsgBox.visible = false;
         }
         this.IsEU = this.params.isEU;
         this.readQueryString();
         if(Boolean(this.mcLogin) && Boolean(this.mcLogin.fbConnect))
         {
            this.mcLogin.fbConnect.visible = this.showFB;
         }
         this.extCall.setGameObject(this.swfObj);
         if(this.params.sURL == null)
         {
            this.params.sURL = "https://www.aq.com/game/";
         }
         this.serverPath = this.params.sURL;
         FacebookConnect.RegisterGame(this);
         if(this.params.doSignup)
         {
            this.params.doSignup = false;
            gotoAndPlay("Account");
         }
      }

      public function FBMessage(param1:*, param2:*) : *
      {
         trace("[Game] FBMessage: " + param1 + " retVal: " + param2);
         FacebookConnect.handleFBMessage(param1,param2);
      }

      public function SendMessage(param1:*, param2:*) : *
      {
      }

      public function FB_showFeedDialog(param1:String, param2:String, param3:String) : void
      {
         if(ISWEB)
         {
            this.extCall.showFeedDialog(param1,param2,param3);
         }
      }

      public function toggleFullScreen() : void
      {
         var screenRectangle:Rectangle = null;
         if(stage["displayState"] == StageDisplayState.NORMAL)
         {
            screenRectangle = new Rectangle(0,0,960,550);
            try
            {
               stage["fullScreenSourceRect"] = screenRectangle;
               stage["displayState"] = StageDisplayState.FULL_SCREEN_INTERACTIVE;
            }
            catch(error:Error)
            {
               try
               {
                  stage["displayState"] = StageDisplayState.FULL_SCREEN;
               }
               catch(errFS:Error)
               {
               }
            }
         }
         else
         {
            stage["displayState"] = StageDisplayState.NORMAL;
         }
      }

      public function showBallyhooAd(param1:String) : void
      {
         stage["displayState"] = StageDisplayState.NORMAL;
         this.extCall.showIt(param1);
      }

      public function callJSFunction(param1:String) : void
      {
         this.extCall.callJSFunction(param1);
      }

      private function readQueryString() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:Array = null;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         try
         {
            _loc1_ = "";
            if(ISWEB)
            {
               _loc1_ = this.extCall.getQueryString();
            }
            if(_loc1_)
            {
               _loc2_ = _loc1_.split("&");
               _loc3_ = 0;
               _loc4_ = -1;
               while(_loc3_ < _loc2_.length)
               {
                  _loc5_ = _loc2_[_loc3_];
                  _loc4_ = _loc5_.indexOf("=");
                  if(_loc4_ > 0)
                  {
                     _loc6_ = _loc5_.substring(0,_loc4_);
                     _loc7_ = _loc5_.substring(_loc4_ + 1);
                     this.querystring[_loc6_] = _loc7_;
                  }
                  _loc3_++;
               }
            }
         }
         catch(e:Error)
         {
         }
      }

      public function initLogin() : void
      {
         var curTS:Number = NaN;
         var iDiff:Number = NaN;
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.key_StageLogin);
         this.mcLogin.ni.tabIndex = 1;
         this.mcLogin.pi.tabIndex = 2;
         this.mcLogin.ni.removeEventListener(FocusEvent.FOCUS_IN,this.onUserFocus);
         this.mcLogin.ni.removeEventListener(KeyboardEvent.KEY_DOWN,this.key_TextLogin);
         this.mcLogin.pi.removeEventListener(KeyboardEvent.KEY_DOWN,this.key_TextLogin);
         this.mcLogin.btnLogin.removeEventListener(MouseEvent.CLICK,this.onLoginClick);
         this.mcLogin.btnFBLogin.removeEventListener(MouseEvent.CLICK,this.onFBLoginClick);
         this.mcLogin.mcForgotPassword.removeEventListener(MouseEvent.CLICK,this.onForgotPassword);
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.key_StageLogin);
         this.mcLogin.ni.addEventListener(FocusEvent.FOCUS_IN,this.onUserFocus);
         this.mcLogin.ni.addEventListener(KeyboardEvent.KEY_DOWN,this.key_TextLogin);
         this.mcLogin.pi.addEventListener(KeyboardEvent.KEY_DOWN,this.key_TextLogin);
         this.mcLogin.btnLogin.addEventListener(MouseEvent.CLICK,this.onLoginClick);
         this.mcLogin.btnFBLogin.addEventListener(MouseEvent.CLICK,this.onFBLoginClick);
         this.mcLogin.mcForgotPassword.addEventListener(MouseEvent.CLICK,this.onForgotPassword);
         this.mcLogin.mcManageAccount.addEventListener(MouseEvent.CLICK,this.onManageClick);
         this.loadUserPreference();
         this.mcLogin.warning.s = String("Sorry! You have been disconnected. \n You will be able to login after $s seconds.");
         this.mcLogin.warning.visible = false;
         this.mcLogin.warning.alpha = 0;
         if(this.params.sURL != null)
         {
            this.mcLogin.mcLogo.txtTitle.htmlText = "<font color=\"#FFB231\">New Release:</font> " + this.params.sTitle;
         }
         if("logoutWarningTS" in this.userPreference.data)
         {
            curTS = new Date().getTime();
            iDiff = this.userPreference.data.logoutWarningTS + this.userPreference.data.logoutWarningDur * 1000 - curTS;
            if(iDiff > 60000)
            {
               this.userPreference.data.logoutWarningDur = 60;
               this.userPreference.data.logoutWarningTS = curTS;
               try
               {
                  this.userPreference.flush();
               }
               catch(e:Error)
               {
                  trace("[Game] ERR userPreference flush: " + e.message);
               }
            }
            if(iDiff > 1000)
            {
               this.initLoginWarning();
            }
         }
      }

      public function onBtnDn(param1:MouseEvent) : void
      {
         var _loc1_:String = null;
         _loc1_ = this.params.test ? "https://www.aq.com/gamedesignnotes/AQW-Spider-OMGClient-PatchNotess-8456" : "https://www.aq.com/gamedesignnotes/AQW-Spider-AQWClient2-PatchNotes-8484";
         navigateToURL(new URLRequest(_loc1_),"_blank");
      }

      public function loadTitle() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         _loc1_ = "Generic2.swf";
         _loc2_ = "The Skyguard";
         _loc3_ = "https://www.aq.com/game/";
         if(this.params.sURL != null)
         {
            _loc3_ = this.params.sURL;
            _loc1_ = this.params.sBG;
            _loc2_ = this.params.sTitle;
         }
         else
         {
            this.params.sURL = _loc3_;
         }
         trace("[Load] LoadBG: sURL: " + _loc3_ + " sBG: " + _loc1_);
         BGLoader.LoadBG(_loc3_,this.mcLogin,_loc1_,_loc2_);
         this.mcLogin.testClientAssets.visible = false;
         this.mcLogin.testClientAssets.cVersion.text = "Version " + this.cVersion;
         this.mcLogin.testClientAssets.dnBtn.addEventListener(MouseEvent.CLICK,this.onBtnDn,false,0,true);
         this.mcLogin.testClientAssets.banner.visible = this.params.test as Boolean;
      }

      private function initLoginWarning() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         _loc1_ = this.mcLogin.warning as MovieClip;
         _loc1_.visible = true;
         _loc1_.alpha = 100;
         this.mcLogin.btnLogin.visible = false;
         this.mcLogin.mcOr.visible = false;
         this.mcLogin.btnFBLogin.visible = false;
         this.mcLogin.mcForgotPassword.visible = false;
         this.mcLogin.mcPassword.visible = false;
         _loc2_ = new Date().getTime();
         _loc3_ = Number(this.userPreference.data.logoutWarningTS);
         _loc4_ = Number(this.userPreference.data.logoutWarningDur);
         _loc1_.n = Math.round((_loc3_ + _loc4_ * 1000 - _loc2_) / 1000);
         _loc1_.ti.text = _loc1_.s.split("$s")[0] + _loc1_.n + _loc1_.s.split("$s")[1];
         _loc1_.timer = new Timer(1000);
         _loc1_.timer.addEventListener(TimerEvent.TIMER,this.loginWarningTimer,false,0,true);
         _loc1_.timer.start();
      }

      private function loginWarningTimer(param1:TimerEvent) : void
      {
         var _loc1_:MovieClip = null;
         _loc1_ = this.mcLogin.warning as MovieClip;
         if(_loc1_.n-- < 1)
         {
            _loc1_.visible = false;
            _loc1_.alpha = 0;
            this.mcLogin.mcPassword.visible = true;
            this.mcLogin.btnLogin.visible = true;
            this.mcLogin.mcOr.visible = true;
            this.mcLogin.btnFBLogin.visible = true;
            this.mcLogin.mcForgotPassword.visible = true;
            _loc1_.timer.removeEventListener(TimerEvent.TIMER,this.loginWarningTimer);
         }
         else
         {
            _loc1_.ti.text = _loc1_.s.split("$s")[0] + _loc1_.n + _loc1_.s.split("$s")[1];
            _loc1_.timer.reset();
            _loc1_.timer.start();
         }
      }

      private function onFocusGuardRemoved(param1:Event) : void
      {
         var _loc1_:InteractiveObject = null;
         var _loc2_:DisplayObject = null;
         if(Boolean(this.focusGuardPending) || stage == null)
         {
            return;
         }
         _loc1_ = stage.focus;
         if(_loc1_ == null)
         {
            return;
         }
         _loc2_ = param1.target as DisplayObject;
         if(_loc2_ == null)
         {
            return;
         }
         if(_loc2_ == _loc1_ || _loc2_ is DisplayObjectContainer && Boolean(DisplayObjectContainer(_loc2_).contains(_loc1_)))
         {
            this.focusGuardPending = true;
            stage.addEventListener(Event.ENTER_FRAME,this.onFocusGuardFrame,false,0,true);
         }
      }

      private function onFocusGuardFrame(param1:Event) : void
      {
         var _loc1_:InteractiveObject = null;
         if(stage == null)
         {
            return;
         }
         stage.removeEventListener(Event.ENTER_FRAME,this.onFocusGuardFrame);
         this.focusGuardPending = false;
         _loc1_ = stage.focus;
         if(_loc1_ != null && _loc1_.stage == null)
         {
            stage.focus = stage;
         }
      }

      private function onFocusGuardMouse(param1:MouseEvent) : void
      {
         var _loc1_:InteractiveObject = null;
         if(stage == null)
         {
            return;
         }
         _loc1_ = stage.focus;
         if(_loc1_ != null && _loc1_.stage == null)
         {
            stage.focus = stage;
         }
      }

      private function onStageLeave(param1:Event) : void
      {
         stage.focus = null;
      }

      private function initInterface() : *
      {
         var _loc1_:int = 0;
         var _loc2_:* = undefined;
         this.updateCoreValues(this.coreValues);
         if(this.ctr_watermark != null)
         {
            this.ctr_watermark.visible = false;
            this.ctr_watermark.mouseEnabled = this.ctr_watermark.mouseChildren = false;
         }
         if(this.ui == null)
         {
            trace("[UI] ERR initInterface: ui is null");
            return;
         }
         if(this.world != null && this.world.parent == this && this.ui.parent == this && getChildIndex(this.world) > getChildIndex(this.ui))
         {
            setChildIndex(this.world,getChildIndex(this.ui));
         }
         if(this.ui.mcFPS != null)
         {
            this.ui.mcFPS.visible = false;
         }
         if(this.ui.mcRes != null)
         {
            this.ui.mcRes.visible = false;
         }
         if(this.ui.mcPopup != null)
         {
            this.ui.mcPopup.visible = false;
         }
         if(this.ui.mcPortrait != null)
         {
            this.ui.mcPortrait.visible = false;
            if(this.ui.mcPortrait.iconBoostXP != null)
            {
               this.ui.mcPortrait.iconBoostXP.visible = false;
            }
            if(this.ui.mcPortrait.iconBoostG != null)
            {
               this.ui.mcPortrait.iconBoostG.visible = false;
            }
            if(this.ui.mcPortrait.iconBoostRep != null)
            {
               this.ui.mcPortrait.iconBoostRep.visible = false;
            }
            if(this.ui.mcPortrait.iconBoostCP != null)
            {
               this.ui.mcPortrait.iconBoostCP.visible = false;
            }
         }
         this.hidePortraitTarget();
         this.ui.visible = false;
         if(this.ui.mcInterface != null)
         {
            if(this.ui.mcInterface.mcXPBar != null && this.ui.mcInterface.mcXPBar.mcXP != null)
            {
               this.ui.mcInterface.mcXPBar.mcXP.scaleX = 0;
            }
            if(this.ui.mcInterface.mcRepBar != null && this.ui.mcInterface.mcRepBar.mcRep != null)
            {
               this.ui.mcInterface.mcRepBar.mcRep.scaleX = 0;
            }
         }
         if(this.ui.mcUpdates != null)
         {
            if(this.ui.mcUpdates.uproto != null)
            {
               this.ui.mcUpdates.uproto.visible = false;
               this.ui.mcUpdates.uproto.y = -400;
            }
            this.ui.mcUpdates.mouseChildren = this.ui.mcUpdates.mouseEnabled = false;
         }
         this.hideMCPVPQueue();
         if(stage != null)
         {
            stage.removeEventListener(Event.MOUSE_LEAVE,this.onStageLeave);
            stage.removeEventListener(KeyboardEvent.KEY_UP,this.key_actBar);
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.key_StageGame);
         }
         if(this.ui.mcInterface != null)
         {
            if(this.ui.mcInterface.mcXPBar != null)
            {
               this.ui.mcInterface.mcXPBar.removeEventListener(MouseEvent.MOUSE_OVER,this.xpBarMouseOver);
               this.ui.mcInterface.mcXPBar.removeEventListener(MouseEvent.MOUSE_OUT,this.xpBarMouseOut);
            }
            if(this.ui.mcInterface.mcRepBar != null)
            {
               this.ui.mcInterface.mcRepBar.removeEventListener(MouseEvent.MOUSE_OVER,this.onRepBarMouseOver);
               this.ui.mcInterface.mcRepBar.removeEventListener(MouseEvent.MOUSE_OUT,this.onRepBarMouseOut);
            }
         }
         if(this.ui.mcPortraitTarget != null)
         {
            this.ui.mcPortraitTarget.removeEventListener(MouseEvent.CLICK,this.portraitClick);
         }
         if(this.ui.mcPortrait != null)
         {
            this.ui.mcPortrait.removeEventListener(MouseEvent.CLICK,this.portraitClick);
            if(this.ui.mcPortrait.iconBoostXP != null)
            {
               this.ui.mcPortrait.iconBoostXP.removeEventListener(MouseEvent.MOUSE_OVER,this.oniconBoostXPOver);
               this.ui.mcPortrait.iconBoostXP.removeEventListener(MouseEvent.MOUSE_OUT,this.oniconBoostOut);
            }
            if(this.ui.mcPortrait.iconBoostG != null)
            {
               this.ui.mcPortrait.iconBoostG.removeEventListener(MouseEvent.MOUSE_OVER,this.oniconBoostGoldOver);
               this.ui.mcPortrait.iconBoostG.removeEventListener(MouseEvent.MOUSE_OUT,this.oniconBoostOut);
            }
            if(this.ui.mcPortrait.iconBoostRep != null)
            {
               this.ui.mcPortrait.iconBoostRep.removeEventListener(MouseEvent.MOUSE_OVER,this.oniconBoostRepOver);
               this.ui.mcPortrait.iconBoostRep.removeEventListener(MouseEvent.MOUSE_OUT,this.oniconBoostOut);
            }
            if(this.ui.mcPortrait.iconBoostCP != null)
            {
               this.ui.mcPortrait.iconBoostCP.removeEventListener(MouseEvent.MOUSE_OVER,this.oniconBoostCPOver);
               this.ui.mcPortrait.iconBoostCP.removeEventListener(MouseEvent.MOUSE_OUT,this.oniconBoostOut);
            }
         }
         if(this.ui.btnTargetPortraitClose != null)
         {
            this.ui.btnTargetPortraitClose.removeEventListener(MouseEvent.CLICK,this.onTargetPortraitCloseClick);
         }
         if(this.ui.btnMonster != null)
         {
            this.ui.btnMonster.removeEventListener(MouseEvent.CLICK,this.onBtnMonsterClick);
         }
         if(this.ui.mcPVPQueue != null)
         {
            this.ui.mcPVPQueue.removeEventListener(MouseEvent.CLICK,this.onMCPVPQueueClick);
         }
         if(this.ui.mcInterface != null && this.ui.mcInterface.tl != null)
         {
            this.ui.mcInterface.tl.mouseEnabled = false;
         }
         if(this.chatF != null)
         {
            this.chatF.init();
         }
         if(stage != null)
         {
            stage.addEventListener(Event.MOUSE_LEAVE,this.onStageLeave,false,0,true);
            stage.addEventListener(KeyboardEvent.KEY_UP,this.key_actBar,false,0,true);
            Mobile.init(this);
            MoveInput.init(this);
            GamePad.init(this);
            stage.addEventListener(Event.REMOVED,this.onFocusGuardRemoved,true,0,true);
            stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onFocusGuardMouse,true,0,true);
         }
         if(this.ui.mcInterface != null)
         {
            if(this.ui.mcInterface.mcXPBar != null)
            {
               if(this.ui.mcInterface.mcXPBar.strXP != null)
               {
                  this.ui.mcInterface.mcXPBar.strXP.visible = false;
               }
               this.ui.mcInterface.mcXPBar.addEventListener(MouseEvent.MOUSE_OVER,this.xpBarMouseOver,false,0,true);
               this.ui.mcInterface.mcXPBar.addEventListener(MouseEvent.MOUSE_OUT,this.xpBarMouseOut,false,0,true);
            }
            if(this.ui.mcInterface.mcRepBar != null)
            {
               if(this.ui.mcInterface.mcRepBar.strRep != null)
               {
                  this.ui.mcInterface.mcRepBar.strRep.visible = false;
               }
               this.ui.mcInterface.mcRepBar.addEventListener(MouseEvent.MOUSE_OVER,this.onRepBarMouseOver,false,0,true);
               this.ui.mcInterface.mcRepBar.addEventListener(MouseEvent.MOUSE_OUT,this.onRepBarMouseOut,false,0,true);
            }
         }
         if(this.ui.mcPortraitTarget != null)
         {
            this.ui.mcPortraitTarget.addEventListener(MouseEvent.CLICK,this.portraitClick,false,0,true);
         }
         if(this.ui.mcPortrait != null)
         {
            this.ui.mcPortrait.addEventListener(MouseEvent.CLICK,this.portraitClick,false,0,true);
            if(this.ui.mcPortrait.iconBoostXP != null)
            {
               this.ui.mcPortrait.iconBoostXP.addEventListener(MouseEvent.MOUSE_OVER,this.oniconBoostXPOver,false,0,true);
               this.ui.mcPortrait.iconBoostXP.addEventListener(MouseEvent.MOUSE_OUT,this.oniconBoostOut,false,0,true);
            }
            if(this.ui.mcPortrait.iconBoostG != null)
            {
               this.ui.mcPortrait.iconBoostG.addEventListener(MouseEvent.MOUSE_OVER,this.oniconBoostGoldOver,false,0,true);
               this.ui.mcPortrait.iconBoostG.addEventListener(MouseEvent.MOUSE_OUT,this.oniconBoostOut,false,0,true);
            }
            if(this.ui.mcPortrait.iconBoostRep != null)
            {
               this.ui.mcPortrait.iconBoostRep.addEventListener(MouseEvent.MOUSE_OVER,this.oniconBoostRepOver,false,0,true);
               this.ui.mcPortrait.iconBoostRep.addEventListener(MouseEvent.MOUSE_OUT,this.oniconBoostOut,false,0,true);
            }
            if(this.ui.mcPortrait.iconBoostCP != null)
            {
               this.ui.mcPortrait.iconBoostCP.addEventListener(MouseEvent.MOUSE_OVER,this.oniconBoostCPOver,false,0,true);
               this.ui.mcPortrait.iconBoostCP.addEventListener(MouseEvent.MOUSE_OUT,this.oniconBoostOut,false,0,true);
            }
         }
         if(this.ui.btnTargetPortraitClose != null)
         {
            this.ui.btnTargetPortraitClose.addEventListener(MouseEvent.CLICK,this.onTargetPortraitCloseClick,false,0,true);
         }
         if(this.ui.btnMonster != null)
         {
            this.ui.btnMonster.addEventListener(MouseEvent.CLICK,this.onBtnMonsterClick,false,0,true);
         }
         if(this.ui.mcPVPQueue != null)
         {
            this.ui.mcPVPQueue.addEventListener(MouseEvent.CLICK,this.onMCPVPQueueClick,false,0,true);
         }
         if(this.ui.iconQuest != null)
         {
            this.ui.iconQuest.visible = false;
            this.ui.iconQuest.buttonMode = true;
            this.ui.iconQuest.addEventListener(MouseEvent.CLICK,this.oniconQuestClick,false,0,true);
         }
         if(this.ui.mcInterface != null)
         {
            if(this.ui.mcInterface.tl != null)
            {
               this.ui.mcInterface.tl.mouseEnabled = false;
            }
            if(this.ui.mcInterface.areaList != null)
            {
               this.ui.mcInterface.areaList.mouseEnabled = false;
               if(this.ui.mcInterface.areaList.title != null)
               {
                  this.ui.mcInterface.areaList.title.mouseEnabled = false;
                  if(this.ui.mcInterface.areaList.title.bMinMax != null)
                  {
                     this.ui.mcInterface.areaList.title.bMinMax.addEventListener(MouseEvent.CLICK,this.areaListClick,false,0,true);
                  }
               }
            }
         }
         if(this.litePreference.data.bCustomDrops)
         {
            if(this.cDropsUI)
            {
               this.cDropsUI.cleanup();
            }
            this.cDropsUI = new customDrops(this);
         }
         if(this.litePreference.data.bDebugger)
         {
            if(this.cMenuUI)
            {
               this.cMenuUI.cleanup();
            }
            this.cMenuUI = new cellMenu(this);
            if(this.pLoggerUI)
            {
               this.pLoggerUI.cleanup();
            }
            if(this.litePreference.data.dOptions["debugPacket"])
            {
               this.pLoggerUI = new packetlogger(this);
            }
         }
         if(this.pAurasUI)
         {
            this.pAurasUI.cleanup();
         }
         if(this.tAurasUI)
         {
            this.tAurasUI.cleanup();
         }
         this.pAurasUI = null;
         this.tAurasUI = null;
         if(this.litePreference.data.bAuras)
         {
            this.pAurasUI = new playerAuras(this);
            this.tAurasUI = new targetAuras(this);
         }
         if(this.partyDrag)
         {
            this.partyDrag.detach();
         }
         this.partyDrag = this.ui.mcPartyFrame != null ? new HudDrag(this.ui.mcPartyFrame,this,"posParty",{
            "backdrop":true,
            "caption":"YOUR PARTY",
            "measure":this.partyBounds,
            "bottom":488
         }) : null;
         if(this.intChatMode)
         {
            this.ui.mcInterface.bMinMax.visible = false;
            this.ui.mcInterface.bShortTall.visible = false;
            this.ui.mcInterface.bCannedChat.visible = false;
            this.ui.mcInterface.tt.visible = false;
            this.ui.mcInterface.tebg.visible = false;
            this.ui.mcInterface.bsend.visible = false;
            this.ui.nc.visible = true;
            this.ui.mcInterface.ncModeChat.visible = true;
            this.ui.mcInterface.ncCannedChat.visible = true;
            this.ui.mcInterface.ncHistory.visible = true;
            this.ui.mcInterface.ncTxtBG.visible = true;
            this.ui.mcInterface.ncPrefix.visible = true;
            this.ui.mcInterface.ncText.visible = true;
            this.ui.mcInterface.ncSendText.visible = true;
         }
         else
         {
            this.ui.mcInterface.bMinMax.visible = true;
            this.ui.mcInterface.bShortTall.visible = true;
            this.ui.mcInterface.bCannedChat.visible = true;
            this.ui.mcInterface.tt.visible = true;
            this.ui.mcInterface.tebg.visible = true;
            this.ui.mcInterface.bsend.visible = true;
            this.ui.nc.visible = false;
            this.ui.mcInterface.ncModeChat.visible = false;
            this.ui.mcInterface.ncCannedChat.visible = false;
            this.ui.mcInterface.ncHistory.visible = false;
            this.ui.mcInterface.ncTxtBG.visible = false;
            this.ui.mcInterface.ncPrefix.visible = false;
            this.ui.mcInterface.ncText.visible = false;
            this.ui.mcInterface.ncSendText.visible = false;
         }
         this.keyDict = this.getKeyboardDict();
         _loc1_ = 0;
         while(_loc1_ < 6)
         {
            _loc2_ = this.ui.mcInterface.getChildByName("keyA" + _loc1_);
            if(_loc1_ == 0)
            {
               _loc2_.text = !this.litePreference.data.keys["Auto Attack"] ? " " : this.keyDict[this.litePreference.data.keys["Auto Attack"]];
            }
            else
            {
               _loc2_.text = !this.litePreference.data.keys["Skill " + _loc1_] ? " " : this.keyDict[this.litePreference.data.keys["Skill " + _loc1_]];
            }
            _loc2_.mouseEnabled = false;
            _loc1_++;
         }
         if(this.world != null && this.world.myAvatar != null && this.world.myAvatar.objData != null)
         {
            this.updateXPBar();
            this.updateRepBar();
            this.setGoldDisplay(this.world.myAvatar.objData.intGold);
         }
      }

      public function traceHack(param1:String) : void
      {
         this.chatF.pushMsg("server",param1,"SERVER","",0);
      }

      private function onUserFocus(param1:FocusEvent) : *
      {
         if(this.mcLogin.ni.text == "click here")
         {
            this.mcLogin.ni.text = "";
         }
      }

      private function loadUserPreference() : *
      {
         if(this.userPreference.data.bitCheckedUsername)
         {
            this.mcLogin.ni.text = this.TempLoginName != "" ? this.TempLoginName : this.userPreference.data.strUsername;
            this.mcLogin.chkUserName.bitChecked = true;
         }
         if(this.userPreference.data.bitCheckedPassword)
         {
            this.mcLogin.pi.text = this.TempLoginPass != "" ? this.TempLoginPass : this.userPreference.data.strPassword;
            this.mcLogin.chkPassword.bitChecked = true;
         }
         this.mcLogin.chkUserName.checkmark.visible = this.mcLogin.chkUserName.bitChecked;
         this.mcLogin.chkPassword.checkmark.visible = this.mcLogin.chkPassword.bitChecked;
      }

      private function saveUserPreference() : *
      {
         this.userPreference.data.bitCheckedUsername = this.mcLogin.chkUserName.bitChecked;
         this.userPreference.data.bitCheckedPassword = this.mcLogin.chkPassword.bitChecked;
         if(this.mcLogin.chkUserName.bitChecked)
         {
            this.userPreference.data.strUsername = this.mcLogin.ni.text;
         }
         else
         {
            this.userPreference.data.strUsername = "";
         }
         if(this.mcLogin.chkPassword.bitChecked)
         {
            this.userPreference.data.strPassword = this.mcLogin.pi.text;
         }
         else
         {
            this.userPreference.data.strPassword = "";
         }
         try
         {
            this.userPreference.flush();
         }
         catch(e:Error)
         {
            trace("[Game] ERR saveUserPreference: flush: " + e.message);
         }
      }

      private function onCreateNewAccount(param1:MouseEvent) : void
      {
         this.mixer.playSound("Click");
         gotoAndPlay("Account");
      }

      private function onForgotPassword(param1:MouseEvent) : void
      {
         navigateToURL(new URLRequest("https://account.aq.com/Login/Forgot"));
      }

      private function onManageClick(param1:MouseEvent) : void
      {
         navigateToURL(new URLRequest("https://account.aq.com/"));
      }

      private function onAccountRecovery(param1:MouseEvent) : void
      {
         this.mixer.playSound("Click");
         navigateToURL(new URLRequest("https://www.aq.com/help/aw-account-recovery.asp"));
      }

      private function onLoginClick(param1:MouseEvent) : void
      {
         if("btnLogin" in this.mcLogin && Boolean(this.mcLogin.btnLogin.visible))
         {
            if(this.mcLogin.ni.text != "" && this.mcLogin.pi.text != "")
            {
               try
               {
                  this.saveUserPreference();
               }
               catch(e:*)
               {
               }
               if(FacebookConnect.isLoggedIn)
               {
                  FacebookConnect.Logout();
               }
               this.login(this.mcLogin.ni.text.toLowerCase(),this.mcLogin.pi.text);
            }
         }
      }

      public function CallFBConnect(param1:Function) : void
      {
         this.addEventListener(FacebookConnectEvent.ONCONNECT,this.FBLoginCreate);
         this.FBConnectCallback = param1;
         FacebookConnect.RequestFBConnect();
      }

      public function GetFBMe() : Object
      {
         return FacebookConnect.Me;
      }

      public function isFBLoggedIn() : Boolean
      {
         return FacebookConnect.isLoggedIn;
      }

      public function FBIP() : String
      {
         return FacebookConnect.IPAddr;
      }

      public function GetFBToken() : String
      {
         return FacebookConnect.AccessToken;
      }

      private function onFBLoginClick(param1:MouseEvent) : void
      {
         navigateToURL(new URLRequest("https://account.aq.com/login/facebookinfo"),"_blank");
      }

      public function FBLogin(param1:FacebookConnectEvent) : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:URLRequest = null;
         var _loc3_:URLVariables = null;
         var _loc4_:URLLoader = null;
         this.removeEventListener(FacebookConnectEvent.ONCONNECT,this.FBLogin);
         if(param1.params.success)
         {
            this.params.FBID = FacebookConnect.Me.id;
            this.params.token = FacebookConnect.AccessToken;
            _loc1_ = Number(this.rn.rand());
            this.mcConnDetail.showConn("Loading Server List...");
            _loc2_ = new URLRequest(this.params.loginURL);
            _loc3_ = new URLVariables();
            _loc3_.fbid = FacebookConnect.Me.id;
            _loc3_.fbtoken = FacebookConnect.AccessToken;
            FacebookConnect.isLoggedIn = true;
            _loc2_.data = _loc3_;
            _loc2_.method = URLRequestMethod.POST;
            _loc4_ = new URLLoader();
            _loc4_.addEventListener(Event.COMPLETE,this.onLoginComplete);
            _loc4_.load(_loc2_);
         }
         else
         {
            this.mcConnDetail.showError(param1.params.message);
         }
      }

      public function FBLoginCreate(param1:FacebookConnectEvent) : void
      {
         var fbevt:FacebookConnectEvent = param1;
         this.removeEventListener(FacebookConnectEvent.ONCONNECT,this.FBLoginCreate);
         if(this.FBConnectCallback != null)
         {
            try
            {
               this.FBConnectCallback();
            }
            catch(e:Error)
            {
               trace("[Game] ERR FBConnectCallback: " + e.message);
            }
         }
         this.FBConnectCallback = null;
      }

      public function getFBUser() : void
      {
         if(ISWEB)
         {
            this.extCall.getFBUser();
         }
      }

      public function login(param1:String, param2:String) : *
      {
         var rand:Number = NaN;
         var url:String = null;
         var request:URLRequest = null;
         var variables:URLVariables = null;
         var strUsername:String = param1;
         var strPassword:String = param2;
         var arrAllowLocal:Array = new Array("zhoom","ztest00","ztest01","ztest02","iterator","zdhz","yorumi");
         this.mcConnDetail.showConn("Authenticating Account Info...");
         loginInfo.strUsername = strUsername;
         loginInfo.strPassword = strPassword;
         rand = Number(this.rn.rand());
         url = "cf-userlogin.asp?ran=" + rand;
         url = this.params.loginURL + "?ran=" + rand;
         trace("[Game] LoginURL: " + url);
         request = new URLRequest(url);
         variables = new URLVariables();
         variables.user = strUsername;
         variables.pass = strPassword;
         variables.option = ISWEB ? "0" : "1";
         if(this.checkPasswordStrength(strPassword) < 18)
         {
            this.bPassword = false;
         }
         if(this.params.strSourceID == "FACEBOOK")
         {
            variables.strSourceID = this.params.strSourceID;
            variables.fbid = this.params.FBID;
            variables.fbtoken = this.params.token;
         }
         else if(this.params.strSourceID == "TAGGED")
         {
            variables.strSourceID = this.params.strSourceID;
            variables.SrcUserID = this.params.SrcUserID;
            variables.token = this.params.token;
         }
         request.data = variables;
         request.method = URLRequestMethod.POST;
         this.loginLoader.removeEventListener(Event.COMPLETE,this.onLoginComplete);
         this.loginLoader.addEventListener(Event.COMPLETE,this.onLoginComplete);
         this.loginLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onLoginError,false,0,true);
         try
         {
            this.loginLoader.load(request);
         }
         catch(error:Error)
         {
            trace("[Game] ERR login: unable to load URL: " + error.message);
         }
      }

      public function onLoginError(param1:Event) : void
      {
         trace("[Game] ERR onLoginError: " + param1);
      }

      public function onLoginComplete(param1:Event) : void
      {
         var _obj:Object = null;
         var event:Event = param1;
         trace("[Game] LoginComplete");
         try
         {
            _obj = JSON.parse(event.target.data);
            if(_obj.login)
            {
               objLogin = _obj.login;
               objLogin.servers = _obj.servers;
               this.playerPollData = _obj.polldata;
            }
            else
            {
               objLogin = _obj;
            }
            this.loginLoader.removeEventListener(Event.COMPLETE,this.onLoginComplete);
            if(objLogin.bSuccess == 1)
            {
               try
               {
                  loginInfo.strUsername = objLogin.unm.toLowerCase();
               }
               catch(e:*)
               {
                  trace("[Game] ERR LoginComplete: loginInfo.strUsername null");
               }
               if(loginInfo.strUsername != null)
               {
                  if(loginInfo.strUsername.toLowerCase() == "iterator" || loginInfo.strUsername.toLowerCase() == "iterator2" || loginInfo.strUsername.toLowerCase() == "iterator3" || loginInfo.strUsername.toLowerCase() == "iterator4")
                  {
                     this.serialCmdMode = true;
                  }
                  else
                  {
                     this.serialCmdMode = false;
                  }
               }
               else
               {
                  this.serialCmdMode = false;
               }
               if(objLogin.FBID != null)
               {
                  if(FacebookConnect.Me == null)
                  {
                     FacebookConnect.Me = new Object();
                  }
                  FacebookConnect.Me.id = objLogin.FBID;
                  if(objLogin.FBName != null)
                  {
                     FacebookConnect.Me.name = objLogin.FBName;
                  }
               }
               if(this.fbL != null)
               {
                  this.fbL.destroy();
               }
               if(ISWEB)
               {
                  this.extCall.getFBUser();
               }
               this.mcConnDetail.hideConn();
               loginInfo.strToken = objLogin.sToken;
               this.sToken = loginInfo.strToken;
               strToken = loginInfo.strToken;
               if(ISWEB)
               {
                  this.extCall.setToken(loginInfo);
               }
               if(this.serialCmdMode)
               {
                  this.mcLogin.testClientAssets.visible = false;
                  this.mcLogin.gotoAndStop("Iterator");
               }
               else
               {
                  this.mcLogin.gotoAndStop("Servers");
               }
            }
            else if(objLogin.sMsg.indexOf("Facebook") > -1)
            {
               this.mcConnDetail.hideConn();
               this.fbL = new fbLinkWindow(this.mcLogin.fbConnect,this as MovieClip);
               this.mcLogin.fbConnect.visible = true;
            }
            else
            {
               this.mcConnDetail.showError(objLogin.sMsg);
            }
         }
         catch(e:*)
         {
            trace("[Game] ERR LoginComplete: " + e);
         }
         this.resetsOnNewSession();
      }

      public function resetsOnNewSession() : void
      {
         if(this.extCall == null)
         {
            this.init();
         }
         if(Boolean(this.litePreference.data.bDebugger) && objLogin.iAccess < 30)
         {
            optionHandler.cmd(MovieClip(this),"@ Debugger");
         }
      }

      public function deepCopy(param1:*, param2:*) : void
      {
         var _loc1_:* = undefined;
         for(var _loc2_ in param2)
         {
            _loc1_ = _loc2_;
            _loc2_;
            if(typeof (param2 as Object)[_loc1_] == "object")
            {
               (param1 as Object)[_loc1_] = new Object();
               this.deepCopy((param1 as Object)[_loc1_],(param2 as Object)[_loc1_]);
            }
            else if((param2 as Object)[_loc1_])
            {
               (param1 as Object)[_loc1_] = (param2 as Object)[_loc1_];
            }
         }
      }

      public function deepCopyArr(param1:*, param2:*) : void
      {
         var _loc1_:* = undefined;
         for each(var _loc2_ in param2)
         {
            _loc1_ = _loc2_;
            _loc2_;
            param1.push(_loc1_);
         }
      }

      public function saveChar() : void
      {
         var _loc1_:Object = null;
         var _loc2_:* = 0;
         var _loc3_:* = undefined;
         var _loc4_:Object = null;
         if(this.characters == null || FacebookConnect.isLoggedIn || !this.litePreference.data.bCharSelect)
         {
            return;
         }
         _loc1_ = new Object();
         _loc1_["strGender"] = this.world.myAvatar.objData.strGender;
         _loc1_["strHairFilename"] = this.world.myAvatar.objData.strHairFilename;
         _loc1_["strHairName"] = this.world.myAvatar.objData.strHairName;
         _loc1_["eqp"] = {};
         this.deepCopy(_loc1_["eqp"],this.world.myAvatar.objData.eqp);
         _loc1_["intGold"] = this.world.myAvatar.objData.intGold;
         _loc1_["intCoins"] = this.world.myAvatar.objData.intCoins;
         _loc1_["strClassName"] = this.world.myAvatar.objData.strClassName;
         _loc1_["iCP"] = this.world.myAvatar.objData.iCP;
         _loc1_["intLevel"] = this.world.myAvatar.objData.intLevel;
         _loc1_["strUsername"] = this.world.myAvatar.objData.strUsername;
         _loc1_["intAccessLevel"] = this.world.myAvatar.objData.intAccessLevel;
         _loc1_["iUpgDays"] = this.world.myAvatar.objData.iUpgDays;
         _loc1_["intColorSkin"] = this.world.myAvatar.objData.intColorSkin;
         _loc1_["intColorHair"] = this.world.myAvatar.objData.intColorHair;
         _loc1_["intColorEye"] = this.world.myAvatar.objData.intColorEye;
         _loc1_["intColorBase"] = this.world.myAvatar.objData.intColorBase;
         _loc1_["intColorTrim"] = this.world.myAvatar.objData.intColorTrim;
         _loc1_["intColorAccessory"] = this.world.myAvatar.objData.intColorAccessory;
         if(this.world.myAvatar.objData.guild != null)
         {
            _loc1_["guild"] = {};
            _loc1_["guild"]["Name"] = this.world.myAvatar.objData.guild.Name;
         }
         _loc1_["showHelm"] = this.world.myAvatar.dataLeaf.showHelm;
         _loc1_["showCloak"] = this.world.myAvatar.dataLeaf.showCloak;
         if(Boolean(this.characters.data.users) && Boolean(this.characters.data.users[this.world.myAvatar.pnm.toLowerCase()]))
         {
            (this.characters.data.users[this.world.myAvatar.pnm.toLowerCase()] as Object).data = _loc1_;
            (this.characters.data.users[this.world.myAvatar.pnm.toLowerCase()] as Object).server = this.objServerInfo.sName;
         }
         else
         {
            _loc2_ = 0;
            for(var _loc5_ in this.characters.data.users)
            {
               _loc3_ = _loc5_;
               _loc5_;
               _loc2_++;
            }
            if(_loc2_ >= 5)
            {
               return;
            }
            (loginInfo as Object).bAsk = false;
            _loc4_ = new Object();
            this.deepCopy(_loc4_,loginInfo);
            this.characters.data.users[this.world.myAvatar.pnm.toLowerCase()] = {
               "index":-1,
               "data":_loc1_,
               "server":this.objServerInfo.sName,
               "loginInfo":_loc4_
            };
         }
         this.characters.flush();
      }

      public function charCount() : int
      {
         var _loc1_:* = 0;
         var _loc2_:* = undefined;
         if(this.characters == null)
         {
            return 0;
         }
         if(!this.characters.data.users)
         {
            this.characters.data.users = new Object();
            this.characters.data.retro = true;
            this.characters.flush();
            return 0;
         }
         _loc1_ = 0;
         for(var _loc3_ in this.characters.data.users)
         {
            _loc2_ = _loc3_;
            _loc3_;
            _loc1_++;
         }
         return _loc1_;
      }

      public function retroLowercase() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         if(this.charCount() == 0)
         {
            return;
         }
         if(this.characters.data.retro)
         {
            return;
         }
         trace("[Game] retroLowercase: migrating saved char names");
         _loc1_ = false;
         for(var _loc4_ in this.characters.data.users)
         {
            _loc2_ = _loc4_;
            _loc4_;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               if(_loc2_.charAt(_loc3_) != _loc2_.charAt(_loc3_).toLowerCase())
               {
                  _loc1_ = true;
                  break;
               }
               _loc3_++;
            }
            if(_loc1_)
            {
               break;
            }
         }
         if(_loc1_)
         {
            this.resetChars();
         }
         else
         {
            this.characters.data.retro = true;
         }
      }

      public function resetChars() : void
      {
         if(this.characters == null)
         {
            return;
         }
         this.characters.data.users = null;
         delete this.characters.data.users;
         this.characters.flush();
      }

      private function loadExternalAssets() : void
      {
         var _loc1_:String = null;
         var _loc2_:* = undefined;
         trace("[Load] loadExternalAssets");
         this.mcConnDetail.showConn("Initializing Client...");
         this.assetsLoader = new AirLoader();
         _loc1_ = this.world != null && this.world.objInfo != null && this.world.objInfo["sAssets"] != null ? String(this.world.objInfo["sAssets"]) : "Assets_20260702.swf";
         this.pendingAssetsFile = _loc1_;
         _loc2_ = new URLRequest(vurl(serverFilePath + "interface/Assets/" + _loc1_));
         this.assetsLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.assetsLoaderCallback,false,0,true);
         this.assetsLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.assetsLoaderErrorHandler,false,0,true);
         this.assetsLoader.load(_loc2_,this.assetsContext);
      }

      private function assetsLoaderCallback(param1:Event) : void
      {
         var _loc1_:LoaderInfo = null;
         trace("[Load] external assets loaded");
         _loc1_ = param1.currentTarget as LoaderInfo;
         if(_loc1_ != null)
         {
            _loc1_.removeEventListener(Event.COMPLETE,this.assetsLoaderCallback);
            _loc1_.removeEventListener(IOErrorEvent.IO_ERROR,this.assetsLoaderErrorHandler);
         }
         this.assetsLoader = null;
         ASSETS_READY = this.pendingAssetsFile;
         this.resumeOnLoginResponse();
      }

      private function resumeOnLoginResponse() : void
      {
         var _loc1_:int = 0;
         this.mcConnDetail.showConn("Joining Lobby..");
         this.sfc.sendXtMessage("zm","firstJoin",[],"str",1);
         if(this.chatF.ignoreList.data.users.length > 0)
         {
            _loc1_ = 0;
            while(_loc1_ < this.chatF.ignoreList.data.users.length)
            {
               if(this.chatF.ignoreList.data.users[_loc1_].toLowerCase() == loginInfo.strUsername.toLowerCase())
               {
                  this.chatF.ignoreList.data.users.splice(_loc1_,1);
                  break;
               }
               _loc1_++;
            }
            this.sfc.sendXtMessage("zm","cmd",["ignoreList",this.chatF.ignoreList.data.users],"str",1);
         }
         else
         {
            this.sfc.sendXtMessage("zm","cmd",["ignoreList","$clearAll"],"str",1);
         }
      }

      private function assetsLoaderErrorHandler(param1:IOErrorEvent) : void
      {
         var _loc1_:LoaderInfo = null;
         _loc1_ = param1.currentTarget as LoaderInfo;
         if(_loc1_ != null)
         {
            _loc1_.removeEventListener(Event.COMPLETE,this.assetsLoaderCallback);
            _loc1_.removeEventListener(IOErrorEvent.IO_ERROR,this.assetsLoaderErrorHandler);
         }
         this.assetsLoader = null;
         trace("[Load] ERR external assets failed: " + param1.text);
         this.mcConnDetail.showError("Client Initialization Failed!");
      }

      public function connectTo(param1:String, param2:int = 5588) : *
      {
         trace("[Game] connectTo: " + param1);
         serverIP = param1;
         this.mixer.playSound("ClickBig");
         this.mcConnDetail.showConn("Connecting to game server...");
         if(this.sfc.isConnected)
         {
            this.sfc.disconnect();
         }
         this.sfc.connect(param1,param2);
         gotoAndPlay("Game");
      }

      public function displayCharPage(param1:String) : void
      {
         var _loc1_:* = undefined;
         _loc1_ = new _loc1_(this,param1);
         this.ui.addChild(_loc1_);
      }

      public function togglePolls() : void
      {
         this.requestInterface("polls/pollingsystem.swf","pollingSystem");
      }

      public function requestInterface(param1:String, param2:String) : void
      {
         this.removeDeadInterfaces();
         this.interfaceQueue.push({
            "nam":param2,
            "intrf":param1
         });
         if(this.interfaceQueue.length == 1)
         {
            this.checkInterfaceQueue();
         }
      }

      public function checkInterfaceQueue() : void
      {
         var _loc1_:Loader = null;
         if(this.interfaceQueue.length < 1)
         {
            return;
         }
         this.visualLoader = new mcLoader();
         this.visualLoader.x = 400;
         this.visualLoader.y = 211;
         this.addChild(this.visualLoader);
         _loc1_ = new AirLoader();
         _loc1_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onInterfaceComplete,false,0,true);
         _loc1_.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onInterfaceProgress,false,0,true);
         _loc1_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onInterfaceError,false,0,true);
         _loc1_.load(new URLRequest(vurl(this.getFilePath() + "interface/" + this.interfaceQueue[0].intrf)),new LoaderContext(false,AirLoader.trust(new ApplicationDomain(ApplicationDomain.currentDomain))));
      }

      public function onInterfaceComplete(param1:Event) : void
      {
         var _loc1_:LoaderInfo = null;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         _loc1_ = param1.currentTarget as LoaderInfo;
         if(_loc1_ != null)
         {
            _loc1_.removeEventListener(Event.COMPLETE,this.onInterfaceComplete);
            _loc1_.removeEventListener(ProgressEvent.PROGRESS,this.onInterfaceProgress);
            _loc1_.removeEventListener(IOErrorEvent.IO_ERROR,this.onInterfaceError);
         }
         _loc2_ = new MovieClip();
         _loc2_.addChild(param1.currentTarget.content);
         _loc2_.name = this.interfaceQueue[0].nam;
         _loc3_ = this.addChild(_loc2_);
         if(this.interfaceRef.hasOwnProperty(this.interfaceQueue[0].nam))
         {
            if(this.interfaceRef[this.interfaceQueue[0].nam])
            {
               if(this.interfaceRef[this.interfaceQueue[0].nam].parent)
               {
                  MovieClip(this.interfaceRef[this.interfaceQueue[0].nam].parent).removeChild(this.interfaceRef[this.interfaceQueue[0].nam]);
               }
            }
         }
         this.interfaceRef[this.interfaceQueue[0].nam] = _loc3_;
         this.interfaceQueue.shift();
         this.checkInterfaceQueue();
         this.setChildIndex(this.MsgBox,numChildren - 1);
         if(_loc2_.name == "pony_engine")
         {
            this.world.myAvatar.swapMorphs(true);
         }
      }

      public function cleanupInterfaces() : void
      {
         var _loc1_:* = undefined;
         for each(var _loc2_ in this.interfaceRef)
         {
            _loc1_ = _loc2_;
            _loc2_;
            if(_loc1_)
            {
               if(_loc1_.parent)
               {
                  MovieClip(_loc1_.parent).removeChild(_loc1_);
               }
            }
         }
         this.interfaceRef = new Object();
      }

      public function mailStart() : void
      {
         this.mailStop();
         this.mailHub = new MailHub(this);
         this.mailHub.start();
         Mobile.hudStart();
         this.mailHub.placeHud();
      }

      public function mailStop() : void
      {
         try
         {
            Mobile.hudStop();
         }
         catch(e:Error)
         {
         }
         if(this.mailHub != null)
         {
            try
            {
               this.mailHub.destroy();
            }
            catch(e:Error)
            {
            }
            this.mailHub = null;
         }
      }

      public function removeDeadInterfaces() : void
      {
         var _loc1_:String = null;
         var _loc2_:Array = null;
         var _loc3_:* = undefined;
         _loc2_ = [];
         for(var _loc4_ in this.interfaceRef)
         {
            _loc1_ = _loc4_;
            _loc4_;
            _loc3_ = this.interfaceRef[_loc1_];
            if(_loc3_)
            {
               if(!_loc3_.parent)
               {
                  _loc2_.push(_loc1_);
               }
            }
         }
         for each(_loc4_ in _loc2_)
         {
            _loc1_ = _loc4_;
            _loc4_;
            delete this.interfaceRef[_loc1_];
         }
      }

      public function getInterface(param1:String) : *
      {
         var _loc1_:* = undefined;
         _loc1_ = this.interfaceRef[param1];
         if(_loc1_)
         {
            if(_loc1_.parent)
            {
               return _loc1_;
            }
            delete this.interfaceRef[param1];
         }
         return null;
      }

      public function onInterfaceProgress(param1:ProgressEvent) : void
      {
         var _loc1_:int = 0;
         this.interfaceLoaded = param1.bytesLoaded;
         this.interfaceTotal = param1.bytesTotal;
         _loc1_ = this.interfaceLoaded / this.interfaceTotal * 100;
         var _loc2_:Number = this.interfaceLoaded / this.interfaceTotal;
         this.visualLoader.mcPct.text = _loc1_ + "%";
         if(this.interfaceLoaded >= this.interfaceTotal)
         {
            this.visualLoader.parent.removeChild(this.visualLoader);
            this.visualLoader = null;
         }
      }

      public function onInterfaceError(param1:IOErrorEvent) : void
      {
         var _loc1_:LoaderInfo = null;
         _loc1_ = param1.currentTarget as LoaderInfo;
         if(_loc1_ != null)
         {
            _loc1_.removeEventListener(Event.COMPLETE,this.onInterfaceComplete);
            _loc1_.removeEventListener(ProgressEvent.PROGRESS,this.onInterfaceProgress);
            _loc1_.removeEventListener(IOErrorEvent.IO_ERROR,this.onInterfaceError);
         }
         trace("[Load] ERR interface load failed: " + param1.text);
      }

      public function requestAPI(param1:String, param2:*, param3:*, param4:*, param5:Boolean = false) : void
      {
         var _loc1_:URLLoader = null;
         var _loc2_:Array = null;
         var _loc3_:URLVariables = null;
         var _loc4_:URLRequest = null;
         var _loc5_:* = undefined;
         _loc1_ = new URLLoader();
         _loc1_.addEventListener(Event.COMPLETE,param3,false,0,true);
         _loc1_.addEventListener(IOErrorEvent.IO_ERROR,param4,false,0,true);
         _loc2_ = [new URLRequestHeader("ccid",this.world.myAvatar.objData.CharID),new URLRequestHeader("token",loginInfo.strToken)];
         _loc3_ = new URLVariables();
         if(param2 != null)
         {
            for(var _loc6_ in param2)
            {
               _loc5_ = _loc6_;
               _loc6_;
               _loc3_[_loc5_] = _loc5_ == "layout" ? JSON.stringify(param2[_loc5_]) : param2[_loc5_];
            }
         }
         _loc4_ = new URLRequest(serverGamePath + "api/char/" + param1 + (param5 ? "?v=" + Math.random() : ""));
         _loc4_.requestHeaders = _loc2_;
         if(param2 != null)
         {
            _loc4_.data = _loc3_;
         }
         _loc4_.method = URLRequestMethod.POST;
         _loc1_.load(_loc4_);
      }

      public function getBank() : void
      {
         this.requestAPI("bank",{"layout":{"cat":"all"}},this.onBankComplete,this.onBankError,true);
      }

      public function onBankComplete(param1:Event) : void
      {
         var _loc1_:MovieClip = null;
         trace("[Load] bank data loaded");
         this.world.addItemsToBank(JSON.parse(param1.target.data) as Array);
         if(this.world.myAvatar != null)
         {
            this.world.myAvatar.bank = [];
         }
         if(this.ui != null && this.ui.mcPopup != null && this.ui.mcPopup.currentLabel == "Bank")
         {
            _loc1_ = this.ui.mcPopup.getChildByName("mcBank") as MovieClip;
            if(_loc1_ != null)
            {
               _loc1_.update({"eventType":"refreshBank"});
            }
         }
      }

      public function onBankError(param1:IOErrorEvent) : void
      {
         this.mcConnDetail.showConn("Error loading bank information");
      }

      public function retrieveInfo(param1:Array) : void
      {
         var _loc1_:URLLoader = null;
         var _loc2_:* = undefined;
         if(this.world == null)
         {
            this.initWorld();
         }
         if(serverGamePath.indexOf("content.aq") == -1)
         {
            for each(var _loc3_ in param1)
            {
               _loc2_ = _loc3_;
               _loc3_;
               this.world.objInfo[_loc2_.split("=")[0]] = _loc2_.substr(_loc2_.indexOf("=") + 1);
            }
            this.iMaxBagSlots = Number(this.world.objInfo["iMaxBagSlots"]);
            this.iMaxBankSlots = Number(this.world.objInfo["iMaxBankSlots"]);
            this.iMaxHouseSlots = Number(this.world.objInfo["iMaxHouseSlots"]);
            this.iMaxFriends = Number(this.world.objInfo["iMaxFriends"]);
            this.iMaxLoadoutSlots = Number(this.world.objInfo["iMaxLoadoutSlots"]);
            if(ASSETS_READY == this.world.objInfo["sAssets"])
            {
               this.bookInfo = null;
               this.resumeOnLoginResponse();
            }
            else
            {
               this.bookInfo = null;
               this.loadExternalAssets();
            }
            return;
         }
         _loc1_ = new URLLoader();
         _loc1_.addEventListener(Event.COMPLETE,this.onInfoComplete,false,0,true);
         _loc1_.addEventListener(IOErrorEvent.IO_ERROR,this.onInfoError,false,0,true);
         _loc1_.load(new URLRequest(serverGamePath + "api/data/clientvars?v=" + Math.random()));
      }

      public function retrieveBook() : void
      {
         var _loc1_:URLLoader = null;
         if(this.bookInfo != null)
         {
            this.showBook();
            return;
         }
         if(this.bookLoaderMC != null && this.bookLoaderMC.parent != null)
         {
            return;
         }
         this.bookLoaderMC = new (this.world.getClass("mcLoader") as Class)();
         this.bookLoaderMC.x = 400;
         this.bookLoaderMC.y = 211;
         this.bookLoaderMC.name = "bookLoaderMC";
         this.ui.addChild(this.bookLoaderMC);
         _loc1_ = new URLLoader();
         _loc1_.addEventListener(Event.COMPLETE,this.onBoLComplete,false,0,true);
         _loc1_.addEventListener(ProgressEvent.PROGRESS,this.onBoLProgress,false,0,true);
         _loc1_.addEventListener(IOErrorEvent.IO_ERROR,this.onBoLError,false,0,true);
         _loc1_.load(new URLRequest(serverGamePath + "api/data/booklore?v=" + this.world.objInfo["sVersion"]));
      }

      public function onInfoComplete(param1:Event) : void
      {
         var _loc1_:URLLoader = null;
         var _loc2_:Object = null;
         var _loc3_:* = undefined;
         _loc1_ = param1.target as URLLoader;
         if(_loc1_ != null)
         {
            _loc1_.removeEventListener(Event.COMPLETE,this.onInfoComplete);
            _loc1_.removeEventListener(IOErrorEvent.IO_ERROR,this.onInfoError);
         }
         if(this.world == null)
         {
            this.initWorld();
         }
         _loc2_ = JSON.parse(param1.target.data);
         for(var _loc4_ in _loc2_)
         {
            _loc3_ = _loc4_;
            _loc4_;
            this.world.objInfo[_loc3_] = _loc2_[_loc3_];
         }
         this.iMaxBagSlots = Number(_loc2_["iMaxBagSlots"]);
         this.iMaxBankSlots = Number(_loc2_["iMaxBankSlots"]);
         this.iMaxHouseSlots = Number(_loc2_["iMaxHouseSlots"]);
         this.iMaxFriends = Number(_loc2_["iMaxFriends"]);
         this.iMaxLoadoutSlots = Number(_loc2_["iMaxLoadoutSlots"]);
         if(ASSETS_READY == _loc2_["sAssets"])
         {
            this.bookInfo = null;
            this.resumeOnLoginResponse();
         }
         else
         {
            this.bookInfo = null;
            this.loadExternalAssets();
         }
      }

      public function onInfoError(param1:IOErrorEvent) : void
      {
         var _loc1_:URLLoader = null;
         _loc1_ = param1.target as URLLoader;
         if(_loc1_ != null)
         {
            _loc1_.removeEventListener(Event.COMPLETE,this.onInfoComplete);
            _loc1_.removeEventListener(IOErrorEvent.IO_ERROR,this.onInfoError);
         }
         this.mcConnDetail.showConn("Error loading client vars");
      }

      public function onBoLComplete(param1:Event) : void
      {
         var _loc1_:URLLoader = null;
         _loc1_ = param1.target as URLLoader;
         if(_loc1_ != null)
         {
            _loc1_.removeEventListener(Event.COMPLETE,this.onBoLComplete);
            _loc1_.removeEventListener(ProgressEvent.PROGRESS,this.onBoLProgress);
         }
         this.dropBookLoader();
         this.bookInfo = JSON.parse(param1.target.data);
         this.showBook();
      }

      private function showBook() : void
      {
         this.world.bookData = this.bookInfo;
         this.dropBook();
         this.bolLoader = new AirLoader();
         this.bolLoader.contentLoaderInfo.addEventListener(Event.INIT,this.onBoLContentComplete,false,0,true);
         this.bolLoader.load(new URLRequest(vurl(Game.serverFilePath + this.world.objInfo.sBook)),new LoaderContext(false,AirLoader.trust(new ApplicationDomain(ApplicationDomain.currentDomain))));
      }

      private function dropBook() : void
      {
         if(this.bolContent != null && this.bolContent.parent != null)
         {
            this.bolContent.parent.removeChild(this.bolContent);
         }
         this.bolContent = null;
         if(this.bolLoader == null)
         {
            return;
         }
         this.bolLoader.contentLoaderInfo.removeEventListener(Event.INIT,this.onBoLContentComplete);
         try
         {
            this.bolLoader.close();
         }
         catch(errC:Error)
         {
         }
         try
         {
            this.bolLoader.unloadAndStop();
         }
         catch(err:Error)
         {
         }
         this.bolLoader = null;
      }

      public function onBoLContentComplete(param1:Event) : void
      {
         var _loc1_:LoaderInfo = null;
         var _loc2_:MovieClip = null;
         trace("[Load] BoL content loaded");
         _loc1_ = param1.currentTarget as LoaderInfo;
         _loc1_.removeEventListener(Event.INIT,this.onBoLContentComplete);
         if(this.bolLoader == null || _loc1_.loader != this.bolLoader)
         {
            return;
         }
         _loc2_ = this.ui.mcPopup.currentLabel == "Book" ? this.ui.mcPopup.mcBook as MovieClip : null;
         if(_loc2_ == null)
         {
            this.dropBook();
            return;
         }
         this.bolContent = _loc1_.content as MovieClip;
         if(_loc2_.numChildren > 0)
         {
            _loc2_.removeChildAt(0);
         }
         _loc2_.addChild(this.bolContent);
      }

      private function onBoLProgress(param1:ProgressEvent) : void
      {
         var _loc1_:int = 0;
         this.bLoaded = param1.bytesLoaded;
         this.bTotal = param1.bytesTotal;
         _loc1_ = this.bLoaded / this.bTotal * 100;
         var _loc2_:Number = this.bLoaded / this.bTotal;
         if(this.bookLoaderMC == null)
         {
            return;
         }
         this.bookLoaderMC.mcPct.text = _loc1_ + "%";
         if(this.bLoaded >= this.bTotal)
         {
            this.dropBookLoader();
         }
      }

      private function onBoLError(param1:IOErrorEvent) : void
      {
         trace("[Load] ERR BoL load failed: " + param1.text);
         this.dropBookLoader();
      }

      private function dropBookLoader() : void
      {
         if(this.bookLoaderMC != null && this.bookLoaderMC.parent != null)
         {
            this.bookLoaderMC.parent.removeChild(this.bookLoaderMC);
         }
         this.bookLoaderMC = null;
      }

      public function serialCmdInit(param1:String) : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         _loc1_ = this.mcLogin.il;
         _loc2_ = _loc1_.cmd;
         _loc2_.btnUnselectAll.visible = false;
         _loc2_.btnSelectAll.visible = false;
         _loc2_.btnGo.visible = false;
         this.serialCmd.si = 0;
         this.serialCmd.cmd = param1;
         this.serialCmd.active = true;
         this.serialCmdNext();
      }

      private function serialCmdNext() : void
      {
         var _loc1_:Date = null;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         _loc1_ = new Date();
         _loc2_ = this.mcLogin.il.iClass;
         var _loc4_:* = this.mcLogin.il.cmd;
         if(this.serialCmd.si > 0)
         {
            _loc3_ = _loc2_.getServerItemByIP(this.serialCmd.servers[this.serialCmd.si - 1].sIP,this.serialCmd.servers[this.serialCmd.si - 1].iPort);
            if(_loc3_ != null)
            {
               _loc2_.serverOn(_loc3_);
               _loc3_.t3.text = (_loc1_.getTime() - this.serialCmd.ts) / 1000 + " s";
               _loc3_.t3.visible = true;
            }
         }
         if(this.serialCmd.si < this.serialCmd.servers.length)
         {
            trace("[Game] serial connecting to: " + this.serialCmd.servers[this.serialCmd.si].sName);
            this.sfc.connect(this.serialCmd.servers[this.serialCmd.si].sIP,this.serialCmd.servers[this.serialCmd.si].iPort);
            this.serialCmd.si++;
            this.serialCmd.ts = _loc1_.getTime();
         }
         else
         {
            this.serialCmdDone();
         }
      }

      private function serialCmdDone() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         _loc1_ = this.mcLogin.il;
         _loc2_ = _loc1_.cmd;
         _loc2_.btnUnselectAll.visible = true;
         _loc2_.btnSelectAll.visible = true;
         _loc2_.btnGo.visible = true;
         this.serialCmd.active = false;
      }

      public function readIA1Preferences() : void
      {
         this.uoPref.bCloak = this.world.getAchievement("ia1",0) == 0;
         this.uoPref.bHelm = this.world.getAchievement("ia1",1) == 0;
         this.uoPref.bPet = this.world.getAchievement("ia1",2) == 0;
         this.uoPref.bWAnim = this.world.getAchievement("ia1",3) == 0;
         this.uoPref.bGoto = this.world.getAchievement("ia1",4) == 0;
         this.uoPref.bMusicOn = this.world.getAchievement("ia1",6) == 0;
         this.uoPref.bFriend = this.world.getAchievement("ia1",7) == 0;
         this.uoPref.bParty = this.world.getAchievement("ia1",8) == 0;
         this.uoPref.bGuild = this.world.getAchievement("ia1",9) == 0;
         this.uoPref.bWhisper = this.world.getAchievement("ia1",10) == 0;
         this.uoPref.bTT = this.world.getAchievement("ia1",11) == 0;
         this.uoPref.bFBShare = this.world.getAchievement("ia1",12) == 1;
         this.uoPref.bDuel = this.world.getAchievement("ia1",13) == 0;
         this.world.hideAllCapes = this.world.getAchievement("ia1",14) == 1;
         this.world.hideOtherPets = this.world.getAchievement("ia1",15) == 1;
         this.world.showAnimations = this.world.getAchievement("ia1",17) == 0;
         this.uoPref.bProf = this.world.getAchievement("ia1",18) == 0;
         this.uoPref.bFBShard = false;
         VolumePanel.applyAll(this);
      }

      public function inituoPref() : void
      {
         this.uoPref.bCloak = true;
         this.uoPref.bHelm = true;
         this.uoPref.bPet = true;
         this.uoPref.bWAnim = true;
         this.uoPref.bGoto = true;
         this.uoPref.bMusicOn = true;
         this.uoPref.bFriend = true;
         this.uoPref.bParty = true;
         this.uoPref.bGuild = true;
         this.uoPref.bWhisper = true;
         this.uoPref.bTT = true;
         this.uoPref.bFBShare = false;
         this.uoPref.bDuel = true;
      }

      public function initKeybindPref(param1:Boolean = false) : void
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:* = undefined;
         if(Boolean(this.litePreference.data.keys) && !("Dash" in this.litePreference.data.keys))
         {
            this.litePreference.data.keys["Dash"] = 32;
            this.litePreference.data.keys["Jump"] = null;
         }
         if(this.litePreference.data.keys)
         {
            _loc1_ = ["Move Up","Move Left","Move Down","Move Right"];
            _loc2_ = [87,65,83,68];
            _loc3_ = 0;
            while(_loc3_ < 4)
            {
               if(!(_loc1_[_loc3_] in this.litePreference.data.keys))
               {
                  _loc4_ = true;
                  for each(var _loc6_ in this.litePreference.data.keys)
                  {
                     _loc5_ = _loc6_;
                     _loc6_;
                     if(_loc5_ == _loc2_[_loc3_])
                     {
                        _loc4_ = false;
                        break;
                     }
                  }
                  this.litePreference.data.keys[_loc1_[_loc3_]] = _loc4_ ? _loc2_[_loc3_] : null;
               }
               _loc3_++;
            }
         }
         if(Boolean(this.litePreference.data.keys) && !param1)
         {
            return;
         }
         this.litePreference.data.keys = {};
         this.litePreference.data.keys["Camera Tool"] = 219;
         this.litePreference.data.keys["World Camera"] = 221;
         this.litePreference.data.keys["Target Random Monster"] = 84;
         this.litePreference.data.keys["Inventory"] = 73;
         this.litePreference.data.keys["Bank"] = 66;
         this.litePreference.data.keys["Quest Log"] = 76;
         this.litePreference.data.keys["Friends List"] = 70;
         this.litePreference.data.keys["Character Panel"] = 67;
         this.litePreference.data.keys["Player HP Bar"] = 86;
         this.litePreference.data.keys["Options"] = 79;
         this.litePreference.data.keys["Area List"] = 85;
         this.litePreference.data.keys["Jump"] = null;
         this.litePreference.data.keys["Auto Attack"] = 49;
         this.litePreference.data.keys["Skill 1"] = 50;
         this.litePreference.data.keys["Skill 2"] = 51;
         this.litePreference.data.keys["Skill 3"] = 52;
         this.litePreference.data.keys["Skill 4"] = 53;
         this.litePreference.data.keys["Skill 5"] = 54;
         this.litePreference.data.keys["Travel Menu\'s Travel"] = 89;
         this.litePreference.data.keys["World Camera\'s Hide"] = 72;
         this.litePreference.data.keys["Rest"] = 88;
         this.litePreference.data.keys["Hide Monsters"] = null;
         this.litePreference.data.keys["Hide Players"] = null;
         this.litePreference.data.keys["Cancel Target"] = 27;
         this.litePreference.data.keys["Hide UI"] = null;
         this.litePreference.data.keys["Battle Analyzer"] = null;
         this.litePreference.data.keys["Decline All Drops"] = null;
         this.litePreference.data.keys["Stats Overview"] = null;
         this.litePreference.data.keys["Battle Analyzer Toggle"] = null;
         this.litePreference.data.keys["Custom Drops UI"] = null;
         this.litePreference.data.keys["@ Debugger - Cell Menu"] = 192;
         this.litePreference.data.keys["@ Debugger - Packet Logger"] = null;
         this.litePreference.data.keys["Dash"] = 32;
         this.litePreference.data.keys["Outfits"] = null;
         this.litePreference.data.keys["Friendships UI"] = null;
         this.litePreference.data.keys["Move Up"] = 87;
         this.litePreference.data.keys["Move Left"] = 65;
         this.litePreference.data.keys["Move Down"] = 83;
         this.litePreference.data.keys["Move Right"] = 68;
      }

      public function debugMessage(param1:String) : void
      {
         if(!this.litePreference.data.bDebugger)
         {
            return;
         }
         this.chatF.pushMsg("warning",param1,"SERVER","",0);
      }

      private function registerErrorSuppression() : void
      {
         var _loc1_:LoaderInfo = null;
         this.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,this.onUncaughtError);
         try
         {
            if(this.parent is Loader)
            {
               Loader(this.parent).uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,this.onUncaughtError);
            }
         }
         catch(e1:Error)
         {
         }
         try
         {
            _loc1_ = DisplayObject(stage.getChildAt(0)).loaderInfo;
            if(_loc1_ != null && _loc1_ != this.loaderInfo)
            {
               _loc1_.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,this.onUncaughtError);
            }
         }
         catch(e2:Error)
         {
         }
      }

      private function uncaughtText(param1:*) : String
      {
         var _loc1_:Error = null;
         var _loc2_:String = null;
         _loc1_ = param1 as Error;
         if(_loc1_ == null)
         {
            return String(param1);
         }
         _loc2_ = _loc1_.getStackTrace();
         if(_loc2_ == null)
         {
            return _loc1_.message;
         }
         return _loc2_;
      }

      private function onUncaughtError(param1:UncaughtErrorEvent) : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         param1.preventDefault();
         param1.stopImmediatePropagation();
         _loc1_ = "uncaught";
         try
         {
            _loc1_ = this.uncaughtText(param1.error);
         }
         catch(e3:Error)
         {
         }
         _loc2_ = int(getTimer());
         if(this.uncaughtSeen[_loc1_] != undefined && _loc2_ - this.uncaughtSeen[_loc1_] < 5000)
         {
            return;
         }
         if(++this.uncaughtCount > 64)
         {
            this.uncaughtSeen = {};
            this.uncaughtCount = 1;
         }
         this.uncaughtSeen[_loc1_] = _loc2_;
         trace("[Game] ERR uncaught: " + _loc1_);
         try
         {
            this.debugMessage("suppressed error: " + _loc1_);
         }
         catch(e4:Error)
         {
         }
      }

      private function partyBounds(param1:DisplayObject) : Rectangle
      {
         var _loc1_:MovieClip = null;
         var _loc2_:Rectangle = null;
         var _loc3_:int = 0;
         var _loc4_:DisplayObjectContainer = null;
         var _loc5_:Rectangle = null;
         _loc1_ = this.ui.mcPartyFrame;
         _loc2_ = null;
         _loc3_ = 0;
         while(_loc3_ < _loc1_.numChildren)
         {
            _loc4_ = _loc1_.getChildAt(_loc3_) as DisplayObjectContainer;
            if(!(_loc4_ == null || !_loc4_.visible || _loc4_.numChildren == 0))
            {
               _loc5_ = _loc4_.getChildAt(0).getBounds(param1);
               _loc2_ = _loc2_ == null ? _loc5_ : _loc2_.union(_loc5_);
            }
            _loc3_++;
         }
         return _loc2_;
      }

      private function defaultFPS() : Number
      {
         if(this.authoredFPS <= 0 && stage != null)
         {
            this.authoredFPS = stage.frameRate;
         }
         return this.authoredFPS > 0 ? Number(this.authoredFPS) : 24;
      }

      public function maxFPSLabel() : String
      {
         var _loc1_:int = 0;
         _loc1_ = int(this.litePreference.data.nMaxFPS);
         return "Max FPS: " + (_loc1_ == 30 || _loc1_ == 48 || _loc1_ == 60 ? _loc1_ : Math.round(this.defaultFPS()));
      }

      public function cycleMaxFPS() : String
      {
         var _loc1_:int = 0;
         _loc1_ = int(this.litePreference.data.nMaxFPS);
         this.litePreference.data.nMaxFPS = _loc1_ == 30 ? 48 : (_loc1_ == 48 ? 60 : (_loc1_ == 60 ? 0 : 30));
         this.litePreference.flush();
         this.applyMaxFPS();
         return this.maxFPSLabel();
      }

      public function crowdLabel() : String
      {
         var _loc1_:String = null;
         _loc1_ = String(this.litePreference.data.sCrowd);
         return "Crowd Mode: " + (_loc1_ == "on" ? "On" : (_loc1_ == "auto" ? "Auto" : "Off"));
      }

      public function cycleCrowd() : String
      {
         var _loc1_:String = null;
         _loc1_ = String(this.litePreference.data.sCrowd);
         this.litePreference.data.sCrowd = _loc1_ == "auto" ? "on" : (_loc1_ == "on" ? "off" : "auto");
         this.litePreference.flush();
         this.crowdLow = 0;
         this.setCrowd(this.litePreference.data.sCrowd == "on");
         return this.crowdLabel();
      }

      public function cacheOthers() : Boolean
      {
         return this.crowdOn || this.litePreference.data.bCachePlayers == true;
      }

      public function applyPlayerCache() : void
      {
         var _loc1_:* = undefined;
         if(this.world == null || this.world.avatars == null)
         {
            return;
         }
         for each(var _loc2_ in this.world.avatars)
         {
            _loc1_ = _loc2_;
            _loc2_;
            if(!(Boolean(_loc1_ == null) || Boolean(_loc1_.isMyAvatar) || _loc1_.pMC == null))
            {
               try
               {
                  _loc1_.pMC.crowdSync();
               }
               catch(e:Error)
               {
               }
            }
         }
      }

      private function setCrowd(param1:Boolean) : void
      {
         if(param1 == this.crowdOn)
         {
            return;
         }
         this.crowdOn = param1;
         if(param1)
         {
            this.crowdCell = this.crowdKey();
            this.crowdN0 = this.crowdCount();
         }
         this.applyPlayerCache();
      }

      private function crowdKey() : String
      {
         return this.world == null ? "" : this.world.strMapName + "|" + this.world.strFrame;
      }

      private function crowdCount() : int
      {
         var _loc1_:* = 0;
         var _loc2_:* = undefined;
         _loc1_ = 0;
         if(this.world == null || this.world.avatars == null)
         {
            return 0;
         }
         for each(var _loc3_ in this.world.avatars)
         {
            _loc2_ = _loc3_;
            _loc3_;
            if(_loc2_ != null && !_loc2_.isMyAvatar && _loc2_.dataLeaf != null && _loc2_.dataLeaf.strFrame == this.world.strFrame)
            {
               _loc1_++;
            }
         }
         return _loc1_;
      }

      public function crowdSample(param1:Number) : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         _loc1_ = String(this.litePreference.data.sCrowd);
         if(_loc1_ == "on")
         {
            this.setCrowd(true);
            return;
         }
         if(_loc1_ != "auto")
         {
            this.setCrowd(false);
            return;
         }
         if(this.world == null || this.world.myAvatar == null || stage == null)
         {
            return;
         }
         _loc2_ = int(this.crowdCount());
         if(this.crowdOn)
         {
            if(this.crowdKey() != this.crowdCell || _loc2_ * 3 < this.crowdN0 * 2)
            {
               this.crowdLow = 0;
               this.setCrowd(false);
            }
            return;
         }
         if(_loc2_ > 0 && param1 < stage.frameRate * 0.8)
         {
            if(++this.crowdLow >= 2)
            {
               this.crowdLow = 0;
               this.setCrowd(true);
            }
         }
         else
         {
            this.crowdLow = 0;
         }
      }

      public function applyMaxFPS() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Number = NaN;
         _loc1_ = int(this.litePreference.data.nMaxFPS);
         _loc2_ = Number(this.defaultFPS());
         if(stage != null)
         {
            stage.frameRate = _loc1_ == 30 || _loc1_ == 48 || _loc1_ == 60 ? _loc1_ : _loc2_;
         }
      }

      public function initlitePref() : void
      {
         if(this.litePreference.data.dOptions == null)
         {
            this.litePreference.data.dOptions = {};
         }
         if(this.litePreference.data.dOptions["termsAgree"] == null)
         {
            this.litePreference.data.dOptions["termsAgree"] = true;
         }
         this.litePref = [{
            "strName":"@ Debugger",
            "bEnabled":this.litePreference.data.bDebugger,
            "sDesc":"Debug Mode!\nPress ` (Changeable in Keybinds) to hide/show the cell & pads menu!",
            "minAccess":30,
            "extra":[{
               "strName":"Disable Linkage Errors",
               "bEnabled":this.litePreference.data.dOptions["debugLinkage"],
               "sDesc":"Avoid receiving linkage error messages"
            },{
               "strName":"Disable Color Coded Items",
               "bEnabled":this.litePreference.data.dOptions["debugColor"],
               "sDesc":"Prevents color coding of item entries\nRed item = costs 0 ac/gold\nRed item = item is AC and > 12k\nYellow item = is staff"
            },{
               "strName":"Packet Logger",
               "bEnabled":this.litePreference.data.dOptions["debugPacket"],
               "sDesc":"View all packets sent to the client.\nMust be enabled to use.\nSet a keybind to hide/show the packet logger window."
            }]
         },{
            "strName":"Allow Quest Log Turn-Ins",
            "bEnabled":this.litePreference.data.bQuestLog,
            "sDesc":"Allows you to turn-in quests using your quest log on the bottom right screen!"
         },{
            "strName":"Auto-Untarget Dead Targets",
            "bEnabled":this.litePreference.data.bUntargetDead,
            "sDesc":"This will untarget targets that are dead."
         },{
            "strName":"Auto-Untarget Self",
            "bEnabled":this.litePreference.data.bUntargetSelf,
            "sDesc":"This will prevent you from targetting yourself."
         },{
            "strName":"Battle Analyzer",
            "extra":"btn",
            "sDesc":"This will allow you to monitor your damage dealt, gold earned, and many more!"
         },{
            "strName":VolumePanel.touchLabel(),
            "btn":true,
            "sDesc":"Click to cycle Auto, On and Off.\nAuto enables mobile controls on the mobile app only; On enables them on any platform.",
            "extra":[{
               "strName":"Hide Mobile Menu Tab",
               "bEnabled":this.litePreference.data.dOptions["bTabHidden"],
               "sDesc":"Hides the mobile controls\' pull tab and its Joy, Skills, Move, Reset, Mouse and Hide buttons.\nWhatever you left turned on (joystick, skills, mouse) stays on screen. Uncheck this to bring the tab back and change them."
            }]
         },{
            "strName":Mobile.sizeLabel(),
            "btn":true,
            "sDesc":"Click to cycle the size of the on-screen mobile controls: the bottom bar, skill buttons and joystick area.\nPick a smaller size if they cover too much of a small phone screen."
         },{
            "strName":"Gamepad Controls",
            "extra":"btn",
            "sDesc":"Choose which controller button does what."
         },{
            "strName":this.maxFPSLabel(),
            "extra":"btn",
            "sDesc":"Caps the game\'s frame rate. AQW art is animated at 24 FPS, so anything above 24 makes animations play faster and can look wonky."
         },{
            "strName":"Battlepets",
            "bEnabled":this.litePreference.data.bBattlepet,
            "sDesc":"Allows your battlepet to fight alongside you without a battlepet class equipped."
         },{
            "strName":"Static Player Art",
            "bEnabled":this.litePreference.data.bCachePlayers,
            "sDesc":"Freezes other players and their ground items as static art for the benefit of performance.\nPlayers freeze shortly after they finish loading, keeping their colors. You will not see their animations or equipment changes while this is enabled. Pets stay animated.\nToggling this on or off applies instantly."
         },{
            "strName":this.crowdLabel(),
            "extra":"btn",
            "sDesc":"Freezes other players\' animations (poses, gear and skill effects) to keep the game smooth in busy areas. Your own animations always play.\nClick to cycle Off, Auto and On. Auto turns it on when your frame rate drops and back off when you change areas or the crowd thins out."
         },{
            "strName":"Char Page",
            "special":1,
            "sDesc":"Search Character Pages"
         },{
            "strName":"Character Select Screen",
            "bEnabled":this.litePreference.data.bCharSelect,
            "sDesc":"Allows you to replace the login screen with a character select screen."
         },{
            "strName":"Comic Sans Font",
            "bEnabled":this.litePreference.data.bComicSans,
            "sDesc":"Displays all player nameplates (name + guild) and monster nameplates (name + race) in Comic Sans MS."
         },{
            "strName":"Chat Settings",
            "bEnabled":this.litePreference.data.bChatFilter,
            "sDesc":"Allow the customization of the game\'s chat window with the options below!",
            "extra":[{
               "strName":"Timestamps",
               "bEnabled":this.litePreference.data.dOptions["timeStamps"],
               "sDesc":"Adding timestamps to chat messages (Server Time)\nOnly works on the old chat ui!"
            },{
               "strName":"Disable Red Messages",
               "bEnabled":this.litePreference.data.dOptions["disRed"],
               "sDesc":"Avoid receiving combat warning messages in chat"
            }]
         },{
            "strName":"Chat UI",
            "bEnabled":this.litePreference.data.bChatUI,
            "sDesc":"If enabled, you will switch to the new Chat UI.",
            "extra":[{
               "strName":"Minimal Mode",
               "bEnabled":this.litePreference.data.dOptions["chatMinimal"],
               "sDesc":"Less intrusive on your gameplay!\nHover over the message box to make the messages visible\nScroll over the message box to scroll!"
            },{
               "strName":"Disable AutoScroll to Bottom",
               "bEnabled":this.litePreference.data.dOptions["chatScroll"],
               "sDesc":"The Chat UI will not automatically scroll to the bottom on a new message"
            }]
         },{
            "strName":"Class Actives/Auras UI",
            "bEnabled":this.litePreference.data.bAuras,
            "sDesc":"Shows your buffs/auras and your target\'s, with stacks and timers from the server.\nHover to see the labels, drag them anywhere. Use \"Reset UI Positions\" if one goes off-screen.",
            "extra":[{
               "strName":"Disable ToolTips",
               "bEnabled":this.litePreference.data.dOptions["disAuraTips"],
               "sDesc":"Prevents you from seeing tooltips when hovering over an aura."
            },{
               "strName":"Disable Aura Text",
               "bEnabled":this.litePreference.data.dOptions["disAuraText"],
               "sDesc":"Prevents you from seeing the yellow aura text on you or other players."
            }]
         },{
            "strName":"Color Sets",
            "bEnabled":this.litePreference.data.bColorSets,
            "sDesc":"Save your colors with this tool that appears when you go customizing your hair or armor colors!"
         },{
            "strName":"Custom Drops UI",
            "bEnabled":this.litePreference.data.bCustomDrops,
            "sDesc":"Shift+Click to block an item drop!\nYour bank items must be loaded to detect if you already have an item",
            "extra":[{
               "strName":"Invert Menu",
               "bEnabled":this.litePreference.data.dOptions["invertMenu"],
               "sDesc":"The drop menu will appear at the top of the screen rather than appearing at the bottom"
            },{
               "strName":"Warn When Declining A Drop",
               "bEnabled":this.litePreference.data.dOptions["warnDecline"],
               "sDesc":"A confirmation box will appear to confirm if you want to decline an item drop"
            },{
               "strName":"Hide Drop Notifications",
               "bEnabled":this.litePreference.data.dOptions["hideDrop"],
               "sDesc":"This will hide regular drop notifications"
            },{
               "strName":"Hide Temporary Drop Notifications",
               "bEnabled":this.litePreference.data.dOptions["hideTemp"],
               "sDesc":"This will hide temporary drop notifications"
            },{
               "strName":"Opened Menu",
               "bEnabled":this.litePreference.data.dOptions["openMenu"],
               "sDesc":"The Custom Drops UI will start up opened rather than closed"
            },{
               "strName":"Draggable Mode",
               "bEnabled":this.litePreference.data.dOptions["dragMode"],
               "sDesc":"The Custom Drops UI will be draggable rather than being attached to the screen"
            },{
               "strName":"Lock Position",
               "bEnabled":this.litePreference.data.dOptions["lockMode"],
               "sDesc":"The draggable Custom Drops UI will not be moved from where it was last placed"
            },{
               "strName":"Reset Position",
               "extra":"btn",
               "sDesc":"If the Drop UI somehow goes off-screen and you can\'t see it, then use this to get it back!\nWorks only for \"Draggable Mode\""
            },{
               "strName":"Quantity Warnings",
               "bEnabled":this.litePreference.data.dOptions["termsAgree"],
               "sDesc":"By disabling this feature you understand help from player support for unaccepted drops will be limited"
            },{
               "strName":"Classic Drops on Mobile",
               "bEnabled":this.litePreference.data.dOptions["classicDropsMobile"] == true,
               "sDesc":"In mobile mode, keep this Custom Drops UI instead of the mobile drop tray and loot notifications"
            },{
               "strName":"Mobile Loot Notifications",
               "bEnabled":this.litePreference.data.dOptions["lootFeedOff"] != true,
               "sDesc":"In mobile mode, show an animated notification on the right side whenever you get a drop"
            }]
         },{
            "strName":"Disable Chat Scrolling",
            "bEnabled":this.litePreference.data.bDisChatScroll,
            "sDesc":"Prevents you from scrolling the chat\nOnly works on the old chat ui!"
         },{
            "strName":"Disable Damage Numbers",
            "bEnabled":this.litePreference.data.bDisDmgDisplay,
            "sDesc":"Disables all damage numbers from showing as well as the white flash/strobe effect"
         },{
            "strName":"Disable Damage Strobe",
            "bEnabled":this.litePreference.data.bDisDmgStrobe,
            "sDesc":"Prevents the white flash/strobe effect whenever a monster or player is damaged!"
         },{
            "strName":"Disable Monster Animations",
            "bEnabled":this.litePreference.data.bDisMonAnim,
            "sDesc":"Disables monster animations with the benefit of performance"
         },{
            "strName":"Disable Self Animations",
            "bEnabled":this.litePreference.data.bDisSelfMAnim,
            "sDesc":"Disables your player\'s movement animations except for walking for the benefit of performance"
         },{
            "strName":"Disable Skill Animations",
            "bEnabled":this.litePreference.data.bDisSkillAnim,
            "sDesc":"There are two types of animations: Class Skill Animations & Player Movement Animations\nThis feature disables Class Skill Animations only while the regular \"Animations\" setting will disable both Class Skill Animations & Player Movement Animations",
            "extra":[{
               "strName":"Show Your Skill Animations Only",
               "bEnabled":this.litePreference.data.dOptions["animSelf"],
               "sDesc":"Only works if \"Disable Skill Animations\" is enabled!\nAdds an exception to \"Disable Skill Animations\" to show your skill animations only"
            }]
         },{
            "strName":"Disable Quest Popup",
            "bEnabled":this.litePreference.data.bDisQPopup,
            "sDesc":"Prevent the Quest Complete Popup if it becomes too intrusive"
         },{
            "strName":"Disable Quest Tracker",
            "bEnabled":this.litePreference.data.bDisQTracker,
            "sDesc":"Prevent the Quest Tracker from opening"
         },{
            "strName":"Disable Weapon Animations",
            "bEnabled":this.litePreference.data.bDisWepAnim,
            "sDesc":"Disables weapon animations\nYou can disable a specific player\'s weapon animations by targetting them and clicking on their portrait!",
            "extra":[{
               "strName":"Keep Your Weapon Animations Only",
               "bEnabled":this.litePreference.data.dOptions["wepSelf"],
               "sDesc":"Only works if \"Disable Weapon Animation\" is enabled!\nHaving this enabled will allow your weapon animations to continue working while others have theirs disabled"
            }]
         },{
            "strName":"Decline All Drops",
            "extra":"btn",
            "sDesc":"Declines all the drops on your screen"
         },{
            "strName":"Display FPS",
            "extra":"btn",
            "sDesc":"Toggles the Frames Per Second Display"
         },{
            "strName":"Draggable Drops",
            "bEnabled":this.litePreference.data.bDraggable,
            "sDesc":"Allows you to drag, or move around, the drops on your screen\nToggling this on with drops already on your screen will not make those drops draggable\nOnly works if \"Custom Drops UI\" is not enabled"
         },{
            "strName":"Freeze / Lock Monster Position",
            "bEnabled":this.litePreference.data.bFreezeMons,
            "sDesc":"This will freeze monsters on the map in place to prevent players from luring/dragging monsters all over the map"
         },{
            "strName":"Invisible Monsters",
            "bEnabled":this.litePreference.data.bHideMons,
            "sDesc":"Make monsters invisible. You can target them by clicking on their shadow"
         },{
            "strName":"Hide Players",
            "bEnabled":this.litePreference.data.bHidePlayers,
            "sDesc":"This will hide players on the map\nYou can hide specific players by clicking on their portraits (targetting them)!",
            "extra":[{
               "strName":"Show Name Tags",
               "bEnabled":this.litePreference.data.dOptions["showNames"],
               "sDesc":"Only works if \"Hide Players\" is enabled!\nHaving this enabled will allow you to still see name tags of players even though they\'re hidden."
            },{
               "strName":"Show Shadows",
               "bEnabled":this.litePreference.data.dOptions["showShadows"],
               "sDesc":"Only works if \"Hide Players\" is enabled!\nHaving this enabled will allow you to still see player shadows and clicking on the shadows will target them."
            }]
         },{
            "strName":"Hide Player Names",
            "bEnabled":this.litePreference.data.bHideNames,
            "sDesc":"Hides player names\nHover over a player to reveal their name & guild",
            "extra":[{
               "strName":"Hide Guild Names Only",
               "bEnabled":this.litePreference.data.dOptions["hideGuild"],
               "sDesc":"Player names will be visible, and guild names will be hidden"
            },{
               "strName":"Hide Your Name Only",
               "bEnabled":this.litePreference.data.dOptions["hideSelf"],
               "sDesc":"Only your name will be hidden.\nEnabling this setting will not make \"Hide Guild Names Only\" work."
            }]
         },{
            "strName":"Hide UI",
            "bEnabled":this.litePreference.data.bHideUI,
            "sDesc":"Hides player & target portraits located on the top left as well as the map name & area list located on the bottom right"
         },{
            "strName":"Item Drops Block List",
            "extra":"btn",
            "sDesc":"Shift+Click dropped items while using \"Custom Drops UI\" to add items to block!"
         },{
            "strName":"Keybinds",
            "extra":"btn",
            "sDesc":"Customize game keybinds.\nYou can not bind ENTER or /.\nUse BACKSPACE to delete a bind."
         },{
            "strName":"Reaccept Quest After Turn-In",
            "bEnabled":this.litePreference.data.bReaccept,
            "sDesc":"After turning in a quest, it will try to reaccept the quest if possible"
         },{
            "strName":"Reset UI Positions",
            "extra":"btn",
            "sDesc":"If your aura, party or Monster Drops window gets dragged off-screen or you lose track of it, this puts them all back in their default spots."
         },{
            "strName":"Show Monster Type",
            "bEnabled":this.litePreference.data.bMonsType,
            "sDesc":"Display the monster\'s type as a tag under their name"
         },{
            "strName":"Smooth Background",
            "bEnabled":this.litePreference.data.bSmoothBG,
            "sDesc":"Removes map background pixelation by disabling the map background rasterizer.\nMay reduce performance on slower computers."
         },{
            "strName":"Travel Menu",
            "extra":"btn",
            "sDesc":"Jump between multiple maps with a press of a button!\nThe keybind to jump maps is rebindable within \"Keybinds\"!"
         },{
            "strName":"Quest Pinner",
            "bEnabled":this.litePreference.data.bQuestPin,
            "sDesc":"1. Open quests from any NPC\n2. Press the \"Pin Quests\" button (left)\n3. You can now access it from anywhere by clicking on the yellow (!) quest log icon at the top left!\nShift+Click the yellow (!) quest log icon to open the Quest Tracker!\nShift+Click the quest pinner icon to clear your pinned quests!"
         },{
            "strName":"Quest Progress Notifications",
            "bEnabled":this.litePreference.data.bQuestNotif,
            "sDesc":"Quest Progress will continue to notify/update you even when you\'ve completed the quest"
         },{
            "strName":"Visual Skill CDs",
            "bEnabled":this.litePreference.data.bSkillCD,
            "sDesc":"Visual skill cooldowns!"
         },{
            "strName":"Hide Ground Items",
            "bEnabled":this.litePreference.data.bDisGround,
            "sDesc":"Hides the item type \'Ground\' from other players",
            "extra":[{
               "strName":"Show Your Ground Item Only",
               "bEnabled":this.litePreference.data.dOptions["groundSelf"],
               "sDesc":"Other players\' ground items will be hidden, while yours remains visible"
            }]
         },{
            "strName":"Hide Healing Bubbles",
            "bEnabled":this.litePreference.data.bDisHealBubble,
            "sDesc":"Hides the green healing bubbles above players when they\'re low on health"
         },{
            "strName":"Disable Aura Animations",
            "bEnabled":this.litePreference.data.bDisAuraAnim,
            "sDesc":"Disables all animations that activate on aura that some classes have from showing",
            "extra":[{
               "strName":"Show Your Aura Animation Only",
               "bEnabled":this.litePreference.data.dOptions["auraAnimSelf"],
               "sDesc":"Other players\' aura animations will be hidden, while yours remains visible. Recommended to leave on."
            }]
         }];
      }

      public function isTestClient() : Boolean
      {
         var _loc1_:Array = null;
         var _loc2_:* = undefined;
         _loc1_ = ["Dev Grotto","Dev04"];
         for each(var _loc3_ in _loc1_)
         {
            _loc2_ = _loc3_;
            _loc3_;
            if(this.objServerInfo.sName.toLowerCase() == _loc2_.toLowerCase())
            {
               return true;
            }
         }
         return false;
      }

      public function castSpellFX(param1:*, param2:*, param3:*, param4:*) : *
      {
         this.cameraToolMC.castSpellFX();
      }

      public function movieClipStopAll(param1:MovieClip) : void
      {
         var _loc1_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < param1.numChildren)
         {
            if(param1.getChildAt(_loc1_) is MovieClip)
            {
               try
               {
                  (param1.getChildAt(_loc1_) as MovieClip).gotoAndStop(0);
                  this.movieClipStopAll(param1.getChildAt(_loc1_) as MovieClip);
               }
               catch(exception:*)
               {
               }
            }
            _loc1_++;
         }
      }

      public function rasterizePart(param1:DisplayObject) : Bitmap
      {
         var _loc1_:Matrix = null;
         var _loc2_:Rectangle = null;
         var _loc3_:Point = null;
         var _loc4_:Number = NaN;
         var _loc5_:BitmapData = null;
         var _loc6_:Bitmap = null;
         var _loc7_:Matrix = null;
         _loc1_ = param1.transform.matrix;
         _loc2_ = param1.getBounds(param1.parent);
         _loc3_ = new Point(param1.x - _loc2_.left,param1.y - _loc2_.top);
         _loc4_ = 1;
         if(param1.parent != null)
         {
            _loc7_ = param1.parent.transform.concatenatedMatrix;
            _loc4_ = Math.max(Math.sqrt(_loc7_.a * _loc7_.a + _loc7_.b * _loc7_.b),Math.sqrt(_loc7_.c * _loc7_.c + _loc7_.d * _loc7_.d));
         }
         if(_loc4_ <= 1)
         {
            _loc4_ = 1;
         }
         if(_loc4_ > 4)
         {
            _loc4_ = 4;
         }
         if(_loc2_.width * _loc4_ > 4095)
         {
            _loc4_ = Math.max(1,4095 / _loc2_.width);
         }
         if(_loc2_.height * _loc4_ > 4095)
         {
            _loc4_ = Math.max(1,4095 / _loc2_.height);
         }
         _loc1_.tx = _loc3_.x;
         _loc1_.ty = _loc3_.y;
         _loc1_.a = _loc1_.a * _loc4_;
         _loc1_.b = _loc1_.b * _loc4_;
         _loc1_.c = _loc1_.c * _loc4_;
         _loc1_.d = _loc1_.d * _loc4_;
         _loc1_.tx = _loc1_.tx * _loc4_;
         _loc1_.ty = _loc1_.ty * _loc4_;
         _loc5_ = new BitmapData(_loc2_.width * _loc4_,_loc2_.height * _loc4_,true,0);
         _loc5_.draw(param1,_loc1_,param1.transform.colorTransform,null,null,true);
         _loc6_ = new Bitmap(_loc5_);
         _loc6_.smoothing = true;
         _loc6_.scaleX = _loc6_.scaleY = 1 / _loc4_;
         _loc6_.x = _loc6_.x - _loc3_.x;
         _loc6_.y = _loc6_.y - _loc3_.y;
         return _loc6_;
      }

      public function rasterize(param1:MovieClip) : void
      {
         this.movieClipRasterizeInner(param1);
      }

      public function fixInputHeight(param1:*) : void
      {
         var _loc1_:Number = NaN;
         if(param1 == null)
         {
            return;
         }
         try
         {
            _loc1_ = param1.getLineMetrics(0).height + 4;
            if(param1.height < _loc1_)
            {
               param1.height = _loc1_;
            }
         }
         catch(e:Error)
         {
         }
      }

      public function setGoldDisplay(param1:*) : void
      {
         var _loc1_:* = undefined;
         try
         {
            _loc1_ = this.ui.mcInterface.mcGold.strGold;
            _loc1_.text = String(param1);
            this.fixInputHeight(_loc1_);
            if(_loc1_.width < _loc1_.textWidth + 4)
            {
               _loc1_.width = _loc1_.textWidth + 4;
            }
         }
         catch(e:Error)
         {
         }
      }

      private function findComicSansEmbedded() : String
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:Font = null;
         if(this.csFontChecked)
         {
            return this.csFontName;
         }
         this.csFontChecked = true;
         _loc1_ = Font.enumerateFonts(false);
         _loc2_ = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_];
            if(_loc3_.fontType == FontType.EMBEDDED)
            {
               if(_loc3_.fontName == "Comic Sans MS" && _loc3_.fontStyle == FontStyle.REGULAR)
               {
                  this.csFontName = _loc3_.fontName;
                  return this.csFontName;
               }
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_];
            if(_loc3_.fontType == FontType.EMBEDDED)
            {
               if(_loc3_.fontName.toLowerCase().indexOf("comic") > -1)
               {
                  this.csFontName = _loc3_.fontName;
                  return this.csFontName;
               }
            }
            _loc2_++;
         }
         trace("[UI] Comic Sans: no embedded font found, falling back to device font");
         return null;
      }

      public function applyComicSansPname(param1:*, param2:Boolean) : void
      {
         var _loc1_:String = null;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:* = undefined;
         var _loc5_:String = null;
         var _loc6_:TextFormat = null;
         var _loc7_:TextFormat = null;
         var _loc8_:TextFormat = null;
         var _loc9_:Object = null;
         var _loc10_:TextFormat = null;
         var _loc11_:TextFormat = null;
         if(!param1)
         {
            return;
         }
         _loc1_ = param2 ? this.findComicSansEmbedded() : null;
         _loc2_ = ["ti","tg","typ"];
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = param1[_loc2_[_loc3_]];
            if(_loc4_)
            {
               _loc5_ = "_csOrig_" + _loc2_[_loc3_];
               if(param2)
               {
                  if(param1[_loc5_] == null)
                  {
                     _loc8_ = _loc4_.defaultTextFormat;
                     param1[_loc5_] = {
                        "font":_loc8_.font,
                        "bold":_loc8_.bold,
                        "italic":_loc8_.italic,
                        "embed":_loc4_.embedFonts
                     };
                  }
                  _loc4_.embedFonts = _loc1_ != null;
                  _loc6_ = _loc4_.defaultTextFormat;
                  _loc6_.font = _loc1_ != null ? _loc1_ : "Comic Sans MS";
                  _loc6_.bold = false;
                  _loc6_.italic = false;
                  _loc4_.defaultTextFormat = _loc6_;
                  _loc7_ = new TextFormat();
                  _loc7_.font = _loc6_.font;
                  _loc7_.bold = false;
                  _loc7_.italic = false;
                  _loc4_.setTextFormat(_loc7_);
                  this.fixInputHeight(_loc4_);
               }
               else if(param1[_loc5_] != null)
               {
                  _loc9_ = param1[_loc5_];
                  _loc4_.embedFonts = _loc9_.embed == true;
                  _loc10_ = _loc4_.defaultTextFormat;
                  _loc10_.font = _loc9_.font;
                  _loc10_.bold = _loc9_.bold;
                  _loc10_.italic = _loc9_.italic;
                  _loc4_.defaultTextFormat = _loc10_;
                  _loc11_ = new TextFormat();
                  _loc11_.font = _loc9_.font;
                  _loc11_.bold = _loc9_.bold;
                  _loc11_.italic = _loc9_.italic;
                  _loc4_.setTextFormat(_loc11_);
                  this.fixInputHeight(_loc4_);
               }
            }
            _loc3_++;
         }
      }

      public function movieClipRasterizeInner(param1:MovieClip) : void
      {
         var _loc1_:uint = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:Sprite = null;
         var _loc4_:* = undefined;
         _loc1_ = 0;
         while(_loc1_ < param1.numChildren)
         {
            if(param1.getChildAt(_loc1_) is MovieClip)
            {
               try
               {
                  _loc2_ = param1.getChildAt(_loc1_) as MovieClip;
                  if(_loc2_.visible != false)
                  {
                     _loc2_.getChildAt(0).visible = false;
                     _loc3_ = new Sprite();
                     _loc3_.name = "rasterWrap";
                     _loc3_.addChild(this.rasterizePart(_loc2_.getChildAt(0)));
                     _loc4_ = _loc2_.addChildAt(_loc3_,0);
                     this.movieClipRasterizeInner(param1.getChildAt(_loc1_) as MovieClip);
                  }
               }
               catch(exception:*)
               {
               }
            }
            _loc1_++;
         }
      }

      public function derasterize(param1:MovieClip) : void
      {
         var _loc1_:* = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:Boolean = false;
         var _loc4_:Sprite = null;
         var _loc5_:Bitmap = null;
         _loc1_ = int(param1.numChildren - 1);
         for(; _loc1_ >= 0; _loc1_--)
         {
            if(param1.getChildAt(_loc1_) is MovieClip)
            {
               try
               {
                  _loc2_ = param1.getChildAt(_loc1_) as MovieClip;
                  this.derasterize(_loc2_);
                  _loc3_ = false;
                  while(_loc2_.numChildren > 0 && _loc2_.getChildAt(0).name == "rasterWrap")
                  {
                     _loc4_ = _loc2_.getChildAt(0) as Sprite;
                     _loc2_.removeChildAt(0);
                     _loc3_ = true;
                     while(_loc4_ != null && _loc4_.numChildren > 0)
                     {
                        _loc5_ = _loc4_.getChildAt(0) as Bitmap;
                        _loc4_.removeChildAt(0);
                        if(_loc5_ != null && _loc5_.bitmapData != null)
                        {
                           _loc5_.bitmapData.dispose();
                        }
                     }
                  }
                  if(_loc3_ && _loc2_.numChildren > 0)
                  {
                     _loc2_.getChildAt(0).visible = true;
                  }
               }
               catch(exception:*)
               {
                  continue;
               }
            }
         }
      }

      public function getQuestValidationString(param1:Object) : String
      {
         var _loc1_:int = 0;
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         var _loc4_:* = undefined;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:* = undefined;
         if(param1.sField != null && this.world.getAchievement(param1.sField,param1.iIndex) != 0)
         {
            if(param1.sField == "im0")
            {
               return "Monthly Quests are only available once per month.";
            }
            if(param1.sField == "iw0")
            {
               return "Weekly Quests are only available once per week.";
            }
            return "Daily Quests are only available once per day.";
         }
         if(param1.bUpg == 1 && !this.world.myAvatar.isUpgraded())
         {
            return "Upgrade is required for this quest!";
         }
         if(param1.iSlot >= 0 && this.world.getQuestValue(param1.iSlot) < param1.iValue - 1)
         {
            return "Quest has not been unlocked!";
         }
         if(param1.iLvl > this.world.myAvatar.objData.intLevel)
         {
            return "Unlocks at Level " + param1.iLvl + ".";
         }
         if(param1.iClass > 0 && this.world.myAvatar.getCPByID(param1.iClass) < param1.iReqCP)
         {
            _loc1_ = this.getRankFromPoints(param1.iReqCP);
            _loc2_ = param1.iReqCP - this.arrRanks[_loc1_ - 1];
            if(_loc2_ > 0)
            {
               return "Requires " + _loc2_ + " Class Points on " + param1.sClass + ", Rank " + _loc1_ + ".";
            }
            return "Requires " + param1.sClass + ", Rank " + _loc1_ + ".";
         }
         if(param1.FactionID > 1 && this.world.myAvatar.getRep(param1.FactionID) < param1.iReqRep)
         {
            _loc3_ = this.getRankFromPoints(param1.iReqRep);
            _loc4_ = param1.iReqRep - this.arrRanks[_loc3_ - 1];
            if(_loc4_ > 0)
            {
               return "Requires " + _loc4_ + " Reputation for " + param1.sFaction + ", Rank " + _loc3_ + ".";
            }
            return "Requires " + param1.sFaction + ", Rank " + _loc3_ + ".";
         }
         if(param1.reqd != null && !this.hasRequiredItemsForQuest(param1))
         {
            _loc5_ = "Required Item(s): ";
            _loc6_ = 0;
            while(_loc6_ < param1.reqd.length)
            {
               _loc7_ = this.world.invTree[param1.reqd[_loc6_].ItemID];
               _loc8_ = int(param1.reqd[_loc6_].iQty);
               if(_loc7_.sES == "ar")
               {
                  _loc9_ = this.getRankFromPoints(_loc8_);
                  _loc10_ = _loc8_ - this.arrRanks[_loc9_ - 1];
                  if(_loc10_ > 0)
                  {
                     _loc5_ = _loc5_ + (_loc10_ + " Class Points on ");
                  }
                  _loc5_ = _loc5_ + (_loc7_.sName + ", Rank " + _loc9_);
               }
               else
               {
                  _loc5_ = _loc5_ + _loc7_.sName;
                  if(_loc8_ > 1)
                  {
                     _loc5_ = _loc5_ + ("x" + _loc8_);
                  }
               }
               _loc5_ = _loc5_ + ", ";
               _loc6_++;
            }
            return _loc5_.substr(0,_loc5_.length - 2) + ".";
         }
         return "";
      }

      private function hasRequiredItemsForQuest(param1:Object) : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         if(param1.reqd != null && param1.reqd.length > 0)
         {
            _loc1_ = 0;
            while(_loc1_ < param1.reqd.length)
            {
               _loc2_ = param1.reqd[_loc1_].ItemID;
               _loc3_ = int(param1.reqd[_loc1_].iQty);
               if(this.world.invTree[_loc2_] == null || int(this.world.invTree[_loc2_].iQty) < _loc3_)
               {
                  return false;
               }
               _loc1_++;
            }
         }
         return true;
      }

      public function xTryMe(param1:Object) : *
      {
         var _loc1_:String = null;
         switch(param1.sES)
         {
            case "Weapon":
            case "he":
            case "ba":
            case "pe":
            case "ar":
            case "co":
            case "mi":
               _loc1_ = param1.sES;
               _loc1_ = _loc1_ == "ar" ? "co" : _loc1_;
               if(_loc1_ == "pe")
               {
                  if(this.world.myAvatar.objData.eqp["pe"])
                  {
                     this.world.myAvatar.unloadPet();
                  }
               }
               if(!this.world.myAvatar.objData.eqp[_loc1_])
               {
                  this.world.myAvatar.objData.eqp[_loc1_] = {};
                  this.world.myAvatar.objData.eqp[_loc1_].wasCreated = true;
               }
               if(Boolean(this.world.myAvatar.objData.eqp[_loc1_].isPreview) || Boolean(this.world.myAvatar.objData.eqp[_loc1_].wasCreated))
               {
                  if(this.world.myAvatar.objData.eqp[_loc1_].sFile == param1.sFile && this.world.myAvatar.objData.eqp[_loc1_].sType == param1.sType)
                  {
                     if(this.world.myAvatar.objData.eqp[_loc1_].wasCreated)
                     {
                        delete this.world.myAvatar.objData.eqp[_loc1_];
                        this.world.myAvatar.unloadMovieAtES(_loc1_);
                     }
                     else if(this.world.myAvatar.objData.eqp[_loc1_].isPreview)
                     {
                        if(_loc1_ == "pe")
                        {
                           if(this.world.myAvatar.objData.eqp["pe"])
                           {
                              this.world.myAvatar.unloadPet();
                           }
                        }
                        this.world.myAvatar.objData.eqp[_loc1_].sType = this.world.myAvatar.objData.eqp[_loc1_].oldType;
                        this.world.myAvatar.objData.eqp[_loc1_].sFile = this.world.myAvatar.objData.eqp[_loc1_].oldFile;
                        this.world.myAvatar.objData.eqp[_loc1_].sLink = this.world.myAvatar.objData.eqp[_loc1_].oldLink;
                        this.world.myAvatar.loadMovieAtES(_loc1_,this.world.myAvatar.objData.eqp[_loc1_].oldFile,this.world.myAvatar.objData.eqp[_loc1_].oldLink);
                        this.world.myAvatar.objData.eqp[_loc1_].isPreview = null;
                     }
                     return;
                  }
               }
               if(!this.world.myAvatar.objData.eqp[_loc1_].isPreview)
               {
                  this.world.myAvatar.objData.eqp[_loc1_].isPreview = true;
                  if(!this.world.myAvatar.objData.eqp[_loc1_].isShowable)
                  {
                     if("sType" in param1)
                     {
                        this.world.myAvatar.objData.eqp[_loc1_].oldType = this.world.myAvatar.objData.eqp[_loc1_].sType;
                     }
                     this.world.myAvatar.objData.eqp[_loc1_].oldFile = this.world.myAvatar.objData.eqp[_loc1_].sFile;
                     this.world.myAvatar.objData.eqp[_loc1_].oldLink = this.world.myAvatar.objData.eqp[_loc1_].sLink;
                  }
               }
               if("sType" in param1)
               {
                  this.world.myAvatar.objData.eqp[_loc1_].sType = param1.sType;
               }
               this.world.myAvatar.objData.eqp[_loc1_].sFile = param1.sFile == "undefined" ? "" : param1.sFile;
               this.world.myAvatar.objData.eqp[_loc1_].sLink = param1.sLink;
               this.world.myAvatar.loadMovieAtES(_loc1_,param1.sFile,param1.sLink);
               if(_loc1_ == "pe" && param1.sName.indexOf("Bank Pet") != -1)
               {
                  this.petDisable.addEventListener(TimerEvent.TIMER,this.onPetDisable,false,0,true);
                  this.petDisable.start();
               }
               this.hasPreviewed = true;
         }
      }

      internal function onPetDisable(param1:TimerEvent) : void
      {
         if(!this.world.myAvatar.petMC.mcChar)
         {
            return;
         }
         this.world.myAvatar.petMC.mcChar.mouseEnabled = false;
         this.world.myAvatar.petMC.mcChar.mouseChildren = false;
         this.world.myAvatar.petMC.mcChar.enabled = false;
         this.petDisable.reset();
         this.petDisable.removeEventListener(TimerEvent.TIMER,this.onPetDisable);
      }

      public function showPortrait(param1:Avatar) : *
      {
         if(this.litePreference.data.bHideUI)
         {
            return;
         }
         this.showPortraitBox(param1,this.ui.mcPortrait);
         this.world.updatePortrait(param1);
         this.ui.iconQuest.visible = true;
         this.ui.monsterIcon.visible = true;
         if(this.mailHub != null)
         {
            this.mailHub.placeHud();
         }
      }

      public function hidePortrait() : void
      {
         this.ui.monsterIcon.visible = false;
         this.ui.mcPortrait.visible = false;
         this.ui.iconQuest.visible = false;
         if(this.mailHub != null)
         {
            this.mailHub.placeHud();
         }
      }

      public function showPortraitTarget(param1:Avatar) : *
      {
         if(this.litePreference.data.bHideUI)
         {
            return;
         }
         this.showPortraitBox(Number(this.world.objExtra["bChar"]) == 1 ? this.world.myAvatar : param1,this.ui.mcPortraitTarget);
         this.ui.mcPortraitTarget.pvpIcon.visible = this.world.bPvP;
         this.world.updatePortrait(param1);
         this.ui.btnTargetPortraitClose.visible = true;
      }

      public function hidePortraitTarget() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:DisplayObject = null;
         _loc1_ = this.ui.mcPortraitTarget.mcHead as MovieClip;
         _loc2_ = _loc1_.head.getChildByName("face");
         if(_loc2_ != null)
         {
            _loc1_.head.removeChild(_loc2_);
         }
         while(_loc1_.backhair.numChildren > 0)
         {
            _loc1_.backhair.removeChildAt(0);
         }
         while(_loc1_.head.hair.numChildren > 0)
         {
            _loc1_.head.hair.removeChildAt(0);
         }
         while(_loc1_.head.helm.numChildren > 0)
         {
            _loc1_.head.helm.removeChildAt(0);
         }
         this.ui.mcPortraitTarget.visible = false;
         this.ui.btnTargetPortraitClose.visible = false;
      }

      public function showPortraitBox(param1:Avatar, param2:MovieClip) : *
      {
         var AssetClass:Class = null;
         var mc:MovieClip = null;
         var child:DisplayObject = null;
         var bBackHair:Boolean = false;
         var sSkinLink:String = null;
         var AssetClass2:Class = null;
         var avt:Avatar = param1;
         var mcPortraitBox:MovieClip = param2;
         mc = mcPortraitBox.mcHead as MovieClip;
         bBackHair = false;
         mcPortraitBox.pAV = avt;
         if(avt.npcType == "monster")
         {
            AssetClass = this.world.getClass("mcHead" + avt.objData.strLinkage);
            child = mc.head.getChildByName("face");
            if(child != null)
            {
               mc.head.removeChild(child);
            }
            mc.head.addChildAt(new AssetClass(),0).name = "face";
            mc.head.hair.visible = false;
            mc.head.helm.visible = false;
            mc.backhair.visible = false;
         }
         else
         {
            try
            {
               sSkinLink = avt.objData.eqp.ar.sLink;
               if(avt.objData.eqp.co != null)
               {
                  sSkinLink = avt.objData.eqp.co.sLink;
               }
               AssetClass = this.world.getClass(sSkinLink + avt.objData.strGender + "Head");
               child = mc.head.getChildByName("face");
               if(child != null)
               {
                  mc.head.removeChild(child);
               }
               mc.head.addChildAt(new AssetClass(),0).name = "face";
            }
            catch(err:Error)
            {
               AssetClass = world.getClass("mcHead" + avt.objData.strGender);
               child = mc.head.getChildByName("face");
               if(child != null)
               {
                  mc.head.removeChild(child);
               }
               mc.head.addChildAt(new AssetClass(),0).name = "face";
            }
            AssetClass = this.world.getClass(avt.objData.strHairName + avt.objData.strGender + "Hair");
            while(mc.head.hair.numChildren > 0)
            {
               mc.head.hair.removeChildAt(0);
            }
            try
            {
               mc.head.hair.addChild(new AssetClass());
            }
            catch(e:Error)
            {
            }
            mc.head.hair.visible = true;
            try
            {
               AssetClass = this.world.getClass(avt.objData.strHairName + avt.objData.strGender + "HairBack");
               while(mc.backhair.numChildren > 0)
               {
                  mc.backhair.removeChildAt(0);
               }
               mc.backhair.addChild(new AssetClass());
               mc.backhair.visible = true;
               bBackHair = true;
            }
            catch(err:Error)
            {
               mc.backhair.visible = false;
            }
            if(avt.objData.eqp.he != null && avt.objData.eqp.he.sLink != null)
            {
               try
               {
                  AssetClass = this.world.getClass(avt.objData.eqp.he.sLink);
                  AssetClass2 = this.world.getClass(avt.objData.eqp.he.sLink + "_backhair") as Class;
                  while(mc.head.helm.numChildren > 0)
                  {
                     mc.head.helm.removeChildAt(0);
                  }
                  mc.head.helm.addChild(new AssetClass());
                  mc.head.helm.visible = avt.dataLeaf.showHelm;
                  mc.head.hair.visible = !mc.head.helm.visible;
                  if(AssetClass2 != null)
                  {
                     if(avt.dataLeaf.showHelm)
                     {
                        if(mc.backhair.numChildren > 0)
                        {
                           mc.backhair.removeChildAt(0);
                        }
                        mc.backhair.visible = true;
                        mc.backhair.addChild(new AssetClass2());
                     }
                  }
                  else
                  {
                     mc.backhair.visible = mc.head.hair.visible && bBackHair;
                  }
               }
               catch(err:Error)
               {
                  mc.head.helm.visible = false;
               }
            }
            else
            {
               mc.head.helm.visible = false;
            }
         }
         mcPortraitBox.visible = true;
         this.ui.mcPortrait.iconDrops.initRoot(this);
         this.ui.mcPortrait.iconDrops.visible = this.litePreference.data.bCustomDrops && !Mobile.useDropTray;
      }

      public function oniconQuestClick(param1:MouseEvent) : void
      {
         if(this.litePreference.data.bQuestPin)
         {
            if(param1.shiftKey)
            {
               this.ui.mcQTracker.toggle();
               return;
            }
            this.world.showQuests(this.pinnedQuests,"q");
         }
         else
         {
            this.ui.mcQTracker.toggle();
         }
      }

      public function organizeBoostIcons() : void
      {
         BoostTray.layout(this);
      }

      public function manageXPBoost(param1:Object) : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         this.ui.mcPortrait.iconBoostXP.visible = param1.op == "+";
         this.organizeBoostIcons();
         if(param1.op == "+")
         {
            this.world.myAvatar.objData.iBoostXP = param1.iSecsLeft;
            this.ui.mcPortrait.iconBoostXP.boostTS = new Date().getTime();
            this.ui.mcPortrait.iconBoostXP.iBoostXP = param1.iSecsLeft;
            this.ui.mcPortrait.iconBoostXP.bShowShop = param1.bShowShop;
            this.addUpdate("You have activated the Experience Boost!  All Experience rewards are doubled while the effect holds.");
            this.chatF.pushMsg("server","You have activated the Experience Boost!  All Experience rewards are doubled while the effect holds. " + Math.ceil(param1.iSecsLeft / 60) + " minute(s) remaining.","SERVER","",0);
         }
         else
         {
            delete this.world.myAvatar.objData.iBoostXP;
            delete this.ui.mcPortrait.iconBoostXP.boostTS;
            delete this.ui.mcPortrait.iconBoostXP.iBoostXP;
            this.addUpdate("The Experience Boost has faded!  Experience rewards are no longer doubled.");
            this.chatF.pushMsg("server","The Experience Boost has faded!  Experience rewards are no longer doubled.","SERVER","",0);
            if(this.ui.mcPortrait.iconBoostXP.bShowShop != null && Boolean(this.ui.mcPortrait.iconBoostXP.bShowShop))
            {
               _loc1_ = new ModalMC();
               _loc2_ = {};
               _loc2_.strBody = "Your Experience Boost has faded!\tExperience rewards are no longer doubled.  Would you like to purchase a new Experience Boost?";
               _loc2_.params = {};
               _loc2_.callback = this.openExpBoostStore;
               _loc2_.glow = "red,medium";
               this.ui.ModalStack.addChild(_loc1_);
               _loc1_.init(_loc2_);
            }
         }
      }

      public function manageGBoost(param1:Object) : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         this.ui.mcPortrait.iconBoostG.visible = param1.op == "+";
         this.organizeBoostIcons();
         if(param1.op == "+")
         {
            this.world.myAvatar.objData.iBoostG = param1.iSecsLeft;
            this.ui.mcPortrait.iconBoostG.boostTS = new Date().getTime();
            this.ui.mcPortrait.iconBoostG.iBoostG = param1.iSecsLeft;
            this.ui.mcPortrait.iconBoostG.bShowShop = param1.bShowShop;
            this.addUpdate("You have activated the Gold Boost!  All Gold rewards are doubled while the effect holds.");
            this.chatF.pushMsg("server","You have activated the Gold Boost!  All Gold rewards are doubled while the effect holds. " + Math.ceil(param1.iSecsLeft / 60) + " minute(s) remaining.","SERVER","",0);
         }
         else
         {
            delete this.world.myAvatar.objData.iBoostG;
            delete this.ui.mcPortrait.iconBoostG.boostTS;
            delete this.ui.mcPortrait.iconBoostG.iBoostG;
            this.addUpdate("The Gold Boost has faded!  Gold rewards are no longer doubled.");
            this.chatF.pushMsg("server","The Gold Boost has faded!  Gold rewards are no longer doubled.","SERVER","",0);
            if(this.ui.mcPortrait.iconBoostG.bShowShop != null && Boolean(this.ui.mcPortrait.iconBoostG.bShowShop))
            {
               _loc1_ = new ModalMC();
               _loc2_ = {};
               _loc2_.strBody = "Your Gold Boost has faded!  Gold rewards are no longer doubled.  Would you like to purchase a new Gold Boost?";
               _loc2_.params = {};
               _loc2_.callback = this.openExpBoostStore;
               _loc2_.glow = "red,medium";
               this.ui.ModalStack.addChild(_loc1_);
               _loc1_.init(_loc2_);
            }
         }
      }

      public function manageRepBoost(param1:Object) : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         this.ui.mcPortrait.iconBoostRep.visible = param1.op == "+";
         this.organizeBoostIcons();
         if(param1.op == "+")
         {
            this.world.myAvatar.objData.iBoostRep = param1.iSecsLeft;
            this.ui.mcPortrait.iconBoostRep.boostTS = new Date().getTime();
            this.ui.mcPortrait.iconBoostRep.iBoostRep = param1.iSecsLeft;
            this.ui.mcPortrait.iconBoostRep.bShowShop = param1.bShowShop;
            this.addUpdate("You have activated the Reputation Boost!  All Reputation rewards are doubled while the effect holds.");
            this.chatF.pushMsg("server","You have activated the Reputation Boost!  All Reputation rewards are doubled while the effect holds. " + Math.ceil(param1.iSecsLeft / 60) + " minute(s) remaining.","SERVER","",0);
         }
         else
         {
            delete this.world.myAvatar.objData.iBoostRep;
            delete this.ui.mcPortrait.iconBoostRep.boostTS;
            delete this.ui.mcPortrait.iconBoostRep.iBoostRep;
            this.addUpdate("The Reputation Boost has faded!  Reputation rewards are no longer doubled.");
            this.chatF.pushMsg("server","The Reputation Boost has faded!  Reputation rewards are no longer doubled.","SERVER","",0);
            if(this.ui.mcPortrait.iconBoostRep.bShowShop != null && Boolean(this.ui.mcPortrait.iconBoostRep.bShowShop))
            {
               _loc1_ = new ModalMC();
               _loc2_ = {};
               _loc2_.strBody = "Your Reputation Boost has faded!\tReputation rewards are no longer doubled.  Would you like to purchase a new Reputation Boost?";
               _loc2_.params = {};
               _loc2_.callback = this.openExpBoostStore;
               _loc2_.glow = "red,medium";
               this.ui.ModalStack.addChild(_loc1_);
               _loc1_.init(_loc2_);
            }
         }
      }

      public function manageCPBoost(param1:Object) : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         this.ui.mcPortrait.iconBoostCP.visible = param1.op == "+";
         this.organizeBoostIcons();
         if(param1.op == "+")
         {
            this.world.myAvatar.objData.iBoostCP = param1.iSecsLeft;
            this.ui.mcPortrait.iconBoostCP.boostTS = new Date().getTime();
            this.ui.mcPortrait.iconBoostCP.iBoostCP = param1.iSecsLeft;
            this.ui.mcPortrait.iconBoostCP.bShowShop = param1.bShowShop;
            this.addUpdate("You have activated the ClassPoint Boost!  All ClassPoint rewards are doubled while the effect holds.");
            this.chatF.pushMsg("server","You have activated the ClassPoint Boost!  All ClassPoint rewards are doubled while the effect holds. " + Math.ceil(param1.iSecsLeft / 60) + " minute(s) remaining.","SERVER","",0);
         }
         else
         {
            delete this.world.myAvatar.objData.iBoostCP;
            delete this.ui.mcPortrait.iconBoostCP.boostTS;
            delete this.ui.mcPortrait.iconBoostCP.iBoostCP;
            this.addUpdate("The ClassPoint Boost has faded!  ClassPoint rewards are no longer doubled.");
            this.chatF.pushMsg("server","The ClassPoint Boost has faded!  ClassPoint rewards are no longer doubled.","SERVER","",0);
            if(this.ui.mcPortrait.iconBoostCP.bShowShop != null && Boolean(this.ui.mcPortrait.iconBoostCP.bShowShop))
            {
               _loc1_ = new ModalMC();
               _loc2_ = {};
               _loc2_.strBody = "Your ClassPoint Boost has faded!\tClassPoint rewards are no longer doubled.  Would you like to purchase a new ClassPoint Boost?";
               _loc2_.params = {};
               _loc2_.callback = this.openExpBoostStore;
               _loc2_.glow = "red,medium";
               this.ui.ModalStack.addChild(_loc1_);
               _loc1_.init(_loc2_);
            }
         }
      }

      public function oniconBoostXPOver(param1:MouseEvent) : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         _loc1_ = MovieClip(param1.currentTarget);
         _loc2_ = new Date().getTime();
         _loc3_ = Math.max(_loc1_.boostTS + _loc1_.iBoostXP * 1000 - _loc2_,0);
         _loc4_ = 0;
         _loc5_ = "All Experience gains are doubled.\n";
         if(_loc3_ < 120000)
         {
            _loc4_ = Math.floor(_loc3_ / 60000);
            _loc5_ = _loc5_ + String(_loc4_ + " minute(s), ");
            _loc4_ = Math.round(_loc3_ % 60000 / 1000);
            _loc5_ = _loc5_ + String(_loc4_ + " second(s) remaining.");
         }
         else
         {
            _loc4_ = Math.round(_loc3_ / 60000);
            _loc5_ = _loc5_ + String(_loc4_ + " minutes remaining.");
         }
         this.ui.ToolTip.openWith({"str":_loc5_});
      }

      public function oniconBoostGoldOver(param1:MouseEvent) : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         _loc1_ = MovieClip(param1.currentTarget);
         _loc2_ = new Date().getTime();
         _loc3_ = Math.max(_loc1_.boostTS + _loc1_.iBoostG * 1000 - _loc2_,0);
         _loc4_ = 0;
         _loc5_ = "All Gold gains are doubled.\n";
         if(_loc3_ < 120000)
         {
            _loc4_ = Math.floor(_loc3_ / 60000);
            _loc5_ = _loc5_ + String(_loc4_ + " minute(s), ");
            _loc4_ = Math.round(_loc3_ % 60000 / 1000);
            _loc5_ = _loc5_ + String(_loc4_ + " second(s) remaining.");
         }
         else
         {
            _loc4_ = Math.round(_loc3_ / 60000);
            _loc5_ = _loc5_ + String(_loc4_ + " minutes remaining.");
         }
         this.ui.ToolTip.openWith({"str":_loc5_});
      }

      public function oniconBoostRepOver(param1:MouseEvent) : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         _loc1_ = MovieClip(param1.currentTarget);
         _loc2_ = new Date().getTime();
         _loc3_ = Math.max(_loc1_.boostTS + _loc1_.iBoostRep * 1000 - _loc2_,0);
         _loc4_ = 0;
         _loc5_ = "All Reputation gains are doubled.\n";
         if(_loc3_ < 120000)
         {
            _loc4_ = Math.floor(_loc3_ / 60000);
            _loc5_ = _loc5_ + String(_loc4_ + " minute(s), ");
            _loc4_ = Math.round(_loc3_ % 60000 / 1000);
            _loc5_ = _loc5_ + String(_loc4_ + " second(s) remaining.");
         }
         else
         {
            _loc4_ = Math.round(_loc3_ / 60000);
            _loc5_ = _loc5_ + String(_loc4_ + " minutes remaining.");
         }
         this.ui.ToolTip.openWith({"str":_loc5_});
      }

      public function oniconBoostCPOver(param1:MouseEvent) : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         _loc1_ = MovieClip(param1.currentTarget);
         _loc2_ = new Date().getTime();
         _loc3_ = Math.max(_loc1_.boostTS + _loc1_.iBoostCP * 1000 - _loc2_,0);
         _loc4_ = 0;
         _loc5_ = "All ClassPoint gains are doubled.\n";
         if(_loc3_ < 120000)
         {
            _loc4_ = Math.floor(_loc3_ / 60000);
            _loc5_ = _loc5_ + String(_loc4_ + " minute(s), ");
            _loc4_ = Math.round(_loc3_ % 60000 / 1000);
            _loc5_ = _loc5_ + String(_loc4_ + " second(s) remaining.");
         }
         else
         {
            _loc4_ = Math.round(_loc3_ / 60000);
            _loc5_ = _loc5_ + String(_loc4_ + " minutes remaining.");
         }
         this.ui.ToolTip.openWith({"str":_loc5_});
      }

      public function openExpBoostStore(param1:Object) : void
      {
         if(param1.accept)
         {
            this.world.sendLoadShopRequest(184);
         }
      }

      public function oniconBoostOut(param1:MouseEvent) : void
      {
         this.ui.ToolTip.close();
      }

      public function updateXPBar() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         if(this.ui == null || this.ui.mcInterface == null || this.world == null || this.world.myAvatar == null || this.world.myAvatar.objData == null)
         {
            return;
         }
         _loc1_ = this.world.myAvatar.objData.intExp / this.world.myAvatar.objData.intExpToLevel;
         this.ui.mcInterface.mcXPBar.mcXP.scaleX = _loc1_ > 1 ? 1 : _loc1_;
         _loc2_ = this.world.myAvatar.objData;
         _loc3_ = _loc2_.intExp;
         _loc4_ = _loc2_.intExpToLevel;
         _loc5_ = int(_loc3_ / _loc4_ * 100);
         if(_loc5_ >= 100)
         {
            _loc5_ = 100;
         }
         this.ui.mcInterface.mcXPBar.strXP.text = "Level " + this.world.myAvatar.objData.intLevel + " : " + _loc3_ + " / " + _loc4_ + "  (" + _loc5_ + "%)";
         this.fixInputHeight(this.ui.mcInterface.mcXPBar.strXP);
      }

      public function xpBarMouseOver(param1:MouseEvent) : *
      {
         MovieClip(param1.currentTarget).strXP.visible = true;
      }

      public function xpBarMouseOut(param1:MouseEvent) : *
      {
         MovieClip(param1.currentTarget).strXP.visible = false;
      }

      public function updateRepBar() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(this.ui == null || this.ui.mcInterface == null || this.world == null || this.world.myAvatar == null || this.world.myAvatar.objData == null)
         {
            return;
         }
         _loc1_ = this.world.myAvatar.objData.iCurCP;
         _loc2_ = this.world.myAvatar.objData.iCPToRank;
         if(_loc2_ <= 0)
         {
            this.ui.mcInterface.mcRepBar.mcRep.scaleX = 0.1;
            this.ui.mcInterface.mcRepBar.mcRep.visible = false;
            this.ui.mcInterface.mcRepBar.strRep.text = this.world.myAvatar.objData.strClassName + ", Rank " + this.world.myAvatar.objData.iRank;
         }
         else
         {
            _loc3_ = int(_loc1_ / _loc2_ * 100);
            if(_loc3_ >= 100)
            {
               _loc3_ = 100;
            }
            this.ui.mcInterface.mcRepBar.mcRep.scaleX = _loc1_ / _loc2_;
            this.ui.mcInterface.mcRepBar.mcRep.visible = true;
            this.ui.mcInterface.mcRepBar.strRep.text = this.world.myAvatar.objData.strClassName + ", Rank " + this.world.myAvatar.objData.iRank + " : " + _loc1_ + "/" + _loc2_ + "  (" + _loc3_ + "%)";
         }
      }

      public function onRepBarMouseOver(param1:MouseEvent) : *
      {
         MovieClip(param1.currentTarget).strRep.visible = true;
      }

      public function onRepBarMouseOut(param1:MouseEvent) : *
      {
         MovieClip(param1.currentTarget).strRep.visible = false;
      }

      public function disabledDelay(param1:TimerEvent) : void
      {
      }

      public function actIconClick(param1:MouseEvent) : *
      {
         var _loc1_:* = undefined;
         _loc1_ = MovieClip(param1.currentTarget).actObj;
         if(_loc1_.auto != null && _loc1_.auto == true)
         {
            this.world.approachTarget();
         }
         else
         {
            this.world.testAction(_loc1_);
         }
      }

      public function determineIndex(param1:Number) : Number
      {
         var _loc1_:Number = NaN;
         _loc1_ = 10;
         if(param1 <= 3)
         {
            _loc1_ = param1;
         }
         else if(param1 == 4)
         {
            _loc1_ = 5;
         }
         else if(param1 <= 6)
         {
            _loc1_ = 4;
         }
         return _loc1_;
      }

      public function mergeProcs(param1:Object) : void
      {
         var _loc1_:String = null;
         for(var _loc2_ in param1)
         {
            _loc1_ = _loc2_;
            _loc2_;
            this.procInfo[_loc1_] = param1[_loc1_];
         }
      }

      public function procTipText(param1:int) : String
      {
         var _loc1_:Object = null;
         var _loc2_:String = null;
         var _loc3_:Number = NaN;
         _loc1_ = this.procInfo[String(param1)];
         if(_loc1_ == null)
         {
            return "<b>No skill info for this trait.</b>";
         }
         _loc2_ = "<b>" + _loc1_.nam + "</b>\n";
         _loc3_ = Number(_loc1_.pct);
         if(_loc3_ > 0)
         {
            _loc2_ = _loc2_ + ("<font color=\'#007A00\'>" + Math.round(_loc3_ * 10) / 10 + "% chance" + (PROC_SLOTS[_loc1_.ref] != null ? " on " + PROC_SLOTS[_loc1_.ref] : "") + "</font>\n");
         }
         return _loc2_ + this.skillTipBody(_loc1_);
      }

      public function skillTipBody(param1:Object) : String
      {
         var _loc1_:String = null;
         _loc1_ = "";
         if(param1.desc != null)
         {
            param1.desc = String(param1.desc).replace(this.regExLineSpace,"\n");
         }
         if(param1.typ != "passive")
         {
            if(param1.mp > 0)
            {
               _loc1_ = _loc1_ + ("<font color=\'#0033AA\'>" + param1.mp + "</font> mana, ");
            }
            _loc1_ = _loc1_ + ("<font color=\'#AA3300\'>" + param1.cd / 1000 + "</font> sec cooldown" + "\n");
         }
         switch(param1.typ)
         {
            case "p":
            case "ph":
            case "aa":
               _loc1_ = _loc1_ + "Physical";
               break;
            case "m":
               _loc1_ = _loc1_ + "Magical";
               break;
            case "ma":
               _loc1_ = _loc1_ + "True Damage";
               break;
            case "pm":
            case "mp":
               _loc1_ = _loc1_ + "Hybrid";
               break;
            case "passive":
               _loc1_ = _loc1_ + "<font color=\'#0033AA\'>Passive Ability</font>";
         }
         _loc1_ = _loc1_ + "\n";
         if(param1.typ != "passive")
         {
            if(param1.range <= 301)
            {
               _loc1_ = _loc1_ + "A <font color=\'#AA3300\'>short range</font> ";
            }
            else if(param1.range >= 3000)
            {
               _loc1_ = _loc1_ + "An <font color=\'#0033AA\'>infinite range</font> ";
            }
            else if(param1.range >= 808)
            {
               _loc1_ = _loc1_ + "A <font color=\'#0033AA\'>long range</font> ";
            }
            else
            {
               _loc1_ = _loc1_ + "A <font color=\'#AA3300\'>medium range</font> ";
            }
            if(!param1.damage)
            {
               _loc1_ = _loc1_ + "status skill that applies to ";
            }
            else
            {
               _loc1_ = _loc1_ + ((param1.damage < 0 ? "skill" : "attack") + " that " + (param1.damage < 0 ? "heals " : "deals damage to "));
            }
            if(param1.tgt == "f")
            {
               _loc1_ = _loc1_ + ("<font color=\'#0033AA\'>" + (param1.tgtMax || 1));
               _loc1_ = _loc1_ + (param1.tgtMax > 1 ? " friendly targets.</font>" : " target.</font>");
            }
            else if(param1.tgt == "s")
            {
               _loc1_ = _loc1_ + "<font color=\'#0033AA\'>yourself.</font>";
            }
            else
            {
               _loc1_ = _loc1_ + ("<font color=\'#AA3300\'>" + (param1.tgtMax || 1));
               _loc1_ = _loc1_ + (param1.tgtMax > 1 ? " hostile targets.</font>" : " target.</font>");
            }
            _loc1_ = _loc1_ + "\n\n";
         }
         if(param1.sArg2 != null && param1.sArg2 != "")
         {
            _loc1_ = _loc1_ + param1.sArg2;
         }
         else if(param1.desc != null)
         {
            _loc1_ = _loc1_ + param1.desc;
         }
         return _loc1_;
      }

      public function actIconOver(param1:MouseEvent) : *
      {
         var _loc1_:MovieClip = null;
         var _loc2_:* = undefined;
         var _loc3_:String = null;
         _loc1_ = MovieClip(param1.currentTarget);
         if(Boolean(this.uoPref.bTT) || this.world.myAvatar.dataLeaf.intState != 2)
         {
            if(_loc1_.item == null)
            {
               _loc2_ = _loc1_.actObj;
               if(_loc2_ != null)
               {
                  _loc3_ = "<b>" + _loc2_.nam + "</b>\n";
                  if(!_loc2_.isOK)
                  {
                     _loc3_ = _loc3_ + ("<font color=\'#FF0000\'>Unlocks at Rank " + String(this.determineIndex(_loc1_.actionIndex)) + "!</font>\n");
                  }
                  _loc3_ = _loc3_ + this.skillTipBody(_loc2_);
                  this.ui.ToolTip.openWith({
                     "str":_loc3_,
                     "lowerright":true
                  });
               }
            }
            else
            {
               this.ui.ToolTip.openWith({
                  "str":_loc1_.item.sName + "\n" + "<font color=\'#AA3300\'>" + _loc1_.actObj.cd / 1000 + "</font> sec cooldown\n" + _loc1_.item.sDesc,
                  "lowerright":true
               });
            }
         }
      }

      public function actIconOut(param1:MouseEvent) : *
      {
         var _loc1_:* = undefined;
         _loc1_ = MovieClip(stage.getChildAt(0)).ui.ToolTip;
         _loc1_.close();
      }

      public function portraitClick(param1:MouseEvent) : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         _loc1_ = MovieClip(param1.currentTarget);
         if(_loc1_.pAV.npcType == "player")
         {
            _loc2_ = {};
            _loc2_.ID = _loc1_.pAV.objData.CharID;
            _loc2_.strUsername = _loc1_.pAV.objData.strUsername;
            if(_loc1_.pAV != this.world.myAvatar)
            {
               this.ui.cMenu.fOpenWith("user",_loc2_);
            }
            else
            {
               this.ui.cMenu.fOpenWith("self",_loc2_);
            }
         }
         else if(_loc1_.pAV.npcType == "monster")
         {
            _loc2_ = {};
            _loc2_.ID = _loc1_.pAV.objData.MonMapID;
            _loc2_.strUsername = _loc1_.pAV.objData.strMonName;
            _loc2_.target = this.world.getMonster(_loc2_.ID).pMC;
            this.ui.cMenu.fOpenWith("mons",_loc2_);
         }
      }

      private function onTargetPortraitCloseClick(param1:MouseEvent) : void
      {
         this.world.cancelTarget();
      }

      private function onBtnMonsterClick(param1:MouseEvent) : void
      {
         this.world.toggleMonsters();
      }

      public function showMap() : void
      {
         this.ui.mcInterface.mcMenu.mcMenuButtons.visible = true;
         this.ui.mcPopup.fOpen("Map");
      }

      public function logout() : void
      {
         try
         {
            if(Boolean(this.intChatMode) && Boolean(this.chatF.bTall))
            {
               this.ui.mcInterface.ncModeChat.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            }
         }
         catch(eLO:Error)
         {
            trace("[Game] ERR logout pre-send: " + eLO.message);
         }
         try
         {
            if(this.litePreference.data.bCharSelect)
            {
               this.saveChar();
            }
         }
         catch(eLO2:Error)
         {
            trace("[Game] ERR logout saveChar: " + eLO2.message);
         }
         trace("[Game] logout called");
         this.sfc.sendXtMessage("zm","cmd",["logout"],"str",1);
      }

      public function showServerList() : void
      {
         try
         {
            if(Boolean(this.intChatMode) && Boolean(this.chatF.bTall))
            {
               this.ui.mcInterface.ncModeChat.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            }
         }
         catch(eSL:Error)
         {
            trace("[Game] ERR showServerList pre-send: " + eSL.message);
         }
         try
         {
            if(this.litePreference.data.bCharSelect)
            {
               this.saveChar();
            }
         }
         catch(eSL2:Error)
         {
            trace("[Game] ERR showServerList saveChar: " + eSL2.message);
         }
         this.showServers = true;
         this.sfc.sendXtMessage("zm","cmd",["logout"],"str",1);
      }

      public function showUpgradeWindow(param1:Object = null) : void
      {
         var _loc1_:MovieClip = null;
         if(mcUpgradeWindow == null)
         {
            mcUpgradeWindow = new MCUpgradeWindow();
         }
         _loc1_ = mcUpgradeWindow as MovieClip;
         var _loc2_:* = param1 != null ? param1 : this.world.myAvatar.objData;
         _loc1_.btnClose.addEventListener(MouseEvent.CLICK,this.hideUpgradeWindow,false,0,true);
         _loc1_.btnClose2.addEventListener(MouseEvent.CLICK,this.hideUpgradeWindow,false,0,true);
         _loc1_.btnBuy.addEventListener(MouseEvent.CLICK,this.onUpgradeClick,false,0,true);
         addChild(mcUpgradeWindow);
         try
         {
            this.ui.mouseChildren = false;
            this.world.mouseChildren = false;
         }
         catch(e:Error)
         {
         }
         try
         {
            this.mcLogin.sl.mouseChildren = false;
         }
         catch(e:Error)
         {
         }
      }

      public function hideUpgradeWindow(param1:MouseEvent) : void
      {
         removeChild(mcUpgradeWindow);
         try
         {
            this.ui.mouseChildren = true;
            this.world.mouseChildren = true;
         }
         catch(e:Error)
         {
         }
         try
         {
            this.mcLogin.sl.mouseChildren = true;
         }
         catch(e:Error)
         {
         }
      }

      public function onUpgradeClick(param1:Event) : void
      {
         var _loc1_:String = null;
         this.mixer.playSound("Click");
         if(ISWEB)
         {
            this.extCall.setUpPayment(this.sToken);
         }
         else
         {
            _loc1_ = "https://www.aq.com/order-now/direct/default.asp?cid=" + this.world.myAvatar.objData.CharID + "&token=" + loginInfo.strToken;
            navigateToURL(new URLRequest(_loc1_),"_blank");
         }
      }

      public function showACWindow() : void
      {
         var _loc1_:MovieClip = null;
         if(mcACWindow == null)
         {
            mcACWindow = new MCACWindow();
         }
         _loc1_ = mcACWindow as MovieClip;
         _loc1_.btnClose.addEventListener(MouseEvent.CLICK,this.hideACWindow,false,0,true);
         _loc1_.btnClose2.addEventListener(MouseEvent.CLICK,this.hideACWindow,false,0,true);
         _loc1_.btnBuy.addEventListener(MouseEvent.CLICK,this.onUpgradeClick,false,0,true);
         _loc1_.btnUpgrade.addEventListener(MouseEvent.CLICK,this.onUpgradeClick,false,0,true);
         addChild(mcACWindow);
         try
         {
            this.ui.mouseChildren = false;
            this.world.mouseChildren = false;
         }
         catch(e:Error)
         {
         }
         try
         {
            this.mcLogin.sl.mouseChildren = false;
         }
         catch(e:Error)
         {
         }
      }

      public function hideACWindow(param1:MouseEvent) : void
      {
         removeChild(mcACWindow);
         try
         {
            this.ui.mouseChildren = true;
            this.world.mouseChildren = true;
         }
         catch(e:Error)
         {
         }
         try
         {
            this.mcLogin.sl.mouseChildren = true;
         }
         catch(e:Error)
         {
         }
      }

      public function initArrHP() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Number = NaN;
         var _loc11_:* = undefined;
         _loc1_ = 100;
         _loc2_ = 550;
         _loc3_ = 275;
         _loc4_ = 0.8;
         _loc5_ = 720;
         _loc6_ = 200;
         _loc7_ = 0.92;
         _loc8_ = 350;
         _loc9_ = 3650;
         _loc10_ = 1.1;
         _loc11_ = 0;
         while(_loc11_ < _loc1_)
         {
            if(_loc11_ > 19)
            {
               this.arrHP.push(Math.round(_loc8_ + Math.pow(_loc11_ / _loc1_,_loc10_) * _loc9_));
            }
            else if(_loc11_ > 7)
            {
               this.arrHP.push(Math.round(_loc5_ + Math.pow(_loc11_ / 20,_loc7_) * _loc6_));
            }
            else
            {
               this.arrHP.push(Math.round(_loc2_ + Math.pow(_loc11_ / 8,_loc4_) * _loc3_));
            }
            _loc11_++;
         }
      }

      public function initArrRep() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = undefined;
         _loc1_ = 0;
         _loc2_ = 1;
         while(_loc2_ < 10)
         {
            _loc1_ = Math.pow(_loc2_ + 1,3) * 100;
            if(_loc2_ > 1)
            {
               this.arrRanks.push(_loc1_ + this.arrRanks[_loc2_ - 1]);
            }
            else
            {
               this.arrRanks.push(_loc1_ + 100);
            }
            _loc2_++;
         }
      }

      public function getRankFromPoints(param1:int) : int
      {
         var _loc1_:* = 0;
         var _loc2_:* = undefined;
         _loc1_ = 1;
         if(param1 < 0)
         {
            param1 = 0;
         }
         _loc2_ = 1;
         while(_loc2_ < this.arrRanks.length)
         {
            if(param1 < this.arrRanks[_loc2_])
            {
               return _loc1_;
            }
            _loc1_++;
            _loc2_++;
         }
         return _loc1_;
      }

      public function attachOnModalStack(param1:String) : MovieClip
      {
         var _loc1_:MovieClip = null;
         var _loc2_:Class = null;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         _loc2_ = this.world.getClass(param1) as Class;
         _loc3_ = true;
         if(this.ui.ModalStack.numChildren)
         {
            _loc1_ = MovieClip(this.ui.ModalStack.getChildAt(0));
            _loc4_ = _loc1_.constructor as Class;
            if(_loc4_ == _loc2_)
            {
               _loc3_ = false;
            }
         }
         if(_loc3_)
         {
            this.clearModalStack();
            _loc1_ = MovieClip(this.ui.ModalStack.addChild(new _loc2_()));
            this.ui.ModalStack.mouseChildren = true;
         }
         return _loc1_;
      }

      public function getInstanceFromModalStack(param1:String) : MovieClip
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.ui.ModalStack.numChildren)
         {
            if(getQualifiedClassName(this.ui.ModalStack.getChildAt(_loc1_) == param1))
            {
               return this.ui.ModalStack.getChildAt(_loc1_);
            }
            _loc1_++;
         }
         return null;
      }

      public function isDialoqueUp() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         _loc1_ = 0;
         while(_loc1_ < this.world.FG.numChildren)
         {
            _loc2_ = this.world.FG.getChildAt(_loc1_);
            _loc3_ = String(_loc2_ as MovieClip);
            if(_loc3_.indexOf("dlg_") > -1)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }

      public function clearModalStack() : Boolean
      {
         var _loc1_:* = 0;
         if(this.isGreedyModalInStack())
         {
            return false;
         }
         _loc1_ = 0;
         while(this.ui.ModalStack.numChildren > 0 && _loc1_ < 100)
         {
            _loc1_++;
            this.ui.ModalStack.removeChildAt(0);
         }
         stage.focus = null;
         return true;
      }

      public function closeModalByStrBody(param1:String) : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         _loc1_ = 0;
         _loc1_ = 0;
         while(_loc1_ < this.ui.ModalStack.numChildren)
         {
            _loc2_ = this.ui.ModalStack.getChildAt(_loc1_) as MovieClip;
            if(_loc2_.cnt.strBody.htmlText.indexOf(param1) > -1 && _loc2_.currentLabel != "out")
            {
               _loc2_.fClose();
            }
            _loc1_++;
         }
      }

      public function isGreedyModalInStack() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         _loc1_ = 0;
         _loc1_ = 0;
         while(_loc1_ < this.ui.ModalStack.numChildren)
         {
            _loc2_ = this.ui.ModalStack.getChildAt(_loc1_) as MovieClip;
            if("greedy" in _loc2_ && _loc2_.greedy != null && _loc2_.greedy == true)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }

      public function clearPopups(param1:Array = null) : void
      {
         if(this.ui.mcPopup.currentLabel == "House")
         {
            this.ui.mcPopup.mcHouseMenu.hideItemHandle();
         }
         if(param1 == null || param1.indexOf(this.ui.mcPopup.currentLabel) < 0)
         {
            this.ui.mcPopup.onClose();
         }
         this.world.removeMovieFront();
         this.clearModalStack();
      }

      public function clearPopupsQ() : void
      {
         if(this.ui.mcPopup.currentLabel != "House" && !(this.ui.mcPopup.currentLabel == "Shop" && this.world.shopinfo != null && this.world.shopinfo.bHouse == 1))
         {
            this.ui.mcPopup.onClose();
         }
      }

      public function addUpdate(param1:String, param2:Boolean = false) : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:MovieClip = null;
         var _loc3_:* = 0;
         _loc1_ = this.ui.mcUpdates;
         _loc2_ = _loc1_.addChildAt(new uProto(),1) as MovieClip;
         _loc2_.y = 0;
         _loc2_.x = _loc1_.uproto.x;
         _loc2_.t1.ti.text = param1;
         if(param2)
         {
            _loc2_.t1.ti.textColor = 16711680;
         }
         _loc2_.gotoAndPlay("in");
         _loc3_ = 2;
         if(_loc1_.numChildren > 2)
         {
            _loc3_ = 2;
            while(_loc3_ < _loc1_.numChildren)
            {
               if(_loc3_ < 4)
               {
                  _loc1_.getChildAt(_loc3_).y = _loc1_.getChildAt(_loc3_).y - 18;
               }
               else
               {
                  MovieClip(_loc1_.getChildAt(_loc3_)).stop();
                  _loc1_.removeChildAt(_loc3_);
                  _loc3_--;
               }
               _loc3_++;
            }
         }
      }

      public function clearUpdates() : void
      {
         var _loc1_:MovieClip = null;
         _loc1_ = this.ui.mcUpdates;
         while(_loc1_.numChildren > 1)
         {
            _loc1_.removeChildAt(1);
         }
      }

      public function showItemDrop(param1:*, param2:*) : void
      {
         var _loc1_:* = undefined;
         var _loc2_:DFrame2MC = null;
         if(Boolean(this.litePreference.data.bCustomDrops) && (Boolean(param1.bTemp == 0) && Boolean(param2)))
         {
            this.cDropsUI.showItem(param1);
            return;
         }
         if(Boolean(this.litePreference.data.dOptions["hideDrop"]) && Boolean(this.litePreference.data.bCustomDrops) && param1.bTemp == 0)
         {
            return;
         }
         if(Boolean(this.litePreference.data.dOptions["hideTemp"]) && Boolean(this.litePreference.data.bCustomDrops) && param1.bTemp != 0)
         {
            return;
         }
         if(Boolean(this.litePreference.data.bCustomDrops) && (param1.bTemp == 0 && !param2))
         {
            _loc1_ = new DFrameMC(param1);
            this.ui.dropStack.addChild(_loc1_);
            _loc1_.init();
            _loc1_.fY = _loc1_.y = -(_loc1_.fHeight + 8);
            _loc1_.fX = _loc1_.x = -(_loc1_.fWidth / 2);
            this.cleanDropStack();
            return;
         }
         if(param1.bTemp != 0 || !param2)
         {
            _loc1_ = new DFrameMC(param1);
         }
         else
         {
            _loc2_ = this.findExistingDropFrame(param1.ItemID);
            if(_loc2_ != null)
            {
               _loc2_.addQuantity(int(param1.iQty));
               this.ui.dropStack.setChildIndex(_loc2_,this.ui.dropStack.numChildren - 1);
               _loc2_.fY = _loc2_.y = -(_loc2_.fHeight + 8);
               _loc2_.fX = _loc2_.x = -(_loc2_.fWidth / 2);
               this.cleanDropStack();
               return;
            }
            _loc1_ = new DFrame2MC(param1);
         }
         this.ui.dropStack.addChild(_loc1_);
         _loc1_.init();
         _loc1_.fY = _loc1_.y = -(_loc1_.fHeight + 8);
         _loc1_.fX = _loc1_.x = -(_loc1_.fWidth / 2);
         this.cleanDropStack();
      }

      private function findExistingDropFrame(param1:*) : DFrame2MC
      {
         var _loc1_:* = undefined;
         var _loc2_:* = 0;
         var _loc3_:* = undefined;
         _loc1_ = this.ui.dropStack;
         _loc2_ = int(_loc1_.numChildren - 1);
         while(_loc2_ >= 0)
         {
            _loc3_ = _loc1_.getChildAt(_loc2_);
            if(_loc3_ is DFrame2MC && !_loc3_.isClosing && _loc3_.fData != null && _loc3_.fData.ItemID == param1)
            {
               return _loc3_ as DFrame2MC;
            }
            _loc2_--;
         }
         return null;
      }

      public function cleanDropStack() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:MovieClip = null;
         var _loc3_:* = undefined;
         _loc1_ = null;
         _loc2_ = null;
         _loc3_ = this.ui.dropStack.numChildren - 2;
         while(_loc3_ > -1)
         {
            _loc1_ = this.ui.dropStack.getChildAt(_loc3_) as MovieClip;
            _loc2_ = this.ui.dropStack.getChildAt(_loc3_ + 1) as MovieClip;
            _loc1_.fY = _loc1_.y = _loc2_.fY - (_loc2_.fHeight + 8);
            _loc3_--;
         }
      }

      public function dropStackBoost() : void
      {
         this.ui.dropStack.y = 438;
      }

      public function dropStackReset() : void
      {
         this.ui.dropStack.y = 493;
      }

      public function showAchievement(param1:String, param2:int) : void
      {
         var _loc1_:mcAchievement = null;
         var _loc2_:MovieClip = null;
         _loc1_ = new mcAchievement();
         _loc2_ = this.ui.dropStack.addChild(_loc1_) as MovieClip;
         _loc2_.cnt.tBody.text = param1;
         _loc2_.cnt.tPts.text = param2;
         _loc2_.fWidth = 348;
         _loc2_.fHeight = 90;
         _loc2_.fX = _loc2_.x = -(_loc2_.fWidth / 2);
         _loc2_.fY = _loc2_.y = -(_loc2_.fHeight + 8);
         this.cleanDropStack();
      }

      public function showQuestpopup(param1:Object) : void
      {
         var _loc1_:mcQuestpopup = null;
         var _loc2_:MovieClip = null;
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         if(this.litePreference.data.bDisQPopup)
         {
            return;
         }
         _loc1_ = new mcQuestpopup();
         _loc1_.cnt.mcAC.visible = false;
         _loc2_ = this.ui.dropStack.addChild(_loc1_) as MovieClip;
         _loc2_.cnt.tName.text = param1.sName;
         _loc2_.cnt.rewards.tRewards.htmlText = "";
         _loc3_ = "";
         _loc4_ = param1.rewardObj;
         if("intCoins" in _loc4_ && _loc4_.intCoins > 0)
         {
            _loc3_ = "<font color=\'#FFFFFF\'>" + _loc4_.intCoins + "</font>";
            _loc3_ = _loc3_ + "<font color=\'#FFCC00\'>ac</font>";
         }
         if("intGold" in _loc4_ && _loc4_.intGold > 0)
         {
            if(_loc3_.length > 0)
            {
               _loc3_ = _loc3_ + "<font color=\'#FFFFFF\'>, </font>";
            }
            _loc3_ = _loc3_ + ("<font color=\'#FFFFFF\'>" + _loc4_.intGold + "</font>");
            _loc3_ = _loc3_ + "<font color=\'#FFCC00\'>g</font>";
         }
         if("intExp" in _loc4_ && _loc4_.intExp > 0)
         {
            if(_loc3_.length > 0)
            {
               _loc3_ = _loc3_ + "<font color=\'#FFFFFF\'>, </font>";
            }
            _loc3_ = _loc3_ + ("<font color=\'#FFFFFF\'>" + _loc4_.intExp + "</font>");
            _loc3_ = _loc3_ + "<font color=\'#FF00FF\'>xp</font>";
         }
         if("iRep" in _loc4_ && _loc4_.iRep > 0)
         {
            if(_loc3_.length > 0)
            {
               _loc3_ = _loc3_ + "<font color=\'#FFFFFF\'>, </font>";
            }
            _loc3_ = _loc3_ + ("<font color=\'#FFFFFF\'>" + _loc4_.iRep + "</font>");
            _loc3_ = _loc3_ + "<font color=\'#00CCFF\'>rep</font>";
         }
         if("guildRep" in _loc4_ && _loc4_.guildRep > 0)
         {
            if(_loc3_.length > 0)
            {
               _loc3_ = _loc3_ + "<font color=\'#FFFFFF\'>, </font>";
            }
            _loc3_ = _loc3_ + ("<font color=\'#FFFFFF\'>" + _loc4_.guildRep + "</font>");
            _loc3_ = _loc3_ + "<font color=\'#00CCFF\'>guild rep</font>";
         }
         _loc2_.cnt.rewards.tRewards.htmlText = _loc3_;
         _loc2_.fWidth = 240;
         _loc2_.fHeight = 70;
         _loc5_ = _loc2_.cnt.rewards.tRewards.x + _loc2_.cnt.rewards.tRewards.textWidth;
         _loc2_.cnt.rewards.x = Math.round(_loc2_.fWidth / 2 - _loc5_ / 2);
         _loc2_.fX = _loc2_.x = -(_loc2_.fWidth / 2);
         _loc2_.fY = _loc2_.y = -(_loc2_.fHeight + 8);
         this.mixer.playSound("Good");
         this.cleanDropStack();
      }

      public function toggleCharpanel(param1:String = "") : void
      {
         var _loc1_:MovieClip = null;
         _loc1_ = this.ui.mcPopup;
         if(!this.isGreedyModalInStack())
         {
            if(_loc1_.currentLabel != "Charpanel")
            {
               this.clearPopups();
               this.clearPopupsQ();
               _loc1_.fData = {"typ":param1};
               _loc1_.visible = true;
               _loc1_.gotoAndPlay("Charpanel");
            }
            else
            {
               _loc1_.mcCharpanel.fClose();
            }
         }
      }

      public function toggleStatspanel(param1:String = "") : void
      {
         if(this.ui.getChildByName("mcStatsPanel"))
         {
            this.mcStatsPanel.cleanup();
            this.mcStatsPanel = null;
            return;
         }
         this.mcStatsPanel = new statsPanel(this);
         this.ui.addChild(this.mcStatsPanel);
         this.mcStatsPanel.name = "mcStatsPanel";
         this.mcStatsPanel.x = 474;
         this.mcStatsPanel.y = 240;
      }

      public function toggleOutfits(param1:String = "") : void
      {
         if(this.world.myAvatar.dataLeaf.intState != 1)
         {
            return;
         }
         if(this.world.bPvP)
         {
            return;
         }
         this.requestInterface("OutfitSets/outfitsetsr2.swf","outfitSets");
      }

      public function showFriendshipUI(param1:String = "") : void
      {
         if(!this.world.coolDown("friendshipStats"))
         {
            return;
         }
         this.requestInterface("friendship/friendship_ui.swf","friendship_ui");
      }

      public function togglePVPPanel(param1:String = "") : void
      {
         var mc:MovieClip = null;
         var typ:String = param1;
         mc = this.ui.mcPopup;
         if(!this.isGreedyModalInStack())
         {
            if(mc.currentLabel != "PVPPanel")
            {
               this.clearPopups();
               this.clearPopupsQ();
               mc.fData = {"typ":typ};
               mc.visible = true;
               mc.gotoAndPlay("PVPPanel");
            }
            else if(typ == "results" && mc.mcPVPPanel != null)
            {
               try
               {
                  mc.fData = {"typ":typ};
                  mc.visible = true;
                  mc.mcPVPPanel.openWith({"typ":typ});
               }
               catch(ePv:Error)
               {
                  mc.onClose();
               }
            }
            else
            {
               mc.onClose();
            }
         }
      }

      public function showPVPScore() : void
      {
         var bar:MovieClip = null;
         var i:int = 0;
         var o:Object = null;
         var a:Array = null;
         var bx:int = 0;
         this.ui.mcPVPScore.visible = true;
         this.ui.mcPVPScore.y = 2;
         i = 0;
         a = [{"sName":"Team A"},{"sName":"Team B"}];
         bx = 200;
         if(this.world.PVPFactions.length > 0)
         {
            a = this.world.PVPFactions;
         }
         i = 0;
         while(i < a.length)
         {
            o = a[i];
            try
            {
               bar = this.ui.mcPVPScore.getChildByName("bar" + i);
               bar.tTeam.text = o.sName;
               if(bar.tTeam.x + bar.tTeam.width - bar.tTeam.textWidth - 6 < bx)
               {
                  bx = Math.round(bar.tTeam.x + bar.tTeam.width - bar.tTeam.textWidth - 6);
               }
            }
            catch(e:Error)
            {
               trace("[UI] ERR PvP faction data could not be found or set: " + e.message);
            }
            i++;
         }
         i = 0;
         while(i < a.length)
         {
            o = a[i];
            try
            {
               bar = this.ui.mcPVPScore.getChildByName("bar" + i);
               bar.cap.x = bx;
            }
            catch(e:Error)
            {
            }
            i++;
         }
      }

      public function hidePVPScore() : void
      {
         this.ui.mcPVPScore.visible = false;
         this.ui.mcPVPScore.y = -300;
      }

      public function showMCPVPQueue() : void
      {
         var _loc1_:Object = null;
         _loc1_ = this.world.getWarzoneByWarzoneName(this.world.PVPQueue.warzone);
         this.ui.mcPVPQueue.t1.text = _loc1_.nam;
         this.ui.mcPVPQueue.removeEventListener(Event.ENTER_FRAME,this.MCPVPQueueEF);
         this.ui.mcPVPQueue.t2label.visible = false;
         this.ui.mcPVPQueue.t2.visible = false;
         if(this.world.PVPQueue.avgWait > -1)
         {
            this.ui.mcPVPQueue.t2label.visible = true;
            this.ui.mcPVPQueue.t2.visible = true;
            this.ui.mcPVPQueue.addEventListener(Event.ENTER_FRAME,this.MCPVPQueueEF,false,0,true);
         }
         this.ui.mcPVPQueue.visible = true;
         this.ui.mcPVPQueue.y = 84;
      }

      public function hideMCPVPQueue() : void
      {
         this.ui.mcPVPQueue.removeEventListener(Event.ENTER_FRAME,this.MCPVPQueueEF);
         this.ui.mcPVPQueue.visible = false;
         this.ui.mcPVPQueue.y = -300;
      }

      public function onMCPVPQueueClick(param1:MouseEvent) : void
      {
         var _loc1_:* = undefined;
         _loc1_ = {};
         try
         {
            _loc1_.strUsername = this.world.myAvatar.objData.strUsername;
            this.ui.cMenu.fOpenWith("pvpqueue",_loc1_);
         }
         catch(e:Error)
         {
         }
      }

      public function MCPVPQueueEF(param1:Event) : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:* = undefined;
         _loc1_ = new Date().getTime();
         _loc2_ = Math.ceil((this.world.PVPQueue.avgWait * 1000 - (_loc1_ - this.world.PVPQueue.ts)) / 1000 / 60);
         if(_loc2_ == this.pvpQueueMins)
         {
            return;
         }
         this.pvpQueueMins = _loc2_;
         this.ui.mcPVPQueue.t2.htmlText = (_loc2_ <= 1 ? "<" : "") + "<font color=\"#FFFFFF\">" + _loc2_ + "</font><font color=\"#999999\">m</font>";
      }

      public function updatePVPScore(param1:Array) : void
      {
         var _loc1_:Object = null;
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc1_ = {};
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc1_ = param1[_loc3_];
            _loc2_ = this.ui.mcPVPScore.getChildByName("bar" + _loc3_) as MovieClip;
            if(_loc2_ != null)
            {
               _loc2_.ti.text = _loc1_.v + "/1000";
               _loc4_ = int(_loc1_.v / 1000 * _loc2_.bar.width);
               _loc4_ = Math.max(Math.min(_loc4_,_loc2_.bar.width),0);
               _loc2_.bar.x = -_loc2_.bar.width + _loc4_;
            }
            _loc3_++;
         }
      }

      public function relayPVPEvent(param1:Object) : void
      {
         if(param1.typ == "kill")
         {
            if(param1.team == this.world.myAvatar.dataLeaf.pvpTeam)
            {
               if(param1.val == "Restorer")
               {
                  this.addUpdate(this.getPVPMessage(param1.val,true));
               }
               if(param1.val == "Brawler")
               {
                  this.addUpdate(this.getPVPMessage(param1.val,true));
               }
               if(param1.val == "Captain")
               {
                  this.addUpdate(this.getPVPMessage(param1.val,true));
               }
               if(param1.val == "General")
               {
                  this.addUpdate("Victory! The enemy general has been defeated!");
               }
               if(param1.val == "Knight")
               {
                  this.addUpdate("A knight of the enemy has fallen! Victory draws closer!");
               }
            }
            else
            {
               if(param1.val == "Restorer")
               {
                  this.addUpdate(this.getPVPMessage(param1.val,false),true);
               }
               if(param1.val == "Brawler")
               {
                  this.addUpdate(this.getPVPMessage(param1.val,false),true);
               }
               if(param1.val == "Captain")
               {
                  this.addUpdate(this.getPVPMessage(param1.val,false),true);
               }
               if(param1.val == "General")
               {
                  this.addUpdate("Oh no!  Our general has been defeated!",true);
               }
               if(param1.val == "Knight")
               {
                  this.addUpdate("A knight has fallen to the enemy!");
               }
            }
         }
      }

      private function getPVPMessage(param1:String, param2:Boolean) : String
      {
         switch(param1)
         {
            case "Restorer":
               if(param2)
               {
                  return this.world.strMapName == "dagepvp" ? "An enemy Blade Master has been defeated! Dage\'s healing powers are waning!" : "An enemy Restorer has been defeated! The Captain\'s healing powers are waning!";
               }
               return this.world.strMapName == "dagepvp" ? "A Blade Master has been defeated!\t Dage\'s healing powers are waning!" : "A Restorer has been defeated!\t Our Captain\'s healing powers are waning!";
               break;
            case "Brawler":
               if(param2)
               {
                  return this.world.strMapName == "dagepvp" ? "An enemy Legion Guard has been defeated!  Dage\'s attacks grow weaker!" : "An enemy Brawler has been defeated!  The Captain\'s attacks grow weaker!";
               }
               return this.world.strMapName == "dagepvp" ? "A Legion Guard has been defeated!\tRally to Dage\'s defense!" : "A Brawler has been defeated!\tRally to the Captain\'s defense!";
               break;
            case "Captain":
               if(param2)
               {
                  return this.world.strMapName == "dagepvp" ? "Dage has been defeated!" : "The enemy captain has been defeated!";
               }
               return this.world.strMapName == "dagepvp" ? "Dage has been fallen to the enemy!" : "Our Captain has been fallen to the enemy!";
               break;
            default:
               return "";
         }
      }

      public function mcSetColor(param1:MovieClip, param2:String, param3:String) : *
      {
         var _loc1_:MovieClip = null;
         var _loc2_:String = null;
         var _loc3_:Object = null;
         var _loc4_:MovieClip = null;
         var _loc5_:* = undefined;
         var _loc6_:Dictionary = null;
         if(currentLabel == "Select")
         {
            this.mcCharSelect.mcSetColor(param1,param2,param3);
            return;
         }
         if(this._colorCache[param1] != null)
         {
            _loc3_ = this._colorCache[param1];
            _loc4_ = null;
            for(var _loc7_ in _loc3_.avatar)
            {
               _loc5_ = _loc7_;
               _loc7_;
               _loc4_ = _loc5_ as MovieClip;
            }
            if(_loc4_ != null && _loc4_.pAV != undefined && param1.parent != null)
            {
               _loc4_.pAV.pMC.setColor(param1,_loc3_.typ,param2,param3);
               return;
            }
            delete this._colorCache[param1];
         }
         _loc1_ = param1;
         _loc2_ = "none";
         while(_loc1_ != null && _loc1_.parent != null && _loc1_.parent != _loc1_.stage)
         {
            if("pAV" in _loc1_)
            {
               if(_loc1_.name.indexOf("previewMC") > -1)
               {
                  _loc2_ = "e";
               }
               else if(_loc1_.name.indexOf("Dummy") > -1)
               {
                  _loc2_ = "d";
               }
               else if(_loc1_.name.indexOf("mcPortraitTarget") > -1)
               {
                  _loc2_ = "c";
               }
               else if(_loc1_.name.indexOf("mcPortrait") > -1)
               {
                  _loc2_ = "b";
               }
               else
               {
                  _loc2_ = "a";
               }
               break;
            }
            _loc1_ = MovieClip(_loc1_.parent);
         }
         if(_loc2_ != "none")
         {
            _loc6_ = new Dictionary(true);
            _loc6_[_loc1_] = true;
            this._colorCache[param1] = {
               "avatar":_loc6_,
               "typ":_loc2_
            };
            if(_loc1_.pAV == undefined)
            {
               this.world.myAvatar.pMC.setColor(param1,_loc2_,param2,param3);
            }
            else
            {
               _loc1_.pAV.pMC.setColor(param1,_loc2_,param2,param3);
            }
         }
      }

      public function registerAttackFrame(param1:MovieClip) : *
      {
         var _loc1_:MovieClip = null;
         _loc1_ = param1;
         while(_loc1_ != null && _loc1_.parent != null && _loc1_.parent != _loc1_.stage)
         {
            if("pAV" in _loc1_)
            {
               break;
            }
            _loc1_ = MovieClip(_loc1_.parent);
         }
         if("pAV" in _loc1_)
         {
            if(!("attackFrames" in _loc1_.pAV.pMC))
            {
               return;
            }
            if(Boolean(_loc1_.pAV.pMC.attackFrames) && _loc1_.pAV.pMC.attackFrames.indexOf(param1) != -1)
            {
               _loc1_.pAV.pMC.attackFrames.splice(_loc1_.pAV.pMC.attackFrames.indexOf(param1),1);
            }
            _loc1_.pAV.pMC.attackFrames.push(param1);
         }
      }

      public function areaListClick(param1:MouseEvent) : void
      {
         var _loc1_:* = undefined;
         _loc1_ = MovieClip(param1.currentTarget.parent.parent);
         switch(_loc1_.currentLabel)
         {
            case "init":
               _loc1_.gotoAndPlay("in");
               break;
            case "hold":
               _loc1_.gotoAndPlay("out");
         }
      }

      public function updateAreaName() : void
      {
         var _loc1_:String = null;
         if(this.ui == null || this.ui.mcInterface == null || this.ui.mcInterface.areaList == null || this.ui.mcInterface.areaList.title == null || this.world == null)
         {
            return;
         }
         _loc1_ = String(this.world.areaUsers.length) + " player";
         if(this.world.areaUsers.length > 1)
         {
            _loc1_ = _loc1_ + "(s)";
         }
         _loc1_ = _loc1_ + " in <font color =\'#FFFF00\'>";
         if(this.world.strAreaName.indexOf(":") > -1)
         {
            _loc1_ = _loc1_ + (this.world.strAreaName.split(":")[0] + " (party)");
         }
         else
         {
            _loc1_ = _loc1_ + this.world.strAreaName;
         }
         _loc1_ = _loc1_ + "</font>";
         this.ui.mcInterface.areaList.title.t1.htmlText = _loc1_;
      }

      public function areaListGet() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc4_:* = undefined;
         _loc1_ = {};
         _loc2_ = this.sfc.getRoom(this.world.curRoom).getUserList();
         for(var _loc5_ in _loc2_)
         {
            _loc3_ = _loc5_;
            _loc5_;
            _loc4_ = this.world.uoTree[_loc2_[_loc3_].getName()];
            if(_loc4_ != null)
            {
               _loc1_[_loc3_] = {
                  "strUsername":_loc4_.strUsername,
                  "intLevel":_loc4_.intLevel
               };
            }
         }
         this.areaListShow(_loc1_);
      }

      public function areaListNameClick(param1:MouseEvent) : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         _loc1_ = MovieClip(param1.currentTarget);
         _loc2_ = {};
         _loc2_.ID = _loc1_.objData.ID;
         _loc2_.strUsername = _loc1_.objData.strUsername;
         if(_loc1_.objData.strUsername == this.world.myAvatar.objData.strUsername)
         {
            this.ui.cMenu.fOpenWith("self",_loc2_);
         }
         else
         {
            this.ui.cMenu.fOpenWith("user",_loc2_);
         }
      }

      public function areaListShow(param1:Object) : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:* = 0;
         var _loc3_:String = null;
         var _loc4_:* = undefined;
         _loc1_ = this.ui.mcInterface.areaList;
         if(_loc1_.currentLabel == "hold")
         {
            while(_loc1_.cnt.numChildren > 0)
            {
               _loc1_.cnt.removeChildAt(0);
            }
         }
         _loc2_ = 0;
         for(var _loc5_ in param1)
         {
            _loc3_ = _loc5_;
            _loc5_;
            _loc4_ = _loc1_.cnt.addChild(new aProto());
            _loc4_.objData = param1[_loc3_];
            _loc4_.txtName.text = param1[_loc3_].strUsername;
            _loc4_.txtLevel.text = param1[_loc3_].intLevel;
            _loc4_.addEventListener(MouseEvent.CLICK,this.areaListNameClick,false,0,true);
            _loc4_.buttonMode = true;
            _loc4_.y = -int(_loc2_ * 14);
            _loc2_++;
         }
         _loc1_.cnt.iproto.visible = _loc1_.currentLabel == "hold";
         _loc1_.visible = true;
      }

      public function showFBShare(param1:Object) : void
      {
         var FBShareTabClass:Class;
         var fbTab:FacebookTabMC = null;
         var o:Object = param1;
         var mc:MovieClip = MovieClip(o.parent);
         if(!ApplicationDomain.currentDomain.hasDefinition("FacebookTabMC"))
         {
            trace("[Load] ERR missing linkage FacebookTabMC showFBShare");
            return;
         }
         FBShareTabClass = getDefinitionByName("FacebookTabMC") as Class;
         if(Boolean(this.uoPref.bFBShare) && Boolean(o.isActive))
         {
            try
            {
               fbTab = o.parent.getChildByName("fbTab") as FacebookTabMC;
            }
            catch(error:Error)
            {
               trace("[UI] ERR showFBShare: " + error.message);
            }
            if(fbTab == null)
            {
               fbTab = new FBShareTabClass();
               fbTab.name = "fbTab";
               fbTab.filters = [new GlowFilter(12892822,1,10,10,2,2,false,false)];
               o.parent.addChild(fbTab);
            }
            fbTab.init(o);
            fbTab.visible = true;
            if("position" in o)
            {
               fbTab.positionBy(o);
            }
         }
         else
         {
            try
            {
               o.parent.getChildByName("fbTab").visible = false;
            }
            catch(error:Error)
            {
            }
         }
      }

      public function closeFBC() : void
      {
         if(this.fbc != null)
         {
            this.fbc.fClose();
         }
      }

      public function getAppName() : String
      {
         return Game.FB_APP_NAME;
      }

      public function getAppID() : String
      {
         return Game.FB_APP_ID;
      }

      public function getAppSec() : String
      {
         return Game.FB_APP_SEC;
      }

      public function getAppURL() : String
      {
         return Game.FB_APP_URL;
      }

      public function getUserName() : String
      {
         if(this.world != null && this.world.myAvatar != null && this.world.myAvatar.objData != null && "strUserName" in this.world.myAvatar.objData)
         {
            return this.world.myAvatar.objData.strUserName;
         }
         return "";
      }

      public function toggleFaction() : void
      {
         if(this.ui.mcPopup.currentLabel != "Faction")
         {
            this.ui.mcPopup.fOpen("Faction");
         }
         else if("cnt" in MovieClip(this.ui.mcPopup))
         {
            MovieClip(MovieClip(this.ui.mcPopup).cnt).xClick();
         }
      }

      public function hideInterface() : void
      {
         this.ui.visible = false;
      }

      public function showInterface() : void
      {
         this.ui.visible = true;
      }

      public function loadExternalSWF(param1:String) : void
      {
         if(param1.indexOf("https://") == -1 && param1.indexOf("http://") == -1 && param1.indexOf("file://") == -1)
         {
            while(param1.length > 1 && param1.charAt(0) == "/")
            {
               param1 = param1.substr(1,param1.length - 1);
            }
            if(param1.indexOf("maps/") != 0)
            {
               param1 = "maps/" + param1;
            }
         }
         trace("[Load] loadExternalSWF: " + param1 + " base: " + serverFilePath);
         this.ldrMC.loadFile(this.mcExtSWF,param1,"Game Files",true);
         this.hideInterface();
         this.world.visible = false;
      }

      public function clearExternamSWF() : void
      {
         var child:DisplayObject = null;
         try
         {
            SoundMixer.stopAll();
         }
         catch(e:Error)
         {
         }
         while(this.mcExtSWF != null && this.mcExtSWF.numChildren > 0)
         {
            child = null;
            try
            {
               child = this.mcExtSWF.removeChildAt(0);
            }
            catch(e2:Error)
            {
               break;
            }
            if(child is MovieClip)
            {
               try
               {
                  this.recursiveStopSafe(MovieClip(child));
               }
               catch(e3:Error)
               {
               }
            }
         }
         if(this.world != null)
         {
            this.world.visible = true;
         }
         this.showInterface();
      }

      public function openCharacterCustomize() : void
      {
         this.ui.mcPopup.fOpen("Customize");
      }

      public function openArmorCustomize() : void
      {
         this.ui.mcPopup.fOpen("ArmorColor");
      }

      public function showFactionInterface() : void
      {
         this.ui.mcPopup.fOpen("Faction");
      }

      public function showConfirmtaionBox(param1:String, param2:Function) : void
      {
         var modal:* = undefined;
         var modalO:* = undefined;
         var sMsg:String = param1;
         var fHandler:Function = param2;
         modal = new ModalMC();
         modalO = {};
         modalO.strBody = sMsg;
         modalO.btns = "dual";
         modalO.params = {};
         modalO.callback = function(param1:Object):*
         {
            fHandler(param1.accept);
         };
         this.ui.ModalStack.addChild(modal);
         modal.init(modalO);
      }

      public function showMessageBox(param1:String, param2:Function = null) : void
      {
         var modal:* = undefined;
         var modalO:* = undefined;
         var sMsg:String = param1;
         var fHandler:Function = param2;
         modal = new ModalMC();
         modalO = {};
         modalO.strBody = sMsg;
         modalO.btns = "mono";
         modalO.params = {};
         modalO.callback = function(param1:Object):*
         {
            if(fHandler != null)
            {
               fHandler();
            }
         };
         this.ui.ModalStack.addChild(modal);
         modal.init(modalO);
      }

      public function getServerTime() : Date
      {
         var _loc1_:Date = null;
         var _loc2_:* = undefined;
         _loc1_ = new Date();
         _loc2_ = this.ts_login_server + (_loc1_.getTime() - this.ts_login_client);
         return new Date(_loc2_);
      }

      public function get date_server() : Date
      {
         return this.getServerTime();
      }

      public function showTracking(param1:String) : void
      {
         var _loc1_:* = undefined;
         try
         {
            _loc1_ = objLogin.userid != null ? objLogin.userid : 0;
            this.extCall.logQuestProgress(_loc1_,param1);
         }
         catch(e:*)
         {
         }
      }

      public function removeApop() : void
      {
         if(this.apop == null)
         {
            return;
         }
         this.apop_ = null;
         this.world.removeMovieFront();
      }

      public function createApop() : void
      {
         if(this.apop_ != null)
         {
            this.removeApop();
         }
         this.apop_ = new apopCore(this as MovieClip,this.apopTree[this.curID]);
         this.apop_.x = 270;
         this.apop_.y = 20;
         this.world.FG.addChild(this.apop_);
         this.world.FG.mouseChildren = true;
      }

      public function rand(param1:Number = 0, param2:Number = 1) : Number
      {
         return this.rn.rand(param1,param2);
      }

      public function get TravelMap() : Object
      {
         return this.travelMapData;
      }

      public function get apop() : apopCore
      {
         return this.apop_;
      }

      public function get objWorldMap() : *
      {
         return this.WorldMapData;
      }

      public function getLogin() : Object
      {
         return objLogin;
      }

      internal function frame1() : *
      {
         stop();
      }

      internal function frame12() : *
      {
         this.init();
         this.showTracking("2");
      }

      internal function frame13() : *
      {
         this.loadTitle();
         if(this.showServers)
         {
            if(FacebookConnect.isLoggedIn && loginInfo.strPassword == null && ISWEB)
            {
               this.extCall.fbLogin();
            }
            else
            {
               this.login(loginInfo.strUsername,loginInfo.strPassword);
            }
            this.showServers = false;
         }
         else if(this.csShowServers)
         {
            this.mcLogin.gotoAndPlay("Servers");
            this.csShowServers = false;
         }
         stop();
      }

      internal function frame23() : *
      {
         trace("at game");
         this.initInterface();
         this.initWorld();
         stop();
      }

      internal function frame33() : *
      {
         if(this.params.vars != null)
         {
            this.loadAccountCreation("newuser/" + this.params.vars.sCharCreate);
         }
         else
         {
            this.loadAccountCreation("newuser/AQW-Landing-MERGETEST.swf");
         }
         stop();
      }

      internal function frame43() : *
      {
         if(this.mcCharSelect != null)
         {
            trace("Cleaning up existing mcCharSelect");
            trace("children count: " + this.numChildren);
            this.mcCharSelect = null;
         }
         this.loader = new mcLoader();
         this.loader.x = 400;
         this.loader.y = 211;
         this.addChild(this.loader);
         this.csLoader = new AirLoader();
         this.csLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onCSComplete,false,0,true);
         this.csLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onCSProgress,false,0,true);
         this.csLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onCSError,false,0,true);
         this.fileUrl = this.getFilePath() + "interface/CharSelect/charselect.swf";
         if(this.params != null && this.params.vars != null && this.params.vars.sVersion != null)
         {
            this.fileUrl = this.fileUrl + ("?v=" + this.params.vars.sVersion);
         }
         this.csLoader.load(new URLRequest(this.fileUrl));
         this.csbLoaded = 0;
         this.csbTotal = 0;
         stop();
      }
   }
}
