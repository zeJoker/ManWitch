package  
{
	import com.milkmangames.nativeextensions.ios.events.StoreKitErrorEvent;
	import com.milkmangames.nativeextensions.ios.events.StoreKitEvent;
	import com.milkmangames.nativeextensions.ios.StoreKit;
	import helper.Constants;
	import starling.display.Button;
	/**
	 * ...
	 * @author Oleg Savchenko
	 */
	public class IAP
	{
		public static var purchased:Boolean = false;
		public static var sexyGirlPurchased:Boolean = false;
		public static var hintsLeft:int = 3;
		public static var loaded:Boolean = false;
		private static var _buttons:Array = [];
		
		public static function addButton(btn:Button):void
		{
			_buttons.push(btn);
		}
		
		public static function getProduct():void
		{
			StoreKit.create();
			if (StoreKit.isSupported() && StoreKit.storeKit.isStoreKitAvailable())
			{
				StoreKit.storeKit.addEventListener(StoreKitEvent.PRODUCT_DETAILS_LOADED,onProductsLoaded);
				StoreKit.storeKit.addEventListener(StoreKitEvent.PURCHASE_SUCCEEDED,onPurchaseSuccess);
				StoreKit.storeKit.addEventListener(StoreKitEvent.PURCHASE_CANCELLED,onPurchaseUserCancelled);
				StoreKit.storeKit.addEventListener(StoreKitEvent.TRANSACTIONS_RESTORED, onTransactionsRestored);
				
				StoreKit.storeKit.addEventListener(StoreKitErrorEvent.PRODUCT_DETAILS_FAILED,onProductsFailed);
				StoreKit.storeKit.addEventListener(StoreKitErrorEvent.PURCHASE_FAILED,onPurchaseFailed);
				StoreKit.storeKit.addEventListener(StoreKitErrorEvent.TRANSACTION_RESTORE_FAILED, onTransactionRestoreFailed);
				
				var vector:Vector.<String> = new Vector.<String>();
				vector[0] = "fs_unlockfullversion01";
				vector[1] = "buy10hints";
				vector[2] = "buy30hints";
				vector[3] = "sexygirl";
				StoreKit.storeKit.loadProductDetails(vector);
			}
		}
		
		public static function restoreTransactions():void
		{
			StoreKit.storeKit.restoreTransactions();
		}
		
		public static function buyProduct(productName:String = "fs_unlockfullversion01", num:int = 1):void
		{
			if (loaded)
			{
				StoreKit.storeKit.purchaseProduct(productName, num);
			}
		}
		
		static private function onProductsLoaded(e:StoreKitEvent):void 
		{
			//Constants.tf.appendText("\n product details LOADED!");
			loaded = true;
		}
		
		static private function onPurchaseSuccess(e:StoreKitEvent):void 
		{
			//Constants.tf.text = "\n purchase transaction SUCCEEDED!";
			switch (e.productId)
			{
				case "fs_unlockfullversion01":
				{
					purchased = true;
					LocalStore.data.purchased = "purchased";
					LocalStore.save();
					for (var i:int = 0; i < _buttons.length; ++i)
					{
						_buttons[i].visible = false;
					}
					break;
				}
				case "buy10hints":
				{
					hintsLeft += 10;
					//
					break;
				}
				case "buy30hints":
				{
					hintsLeft += 30;
					//
					break;
				}
				case "sexygirl":
				{
					sexyGirlPurchased = true;
					//
					break;
				}
			}
			
		}
		
		static private function onPurchaseUserCancelled(e:StoreKitEvent):void 
		{
			//Constants.tf.text = "\n purchase transaction CANCELED!";
		}
		
		static private function onTransactionsRestored(e:StoreKitEvent):void 
		{
			//Constants.tf.text = "\n restore transactions COMPLETED!";
			//purchased = true;
			//LocalStore.data.purchased = "purchased";
			//LocalStore.save();
			//for (var i:int = 0; i < _buttons.length; ++i)
			//{
				//_buttons[i].visible = false;
			//}
		}
		
		static private function onProductsFailed(e:StoreKitErrorEvent):void 
		{
			//Constants.tf.appendText("\n product details FAILED!");
		}
		
		static private function onPurchaseFailed(e:StoreKitErrorEvent):void 
		{
			//Constants.tf.text = "\n purchase transaction FAILED!";
		}
		
		static private function onTransactionRestoreFailed(e:StoreKitErrorEvent):void 
		{
			//Constants.tf.text = "\n restore transactions FAILED!";
		}
	}

}