package liteAssets.draw
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.*;
   import flash.geom.*;
   import flash.utils.*;

   public class AuraHUD extends Sprite
   {

      private static const PITCH_X:int = 32;

      private static const PITCH_Y:int = 28;

      private static const PER_ROW:int = 4;

      private static const CELL_W:int = 26;

      private static const CELL_H:int = 24;

      private static const TICK_MS:int = 100;

      private static const STALE_MS:int = 10000;

      protected var rootClass:MovieClip;

      private var isTarget:Boolean;

      private var cells:Object;

      private var order:Array;

      private var leaf:Object;

      private var lastV:int = -1;

      private var dirty:Boolean = true;

      private var lastTick:int = 0;

      private var drag:HudDrag;

      private var hoverCell:AuraCell;

      private var lastTip:String;

      private var lastRows:int = -1;

      public function AuraHUD(param1:MovieClip, param2:Boolean)
      {
         var ui:MovieClip = null;
         var idx:int = 0;
         var r:MovieClip = param1;
         var target:Boolean = param2;
         this.cells = {};
         this.order = [];
         super();
         this.rootClass = r;
         this.isTarget = target;
         name = target ? "targetAuras" : "playerAuras";
         visible = false;
         x = target ? 320 : 130;
         y = target ? 104 : 100;
         try
         {
            ui = r.ui;
            idx = Math.max(ui.getChildIndex(ui.mcPortrait),ui.getChildIndex(ui.mcPortraitTarget)) + 1;
            ui.addChildAt(this,Math.min(idx,ui.numChildren));
         }
         catch(e:Error)
         {
            r.ui.addChild(this);
         }
         this.drag = new HudDrag(this,r,target ? "posAurasT" : "posAurasP",{
            "backdrop":true,
            "caption":(target ? "TARGET" : "YOU"),
            "measure":this.measure,
            "bottom":488
         });
         addEventListener(Event.ENTER_FRAME,this.onTick,false,0,true);
      }

      private static function escapeHtml(param1:String) : String
      {
         return param1.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
      }

      public function resetPosition() : void
      {
         if(this.drag != null)
         {
            this.drag.reset(this.isTarget ? 320 : 130,this.isTarget ? 104 : 100);
         }
      }

      public function classChanged() : void
      {
         this.dirty = true;
      }

      public function clearMCs() : void
      {
         var _loc1_:String = null;
         for(_loc1_ in this.cells)
         {
            this.killCell(this.cells[_loc1_]);
         }
         this.cells = {};
         this.order = [];
         this.hoverCell = null;
         visible = false;
      }

      public function cleanup() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onTick);
         if(this.drag != null)
         {
            this.drag.detach();
            this.drag = null;
         }
         if(this.hoverCell != null && this.rootClass.ui != null)
         {
            this.rootClass.ui.ToolTip.close();
         }
         this.clearMCs();
         this.leaf = null;
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }

      private function subjectLeaf() : Object
      {
         var _loc1_:* = this.rootClass.world;
         if(_loc1_ == null || _loc1_.myAvatar == null)
         {
            return null;
         }
         if(!this.isTarget)
         {
            return _loc1_.myAvatar.dataLeaf;
         }
         return _loc1_.myAvatar.target != null ? _loc1_.myAvatar.target.dataLeaf : null;
      }

      private function onTick(param1:Event) : void
      {
         var _loc1_:AuraCell = null;
         var _loc2_:int = int(getTimer());
         if(_loc2_ - this.lastTick < TICK_MS)
         {
            return;
         }
         this.lastTick = _loc2_;
         var _loc3_:Boolean = false;
         try
         {
            _loc3_ = Boolean(this.rootClass.litePreference.data.bHideUI);
         }
         catch(eP:Error)
         {
         }
         var _loc4_:Object = _loc3_ ? null : this.subjectLeaf();
         if(_loc4_ != this.leaf)
         {
            this.leaf = _loc4_;
            this.dirty = true;
         }
         var _loc5_:int = this.leaf != null ? int(this.leaf.hudAurasV) : -1;
         if(_loc5_ != this.lastV)
         {
            this.lastV = _loc5_;
            this.dirty = true;
         }
         var _loc6_:Object = this.leaf != null ? this.leaf.hudAuras : null;
         if(this.dirty)
         {
            this.dirty = false;
            this.sync(_loc6_);
         }
         if(this.order.length == 0)
         {
            visible = false;
            return;
         }
         visible = true;
         var _loc7_:Boolean = false;
         for each(_loc1_ in this.order)
         {
            if(_loc1_.tick(_loc2_) && _loc2_ > _loc1_.h.end + STALE_MS)
            {
               delete _loc6_[_loc1_.nam];
               _loc7_ = true;
            }
         }
         if(_loc7_)
         {
            this.leaf.hudAurasV = int(this.leaf.hudAurasV) + 1;
         }
         if(this.hoverCell != null && this.hoverCell.parent == this)
         {
            this.showTip(this.hoverCell,_loc2_);
         }
      }

      private function sync(param1:Object) : void
      {
         var _loc1_:String = null;
         var _loc2_:AuraCell = null;
         var _loc3_:AuraCell = null;
         var _loc4_:Array = [];
         for(_loc1_ in this.cells)
         {
            if(param1 == null || param1[_loc1_] == null)
            {
               _loc4_.push(_loc1_);
            }
         }
         for each(_loc1_ in _loc4_)
         {
            _loc2_ = this.cells[_loc1_];
            if(_loc2_ == this.hoverCell)
            {
               this.hoverCell = null;
               this.rootClass.ui.ToolTip.close();
            }
            this.killCell(_loc2_);
            delete this.cells[_loc1_];
         }
         this.order.length = 0;
         if(param1 != null)
         {
            for(_loc1_ in param1)
            {
               _loc3_ = this.cells[_loc1_];
               if(_loc3_ == null)
               {
                  _loc3_ = this.cells[_loc1_] = new AuraCell(this.rootClass,_loc1_);
                  _loc3_.addEventListener(MouseEvent.ROLL_OVER,this.onCellOver,false,0,true);
                  _loc3_.addEventListener(MouseEvent.ROLL_OUT,this.onCellOut,false,0,true);
                  addChild(_loc3_);
               }
               _loc3_.bind(param1[_loc1_]);
               this.order.push(_loc3_);
            }
         }
         this.order.sortOn("seq",Array.NUMERIC);
         var _loc5_:int = 0;
         while(_loc5_ < this.order.length)
         {
            this.order[_loc5_].x = _loc5_ % PER_ROW * PITCH_X;
            this.order[_loc5_].y = int(_loc5_ / PER_ROW) * PITCH_Y;
            _loc5_++;
         }
         var _loc6_:int = int((this.order.length + PER_ROW - 1) / PER_ROW);
         if(this.drag != null)
         {
            if(_loc6_ != this.lastRows)
            {
               this.drag.clamp();
            }
            this.drag.refresh();
         }
         this.lastRows = _loc6_;
      }

      private function killCell(param1:AuraCell) : void
      {
         param1.removeEventListener(MouseEvent.ROLL_OVER,this.onCellOver);
         param1.removeEventListener(MouseEvent.ROLL_OUT,this.onCellOut);
         param1.dispose();
      }

      private function measure(param1:DisplayObject) : Rectangle
      {
         var _loc1_:int = int(this.order.length);
         if(_loc1_ == 0)
         {
            return null;
         }
         var _loc2_:int = Math.min(_loc1_,PER_ROW);
         var _loc3_:int = int((_loc1_ + PER_ROW - 1) / PER_ROW);
         return new Rectangle(x,y,(_loc2_ - 1) * PITCH_X + CELL_W,(_loc3_ - 1) * PITCH_Y + CELL_H);
      }

      private function onCellOver(param1:MouseEvent) : void
      {
         var _loc1_:Boolean = false;
         try
         {
            _loc1_ = Boolean(this.rootClass.litePreference.data.dOptions["disAuraTips"]);
         }
         catch(eO:Error)
         {
         }
         if(_loc1_)
         {
            return;
         }
         this.hoverCell = param1.currentTarget as AuraCell;
         this.lastTip = null;
         this.showTip(this.hoverCell,getTimer());
      }

      private function onCellOut(param1:MouseEvent) : void
      {
         if(this.hoverCell == null)
         {
            return;
         }
         this.hoverCell = null;
         this.rootClass.ui.ToolTip.close();
      }

      private function showTip(param1:AuraCell, param2:int) : void
      {
         var _loc1_:String = "<b>" + escapeHtml(param1.nam) + (param1.h.n > 1 ? "  x" + param1.h.n : "") + "</b>";
         var _loc2_:* = this.rootClass.world != null && this.rootClass.world.auraDescs != null ? this.rootClass.world.auraDescs[param1.nam] : null;
         if(_loc2_ != null && _loc2_ != "")
         {
            _loc1_ += "\n" + escapeHtml(String(_loc2_));
         }
         if(_loc1_ == this.lastTip)
         {
            return;
         }
         this.lastTip = _loc1_;
         this.rootClass.ui.ToolTip.openWith({"str":_loc1_});
      }
   }
}

