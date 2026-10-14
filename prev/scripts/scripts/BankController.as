package
{
   import flash.display.MovieClip;

   public class BankController
   {

      private var bankModified:Boolean = true;

      private var rootClass:MovieClip;

      public var bankItems:Object;

      private var bankArr:Array = [];

      public var searchArr:Array = [];

      public var lastSearch:String = "";

      private var requestedTypes:Object = new Object();

      public var Count:int = 0;

      public function BankController()
      {
         super();
         this.rootClass = World.GameRoot;
         this.bankItems = new Object();
      }

      public function addItemsToBank(param1:Array) : void
      {
         var _loc1_:Object = null;
         for each(_loc1_ in param1)
         {
            if(!InvCat.isClass(_loc1_))
            {
               this.bankItems[int(_loc1_.ItemID)] = _loc1_;
            }
         }
         this.bankModified = true;
      }

      public function addItem(param1:Object) : void
      {
         if(InvCat.isClass(param1))
         {
            return;
         }
         this.bankItems[param1.ItemID] = param1;
      }

      public function isItemInBank(param1:int) : Boolean
      {
         return this.bankItems[param1] != null;
      }

      public function get items() : Array
      {
         return this.searchArr.length == 0 ? this.BankArray : this.SearchArray;
      }

      public function get BankArray() : Array
      {
         var _loc2_:Number = NaN;
         var _loc1_:Object = null;
         if(this.bankModified)
         {
            this.bankArr = [];
            _loc2_ = new Date().getTime();
            for each(_loc1_ in this.bankItems)
            {
               if(_loc1_.tPurchase != null)
               {
                  _loc1_.iHrs = (_loc2_ - _loc1_.tPurchase) / (1000 * 60 * 60);
               }
               this.bankArr.push(_loc1_);
            }
            this.bankModified = false;
         }
         return this.bankArr;
      }

      public function addRequestedTypes(param1:Array) : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < param1.length)
         {
            this.requestedTypes[String(param1[_loc1_])] = true;
            _loc1_++;
         }
      }

      public function hasRequested(param1:Array) : Boolean
      {
         var _loc1_:uint = 0;
         while(_loc1_ < param1.length)
         {
            if(this.requestedTypes[param1[_loc1_]] == null)
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }

      public function bankToInv(param1:int) : Object
      {
         if(this.bankItems[param1] == null)
         {
            return null;
         }
         var _loc1_:Object = this.bankItems[param1];
         delete this.bankItems[param1];
         this.bankModified = true;
         if(_loc1_.bCoins == 0)
         {
            --this.Count;
         }
         var _loc3_:String = this.lastSearch;
         this.resetSearch();
         this.search(_loc3_);
         return _loc1_;
      }

      public function bankFromInv(param1:int = -1) : void
      {
         this.bankModified = true;
         var _loc1_:String = this.lastSearch;
         this.resetSearch();
         this.search(_loc1_);
      }

      public function getBankItem(param1:int) : Object
      {
         return this.bankItems[param1];
      }

      public function resetSearch() : void
      {
         this.lastSearch = "";
         this.searchArr = [];
      }

      public function get SearchArray() : Array
      {
         return this.searchArr;
      }

      public function search(param1:String) : void
      {
         var _loc1_:Object = null;
         if(this.rootClass.ui.mcPopup.currentLabel != "Bank" && this.rootClass.ui.mcPopup.currentLabel != "HouseBank")
         {
            return;
         }
         if(this.lastSearch != param1 && param1 != "")
         {
            this.searchArr = [];
            this.lastSearch = param1;
            for each(_loc1_ in this.bankItems)
            {
               if(_loc1_.sName.toLowerCase().indexOf(param1) > -1 && (Boolean(this.rootClass.bankFiltersMC == null) || Boolean(this.rootClass.bankFiltersMC.onFilter(_loc1_))))
               {
                  this.searchArr.push(_loc1_);
               }
            }
         }
         if(param1 == "")
         {
            this.searchArr = [];
            this.lastSearch = "";
         }
         if(this.rootClass.bankFiltersMC != null)
         {
            this.rootClass.bankFiltersMC.dispatch();
         }
      }
   }
}
