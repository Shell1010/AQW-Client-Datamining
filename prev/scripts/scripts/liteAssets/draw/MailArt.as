package liteAssets.draw
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;

   public class MailArt
   {

      private static var hbOut:Array;

      private static var hbBuf:String;

      private static var hbStack:Array;

      private static var hbEdge:Boolean;

      private static var hbImgs:int;

      private static var faces:Array;

      public static const GOLD:uint = 14725888;

      public static const TRIM:uint = 13145646;

      private static const MONTHS:Array = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];

      private static const MONTHS_LONG:Array = ["January","February","March","April","May","June","July","August","September","October","November","December"];

      private static const IMG_URL_RE:RegExp = /^https?:\/\/[^\s"'<>\[\]]+\.(png|jpe?g|gif)(\?[^\s"'<>\[\]]*)?$/i;

      private static const HTML_TAG_RE:RegExp = /<\s*\/?\s*(p|div|br|strong|b|em|i|u|s|span|ul|ol|li|h[1-6]|a|img|blockquote|pre|code)\b/i;

      private static const HB_SIZES:Array = [24,21,18,16,14,13];

      private static const HB_DROP:Object = {
         "script":1,
         "style":1,
         "iframe":1,
         "object":1,
         "embed":1,
         "svg":1
      };

      private static const HB_VOID:Object = {
         "br":1,
         "img":1,
         "hr":1,
         "wbr":1,
         "input":1,
         "meta":1,
         "link":1,
         "area":1,
         "base":1,
         "col":1,
         "source":1,
         "track":1,
         "param":1
      };

      private static const HB_BLOCK:Object = {
         "p":1,
         "div":1,
         "h1":1,
         "h2":1,
         "h3":1,
         "h4":1,
         "h5":1,
         "h6":1,
         "ul":1,
         "ol":1,
         "li":1,
         "blockquote":1,
         "pre":1
      };

      public static var serverOffsetMs:Number = 0;

      private static const CTRL_RE:RegExp = /[\r\n\t]/g;

      private static const BI_TAG_RE:RegExp = /<(\/?)(b|i)>/gi;

      private static var buttonState:Dictionary = new Dictionary(true);

      private static var iconClassCache:Object = {};

      public function MailArt()
      {
         super();
      }

      public static function embedded() : Boolean
      {
         var names:Array = null;
         var all:Boolean = false;
         var i:int = 0;
         var c:Class = null;
         if(faces == null)
         {
            faces = [];
            names = ["UIFontReg","UIFontBold","UIFontItalic","UIFontBoldItalic"];
            all = true;
            i = 0;
            while(i < 4)
            {
               try
               {
                  c = getDefinitionByName(names[i]) as Class;
                  Font.registerFont(c);
                  faces[i] = new c() as Font;
               }
               catch(e:Error)
               {
                  faces[i] = null;
               }
               if(faces[i] == null)
               {
                  all = false;
               }
               i++;
            }
            if(!all)
            {
               faces.length = 0;
            }
         }
         return faces.length == 4;
      }

      public static function fmt(param1:int, param2:uint, param3:Boolean = false, param4:Boolean = false) : TextFormat
      {
         if(!embedded())
         {
            return new TextFormat("Arial",param1,param2,param3,param4);
         }
         var _loc1_:Font = faces[(param3 ? 1 : 0) | (param4 ? 2 : 0)];
         return new TextFormat(_loc1_.fontName,param1,param2,_loc1_.fontStyle == FontStyle.BOLD || _loc1_.fontStyle == FontStyle.BOLD_ITALIC,_loc1_.fontStyle == FontStyle.ITALIC || _loc1_.fontStyle == FontStyle.BOLD_ITALIC);
      }

      public static function cover(param1:TextField) : void
      {
         var _loc1_:TextFormat = null;
         var _loc2_:int = 0;
         var _loc3_:TextFormat = null;
         if(!embedded())
         {
            return;
         }
         var _loc4_:Boolean = Boolean(Font(faces[0]).hasGlyphs(param1.text.replace(CTRL_RE,"")));
         if(_loc4_ == param1.embedFonts)
         {
            return;
         }
         param1.embedFonts = _loc4_;
         var _loc5_:int = param1.length;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc1_ = param1.getTextFormat(_loc6_,_loc6_ + 1);
            _loc2_ = _loc6_ + 1;
            while(_loc2_ < _loc5_)
            {
               _loc3_ = param1.getTextFormat(_loc2_,_loc2_ + 1);
               if(_loc3_.font != _loc1_.font || _loc3_.bold != _loc1_.bold || _loc3_.italic != _loc1_.italic)
               {
                  break;
               }
               _loc2_++;
            }
            param1.setTextFormat(swapFace(_loc1_,_loc4_),_loc6_,_loc2_);
            _loc6_ = _loc2_;
         }
         param1.defaultTextFormat = swapFace(param1.defaultTextFormat,_loc4_);
      }

      public static function embedHtml(param1:String) : String
      {
         var b:int = 0;
         var it:int = 0;
         var closers:Array = null;
         var html:String = param1;
         if(!embedded())
         {
            return html;
         }
         b = 0;
         it = 0;
         closers = [];
         return html.replace(BI_TAG_RE,function(... rest):String
         {
            var _loc4_:* = String(rest[2]).toLowerCase() == "b";
            if(rest[1] == "/")
            {
               if(_loc4_)
               {
                  if(b > 0)
                  {
                     --b;
                  }
               }
               else if(it > 0)
               {
                  --it;
               }
               return closers.length > 0 ? closers.pop() : "";
            }
            if(_loc4_)
            {
               ++b;
            }
            else
            {
               ++it;
            }
            var _loc5_:* = faces[(b > 0 ? 1 : 0) | (it > 0 ? 2 : 0)];
            var _loc6_:* = _loc5_.fontStyle == FontStyle.BOLD || _loc5_.fontStyle == FontStyle.BOLD_ITALIC;
            var _loc1_:* = _loc5_.fontStyle == FontStyle.ITALIC || _loc5_.fontStyle == FontStyle.BOLD_ITALIC;
            closers.push((_loc1_ ? "</i>" : "") + (_loc6_ ? "</b>" : "") + "</font>");
            return "<font face=\"" + _loc5_.fontName + "\">" + (_loc6_ ? "<b>" : "") + (_loc1_ ? "<i>" : "");
         });
      }

      private static function swapFace(param1:TextFormat, param2:Boolean) : TextFormat
      {
         var _loc3_:Font = null;
         var _loc5_:Boolean = param1.bold == true;
         var _loc6_:Boolean = param1.italic == true;
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            _loc3_ = faces[_loc1_];
            if(_loc3_.fontName == param1.font && _loc3_.fontName != "Arial")
            {
               _loc5_ = (_loc1_ & 1) != 0;
               _loc6_ = (_loc1_ & 2) != 0;
               break;
            }
            _loc1_++;
         }
         var _loc2_:TextFormat = param2 ? fmt(12,0,_loc5_,_loc6_) : new TextFormat("Arial",null,null,_loc5_,_loc6_);
         param1.font = _loc2_.font;
         param1.bold = _loc2_.bold;
         param1.italic = _loc2_.italic;
         return param1;
      }

      public static function tf(param1:int, param2:uint, param3:Boolean = false, param4:Boolean = false) : TextField
      {
         var _loc1_:TextField = new TextField();
         _loc1_.embedFonts = embedded();
         if(_loc1_.embedFonts)
         {
            _loc1_.antiAliasType = AntiAliasType.ADVANCED;
         }
         _loc1_.selectable = false;
         _loc1_.mouseEnabled = false;
         _loc1_.multiline = false;
         _loc1_.wordWrap = false;
         _loc1_.autoSize = TextFieldAutoSize.LEFT;
         _loc1_.defaultTextFormat = fmt(param1,param2,param3,param4);
         return _loc1_;
      }

      public static function fit(param1:TextField, param2:Number) : void
      {
         var _loc3_:int = 0;
         if(param1.textWidth <= param2)
         {
            return;
         }
         var _loc5_:String = param1.text;
         var _loc6_:int = 0;
         var _loc1_:int = _loc5_.length - 1;
         var _loc2_:int = 0;
         while(_loc6_ <= _loc1_)
         {
            _loc3_ = _loc6_ + _loc1_ >> 1;
            param1.text = _loc5_.substr(0,_loc3_) + "…";
            if(param1.textWidth <= param2)
            {
               _loc2_ = _loc3_;
               _loc6_ = _loc3_ + 1;
            }
            else
            {
               _loc1_ = _loc3_ - 1;
            }
         }
         param1.text = _loc5_.substr(0,_loc2_) + "…";
      }

      public static function envelope(param1:Graphics, param2:Number, param3:Number, param4:Number, param5:Number, param6:Boolean, param7:Boolean) : void
      {
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = param2 + param4 / 2;
         var _loc11_:Number = param3 + param5 / 2;
         if(param6)
         {
            param1.lineStyle();
            param1.beginFill(16776693);
            param1.drawRect(param2 + param4 * 0.14,param3 - param5 * 0.3,param4 * 0.72,param5 * 0.3);
            param1.endFill();
         }
         param1.lineStyle(1,7032366,1,true);
         param1.beginFill(15983808);
         param1.drawRect(param2,param3,param4,param5);
         param1.endFill();
         param1.lineStyle(1,9071162,1,true);
         param1.beginFill(15127202);
         if(param6)
         {
            param1.moveTo(param2,param3);
            param1.lineTo(_loc10_,param3 - param5 * 0.55);
            param1.lineTo(param2 + param4,param3);
            param1.lineTo(param2,param3);
         }
         else
         {
            param1.moveTo(param2,param3);
            param1.lineTo(_loc10_,_loc11_);
            param1.lineTo(param2 + param4,param3);
            param1.lineTo(param2,param3);
         }
         param1.endFill();
         if(param7)
         {
            _loc7_ = _loc10_;
            _loc8_ = param6 ? param3 - param5 * 0.55 : _loc11_;
            _loc9_ = param5 * 0.18;
            param1.lineStyle(1,7999504,1,true);
            param1.beginFill(11674146);
            param1.drawCircle(_loc7_,_loc8_,_loc9_);
            param1.endFill();
         }
      }

      public static function gift(param1:Graphics, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc1_:Number = param4 / 2;
         var _loc2_:Number = param2 - _loc1_;
         var _loc3_:Number = param3 - _loc1_;
         param1.lineStyle(1,9071162,1,true);
         param1.beginFill(GOLD);
         param1.drawRect(_loc2_,_loc3_,param4,param4);
         param1.endFill();
         var _loc10_:Number = param4 * 0.18;
         param1.lineStyle();
         param1.beginFill(12986408);
         param1.drawRect(param2 - _loc10_ / 2,_loc3_,_loc10_,param4);
         param1.drawRect(_loc2_,param3 - _loc10_ / 2,param4,_loc10_);
         param1.endFill();
         var _loc11_:Number = param4 * 0.16;
         param1.beginFill(12986408);
         param1.drawCircle(param2 - _loc11_,_loc3_ - _loc11_ * 0.3,_loc11_);
         param1.drawCircle(param2 + _loc11_,_loc3_ - _loc11_ * 0.3,_loc11_);
         param1.endFill();
      }

      public static function check(param1:Graphics, param2:Number, param3:Number, param4:Number) : void
      {
         param1.lineStyle(1,16777215,1,true);
         param1.beginFill(3055172);
         param1.drawCircle(param2,param3,param4);
         param1.endFill();
         param1.lineStyle(2,16777215,1,true);
         param1.moveTo(param2 - param4 * 0.5,param3);
         param1.lineTo(param2 - param4 * 0.15,param3 + param4 * 0.4);
         param1.lineTo(param2 + param4 * 0.5,param3 - param4 * 0.35);
      }

      public static function button(param1:String, param2:int, param3:int, param4:String) : Sprite
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.buttonMode = true;
         _loc1_.useHandCursor = true;
         _loc1_.mouseChildren = false;
         var _loc2_:Boolean = param4 != "plain";
         var _loc3_:int = param4 == "plain" ? 12 : (param3 >= 28 ? 14 : 12);
         var _loc10_:uint = param4 == "plain" ? 14731680 : 16777215;
         var _loc11_:TextField = tf(_loc3_,_loc10_,_loc2_);
         _loc11_.filters = [new DropShadowFilter(1,45,0,0.6,2,2,1,1)];
         _loc11_.text = param1;
         _loc1_.addChild(_loc11_);
         var _loc7_:Object = {
            "w":param2,
            "h":param3,
            "style":param4,
            "enabled":true,
            "hover":false,
            "tf":_loc11_
         };
         buttonState[_loc1_] = _loc7_;
         drawButton(_loc1_,_loc7_);
         _loc1_.addEventListener(MouseEvent.ROLL_OVER,onButtonOver,false,0,true);
         _loc1_.addEventListener(MouseEvent.ROLL_OUT,onButtonOut,false,0,true);
         return _loc1_;
      }

      public static function setButton(param1:Sprite, param2:Boolean, param3:String = null) : void
      {
         var _loc6_:Object = buttonState[param1];
         if(_loc6_ == null)
         {
            return;
         }
         _loc6_.enabled = param2;
         if(param3 != null)
         {
            TextField(_loc6_.tf).text = param3;
         }
         drawButton(param1,_loc6_);
      }

      public static function isEnabled(param1:Sprite) : Boolean
      {
         var _loc4_:Object = buttonState[param1];
         return _loc4_ == null ? true : Boolean(_loc4_.enabled);
      }

      private static function drawButton(param1:Sprite, param2:Object) : void
      {
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc5_:Graphics = param1.graphics;
         _loc5_.clear();
         var _loc6_:int = int(param2.w);
         var _loc1_:int = int(param2.h);
         var _loc2_:Matrix = new Matrix();
         _loc2_.createGradientBox(_loc6_,_loc1_,Math.PI / 2,0,0);
         var _loc3_:TextField = TextField(param2.tf);
         if(!param2.enabled)
         {
            _loc5_.lineStyle(1,6710886,1,true);
            _loc5_.beginGradientFill(GradientType.LINEAR,[5592405,3355443],[1,1],[0,255],_loc2_);
            _loc5_.drawRoundRect(0,0,_loc6_,_loc1_,12,12);
            _loc5_.endFill();
            _loc3_.textColor = 10066329;
         }
         else if(param2.style == "green")
         {
            _loc10_ = param2.hover ? 6081385 : 4830038;
            _loc11_ = param2.hover ? 2593846 : 2062892;
            _loc5_.lineStyle(1,TRIM,1,true);
            _loc5_.beginGradientFill(GradientType.LINEAR,[_loc10_,_loc11_],[1,1],[0,255],_loc2_);
            _loc5_.drawRoundRect(0,0,_loc6_,_loc1_,12,12);
            _loc5_.endFill();
            _loc3_.textColor = 16777215;
         }
         else
         {
            _loc5_.lineStyle(1,9071162,1,true);
            _loc5_.beginFill(param2.hover ? 4863524 : 3811866);
            _loc5_.drawRect(0,0,_loc6_,_loc1_);
            _loc5_.endFill();
            _loc3_.textColor = 14731680;
         }
         param1.buttonMode = Boolean(param2.enabled);
         _loc3_.x = Math.round((_loc6_ - _loc3_.textWidth) / 2);
         _loc3_.y = Math.round((_loc1_ - _loc3_.textHeight) / 2) - 1;
      }

      private static function onButtonOver(param1:MouseEvent) : void
      {
         var _loc4_:Sprite = null;
         var _loc5_:Object = null;
         try
         {
            _loc4_ = param1.currentTarget as Sprite;
            _loc5_ = buttonState[_loc4_];
            if(_loc5_ == null || Boolean(_loc5_.hover))
            {
               return;
            }
            _loc5_.hover = true;
            drawButton(_loc4_,_loc5_);
         }
         catch(err:Error)
         {
         }
      }

      private static function onButtonOut(param1:MouseEvent) : void
      {
         var _loc4_:Sprite = null;
         var _loc5_:Object = null;
         try
         {
            _loc4_ = param1.currentTarget as Sprite;
            _loc5_ = buttonState[_loc4_];
            if(_loc5_ == null || !_loc5_.hover)
            {
               return;
            }
            _loc5_.hover = false;
            drawButton(_loc4_,_loc5_);
         }
         catch(err:Error)
         {
         }
      }

      public static function commas(param1:Number) : String
      {
         var _loc4_:Boolean = param1 < 0;
         var _loc5_:String = String(int(Math.abs(param1)));
         var _loc6_:String = "";
         var _loc1_:int = 0;
         var _loc2_:* = int(_loc5_.length - 1);
         while(_loc2_ >= 0)
         {
            _loc6_ = _loc5_.charAt(_loc2_) + _loc6_;
            if(++_loc1_ % 3 == 0 && _loc2_ != 0)
            {
               _loc6_ = "," + _loc6_;
            }
            _loc2_--;
         }
         return (_loc4_ ? "-" : "") + _loc6_;
      }

      public static function shortNum(param1:Number) : String
      {
         var _loc1_:String = null;
         var _loc4_:Number = Number(param1);
         var _loc5_:Boolean = _loc4_ < 0;
         var _loc6_:Number = Math.abs(_loc4_);
         if(_loc6_ < 10000)
         {
            return commas(_loc4_);
         }
         if(_loc6_ < 1000000)
         {
            _loc1_ = fmtDec(_loc6_ / 1000) + "K";
         }
         else
         {
            _loc1_ = fmtDec(_loc6_ / 1000000) + "M";
         }
         return (_loc5_ ? "-" : "") + _loc1_;
      }

      private static function fmtDec(param1:Number) : String
      {
         var _loc4_:Number = Math.floor(param1 * 10) / 10;
         var _loc5_:String = _loc4_.toFixed(1);
         if(_loc5_.substr(_loc5_.length - 2) == ".0")
         {
            _loc5_ = _loc5_.substr(0,_loc5_.length - 2);
         }
         return _loc5_;
      }

      private static function sameDay(param1:Date, param2:Date) : Boolean
      {
         return param1.fullYear == param2.fullYear && param1.month == param2.month && param1.date == param2.date;
      }

      public static function dateShort(param1:Number) : String
      {
         var _loc4_:Date = new Date(Number(param1) * 1000 + serverOffsetMs);
         var _loc5_:Date = new Date(new Date().time + serverOffsetMs);
         if(sameDay(_loc4_,_loc5_))
         {
            return "Today";
         }
         var _loc6_:Date = new Date(_loc5_.time - 86400000);
         if(sameDay(_loc4_,_loc6_))
         {
            return "Yesterday";
         }
         return MONTHS[_loc4_.month] + " " + _loc4_.date;
      }

      public static function dateLong(param1:Number) : String
      {
         var _loc4_:Date = new Date(Number(param1) * 1000 + serverOffsetMs);
         var _loc5_:int = _loc4_.hours % 12;
         var _loc6_:int = _loc4_.minutes;
         return MONTHS_LONG[_loc4_.month] + " " + _loc4_.date + ", " + _loc4_.fullYear + " · " + (_loc5_ == 0 ? 12 : _loc5_) + ":" + (_loc6_ < 10 ? "0" : "") + _loc6_ + (_loc4_.hours < 12 ? " AM" : " PM");
      }

      public static function expiryText(param1:Number) : String
      {
         var _loc4_:Number = Number(param1) - new Date().time / 1000;
         if(_loc4_ >= 172800)
         {
            return "Expires in " + Math.floor(_loc4_ / 86400) + " days";
         }
         if(_loc4_ >= 86400)
         {
            return "Expires in 1 day";
         }
         if(_loc4_ >= 7200)
         {
            return "Expires in " + Math.floor(_loc4_ / 3600) + " hours";
         }
         if(_loc4_ > 0)
         {
            return "Expires soon";
         }
         return "Expired";
      }

      public static function soon(param1:Number) : Boolean
      {
         var _loc4_:Number = Number(param1) - new Date().time / 1000;
         return _loc4_ < 259200;
      }

      private static function pushText(param1:Array, param2:String) : void
      {
         if(param2 == null || param2.length == 0)
         {
            return;
         }
         var _loc5_:String = trimBr(convertText(param2));
         if(_loc5_.length > 0)
         {
            param1.push({
               "t":"text",
               "html":_loc5_
            });
         }
      }

      private static function trimBr(param1:String) : String
      {
         var _loc4_:String = param1;
         while(_loc4_.length >= 4 && _loc4_.substr(0,4).toLowerCase() == "<br>")
         {
            _loc4_ = _loc4_.substr(4);
         }
         while(_loc4_.length >= 4 && _loc4_.substr(_loc4_.length - 4).toLowerCase() == "<br>")
         {
            _loc4_ = _loc4_.substr(0,_loc4_.length - 4);
         }
         return _loc4_;
      }

      private static function convertText(param1:String) : String
      {
         var _loc4_:String = param1;
         _loc4_ = _loc4_.split("&").join("&amp;");
         _loc4_ = _loc4_.split("<").join("&lt;");
         _loc4_ = _loc4_.split(">").join("&gt;");
         _loc4_ = _loc4_.split("\"").join("&quot;");
         _loc4_ = _loc4_.split("\r\n").join("<br>");
         _loc4_ = _loc4_.split("\n").join("<br>");
         _loc4_ = _loc4_.replace(/\[b\]/gi,"<b>");
         _loc4_ = _loc4_.replace(/\[\/b\]/gi,"</b>");
         _loc4_ = _loc4_.replace(/\[i\]/gi,"<i>");
         _loc4_ = _loc4_.replace(/\[\/i\]/gi,"</i>");
         _loc4_ = _loc4_.replace(/\[u\]/gi,"<u>");
         _loc4_ = _loc4_.replace(/\[\/u\]/gi,"</u>");
         _loc4_ = _loc4_.replace(/\[color=#([0-9a-fA-F]{6})\]/gi,"<font color=\"#$1\">");
         _loc4_ = _loc4_.replace(/\[color=[^\]]*\]/gi,"");
         _loc4_ = _loc4_.replace(/\[\/color\]/gi,"</font>");
         _loc4_ = _loc4_.replace(/\[size=(\d+)\]/gi,sizeReplacer);
         _loc4_ = _loc4_.replace(/\[size=[^\]]*\]/gi,"");
         _loc4_ = _loc4_.replace(/\[\/size\]/gi,"</font>");
         _loc4_ = _loc4_.replace(/\[center\]/gi,"<p align=\"center\">");
         _loc4_ = _loc4_.replace(/\[\/center\]/gi,"</p>");
         return _loc4_.replace(/\[url=([^\]]*)\](.*?)\[\/url\]/gi,urlReplacer);
      }

      private static function sizeReplacer(param1:String, param2:String, param3:int, param4:String) : String
      {
         var _loc1_:int = int(param2);
         if(_loc1_ < 9)
         {
            _loc1_ = 9;
         }
         if(_loc1_ > 24)
         {
            _loc1_ = 24;
         }
         return "<font size=\"" + _loc1_ + "\">";
      }

      private static function urlReplacer(param1:String, param2:String, param3:String, param4:int, param5:String) : String
      {
         if(/^https?:\/\//i.test(param2) && param2.indexOf("\"") < 0 && param2.indexOf("\'") < 0 && param2.indexOf("[") < 0)
         {
            return "<a href=\"event:" + param2 + "\"><u><font color=\"#1A4F8B\">" + param3 + "</font></u></a>";
         }
         return param3;
      }

      public static function bbBlocks(param1:String) : Array
      {
         var _loc3_:String = null;
         var _loc10_:String = null;
         var _loc4_:Array = [];
         if(param1 == null || param1.length == 0)
         {
            return _loc4_;
         }
         if(HTML_TAG_RE.test(param1))
         {
            return htmlBlocks(param1);
         }
         var _loc5_:RegExp = /\[img\](.*?)\[\/img\]|\[img=([^\]]*)\]/gi;
         var _loc6_:int = 0;
         var _loc1_:int = 0;
         var _loc2_:Object = _loc5_.exec(param1);
         while(_loc2_ != null)
         {
            _loc3_ = param1.substring(_loc1_,_loc2_.index);
            _loc1_ = _loc5_.lastIndex;
            _loc10_ = _loc2_[1] != null ? _loc2_[1] : _loc2_[2];
            if(_loc10_ != null && _loc6_ < 5 && Boolean(IMG_URL_RE.test(_loc10_)))
            {
               pushText(_loc4_,_loc3_);
               _loc4_.push({
                  "t":"img",
                  "url":_loc10_
               });
               _loc6_++;
            }
            else
            {
               pushText(_loc4_,_loc3_);
            }
            _loc2_ = _loc5_.exec(param1);
         }
         pushText(_loc4_,param1.substring(_loc1_));
         return _loc4_;
      }

      public static function htmlBlocks(param1:String) : Array
      {
         var result:Array;
         var re:RegExp = null;
         var skipTag:String = null;
         var skipDepth:int = 0;
         var m:Object = null;
         var tok:String = null;
         var name:String = null;
         var closing:Boolean = false;
         var body:String = param1;
         hbOut = [];
         hbBuf = "";
         hbStack = [];
         hbEdge = true;
         hbImgs = 0;
         try
         {
            re = /<!--[\s\S]*?-->|<(\/?)([a-zA-Z][a-zA-Z0-9]*)((?:"[^"]*"|'[^']*'|[^>"'])*)>|<[^>]*>|[^<]+|</g;
            skipTag = null;
            skipDepth = 0;
            while((m = re.exec(body)) != null)
            {
               tok = String(m[0]);
               name = m[2] != null ? String(m[2]).toLowerCase() : "";
               closing = m[1] != null && String(m[1]).length > 0;
               if(skipTag != null)
               {
                  if(name == skipTag)
                  {
                     if(closing)
                     {
                        skipDepth--;
                        if(skipDepth <= 0)
                        {
                           skipTag = null;
                        }
                     }
                     else
                     {
                        skipDepth++;
                     }
                  }
               }
               else if(name.length == 0)
               {
                  if(tok == "<" || tok.charAt(0) != "<")
                  {
                     hbText(tok);
                  }
               }
               else if(closing)
               {
                  hbClose(name);
               }
               else if(HB_DROP[name] != null)
               {
                  if(tok.substr(tok.length - 2) != "/>")
                  {
                     skipTag = name;
                     skipDepth = 1;
                  }
               }
               else
               {
                  hbOpen(name,String(m[3]));
               }
            }
            hbPushBlock();
         }
         catch(e:Error)
         {
            hbOut = [];
            pushText(hbOut,decodeEntities(body.replace(/<[^>]*>/g,"")));
         }
         result = hbOut;
         hbOut = null;
         hbStack = null;
         return result;
      }

      private static function hbPush(param1:String, param2:String, param3:String, param4:String = null) : Object
      {
         if(hbStack.length >= 32)
         {
            return null;
         }
         hbBuf += param2;
         var _loc1_:Object = {
            "tag":param1,
            "close":param3,
            "reopen":(param4 == null ? param2 : param4),
            "start":hbBuf.length,
            "cnt":{}
         };
         hbStack.push(_loc1_);
         return _loc1_;
      }

      private static function hbPushBlock() : void
      {
         var _loc5_:* = 0;
         var _loc6_:Object = null;
         var _loc12_:String = hbBuf;
         var _loc4_:String = "";
         _loc5_ = int(hbStack.length - 1);
         while(_loc5_ >= 0)
         {
            _loc12_ += hbStack[_loc5_].close;
            _loc5_--;
         }
         _loc5_ = 0;
         while(_loc5_ < hbStack.length)
         {
            _loc6_ = hbStack[_loc5_];
            _loc4_ += _loc6_.reopen;
            if(_loc6_.tag == "li")
            {
               _loc6_.close = "";
               _loc6_.reopen = "";
            }
            _loc5_++;
         }
         hbBuf = _loc4_;
         hbEdge = true;
         _loc12_ = _loc12_.replace(/^(?:<br>|<p[^>]*><\/p>)+/i,"").replace(/(?:<br>|<p[^>]*><\/p>)+$/i,"");
         if(/[^\s ]/.test(_loc12_.replace(/<[^>]*>/g,"")))
         {
            hbOut.push({
               "t":"text",
               "html":_loc12_
            });
         }
      }

      private static function hbText(param1:String) : void
      {
         var _loc4_:String = decodeEntities(param1);
         var _loc5_:Boolean = Boolean(hbInStack("pre"));
         if(_loc5_)
         {
            _loc4_ = _loc4_.replace(/\r\n|\r/g,"\n");
         }
         else
         {
            _loc4_ = _loc4_.replace(/[ \t\r\n\f]+/g," ");
            if(hbEdge)
            {
               _loc4_ = _loc4_.replace(/^ +/,"");
            }
         }
         if(_loc4_.length == 0)
         {
            return;
         }
         var _loc6_:String = esc(_loc4_);
         if(_loc5_)
         {
            _loc6_ = _loc6_.split("\n").join("<br>");
         }
         hbBuf += _loc6_;
         hbEdge = false;
      }

      private static function hbInStack(param1:String) : Boolean
      {
         var _loc4_:* = int(hbStack.length - 1);
         while(_loc4_ >= 0)
         {
            if(hbStack[_loc4_].tag == param1)
            {
               return true;
            }
            _loc4_--;
         }
         return false;
      }

      private static function hbClose(param1:String) : void
      {
         var _loc5_:* = 0;
         var _loc6_:Object = null;
         var _loc4_:int = -1;
         _loc5_ = int(hbStack.length - 1);
         while(_loc5_ >= 0)
         {
            if(hbStack[_loc5_].tag == param1)
            {
               _loc4_ = _loc5_;
               break;
            }
            _loc5_--;
         }
         if(_loc4_ < 0)
         {
            return;
         }
         while(hbStack.length > _loc4_)
         {
            _loc6_ = hbStack.pop();
            if((_loc6_.tag == "p" || _loc6_.tag == "div") && hbBuf.substr(_loc6_.start) == "<br>")
            {
               hbBuf = hbBuf.substr(0,_loc6_.start);
            }
            hbBuf += _loc6_.close;
            if(HB_BLOCK[_loc6_.tag] != null)
            {
               hbEdge = true;
            }
         }
      }

      private static function hbOpen(param1:String, param2:String) : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc10_:Object = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc5_:String = attr(param2,"class");
         var _loc6_:String = attr(param2,"style");
         var _loc11_:Object = hbStack.length > 0 ? hbStack[hbStack.length - 1] : null;
         if(param1 == "br")
         {
            hbBuf += "<br>";
            hbEdge = true;
            return;
         }
         if(param1 == "img")
         {
            _loc7_ = attr(param2,"src");
            if(hbImgs < 5 && Boolean(IMG_URL_RE.test(_loc7_)))
            {
               hbPushBlock();
               hbOut.push({
                  "t":"img",
                  "url":_loc7_
               });
               ++hbImgs;
            }
            return;
         }
         if(HB_VOID[param1] != null)
         {
            return;
         }
         if((param1 == "p" || param1 == "li") && _loc11_ != null && _loc11_.tag == param1)
         {
            hbClose(param1);
         }
         switch(param1)
         {
            case "p":
            case "div":
               _loc1_ = int(indentOf(_loc5_));
               _loc2_ = (_loc1_ > 0 ? tfOpen(_loc1_) : "") + "<p" + alignAttr(_loc5_,_loc6_) + ">";
               _loc3_ = "</p>" + (_loc1_ > 0 ? "</textformat>" : "");
               break;
            case "h1":
            case "h2":
            case "h3":
            case "h4":
            case "h5":
            case "h6":
               _loc1_ = int(indentOf(_loc5_));
               _loc2_ = (_loc1_ > 0 ? tfOpen(_loc1_) : "") + "<p" + alignAttr(_loc5_,_loc6_) + "><font size=\"" + HB_SIZES[int(param1.charAt(1)) - 1] + "\"><b>";
               _loc3_ = "</b></font></p>" + (_loc1_ > 0 ? "</textformat>" : "");
               break;
            case "strong":
            case "b":
               _loc2_ = "<b>";
               _loc3_ = "</b>";
               break;
            case "em":
            case "i":
               _loc2_ = "<i>";
               _loc3_ = "</i>";
               break;
            case "u":
               _loc2_ = "<u>";
               _loc3_ = "</u>";
               break;
            case "span":
               _loc2_ = fontOpen(_loc5_,_loc6_);
               _loc3_ = _loc2_.length > 0 ? "</font>" : "";
               break;
            case "ul":
            case "ol":
               if(_loc11_ != null && _loc11_.tag == "li" && _loc11_.close.length > 0)
               {
                  hbBuf += _loc11_.close;
                  _loc11_.close = "";
               }
               _loc2_ = "";
               _loc3_ = "";
               break;
            case "li":
               _loc2_ = liOpen(param2,_loc5_);
               _loc3_ = _loc2_.indexOf("<li>") >= 0 ? "</li>" : "</p></textformat>";
               if(_loc2_.indexOf("<textformat blockindent") == 0)
               {
                  _loc3_ += "</textformat>";
               }
               break;
            case "blockquote":
               _loc2_ = "<textformat blockindent=\"14\"><p><font color=\"#6B4E2E\"><i>";
               _loc3_ = "</i></font></p></textformat>";
               break;
            case "pre":
               _loc2_ = "<p><font face=\"_typewriter\">";
               _loc3_ = "</font></p>";
               break;
            case "code":
               _loc2_ = "<font face=\"_typewriter\">";
               _loc3_ = "</font>";
               break;
            case "a":
               _loc8_ = attr(param2,"href");
               if(/^https?:\/\/[^\s"'<>\[\]]+$/i.test(_loc8_))
               {
                  _loc2_ = "<a href=\"event:" + _loc8_.split("&").join("&amp;") + "\"><u><font color=\"#1A4F8B\">";
                  _loc3_ = "</font></u></a>";
               }
               else
               {
                  _loc2_ = "";
                  _loc3_ = "";
               }
               break;
            default:
               _loc2_ = "";
               _loc3_ = "";
         }
         _loc10_ = hbPush(param1,_loc2_,_loc3_,param1 == "li" ? "" : null);
         if(_loc10_ != null && HB_BLOCK[param1] != null)
         {
            hbEdge = true;
         }
      }

      private static function liOpen(param1:String, param2:String) : String
      {
         var _loc1_:* = 0;
         var _loc7_:String = null;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         _loc1_ = int(hbStack.length - 1);
         while(_loc1_ >= 0)
         {
            _loc7_ = hbStack[_loc1_].tag;
            if(_loc7_ == "ul" || _loc7_ == "ol")
            {
               if(_loc5_ == null)
               {
                  _loc5_ = hbStack[_loc1_];
               }
               _loc6_++;
            }
            _loc1_--;
         }
         var _loc2_:String = attr(param1,"data-list").toLowerCase();
         var _loc3_:Boolean = _loc2_.length > 0 ? _loc2_ == "ordered" : _loc5_ != null && _loc5_.tag == "ol";
         var _loc10_:int = indentOf(param2) + (_loc6_ > 1 ? _loc6_ - 1 : 0);
         if(_loc10_ > 8)
         {
            _loc10_ = 8;
         }
         var _loc11_:Object = _loc5_ != null ? _loc5_.cnt : {};
         if(_loc3_)
         {
            _loc11_[_loc10_] = int(_loc11_[_loc10_]) + 1;
         }
         else
         {
            _loc11_[_loc10_] = 0;
         }
         _loc1_ = int(_loc10_ + 1);
         while(_loc1_ <= 8)
         {
            _loc11_[_loc1_] = 0;
            _loc1_++;
         }
         if(_loc3_)
         {
            return "<textformat leftmargin=\"" + (20 * _loc10_ + 18) + "\" indent=\"-18\"><p>" + _loc11_[_loc10_] + ". ";
         }
         return (_loc10_ > 0 ? tfOpen(_loc10_) : "") + "<li>";
      }

      private static function tfOpen(param1:int) : String
      {
         return "<textformat blockindent=\"" + 20 * param1 + "\">";
      }

      private static function indentOf(param1:String) : int
      {
         var _loc4_:Object = /ql-indent-(\d+)/.exec(param1);
         if(_loc4_ == null)
         {
            return 0;
         }
         var _loc5_:int = int(_loc4_[1]);
         return _loc5_ > 8 ? 8 : _loc5_;
      }

      private static function alignAttr(param1:String, param2:String) : String
      {
         var _loc5_:Object = /ql-align-(center|right|justify)/.exec(param1);
         if(_loc5_ == null)
         {
            _loc5_ = /text-align\s*:\s*(center|right|justify|left)/i.exec(param2);
         }
         if(_loc5_ == null)
         {
            return "";
         }
         return " align=\"" + String(_loc5_[1]).toLowerCase() + "\"";
      }

      private static function fontOpen(param1:String, param2:String) : String
      {
         var _loc5_:String = "";
         var _loc6_:int = 0;
         var _loc1_:Object = /(?:^|;)\s*color\s*:\s*([^;]+)/i.exec(param2);
         if(_loc1_ != null)
         {
            _loc5_ = colorOf(String(_loc1_[1]));
         }
         _loc1_ = /font-size\s*:\s*(\d+(?:\.\d+)?)px/i.exec(param2);
         if(_loc1_ != null)
         {
            _loc6_ = Math.round(Number(_loc1_[1]));
         }
         else if(/ql-size-small/.test(param1))
         {
            _loc6_ = 10;
         }
         else if(/ql-size-large/.test(param1))
         {
            _loc6_ = 18;
         }
         else if(/ql-size-huge/.test(param1))
         {
            _loc6_ = 24;
         }
         if(_loc6_ > 0)
         {
            _loc6_ = Math.max(9,Math.min(28,_loc6_));
         }
         if(_loc5_.length == 0 && _loc6_ == 0)
         {
            return "";
         }
         return "<font" + (_loc5_.length > 0 ? " color=\"" + _loc5_ + "\"" : "") + (_loc6_ > 0 ? " size=\"" + _loc6_ + "\"" : "") + ">";
      }

      private static function colorOf(param1:String) : String
      {
         var _loc4_:String = param1.replace(/^\s+|\s+$/g,"");
         var _loc5_:Object = /^#([0-9a-f]{6})$/i.exec(_loc4_);
         if(_loc5_ != null)
         {
            return "#" + String(_loc5_[1]).toUpperCase();
         }
         _loc5_ = /^#([0-9a-f])([0-9a-f])([0-9a-f])$/i.exec(_loc4_);
         if(_loc5_ != null)
         {
            return ("#" + _loc5_[1] + _loc5_[1] + _loc5_[2] + _loc5_[2] + _loc5_[3] + _loc5_[3]).toUpperCase();
         }
         _loc5_ = /^rgba?\(\s*(\d{1,3})[\s,]+(\d{1,3})[\s,]+(\d{1,3})/i.exec(_loc4_);
         if(_loc5_ != null)
         {
            return "#" + hex2(int(_loc5_[1])) + hex2(int(_loc5_[2])) + hex2(int(_loc5_[3]));
         }
         return "";
      }

      private static function hex2(param1:int) : String
      {
         var _loc4_:int = Math.max(0,Math.min(255,param1));
         var _loc5_:String = _loc4_.toString(16).toUpperCase();
         return _loc5_.length < 2 ? "0" + _loc5_ : _loc5_;
      }

      private static function attr(param1:String, param2:String) : String
      {
         var _loc5_:Object = new RegExp("(?:^|\\s)" + param2 + "\\s*=\\s*(?:\"([^\"]*)\"|\'([^\']*)\'|([^\\s\"\'>]+))","i").exec(param1);
         if(_loc5_ == null)
         {
            return "";
         }
         return decodeEntities(String(_loc5_[1] || _loc5_[2] || _loc5_[3] || ""));
      }

      private static function esc(param1:String) : String
      {
         return param1.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;").split("\"").join("&quot;");
      }

      private static function decodeEntities(param1:String) : String
      {
         return param1.replace(/&(#x[0-9a-fA-F]+|#[0-9]+|[a-zA-Z]+);/g,entityReplacer);
      }

      private static function entityReplacer(param1:String, param2:String, param3:int, param4:String) : String
      {
         var _loc1_:Number = -1;
         if(param2.charAt(0) == "#")
         {
            _loc1_ = param2.charAt(1).toLowerCase() == "x" ? Number(parseInt(param2.substr(2),16)) : Number(parseInt(param2.substr(1),10));
         }
         else
         {
            switch(param2.toLowerCase())
            {
               case "amp":
                  _loc1_ = 38;
                  break;
               case "lt":
                  _loc1_ = 60;
                  break;
               case "gt":
                  _loc1_ = 62;
                  break;
               case "quot":
                  _loc1_ = 34;
                  break;
               case "apos":
                  _loc1_ = 39;
                  break;
               case "nbsp":
                  _loc1_ = 160;
                  break;
               default:
                  return param1;
            }
         }
         if(Boolean(isNaN(_loc1_)) || _loc1_ > 65535 || _loc1_ >= 55296 && _loc1_ <= 57343)
         {
            return "";
         }
         if(_loc1_ < 32)
         {
            return " ";
         }
         return String.fromCharCode(_loc1_);
      }

      public static function itemLinkage(param1:Object) : String
      {
         var t:String = null;
         var o:Object = param1;
         var s:String = "";
         try
         {
            t = String(o.sType).toLowerCase();
            if(t == "serveruse" || t == "clientuse")
            {
               s = o.sFile != null && String(o.sFile).length > 0 ? String(o.sFile) : String(o.sIcon);
            }
            else if(o.sIcon == null || o.sIcon == "" || o.sIcon == "none")
            {
               s = o.sLink != null && String(o.sLink).toLowerCase() != "none" ? "iidesign" : "iibag";
            }
            else
            {
               s = String(o.sIcon);
            }
         }
         catch(e:Error)
         {
            s = "";
         }
         return s;
      }

      public static function icon(param1:MovieClip, param2:String) : DisplayObject
      {
         var c:Class = null;
         var d:DisplayObject = null;
         var mc:MovieClip = null;
         var rootClass:MovieClip = param1;
         var link:String = param2;
         if(link == null || link.length == 0)
         {
            return null;
         }
         try
         {
            c = iconClassCache[link] as Class;
            if(c == null)
            {
               try
               {
                  c = getDefinitionByName(link) as Class;
               }
               catch(e1:Error)
               {
                  c = null;
               }
               if(c == null && rootClass != null && rootClass.world != null)
               {
                  try
                  {
                     c = rootClass.world.getClass(link) as Class;
                  }
                  catch(e2:Error)
                  {
                     c = null;
                  }
               }
               if(c != null)
               {
                  iconClassCache[link] = c;
               }
            }
            if(c == null)
            {
               return null;
            }
            d = new c() as DisplayObject;
            if(d == null)
            {
               return null;
            }
            if(d is MovieClip)
            {
               mc = MovieClip(d);
               mc.gotoAndStop(1);
               mc.mouseEnabled = false;
               mc.mouseChildren = false;
            }
            return d;
         }
         catch(e:Error)
         {
            return null;
         }
      }
   }
}