import flash.display.*;
import flash.filters.*;
import flash.geom.*;
import flash.text.*;
import flash.utils.*;

class AuraCell extends Sprite
{

   private static const SCALE:Number = 0.6;

   private static const DIM_CT:ColorTransform = new ColorTransform(0.5,0.5,0.5,1,-50,-50,-50,0);

   private static const STACK_GLOW:Array = [new GlowFilter(0,5,0,0,5,5)];

   public var nam:String;

   public var h:Object;

   public var seq:int;

   private var rootClass:MovieClip;

   private var base:MovieClip;

   private var visual:DisplayObject;

   private var iconKey:String;

   private var dim:Bitmap;

   private var sweep:MovieClip;

   private var segY:Array;

   private var tStk:TextField;

   private var lastN:int = -1;

   private var lastStep:int = -2;

   private var noSweep:Boolean = false;

   public function AuraCell(param1:MovieClip, param2:String)
   {
      var fmtStk:TextFormat;
      var c:Class = null;
      var r:MovieClip = param1;
      var auraName:String = param2;
      super();
      this.rootClass = r;
      this.nam = auraName;
      mouseChildren = false;
      try
      {
         c = getDefinitionByName("ib3") as Class;
         this.base = new c() as MovieClip;
      }
      catch(e:Error)
      {
         base = null;
      }
      if(this.base == null)
      {
         return;
      }
      this.base.width = 42;
      this.base.height = 39;
      this.base.scaleX = this.base.scaleY = SCALE;
      if(this.base.cnt != null && this.base.cnt.numChildren > 0)
      {
         this.base.cnt.removeChildAt(0);
      }
      if(this.base.tQty != null)
      {
         this.base.tQty.visible = false;
      }
      addChild(this.base);
      this.tStk = new TextField();
      fmtStk = MailArt.fmt(12,16777215,true);
      fmtStk.align = "right";
      this.tStk.embedFonts = MailArt.embedded();
      if(this.tStk.embedFonts)
      {
         this.tStk.antiAliasType = AntiAliasType.ADVANCED;
      }
      this.tStk.defaultTextFormat = fmtStk;
      this.tStk.selectable = false;
      this.tStk.mouseEnabled = false;
      this.tStk.filters = STACK_GLOW;
      this.tStk.x = 3.25;
      this.tStk.y = 28.1;
      this.tStk.width = 42.7;
      this.tStk.height = 16.25;
      this.tStk.visible = false;
      this.base.addChild(this.tStk);
   }

