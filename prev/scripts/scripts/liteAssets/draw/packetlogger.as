package liteAssets.draw
{
   import fl.controls.TextArea;
   import fl.controls.TextInput;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol158")]
   public class packetlogger extends MovieClip
   {

      public var btnClose:MovieClip;

      public var input:TextInput;

      public var output:TextArea;

      private var tf:TextFormat = new TextFormat();

      public var r:MovieClip;

      private var alwaysOn:Boolean = false;

      private var scrToBottom:Boolean = false;

      private var jsonLimit:int = 0;

      private var whiteSpace:RegExp = /\s{2,}/gim;

      private var tabPos:int = 0;

      private var separator:RegExp = /[%]+/gim;

      private var gdq:RegExp = /[&quot;]+/gim;

      private var gtrue:RegExp = /[true]+/gim;

      private var gfalse:RegExp = /[false]+/gim;

      public function packetlogger(param1:MovieClip)
      {
         super();
         this.visible = false;
         this.r = param1;
         this.r.stage.addChild(this);
         this.name = "packetlogger";
         this.tf.font = "Arial";
         this.tf.size = 18;
         this.output.setStyle("textFormat",this.tf);
         this.tf.size = 25;
         this.input.setStyle("textFormat",this.tf);
         var _loc1_:Shape = new Shape();
         _loc1_.graphics.beginFill(16777215,0.9);
         _loc1_.graphics.drawRect(0,0,960,500);
         _loc1_.graphics.endFill();
         var _loc2_:* = new MovieClip();
         _loc2_.addChild(_loc1_);
         this.output.setStyle("upSkin",_loc2_);
         _loc1_ = new Shape();
         _loc1_.graphics.beginFill(16777215,0.9);
         _loc1_.graphics.drawRect(0,0,960,40);
         _loc1_.graphics.endFill();
         _loc2_ = new MovieClip();
         _loc2_.addChild(_loc1_);
         this.input.setStyle("upSkin",_loc2_);
         this.input.addEventListener(KeyboardEvent.KEY_DOWN,this.onInput,false,0,true);
         this.btnClose.addEventListener(MouseEvent.CLICK,this.onHide,false,0,true);
      }

      public function onHide(param1:MouseEvent) : void
      {
         this.visible = false;
         this.toggle();
      }

      public function onInput(param1:KeyboardEvent) : void
      {
         var _loc1_:String = null;
         if(param1.keyCode == 13)
         {
            _loc1_ = this.input.text.replace(this.whiteSpace,"");
            if(_loc1_.indexOf("/setlimit") == 0)
            {
               this.regular("This command is currently disabled");
            }
            else
            {
               switch(_loc1_)
               {
                  case "/help":
                     this.regular("\tCOMMANDS ---");
                     this.regular("\t/help - COMMANDS");
                     this.regular("\t/autoscr - AUTO SCROLL TO BOTTOM (DEFAULT: OFF)");
                     this.regular("\t/clear - CLEARS SCREEN");
                     this.regular("\t/hide - HIDES SCREEN");
                     this.regular("\t/alwayson - ALWAYS LOG EVEN IF HIDDEN");
                     this.regular("\tENTERING ANYTHING WILL SEND TO THE SERVER");
                     break;
                  case "/alwayson":
                     this.alwaysOn = !this.alwaysOn;
                     this.regular("\tALWAYS ON SET TO: " + this.alwaysOn);
                     break;
                  case "/autoscr":
                     this.scrToBottom = !this.scrToBottom;
                     this.regular("\tAUTO SCROLL TO BOTTOM SET TO: " + this.scrToBottom);
                     break;
                  case "/getlimit":
                     this.regular("\tJSON PRETTY PRINT STRING LIMIT -- " + this.jsonLimit + " CHARACTERS");
                     break;
                  case "/clear":
                     this.output.text = "";
                     break;
                  case "/hide":
                     this.visible = false;
                     this.toggle();
                     break;
                  default:
                     if(this.r.world.myAvatar.isStaff())
                     {
                        this.r.sfc.sendString(this.input.text);
                        this.regular("\tSENT TO SERVER: " + this.input.text);
                     }
               }
            }
            this.input.text = "";
            if(this.scrToBottom)
            {
               this.output.verticalScrollPosition = this.output.maxVerticalScrollPosition;
            }
         }
      }

      public function cleanup() : void
      {
         if(this.parent as MovieClip != null)
         {
            (this.parent as MovieClip).removeChild(this);
         }
         this.input.removeEventListener(KeyboardEvent.KEY_DOWN,this.onInput);
         this.r.sfc.removeEventListener("onDebugMessage",this.onLogger);
         this.r.sfc.debug = false;
         this.r.pLoggerUI = null;
      }

      public function getTabs() : String
      {
         var _loc3_:* = "";
         var _loc1_:int = 0;
         while(_loc1_ < this.tabPos)
         {
            _loc3_ += "    ";
            _loc1_++;
         }
         return _loc3_;
      }

      public function color(param1:String, param2:String) : String
      {
         return "<font face=\"Arial\" size=\"20\" color=\"" + param2 + "\">" + param1 + "</font>";
      }

      public function tab(param1:String) : void
      {
         this.output.htmlText += "<font face=\"Arial\" size=\"20\">" + this.getTabs() + param1 + "</font>";
         if(this.scrToBottom)
         {
            this.output.verticalScrollPosition = this.output.textField.maxScrollV;
         }
      }

      public function noTab(param1:String) : void
      {
         this.output.htmlText += "<font face=\"Arial\" size=\"20\">" + param1 + "</font>";
         if(this.scrToBottom)
         {
            this.output.verticalScrollPosition = this.output.textField.maxScrollV;
         }
      }

      public function regular(param1:String) : void
      {
         this.output.appendText(param1 + "\n");
      }

      public function parse(param1:*) : String
      {
         var _loc2_:* = undefined;
         var _loc4_:* = undefined;
         ++this.tabPos;
         var _loc1_:int = 0;
         for(_loc2_ in param1)
         {
            _loc1_++;
         }
         if(_loc1_ == 0)
         {
            --this.tabPos;
            return " {}";
         }
         var _loc5_:int = 0;
         var _loc6_:String = " {\n";
         for(_loc4_ in param1)
         {
            _loc6_ += this.getTabs() + ("\"" + this.color(_loc4_,"#BF40BF") + "\":");
            if(param1[_loc4_] is String)
            {
               _loc6_ += " \"" + this.color(param1[_loc4_],"#FF0000") + "\"";
            }
            else if(param1[_loc4_] is Number || param1[_loc4_] is Boolean)
            {
               _loc6_ += " " + this.color(param1[_loc4_],"#FF0000");
            }
            else if(param1[_loc4_] is Object || param1[_loc4_] is Array)
            {
               _loc6_ += this.parse(param1[_loc4_]);
            }
            else
            {
               _loc6_ += " " + this.color(param1[_loc4_],"#FF0000");
            }
            if(_loc5_ + 1 != _loc1_)
            {
               _loc6_ += ",";
            }
            _loc6_ += "\n";
            _loc5_++;
         }
         --this.tabPos;
         return _loc6_ + (this.getTabs() + "}");
      }

      internal function raw_parse(param1:*) : String
      {
         var _loc2_:* = undefined;
         var _loc4_:* = undefined;
         ++this.tabPos;
         var _loc1_:int = 0;
         for(_loc2_ in param1)
         {
            _loc1_++;
         }
         if(_loc1_ == 0)
         {
            --this.tabPos;
            return " {}";
         }
         var _loc5_:int = 0;
         var _loc6_:String = " {\n";
         for(_loc4_ in param1)
         {
            _loc6_ += this.getTabs() + ("\"" + _loc4_ + "\":");
            if(param1[_loc4_] is String)
            {
               _loc6_ += " \"" + param1[_loc4_] + "\"";
            }
            else if(param1[_loc4_] is Number || param1[_loc4_] is Boolean)
            {
               _loc6_ += " " + param1[_loc4_];
            }
            else if(param1[_loc4_] is Object || param1[_loc4_] is Array)
            {
               _loc6_ += this.raw_parse(param1[_loc4_]);
            }
            else
            {
               _loc6_ += " " + param1[_loc4_];
            }
            if(_loc5_ + 1 != _loc1_)
            {
               _loc6_ += ",";
            }
            _loc6_ += "\n";
            _loc5_++;
         }
         --this.tabPos;
         return _loc6_ + (this.getTabs() + "}");
      }

      private function fixHTML(param1:String) : String
      {
         var _loc1_:RegExp = /[<]+/gim;
         var _loc2_:RegExp = /[>]+/gim;
         var _loc5_:RegExp = /[&]+/gim;
         var _loc6_:RegExp = /["]+/gim;
         var _loc4_:RegExp = /[']+/gim;
         param1 = param1.replace(_loc1_,"&lt;");
         param1 = param1.replace(_loc2_,"&gt;");
         param1 = param1.replace(_loc5_,"&amp;");
         param1 = param1.replace(_loc6_,"&quot;");
         return param1.replace(_loc4_,"&apos;");
      }

      public function onLogger(param1:*) : void
      {
         var _loc2_:* = undefined;
         var _loc1_:* = param1.params.message;
         if(_loc1_.indexOf("[ RECEIVED ]:") == 0)
         {
            _loc2_ = _loc1_.substr(_loc1_.indexOf("]: ") + 3,_loc1_.lastIndexOf(", (len:") - 14) + "\n";
            if(_loc2_.length > this.jsonLimit)
            {
               if(_loc2_.indexOf("%") != -1)
               {
                  this.regular("\t" + _loc2_);
               }
               else
               {
                  this.regular(this.raw_parse(JSON.parse(_loc2_)));
               }
            }
            else
            {
               this.noTab(this.parse(JSON.parse(_loc2_)));
            }
            this.tabPos = 0;
         }
         else
         {
            _loc2_ = _loc1_.substr(_loc1_.indexOf("]: ") + 3,_loc1_.length);
            if(_loc2_.length > this.jsonLimit)
            {
               this.regular("\t" + _loc2_);
            }
            else
            {
               if(_loc2_.indexOf("%") != -1 && _loc2_.length <= this.jsonLimit)
               {
                  _loc2_ = this.fixHTML(_loc2_);
                  _loc2_ = this.color(_loc2_,"#BF40BF");
                  _loc2_ = _loc2_.replace(this.separator,this.color("%","#FF0000"));
               }
               this.noTab("<br>" + _loc2_);
            }
         }
         if(this.scrToBottom)
         {
            this.output.verticalScrollPosition = this.output.maxVerticalScrollPosition;
         }
      }

      public function toggle() : void
      {
         this.r.stage.focus = null;
         if(!this.alwaysOn)
         {
            if(this.visible)
            {
               this.r.sfc.addEventListener("onDebugMessage",this.onLogger,false,0,true);
               this.r.sfc.debug = true;
            }
            else
            {
               this.r.sfc.removeEventListener("onDebugMessage",this.onLogger);
               this.r.sfc.debug = false;
            }
         }
      }
   }
}
