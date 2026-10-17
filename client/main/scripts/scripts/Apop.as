package
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.media.SoundTransform;
   import flash.text.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol2992")]
   public class Apop extends MovieClip
   {

      public var npc:MovieClip;

      public var btnClose:MovieClip;

      public var nMask:MovieClip;

      public var placement:MovieClip;

      public var cnt:MovieClip;

      public var world:MovieClip;

      public var rootClass:MovieClip;

      public var o:Object = null;

      private var mc:MovieClip;

      public function Apop()
      {
         super();
         addFrameScript(5,this.frame6);
         this.mc = MovieClip(this);
         this.mc.btnClose.addEventListener(MouseEvent.CLICK,this.xClick,false,0,true);
      }

      public function update(param1:Object) : *
      {
         var _loc1_:Class = null;
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         var _loc4_:Class = null;
         var _loc5_:* = undefined;
         var _loc6_:MovieClip = null;
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         this.rootClass = MovieClip(this.stage.getChildAt(0));
         this.world = this.rootClass.world;
         this.o = param1;
         var _loc9_:String = "none";
         var _loc10_:String = "none";
         var _loc11_:String = "none";
         var _loc12_:String = "none";
         var _loc13_:String = "none";
         if("npcLinkage" in this.o)
         {
            _loc9_ = this.o.npcLinkage;
         }
         if("npcEntry" in this.o)
         {
            _loc10_ = this.o.npcEntry;
         }
         if("cnt" in this.o)
         {
            _loc12_ = this.o.cnt;
         }
         if("scene" in this.o)
         {
            _loc11_ = this.o.scene;
         }
         if("frame" in this.o)
         {
            _loc13_ = this.o.frame;
         }
         if(_loc9_ != "none")
         {
            _loc1_ = this.world.ldr_map.contentLoaderInfo.applicationDomain.getDefinition(_loc9_) as Class;
            if(_loc1_ != null)
            {
               if(_loc10_ == "right")
               {
                  _loc2_ = this.mc.npc.npcRight;
                  _loc3_ = this.mc.npc.npcLeft;
                  if(_loc3_.currentLabel != "init")
                  {
                     _loc3_.gotoAndPlay("slide-out");
                  }
                  else
                  {
                     _loc3_.visible = false;
                  }
               }
               else
               {
                  _loc2_ = this.mc.npc.npcLeft;
                  _loc3_ = this.mc.npc.npcRight;
                  if(_loc3_.currentLabel != "init")
                  {
                     _loc3_.gotoAndPlay("slide-out");
                  }
                  else
                  {
                     _loc3_.visible = false;
                  }
               }
               _loc2_.visible = true;
               _loc2_.npc.removeChildAt(0);
               _loc2_.npc.addChild(new _loc1_());
               if(_loc2_.currentLabel != "init")
               {
                  _loc2_.gotoAndPlay("slide-hook");
               }
               else
               {
                  _loc2_.gotoAndPlay("slide-in");
               }
            }
            else
            {
               this.mc.npc.npcRight.visible = false;
               this.mc.npc.npcLeft.visible = false;
            }
         }
         if(_loc12_ != "none")
         {
            _loc4_ = this.world.ldr_map.contentLoaderInfo.applicationDomain.getDefinition(_loc12_) as Class;
            if(_loc4_ != null)
            {
               this.mc.cnt.removeChildAt(0);
               _loc5_ = this.mc.cnt.addChild(new _loc4_());
               _loc5_.name = "cnt";
               if(_loc11_ != "none")
               {
                  _loc5_.gotoAndPlay(_loc11_);
               }
            }
         }
         if(_loc13_ != "none")
         {
            _loc6_ = MovieClip(this.mc.cnt.getChildByName("cnt"));
            _loc7_ = false;
            _loc8_ = 0;
            while(_loc8_ < _loc6_.currentLabels.length)
            {
               if(_loc6_.currentLabels[_loc8_].name == _loc13_)
               {
                  _loc7_ = true;
               }
               _loc8_++;
            }
            if(_loc7_)
            {
               _loc6_.gotoAndPlay(_loc13_);
            }
            else
            {
               this.rootClass.addUpdate("Label " + _loc13_ + " not found!");
            }
         }
         if(this.mc.currentLabel == "init")
         {
            this.mc.gotoAndPlay("in");
         }
      }

      public function updateWithClasses(param1:Object, param2:Class, param3:Class) : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:MovieClip = null;
         var _loc3_:* = undefined;
         var _loc4_:MovieClip = null;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         this.rootClass = MovieClip(this.stage.getChildAt(0));
         this.world = this.rootClass.world;
         this.o = param1;
         var _loc7_:String = "none";
         var _loc8_:String = "none";
         var _loc9_:String = "none";
         if("npcEntry" in this.o)
         {
            _loc7_ = this.o.npcEntry;
         }
         if("scene" in this.o)
         {
            _loc8_ = this.o.scene;
         }
         if("frame" in this.o)
         {
            _loc9_ = this.o.frame;
         }
         if(param2 != null)
         {
            if(_loc7_ == "right")
            {
               _loc1_ = this.mc.npc.npcRight;
               _loc2_ = this.mc.npc.npcLeft;
               if(_loc2_.currentLabel != "init")
               {
                  _loc2_.gotoAndPlay("slide-out");
               }
               else
               {
                  _loc2_.visible = false;
               }
            }
            else
            {
               _loc1_ = this.mc.npc.npcLeft;
               _loc2_ = this.mc.npc.npcRight;
               if(_loc2_.currentLabel != "init")
               {
                  _loc2_.gotoAndPlay("slide-out");
               }
               else
               {
                  _loc2_.visible = false;
               }
            }
            _loc1_.visible = true;
            _loc1_.npc.removeChildAt(0);
            _loc1_.npc.addChild(new param2());
            if(_loc1_.currentLabel != "init")
            {
               _loc1_.gotoAndPlay("slide-hook");
            }
            else
            {
               _loc1_.gotoAndPlay("slide-in");
            }
         }
         else
         {
            this.mc.npc.npcRight.visible = false;
            this.mc.npc.npcLeft.visible = false;
         }
         if(param3 != null)
         {
            this.mc.cnt.removeChildAt(0);
            _loc3_ = this.mc.cnt.addChild(new param3());
            _loc3_.name = "cnt";
            if(_loc8_ != "none")
            {
               _loc3_.gotoAndPlay(_loc8_);
            }
         }
         if(_loc9_ != "none")
         {
            _loc4_ = MovieClip(this.mc.cnt.getChildByName("cnt"));
            _loc5_ = false;
            _loc6_ = 0;
            while(_loc6_ < _loc4_.currentLabels.length)
            {
               if(_loc4_.currentLabels[_loc6_].name == _loc9_)
               {
                  _loc5_ = true;
               }
               _loc6_++;
            }
            if(_loc5_)
            {
               _loc4_.gotoAndPlay(_loc9_);
            }
            else
            {
               this.rootClass.addUpdate("Label " + _loc9_ + " not found!");
            }
         }
         if(this.mc.currentLabel == "init")
         {
            this.mc.gotoAndPlay("in");
         }
      }

      public function fClose() : void
      {
         var _loc1_:MovieClip = MovieClip(this.mc.cnt.getChildByName("cnt"));
         _loc1_.soundTransform = new SoundTransform(0);
         _loc1_.stop();
         this.mc.btnClose.removeEventListener(MouseEvent.CLICK,this.xClick);
         this.mc.parent.removeChild(this);
      }

      private function xClick(param1:MouseEvent) : void
      {
         this.fClose();
      }

      public function exit() : void
      {
         this.fClose();
      }

      public function warn(param1:String) : *
      {
         trace("");
         trace("*^*^* NPC DIALOGUE ERROR *^*^*");
         trace("  > " + param1);
         trace("");
      }

      internal function frame6() : *
      {
         stop();
      }
   }
}
