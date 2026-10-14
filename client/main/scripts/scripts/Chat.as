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

   public class Chat
   {

      private static const TOUCH_STEP:Number = 18;

      public var rootClass:*;

      public var iChat:int = 0;

      internal var pmMode:* = 0;

      private var chatArray:Array = [];

      private var t1Arr:* = [];

      private var t2Arr:* = [];

      private var tl:MovieClip;

      private var silentMute:* = 0;

      private var lineLimit:int = 100;

      private var mci:MovieClip;

      public var pmSourceA:* = [];

      public var pmI:int = 0;

      public var pmNm:String = "";

      public var ignoreList:SharedObject = SharedObject.getLocal("ignoreList","/");

      public var mute:* = {
         "ts":0,
         "cd":0,
         "timer":new Timer(0,1)
      };

      public var myMsgs:* = [];

      public var myMsgsI:int = 0;

      public var chn:* = new Object();

      public var emailWarning:String = "WARNING: Never give your email or password to anyone else. Moderators have gold names. If a player does not have a gold name they are NOT a moderator or staff member.";

      public var legalChars:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789~!@#$%^&*_+-=:\"?,./;\'\\|<>() ";

      private var _regexCache:Object = {};

      public var legalCharsStrict:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

      public var markChars:* = "~!@#$%^&*()_+-=:\"<>?,.;\'\\";

      public var strictComparisonChars:* = "~!@#$%^&*()_+-=:\"<>?,.;\'\\ÇüéâäåçêëèïîìÄÅæÆôöòûùÿ֣¥áíóúñ?£ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝß";

      public var strictComparisonCharsB:* = "~!#%^&()_+-=:\"<>?,.;\'\\ÇüéâäåçêëèïîìÄÅæÆôöòûùÿ֣¥áíóúñ?£ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝß";

      public var illegalStrings:* = ["&#","www","http","https","ftp",".com",".c0m",".net",".org",".de",".ru",".sg",".ph",".tk","dotcom","freegold","freecoins","freeadventurecoins","freelevels","freeitems","freeupgrades","gmail","yahoo","hotmail","aol","formfacil","email","password"];

      public var modWhisperCheckList:Array = ["trade","free","acs","member","pass","login","user","imamod","iamamod","i\'mamod","account"];

      public var regExpA:RegExp = /(a{2,})/gi;

      public var regExpE:RegExp = /(e{2,})/gi;

      public var regExpI:RegExp = /(i{2,})/gi;

      public var regExpO:RegExp = /(o{2,})/gi;

      public var regExpU:RegExp = /(u{2,})/gi;

      public var regExpSPACE:RegExp = /(\s{2,})/gi;

      internal var regExpMod:RegExp = /(\(|<)mod(era(t|d)or)?(>|\))/gi;

      public var regExpURL:RegExp = new RegExp("\\bhttps://[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]","gi");

      public var unsendable:* = ["@"];

      private var whichField:* = 0;

      private var msgFields:* = ["t1:","t2:say,zone,trade,moderator"];

      private var drawnA:Array = [];

      private var lineMC:Object = {};

      private var t1Ts:Boolean = false;

      private var tfHeight:int = 126;

      private var t1Shorty:int = -137;

      private var t1Tally:int = -378;

      private var tfdH:int = Math.abs(this.t1Tally - this.t1Shorty);

      public var panelIndex:int = 0;

      private var msgID:int = 0;

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

      private var mcCannedChat:MovieClip;

      public var t:Timer = new Timer(500,1);

      public var windowTimer:Timer = new Timer(60000,1);

      private var touch:TouchScroll;

      private var touchHit:Sprite;

      private var chatPos:Number = 0;

      public var regExpMultiG:RegExp = /(gg{2,})/gi;

      internal var regexEscapes:String = "[]{}()*+?|^$.\\";

      public function Chat()
      {
         super();
         this.chn.cur = {};
         this.chn.lastPublic = {};
         this.chn.xt = "zm";
         this.chn.zone = {};
         this.chn.trade = {};
         this.chn.moderator = {};
         this.chn.warning = {};
         this.chn.server = {};
         this.chn.event = {};
         this.chn.whisper = {};
         this.chn.party = {};
         this.chn.guild = {};
         this.chn.wheel = {};
         this.chn.zone.col = "9CCAFD";
         this.chn.trade.col = "D2FD94";
         this.chn.moderator.col = "FFCC33";
         this.chn.warning.col = "A80000";
         this.chn.server.col = "00FFFF";
         this.chn.event.col = "00FF00";
         this.chn.whisper.col = "FF00FF";
         this.chn.party.col = "00CCFF";
         this.chn.guild.col = "99FF00";
         this.chn.wheel.col = "FFCC33";
         this.chn.zone.str = "zone";
         this.chn.trade.str = "trade";
         this.chn.moderator.str = "moderator";
         this.chn.warning.str = "warning";
         this.chn.server.str = "server";
         this.chn.event.str = "event";
         this.chn.whisper.str = "whisper";
         this.chn.party.str = "party";
         this.chn.guild.str = "guild";
         this.chn.wheel.str = "wheel";
         this.chn.zone.typ = "message";
         this.chn.trade.typ = "message";
         this.chn.moderator.typ = "whisper";
         this.chn.warning.typ = "server";
         this.chn.server.typ = "server";
         this.chn.event.typ = "event";
         this.chn.whisper.typ = "whisper";
         this.chn.party.typ = "message";
         this.chn.guild.typ = "message";
         this.chn.wheel.typ = "whisper";
         this.chn.zone.tag = "";
         this.chn.trade.tag = "";
         this.chn.moderator.tag = "Moderator";
         this.chn.warning.tag = "";
         this.chn.server.tag = "";
         this.chn.whisper.tag = "Whisper";
         this.chn.event.tag = "";
         this.chn.party.tag = "Party";
         this.chn.guild.tag = "Guild";
         this.chn.wheel.tag = "Wheel of Doom";
         this.chn.zone.rid = 0;
         this.chn.trade.rid = 0;
         this.chn.moderator.rid = 0;
         this.chn.warning.rid = 0;
         this.chn.server.rid = 0;
         this.chn.event.rid = 0;
         this.chn.whisper.rid = 0;
         this.chn.party.rid = 32123;
         this.chn.guild.rid = 0;
         this.chn.wheel.rid = 0;
         this.chn.zone.act = 1;
         this.chn.trade.act = 0;
         this.chn.moderator.act = 1;
         this.chn.warning.act = 1;
         this.chn.server.act = 1;
         this.chn.event.act = 1;
         this.chn.whisper.act = 1;
         this.chn.party.act = 0;
         this.chn.guild.act = 0;
         this.chn.wheel.act = 1;
         this.chn.cur = this.chn.zone;
         this.chn.lastPublic = this.chn.cur;
         if(this.ignoreList.data.users == undefined)
         {
            this.ignoreList.data.users = [];
         }
      }

      private function initProfanity() : void
      {
         var _loc1_:String = null;
         var _loc2_:Array = new Array("butt","pron","rape","tits","shi t","shi t");
         var _loc3_:Array = new Array("as5","a5s","a$$","a5$","a$5","as$","fck","fkc","fvk","fuck","fvck","fukk","fvkk","sh!t","sh|t","sh1t","shiz");
         var _loc4_:int = 0;
         while(_loc4_ < this.profanityA.length)
         {
            _loc1_ = this.rootClass.stripWhiteStrict(this.profanityA[_loc4_]);
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

      internal function init() : *
      {
         this.mci = this.rootClass.ui.mcInterface;
         this.chatArray = [];
         this.t1Arr = [];
         this.clearLines();
         this.msgID = 0;
         this.panelIndex = 0;
         this.tfHeight = 126;
         this.t1Shorty = -137;
         this.t1Tally = -378;
         this.tfdH = Math.abs(this.t1Tally - this.t1Shorty);
         this.initProfanity();
         this.mute.timer.addEventListener(TimerEvent.TIMER,this.unmuteMe,false,0,true);
         if(this.mcCannedChat == null)
         {
            this.mcCannedChat = this.initCannedChat(this.xmlCannedOptions.children());
         }
         this.mci.tt.mouseEnabled = false;
         this.tl = this.mci.textLine as MovieClip;
         this.tl.ti.htmlText = "";
         this.tl.ti.autoSize = "left";
         this.tl.visible = false;
         this.mci.bMinMax.buttonMode = true;
         this.mci.bMinMax.a2.visible = false;
         this.mci.bShortTall.buttonMode = true;
         this.mci.bShortTall.a2.visible = false;
         this.mci.te.text = "";
         this.mci.te.visible = false;
         this.mci.tt.text = "";
         this.mci.tt.visible = false;
         this.mci.te.maxChars = 150;
         this.rootClass.fixInputHeight(this.mci.te);
         this.rootClass.fixInputHeight(this.mci.tt);
         this.mci.bCannedChat.removeEventListener(MouseEvent.CLICK,this.onCannedChatClick);
         this.mci.bsend.removeEventListener(MouseEvent.CLICK,this.chat_btnSend);
         this.mci.tebg.removeEventListener(MouseEvent.CLICK,this.chat_tebgClick);
         this.mci.bMinMax.removeEventListener(MouseEvent.CLICK,this.bMinMaxClick);
         this.mci.bMinMax.removeEventListener(MouseEvent.MOUSE_OVER,this.bMinMaxMouseOver);
         this.mci.bMinMax.removeEventListener(MouseEvent.MOUSE_OUT,this.bMinMaxMouseOut);
         this.mci.bShortTall.removeEventListener(MouseEvent.CLICK,this.bShortTallClick);
         this.mci.bShortTall.removeEventListener(MouseEvent.MOUSE_OVER,this.bShortTallMouseOver);
         this.mci.bShortTall.removeEventListener(MouseEvent.MOUSE_OUT,this.bShortTallMouseOut);
         this.rootClass.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.rootClass.key_StageLogin);
         this.rootClass.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.rootClass.key_StageGame);
         this.mci.te.removeEventListener(KeyboardEvent.KEY_DOWN,this.rootClass.key_ChatEntry);
         this.mci.te.removeEventListener(Event.CHANGE,this.checkMsgType);
         this.rootClass.stage.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheelEvent);
         this.mcCannedChat.removeEventListener(MouseEvent.MOUSE_OVER,this.onCannedChatOver);
         this.mcCannedChat.removeEventListener(MouseEvent.MOUSE_OUT,this.onCannedChatOut);
         this.t.removeEventListener(TimerEvent.TIMER,this.closeCannedChatTimer);
         this.windowTimer.removeEventListener(TimerEvent.TIMER,this.timedWindowHide);
         this.mci.bCannedChat.addEventListener(MouseEvent.CLICK,this.onCannedChatClick);
         this.mci.bsend.addEventListener(MouseEvent.CLICK,this.chat_btnSend);
         this.mci.tebg.addEventListener(MouseEvent.CLICK,this.chat_tebgClick);
         this.mci.bMinMax.addEventListener(MouseEvent.CLICK,this.bMinMaxClick);
         this.mci.bMinMax.addEventListener(MouseEvent.MOUSE_OVER,this.bMinMaxMouseOver);
         this.mci.bMinMax.addEventListener(MouseEvent.MOUSE_OUT,this.bMinMaxMouseOut);
         this.mci.bShortTall.addEventListener(MouseEvent.CLICK,this.bShortTallClick);
         this.mci.bShortTall.addEventListener(MouseEvent.MOUSE_OVER,this.bShortTallMouseOver);
         this.mci.bShortTall.addEventListener(MouseEvent.MOUSE_OUT,this.bShortTallMouseOut);
         this.rootClass.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.rootClass.key_StageGame);
         this.mci.te.addEventListener(KeyboardEvent.KEY_DOWN,this.rootClass.key_ChatEntry);
         this.mci.te.addEventListener(Event.CHANGE,this.checkMsgType);
         this.rootClass.stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheelEvent);
         this.rootClass.ui.mouseEnabled = false;
         this.mci.mouseEnabled = false;
         this.mci.t1.mouseEnabled = false;
         this.initTouch();
         this.mci.addChild(this.mcCannedChat);
         this.mcCannedChat.addEventListener(MouseEvent.MOUSE_OVER,this.onCannedChatOver);
         this.mcCannedChat.addEventListener(MouseEvent.MOUSE_OUT,this.onCannedChatOut);
         this.mcCannedChat.y = -this.mcCannedChat.numChildren * 23;
         this.mcCannedChat.visible = false;
         this.t.addEventListener(TimerEvent.TIMER,this.closeCannedChatTimer);
         this.windowTimer.addEventListener(TimerEvent.TIMER,this.timedWindowHide);
      }

      private function timedWindowHide(param1:Event) : void
      {
         this.mci.t1.visible = false;
      }

      private function startWindowTimer() : void
      {
         var _loc1_:MovieClip = this.mci.bMinMax;
         if(this.mci.t1.visible)
         {
         }
      }

      private function bMinMaxMouseOver(param1:MouseEvent) : *
      {
         var _loc1_:MovieClip = param1.currentTarget as MovieClip;
         if(!this.mci.t1.visible)
         {
            this.rootClass.ui.ToolTip.openWith({"str":"Show the chat pane"});
         }
         else
         {
            this.rootClass.ui.ToolTip.openWith({"str":"Hide the chat pane"});
         }
      }

      private function bMinMaxMouseOut(param1:MouseEvent) : *
      {
         var _loc1_:MovieClip = param1.currentTarget as MovieClip;
         this.rootClass.closeToolTip();
      }

      private function bMinMaxClick(param1:MouseEvent) : void
      {
         this.toggleChatPane();
      }

      public function toggleChatPane(param1:Boolean = true) : *
      {
         var _loc1_:MovieClip = this.mci.bMinMax;
         if(!this.mci.t1.visible)
         {
            this.mci.t1.visible = true;
            _loc1_.a1.visible = true;
            _loc1_.a2.visible = false;
            if(param1)
            {
               this.rootClass.ui.ToolTip.openWith({"str":"Hide the chat pane"});
            }
         }
         else
         {
            this.mci.t1.visible = false;
            _loc1_.a1.visible = false;
            _loc1_.a2.visible = true;
            if(param1)
            {
               this.rootClass.ui.ToolTip.openWith({"str":"Show the chat pane"});
            }
         }
      }

      private function bShortTallMouseOver(param1:MouseEvent) : *
      {
         var _loc1_:MovieClip = param1.currentTarget as MovieClip;
         if(this.mci.t1.y == this.t1Shorty)
         {
            this.rootClass.ui.ToolTip.openWith({"str":"Set the chat pane to full height"});
         }
         else
         {
            this.rootClass.ui.ToolTip.openWith({"str":"Return the chat pane to normal height"});
         }
      }

      private function bShortTallMouseOut(param1:MouseEvent) : *
      {
         var _loc1_:MovieClip = param1.currentTarget as MovieClip;
         this.rootClass.closeToolTip();
      }

      public function bShortTallClick(param1:MouseEvent) : void
      {
         var _loc1_:MovieClip = this.mci.bShortTall;
         if(this.mci.t1.y == this.t1Tally)
         {
            this.mci.t1.y = this.t1Shorty;
            this.tfHeight -= this.tfdH;
            _loc1_.a1.visible = true;
            _loc1_.a2.visible = false;
            this.rootClass.ui.ToolTip.openWith({"str":"Set the chat pane to full height"});
         }
         else
         {
            this.mci.t1.y = this.t1Tally;
            this.tfHeight += this.tfdH;
            _loc1_.a1.visible = false;
            _loc1_.a2.visible = true;
            this.rootClass.ui.ToolTip.openWith({"str":"Return the chat pane to normal height"});
         }
         this.updateTouchHit();
         this.writeText(this.panelIndex);
      }

      private function onCannedChatClick(param1:MouseEvent) : void
      {
         this.mcCannedChat.visible = !this.mcCannedChat.visible;
      }

      public function closeCannedChat() : void
      {
         this.mcCannedChat.visible = false;
      }

      private function initCannedChat(param1:XMLList) : MovieClip
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
            this.submitMsg("/" + _loc1_.strMsg,"emote",this.rootClass.sfc.myUserName);
         }
         else
         {
            this.rootClass.sfc.sendXtMessage("zm","cc",[_loc1_.id],"str",1);
         }
         this.closeCannedChat();
      }

      private function onCannedChatOver(param1:MouseEvent) : *
      {
         if(this.t != null)
         {
            this.t.reset();
         }
      }

      private function onCannedChatOut(param1:MouseEvent) : *
      {
         this.t.start();
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

      private function chat_btnSend(param1:MouseEvent) : *
      {
         this.submitMsg(this.mci.te.text,this.chn.cur.typ,this.pmNm);
         this.rootClass.stage.focus = null;
      }

      private function chat_tebgClick(param1:MouseEvent) : *
      {
         if(this.rootClass.stage.focus != this.mci.te)
         {
            this.openMsgEntry();
         }
      }

      private function chat_linkHandler(param1:TextEvent) : *
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         _loc1_ = String(param1.text.split(",")[0]);
         switch(_loc1_)
         {
            case "openPMsg":
               this.pmMode = 1;
               _loc2_ = String(param1.text.split(",")[1]);
               this.openPMsg(_loc2_);
         }
      }

      private function initTouch() : void
      {
         if(this.touch != null)
         {
            this.touch.detach();
         }
         if(this.touchHit == null)
         {
            this.touchHit = new Sprite();
            this.touchHit.name = "t999999999";
            if(Mobile.events != null)
            {
               Mobile.events.addEventListener(Event.CHANGE,this.onTouchMode,false,0,true);
            }
         }
         this.mci.t1.addChildAt(this.touchHit,0);
         this.mci.te.removeEventListener(FocusEvent.FOCUS_IN,this.onTouchFocus);
         this.mci.te.removeEventListener(FocusEvent.FOCUS_OUT,this.onTouchFocus);
         this.mci.te.addEventListener(FocusEvent.FOCUS_IN,this.onTouchFocus);
         this.mci.te.addEventListener(FocusEvent.FOCUS_OUT,this.onTouchFocus);
         this.updateTouchHit();
         this.touch = TouchScroll.attach(this.mci.t1,this.touchGet,this.touchSet,this.touchMax);
      }

      private function onTouchMode(param1:Event) : void
      {
         this.updateTouchHit();
      }

      private function onTouchFocus(param1:FocusEvent) : void
      {
         this.updateTouchHit();
      }

      private function updateTouchHit() : void
      {
         if(this.touchHit == null)
         {
            return;
         }
         var _loc1_:Number = this.mci.bsend.x - this.mci.t1.x;
         if(_loc1_ <= 0)
         {
            _loc1_ = 400;
         }
         this.touchHit.graphics.clear();
         this.touchHit.graphics.beginFill(0,0);
         this.touchHit.graphics.drawRect(0,0,_loc1_,this.tfHeight);
         this.touchHit.graphics.endFill();
         this.touchHit.mouseEnabled = Boolean(Mobile.active) && (Boolean(this.mci.te.visible) || this.rootClass.stage.focus == this.mci.te);
         this.padEntry();
      }

      private function padEntry() : void
      {
         var _loc1_:InteractiveObject = this.mci.bsend as InteractiveObject;
         var _loc2_:InteractiveObject = this.mci.tebg as InteractiveObject;
         if(!Mobile.active)
         {
            TouchTargets.unpad(_loc1_);
            TouchTargets.unpad(_loc2_);
            return;
         }
         var _loc3_:Array = [this.mci.t1,this.mci.bCannedChat,this.mci.bMinMax,this.mci.bShortTall];
         TouchTargets.pad(_loc1_,0,0,QtyTouch.band(_loc1_,null,_loc3_.concat(this.mci.te)));
         var _loc4_:Rectangle = QtyTouch.band(_loc2_,null,_loc3_);
         var _loc5_:Rectangle = _loc2_.getBounds(this.mci);
         _loc4_.x = _loc5_.x;
         _loc4_.width = _loc5_.width;
         TouchTargets.pad(_loc2_,0,0,_loc4_);
      }

      private function touchLo() : int
      {
         return Math.max(0,Math.min(this.t1Arr.length - 1,int(this.tfHeight / TOUCH_STEP) - 1));
      }

      private function touchMax() : Number
      {
         if(this.rootClass.litePreference.data.bDisChatScroll)
         {
            return 0;
         }
         return Math.max(0,this.t1Arr.length - 1 - this.touchLo()) * TOUCH_STEP;
      }

      private function touchGet() : Number
      {
         var _loc1_:int = int(this.touchLo());
         var _loc2_:int = Math.max(_loc1_,Math.min(this.panelIndex,this.t1Arr.length - 1));
         if(int(this.chatPos / TOUCH_STEP) != _loc2_ - _loc1_)
         {
            this.chatPos = (_loc2_ - _loc1_) * TOUCH_STEP;
         }
         return this.chatPos;
      }

      private function touchSet(param1:Number) : void
      {
         if(Boolean(this.rootClass.litePreference.data.bDisChatScroll) || this.t1Arr.length < 1)
         {
            return;
         }
         this.chatPos = param1;
         var _loc1_:int = Math.max(0,Math.min(this.touchLo() + int(param1 / TOUCH_STEP),this.t1Arr.length - 1));
         if(_loc1_ != this.panelIndex)
         {
            this.panelIndex = _loc1_;
            this.writeText(this.panelIndex);
         }
      }

      internal function onMouseWheelEvent(param1:MouseEvent) : void
      {
         var _loc1_:* = undefined;
         if(this.rootClass.litePreference.data.bDisChatScroll)
         {
            return;
         }
         if(this.mci.t1.hitTestPoint(param1.stageX,param1.stageY))
         {
            _loc1_ = this.t1Arr.length;
            if(param1.delta > 0)
            {
               if(this.panelIndex > 0)
               {
                  --this.panelIndex;
               }
            }
            else if(this.panelIndex < this.t1Arr.length - 1)
            {
               ++this.panelIndex;
            }
            this.writeText(this.panelIndex);
         }
      }

      internal function resetAreaChannels() : *
      {
         this.chn.zone.act = 0;
         this.chn.trade.act = 0;
      }

      public function mapChannels(param1:*) : *
      {
         var _loc1_:* = undefined;
         this.resetAreaChannels();
         var _loc2_:* = 0;
         while(_loc2_ < param1.length)
         {
            _loc1_ = param1[_loc2_].split(",")[0].toString();
            if(_loc1_.indexOf("trade") > -1)
            {
               this.chn.trade.rid = this.rootClass.sfc.getRoom(_loc1_).getId();
               this.chn.trade.act = 1;
            }
            _loc2_++;
         }
         this.chn.zone.act = 1;
      }

      internal function popBubble(param1:*, param2:*, param3:*) : *
      {
         var _loc1_:* = null;
         var _loc2_:* = param1.split(":")[0];
         param1 = param1.substr(2);
         switch(_loc2_)
         {
            case "u":
               _loc1_ = this.rootClass.world.getMCByUserName(param1);
         }
         if(_loc1_ != null)
         {
            _loc1_.bubble.ti.autoSize = TextFieldAutoSize.CENTER;
            _loc1_.bubble.ti.wordWrap = true;
            _loc1_.bubble.ti.htmlText = param2;
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

      public function formatMsgEntry(param1:*) : *
      {
         this.mci.te.setSelection(0,0);
         if(this.chn.cur != this.chn.whisper)
         {
            if(this.chn.cur == this.chn.zone)
            {
               this.mci.tt.text = "";
               this.mci.tt.visible = false;
            }
            else
            {
               this.mci.tt.text = this.chn.cur.tag + ": ";
               this.mci.tt.visible = true;
            }
         }
         else if(typeof param1 == "undefined" || param1 == "")
         {
            this.mci.tt.text = "";
            this.mci.tt.visible = false;
         }
         else
         {
            this.pmNm = param1;
            this.mci.tt.text = "To " + param1 + ": ";
            this.mci.tt.visible = true;
         }
      }

      public function updateMsgEntry() : *
      {
         this.mci.te.x = this.mci.tt.x + this.mci.tt.textWidth + (this.mci.tt.text.length ? 1 : 0);
         this.mci.te.width = this.mci.bsend.x - this.mci.te.x - 3;
         this.mci.te.textColor = "0xFFFFFF";
         this.mci.tt.textColor = "0xFFFFFF";
      }

      private function checkMsgType(param1:Event) : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = this.mci.te.text;
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
                     if(this.chn.zone.act)
                     {
                        this.chn.cur = this.chn.zone;
                        this.chn.lastPublic = this.chn.zone;
                        this.mci.te.text = this.mci.te.text.substr(_loc1_.substr(1).length + 2);
                     }
                     this.formatMsgEntry("");
                     this.updateMsgEntry();
                     break;
                  case "2":
                     if(this.chn.trade.act)
                     {
                        this.chn.cur = this.chn.trade;
                        this.chn.lastPublic = this.chn.trade;
                        this.mci.te.text = this.mci.te.text.substr(3);
                     }
                     this.formatMsgEntry("");
                     this.updateMsgEntry();
                     break;
                  case "p":
                     if(this.chn.party.act)
                     {
                        this.chn.cur = this.chn.party;
                        this.chn.lastPublic = this.chn.party;
                        this.mci.te.text = this.mci.te.text.substr(3);
                     }
                     this.formatMsgEntry("");
                     this.updateMsgEntry();
                     break;
                  case "r":
                     if(this.pmSourceA.length)
                     {
                        this.pmMode = 1;
                        this.chn.cur = this.chn.whisper;
                        this.mci.te.text = this.mci.te.text.substr(3);
                        this.formatMsgEntry(this.pmSourceA[0]);
                        this.updateMsgEntry();
                     }
                     break;
                  case "tell":
                  case "w":
                     if(_loc6_.length > 2)
                     {
                        this.pmMode = 1;
                        this.chn.cur = this.chn.whisper;
                        this.mci.te.text = this.mci.te.text.substr(_loc6_[0].length + _loc6_[1].length + 1);
                        this.formatMsgEntry(_loc6_[1]);
                        this.updateMsgEntry();
                     }
                     break;
                  case "c":
                     this.pmMode = 2;
                     this.chn.cur = this.chn.whisper;
                     this.mci.te.text = this.mci.te.text.substr(_loc6_[0].length + _loc6_[1].length + 1);
                     this.formatMsgEntry(this.pmSourceA[0]);
                     this.updateMsgEntry();
                     break;
                  case "g":
                     if(this.chn.guild.act)
                     {
                        this.chn.cur = this.chn.guild;
                        this.chn.lastPublic = this.chn.guild;
                        this.mci.te.text = this.mci.te.text.substr(3);
                     }
                     this.formatMsgEntry("");
                     this.updateMsgEntry();
               }
            }
            if(_loc1_.charAt(0) == ">")
            {
               if(this.pmSourceA.length)
               {
                  this.pmMode = 1;
                  this.chn.cur = this.chn.whisper;
                  this.mci.te.text = this.mci.te.text.substr(2);
                  this.formatMsgEntry(this.pmSourceA[0]);
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
               this.pmMode = 1;
               this.chn.cur = this.chn.whisper;
               this.mci.te.text = _loc4_[1];
               this.formatMsgEntry(_loc4_[0]);
               this.updateMsgEntry();
            }
         }
      }

      internal function openMsgEntry() : *
      {
         this.pmI = 0;
         this.myMsgsI = 0;
         this.mci.tebg.addEventListener(MouseEvent.CLICK,this.chat_tebgClick);
         this.mci.te.visible = true;
         this.mci.te.type = TextFieldType.INPUT;
         this.rootClass.stage.focus = null;
         this.rootClass.stage.focus = this.mci.te;
         this.updateTouchHit();
         this.formatMsgEntry(this.pmNm);
         this.updateMsgEntry();
      }

      internal function openPMsg(param1:*) : *
      {
         this.pmNm = param1;
         this.chn.cur = this.chn.whisper;
         this.openMsgEntry();
      }

      internal function closeMsgEntry() : *
      {
         this.mci.tebg.addEventListener(MouseEvent.CLICK,this.chat_tebgClick);
         this.mci.te.text = "";
         this.mci.tt.text = "";
         this.mci.te.visible = false;
         this.mci.tt.visible = false;
         if(this.pmMode != 2)
         {
            this.chn.cur = this.chn.lastPublic;
         }
         this.mci.te.type = TextFieldType.DYNAMIC;
         this.rootClass.stage.focus = null;
         this.updateTouchHit();
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
            param1 = param1.split("#060:").join("&lt;");
         }
         if(param1.indexOf(">") > -1)
         {
            param1 = param1.split(">").join("#062:");
         }
         if(param2 && param1.indexOf("#062:") > -1)
         {
            param1 = param1.split("#062:").join("&gt;");
         }
         if(param2)
         {
            param1 = this.removeHTML(param1);
         }
         return param1;
      }

      public function cleanChars(param1:String) : String
      {
         param1 = param1.replace(this.regExpMod,"");
         var _loc1_:int = 0;
         while(_loc1_ < param1.length)
         {
            if(this.legalChars.indexOf(param1.charAt(_loc1_)) < 0)
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
         if(this.rootClass.world != null && this.rootClass.world.myAvatar != null)
         {
            if(this.rootClass.world.myAvatar.items == null || this.rootClass.world.myAvatar.items.length < 1)
            {
               msgOK = false;
               warningModal = false;
               this.pushMsg("warning","Character is still being loaded, please wait a moment.","SERVER","",0);
            }
            if(this.rootClass.world.myAvatar.objData != null)
            {
               uoData = this.rootClass.world.myAvatar.objData;
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
            this.rootClass.ui.ModalStack.addChild(modal);
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
         str = this.rootClass.stripWhite(msg);
         if(str.length)
         {
            this.myMsgs.push(msg);
            if(this.myMsgs.length > 200)
            {
               this.myMsgs.shift();
            }
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
                        this.pushMsg("server","QV " + params[1] + ": " + this.rootClass.world.getQuestValue(parseInt(params[1])),"SERVER","",0);
                     }
                     break;
                  case "debug":
                     if(Game.objLogin.iAccess >= 30)
                     {
                        optionHandler.cmd(this.rootClass,"@ Debugger");
                     }
                     break;
                  case "captest":
                     if(this.rootClass.world.myAvatar.isStaff())
                     {
                        this.rootClass.sfc.sendString(msg.substr(msg.indexOf(" ") + 1));
                        this.pushMsg("server","Sent " + msg.substr(msg.indexOf(" ") + 1),"SERVER","",0);
                     }
                     break;
                  case "multi":
                     msg = "/" + msg.substr(7);
                     this.submitMsg(msg,typ,unm,true);
                     return;
                  case "reload":
                     cmd = null;
                     if(this.rootClass.world.myAvatar.isStaff())
                     {
                        this.rootClass.world.reloadCurrentMap();
                     }
                     break;
                  case "cell":
                     cmd = null;
                     if(this.rootClass.world.myAvatar.objData.intAccessLevel >= 40)
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
                        for each(cell in this.rootClass.world.map.currentScene.labels)
                        {
                           if(cell.name == parta)
                           {
                              isCellOK = true;
                              break;
                           }
                        }
                        if(isCellOK)
                        {
                           this.rootClass.world.moveToCell(parta,partb);
                        }
                        else
                        {
                           this.rootClass.chatF.pushMsg("warning","Frame \'" + parta + "\' does not exist.","SERVER","",0);
                        }
                     }
                     break;
                  case "shop":
                     cmd = null;
                     if(this.rootClass.world.myAvatar.objData.intAccessLevel >= 40)
                     {
                        if(params.length > 1)
                        {
                           parta = int(params[1]);
                        }
                        else
                        {
                           parta = 1;
                        }
                        this.rootClass.world.sendLoadShopRequest(parta);
                     }
                     break;
                  case "sound":
                     cmd = null;
                     if(typeof params[1] != "undefined" && params[1].length > 0)
                     {
                        if(params[1] == "off")
                        {
                           this.rootClass.mixer.bSoundOn = false;
                        }
                        else if(params[1] == "on")
                        {
                           this.rootClass.mixer.bSoundOn = true;
                        }
                     }
                     break;
                  case "ignore":
                     cmd = null;
                     if(typeof params[1] != "undefined" && params[1].length > 0)
                     {
                        tuoNm = params.slice(1).join(" ");
                        if(tuoNm.toLowerCase() != this.rootClass.sfc.myUserName)
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
                     this.ignoreList.data.users = [];
                     this.pushMsg("warning","Ignore List Cleared!","SERVER","",0);
                     this.rootClass.sfc.sendXtMessage("zm","cmd",["ignoreList","$clearAll"],"str",1);
                     break;
                  case "report":
                  case "reportlang":
                     cmd = null;
                     if(typeof params[1] != "undefined" && params[1].length > 0)
                     {
                        tuoNm = params.slice(1).join(" ");
                        this.rootClass.ui.mcPopup.fOpen("Report",{"unm":tuoNm});
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
                     this.rootClass.world.showGuildList();
                     break;
                  case "guildInvite":
                  case "gi":
                     cmd = null;
                     if(typeof params[1] != "undefined" && params[1].length > 0)
                     {
                        tuoNm = params.slice(1).join(" ");
                        this.rootClass.world.guildInvite(tuoNm);
                     }
                     break;
                  case "guildremove":
                  case "gr":
                     cmd = null;
                     if(typeof params[1] != "undefined" && params[1].length > 0)
                     {
                        tuoNm = params.slice(1).join(" ");
                        avt = this.rootClass.world.getAvatarByUserName(tuoNm);
                        if(this.rootClass.world.myAvatar.objData.guildRank >= 2 || Boolean(avt.isMyAvatar))
                        {
                           modal = new ModalMC();
                           modalO = {};
                           modalO.strBody = "Do you want to remove " + tuoNm + " from the guild?";
                           modalO.callback = this.rootClass.world.guildRemove;
                           modalO.params = {"userName":tuoNm};
                           modalO.btns = "dual";
                           this.rootClass.ui.ModalStack.addChild(modal);
                           modal.init(modalO);
                        }
                     }
                     break;
                  case "guildPromote":
                  case "gp":
                     cmd = null;
                     if(this.rootClass.world.myAvatar.objData.guildRank >= 2)
                     {
                        if(typeof params[1] != "undefined" && params[1].length > 0)
                        {
                           tuoNm = params.slice(1).join(" ");
                           this.rootClass.world.guildPromote(tuoNm);
                        }
                     }
                     break;
                  case "guildDemote":
                  case "gd":
                     cmd = null;
                     if(this.rootClass.world.myAvatar.objData.guildRank >= 2)
                     {
                        if(typeof params[1] != "undefined" && params[1].length > 0)
                        {
                           tuoNm = params.slice(1).join(" ");
                           this.rootClass.world.guildDemote(tuoNm);
                        }
                     }
                     break;
                  case "motd":
                     if(msg.length == 5)
                     {
                        if(this.rootClass.world.myAvatar.objData.guild != null)
                        {
                           if(this.rootClass.world.myAvatar.objData.guild.MOTD != null && String(this.rootClass.world.myAvatar.objData.guild.MOTD) != "undefined")
                           {
                              this.pushMsg("guild","Message of the day: " + String(this.rootClass.world.myAvatar.objData.guild.MOTD),"SERVER","",0);
                           }
                           else
                           {
                              this.pushMsg("guild","No Message of the day has been set.","SERVER","",0);
                           }
                        }
                     }
                     else
                     {
                        this.rootClass.world.setGuildMOTD(msg.substr(5));
                     }
                     break;
                  case "gc":
                  case "guildcreate":
                     if(this.rootClass.world.myAvatar.isUpgraded())
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
                              modalO.callback = this.rootClass.world.createGuild;
                              modalO.params = {"guildName":guildName};
                              modalO.btns = "dual";
                              this.rootClass.ui.ModalStack.addChild(modal);
                              modal.init(modalO);
                           }
                           else
                           {
                              this.rootClass.chatF.pushMsg("server","Guild names must be 25 characters or less.","SERVER","",0);
                           }
                        }
                        else
                        {
                           this.rootClass.chatF.pushMsg("server","Please specify a name for your guild.","SERVER","",0);
                        }
                     }
                     else
                     {
                        this.rootClass.chatF.pushMsg("server","Only members may create guilds.","SERVER","",0);
                     }
                     break;
                  case "renameGuild":
                  case "rg":
                     if(this.rootClass.world.myAvatar.objData.guildRank == 3)
                     {
                        if(this.rootClass.world.myAvatar.objData.intCoins >= 1000)
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
                                 modalO.callback = this.rootClass.world.renameGuild;
                                 modalO.params = {"guildName":guildName};
                                 modalO.btns = "dual";
                                 this.rootClass.ui.ModalStack.addChild(modal);
                                 modal.init(modalO);
                              }
                              else
                              {
                                 this.rootClass.chatF.pushMsg("server","Guild names must be 25 characters or less.","SERVER","",0);
                              }
                           }
                           else
                           {
                              this.rootClass.chatF.pushMsg("server","Please specify a name for your guild.","SERVER","",0);
                           }
                        }
                        else
                        {
                           this.rootClass.chatF.pushMsg("server","You do not have enough ACs.","SERVER","",0);
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
                           this.rootClass.sfc.sendXtMessage("zm","dynamic",[paramStr,params[1],params[2]],"str",1);
                        }
                        catch(e:*)
                        {
                           rootClass.sfc.sendXtMessage("zm","dynamic",[paramStr,params[1]],"str",1);
                        }
                     }
                     break;
                  case "guildreset":
                     this.rootClass.sfc.sendXtMessage("zm","guild",["guildreset"],"str",1);
                     break;
                  case "yuki":
                     rmId = int(this.chn.cur.rid);
                     cmd = "message";
                     msg = this.cleanStr(msg,false,true);
                     xtArr.push(msg.substring(msg.indexOf("//yuki ") + 6,msg.length));
                     xtArr.push(this.chn.cur.str);
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
                     this.rootClass.sfc.sendXtMessage("zm","guild",["gi",s],"str",1);
                     break;
                  case "invite":
                  case "pi":
                     cmd = null;
                     if(typeof params[1] != "undefined" && params[1].length > 0)
                     {
                        tuoNm = params.slice(1).join(" ");
                        if(!this.rootClass.world.isPartyFull() && !this.rootClass.world.isPartyMember(tuoNm))
                        {
                           this.rootClass.world.partyInvite(tuoNm);
                        }
                     }
                     break;
                  case "ps":
                     cmd = null;
                     if(typeof params[1] != "undefined" && params[1].length > 0)
                     {
                        tuoNm = params.slice(1).join(" ");
                        this.rootClass.world.partySummon(tuoNm);
                     }
                     break;
                  case "pk":
                     cmd = null;
                     if(typeof params[1] != "undefined" && params[1].length > 0)
                     {
                        tuoNm = params.slice(1).join(" ");
                        this.rootClass.world.partyKick(tuoNm);
                     }
                     break;
                  case "duel":
                     cmd = null;
                     if(typeof params[1] != "undefined" && params[1].length > 0)
                     {
                        tuoNm = params.slice(1).join(" ");
                        this.rootClass.world.sendDuelInvite(tuoNm);
                     }
                     break;
                  case "friends":
                     cmd = null;
                     this.rootClass.world.showFriendsList();
                     break;
                  case "friend":
                     if(typeof params[1] != "undefined" && params[1].length > 0)
                     {
                        tuoNm = params.slice(1).join(" ");
                        if(tuoNm.toLowerCase() != this.rootClass.sfc.myUserName)
                        {
                           this.rootClass.world.requestFriend(tuoNm);
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
                     if(typeof params[1] != "undefined" && params[1].length > 0 && this.rootClass.world.uoTree[this.rootClass.sfc.myUserName].intState != 0 && Boolean(this.rootClass.world.coolDown("tfer")))
                     {
                        this.rootClass.world.returnInfo = null;
                        cmd = "cmd";
                        uName = this.rootClass.sfc.myUserName;
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
                        xtArr.push(this.rootClass.sfc.myUserName);
                        xtArr.push(strMap);
                     }
                     break;
                  case "roomid":
                     cmd = "cmd";
                     xtArr.push("roomID");
                     xtArr.push(this.rootClass.sfc.myUserName);
                     xtArr.push(params[1]);
                     break;
                  case "house":
                     cmd = null;
                     if(params[1] == null)
                     {
                        tuoNm = this.rootClass.sfc.myUserName;
                     }
                     else
                     {
                        tuoNm = params.slice(1).join(" ");
                     }
                     this.rootClass.world.gotoHouse(tuoNm);
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
                     if(Boolean(this.rootClass.world.myAvatar.isStaff()) && Boolean(typeof params[1] != "undefined") && params[1].length > 0)
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
                        this.rootClass.world.goto(params.slice(1).join(" "));
                     }
                     break;
                  case "pull":
                     if(typeof params[1] != "undefined" && params[1].length > 0)
                     {
                        cmd = null;
                        this.rootClass.world.pull(params.slice(1).join(" "));
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
                     cmd = null;
                     this.rootClass.world.toggleFPS();
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
                     if(Boolean(this.rootClass.world.myAvatar.isStaff()) && params.length == 3)
                     {
                        this.pushMsg("warning","geta " + params[1] + "," + params[2] + ": " + this.rootClass.world.getAchievement(params[1],params[2]),"SERVER","",0);
                     }
                     break;
                  case "seta":
                     if(Boolean(this.rootClass.world.myAvatar.isStaff()) && params.length == 4)
                     {
                        this.rootClass.world.setAchievement(params[1],params[2],params[3]);
                     }
                     break;
                  case "queststring":
                     if(this.rootClass.world.myAvatar.isStaff())
                     {
                        this.rootClass.world.loadQuestStringData();
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
                        trace("[Chat] em send: " + emStr);
                        if(emStr.length > 0)
                        {
                           rmId = int(this.chn.cur.rid);
                           cmd = "em";
                           xtArr.push(emStr);
                           xtArr.push(this.chn.event.str);
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
                     this.rootClass.world.afkToggle();
                     break;
                  case "rest":
                     this.rootClass.world.rest();
                     break;
                  case "repairavatars":
                     cmd = null;
                     this.rootClass.world.repairAvatars();
                     break;
                  case "samba":
                     bAch = this.rootClass.world.getAchievement("ia0",11);
                     if(!bAch)
                     {
                        this.pushMsg("warning","You must learn this dance from Samba in Bloodtusk Ravine.","SERVER","",0);
                        break;
                     }
                     if(!this.rootClass.world.myAvatar.isUpgraded())
                     {
                        this.pushMsg("warning","Requires membership to use this emote.","SERVER","",0);
                        break;
                     }
                  case "danceweapon":
                     if(!this.rootClass.world.myAvatar.isUpgraded())
                     {
                        this.pushMsg("warning","Requires membership to use this emote.","SERVER","",0);
                        break;
                     }
                  case "useweapon":
                     if(!this.rootClass.world.myAvatar.isUpgraded())
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
                     if(!this.rootClass.world.myAvatar.isUpgraded())
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
                     if(unm == "iterator" || Boolean(this.rootClass.world.myAvatar.isStaff()))
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
            }
            else if(typ != "whisper")
            {
               rmId = int(this.chn.cur.rid);
               cmd = "message";
               msg = this.cleanStr(msg,false,true);
               xtArr.push(msg);
               xtArr.push(this.chn.cur.str);
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
               this.rootClass.world.myAvatar.pMC.mcChar.gotoAndPlay(this.rootClass.strToProperCase(uVars.strEmote));
               this.rootClass.sfc.sendXtMessage("zm",cmd,[uVars.strEmote],"str",1);
            }
            else if(cmd == "mod" || cmd == "cmd")
            {
               if(xtArr.length)
               {
                  this.rootClass.sfc.sendXtMessage("zm",cmd,xtArr,"str",1);
               }
            }
            else if(cmd != "simple")
            {
               if(!(cmd == null || xtArr.length < 1))
               {
                  if(!this.rootClass.serialCmdMode)
                  {
                     this.rootClass.world.afkPostpone();
                     myAvatar = this.rootClass.world.myAvatar;
                     profanityResult = {};
                     profanityResult = this.nuProfanityCheck(this.cleanStr(xtArr[0]));
                     if(this.iChat == 0)
                     {
                        this.pushMsg("warning","This server only allows canned chat.","SERVER","",0);
                     }
                     else if(this.iChat == 1 && !this.rootClass.world.myAvatar.hasUpgraded() && !this.rootClass.world.myAvatar.isVerified() && !this.rootClass.world.myAvatar.isStaff())
                     {
                        this.pushMsg("warning","Chat is a members-only feature at this time.","SERVER","",0);
                     }
                     else if(!this.rootClass.world.myAvatar.hasUpgraded() && !this.rootClass.world.myAvatar.isVerified() && !this.rootClass.world.myAvatar.isStaff() && !this.rootClass.world.myAvatar.isEmailVerified())
                     {
                        if(int(this.rootClass.world.myAvatar.objData.iAge) < 13)
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
                     else if(myAvatar.objData.dMutedTill != null && myAvatar.objData.dMutedTill.getTime() > this.rootClass.date_server.getTime())
                     {
                        iDiff = (myAvatar.objData.dMutedTill.getTime() - this.rootClass.date_server.getTime()) / 1000;
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
                        if(Boolean(profanityResult.code) && Boolean(this.rootClass.uoPref.bProf))
                        {
                           xtArr[0] = this.maskStringBetween(xtArr[0],profanityResult.indeces);
                        }
                        if(!this.rootClass.uoPref.bProf)
                        {
                           profanityResult = this.nuProfanityCheck(this.cleanStr(xtArr[0]),true);
                           if(profanityResult.code)
                           {
                              xtArr[0] = this.maskStringBetween(xtArr[0],profanityResult.indeces);
                           }
                        }
                        xtArr[0] = this.forceRemove(xtArr[0]);
                        this.rootClass.sfc.sendXtMessage("zm",cmd,xtArr,"str",rmId);
                     }
                  }
                  else
                  {
                     this.rootClass.sfc.sendXtMessage("zm",cmd,xtArr,"str",rmId);
                  }
               }
            }
         }
         if(!this.rootClass.serialCmdMode)
         {
            this.closeMsgEntry();
         }
      }

      private function checkFieldsVPos() : *
      {
         var _loc1_:* = this.mci.t1;
         _loc1_.resetVPos = 0;
         if(this.panelIndex == this.t1Arr.length - 1)
         {
            _loc1_.resetVPos = 1;
         }
      }

      private function setFieldsVPos() : *
      {
         var _loc1_:* = this.mci.t1;
         if(_loc1_.resetVPos)
         {
            this.panelIndex = this.t1Arr.length - 1;
         }
         this.panelIndex = Math.min(this.panelIndex,this.t1Arr.length - 1);
      }

      public function format_time() : String
      {
         var _loc1_:String = null;
         var _loc2_:Number = Number(this.rootClass.date_server.hours);
         var _loc3_:Number = Number(this.rootClass.date_server.minutes);
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

      private function html2Fields(param1:*, param2:*, param3:*, param4:*) : *
      {
         var _loc1_:* = this.mci.t1;
         switch(param2)
         {
            case "=":
            default:
               this.t1Arr = [{
                  "s":param1,
                  "id":param4
               }];
               break;
            case "+=":
               this.t1Arr.push({
                  "s":param1,
                  "id":param4
               });
         }
      }

      private function tsOn() : Boolean
      {
         return Boolean(this.rootClass.litePreference.data.bChatFilter && this.rootClass.litePreference.data.dOptions["timeStamps"]);
      }

      private function fmtLine(param1:Array, param2:Boolean) : String
      {
         var _loc1_:* = param1[0];
         var _loc2_:* = param1[1];
         var _loc3_:* = param1[2];
         var _loc4_:* = param1[3];
         var _loc5_:* = param1[4];
         var _loc6_:* = param2 ? param1[6] : "";
         var _loc7_:* = "<font color=\"#";
         var _loc8_:* = "\">";
         var _loc9_:* = "</font>";
         var _loc10_:* = this.chn[_loc1_].tag == "" ? "" : "[" + this.chn[_loc1_].tag + "] ";
         var _loc11_:* = "";
         _loc2_ = _loc2_.replace(this.regExpURL,"$({url,$&})$");
         if(_loc3_ != null && _loc3_ != "SERVER")
         {
            _loc11_ = "$({user," + _loc3_ + "})$: ";
         }
         if(_loc1_ != "whisper")
         {
            if(_loc1_ != "event")
            {
               return _loc6_ + _loc7_ + this.chn[_loc1_].col + _loc8_ + _loc10_ + _loc11_ + _loc2_ + _loc9_ + "<br>";
            }
            return _loc6_ + _loc7_ + "CCCCCC" + _loc8_ + "*" + _loc7_ + "FFFFFF" + _loc8_ + _loc3_ + _loc9_ + _loc7_ + "CCCCCC" + _loc8_ + " " + _loc2_ + _loc9_ + "*<br>";
         }
         if((_loc3_ == this.rootClass.sfc.myUserName || Boolean(this.isMyModHandle(_loc3_))) && _loc5_ == 0)
         {
            return _loc6_ + "<font color=\"#" + this.rootClass.modColor(this.chn[_loc1_].col,"666666","-") + "\">" + "To " + _loc4_ + ": " + _loc2_ + "</font><br>";
         }
         return _loc6_ + "<font color=\"#" + this.chn[_loc1_].col + "\">From " + _loc11_ + _loc2_ + "</font><br>";
      }

      private function syncFields() : void
      {
         var _loc1_:Boolean = Boolean(this.tsOn());
         if(_loc1_ == this.t1Ts)
         {
            return;
         }
         this.t1Ts = _loc1_;
         this.t1Arr = [];
         var _loc2_:int = 0;
         while(_loc2_ < this.chatArray.length)
         {
            this.html2Fields(this.fmtLine(this.chatArray[_loc2_],_loc1_),"+=",this.chatArray[_loc2_][0],int(this.chatArray[_loc2_][5]));
            _loc2_++;
         }
         this.clearLines();
      }

      private function clearLines() : void
      {
         var _loc1_:String = null;
         var _loc2_:DisplayObject = null;
         for(_loc1_ in this.lineMC)
         {
            _loc2_ = this.lineMC[_loc1_];
            if(_loc2_ != null && _loc2_.parent != null)
            {
               _loc2_.parent.removeChild(_loc2_);
            }
         }
         this.lineMC = {};
         this.drawnA = [];
      }

      public function writeText(param1:int) : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:* = 0;
         var _loc5_:int = 0;
         this.syncFields();
         var _loc6_:Object = {};
         var _loc7_:int = 0;
         var _loc8_:int;
         _loc4_ = _loc8_ = Math.min(param1,this.t1Arr.length - 1);
         while(_loc4_ > -1)
         {
            _loc2_ = this.t1Arr[_loc4_];
            _loc5_ = int(_loc2_.id);
            if(_loc2_.h <= 0)
            {
               this.tl.ti.htmlText = _loc2_.s;
               this.formatWithoutTextLinks(this.tl.ti);
               _loc2_.h = this.tl.height;
            }
            if(_loc4_ < _loc8_)
            {
               _loc3_ = _loc7_ - _loc2_.h + 2;
            }
            else
            {
               _loc3_ = Math.round(this.tfHeight - _loc2_.h);
            }
            if(_loc3_ <= 0)
            {
               break;
            }
            _loc6_[_loc5_] = true;
            _loc1_ = this.lineMC[_loc5_];
            if(_loc1_ == null)
            {
               _loc1_ = this.buildTextLinks(this.tl.ti,_loc2_.s,this.mci.t1,this.drawnA,_loc5_);
               this.lineMC[_loc5_] = _loc1_;
            }
            _loc1_.y = _loc3_;
            _loc7_ = _loc3_;
            MovieClip(_loc1_).mouseEnabled = false;
            _loc4_--;
         }
         _loc4_ = 0;
         while(_loc4_ < this.drawnA.length)
         {
            _loc5_ = int(this.drawnA[_loc4_]);
            if(!_loc6_[_loc5_])
            {
               _loc1_ = this.lineMC[_loc5_];
               delete this.lineMC[_loc5_];
               if(_loc1_ != null && _loc1_.parent != null)
               {
                  _loc1_.parent.removeChild(_loc1_);
               }
               this.drawnA.splice(_loc4_,1);
               _loc4_--;
            }
            _loc4_++;
         }
      }

      private function formatWithoutTextLinks(param1:TextField) : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:String = "$({";
         var _loc12_:String = "})$";
         var _loc13_:* = "<font color=\"#";
         var _loc14_:* = "\">";
         var _loc15_:* = "</font>";
         while(param1.htmlText.indexOf(_loc11_) > -1 && param1.htmlText.indexOf(_loc12_) > -1)
         {
            _loc1_ = param1.htmlText;
            _loc2_ = _loc1_.substr(0,_loc1_.indexOf(_loc11_));
            _loc3_ = _loc1_.substr(_loc1_.indexOf(_loc12_) + _loc12_.length);
            _loc4_ = _loc1_.substr(_loc1_.indexOf(_loc11_) + _loc11_.length);
            _loc5_ = _loc4_.substr(0,_loc4_.indexOf(_loc12_)).split(",");
            _loc6_ = _loc5_[0];
            _loc7_ = _loc5_[1];
            _loc8_ = param1.text.indexOf(_loc11_);
            switch(_loc6_)
            {
               case "url":
                  _loc10_ = _loc7_;
                  _loc9_ = _loc13_ + "FFFF99" + _loc14_ + "<u>" + _loc10_ + "</u>" + _loc15_;
                  break;
               case "user":
                  _loc10_ = _loc7_;
                  _loc9_ = _loc13_ + "FFFFFF" + _loc14_ + _loc10_ + _loc15_;
                  break;
               case "item":
               case "quest":
                  _loc10_ = "[" + _loc7_ + "]";
                  _loc9_ = _loc13_ + "00CCFF" + _loc14_ + _loc10_ + _loc15_;
            }
            param1.htmlText = _loc2_ + _loc9_ + _loc3_;
         }
      }

      private function buildTextLinks(param1:TextField, param2:String, param3:MovieClip, param4:Array, param5:int) : DisplayObject
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:Object = null;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:* = undefined;
         var _loc18_:Rectangle = null;
         var _loc19_:Rectangle = null;
         var _loc20_:MovieClip = null;
         var _loc21_:* = undefined;
         var _loc22_:String = null;
         var _loc23_:MovieClip = new MovieClip();
         _loc23_.name = "b" + param5;
         var _loc24_:String = "$({";
         var _loc25_:String = "})$";
         var _loc26_:* = "<font color=\"#";
         var _loc27_:* = "\">";
         var _loc28_:* = "</font>";
         param1.htmlText = param2;
         while(param1.htmlText.indexOf(_loc24_) > -1 && param1.htmlText.indexOf(_loc25_) > -1)
         {
            _loc1_ = param1.htmlText;
            _loc2_ = _loc1_.substr(0,_loc1_.indexOf(_loc24_));
            _loc3_ = _loc1_.substr(_loc1_.indexOf(_loc25_) + _loc25_.length);
            _loc4_ = _loc1_.substr(_loc1_.indexOf(_loc24_) + _loc24_.length);
            _loc5_ = _loc4_.substr(0,_loc4_.indexOf(_loc25_)).split(",");
            _loc6_ = _loc5_[0];
            _loc7_ = _loc5_[1];
            _loc7_ = _loc7_.split("&amp;").join("&");
            _loc8_ = param1.text.indexOf(_loc24_);
            _loc11_ = {};
            switch(_loc6_)
            {
               case "url":
                  _loc10_ = _loc7_;
                  _loc9_ = _loc26_ + "FFFF99" + _loc27_ + "<u>" + _loc10_ + "</u>" + _loc28_;
                  _loc11_.callback = this.urlClick;
                  break;
               case "user":
                  _loc10_ = _loc7_;
                  _loc9_ = _loc26_ + "FFFFFF" + _loc27_ + _loc10_ + _loc28_;
                  _loc11_.callback = this.pmClick;
                  break;
               case "item":
                  _loc10_ = "[" + _loc7_ + "]";
                  _loc9_ = _loc26_ + "00CCFF" + _loc27_ + _loc10_ + _loc28_;
                  _loc11_.callback = null;
                  break;
               case "quest":
                  _loc11_.sName = _loc5_[1];
                  _loc11_.QuestID = _loc5_[2];
                  _loc11_.iLvl = _loc5_[3];
                  _loc11_.unm = _loc5_[4];
                  _loc10_ = "[" + _loc7_ + "]";
                  _loc9_ = _loc26_ + "00CCFF" + _loc27_ + _loc10_ + _loc28_;
                  _loc11_.callback = this.rootClass.world.doCTAClick;
            }
            param1.htmlText = _loc2_ + _loc9_ + _loc3_;
            _loc12_ = _loc8_;
            _loc13_ = _loc8_ + _loc10_.length - 1;
            _loc14_ = param1.getLineIndexOfChar(_loc12_);
            _loc15_ = param1.getLineIndexOfChar(_loc13_);
            _loc16_ = _loc14_;
            while(_loc16_ <= _loc15_)
            {
               if(_loc16_ == _loc14_)
               {
                  _loc17_ = param1.getCharBoundaries(_loc12_);
               }
               else
               {
                  _loc17_ = param1.getCharBoundaries(param1.getLineOffset(_loc16_));
               }
               if(_loc16_ == _loc15_)
               {
                  _loc18_ = param1.getCharBoundaries(_loc13_);
               }
               else
               {
                  _loc18_ = param1.getCharBoundaries(param1.getLineOffset(_loc16_ + 1) - 1);
               }
               _loc19_ = new Rectangle(_loc17_.x,_loc17_.y,_loc18_.x - _loc17_.x + _loc18_.width,_loc18_.y - _loc17_.y + _loc18_.height);
               _loc20_ = new MovieClip();
               _loc20_.graphics.beginFill(52479);
               _loc20_.graphics.drawRect(0,0,_loc19_.width,_loc19_.height);
               _loc20_.graphics.endFill();
               _loc21_ = _loc23_.addChild(_loc20_);
               _loc21_.alpha = 0;
               _loc21_.x = param1.x + _loc17_.x;
               _loc21_.y = param1.y + _loc17_.y;
               for(_loc22_ in _loc11_)
               {
                  if(_loc22_ != "callback")
                  {
                     _loc21_[_loc22_] = _loc11_[_loc22_];
                  }
               }
               _loc21_.str = _loc7_;
               _loc21_.buttonMode = true;
               _loc21_.addEventListener(MouseEvent.CLICK,_loc11_.callback,false,0,true);
               _loc16_++;
            }
         }
         var _loc29_:* = new uiTextLine();
         _loc29_.ti.htmlText = this.tl.ti.htmlText;
         _loc29_.ti.autoSize = "left";
         _loc29_.ti.multiline = true;
         MovieClip(_loc29_).mouseEnabled = false;
         MovieClip(_loc29_).mouseChildren = false;
         _loc29_.name = "bmp";
         if(_loc23_.numChildren > 0)
         {
            _loc23_.swapChildren(_loc23_.getChildAt(0),_loc23_.addChildAt(_loc29_,0));
         }
         else
         {
            _loc23_.addChild(_loc29_);
         }
         param4.push(param5);
         return param3.addChild(_loc23_);
      }

      private function pmClick(param1:MouseEvent) : void
      {
         var _loc1_:* = undefined;
         if(param1.shiftKey)
         {
            _loc1_ = param1.currentTarget as MovieClip;
            this.openPMsg(_loc1_.str);
         }
         else
         {
            this.rootClass.world.onWalkClick();
         }
      }

      private function urlClick(param1:MouseEvent) : void
      {
         var _loc1_:* = param1.currentTarget as MovieClip;
         navigateToURL(new URLRequest(_loc1_.str),"_blank");
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
         _loc1_ = this.rootClass.stripMarks(_loc1_);
         _loc1_ = this.rootClass.stripDuplicateVowels(_loc1_);
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
         _loc1_ = this.rootClass.stripDuplicateVowels(this.removeHTML(this.cleanStr(param1.toLowerCase())));
         _loc1_ = this.rootClass.stripWhiteStrict(_loc1_);
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
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         if(this.rootClass.litePreference.data.bChatFilter)
         {
            if(Boolean(this.rootClass.litePreference.data.dOptions["disRed"]) && param1 == "warning")
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
         var _loc9_:Boolean = false;
         if(this.ignoreList.data.users != null && this.ignoreList.data.users.indexOf(param3) > -1)
         {
            return;
         }
         if(param3 != "SERVER")
         {
            _loc2_ = 0;
            _loc3_ = this.rootClass.stripWhite(param2.toLowerCase());
            _loc4_ = this.nuProfanityCheck(param2.toLowerCase());
            if(param3.toLowerCase() != this.rootClass.sfc.myUserName && param6 == 0)
            {
               _loc5_ = param2.replace(/[^a-z]/gi,"");
               if(this.strContains(_loc5_.toLowerCase(),["aqwtrade","qwtrade","qwtrde","qwtrd","aqwtrad","aqwtrde","aqwtrd","edartwqa","aqwpirate","aqwolf"]))
               {
                  return;
               }
               if(this.strContains(_loc3_,this.illegalStrings) || this.strContains(_loc3_,this.unsendable))
               {
                  _loc2_ = 1;
               }
               _loc3_ = this.rootClass.stripWhiteStrict(param2.toLowerCase());
               if(this.strContains(_loc3_,["email","password"]))
               {
                  _loc2_ = 1;
               }
               if(param1 == "whisper" && this.modWhisperCheck(param2) > 0)
               {
                  _loc9_ = true;
               }
               if(_loc2_)
               {
                  return;
               }
            }
            if(Boolean(_loc4_.code) && Boolean(this.rootClass.uoPref.bProf))
            {
               param2 = this.maskStringBetween(param2,_loc4_.indeces);
            }
            if(!this.rootClass.uoPref.bProf)
            {
               _loc4_ = this.nuProfanityCheck(param2.toLowerCase(),true);
               if(_loc4_.code)
               {
                  param2 = this.maskStringBetween(param2,_loc4_.indeces);
               }
            }
            param2 = this.forceRemove(param2);
         }
         this.startWindowTimer();
         if(param3.toLowerCase() == this.rootClass.sfc.myUserName && this.rootClass.world.myAvatar.objData.intActivationFlag == 1)
         {
            this.pushMsg("warning","Confirm your email at https://account.aq.com/ to protect your account and remove this message. ","SERVER","",0);
         }
         if(this.isChannel(param1))
         {
            if(param1 == "zone")
            {
               param3 = this.rootClass.strToProperCase(param3);
               if(param3 == "Eienyuki" && param6 == 1)
               {
                  this.popBubble("u:yorumi","Eienyuki: " + param2,param1);
               }
               else
               {
                  this.popBubble("u:" + param3,param2,param1);
               }
            }
            this.checkFieldsVPos();
            this.syncFields();
            _loc6_ = [param1,param2,param3,param4,param5,this.msgID,"<font size=\"11\" style=\"font-family:Arial;\">" + this.format_time() + "</font> "];
            this.html2Fields(this.fmtLine(_loc6_,this.t1Ts),"+=",param1,this.msgID);
            this.chatArray.push(_loc6_);
            ++this.msgID;
            if(this.chatArray.length > this.lineLimit)
            {
               _loc7_ = this.chatArray.length - this.lineLimit;
               this.chatArray.splice(0,_loc7_);
               this.t1Arr.splice(0,_loc7_);
            }
            this.setFieldsVPos();
            this.writeText(this.panelIndex);
         }
         if(_loc9_)
         {
            this.pushMsg("warning","<font color=\'#FFFFFF\'>" + param3 + "</font> IS NOT A MODERATOR.  DO NOT GIVE ACCOUNT INFORMATION TO OTHER PLAYERS.","SERVER","",0);
            _loc8_ = "<font color=\'#FF0000\'>WARNING</font><br/><font color=\'#FFFFFF\'>" + param3.toUpperCase() + "</font><font color=\'#FFFFFF\'> IS NOT A MODERATOR.<br/>Do not give account information to other players.<font>";
            _loc8_ = _loc8_ + "<br/><a href=\'event:link::https://aq.com/safety.asp\'><font color=\'#66CCFF\'><u>Click here</u></font></a> to learn more.";
            this.rootClass.ui.ToolTip.openWith({
               "str":_loc8_,
               "lowerright":true,
               "invert":true,
               "closein":10000
            });
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
         _loc1_ = " " + this.removeHTML(this.cleanStr(param1.toLowerCase())) + " ";
         _loc1_ = this.rootClass.stripMarks(_loc1_);
         _loc1_ = this.rootClass.stripDuplicateVowels(_loc1_);
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
         _loc1_ = this.rootClass.stripDuplicateVowels(this.removeHTML(this.cleanStr(param1.toLowerCase())));
         _loc1_ = this.rootClass.stripWhiteStrict(_loc1_);
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
         _loc1_ = this.rootClass.stripDuplicateVowels(this.removeHTML(this.cleanStr(param1.toLowerCase())));
         _loc1_ = this.rootClass.stripWhiteStrictB(_loc1_);
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
            if(this.legalCharsStrict.indexOf(param1.charAt(_loc6_)) > -1)
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

      public function modWhisperCheck(param1:String) : int
      {
         var _loc1_:String = null;
         var _loc2_:String = this.rootClass.stripWhiteStrict(this.removeHTML(param1.toLowerCase()));
         for each(_loc1_ in this.modWhisperCheckList)
         {
            if(_loc2_.indexOf(_loc1_) > -1)
            {
               return 1;
            }
         }
         return 0;
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
         while(_loc1_ < this.unsendable.length)
         {
            if(param1.toLowerCase().indexOf(this.unsendable[_loc1_]) > -1)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }

      public function isIgnored(param1:String) : Boolean
      {
         return this.ignoreList.data.users.indexOf(param1.toLowerCase()) >= 0;
      }

      public function ignore(param1:String) : void
      {
         var mc:* = undefined;
         var strName:String = param1;
         if(this.ignoreList.data.users.indexOf(strName.toLowerCase()) == -1)
         {
            this.ignoreList.data.users.push(strName.toLowerCase());
            try
            {
               this.ignoreList.flush();
            }
            catch(e:Error)
            {
               trace("[Chat] ERR ignore: ignoreList flush: " + e.message);
            }
            mc = this.rootClass.world.getAvatarByUserName(strName.toLowerCase());
            if(mc != null)
            {
               mc.pMC.ignore.visible = true;
            }
            this.rootClass.sfc.sendXtMessage("zm","cmd",["ignoreList",this.ignoreList.data.users],"str",1);
         }
         try
         {
            if(this.rootClass.ui.mcOFrame.fData.typ == "userListIgnore")
            {
               this.rootClass.ui.mcOFrame.update();
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
         var uind:* = this.ignoreList.data.users.indexOf(strName.toLowerCase());
         while(uind > -1)
         {
            this.ignoreList.data.users.splice(uind,1);
            uind = this.ignoreList.data.users.indexOf(strName.toLowerCase());
         }
         try
         {
            this.ignoreList.flush();
         }
         catch(e:Error)
         {
            trace("[Chat] ERR unignore: ignoreList flush: " + e.message);
         }
         mc = this.rootClass.world.getAvatarByUserName(strName.toLowerCase());
         if(mc != null)
         {
            mc.pMC.ignore.visible = false;
         }
         this.rootClass.sfc.sendXtMessage("zm","cmd",["ignoreList",this.ignoreList.data.users],"str",1);
         try
         {
            if(this.rootClass.ui.mcOFrame.fData.typ == "userListIgnore")
            {
               this.rootClass.ui.mcOFrame.update();
            }
         }
         catch(e:Error)
         {
         }
      }

      public function muteMe(param1:int) : void
      {
         var _loc1_:Date = new Date();
         this.mute.ts = Number(_loc1_.getTime());
         this.mute.cd = param1;
         this.mute.timer.delay = param1;
         this.mute.timer.start();
         this.pushMsg("warning","You have been muted! Chat privileges are temporarily revoked.","SERVER","",0);
      }

      public function unmuteMe(param1:Event = null) : void
      {
         this.mute.ts = 0;
         this.mute.cd = 0;
         this.mute.timer.reset();
         this.pushMsg("server","You have been unmuted.  Chat privileges are restored.","SERVER","",0);
      }

      public function amIMute() : Boolean
      {
         var _loc1_:Date = null;
         var _loc2_:Number = NaN;
         var _loc3_:Boolean = false;
         if(this.mute.ts > 0)
         {
            _loc1_ = new Date();
            _loc2_ = _loc1_.getTime();
            if(_loc2_ - this.mute.ts >= this.mute.cd)
            {
               this.mute.ts = 0;
               this.mute.cd = 0;
            }
            else
            {
               _loc3_ = true;
            }
         }
         return _loc3_;
      }

      public function isChannel(param1:String) : Boolean
      {
         var _loc1_:* = undefined;
         for(_loc1_ in this.chn)
         {
            if(_loc1_.toLowerCase() == param1.toLowerCase())
            {
               return true;
            }
         }
         return false;
      }

      private function isMyModHandle(param1:String) : Boolean
      {
         if(param1.split("-")[0] == "Moderator" && Boolean(int(param1.split("-")[1] == this.rootClass.world.modID)))
         {
            return true;
         }
         return false;
      }
   }
}