   public function bind(param1:Object) : void
   {
      this.h = param1;
      this.seq = int(param1.seq);
      if(this.base == null)
      {
         return;
      }
      var _loc1_:String = param1.icon != null ? String(param1.icon) : "";
      if(_loc1_ != this.iconKey || this.visual == null)
      {
         this.setIcon(_loc1_);
      }
      var _loc2_:int = int(param1.n);
      if(_loc2_ != this.lastN)
      {
         this.lastN = _loc2_;
         this.tStk.visible = _loc2_ > 1;
         this.tStk.text = String(_loc2_);
         this.tStk.height = this.tStk.textHeight + 4;
         this.tStk.y = 44.35 - this.tStk.height;
      }
      this.lastStep = -2;
   }

   private function setIcon(param1:String) : void
   {
      var link:String;
      var c:Class;
      var parts:Array = null;
      var k:String = param1;
      this.iconKey = k;
      this.noSweep = false;
      this.clearSweep();
      if(this.visual != null)
      {
         if(this.visual is MovieClip)
         {
            MovieClip(this.visual).stop();
         }
         if(this.visual.parent != null)
         {
            this.visual.parent.removeChild(this.visual);
         }
         this.visual = null;
      }
      link = k;
      if(link.indexOf(",") > -1)
      {
         parts = link.split(",");
         link = parts[parts.length - 1];
      }
      c = null;
      try
      {
         if(link != "" && link != "undefined")
         {
            c = this.rootClass.world.getClass(link) as Class;
         }
         if(c == null)
         {
            c = this.rootClass.world.getClass("isp2") as Class;
         }
         if(c != null)
         {
            this.visual = new c() as DisplayObject;
         }
      }
      catch(e:Error)
      {
         visual = null;
      }
      if(this.visual == null || this.base.cnt == null)
      {
         return;
      }
      if(this.visual is MovieClip)
      {
         MovieClip(this.visual).stop();
         MovieClip(this.visual).mouseEnabled = MovieClip(this.visual).mouseChildren = false;
      }
      this.base.cnt.addChild(this.visual);
      if(this.visual.width > this.visual.height)
      {
         this.visual.scaleX = this.visual.scaleY = 34 / this.visual.width;
      }
      else
      {
         this.visual.scaleX = this.visual.scaleY = 31 / this.visual.height;
      }
      this.visual.x = this.base.bg.width / 2 - this.visual.width / 2;
      this.visual.y = this.base.bg.height / 2 - this.visual.height / 2;
   }

