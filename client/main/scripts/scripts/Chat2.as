package
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.net.*;
   import flash.text.*;
   import flash.utils.*;
   import liteAssets.handlers.*;
   import liteAssets.mobile.*;

   public class Chat2 extends ChatBase
   {

      private static const CHAT_SHADOW:DropShadowFilter = new DropShadowFilter(0,45,0,1,3,3,5,1,false,false,false);

      private var _regexCache:Object = {};

      public var r:MovieClip;

      private var mci:MovieClip;

      private var messages:Array;

      internal var mask:Shape;

      internal var mcInvis:MovieClip;

      public var bHovering:Boolean;

      public var bMinimal:Boolean;

      internal var mcCannedChat:MovieClip;

      internal var mcHistory:MovieClip;

      internal var cmdHistory:Array = [];

      private var iChatMode:int = 0;

      public var bTall:Boolean;

      internal var upConst:Number = 51;

      internal var heightConst:Number = 83.45;

      private var touch:TouchScroll;

      public var regExpMultiG:RegExp = /(gg{2,})/gi;

      internal var regexEscapes:String = "[]{}()*+?|^$.\\";

      internal var lineLimit:Number = 100;

      internal var wasBottom:Boolean = false;

      public var fadeTimer:Timer;

      public var fadeQueue:Array;

      private var filterCode:int = 0;

      internal var xmlCannedOptions:XML = <CannedChat>
	<l1 display="Emotes">
		<l2 id="emote" display="Dance" text="dance"/>
		<l2 id="emote" display="Dance2" text="dance2"/>
		<l2 id="emote" display="Laugh" text="laugh"/>
		<l2 id="emote" display="Cry" text="cry"/>
		<l2 id="emote" display="Cheer" text="cheer"/>
		<l2 id="emote" display="Point" text="point"/>
		<l2 id="emote" display="Use" text="use"/>
		<l2 id="emote" display="Feign" text="feign"/>
		<l2 id="emote" display="Sleep" text="sleep"/>
		<l2 id="emote" display="Jump" text="jump"/>
		<l2 id="emote" display="Punt" text="punt"/>
		<l2 id="emote" display="Wave" text="wave"/>
		<l2 id="emote" display="Bow" text="bow"/>
		<l2 id="emote" display="Salute" text="Salute"/>
		<l2 id="emote" display="Backflip" text="backflip"/>
		<l2 id="emote" display="Swordplay" text="swordplay"/>
		<l2 id="emote" display="Unsheath" text="unsheath"/>
		<l2 id="emote" display="Facepalm" text="facepalm"/>
		<l2 id="emote" display="Air Guitar" text="airguitar"/>
		<l2 id="emote" display="Stern" text="stern"/>
	</l1>
	<l1 display="Member Emotes">
		<l2 id="emote" display="Powerup" text="powerup"/>
		<l2 id="emote" display="Kneel" text="kneel"/>
		<l2 id="emote" display="Jumpcheer" text="jumpcheer"/>
		<l2 id="emote" display="Salute2" text="salute2"/>
		<l2 id="emote" display="Cry2" text="cry2"/>
		<l2 id="emote" display="Spar" text="spar"/>
		<l2 id="emote" display="Stepdance" text="stepdance"/>
		<l2 id="emote" display="Headbang" text="headbang"/>
		<l2 id="emote" display="Dazed" text="dazed"/>
		<l2 id="emote" display="DanceWeapon" text="danceweapon"/>
	</l1>
	<l1 display="Greetings">
		<l2 id="ba" display="Hello!" text="Hello!"/>
		<l2 id="bb" display="Hi!" text="Hi!"/>
		<l2 id="bc" display="Well met!" text="Well met!"/>
		<l2 id="bd" display="Welcome!" text="Welcome!"/>
		<l2 id="be" display="Welcome back!" text="Welcome back!"/>
		<l2 id="bf" display="How are you today?" text="How are you today?"/>
	</l1>
	<l1 display="Farewells">
		<l2 id="ca" display="Bye!" text="Bye!"/>
		<l2 id="cb" display="See you later." text="See you later."/>
		<l2 id="cc" display="AFK" text="I'm going AFK"/>
		<l2 id="cd" display="I have to go now." text="I have to go now."/>
		<l2 id="ce" display="Logging out now" text="Logging out now."/>
		<l2 id="cf" display="brb" text="brb"/>
		<l2 id="cg" display="Farewell" text="Farewell"/>
	</l1>
	<l1 display="Questions">
		<l2 id="da" display="Can I add you">
			<l3 id="ea" display="to my Friends list" text="Can I add you to my Friends list?"/>
			<l3 id="eb" display="to my Party" text="Can I add you to my Party?"/>
		</l2>
		<l2 id="db" display="Do you want to battle together?" text="Do you want to battle together?"/>
	    <l2 id="dc" display="Is that a Member only...">
			<l3 id="fa" display="Helm" text=" Is that a Member only helm?"/>
			<l3 id="fb" display="Cape" text=" Is that a Member only cape?"/>
			<l3 id="fc" display="Armor" text=" Is that a Member only armor?"/>
			<l3 id="fd" display="Weapon" text=" Is that a Member only weapon?"/>
		</l2>
		<l2 id="dd" display="Where are you?" text="Where are you?"/>
		<l2 id="de" display="Are you sure?" text="Are you sure?"/>
		<l2 id="df" display="Can I help you?" text="Can I help you?"/>
		<l2 id="dg" display="What is your alignment?" text="What is your alignment?"/>
		<l2 id="dh" display="Where did you get that ...">
			<l3 id="ga" display="Helm" text="Where did you get that helm?"/>
			<l3 id="gb" display="Cape" text="Where did you get that cape?"/>
			<l3 id="gc" display="Armor" text="Where did you get that armor?"/>
			<l3 id="gd" display="Weapon" text="Where did you get that weapon?"/>
			<l3 id="ge" display="Pet" text="Where did you get that pet?"/>
			<l3 id="ge" display="Class" text="Where did you get that class?"/>
		</l2>
		<l2 id="di" display="Are you a...">
			<l3 id="ha" display="Guardian" text="Are you a Guardian?"/>
			<l3 id="hb" display="DragonLord" text="Are you a DragonLord?"/>
			<l3 id="hc" display="StarCaptain" text="Are you a StarCaptain?"/>
		</l2>
		<l2 id="dj" display="Do you play...">
			<l3 id="ia" display="AdventureQuest" text="Do you play AdventureQuest?"/>
			<l3 id="ib" display="DragonFable" text="Do you play DragonFable?"/>
			<l3 id="ic" display="MechQuest" text="Do you play MechQuest?"/>
		</l2>
		<l2 id="dl" display="What are you doing?" text="What are you doing?"/>
	</l1>
	<l1 display="Answers">
		<l2 id="ja" display="thanks/welcome">
			<l3 id="ka" display="Thanks!" text="Thanks!"/>
			<l3 id="kb" display="Thank you!" text="Thank you!"/>
			<l3 id="kc" display="Thanks for helping me." text="Thanks for helping me."/>
			<l3 id="kd" display="I owe you one." text="I owe you one.."/>
			<l3 id="ke" display="No problem!" text="No problem!"/>
			<l3 id="kf" display="You're welcome!" text="You're welcome!"/>
		</l2>
		<l2 id="jn" display="I am doing/trying to..">
			<l3 id="ma" display="Quest" text="I am doing a quest."/>
			<l3 id="mb" display="Farming" text="I am farming."/>
			<l3 id="mc" display="New" text="I am playing the new release."/>
			<l3 id="md" display="Level up." text="I am trying to level up."/>
			<l3 id="me" display="Rank up." text="I am trying to rank up."/>
		</l2>
		<l2 id="jb" display="I'm fine, thanks." text="I'm fine, thanks."/>
		<l2 id="jc" display="Could be better." text="Could be better."/>
		<l2 id="jd" display="I don't think so." text="I don't think so."/>
		<l2 id="je" display="I don't know." text="I don't know."/>
		<l2 id="jf" display="Indeed." text="Indeed."/>
		<l2 id="jg" display="Pleased to meet you." text="Pleased to meet you."/>
		<l2 id="jh" display="Good." text="I am Good."/>
		<l2 id="ji" display="Evil." text="I am Evil."/>
		<l2 id="jj" display="Me too!" text="Me too!"/>
		<l2 id="jk" display="I got it...">
			<l3 id="la" display="as a drop." text="I got it as a drop."/>
			<l3 id="lb" display="from a shop." text="I got it from a shop."/>
		</l2>
		<l2 id="jl" display="Check the Wiki..." text="You can check the Wiki for the location."/>
		<l2 id="jm" display="Your Book of Lore will know that" text="Your Book of Lore will know that."/>
		<l2 id="jo" display="I can only use Canned Chat." text="I can only use Canned Chat."/>
	</l1>
	<l1 display="Meeting up">
		<l2 id="na" display="Follow me!" text="Follow me!"/>
		<l2 id="nb" display="Over here!" text="Over here!"/>
		<l2 id="nc" display="Goto me." text="Goto me."/>
		<l2 id="nd" display="I'll follow you." text="I'll follow you."/>
		<l2 id="ne" display="Maybe some other time." text="Maybe some other time."/>
		<l2 id="nf" display="Ok, let's go." text="Ok, let's go."/>
		<l2 id="ng" display="Come back here." text="Come back here."/>
		<l2 id="nh" display="I need to finish this first." text="I need to finish this first."/>
		<l2 id="ni" display="Seriously?" text="Seriously?"/>
		<l2 id="nj" display="*I'm going to...">
			<l3 id="oa" display="Artix" text="I'm going to the Artix Server."/>
			<l3 id="ob" display="Galanoth" text="I'm going to the Galanoth Server."/>
			<l3 id="oh" display="Sir Ver" text="I'm going to Sir Ver."/>
			<l3 id="oi" display="Twig" text="I'm going to the Twig server."/>
			<l3 id="oj" display="Twilly" text="I'm going to the Twilly server."/>
			<l3 id="ok" display="Yorumi" text="I'm going to the Yorumi server."/>
			<l3 id="oj" display="TestingServer" text="I'm going to the TestingServer server."/>
			<l3 id="ok" display="TestingServer2" text="I'm going to the TestingServer2 server."/>
		</l2>
		<l2 id="nk" display="Sorry, I'm busy." text="Sorry, I'm busy."/>
	</l1>
	<l1 display="In Battle">
		<l2 id="pa" display="Can you..">
			<l3 id="qa" display="help with battle" text="Can you help me with this battle?"/>
			<l3 id="qb" display="help with Boss" text="Can you help me with the Boss?"/>
		</l2>
		<l2 id="pb" display="Planning...">
			<l3 id="ra" display="Let's attack now!" text="Let's attack now!"/>
			<l3 id="rb" display="I'll attack first." text="I'll attack first."/>
			<l3 id="rc" display="You go first." text="You go first."/>
			<l3 id="rd" display="I need to rest." text="I need to rest."/>
		</l2>
		<l2 id="pc" display="During the battle">
			<l3 id="sa" display="Heal, please!" text="Heal, please!"/>
			<l3 id="sb" display="MEDIC!" text="MEDIC!"/>
			<l3 id="sc" display="Help!" text="Help!"/>
			<l3 id="sd" display="I'm out of Mana." text="I'm out of Mana."/>
			<l3 id="se" display="Use your special attacks!" text="Use your special attacks!"/>
			<l3 id="sf" display="This monster is strong!" text="This monster is strong!"/>
			<l3 id="sg" display="Slay that monster!" text="Slay that monster!"/>
			<l3 id="sh" display="This is hard." text="This hard."/>
			<l3 id="si" display="This is easy." text="This easy."/>
			<l3 id="sj" display="Run away!" text="Run away!"/>
		</l2>
		<l2 id="pd" display="After battle">
			<l3 id="ta" display="Yes! I got the drop!" text="Yes! I got the drop!"/>
			<l3 id="tb" display="We did it!" text="We did it!"/>
			<l3 id="tc" display="You fight well." text="You fight well."/>
			<l3 id="td" display="Nooo! I died!" text="Nooo! I died!"/>
			<l3 id="tf" display="Let's try again!" text="Let's try again!"/>
		</l2>
	</l1>
	<l1 display="Exclamations">
		<l2 id="ua" display="Battle on!" text="Battle on!"/>
		<l2 id="uc" display="OMG!" text="OMG!"/>
		<l2 id="ud" display="lol" text="lol"/>
		<l2 id="uf" display="Woot!" text="Woot!"/>
		<l2 id="ug" display="Wow!" text="Wow"/>
		<l2 id="uh" display="High Five!" text="High Five!"/>
		<l2 id="ui" display="Congrats!" text="Congrats!"/>
		<l2 id="uj" display="Level up!" text="Level up!"/>
		<l2 id="uk" display="Rank up!" text="Rank up!"/>
		<l2 id="ul" display="LONG UN-LIVE THE SHADOWSCYTHE!!" text="LONG UN-LIVE THE SHADOWSCYTHE!!"/>
		<l2 id="um" display="Long live King Alteon the Good!!" text="Long live King Alteon the Good!!"/>
		<l2 id="un" display="This rocks!" text="This rocks!"/>
		<l2 id="uo" display="This is awesome!" text="This is awesome!"/>
		<l2 id="up" display="This is fun." text="This is fun."/>
		<l2 id="uq" display="That is really cool." text="That is really cool."/>
		<l2 id="ur" display="Cheer up!" text="Cheer up!"/>
		<l2 id="ut" display="Great!" text="Great!"/>
		<l2 id="uu" display="HaHa" text="HaHa"/>
	</l1>
	<l1 display="Stop">
		<l2 id="va" display="following me" text="Please stop following me."/>
		<l2 id="vb" display="doing that" text="Please stop doing that."/>
		<l2 id="vc" display="PMing me" text="Please stop PMing me."/>
	</l1>
	<l1 display="Smilies">
		<l2 id="wa" display=":)" text=":)"/>
		<l2 id="wb" display=":(" text=":("/>
		<l2 id="wc" display=":/" text=":/"/>
		<l2 id="wd" display=":|" text=":|"/>
		<l2 id="we" display=":O" text=":O"/>
		<l2 id="wf" display="D:" text="D:"/>
	</l1>
	<l1 id="x" display="Yes." text="Yes."/>
	<l1 id="y" display="No." text="No."/>
	<l1 id="z" display="OK." text="OK."/>
</CannedChat>;

      private var profanityA:Vector.<String> = new <String>["@$$","&&##","anal","arse","ass","a55","a5s","as5","a$$","a$s","as$","a5$","a$5","a*s","*ss","a**","as*","assclown","assface","asshole","asswipe","bastard","beating the meat","beef curtains","beef flaps","betch","biatch","bich","bish","b1ch","b!ch","blch","b|ch","bitch","b1tch","b!tch","bltch","b|tch","bizzach","blowjob","boobies","boobs","b00bs","buggery","bullshit","buttsex","carpet muncher","carpet munchers","carpetlicker","carpetlickers","ch1nk","chink","chode","clit","cocaine","cock","cocks","c0ck","co*k","c*ck","cocksucker","condom","cracka","cum","cumming","cums","cummies","cumguzzler","cumlicker","cuck","cumsucker","cumdrinker","cunt","cunts","c*nt","cu*t","*unt","cun*","cumslut","dicksucker","damn","d1ck","dick","di*k","d*ck","d**k","d|ck","dildo","d1ldo","dumbass","dumb4ss","dyke","ejaculate","f*ck","feck","f@g","fag","f4ggot","f4gg0t","faggot","fap","f4p","fapping","f4pping","fatass","fack","feck","felcher","foreskin","fhuck","fking","fuk","fck","fuck","fuc","fu*k","fuuck","fuuk","fcuk","fvck","fvk","fvvck","fvvk","fock","fux0r","fucken","fucker","fucking","fudgepacker","ganja","gook","h0r","h*re","hentai","heroin","h0mo","h0m0","homo","horny","injun","jack off","jerk off","jackass","j1sm","jism","j1zz","jizz","kawk","kike","klootzak","knulle","kraut","kuk","kunt","kuksuger","kurac","kurwa","kusi","kyrpa","l3+ch","lesbo","lez","marijuana","masturbate","masturbation","meat puppet","merd","milf","molester","m0lester","m0l3ster","m0l3st3r","motherfucker","muie","mulkku","nads","nazi","n1gga","nigga","nigger","nutsack","orospu","orgasm","orgy","p0rn","paska","penis","phuck","pierdol","pillu","pimmel","pimp","piss","poontsee","porn","p0rno","p0rn0","porno","pr0n","preteen","pron","prostitute","pussy","pussie","pu$$y","puta","puto","queef","r4pe","rape","r4ped","raped","rapist","retard","rimjob","schaffer","schiess","schlampe","screw","scrotum","secks","s3x","sex","s*x","se*","sharmuta","sharmute","shipal","shit","sh1t","sh!t","shlt","sh|t","shiz","sh1z","sh!z","shlz","sh|z","shiit","shi!t","sh!it","shilt","shlit","sh||t","shi|t","sh|it","shiiz","shi t","shyt","sh*t","s*it","s**t","s***","shlong","skank","skurwysyn","slut","sl*t","s**t","smartass","smut","spierdalaj","splooge","threesome","tit","tits","titties","twat","vagina","wank","weed","wetback","whack off","wh0re","whore","whoring","wichser","yolasite","zabourah","yolas1te","y0lasite","y0las1te","webly","w33bly","web1y","w33b1y","anus","4nus","rectum","r3ctum","foda","fodao","phoda","phodao","Azzhole","A$$hole","AsshoIe","Azzhole","Asswipe","Btch","B!tch","BItch","BItch","D!ck","Dlck","D!ldo","Dumbass","Dyke","Fgt","Faggot","Fagget","Fegget","Feggit","Feget","Fggot","Fggt","Fhaggot","F4g","Fken","Fkking","fu/ck","H#mo","Nigga","N|gger","Niga","Ngga","Pen1s","Rape","Rhape","Raep","Buceta","Xoxota","Cachorra","Cagada","puta","Foda-se","Macaco","Negrinho","Merda","Porra","Merdimbuca","Mijada","Mijão","Ninfeta","Sapatao","Cagada","Cerote","Chichis","Cojer","Cojido","Culera","Culero","Culona","Joto","Mamahuevo","Maricon","Mierda","Nachas","Nalgas","Nalgona","Pendeja","Pendejo","Perra","Pito","Puta","Puto","Putas","Retardado","Tetas","Verga","Vergisima"];

      private var profanityB:Vector.<String> = new <String>["porn","nigger","slut","dick"];

      private var profanityD:Vector.<String> = new <String>["chink","puto","puta","oten"];

      private var profanityF:Vector.<String> = new <String>["nigga","nigger","cunt","fag","tranny","shemale","kontol","vagina","penis","clitoris","kike","slut","dick"];

      private var profanityC:Vector.<String> = new <String>["bitch","b1tch","b!tch","bltch","b|tch","damn","dick","fag","fuk","fvk","fvck","fuck","pussy","shit","sh1t","sh!t","shlt","sh|t"];

      public var iChat:int = 0;

      public function Chat2(param1:MovieClip)
      {
         super();
         this.r = param1;
         rootClass = param1;
         this.messages = [];
         this.initObject();
      }

      public function initObject() : void
      {
      }

      public function init() : void
      {
         this.initProfanity();
         this.mci = this.r.ui.mcInterface;
         this.mask = new Shape();
         this.mask.graphics.beginFill(0);
         this.mask.graphics.drawRect(0,0,312.7,this.r.ui.nc.ncTextLine.height);
         this.mask.graphics.endFill();
         this.mcInvis = new MovieClip();
         this.mcInvis.addChild(this.mask);
         this.r.ui.addChild(this.mcInvis);
         this.mcInvis.name = "ncMask";
         this.mcInvis.x = this.r.ui.nc.x;
         this.mcInvis.y = this.r.ui.nc.y;
         this.r.ui.nc.mask = this.r.ui.getChildByName("ncMask");
         rootClass.stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.onScroll,false,0,true);
         if(this.touch != null)
         {
            this.touch.detach();
         }
         this.touch = TouchScroll.attach(this.r.ui.nc,this.touchGet,this.touchSet,this.touchMax);
         this.mci.ncSendText.addEventListener(MouseEvent.CLICK,this.onBtnSendText,false,0,true);
         this.mci.ncModeChat.addEventListener(MouseEvent.CLICK,this.onBtnShortTall,false,0,true);
         this.mci.ncCannedChat.addEventListener(MouseEvent.CLICK,this.onCannedChat,false,0,true);
         this.mcCannedChat = this.initCannedChat(this.xmlCannedOptions.children());
         t.addEventListener(TimerEvent.TIMER,this.closeCannedChatTimer);
         this.r.ui.addChild(this.mcCannedChat);
         this.mcCannedChat.addEventListener(MouseEvent.MOUSE_OVER,this.onCannedChatOver);
         this.mcCannedChat.addEventListener(MouseEvent.MOUSE_OUT,this.onCannedChatOut);
         this.mcCannedChat.y = 495 + -this.mcCannedChat.numChildren * 23;
         this.mcCannedChat.visible = false;
         this.r.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.r.key_StageGame);
         this.mci.ncText.addEventListener(KeyboardEvent.KEY_DOWN,this.r.key_ChatEntry);
         this.mci.ncText.addEventListener(Event.CHANGE,this.checkMsgType);
         this.r.fixInputHeight(this.mci.ncText);
         this.r.fixInputHeight(this.mci.ncPrefix);
         this.mci.ncHistory.addEventListener(MouseEvent.CLICK,this.onHistoryClick);
         this.r.ui.mouseEnabled = false;
         this.mci.mouseEnabled = false;
         this.r.ui.nc.mouseEnabled = false;
         this.r.ui.nc.mouseChildren = false;
         this.r.ui.nc.ncTextLine.mouseEnabled = false;
         this.r.ui.nc.ncTextLine.mouseChildren = false;
         this.mcInvis.mouseEnabled = false;
         this.mcInvis.mouseChildren = false;
         this.clearEverything();
         this.setMinimalMode(this.r.litePreference.data.dOptions["chatMinimal"]);
      }

      public function onMinimalOver(param1:MouseEvent) : void
      {
         this.bHovering = true;
         var _loc1_:int = 0;
         while(_loc1_ < this.r.ui.nc.ncTextLine.numChildren)
         {
            this.r.ui.nc.ncTextLine.getChildAt(_loc1_).alpha = this.r.ui.nc.ncTextLine.getChildAt(_loc1_).isTS ? 0.4 : 1;
            _loc1_++;
         }
      }

      public function onMinimalOut(param1:MouseEvent) : void
      {
         this.bHovering = false;
         var _loc1_:int = 0;
         while(_loc1_ < this.r.ui.nc.ncTextLine.numChildren)
         {
            this.r.ui.nc.ncTextLine.getChildAt(_loc1_).alpha = 0;
            _loc1_++;
         }
      }

      public function setMinimalMode(param1:Boolean) : void
      {
         var _loc1_:int = 0;
         if(param1)
         {
            rootClass.stage.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onScroll);
            this.mci.ncText.addEventListener(MouseEvent.MOUSE_WHEEL,this.onScroll,false,0,true);
            this.mci.ncText.addEventListener(MouseEvent.MOUSE_OVER,this.onMinimalOver,false,0,true);
            this.mci.ncText.addEventListener(MouseEvent.MOUSE_OUT,this.onMinimalOut,false,0,true);
            this.fadeQueue = [];
            this.fadeTimer = new Timer(70);
            this.fadeTimer.addEventListener(TimerEvent.TIMER,this.fadeEffect,false,0,true);
            this.fadeTimer.start();
         }
         else if(this.bMinimal)
         {
            rootClass.stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.onScroll,false,0,true);
            this.mci.ncText.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onScroll);
            this.mci.ncText.removeEventListener(MouseEvent.MOUSE_OVER,this.onMinimalOver);
            this.mci.ncText.removeEventListener(MouseEvent.MOUSE_OUT,this.onMinimalOut);
            this.fadeQueue = null;
            this.fadeTimer.reset();
            this.fadeTimer.removeEventListener(TimerEvent.TIMER,this.fadeEffect);
            this.fadeTimer = null;
            this.bHovering = false;
            _loc1_ = 0;
            while(_loc1_ < this.r.ui.nc.ncTextLine.numChildren)
            {
               this.r.ui.nc.ncTextLine.getChildAt(_loc1_).alpha = this.r.ui.nc.ncTextLine.getChildAt(_loc1_).isTS ? 0.4 : 1;
               _loc1_++;
            }
         }
         this.bMinimal = param1;
         if(this.bMinimal && this.fadeQueue.length == 0)
         {
            _loc1_ = 0;
            while(_loc1_ < this.r.ui.nc.ncTextLine.numChildren)
            {
               this.r.ui.nc.ncTextLine.getChildAt(_loc1_).alpha = 0;
               _loc1_++;
            }
         }
      }

      private function rebuildHistory() : void
      {
         if(this.cmdHistory.length < 1)
         {
            return;
         }
         if(this.r.ui.getChildByName("mcHistory"))
         {
            this.r.ui.removeChild(this.r.ui.getChildByName("mcHistory"));
         }
         this.mcHistory = this.initHistory();
         this.r.ui.addChild(this.mcHistory);
         this.mcHistory.name = "mcHistory";
         this.mcHistory.x = 42.95;
         this.mcHistory.y = 495 + -this.mcHistory.numChildren * 23;
         this.mcHistory.visible = false;
      }

      private function initHistory() : MovieClip
      {
         var _loc1_:* = undefined;
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = new MovieClip();
         var _loc4_:Number = 0;
         var _loc5_:int = 0;
         while(_loc5_ < this.cmdHistory.length)
         {
            _loc1_ = new CannedOption();
            _loc1_.y = _loc5_ * 23;
            _loc1_.addEventListener(MouseEvent.ROLL_OVER,this.onCmdRollOver,false,0,true);
            _loc1_.addEventListener(MouseEvent.ROLL_OUT,this.onCmdRollOut,false,0,true);
            _loc1_.txtChat.text = this.cmdHistory[_loc5_];
            if(_loc1_.txtChat.textWidth > _loc4_)
            {
               _loc4_ = Number(_loc1_.txtChat.textWidth);
            }
            _loc1_.mcMore.visible = false;
            _loc1_.strMsg = this.cmdHistory[_loc5_];
            _loc3_.addChild(_loc1_);
            _loc1_.addEventListener(MouseEvent.CLICK,this.onCmdMouseClick,false,0,true);
            _loc5_++;
         }
         var _loc6_:int = 0;
         while(_loc6_ < _loc3_.numChildren)
         {
            _loc2_ = MovieClip(_loc3_.getChildAt(_loc6_));
            _loc2_.txtChat.width = _loc4_ + 6;
            _loc2_.bg.width = _loc4_ + 20;
            _loc6_++;
         }
         var _loc7_:BevelFilter = new BevelFilter(1,45,0,1,0,1,0,0,1,3);
         _loc3_.filters = [_loc7_];
         return _loc3_;
      }

      private function onCmdRollOver(param1:MouseEvent) : *
      {
         var _loc1_:* = MovieClip(param1.currentTarget);
         _loc1_.bg.transform.colorTransform = new ColorTransform(1,1,1,1,25,25,25,0);
      }

      private function onCmdRollOut(param1:MouseEvent) : *
      {
         var _loc1_:* = MovieClip(param1.currentTarget);
         _loc1_.bg.transform.colorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
      }

      private function onCmdMouseClick(param1:MouseEvent) : *
      {
         var _loc1_:* = MovieClip(param1.currentTarget);
         this.mci.ncText.text = _loc1_.strMsg;
         this.mcHistory.visible = false;
         this.r.stage.focus = null;
      }

      public function onHistoryClick(param1:MouseEvent) : void
      {
         if(this.cmdHistory.length < 1)
         {
            return;
         }
         this.mcHistory.visible = !this.mcHistory.visible;
      }

      public function onCannedChat(param1:MouseEvent) : void
      {
         this.mcCannedChat.visible = !this.mcCannedChat.visible;
      }

      public function onClick(param1:MouseEvent) : void
      {
         if(Boolean(param1.target) && Boolean(param1.target.parent) && Boolean(param1.target.parent.id) && Boolean(param1.target.parent.hasURL))
         {
            this.onLinkSelected(param1.target.parent.id);
         }
      }

      public function onBtnShortTall(param1:MouseEvent) : void
      {
         ++this.iChatMode;
         if(this.iChatMode > 2)
         {
            this.iChatMode = 0;
         }
         this.r.ui.nc.visible = this.iChatMode != 2;
         if(this.iChatMode == 2)
         {
            return;
         }
         this.bTall = this.iChatMode == 1;
         this.r.ui.removeChild(this.r.ui.getChildByName("ncMask"));
         this.mask = new Shape();
         this.mask.graphics.beginFill(0);
         this.mask.graphics.drawRect(0,0,312.7,this.bTall ? 324.6 : 118.1);
         this.mask.graphics.endFill();
         this.mcInvis = new MovieClip();
         this.mcInvis.addChild(this.mask);
         this.r.ui.addChild(this.mcInvis);
         this.mcInvis.name = "ncMask";
         this.mcInvis.x = this.r.ui.nc.x;
         this.mcInvis.y = this.bTall ? 187.9 - 20 : 374.9;
         this.r.ui.nc.mask = this.r.ui.getChildByName("ncMask");
         this.mcInvis.mouseEnabled = false;
         this.mcInvis.mouseChildren = false;
         this.upConst = this.bTall ? 187.4 : 51;
         this.heightConst = this.bTall ? -132.95 : 83.45;
         this.rebuild();
      }

      public function onBtnSendText(param1:MouseEvent) : void
      {
         this.submitMsg(this.mci.ncText.text,chn.cur.typ,pmNm);
         this.r.stage.focus = null;
      }

      private function toBottom() : void
      {
         this.r.ui.nc.ncTextLine.y = this.r.ui.nc.mask.height - this.r.ui.nc.ncTextLine.height + this.heightConst;
         this.r.ui.nc.ncTextLine.y -= this.r.ui.nc.ncTextLine.getChildAt(this.r.ui.nc.ncTextLine.numChildren - 1).height - 16.25;
      }

      private function setScrollForBottom(param1:Boolean = false, param2:Boolean = false) : void
      {
         this.heightConst = this.bTall ? -132.95 : 83.45;
         if(this.r.ui.nc.ncTextLine.numChildren < 1)
         {
            return;
         }
         if(this.r.litePreference.data.dOptions["chatScroll"])
         {
            if(this.wasBottom && param1 || param2)
            {
               this.toBottom();
            }
            return;
         }
         if(param1 || param2)
         {
            this.toBottom();
         }
      }

      private function touchOff() : Boolean
      {
         return Boolean(rootClass.litePreference.data.bDisChatScroll) || this.r.ui.nc.ncTextLine.numChildren < 1;
      }

      private function touchMax() : Number
      {
         if(this.touchOff())
         {
            return 0;
         }
         this.setScrollForBottom();
         var _loc1_:MovieClip = this.r.ui.nc.ncTextLine;
         return Math.max(0,this.upConst - (this.heightConst - (_loc1_.height - this.r.ui.nc.mask.height)));
      }

      private function touchGet() : Number
      {
         return this.upConst - this.r.ui.nc.ncTextLine.y;
      }

      private function touchSet(param1:Number) : void
      {
         var _loc1_:Number = Number(this.touchMax());
         if(_loc1_ <= 0)
         {
            return;
         }
         if(param1 >= _loc1_)
         {
            this.toBottom();
         }
         else
         {
            this.r.ui.nc.ncTextLine.y = this.upConst - param1;
         }
      }

      public function onScroll(param1:MouseEvent) : void
      {
         if(rootClass.litePreference.data.bDisChatScroll)
         {
            return;
         }
         if(!this.r.ui.nc.hitTestPoint(param1.stageX,param1.stageY))
         {
            return;
         }
         var _loc1_:MovieClip = this.r.ui.nc.ncTextLine;
         param1.delta *= 6;
         this.setScrollForBottom();
         _loc1_.y += param1.delta;
         if(_loc1_.y >= this.upConst)
         {
            _loc1_.y = this.upConst;
         }
         else if(_loc1_.y <= this.heightConst - (_loc1_.height - this.r.ui.nc.mask.height))
         {
            this.toBottom();
         }
      }

      public function nuProfanityCheck(param1:String, param2:Boolean = false) : Object
      {
         var _loc1_:String = null;
         var _loc2_:* = param2 ? this.profanityD : this.profanityA;
         var _loc3_:* = param2 ? this.profanityF : this.profanityB;
         var _loc4_:int = 0;
         var _loc5_:Object = {
            "code":0,
            "term":"",
            "index":-1,
            "indeces":[]
         };
         _loc1_ = " " + this.removeHTML(this.cleanStr(param1.toLowerCase())) + " ";
         _loc1_ = rootClass.stripMarks(_loc1_);
         _loc1_ = rootClass.stripDuplicateVowels(_loc1_);
         _loc1_ = _loc1_.replace(this.regExpMultiG,"gg");
         _loc4_ = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc5_.index = _loc1_.indexOf(" " + _loc2_[_loc4_] + " ");
            if(_loc5_.index > -1)
            {
               _loc5_.term = _loc2_[_loc4_];
               _loc5_.indeces.push({"term":_loc5_.term});
               _loc5_.code = 1;
            }
            _loc4_++;
         }
         _loc1_ = rootClass.stripDuplicateVowels(this.removeHTML(this.cleanStr(param1.toLowerCase())));
         _loc1_ = rootClass.stripWhiteStrict(_loc1_);
         _loc1_ = _loc1_.replace(this.regExpMultiG,"gg");
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_.index = _loc1_.indexOf(_loc3_[_loc4_]);
            if(_loc5_.index > -1)
            {
               _loc5_.term = _loc3_[_loc4_];
               _loc5_.indeces.push({"term":_loc5_.term});
               _loc5_.code = 2;
            }
            _loc4_++;
         }
         return _loc5_;
      }

      public function createAsterisk(param1:int) : *
      {
         var _loc1_:String = "";
         var _loc2_:int = 0;
         while(_loc2_ < param1)
         {
            _loc1_ += "*";
            _loc2_++;
         }
         return _loc1_;
      }

      public function buildRegex(param1:String) : String
      {
         var _loc1_:String = "";
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc1_ += "(" + (this.regexEscapes.indexOf(param1.charAt(_loc2_)) > -1 ? "\\" : "") + param1.charAt(_loc2_) + ")+";
            _loc2_++;
         }
         return _loc1_;
      }

      public function forceRemove(param1:String) : String
      {
         var _loc1_:String = param1;
         var _loc2_:RegExp = /\W*?(cum|faggot)\W*\b/gi;
         return _loc1_.replace(_loc2_,"");
      }

      public function maskStringBetween(param1:String, param2:Array) : String
      {
         var _loc1_:* = undefined;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = param1;
         if(param2.length > 0)
         {
            for each(_loc1_ in param2)
            {
               _loc2_ = this.buildRegex(_loc1_.term);
               _loc3_ = _loc2_ + "|gi";
               if(this._regexCache[_loc3_] == null)
               {
                  this._regexCache[_loc3_] = new RegExp(_loc2_,"gi");
               }
               _loc4_ = _loc4_.replace(this._regexCache[_loc3_],this.createAsterisk(3));
            }
         }
         else
         {
            trace("[Chat] ERR maskStringBetween: malformed indeces array");
         }
         return _loc4_;
      }

      public function pushMsg(param1:*, param2:*, param3:*, param4:*, param5:*, param6:int = 0) : *
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:Number = NaN;
         var _loc9_:String = null;
         if(this.r.litePreference.data.bChatFilter)
         {
            if(Boolean(this.r.litePreference.data.dOptions["disRed"]) && param1 == "warning")
            {
               _loc1_ = true;
               if(param2.indexOf("You are out of range!") > -1)
               {
                  _loc1_ = false;
               }
               else if(param2.indexOf("is not ready yet.") > -1)
               {
                  _loc1_ = false;
               }
               else if(param2.indexOf("No target selected!") > -1)
               {
                  _loc1_ = false;
               }
               else if(param2.indexOf("Not enough mana!") > -1)
               {
                  _loc1_ = false;
               }
               if(!_loc1_)
               {
                  return;
               }
            }
         }
         if(ignoreList.data.users != null && ignoreList.data.users.indexOf(param3) > -1)
         {
            return;
         }
         param2 = this.cleanStr(param2);
         var _loc10_:Boolean = false;
         if(param3 != "SERVER")
         {
            _loc2_ = 0;
            _loc3_ = rootClass.stripWhite(param2.toLowerCase());
            _loc4_ = this.nuProfanityCheck(param2.toLowerCase());
            _loc5_ = this.profanityCheck(param2.toLowerCase());
            if(param3.toLowerCase() != rootClass.sfc.myUserName && param6 == 0)
            {
               if(this.strContains(_loc3_,illegalStrings) || this.strContains(_loc3_,unsendable))
               {
                  _loc2_ = 1;
               }
               _loc3_ = this.r.stripWhiteStrict(param2.toLowerCase());
               if(this.strContains(_loc3_,["email","password"]))
               {
                  _loc2_ = 1;
               }
               if(param1 == "whisper" && this.modWhisperCheck(param2) > 0)
               {
                  _loc10_ = true;
               }
               if(_loc2_)
               {
                  return;
               }
            }
            if(Boolean(_loc4_.code) && Boolean(rootClass.uoPref.bProf))
            {
               param2 = this.maskStringBetween(param2,_loc4_.indeces);
            }
            if(!rootClass.uoPref.bProf)
            {
               _loc4_ = this.nuProfanityCheck(param2.toLowerCase(),true);
               if(_loc4_.code)
               {
                  param2 = this.maskStringBetween(param2,_loc4_.indeces);
               }
            }
            param2 = this.forceRemove(param2);
         }
         if(param3.toLowerCase() == rootClass.sfc.myUserName && rootClass.world.myAvatar.objData.intActivationFlag == 1)
         {
            this.pushMsg("warning","Confirm your email at https://account.aq.com/ to protect your account and remove this message. ","SERVER","",0);
            return;
         }
         if(this.bMinimal && this.messages.length > 2)
         {
            _loc6_ = this.messages[this.messages.length - 1];
            _loc7_ = 0;
            while(_loc7_ < 2)
            {
               if(_loc6_.msg == param2 && (_loc6_.user == param3 || param3 == "SERVER" && _loc6_.user == "") && _loc6_.typ == param1 && _loc6_.rnm == param4 && _loc6_.org == param5)
               {
                  return;
               }
               _loc6_ = this.messages[this.messages.length - 2];
               _loc7_++;
            }
         }
         var _loc11_:Object = {
            "id":this.messages.length,
            "typ":param1,
            "rnm":param4,
            "org":param5,
            "user":param3,
            "time":"0:00",
            "msg":param2,
            "tMC":null,
            "mc":null
         };
         _loc11_.user = param3 == "SERVER" ? "" : param3;
         if(this.isChannel(param1))
         {
            if(param1 == "zone")
            {
               param3 = this.r.strToProperCase(param3);
               this.popBubble("u:" + param3,param2,param1);
            }
            this.messages.push(_loc11_);
            if(Boolean(this.r.ui) && Boolean(this.r.ui.nc) && Boolean(this.r.ui.nc.ncTextLine) && Boolean(this.r.ui.nc.mask))
            {
               _loc8_ = this.heightConst - (this.r.ui.nc.ncTextLine.height - this.r.ui.nc.mask.height);
               this.wasBottom = Math.round(this.r.ui.nc.ncTextLine.y) == Math.round(_loc8_);
            }
            this.buildMessage(this.messages[this.messages.length - 1]);
         }
         if(_loc10_)
         {
            this.pushMsg("warning",param3 + " IS NOT A MODERATOR.  DO NOT GIVE ACCOUNT INFORMATION TO OTHER PLAYERS.","SERVER","",0);
            _loc9_ = "<font color=\'#FF0000\'>WARNING</font><br/><font color=\'#FFFFFF\'>" + param3.toUpperCase() + "</font><font color=\'#FFFFFF\'> IS NOT A MODERATOR.<br/>Do not give account information to other players.<font>";
            _loc9_ = _loc9_ + "<br/><a href=\'event:link::https://aq.com/safety.asp\'><font color=\'#66CCFF\'><u>Click here</u></font></a> to learn more.";
            this.r.ui.ToolTip.openWith({
               "str":_loc9_,
               "lowerright":true,
               "invert":true,
               "closein":10000
            });
         }
      }

      public function clearMessages() : void
      {
         if(Boolean(this.mci) && Boolean(this.r.ui.nc))
         {
            while(this.r.ui.nc.ncTextLine.numChildren > 0)
            {
               this.r.ui.nc.ncTextLine.removeChildAt(0);
            }
         }
      }

      public function clearEverything() : void
      {
         this.clearMessages();
         this.filterCode = 0;
         if(Boolean(this.mci) && Boolean(this.r.ui.nc))
         {
            this.messages = [];
         }
      }

      public function bMinMaxClick(param1:MouseEvent) : void
      {
      }

      public function format_time() : String
      {
         var _loc1_:String = null;
         var _loc2_:Number = Number(rootClass.date_server.hours);
         var _loc3_:Number = Number(rootClass.date_server.minutes);
         var _loc4_:String = "PM";
         if(_loc2_ < 10)
         {
            _loc1_ = "0" + _loc2_;
         }
         if(_loc2_ > 12)
         {
            _loc2_ -= 12;
         }
         else if(_loc2_ == 0)
         {
            _loc4_ = "AM";
            _loc2_ = 12;
         }
         else if(_loc2_ < 12)
         {
            _loc4_ = "AM";
         }
         _loc1_ = "" + _loc2_;
         var _loc5_:String = "" + _loc3_;
         if(_loc3_ < 10)
         {
            _loc5_ = "0" + _loc3_;
         }
         if(_loc5_ == "NaN")
         {
            return "";
         }
         return _loc1_ + ":" + _loc5_ + " " + _loc4_;
      }

      public function buildMessage(param1:Object) : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:TextField = null;
         var _loc4_:TextFormat = null;
         var _loc5_:* = undefined;
         var _loc6_:MovieClip = null;
         var _loc7_:* = undefined;
         var _loc8_:MovieClip = null;
         if(this.format_time() != "")
         {
            _loc3_ = new TextField();
            _loc4_ = new TextFormat();
            _loc4_.font = "Arial";
            _loc4_.size = 9;
            _loc4_.color = 16777215;
            _loc4_.indent = -10;
            _loc4_.leftMargin = 10;
            _loc4_.align = TextFormatAlign.RIGHT;
            _loc5_ = this.format_time();
            _loc3_.text = _loc5_;
            _loc3_.antiAliasType = AntiAliasType.ADVANCED;
            _loc3_.embedFonts = true;
            _loc3_.setTextFormat(_loc4_,0,_loc3_.text.length);
            _loc3_.filters = [CHAT_SHADOW];
            _loc3_.width = 44.1;
            _loc6_ = new MovieClip();
            _loc6_.addChild(_loc3_);
            _loc6_.alpha = 0.4;
            param1.tMC = _loc6_;
         }
         var _loc9_:TextField = new TextField();
         _loc9_.antiAliasType = AntiAliasType.ADVANCED;
         _loc9_.embedFonts = true;
         _loc9_.multiline = true;
         _loc9_.wordWrap = true;
         _loc9_.autoSize = TextFieldAutoSize.LEFT;
         _loc9_.filters = [CHAT_SHADOW];
         var _loc10_:TextFormat = new TextFormat();
         _loc10_.font = "Arial";
         _loc10_.size = 11;
         _loc10_.color = 16777215;
         var _loc11_:TextFormat = new TextFormat();
         _loc11_.font = "Arial";
         _loc11_.size = 11;
         _loc11_.color = chn[param1.typ].col;
         _loc11_.indent = -10;
         _loc11_.leftMargin = 10;
         if(param1.typ == "whisper")
         {
            if(param1.user == this.r.sfc.myUserName || Boolean(this.isMyModHandle(param1.user)))
            {
               if(param1.org == 0)
               {
                  _loc11_.color = uint("0x" + rootClass.modColor("FF00FF","666666","-"));
                  _loc1_ = "To ";
               }
               else
               {
                  _loc1_ = "From ";
               }
            }
            else
            {
               _loc1_ = "From ";
            }
         }
         else
         {
            _loc1_ = chn[param1.typ].tag == "" ? "" : "[" + chn[param1.typ].tag + "] ";
         }
         if(param1.typ == "whisper")
         {
            if(param1.user == this.r.sfc.myUserName || Boolean(this.isMyModHandle(param1.user)))
            {
               if(param1.org == 0)
               {
                  _loc2_ = param1.rnm + ": ";
               }
               else
               {
                  _loc2_ = param1.user + ": ";
               }
            }
            else
            {
               _loc2_ = param1.user + ": ";
            }
         }
         else
         {
            _loc2_ = param1.user + (param1.user == "" ? "" : ": ");
         }
         _loc9_.width = param1.tMC ? 266.5 : 314;
         _loc9_.text = _loc1_ + _loc2_ + param1.msg;
         if(_loc9_.text.length < 1)
         {
            this.messages.pop();
            return;
         }
         if(_loc1_ != "")
         {
            _loc9_.setTextFormat(_loc11_,0,_loc1_.length);
            _loc9_.setTextFormat(_loc10_,_loc1_.length,_loc1_.length + _loc2_.length);
            _loc9_.setTextFormat(_loc11_,_loc1_.length + _loc2_.length,_loc9_.text.length);
         }
         else if(_loc2_ != "")
         {
            _loc9_.setTextFormat(_loc10_,0,_loc2_.length - 2);
            _loc9_.setTextFormat(_loc11_,_loc2_.length - 2,_loc9_.text.length);
         }
         else
         {
            _loc9_.setTextFormat(_loc11_,0,_loc9_.text.length);
         }
         _loc9_.width = param1.tMC ? 266.5 : 314;
         var _loc12_:TextFormat = new TextFormat();
         _loc12_.font = "Arial";
         _loc12_.size = 11;
         _loc12_.color = 16777113;
         _loc12_.underline = true;
         regExpURL.lastIndex = 0;
         var _loc13_:Object = regExpURL.exec(_loc9_.text);
         while(_loc13_ != null)
         {
            _loc9_.setTextFormat(_loc12_,_loc13_.index,_loc13_.index + _loc13_[0].length);
            _loc13_ = regExpURL.exec(_loc9_.text);
            param1.hasURL = true;
         }
         var _loc14_:MovieClip = new MovieClip();
         _loc14_.addChild(_loc9_);
         _loc14_.mouseEnabled = _loc14_.mouseChildren = false;
         param1.mc = _loc14_;
         if(this.filterCode > 0 || this.messages.length >= this.lineLimit)
         {
            if(this.messages.length >= this.lineLimit)
            {
               if(this.filterCode > 0 && this.r.ui.nc.ncTextLine.numChildren >= this.lineLimit * 2 || this.filterCode == 0 && this.r.ui.nc.ncTextLine.numChildren > 0)
               {
                  _loc7_ = 0;
                  while(_loc7_ < 50)
                  {
                     this.messages.shift();
                     if(this.r.ui.nc.ncTextLine.numChildren >= 2)
                     {
                        if(this.r.ui.nc.ncTextLine.getChildAt(0).isTS)
                        {
                           this.r.ui.nc.ncTextLine.removeChildAt(0);
                        }
                        this.r.ui.nc.ncTextLine.removeChildAt(0);
                     }
                     _loc7_++;
                  }
               }
            }
            this.rebuild();
            return;
         }
         if(param1.tMC)
         {
            _loc8_ = this.r.ui.nc.ncTextLine.addChild(param1.tMC);
            _loc8_.mouseEnabled = false;
            _loc8_.id = param1.id;
            _loc8_.isTS = true;
            if(this.messages.length > 1)
            {
               _loc8_.y = this.messages[this.messages.length - 2].mc.y + this.messages[this.messages.length - 2].mc.height + 1.55;
            }
            if(this.bMinimal && !this.bHovering)
            {
               this.pushFade(_loc8_);
            }
         }
         var _loc15_:MovieClip = this.r.ui.nc.ncTextLine.addChild(param1.mc);
         _loc15_.mouseEnabled = false;
         _loc15_.id = param1.id;
         _loc15_.hasURL = param1.hasURL;
         _loc15_.x = param1.tMC ? 47.45 : 0;
         if(this.messages.length > 1)
         {
            _loc15_.y = this.messages[this.messages.length - 2].mc.y + this.messages[this.messages.length - 2].mc.height;
         }
         if(this.bMinimal && !this.bHovering)
         {
            this.pushFade(_loc15_);
         }
         this.setScrollForBottom(true,param1.typ == "server" && param1.msg == "Character load complete.");
      }

      public function onLinkSelected(param1:Number) : void
      {
         var _loc1_:* = undefined;
         var _loc2_:Object = null;
         var _loc3_:MovieClip = null;
         var _loc4_:* = undefined;
         for each(_loc1_ in this.messages)
         {
            if(_loc1_.id == param1 && Boolean(_loc1_.hasURL))
            {
               regExpURL.lastIndex = 0;
               _loc2_ = regExpURL.exec(_loc1_.msg);
               while(_loc2_ != null)
               {
                  _loc3_ = new ModalMC();
                  _loc4_ = {};
                  _loc4_.strBody = "Are you sure you want to go to " + _loc2_[0] + "?";
                  _loc4_.callback = this.urlTraverse;
                  _loc4_.params = {"url":_loc2_[0]};
                  _loc4_.btns = "dual";
                  this.r.ui.ModalStack.addChild(_loc3_);
                  _loc3_.init(_loc4_);
                  _loc2_ = regExpURL.exec(_loc1_.msg);
               }
            }
         }
      }

      public function urlTraverse(param1:Object) : void
      {
         if(param1.accept)
         {
            navigateToURL(new URLRequest(param1.url),"_blank");
         }
         this.r.stage.focus = null;
      }

      public function pushFade(param1:Object) : void
      {
         this.fadeQueue.push([param1,getTimer()]);
         if(Boolean(this.fadeTimer) && !this.fadeTimer.running)
         {
            this.fadeTimer.start();
         }
      }

      public function fadeEffect(param1:TimerEvent) : void
      {
         var _loc1_:int = 0;
         var _loc2_:Array = null;
         if(!this.r.ui || !this.r.ui.nc || !this.r.ui.nc.ncTextLine)
         {
            return;
         }
         if(this.bHovering || this.fadeQueue.length < 1)
         {
            if(this.bHovering)
            {
               this.fadeQueue = [];
            }
            if(!this.bHovering)
            {
               _loc1_ = 0;
               while(_loc1_ < this.r.ui.nc.ncTextLine.numChildren)
               {
                  this.r.ui.nc.ncTextLine.getChildAt(_loc1_).alpha = 0;
                  _loc1_++;
               }
            }
            this.fadeTimer.stop();
            return;
         }
         var _loc3_:int = int(getTimer());
         var _loc4_:* = int(this.fadeQueue.length - 1);
         while(_loc4_ >= 0)
         {
            _loc2_ = this.fadeQueue[_loc4_];
            if(!_loc2_[0])
            {
               this.fadeQueue.splice(_loc4_,1);
            }
            else if(_loc3_ - _loc2_[1] >= 45000)
            {
               if(_loc2_[0].alpha > 0)
               {
                  _loc2_[0].alpha -= 0.05;
               }
               if(_loc2_[0].alpha <= 0)
               {
                  this.fadeQueue.splice(_loc4_,1);
               }
            }
            _loc4_--;
         }
      }

      public function rebuild() : void
      {
         var _loc1_:Object = null;
         var _loc2_:* = undefined;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         this.clearMessages();
         var _loc5_:* = 0;
         for(; _loc5_ < this.messages.length; _loc5_++)
         {
            _loc2_ = this.messages[_loc5_];
            if(this.filterCode > 0)
            {
               if(this.filterCode == 1)
               {
                  if(_loc2_.typ != "party")
                  {
                     continue;
                  }
               }
               else if(this.filterCode == 2)
               {
                  if(_loc2_.typ != "guild")
                  {
                     continue;
                  }
               }
               else if(this.filterCode == 3)
               {
                  if(_loc2_.typ != "zone" && _loc2_.typ != "moderator" && _loc2_.typ != "whisper")
                  {
                     continue;
                  }
               }
            }
            if(_loc2_.tMC)
            {
               _loc4_ = this.r.ui.nc.ncTextLine.addChild(_loc2_.tMC);
               _loc4_.mouseEnabled = false;
               _loc4_.id = _loc2_.id;
               _loc4_.x = 0;
               if(_loc1_)
               {
                  _loc4_.y = _loc1_.mc.y + _loc1_.mc.height + 1.55;
               }
               else
               {
                  _loc4_.y = 1.55;
               }
            }
            _loc3_ = this.r.ui.nc.ncTextLine.addChild(_loc2_.mc);
            _loc3_.mouseEnabled = false;
            _loc3_.id = _loc2_.id;
            _loc3_.hasURL = _loc2_.hasURL;
            _loc3_.x = _loc2_.tMC ? 47.45 : 0;
            if(_loc1_)
            {
               _loc3_.y = _loc1_.mc.y + _loc1_.mc.height;
            }
            else
            {
               _loc3_.y = 0;
            }
            _loc1_ = _loc2_;
         }
         this.setScrollForBottom(true);
      }

      private function initProfanity() : void
      {
         var _loc1_:String = null;
         var _loc2_:Array = new Array("butt","pron","rape","tits","shi t","shi t");
         var _loc3_:Array = new Array("as5","a5s","a$$","a5$","a$5","as$","fck","fkc","fvk","fuck","fvck","fukk","fvkk","sh!t","sh|t","sh1t","shiz");
         var _loc4_:int = 0;
         while(_loc4_ < this.profanityA.length)
         {
            _loc1_ = rootClass.stripWhiteStrict(this.profanityA[_loc4_]);
            if(_loc2_.indexOf(_loc1_) == -1 && (_loc1_.length > 4 || _loc3_.indexOf(_loc1_) > -1))
            {
               this.profanityB.push(_loc1_);
            }
            else if(this.profanityA[_loc4_].indexOf("*") > -1)
            {
               this.profanityB.push(this.profanityA[_loc4_]);
            }
            _loc4_++;
         }
      }

      override protected function initCannedChat(param1:XMLList) : MovieClip
      {
         var _loc1_:XML = null;
         var _loc2_:* = undefined;
         var _loc3_:String = null;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = new MovieClip();
         var _loc6_:Number = 0;
         var _loc7_:int = 0;
         while(_loc7_ < param1.length())
         {
            _loc1_ = param1[_loc7_];
            _loc2_ = new CannedOption();
            _loc2_.y = _loc7_ * 23;
            _loc2_.addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
            _loc2_.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
            _loc2_.txtChat.text = _loc1_.attribute("display").toString();
            if(_loc2_.txtChat.textWidth > _loc6_)
            {
               _loc6_ = Number(_loc2_.txtChat.textWidth);
            }
            _loc2_.strMsg = _loc1_.attribute("text").toString();
            _loc2_.id = _loc1_.attribute("id").toString();
            _loc5_.addChild(_loc2_);
            if(_loc1_.children().length() > 0)
            {
               _loc2_.mcMoreOptions = this.initCannedChat(_loc1_.children());
               _loc2_.addChild(_loc2_.mcMoreOptions);
               _loc2_.mcMoreOptions.visible = false;
               _loc3_ = _loc2_.txtChat.text;
               if(_loc3_ == "During the battle" || _loc3_ == "*I\'m going to...")
               {
                  _loc2_.mcMoreOptions.y -= 100;
               }
            }
            else
            {
               _loc2_.mcMore.visible = false;
               _loc2_.addEventListener(MouseEvent.CLICK,this.onMouseClick);
            }
            _loc7_++;
         }
         var _loc8_:int = 0;
         while(_loc8_ < _loc5_.numChildren)
         {
            _loc4_ = MovieClip(_loc5_.getChildAt(_loc8_));
            _loc4_.txtChat.width = _loc6_ + 6;
            _loc4_.bg.width = _loc6_ + 20;
            _loc4_.mcMore.x = _loc4_.bg.width - 10;
            if(_loc4_.mcMoreOptions != null)
            {
               _loc4_.mcMoreOptions.x = _loc4_.bg.width;
            }
            _loc8_++;
         }
         var _loc9_:BevelFilter = new BevelFilter(1,45,0,1,0,1,0,0,1,3);
         _loc5_.filters = [_loc9_];
         return _loc5_;
      }

      public function closeCannedChat() : void
      {
         this.mcCannedChat.visible = false;
      }

      private function onRollOver(param1:MouseEvent) : *
      {
         var _loc1_:* = undefined;
         var _loc2_:Point = null;
         var _loc3_:Point = null;
         var _loc4_:* = MovieClip(param1.currentTarget);
         _loc4_.bg.transform.colorTransform = new ColorTransform(1,1,1,1,25,25,25,0);
         if(param1.currentTarget.mcMoreOptions != null)
         {
            param1.currentTarget.mcMoreOptions.visible = true;
            _loc1_ = param1.currentTarget;
            _loc2_ = new Point(_loc1_.x,_loc1_.y + _loc1_.mcMoreOptions.y + _loc1_.mcMoreOptions.numChildren * 23);
            _loc3_ = this.mcCannedChat.localToGlobal(_loc2_);
            if(_loc3_.y > 500)
            {
               _loc1_.mcMoreOptions.y -= _loc3_.y - 500;
            }
         }
      }

      private function onRollOut(param1:MouseEvent) : *
      {
         var _loc1_:* = MovieClip(param1.currentTarget);
         _loc1_.bg.transform.colorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
         if(param1.currentTarget.mcMoreOptions != null)
         {
            param1.currentTarget.mcMoreOptions.visible = false;
         }
      }

      private function onMouseClick(param1:MouseEvent) : *
      {
         var _loc1_:* = MovieClip(param1.currentTarget);
         if(_loc1_.id == "emote")
         {
            this.submitMsg("/" + _loc1_.strMsg,"emote",rootClass.sfc.myUserName);
         }
         else
         {
            rootClass.sfc.sendXtMessage("zm","cc",[_loc1_.id],"str",1);
         }
         this.closeCannedChat();
      }

      private function onCannedChatOver(param1:MouseEvent) : *
      {
         if(t != null)
         {
            t.reset();
         }
      }

      private function onCannedChatOut(param1:MouseEvent) : *
      {
         t.start();
      }

      private function closeCannedChatTimer(param1:TimerEvent) : *
      {
         this.closeCannedChat();
      }

      public function getCCText(param1:String) : String
      {
         var _loc1_:XML = this.getCCOption(param1,this.xmlCannedOptions.children());
         if(_loc1_ != null)
         {
            return _loc1_.attribute("text").toString();
         }
         return "";
      }

      private function getCCOption(param1:String, param2:XMLList) : XML
      {
         var _loc1_:XML = null;
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         while(_loc3_ < param2.length())
         {
            _loc1_ = param2[_loc3_];
            if(_loc1_.children().length() == 0)
            {
               if(_loc1_.attribute("id").toString() == param1)
               {
                  return _loc1_;
               }
            }
            else
            {
               _loc2_ = this.getCCOption(param1,_loc1_.children());
               if(_loc2_ != null)
               {
                  return _loc2_;
               }
            }
            _loc3_++;
         }
         return null;
      }

      private function isMyModHandle(param1:String) : Boolean
      {
         if(param1.split("-")[0] == "Moderator" && Boolean(int(param1.split("-")[1] == this.r.world.modID)))
         {
            return true;
         }
         return false;
      }

      internal function popBubble(param1:*, param2:*, param3:*) : *
      {
         var _loc1_:* = null;
         var _loc2_:* = param1.split(":")[0];
         param1 = param1.substr(2);
         switch(_loc2_)
         {
            case "u":
               _loc1_ = this.r.world.getMCByUserName(param1);
         }
         if(_loc1_ != null)
         {
            _loc1_.bubble.ti.autoSize = TextFieldAutoSize.CENTER;
            _loc1_.bubble.ti.wordWrap = true;
            _loc1_.bubble.ti.text = param2;
            _loc1_.bubble.bg.width = int(_loc1_.bubble.ti.textWidth + 12);
            _loc1_.bubble.bg.height = int(_loc1_.bubble.ti.textHeight + 8);
            _loc1_.bubble.y = _loc1_.pname.y - _loc1_.bubble.bg.height - 4;
            _loc1_.bubble.bg.x = 0 - _loc1_.bubble.bg.width / 2;
            _loc1_.bubble.arrow.y = _loc1_.bubble.bg.y + _loc1_.bubble.bg.height - 2;
            _loc1_.bubble.visible = true;
            _loc1_.bubble.alpha = 100;
            if(_loc1_.kv == null)
            {
               _loc1_.kv = new Killvis();
               _loc1_.kv.kill(_loc1_.bubble,3000);
            }
            else
            {
               _loc1_.kv.resetkill();
            }
         }
      }

      public function profanityCheck(param1:String) : Object
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         var _loc3_:Object = {
            "code":0,
            "term":"",
            "index":-1,
            "indeces":[]
         };
         _loc1_ = " " + this.cleanStr(param1.toLowerCase()) + " ";
         _loc1_ = this.r.stripMarks(_loc1_);
         _loc1_ = this.r.stripDuplicateVowels(_loc1_);
         _loc2_ = 0;
         while(_loc2_ < this.profanityA.length)
         {
            _loc3_.index = _loc1_.indexOf(" " + this.profanityA[_loc2_] + " ");
            if(_loc3_.index > -1)
            {
               _loc3_.term = this.profanityA[_loc2_];
               _loc3_.code = 1;
               return _loc3_;
            }
            _loc2_++;
         }
         _loc1_ = this.r.stripDuplicateVowels(this.cleanStr(param1.toLowerCase()));
         _loc1_ = this.r.stripWhiteStrict(_loc1_);
         _loc2_ = 0;
         while(_loc2_ < this.profanityB.length)
         {
            _loc3_.index = _loc1_.indexOf(this.profanityB[_loc2_]);
            if(_loc3_.index > -1)
            {
               _loc3_.term = this.profanityB[_loc2_];
               _loc3_.code = 2;
               return _loc3_;
            }
            _loc2_++;
         }
         _loc1_ = this.r.stripDuplicateVowels(this.cleanStr(param1.toLowerCase()));
         _loc1_ = this.r.stripWhiteStrictB(_loc1_);
         _loc2_ = 0;
         while(_loc2_ < this.profanityB.length)
         {
            _loc3_.index = _loc1_.indexOf(this.profanityB[_loc2_]);
            if(_loc3_.index > -1)
            {
               _loc3_.term = this.profanityB[_loc2_];
               _loc3_.code = 2;
               return _loc3_;
            }
            _loc2_++;
         }
         var _loc4_:Array = [];
         var _loc5_:String = "";
         var _loc6_:int = 0;
         while(_loc6_ < param1.length)
         {
            if(legalCharsStrict.indexOf(param1.charAt(_loc6_)) > -1)
            {
               if(_loc5_.length == 0 || param1.charAt(_loc6_) != _loc5_.charAt(_loc5_.length - 1))
               {
                  _loc5_ += param1.charAt(_loc6_);
                  _loc4_.push(_loc6_);
               }
            }
            _loc6_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.profanityC.length)
         {
            _loc3_.index = _loc5_.indexOf(this.profanityC[_loc2_]);
            if(_loc3_.index > -1)
            {
               _loc3_.code = 3;
               _loc3_.indeces.push(_loc4_[_loc3_.index]);
               _loc3_.indeces.push(_loc4_[_loc3_.index] + this.profanityC[_loc2_].length - 1);
            }
            _loc2_++;
         }
         return _loc3_;
      }

      public function submitMsg(param1:String, param2:*, param3:*, param4:Boolean = false) : *
      {
         var i:int;
         var str:*;
         var tuo:* = undefined;
         var uName:String = null;
         var rmId:int = 0;
         var tuoNm:String = null;
         var parta:* = undefined;
         var partb:String = null;
         var multiO:Object = null;
         var strPassword:* = undefined;
         var uoData:* = undefined;
         var modal:* = undefined;
         var modalO:* = undefined;
         var strA:String = null;
         var ei:int = 0;
         var xtArr:* = undefined;
         var cmd:* = undefined;
         var params:* = undefined;
         var paramStr:* = undefined;
         var s:* = undefined;
         var bAch:* = undefined;
         var uVars:* = undefined;
         var isCellOK:Boolean = false;
         var cell:* = undefined;
         var avt:* = undefined;
         var guildName:String = null;
         var strMap:String = null;
         var m:uint = 0;
         var emStr:* = undefined;
         var index:int = 0;
         var myAvatar:Avatar = null;
         var profanityResult:Object = null;
         var iDiff:Number = NaN;
         var iHrs:int = 0;
         var iMins:int = 0;
         var msg:String = param1;
         var typ:* = param2;
         var unm:* = param3;
         var isMulti:Boolean = param4;
         msg = this.cleanChars(msg);
         var msgOK:Boolean = true;
         var warningModal:Boolean = true;
         var strEmail:String = null;
         if(Game.loginInfo.strPassword != null)
         {
            strPassword = Game.loginInfo.strPassword.toLowerCase();
            if(msg.toLowerCase().indexOf(strPassword) > -1)
            {
               msgOK = false;
            }
         }
         if(this.r.world != null && this.r.world.myAvatar != null)
         {
            if(this.r.world.myAvatar.items == null || this.r.world.myAvatar.items.length < 1)
            {
               msgOK = false;
               warningModal = false;
               this.pushMsg("warning","Character is still being loaded, please wait a moment.","SERVER","",0);
            }
            if(this.r.world.myAvatar.objData != null)
            {
               uoData = this.r.world.myAvatar.objData;
               if(uoData.strEmail != null)
               {
                  strEmail = uoData.strEmail.toLowerCase();
               }
               if(strEmail != null && strEmail.length > 5)
               {
                  if(msg.toLowerCase().indexOf(strEmail) > -1)
                  {
                     msgOK = false;
                  }
               }
            }
         }
         if(!msgOK && warningModal)
         {
            modal = new ModalMC();
            modalO = {};
            modalO.strBody = "Never give your password or email to anyone. Please note that AQWorlds staff will never ask for your password or email. We do not need that information to look up your account.";
            modalO.callback = null;
            modalO.btns = "mono";
            this.r.ui.ModalStack.addChild(modal);
            modal.init(modalO);
            strA = "";
            ei = 0;
            if(strEmail != null)
            {
               if(msg.indexOf(strEmail) > -1)
               {
                  ei = 0;
                  while(ei < strEmail.length)
                  {
                     strA += ei == 0 ? strEmail.charAt(0) : "*";
                     ei++;
                  }
                  msg = msg.split(strEmail).join(strA);
               }
            }
            ei = 0;
            strA = "";
            if(msg.indexOf(strPassword) > -1)
            {
               ei = 0;
               while(ei < strPassword.length)
               {
                  strA += ei == 0 ? strPassword.charAt(0) : "*";
                  ei++;
               }
               msg = msg.split(strPassword).join(strA);
            }
            this.pushMsg("warning",msg,"SERVER","",0);
            this.closeMsgEntry();
            return;
         }
         i = 0;
         str = this.r.stripWhite(msg);
         if(str.length)
         {
            xtArr = [];
            cmd = "";
            if(msg.substr(0,1) == "/")
            {
               params = msg.substr(1).split(" ");
               paramStr = params[0].toLowerCase();
               switch(paramStr)
               {
                  case "qv":
                     if(Game.objLogin.iAccess >= 30)
                     {
                        if(isNaN(parseInt(params[1])))
                        {
                           break;
                        }
                        this.pushMsg("server","QV " + params[1] + ": " + rootClass.world.getQuestValue(parseInt(params[1])),"SERVER","",0);
                     }
                     break;
                  case "debug":
                     if(Game.objLogin.iAccess >= 30)
                     {
                        optionHandler.cmd(rootClass,"@ Debugger");
                     }
                     break;
                  case "captest":
                     if(this.r.world.myAvatar.isStaff())
                     {
                        this.r.sfc.sendString(msg.substr(msg.indexOf(" ") + 1));
                        this.pushMsg("server","Sent " + msg.substr(msg.indexOf(" ") + 1),"SERVER","",0);
                     }
                     break;
                  case "multi":
                     msg = "/" + msg.substr(7);
                     this.submitMsg(msg,typ,unm,true);
                     return;
                  case "reload":
                     cmd = null;
                     if(this.r.world.myAvatar.isStaff())
                     {
                        this.r.world.reloadCurrentMap();
                     }
                     break;
                  case "cell":
                     cmd = null;
                     if(this.r.world.myAvatar.objData.intAccessLevel >= 40)
                     {
                        if(params.length > 1)
                        {
                           parta = params[1];
                        }
                        else
                        {
                           parta = "none";
                        }
                        if(params.length > 2)
                        {
                           partb = params[2];
                        }
                        else
                        {
                           partb = "none";
                        }
                        isCellOK = false;
                        for each(cell in this.r.world.map.currentScene.labels)
                        {
                           if(cell.name == parta)
                           {
                              isCellOK = true;
                              break;
                           }
                        }
                        if(isCellOK)
                        {
                           this.r.world.moveToCell(parta,partb);
                        }
                        else
                        {
                           this.r.chatF.pushMsg("warning","Frame \'" + parta + "\' does not exist.","SERVER","",0);
                        }
                     }
                     break;
                  case "shop":
                     cmd = null;
                     if(this.r.world.myAvatar.objData.intAccessLevel >= 40)
                     {
                        if(params.length > 1)
                        {
                           parta = int(params[1]);
                        }
                        else
                        {
                           parta = 1;
                        }
                        this.r.world.sendLoadShopRequest(parta);
                     }
                     break;
                  case "sound":
                     cmd = null;
                     if(typeof params[1] != "undefined" && params[1].length > 0)
                     {
                        if(params[1] == "off")
                        {
                           this.r.mixer.bSoundOn = false;
                        }
                        else if(params[1] == "on")
                        {
                           this.r.mixer.bSoundOn = true;
                        }
                     }
                     break;
                  case "ignore":
                     cmd = null;
                     if(typeof params[1] != "undefined" && params[1].length > 0)
                     {
                        tuoNm = params.slice(1).join(" ");
                        if(tuoNm.toLowerCase() != this.r.sfc.myUserName)
                        {
                           cmd = "cmd";
                           this.ignore(tuoNm);
                           msg = "You are now ignoring user " + tuoNm;
                           this.pushMsg("server",msg,"SERVER","",0);
                        }
                        else
                        {
                           msg = "You cannot ignore yourself!";
                           this.pushMsg("warning",msg,"SERVER","",0);
                        }
                     }
                     break;
                  case "unignore":
                     cmd = null;
                     if(typeof params[1] != "undefined" && params[1].length > 0)
                     {
                        tuoNm = params.slice(1).join(" ");
                        cmd = "cmd";
                        this.unignore(tuoNm);
                        msg = "User " + tuoNm + " is no longer being ignored";
                        this.pushMsg("server",msg,"SERVER","",0);
                     }
                     break;
                  case "ignoreclear":
                     cmd = null;
                     ignoreList.data.users = [];
                     this.pushMsg("warning","Ignore List Cleared!","SERVER","",0);
                     this.r.sfc.sendXtMessage("zm","cmd",["ignoreList","$clearAll"],"str",1);
                     break;
                  case "report":
                  case "reportlang":
                     cmd = null;
                     if(typeof params[1] != "undefined" && params[1].length > 0)
                     {
                        tuoNm = params.slice(1).join(" ");
                        this.r.ui.mcPopup.fOpen("Report",{"unm":tuoNm});
                     }
                     break;
                  case "reporthack":
                     cmd = null;
                     if(typeof params[1] != "undefined" && params[1].length > 0)
                     {
                        parta = params.split(":")[0];
                        partb = params.split(":")[1];
                        tuoNm = parta.slice(1).join(" ");
                        cmd = "cmd";
                        xtArr.push("reporthack");
                        xtArr.push(tuoNm);
                        xtArr.push(partb);
                     }
                     break;
                  case "modon":
                  case "modoff":
                     cmd = "cmd";
                     xtArr.push(params[0]);
                     break;
                  case "getinfo":
                     if(typeof params[1] != "undefined" && params[1].length > 0)
                     {
                        tuoNm = params.slice(1).join(" ");
                        cmd = "cmd";
                        xtArr.push(params[0]);
                        xtArr.push(tuoNm);
                     }
                     break;
                  case "size":
                     cmd = "cmd";
                     xtArr.push(params[0]);
                  case "getroomname":
                     if(typeof params[1] != "undefined" && params[1].length > 0)
                     {
                        cmd = "cmd";
                        xtArr.push(params[0]);
                        xtArr.push(params[1]);
                     }
                     break;
                  case "event":
                     if(params.length > 2)
                     {
                        cmd = "cmd";
                        xtArr.push(params[0]);
                        xtArr.push(params[1]);
                        xtArr.push(params.slice(2).join(" "));
                     }
                     break;
                  case "tfer":
                     if(typeof params[1] != "undefined" && params[1].length > 0 && typeof params[2] != "undefined" && params[2].length > 0)
                     {
                        cmd = "cmd";
                        xtArr.push(params[0]);
                        xtArr.push(params[1]);
                        xtArr.push(params[2]);
                     }
                     break;
                  case "guild":
                     this.r.world.showGuildList();
                     break;
                  case "guildInvite":
                  case "gi":
                     cmd = null;
                     if(typeof params[1] != "undefined" && params[1].length > 0)
                     {
                        tuoNm = params.slice(1).join(" ");
                        this.r.world.guildInvite(tuoNm);
                     }
                     break;
                  case "guildremove":
                  case "gr":
                     cmd = null;
                     if(typeof params[1] != "undefined" && params[1].length > 0)
                     {
                        tuoNm = params.slice(1).join(" ");
                        avt = this.r.world.getAvatarByUserName(tuoNm);
                        if(this.r.world.myAvatar.objData.guildRank >= 2 || Boolean(avt.isMyAvatar))
                        {
                           modal = new ModalMC();
                           modalO = {};
                           modalO.strBody = "Do you want to remove " + tuoNm + " from the guild?";
                           modalO.callback = this.r.world.guildRemove;
                           modalO.params = {"userName":tuoNm};
                           modalO.btns = "dual";
                           this.r.ui.ModalStack.addChild(modal);
                           modal.init(modalO);
                        }
                     }
                     break;
                  case "guildPromote":
                  case "gp":
                     cmd = null;
                     if(this.r.world.myAvatar.objData.guildRank >= 2)
                     {
                        if(typeof params[1] != "undefined" && params[1].length > 0)
                        {
                           tuoNm = params.slice(1).join(" ");
                           this.r.world.guildPromote(tuoNm);
                        }
                     }
                     break;
                  case "guildDemote":
                  case "gd":
                     cmd = null;
                     if(this.r.world.myAvatar.objData.guildRank >= 2)
                     {
                        if(typeof params[1] != "undefined" && params[1].length > 0)
                        {
                           tuoNm = params.slice(1).join(" ");
                           this.r.world.guildDemote(tuoNm);
                        }
                     }
                     break;
                  case "motd":
                     if(msg.length == 5)
                     {
                        if(this.r.world.myAvatar.objData.guild != null)
                        {
                           if(this.r.world.myAvatar.objData.guild.MOTD != null && String(this.r.world.myAvatar.objData.guild.MOTD) != "undefined")
                           {
                              this.pushMsg("guild","Message of the day: " + String(this.r.world.myAvatar.objData.guild.MOTD),"SERVER","",0);
                           }
                           else
                           {
                              this.pushMsg("guild","No Message of the day has been set.","SERVER","",0);
                           }
                        }
                     }
                     else
                     {
                        this.r.world.setGuildMOTD(msg.substr(5));
                     }
                     break;
                  case "gc":
                  case "guildcreate":
                     if(this.r.world.myAvatar.isUpgraded())
                     {
                        if(params[1].length > 0)
                        {
                           guildName = params[1];
                           i = 2;
                           while(i < params.length)
                           {
                              guildName = guildName + " " + params[i];
                              i++;
                           }
                           if(guildName.length <= 25)
                           {
                              modal = new ModalMC();
                              modalO = {};
                              modalO.strBody = "Do you want to create the guild " + guildName + "?";
                              modalO.callback = this.r.world.createGuild;
                              modalO.params = {"guildName":guildName};
                              modalO.btns = "dual";
                              this.r.ui.ModalStack.addChild(modal);
                              modal.init(modalO);
                           }
                           else
                           {
                              this.r.chatF.pushMsg("server","Guild names must be 25 characters or less.","SERVER","",0);
                           }
                        }
                        else
                        {
                           this.r.chatF.pushMsg("server","Please specify a name for your guild.","SERVER","",0);
                        }
                     }
                     else
                     {
                        this.r.chatF.pushMsg("server","Only members may create guilds.","SERVER","",0);
                     }
                     break;
                  case "renameGuild":
                  case "rg":
                     if(this.r.world.myAvatar.objData.guildRank == 3)
                     {
                        if(this.r.world.myAvatar.objData.intCoins >= 1000)
                        {
                           if(params[1].length > 0)
                           {
                              guildName = params[1];
                              i = 2;
                              while(i < params.length)
                              {
                                 guildName = String(guildName) + " " + String(params[i]);
                                 i++;
                              }
                              if(guildName.length <= 25)
                              {
                                 modal = new ModalMC();
                                 modalO = {};
                                 modalO.strBody = "Do you want to rename the guild to " + guildName + "? This will cost 1000 ACs.";
                                 modalO.callback = this.r.world.renameGuild;
                                 modalO.params = {"guildName":guildName};
                                 modalO.btns = "dual";
                                 this.r.ui.ModalStack.addChild(modal);
                                 modal.init(modalO);
                              }
                              else
                              {
                                 this.r.chatF.pushMsg("server","Guild names must be 25 characters or less.","SERVER","",0);
                              }
                           }
                           else
                           {
                              this.r.chatF.pushMsg("server","Please specify a name for your guild.","SERVER","",0);
                           }
                        }
                        else
                        {
                           this.r.chatF.pushMsg("server","You do not have enough ACs.","SERVER","",0);
                        }
                     }
                     break;
                  case "addquest":
                  case "removequest":
                  case "forcestart":
                  case "forcestop":
                     if(typeof params[1] != "undefined" && params[1].length > 0)
                     {
                        try
                        {
                           this.r.sfc.sendXtMessage("zm","dynamic",[paramStr,params[1],params[2]],"str",1);
                        }
                        catch(e:*)
                        {
                           r.sfc.sendXtMessage("zm","dynamic",[paramStr,params[1]],"str",1);
                        }
                     }
                     break;
                  case "guildreset":
                     this.r.sfc.sendXtMessage("zm","guild",["guildreset"],"str",1);
                     break;
                  case "yuki":
                     rmId = int(chn.cur.rid);
                     cmd = "message";
                     msg = this.cleanStr(msg,false,true);
                     xtArr.push(msg.substring(msg.indexOf("//yuki ") + 6,msg.length));
                     xtArr.push(chn.cur.str);
                     xtArr.push("yuki");
                     break;
                  case "ginv":
                     cmd = null;
                     s = String(params[1]);
                     i = 2;
                     while(i < params.length)
                     {
                        s = s + " " + String(params[i]);
                        i++;
                     }
                     this.r.sfc.sendXtMessage("zm","guild",["gi",s],"str",1);
                     break;
                  case "invite":
                  case "pi":
                     cmd = null;
                     if(typeof params[1] != "undefined" && params[1].length > 0)
                     {
                        tuoNm = params.slice(1).join(" ");
                        if(!this.r.world.isPartyFull() && !this.r.world.isPartyMember(tuoNm))
                        {
                           this.r.world.partyInvite(tuoNm);
                        }
                     }
                     break;
                  case "ps":
                     cmd = null;
                     if(typeof params[1] != "undefined" && params[1].length > 0)
                     {
                        tuoNm = params.slice(1).join(" ");
                        this.r.world.partySummon(tuoNm);
                     }
                     break;
                  case "pk":
                     cmd = null;
                     if(typeof params[1] != "undefined" && params[1].length > 0)
                     {
                        tuoNm = params.slice(1).join(" ");
                        this.r.world.partyKick(tuoNm);
                     }
                     break;
                  case "duel":
                     cmd = null;
                     if(typeof params[1] != "undefined" && params[1].length > 0)
                     {
                        tuoNm = params.slice(1).join(" ");
                        this.r.world.sendDuelInvite(tuoNm);
                     }
                     break;
                  case "friends":
                     cmd = null;
                     this.r.world.showFriendsList();
                     break;
                  case "friend":
                     if(typeof params[1] != "undefined" && params[1].length > 0)
                     {
                        tuoNm = params.slice(1).join(" ");
                        if(tuoNm.toLowerCase() != this.r.sfc.myUserName)
                        {
                           this.r.world.requestFriend(tuoNm);
                        }
                     }
                     break;
                  case "modban":
                     if(typeof params[1] != "undefined" && params[1].length > 0)
                     {
                        cmd = "cmd";
                        tuoNm = params.slice(1).join(" ");
                        xtArr.push(params[0]);
                        xtArr.push(tuoNm);
                        xtArr.push(24);
                     }
                     break;
                  case "join":
                     if(typeof params[1] != "undefined" && params[1].length > 0 && this.r.world.uoTree[this.r.sfc.myUserName].intState != 0 && Boolean(this.r.world.coolDown("tfer")))
                     {
                        this.r.world.returnInfo = null;
                        cmd = "cmd";
                        uName = this.r.sfc.myUserName;
                        strMap = params[1];
                        if(params.length > 2)
                        {
                           m = 2;
                           while(m < params.length)
                           {
                              strMap = strMap + " " + params[m];
                              m++;
                           }
                        }
                        xtArr.push("tfer");
                        xtArr.push(this.r.sfc.myUserName);
                        xtArr.push(strMap);
                     }
                     break;
                  case "roomid":
                     cmd = "cmd";
                     xtArr.push("roomID");
                     xtArr.push(this.r.sfc.myUserName);
                     xtArr.push(params[1]);
                     break;
                  case "house":
                     cmd = null;
                     if(params[1] == null)
                     {
                        tuoNm = this.r.sfc.myUserName;
                     }
                     else
                     {
                        tuoNm = params.slice(1).join(" ");
                     }
                     this.r.world.gotoHouse(tuoNm);
                     break;
                  case "kick":
                  case "ipkick":
                  case "ipunmute":
                  case "unmute":
                  case "freeze":
                  case "unfreeze":
                  case "watch":
                  case "unwatch":
                     if(typeof params[1] != "undefined" && params[1].length > 0)
                     {
                        cmd = "cmd";
                        tuoNm = params.slice(1).join(" ");
                        xtArr.push(params[0]);
                        xtArr.push(tuoNm);
                     }
                     break;
                  case "mute":
                  case "ban":
                  case "ipmute":
                     if(Boolean(this.r.world.myAvatar.isStaff()) && Boolean(typeof params[1] != "undefined") && params[1].length > 0)
                     {
                        cmd = "cmd";
                        tuoNm = params.slice(2).join(" ");
                        xtArr.push(params[0]);
                        xtArr.push(params[1]);
                        xtArr.push(tuoNm);
                     }
                     break;
                  case "goto":
                     if(typeof params[1] != "undefined" && params[1].length > 0)
                     {
                        cmd = null;
                        this.r.world.goto(params.slice(1).join(" "));
                     }
                     break;
                  case "pull":
                     if(typeof params[1] != "undefined" && params[1].length > 0)
                     {
                        cmd = null;
                        this.r.world.pull(params.slice(1).join(" "));
                     }
                     break;
                  case "clear":
                  case "bonus":
                  case "boost":
                     if(params.length > 1)
                     {
                        cmd = "cmd";
                        i = 0;
                        while(i < params.length)
                        {
                           xtArr.push(params[i]);
                           i++;
                        }
                     }
                     break;
                  case "frostreset":
                     cmd = "cmd";
                     xtArr.push("frostreset");
                     break;
                  case "queue":
                     cmd = "cmd";
                     xtArr.push(params[0]);
                     break;
                  case "killmap":
                     if(typeof params[1] != "undefined" && params[1].length > 0)
                     {
                        cmd = "cmd";
                        xtArr.push(params[0]);
                        xtArr.push(params[1]);
                     }
                     break;
                  case "item":
                     if(typeof params[1] != "undefined" && params[1].length > 0)
                     {
                        cmd = "cmd";
                        xtArr.push(params[0]);
                        xtArr.push(params[1]);
                        xtArr.push(params[2]);
                     }
                     break;
                  case "combat":
                     cmd = "cmd";
                     xtArr.push(params[0]);
                     xtArr.push(params[1]);
                     break;
                  case "addrep":
                  case "addxp":
                  case "addv":
                  case "hp":
                  case "level":
                  case "getevents":
                  case "getevent":
                     if(typeof params[1] != "undefined" && params[1].length > 0)
                     {
                        cmd = "cmd";
                        xtArr.push(params[0]);
                        xtArr.push(params[1]);
                     }
                     break;
                  case "datadump":
                  case "monitor":
                  case "resetevents":
                  case "resetlogins":
                  case "resetgrove":
                  case "resettimes":
                  case "getlogins":
                  case "gettimes":
                  case "clock":
                  case "whitelist":
                     cmd = "cmd";
                     i = 0;
                     while(i < params.length)
                     {
                        xtArr.push(params[i]);
                        i++;
                     }
                     break;
                  case "getbreakdown":
                     cmd = "cmd";
                     xtArr.push(params[0]);
                     break;
                  case "adminyell":
                  case "iay":
                     if(typeof params[1] != "undefined" && params[1].length > 0)
                     {
                        cmd = "cmd";
                        xtArr.push(params[0]);
                        msg = params.slice(1).join(" ");
                        msg = this.cleanStr(msg,false,true);
                        xtArr.push(msg);
                     }
                     break;
                  case "iteratortest":
                     cmd = "cmd";
                     xtArr.push(params[0]);
                     break;
                  case "fps":
                     this.r.world.toggleFPS();
                     break;
                  case "mod":
                     cmd = "cmd";
                     xtArr.push(params[0]);
                     break;
                  case "pmoff":
                     cmd = "cmd";
                     xtArr.push(params[0]);
                     xtArr.push(msg.substr(7));
                     break;
                  case "pmon":
                  case "partyon":
                  case "partyoff":
                  case "chaton":
                  case "chatoff":
                  case "friendon":
                  case "friendoff":
                  case "waron":
                  case "waroff":
                  case "kickall":
                  case "restart":
                  case "restartnow":
                  case "shutdown":
                  case "shutdownnow":
                  case "empty":
                     cmd = "cmd";
                     xtArr.push(params[0]);
                     break;
                  case "roll":
                     cmd = "util";
                     xtArr.push(params[0]);
                     break;
                  case "geta":
                     if(Boolean(this.r.world.myAvatar.isStaff()) && params.length == 3)
                     {
                        this.pushMsg("warning","geta " + params[1] + "," + params[2] + ": " + this.r.world.getAchievement(params[1],params[2]),"SERVER","",0);
                     }
                     break;
                  case "seta":
                     if(Boolean(this.r.world.myAvatar.isStaff()) && params.length == 4)
                     {
                        this.r.world.setAchievement(params[1],params[2],params[3]);
                     }
                     break;
                  case "queststring":
                     if(this.r.world.myAvatar.isStaff())
                     {
                        this.r.world.loadQuestStringData();
                        cmd = "cmd";
                        i = 0;
                        while(i < params.length)
                        {
                           xtArr.push(params[i]);
                           i++;
                        }
                     }
                     break;
                  case "e":
                  case "me":
                  case "em":
                     if(typeof params[1] != "undefined" && params[1].length > 0)
                     {
                        emStr = params.slice(1).join(" ");
                        emStr = this.cleanStr(emStr,false,true);
                        trace("[Chat2] em send: " + emStr);
                        if(emStr.length > 0)
                        {
                           rmId = int(chn.cur.rid);
                           cmd = "em";
                           xtArr.push(emStr);
                           xtArr.push(chn.event.str);
                        }
                     }
                     break;
                  case "who":
                     cmd = "cmd";
                     xtArr.push(params[0]);
                     if(typeof params[1] != "undefined" && params[1].length > 0)
                     {
                        xtArr.push(params.splice(1).join(" "));
                     }
                     break;
                  case "afk":
                     cmd = null;
                     this.r.world.afkToggle();
                     break;
                  case "rest":
                     this.r.world.rest();
                     break;
                  case "repairavatars":
                     cmd = null;
                     this.r.world.repairAvatars();
                     break;
                  case "samba":
                     bAch = this.r.world.getAchievement("ia0",11);
                     if(!bAch)
                     {
                        this.pushMsg("warning","You must learn this dance from Samba in Bloodtusk Ravine.","SERVER","",0);
                        break;
                     }
                     if(!this.r.world.myAvatar.isUpgraded())
                     {
                        this.pushMsg("warning","Requires membership to use this emote.","SERVER","",0);
                        break;
                     }
                  case "danceweapon":
                     if(!this.r.world.myAvatar.isUpgraded())
                     {
                        this.pushMsg("warning","Requires membership to use this emote.","SERVER","",0);
                        break;
                     }
                  case "useweapon":
                     if(!this.r.world.myAvatar.isUpgraded())
                     {
                        this.pushMsg("warning","Requires membership to use this emote.","SERVER","",0);
                        break;
                     }
                  case "powerup":
                  case "kneel":
                  case "jumpcheer":
                  case "salute2":
                  case "cry2":
                  case "spar":
                  case "stepdance":
                  case "headbang":
                  case "dazed":
                     if(!this.r.world.myAvatar.isUpgraded())
                     {
                        this.pushMsg("warning","Requires membership to use this emote.","SERVER","",0);
                        break;
                     }
                  case "dance":
                  case "laugh":
                  case "lol":
                  case "point":
                  case "use":
                  case "fart":
                  case "backflip":
                  case "sleep":
                  case "jump":
                  case "punt":
                  case "dance2":
                  case "swordplay":
                  case "feign":
                  case "wave":
                  case "bow":
                  case "cry":
                  case "unsheath":
                  case "cheer":
                  case "stern":
                  case "salute":
                  case "airguitar":
                  case "facepalm":
                     uVars = {};
                     cmd = uVars.typ = "emotea";
                     uVars.strEmote = paramStr;
                     if(uVars.strEmote == "lol")
                     {
                        uVars.strEmote = "laugh";
                     }
                     uVars.strChar = params[1];
                     break;
                  default:
                     if(unm == "iterator" || Boolean(this.r.world.myAvatar.isStaff()))
                     {
                        cmd = "cmd";
                        index = 0;
                        while(index < params.length)
                        {
                           xtArr.push(params[index]);
                           index++;
                        }
                     }
               }
               if(!this.r.serialCmdMode)
               {
                  if(this.cmdHistory.indexOf(msg) == -1)
                  {
                     this.cmdHistory.push(msg);
                     if(this.cmdHistory.length > 10)
                     {
                        this.cmdHistory.shift();
                     }
                     this.rebuildHistory();
                  }
               }
            }
            else if(typ != "whisper")
            {
               rmId = int(chn.cur.rid);
               cmd = "message";
               msg = this.cleanStr(msg,false,true);
               xtArr.push(msg);
               xtArr.push(chn.cur.str);
            }
            else
            {
               rmId = 1;
               cmd = "whisper";
               msg = this.cleanStr(msg,false,true);
               xtArr.push(msg);
               xtArr.push(unm);
            }
            if(cmd == "emotea")
            {
               this.r.world.myAvatar.pMC.mcChar.gotoAndPlay(this.r.strToProperCase(uVars.strEmote));
               this.r.sfc.sendXtMessage("zm",cmd,[uVars.strEmote],"str",1);
            }
            else if(cmd == "mod" || cmd == "cmd")
            {
               if(xtArr.length)
               {
                  this.r.sfc.sendXtMessage("zm",cmd,xtArr,"str",1);
               }
            }
            else if(cmd != "simple")
            {
               if(!(cmd == null || xtArr.length < 1))
               {
                  if(!this.r.serialCmdMode)
                  {
                     this.r.world.afkPostpone();
                     myAvatar = this.r.world.myAvatar;
                     profanityResult = {};
                     profanityResult = this.nuProfanityCheck(this.cleanStr(xtArr[0]));
                     if(this.iChat == 0)
                     {
                        this.pushMsg("warning","This server only allows canned chat.","SERVER","",0);
                     }
                     else if(this.iChat == 1 && !this.r.world.myAvatar.hasUpgraded() && !this.r.world.myAvatar.isVerified() && !this.r.world.myAvatar.isStaff())
                     {
                        this.pushMsg("warning","Chat is a members-only feature at this time.","SERVER","",0);
                     }
                     else if(!this.r.world.myAvatar.hasUpgraded() && !this.r.world.myAvatar.isVerified() && !this.r.world.myAvatar.isStaff() && !this.r.world.myAvatar.isEmailVerified())
                     {
                        if(int(this.r.world.myAvatar.objData.iAge) < 13)
                        {
                           this.pushMsg("warning","Upgrade is required to chat in this server.","SERVER","",0);
                        }
                        else
                        {
                           this.pushMsg("warning","Confirm your email at https://account.aq.com/ to protect your account and enable chat.","SERVER","",0);
                        }
                     }
                     else if(myAvatar.objData.bPermaMute == 1)
                     {
                        this.pushMsg("warning","You are mute! Chat privileges have been permanently revoked.","SERVER","",0);
                     }
                     else if(myAvatar.objData.dMutedTill != null && myAvatar.objData.dMutedTill.getTime() > this.r.date_server.getTime())
                     {
                        iDiff = (myAvatar.objData.dMutedTill.getTime() - this.r.date_server.getTime()) / 1000;
                        iHrs = iDiff / (60 * 60);
                        iMins = (iDiff - iHrs * 60 * 60) / 60;
                        this.pushMsg("warning","You are mute! Chat privileges have been revoked for next " + iHrs + " h " + iMins + " m!","SERVER","",0);
                     }
                     else if(this.isUnsendable(msg))
                     {
                        this.pushMsg("warning","Please do not send messages that may contain private information, such as an email address.","SERVER","",0);
                     }
                     else if(xtArr[0].length > 0)
                     {
                        if(Boolean(profanityResult.code) && Boolean(rootClass.uoPref.bProf))
                        {
                           xtArr[0] = this.maskStringBetween(xtArr[0],profanityResult.indeces);
                        }
                        if(!rootClass.uoPref.bProf)
                        {
                           profanityResult = this.nuProfanityCheck(this.cleanStr(xtArr[0]),true);
                           if(profanityResult.code)
                           {
                              xtArr[0] = this.maskStringBetween(xtArr[0],profanityResult.indeces);
                           }
                        }
                        xtArr[0] = this.forceRemove(xtArr[0]);
                        this.r.sfc.sendXtMessage("zm",cmd,xtArr,"str",rmId);
                        if(cmd == "whisper" && pmMode != 2)
                        {
                           this.formatMsgEntry("");
                           this.updateMsgEntry();
                        }
                     }
                  }
                  else
                  {
                     this.r.sfc.sendXtMessage("zm",cmd,xtArr,"str",rmId);
                  }
               }
            }
         }
         if(!this.r.serialCmdMode)
         {
            this.closeMsgEntry();
         }
      }

      override public function isIgnored(param1:String) : Boolean
      {
         return ignoreList.data.users.indexOf(param1.toLowerCase()) >= 0;
      }

      public function ignore(param1:String) : void
      {
         var mc:* = undefined;
         var strName:String = param1;
         if(ignoreList.data.users.indexOf(strName.toLowerCase()) == -1)
         {
            ignoreList.data.users.push(strName.toLowerCase());
            try
            {
               ignoreList.flush();
            }
            catch(e:Error)
            {
               trace("[Chat] ERR ignore: ignoreList flush: " + e.message);
            }
            mc = rootClass.world.getAvatarByUserName(strName.toLowerCase());
            if(mc != null)
            {
               mc.pMC.ignore.visible = true;
            }
            rootClass.sfc.sendXtMessage("zm","cmd",["ignoreList",ignoreList.data.users],"str",1);
         }
         try
         {
            if(rootClass.ui.mcOFrame.fData.typ == "userListIgnore")
            {
               rootClass.ui.mcOFrame.update();
            }
         }
         catch(e:Error)
         {
         }
      }

      public function unignore(param1:String) : void
      {
         var mc:*;
         var strName:String = param1;
         var uind:* = ignoreList.data.users.indexOf(strName.toLowerCase());
         while(uind > -1)
         {
            ignoreList.data.users.splice(uind,1);
            uind = ignoreList.data.users.indexOf(strName.toLowerCase());
         }
         try
         {
            ignoreList.flush();
         }
         catch(e:Error)
         {
            trace("[Chat] ERR unignore: ignoreList flush: " + e.message);
         }
         mc = rootClass.world.getAvatarByUserName(strName.toLowerCase());
         if(mc != null)
         {
            mc.pMC.ignore.visible = false;
         }
         rootClass.sfc.sendXtMessage("zm","cmd",["ignoreList",ignoreList.data.users],"str",1);
         try
         {
            if(rootClass.ui.mcOFrame.fData.typ == "userListIgnore")
            {
               rootClass.ui.mcOFrame.update();
            }
         }
         catch(e:Error)
         {
         }
      }

      public function muteMe(param1:int) : void
      {
         var _loc1_:Date = new Date();
         mute.ts = Number(_loc1_.getTime());
         mute.cd = param1;
         mute.timer.delay = param1;
         mute.timer.start();
         this.pushMsg("warning","You have been muted! Chat privileges are temporarily revoked.","SERVER","",0);
      }

      override public function unmuteMe(param1:Event = null) : void
      {
         mute.ts = 0;
         mute.cd = 0;
         mute.timer.reset();
         this.pushMsg("server","You have been unmuted.  Chat privileges are restored.","SERVER","",0);
      }

      public function amIMute() : Boolean
      {
         var _loc1_:Date = null;
         var _loc2_:Number = NaN;
         var _loc3_:Boolean = false;
         if(mute.ts > 0)
         {
            _loc1_ = new Date();
            _loc2_ = _loc1_.getTime();
            if(_loc2_ - mute.ts >= mute.cd)
            {
               mute.ts = 0;
               mute.cd = 0;
            }
            else
            {
               _loc3_ = true;
            }
         }
         return _loc3_;
      }

      public function cleanChars(param1:String) : String
      {
         param1 = param1.replace(regExpMod,"");
         var _loc1_:int = 0;
         while(_loc1_ < param1.length)
         {
            if(legalChars.indexOf(param1.charAt(_loc1_)) < 0)
            {
               param1 = param1.replace(param1.charAt(_loc1_),"?");
            }
            _loc1_++;
         }
         return param1;
      }

      public function strContains(param1:String, param2:Array) : Boolean
      {
         var _loc1_:int = 0;
         while(_loc1_ < param2.length)
         {
            if(param1.indexOf(param2[_loc1_]) > -1)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }

      public function cleanStr(param1:String, param2:Boolean = true, param3:Boolean = false, param4:Boolean = false) : *
      {
         param1 = param1.split("&#").join("");
         if(!param4)
         {
            param1 = param1.split("#038:").join("");
         }
         else
         {
            param1 = param1.split("#038:#").join("");
         }
         if(param3)
         {
            param1 = this.removeHTML(param1);
         }
         if(param1.indexOf("%") > -1)
         {
            param1 = param1.split("%").join("#037:");
         }
         if(param2 && param1.indexOf("#037:") > -1)
         {
            param1 = param1.split("#037:").join("%");
         }
         if(param1.indexOf("&") > -1)
         {
            param1 = param1.split("&").join("#038:");
         }
         if(param2 && param1.indexOf("#038:") > -1)
         {
            param1 = param1.split("#038:").join("&");
         }
         if(param1.indexOf("<") > -1)
         {
            param1 = param1.split("<").join("#060:");
         }
         if(param2 && param1.indexOf("#060:") > -1)
         {
            param1 = param1.split("#060:").join("<");
         }
         if(param1.indexOf(">") > -1)
         {
            param1 = param1.split(">").join("#062:");
         }
         if(param2 && param1.indexOf("#062:") > -1)
         {
            param1 = param1.split("#062:").join(">");
         }
         if(param2)
         {
            param1 = this.removeHTML(param1);
         }
         return param1;
      }

      private function removeHTML(param1:String) : String
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         var _loc3_:String = param1.toLowerCase();
         var _loc4_:String = "" + param1;
         var _loc5_:Array = ["&nbsp;","<br>"];
         for each(_loc2_ in _loc5_)
         {
            while(_loc3_.indexOf(_loc2_) > -1)
            {
               _loc1_ = _loc3_.indexOf(_loc2_);
               _loc3_ = _loc3_.substr(0,_loc1_) + " " + _loc3_.substr(_loc1_ + _loc2_.length,_loc3_.length);
               _loc4_ = _loc4_.substr(0,_loc1_) + " " + _loc4_.substr(_loc1_ + _loc2_.length,_loc4_.length);
            }
         }
         return _loc4_;
      }

      public function isUnsendable(param1:String) : Boolean
      {
         var _loc1_:* = 0;
         while(_loc1_ < unsendable.length)
         {
            if(param1.toLowerCase().indexOf(unsendable[_loc1_]) > -1)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }

      private function getRoomType(param1:*) : *
      {
         if(param1.indexOf("trade") > -1)
         {
            return "trade";
         }
         if(param1.indexOf("party") > -1)
         {
            return "party";
         }
         return "zone";
      }

      public function modWhisperCheck(param1:String) : int
      {
         var _loc1_:String = null;
         var _loc2_:String = rootClass.stripWhiteStrict(this.removeHTML(param1.toLowerCase()));
         for each(_loc1_ in modWhisperCheckList)
         {
            if(_loc2_.indexOf(_loc1_) > -1)
            {
               return 1;
            }
         }
         return 0;
      }

      public function isChannel(param1:String) : Boolean
      {
         var _loc1_:* = undefined;
         for(_loc1_ in chn)
         {
            if(_loc1_.toLowerCase() == param1.toLowerCase())
            {
               return true;
            }
         }
         return false;
      }

      public function formatMsgEntry(param1:*) : *
      {
         this.mci.ncText.setSelection(0,0);
         if(chn.cur != chn.whisper)
         {
            if(chn.cur == chn.zone)
            {
               this.mci.ncPrefix.text = "Chat:";
            }
            else
            {
               this.mci.ncPrefix.text = chn.cur.tag + ": ";
            }
         }
         else if(typeof param1 == "undefined" || param1 == "")
         {
            this.mci.ncPrefix.text = "Chat:";
         }
         else
         {
            pmNm = param1;
            this.mci.ncPrefix.text = "To " + param1 + ":";
         }
      }

      public function updateMsgEntry() : *
      {
         this.mci.ncPrefix.width = this.mci.ncPrefix.textWidth + 1;
         this.mci.ncText.x = this.mci.ncPrefix.x + this.mci.ncPrefix.textWidth + (this.mci.ncPrefix.text.length ? 1 : 0);
         this.mci.ncText.width = this.mci.bsend.x - this.mci.ncText.x - 3;
      }

      internal function openPMsg(param1:*) : *
      {
         pmNm = param1;
         chn.cur = chn.whisper;
         this.openMsgEntry();
      }

      internal function openMsgEntry() : *
      {
         pmI = 0;
         myMsgsI = 0;
         rootClass.stage.focus = null;
         rootClass.stage.focus = this.mci.ncText;
         this.formatMsgEntry(pmNm);
         this.updateMsgEntry();
      }

      internal function closeMsgEntry() : *
      {
         this.mci.ncText.text = "";
         if(pmMode != 2)
         {
            chn.cur = chn.lastPublic;
         }
         rootClass.stage.focus = null;
      }

      private function checkMsgType(param1:Event) : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = this.mci.ncText.text;
         var _loc6_:* = _loc5_.split(" ");
         if(_loc6_.length > 1)
         {
            _loc1_ = _loc6_[0];
            _loc2_ = "";
            if(_loc1_.charAt(0) == "/")
            {
               switch(_loc1_.substr(1))
               {
                  case "1":
                  case "s":
                  case "say":
                     if(chn.zone.act)
                     {
                        chn.cur = chn.zone;
                        chn.lastPublic = chn.zone;
                        this.mci.ncText.text = this.mci.ncText.text.substr(_loc1_.substr(1).length + 2);
                     }
                     this.formatMsgEntry("");
                     this.updateMsgEntry();
                     break;
                  case "2":
                     if(chn.trade.act)
                     {
                        chn.cur = chn.trade;
                        chn.lastPublic = chn.trade;
                        this.mci.ncText.text = this.mci.ncText.text.substr(3);
                     }
                     this.formatMsgEntry("");
                     this.updateMsgEntry();
                     break;
                  case "p":
                     if(chn.party.act)
                     {
                        chn.cur = chn.party;
                        chn.lastPublic = chn.party;
                        this.mci.ncText.text = this.mci.ncText.text.substr(3);
                     }
                     this.formatMsgEntry("");
                     this.updateMsgEntry();
                     break;
                  case "r":
                     if(pmSourceA.length)
                     {
                        pmMode = 1;
                        chn.cur = chn.whisper;
                        this.mci.ncText.text = this.mci.ncText.text.substr(3);
                        this.formatMsgEntry(pmSourceA[0]);
                        this.updateMsgEntry();
                     }
                     break;
                  case "tell":
                  case "w":
                     if(_loc6_.length > 2)
                     {
                        pmMode = 1;
                        chn.cur = chn.whisper;
                        this.mci.ncText.text = this.mci.ncText.text.substr(_loc6_[0].length + _loc6_[1].length + 1);
                        this.formatMsgEntry(_loc6_[1]);
                        this.updateMsgEntry();
                     }
                     break;
                  case "c":
                     pmMode = 2;
                     chn.cur = chn.whisper;
                     this.mci.ncText.text = this.mci.ncText.text.substr(_loc6_[0].length + _loc6_[1].length + 1);
                     this.formatMsgEntry(pmSourceA[0]);
                     this.updateMsgEntry();
                     break;
                  case "g":
                     if(chn.guild.act)
                     {
                        chn.cur = chn.guild;
                        chn.lastPublic = chn.guild;
                        this.mci.ncText.text = this.mci.ncText.text.substr(3);
                     }
                     this.formatMsgEntry("");
                     this.updateMsgEntry();
               }
            }
            if(_loc1_.charAt(0) == ">")
            {
               if(pmSourceA.length)
               {
                  pmMode = 1;
                  chn.cur = chn.whisper;
                  this.mci.ncText.text = this.mci.ncText.text.substr(2);
                  this.formatMsgEntry(pmSourceA[0]);
                  this.updateMsgEntry();
               }
            }
            _loc3_ = [];
            if(_loc5_.indexOf(" > ") > 1 && (_loc5_.indexOf("<") == -1 || _loc5_.indexOf(" > ") < _loc5_.indexOf("<")))
            {
               _loc4_ = _loc5_.split(">");
               while(_loc4_[0].charAt(_loc4_[0].length - 1) == " ")
               {
                  _loc4_[0] = _loc4_[0].substr(0,_loc4_[0].length - 1);
               }
               pmMode = 1;
               chn.cur = chn.whisper;
               this.mci.ncText.text = _loc4_[1];
               this.formatMsgEntry(_loc4_[0]);
               this.updateMsgEntry();
            }
         }
      }
   }
}
