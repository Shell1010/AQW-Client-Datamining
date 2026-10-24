package liteAssets.draw
{
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;

   public class MinigameSkip
   {

      private static var game:MovieClip;

      private static var games:Array;

      private static var btn:MovieClip;

      private static var cur:Object;

      private static var done:Object;

      private static var extKey:String = "";

      public function MinigameSkip()
      {
         super();
      }

      public static function init(param1:MovieClip) : void
      {
         if(game != null)
         {
            return;
         }
         game = param1;
         games = table();
         var _loc1_:Timer = new Timer(300);
         _loc1_.addEventListener(TimerEvent.TIMER,onTick,false,0,true);
         _loc1_.start();
      }

      public static function noteExt(param1:String) : void
      {
         var _loc1_:String = String(param1).toLowerCase().split("?")[0];
         var _loc2_:int = _loc1_.indexOf("/maps/");
         if(_loc2_ > -1)
         {
            _loc1_ = _loc1_.substr(_loc2_ + 6);
         }
         while(_loc1_.charAt(0) == "/")
         {
            _loc1_ = _loc1_.substr(1);
         }
         if(_loc1_.indexOf("maps/") == 0)
         {
            _loc1_ = _loc1_.substr(5);
         }
         extKey = _loc1_;
      }

      private static function qv(param1:Object, param2:int) : int
      {
         return int(param1.getQuestValue(param2));
      }

      private static function prog(param1:Object, param2:int) : Boolean
      {
         return Boolean(param1.isQuestInProgress(param2));
      }

      private static function turnInLater(param1:Object, param2:int) : void
      {
         var w:Object = param1;
         var q:int = param2;
         setTimeout(function():void
         {
            try
            {
               w.tryQuestComplete(q);
            }
            catch(e:Error)
            {
            }
         },3000);
      }

      private static function cell(param1:String, param2:String, param3:int, param4:int, param5:Boolean, param6:int, param7:int, param8:int, param9:String = null, param10:String = null) : Object
      {
         var map:String = param1;
         var c:String = param2;
         var slot:int = param3;
         var val:int = param4;
         var below:Boolean = param5;
         var progQ:int = param6;
         var item:int = param7;
         var turnIn:int = param8;
         var exitCell:String = param9;
         var exitPad:String = param10;
         return {
            "map":map,
            "cell":c.toLowerCase(),
            "when":function(param1:Object):Boolean
            {
               if(slot > 0 && !(below ? qv(param1,slot) < val : qv(param1,slot) == val))
               {
                  return false;
               }
               return progQ <= 0 || Boolean(prog(param1,progQ));
            },
            "run":function(param1:Object):void
            {
               if(item > 0)
               {
                  param1.getMapItem(item);
               }
               if(turnIn > 0)
               {
                  turnInLater(param1,turnIn);
               }
               if(exitCell != null)
               {
                  param1.moveToCell(exitCell,exitPad);
               }
            }
         };
      }

      private static function table() : Array
      {
         return [{
            "ext":"minigames/aqwcartgame.swf",
            "run":function(param1:Object):void
            {
               try
               {
                  param1.map.resetGems();
               }
               catch(e:Error)
               {
               }
               param1.getMapItem(58);
            }
         },{
            "ext":"minigames/aqwdragonrider.swf",
            "run":function(param1:Object):void
            {
            }
         },{
            "ext":"events/mogloween2015/minigame/arrowgame.swf",
            "when":function(param1:Object):Boolean
            {
               return qv(param1,97) == 3;
            },
            "run":function(param1:Object):void
            {
               param1.tryQuestComplete(4601);
               param1.moveToCell("Enter","Spawn");
            }
         },{
            "ext":"sandsea/carpetchase.swf",
            "when":carpet,
            "run":function(param1:Object):void
            {
               param1.map.checkQS();
            }
         },{
            "ext":"sandsea/carpetchase-r1.swf",
            "when":carpet,
            "run":function(param1:Object):void
            {
               param1.map.checkQS();
            }
         },{
            "ext":"skyguard/airshipchase.swf",
            "run":function(param1:Object):void
            {
               param1.getMapItem(559);
            }
         },{
            "ext":"sepulchure/aqwdragonriderseppy.swf",
            "run":function(param1:Object):void
            {
               param1.getMapItem(5910);
               param1.tryQuestComplete(6400);
            }
         },{
            "ext":"northlands/game-icedoorr1.swf",
            "run":function(param1:Object):void
            {
               param1.map.wonCoder();
            }
         },{
            "ext":"swordhaven/game-castledefense.swf",
            "when":function(param1:Object):Boolean
            {
               return qv(param1,131) == 12 && Boolean(prog(param1,3092));
            },
            "run":function(param1:Object):void
            {
               if(!param1.myAvatar.checkTempItem(1957,1))
               {
                  param1.getMapItem(1957);
               }
               turnInLater(param1,3092);
               cutTarget(param1);
            }
         },{
            "ext":"throneofdarkness/mysteriousdungeon/jailgame.swf",
            "run":function(param1:Object):void
            {
               param1.getMapItem(4818);
               param1.tryQuestComplete(5438);
               game.loadExternalSWF("ThroneOfDarkness/MysteriousDungeon/Cutscene-Mysterious-Mini1.swf");
               param1.moveToCell("r2","Left");
            }
         },{
            "ext":"events/newyear/2017-18/dogsledrace.swf",
            "when":function(param1:Object):Boolean
            {
               return prog(param1,6146);
            },
            "run":function(param1:Object):void
            {
               param1.getMapItem(5568);
               param1.tryQuestComplete(6146);
            }
         },{
            "ext":"skyguard/dogsledrace.swf",
            "when":function(param1:Object):Boolean
            {
               return qv(param1,259) == 2 && Boolean(prog(param1,6146));
            },
            "run":function(param1:Object):void
            {
               param1.map.checkQS();
            }
         },{
            "ext":"giant/mini-tablerace.swf",
            "when":function(param1:Object):Boolean
            {
               return qv(param1,29) == 10;
            },
            "run":function(param1:Object):void
            {
               param1.map.callQuest();
            }
         },{
            "ext":"j6/minigame1a.swf",
            "when":function(param1:Object):Boolean
            {
               return qv(param1,28) == 11;
            },
            "run":function(param1:Object):void
            {
               param1.tryQuestComplete(2169);
               param1.moveToCell("r3","Left");
            }
         },{
            "ext":"j6/minigame2r1.swf",
            "when":function(param1:Object):Boolean
            {
               return qv(param1,28) == 12;
            },
            "run":function(param1:Object):void
            {
               param1.tryQuestComplete(2170);
               game.loadExternalSWF("J6/J6Chapter4CutE.swf");
               param1.moveToCell("Cut4","Left");
            }
         },{
            "ext":"j6/minigame3.swf",
            "when":function(param1:Object):Boolean
            {
               return qv(param1,28) == 13;
            },
            "run":function(param1:Object):void
            {
               param1.tryQuestComplete(2171);
               game.loadExternalSWF("J6/J6Chapter4CutH.swf");
               param1.moveToCell("Cut5","Left");
            }
         },{
            "ext":"j6/j6quizgame.swf",
            "when":function(param1:Object):Boolean
            {
               return !param1.myAvatar.isItemInInventory("Coordinates to Hyperium");
            },
            "run":function(param1:Object):void
            {
               param1.getMapItem(109);
               if(qv(param1,28) == 0)
               {
                  param1.tryQuestComplete(674);
               }
            }
         },{
            "ext":"events/voltaire/bunnygame.swf",
            "when":function(param1:Object):Boolean
            {
               return qv(param1,74) == 12;
            },
            "run":function(param1:Object):void
            {
               param1.tryQuestComplete(2021);
               game.loadExternalSWF("events/voltaire/Cutscene-Voltaire12b-05.swf");
            }
         },{
            "ext":"throneofdarkness/towerofmirrors/mirrorgame/mirrorgame.swf",
            "when":function(param1:Object):Boolean
            {
               return qv(param1,211) == 7;
            },
            "run":function(param1:Object):void
            {
               if(!param1.myAvatar.checkTempItem(36147,1))
               {
                  param1.getMapItem(4682);
               }
               if(param1.cHandle != null)
               {
                  param1.cHandle.transfer();
               }
            }
         },{
            "ext":"doomwood/necrogame/necrogame-r2.swf",
            "when":necroLeft,
            "run":necro
         },{
            "ext":"doomwood/necrogame/necrogame.swf",
            "when":necroLeft,
            "run":necro
         },{
            "ext":"darkovia/zorbakcon/snuffasneevilsheep.swf",
            "when":function(param1:Object):Boolean
            {
               return qv(param1,213) == 12;
            },
            "run":function(param1:Object):void
            {
               param1.getMapItem(4726);
               turnInLater(param1,5369);
            }
         },{
            "map":"cornelis",
            "front":"lockgame",
            "when":function(param1:Object):Boolean
            {
               return qv(param1,66) == 6 && !param1.map.bMap;
            },
            "run":function(param1:Object):void
            {
               if(String(param1.map.currentLabel) != "Vault1")
               {
                  return;
               }
               param1.map.bMap = true;
               game.MsgBox.notify("You did it! The door is now open.");
               param1.moveToCell("Vault1","Left");
            }
         },{
            "ext":"thespan/minigame-iadoa-r1.swf",
            "when":function(param1:Object):Boolean
            {
               return Boolean(prog(param1,2505)) && !param1.myAvatar.checkTempItem(15016,3);
            },
            "run":function(param1:Object):void
            {
               var _loc1_:* = param1.myAvatar;
               param1.moveToCell(_loc1_.checkTempItem(15016,2) ? "p3" : (_loc1_.checkTempItem(15016,1) ? "p2" : "p1"),"Left");
            }
         },{
            "map":"saloon",
            "front":"apop",
            "keep":true,
            "when":function(param1:Object):Boolean
            {
               return !param1.map.checkArray(2) && rps(param1) != null;
            },
            "run":function(param1:Object):void
            {
               var _loc1_:* = rps(param1);
               param1.map.updateArray(2);
               if(_loc1_ != null)
               {
                  _loc1_.gotoAndStop("Win");
               }
            }
         },curse(15,7093,6695,"curse1","Fizz"),curse(17,7095,6696,"curse2","Fizz"),curse(19,7097,6697,"curse3","FizzWin"),{
            "map":"puzzlebox",
            "front":"puzzlegame",
            "when":function(param1:Object):Boolean
            {
               return !param1.myAvatar.checkTempItem(53734,1);
            },
            "run":function(param1:Object):void
            {
               param1.getMapItem(7165);
               param1.attachMovieFront("Solve");
            }
         },{
            "map":"cask",
            "front":"puzzlegame",
            "when":function(param1:Object):Boolean
            {
               return prog(param1,3843);
            },
            "run":function(param1:Object):void
            {
               param1.getMapItem(2952);
               turnInLater(param1,3843);
            }
         },cell("asylumcatacombs","Lock",95,11,true,2464,1533,2464),cell("brightfortress","Lock",0,0,false,4456,3649,4456),cell("dualplane","Lock",357,11,true,7570,7460,7570),cell("greed","DisarmGame",243,6,true,5939,5377,0,"r9a","Left"),cell("merrowtrench","Lock",321,9,true,7082,6691,7082),cell("tachyon","Game1",99,20,false,5073,4448,5073),cell("tachyon","Game2",99,24,false,5077,4452,5077),cell("tachyon","Game3",99,28,false,5081,4455,5081),cell("hyperspace","Game",28,22,false,0,1744,2839),cell("wormhole","Game",201,7,false,0,4428,5058),cell("meatlab","Game",332,12,false,0,6842,7212),cell("byrodax","Game",354,0,false,0,7395,0)];
      }

      private static function curse(param1:int, param2:int, param3:int, param4:String, param5:String) : Object
      {
         var val:int = param1;
         var q:int = param2;
         var item:int = param3;
         var mc:String = param4;
         var anim:String = param5;
         return {
            "map":"ghostship",
            "cell":"game",
            "when":function(param1:Object):Boolean
            {
               return qv(param1,321) == val && Boolean(prog(param1,q));
            },
            "run":function(param1:Object):void
            {
               try
               {
                  param1.map[mc].gotoAndPlay(anim);
               }
               catch(e:Error)
               {
               }
               param1.getMapItem(item);
            }
         };
      }

      private static function carpet(param1:Object) : Boolean
      {
         return qv(param1,36) == 9 && Boolean(prog(param1,971));
      }

      private static function necroLeft(param1:Object) : Boolean
      {
         var _loc1_:int = int(qv(param1,48));
         return _loc1_ >= 1 && _loc1_ <= 10;
      }

      private static function necroLocked(param1:Object) : Boolean
      {
         if(extKey.indexOf("doomwood/necrogame/necrogame") != 0 || game.mcExtSWF.numChildren == 0 || qv(param1,48) >= 1)
         {
            return false;
         }
         game.clearExternamSWF();
         game.MsgBox.notify("The elevator won\'t move until the tower\'s book quest is turned in.");
         return true;
      }

      private static function necro(param1:Object) : void
      {
         var sent:int = 0;
         var t:Timer = null;
         var w:Object = param1;
         sent = -1;
         t = new Timer(1500,30);
         var step:Function = function(param1:Event = null):void
         {
            if(game.world != w)
            {
               t.stop();
               return;
            }
            var _loc1_:int = int(qv(w,48));
            if(_loc1_ > 10)
            {
               t.stop();
               w.moveToCell("Cut1","Left");
            }
            else if(_loc1_ != sent)
            {
               sent = _loc1_;
               w.tryQuestComplete(1091 + _loc1_);
            }
         };
         t.addEventListener(TimerEvent.TIMER,step);
         step();
         t.start();
      }

      private static function cutTarget(param1:Object) : void
      {
         var _loc1_:Object = param1.map.objCutTarget;
         if(_loc1_ == null)
         {
            return;
         }
         if(_loc1_.strMap != "Reset")
         {
            if(_loc1_.strMap != "None")
            {
               param1.gotoTown(_loc1_.strMap,_loc1_.strFrame,_loc1_.strPad);
            }
            else
            {
               param1.moveToCell(_loc1_.strFrame,_loc1_.strPad);
            }
         }
         _loc1_.strMap = "Reset";
      }

      private static function mapIs(param1:Object, param2:String) : Boolean
      {
         return String(param1.strMapName).toLowerCase() == param2 || String(param1.strMapFileName).toLowerCase().indexOf(param2) > -1;
      }

      private static function findClass(param1:DisplayObjectContainer, param2:String, param3:int) : MovieClip
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         while(_loc3_ < param1.numChildren)
         {
            _loc1_ = param1.getChildAt(_loc3_);
            if(getQualifiedClassName(_loc1_).indexOf(param2) > -1)
            {
               return _loc1_ as MovieClip;
            }
            if(param3 > 0 && _loc1_ is DisplayObjectContainer)
            {
               _loc2_ = findClass(DisplayObjectContainer(_loc1_),param2,param3 - 1);
               if(_loc2_ != null)
               {
                  return _loc2_;
               }
            }
            _loc3_++;
         }
         return null;
      }

      private static function rps(param1:Object) : MovieClip
      {
         var _loc1_:MovieClip = findClass(param1.FG,"Henry_APOP",4);
         return _loc1_ != null && findClass(_loc1_,"RPSgame",1) != null ? _loc1_ : null;
      }

      private static function pass(param1:Object, param2:Object) : Boolean
      {
         return param1.when == null || Boolean(param1.when(param2));
      }

      private static function find(param1:Object) : Object
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(game.mcExtSWF != null && game.mcExtSWF.numChildren > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < games.length)
            {
               _loc1_ = games[_loc2_];
               if(_loc1_.ext == extKey && Boolean(pass(_loc1_,param1)))
               {
                  return _loc1_;
               }
               _loc2_++;
            }
            return null;
         }
         if(param1.FG != null && param1.FG.numChildren > 0)
         {
            _loc3_ = String(param1.frontFile).toLowerCase();
            _loc4_ = _loc3_.substr(_loc3_.lastIndexOf(":") + 1);
            _loc2_ = 0;
            while(_loc2_ < games.length)
            {
               _loc1_ = games[_loc2_];
               if(_loc1_.front == _loc4_ && Boolean(mapIs(param1,_loc1_.map)) && Boolean(pass(_loc1_,param1)))
               {
                  return _loc1_;
               }
               _loc2_++;
            }
            return null;
         }
         var _loc5_:String = String(param1.strFrame).toLowerCase();
         _loc2_ = 0;
         while(_loc2_ < games.length)
         {
            _loc1_ = games[_loc2_];
            if(_loc1_.cell == _loc5_ && Boolean(mapIs(param1,_loc1_.map)) && Boolean(pass(_loc1_,param1)))
            {
               return _loc1_;
            }
            _loc2_++;
         }
         return null;
      }

      private static function onTick(param1:TimerEvent) : void
      {
         var w:Object = null;
         var e:TimerEvent = param1;
         var o:Object = null;
         try
         {
            w = game.world;
            if(w != null && w.myAvatar != null && w.map != null && !necroLocked(w))
            {
               o = find(w);
               if(o != done)
               {
                  done = null;
               }
               if(o == done)
               {
                  o = null;
               }
            }
         }
         catch(err:Error)
         {
            o = null;
         }
         cur = o;
         if(o == null)
         {
            hide();
            return;
         }
         show(o.ext == null);
      }

      private static function show(param1:Boolean) : void
      {
         var _loc1_:Class = null;
         var _loc2_:Stage = game.stage;
         if(_loc2_ == null)
         {
            return;
         }
         if(btn == null)
         {
            _loc1_ = getDefinitionByName("LPFFrameGenericButton") as Class;
            btn = new _loc1_() as MovieClip;
            btn.t1.text = "";
            btn.t2.text = "Skip Minigame";
            btn.btn1.visible = false;
            btn.btn2.visible = true;
            btn.visible = true;
            btn.addEventListener(MouseEvent.CLICK,onSkip,false,10,true);
         }
         btn.x = 950 - int(btn.btn2.width);
         btn.y = param1 ? 10 : 540 - int(btn.btn2.height);
         if(btn.parent == null)
         {
            _loc2_.addChild(btn);
            btn.addEventListener(Event.ENTER_FRAME,onTop,false,0,true);
         }
      }

      private static function hide() : void
      {
         if(btn == null || btn.parent == null)
         {
            return;
         }
         btn.removeEventListener(Event.ENTER_FRAME,onTop);
         btn.parent.removeChild(btn);
      }

      private static function onTop(param1:Event) : void
      {
         var _loc1_:Stage = btn.stage;
         if(_loc1_ != null && _loc1_.getChildIndex(btn) != _loc1_.numChildren - 1)
         {
            _loc1_.setChildIndex(btn,_loc1_.numChildren - 1);
         }
      }

      private static function onSkip(param1:MouseEvent) : void
      {
         var o:Object;
         var w:Object;
         var ldrs:Array = null;
         var i:int = 0;
         var ldr:Loader = null;
         var e:MouseEvent = param1;
         e.stopImmediatePropagation();
         o = cur;
         w = game.world;
         if(o == null || w == null)
         {
            return;
         }
         try
         {
            game.mixer.playSound("Click");
         }
         catch(err0:Error)
         {
         }
         done = o;
         cur = null;
         hide();
         if(o.ext != null)
         {
            ldrs = [];
            i = 0;
            while(i < game.mcExtSWF.numChildren)
            {
               try
               {
                  ldrs.push(game.mcExtSWF.getChildAt(i).loaderInfo.loader);
               }
               catch(err:Error)
               {
               }
               i++;
            }
            game.clearExternamSWF();
            for each(ldr in ldrs)
            {
               try
               {
                  ldr.unloadAndStop(false);
               }
               catch(err2:Error)
               {
               }
            }
         }
         else if(o.front != null && !o.keep)
         {
            w.removeMovieFront();
         }
         try
         {
            o.run(w);
         }
         catch(err3:Error)
         {
            trace("[MinigameSkip] " + err3.message);
         }
      }
   }
}