   private function buildSweep() : void
   {
      var i:int;
      var bmd:BitmapData = null;
      var seg:MovieClip = null;
      bmd = new BitmapData(50,50,true,0);
      try
      {
         this.base.removeChild(this.tStk);
         bmd.draw(this.base,null,DIM_CT);
      }
      catch(eD:Error)
      {
         bmd.dispose();
         if(tStk.parent == null)
         {
            base.addChild(tStk);
         }
         noSweep = true;
         return;
      }
      this.base.addChild(this.tStk);
      this.dim = new Bitmap(bmd);
      this.base.addChildAt(this.dim,this.base.getChildIndex(this.tStk));
      try
      {
         this.sweep = new ActMaskReverse() as MovieClip;
      }
      catch(e:Error)
      {
         sweep = null;
      }
      if(this.sweep == null)
      {
         this.noSweep = true;
         this.clearSweep();
         return;
      }
      this.base.addChild(this.sweep);
      this.sweep.x = int(this.dim.x + this.dim.width / 2 - 122);
      this.sweep.y = int(this.dim.y + this.dim.height / 2 - 122);
      this.segY = [];
      i = 0;
      while(i < 4)
      {
         seg = this.sweep["e" + i];
         seg.stop();
         this.segY.push(seg.y);
         i++;
      }
      this.dim.mask = this.sweep;
   }

   private function clearSweep() : void
   {
      if(this.dim != null)
      {
         this.dim.mask = null;
         if(this.dim.parent != null)
         {
            this.dim.parent.removeChild(this.dim);
         }
         this.dim.bitmapData.dispose();
         this.dim = null;
      }
      if(this.sweep != null)
      {
         if(this.sweep.parent != null)
         {
            this.sweep.parent.removeChild(this.sweep);
         }
         this.sweep = null;
      }
      this.segY = null;
   }

   public function tick(param1:int) : Boolean
   {
      var _loc1_:int = 0;
      var _loc2_:int = 0;
      var _loc3_:int = 0;
      var _loc4_:int = 0;
      var _loc5_:MovieClip = null;
      if(this.base == null || this.h == null || this.h.end <= 0 || this.h.dur <= 0)
      {
         if(this.dim != null)
         {
            this.clearSweep();
         }
         return false;
      }
      if(this.dim == null && !this.noSweep)
      {
         this.buildSweep();
      }
      var _loc6_:int = int(this.h.end) - param1;
      var _loc7_:Number = 1 - _loc6_ / (Number(this.h.dur) * 1000);
      if(_loc7_ < 0)
      {
         _loc7_ = 0;
      }
      if(_loc7_ > 0.999)
      {
         _loc7_ = 0.999;
      }
      if(this.sweep != null)
      {
         _loc1_ = int(_loc7_ * 4);
         _loc2_ = int(_loc7_ * 360 % 90) + 1;
         _loc3_ = _loc1_ * 100 + _loc2_;
         if(_loc3_ != this.lastStep)
         {
            this.lastStep = _loc3_;
            _loc4_ = 0;
            while(_loc4_ < 4)
            {
               _loc5_ = this.sweep["e" + _loc4_];
               if(_loc4_ < _loc1_)
               {
                  if(_loc5_.currentFrame != 90)
                  {
                     _loc5_.gotoAndStop(90);
                  }
               }
               else
               {
                  _loc5_.y = this.segY[_loc4_];
                  if(_loc4_ > _loc1_)
                  {
                     _loc5_.gotoAndStop(1);
                  }
               }
               _loc4_++;
            }
            MovieClip(this.sweep["e" + _loc1_]).gotoAndStop(_loc2_);
         }
      }
      return _loc6_ <= 0;
   }

   public function dispose() : void
   {
      this.clearSweep();
      if(this.visual != null && this.visual is MovieClip)
      {
         MovieClip(this.visual).stop();
      }
      while(numChildren > 0)
      {
         removeChildAt(0);
      }
      this.visual = null;
      this.base = null;
      this.h = null;
      this.rootClass = null;
      if(parent != null)
      {
         parent.removeChild(this);
      }
   }
}
