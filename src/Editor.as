package
{
	import adobe.utils.CustomActions;
	import assets.Assets;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import mx.core.ButtonAsset;
	import objects.Box;
	import physics.PhysicWorld;
	import physics.PlayerContactListener;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * ...
	 * @author Oleg Savchenko
	 */
	public class Editor extends Sprite
	{
		private var _background:Image;
		private var _grid:Image;
		private var _touch:Touch;
		private var _array:Array;
		private var _tileManager:TileManager;
		private var _tileSelectSprite:Sprite;
		private var _newObjectSprite:Sprite;
		private var _environmentFront:Sprite;
		private var _environmentBack:Sprite;
		private var _tutorial:Sprite;
		private var _objects:Sprite;
		private var _boxesSettings:Sprite;
		private var _newTileKey:String;
		private var _frame:Image;
		private var _boxFrame1:Image;
		private var _boxFrame2:Image;
		private var _boxFrame3:Image;
		private var _levelXML:XML;
		private var _levelSaveLoad:LevelSaveLoad;
		private var _testGame:Game;
		private var _isEnvironment:Boolean;
		private var _tempSprite:Sprite;
		private var _selection:Image;
		private var _diffX:Number;
		private var _diffY:Number;
		private var _addingToBack:Boolean;
		private var _startingBoxes:Array = [1, 1, 1];
		
		public function Editor()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			_levelSaveLoad = new LevelSaveLoad();
			drawBackground();
			//drawIcons();
			
			_environmentBack = new Sprite();
			addChild(_environmentBack);
			
			_tileManager = new TileManager(true);
			_array = _tileManager.tiles;
			addChild(_tileManager);
			
			_environmentFront = new Sprite();
			addChild(_environmentFront);
			
			_objects = new Sprite();
			addChild(_objects);
			
			_tileSelectSprite = new Sprite();
			addChild(_tileSelectSprite);
			fillSelectSprite();
			_tileSelectSprite.visible = false;
			
			_newObjectSprite = new Sprite();
			addChild(_newObjectSprite);
			fillNewObjectSprite();
			_newObjectSprite.visible = false;
			
			_tutorial = new Sprite();
			addChild(_tutorial);
			fillTutorial();
			_tutorial.visible = false;
			
			_boxesSettings = new Sprite();
			addChild(_boxesSettings);
			fillBoxesSettings();
			_boxesSettings.visible = false;
			
			_newTileKey = "3333A";
			
			//PhysicWorld.world.DrawDebugData();
			stage.addEventListener(TouchEvent.TOUCH, onTouch);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function fillTutorial():void 
		{
			var texture:Texture = Texture.fromBitmapData(new BitmapData(640, 480, false, 0x0000FF));
			var back:Image = new Image(texture);
			back.alpha = 0.5;
			back.name = "Back";
			_tutorial.addChild(back);
			
			_tutorial.addChild(createButton("Tutorial1-1", 0, 0, 0.5));
			_tutorial.addChild(createButton("Tutorial1-2", 170, 0, 0.5));
			_tutorial.addChild(createButton("Tutorial1-3", 250, 0, 0.5));
			_tutorial.addChild(createButton("Tutorial2-1", 0, 80, 0.5));
			_tutorial.addChild(createButton("Tutorial2-2", 90, 80, 0.5));
			_tutorial.addChild(createButton("Tutorial3-1", 0, 150, 0.5));
			_tutorial.addChild(createButton("Tutorial4-1", 0, 180, 0.5));
			_tutorial.addChild(createButton("Tutorial5-1", 0, 260, 0.5));
			_tutorial.addChild(createButton("Tutorial5-2", 130, 260, 0.5));
			_tutorial.addChild(createButton("Tutorial7-1", 0, 310, 0.5));
			_tutorial.addChild(createButton("Tutorial8-1", 0, 350, 0.5));
			_tutorial.addChild(createButton("Tutorial8-2", 100, 350, 0.5));
			_tutorial.addChild(createButton("Tutorial8-3", 180, 350, 0.5));
			_tutorial.addChild(createButton("Tutorial8-4", 260, 350, 0.5));
			_tutorial.addChild(createButton("Tutorial12-1", 0, 420, 0.5));
		}
		
		private function fillBoxesSettings():void 
		{
			var texture:Texture = Texture.fromBitmapData(new BitmapData(640, 480, false, 0x0000FF));
			var back:Image = new Image(texture);
			back.alpha = 0.5;
			back.name = "Back";
			_boxesSettings.addChild(back);
			
			texture = Texture.fromBitmapData(new BitmapData(70, 70, false, 0xFFFFFF));
			_boxFrame1 = new Image(texture);
			_boxFrame1.x = 190 - 5;
			_boxFrame1.y = 350 - 5;
			_boxesSettings.addChild(_boxFrame1);
			_boxFrame2 = new Image(texture);
			_boxFrame2.x = 290 - 5;
			_boxFrame2.y = 350 - 5;
			_boxesSettings.addChild(_boxFrame2);
			_boxFrame3 = new Image(texture);
			_boxFrame3.x = 390 - 5;
			_boxFrame3.y = 350 - 5;
			_boxesSettings.addChild(_boxFrame3);
			
			_boxesSettings.addChild(createBoxButton("BoxIdle0001", 190, 50));
			_boxesSettings.addChild(createBoxButton("FlyingBoxIdle0001", 190, 250));
			_boxesSettings.addChild(createBoxButton("JumpingBoxIdle0001", 190, 150));
			_boxesSettings.addChild(createBoxButton("BoxIdle0001", 290, 50));
			_boxesSettings.addChild(createBoxButton("FlyingBoxIdle0001", 290, 250));
			_boxesSettings.addChild(createBoxButton("JumpingBoxIdle0001", 290, 150));
			_boxesSettings.addChild(createBoxButton("BoxIdle0001", 390, 50));
			_boxesSettings.addChild(createBoxButton("FlyingBoxIdle0001", 390, 250));
			_boxesSettings.addChild(createBoxButton("JumpingBoxIdle0001", 390, 150));
			
			texture = Texture.fromBitmapData(new BitmapData(60, 60, false, 0x000000));
			var button:Button;
			for (var i:int = 0; i < 3; ++i)
			{
				button = new Button(texture, "", texture);
				button.x = 190 + 100 * i;
				button.y = 350;
				button.addEventListener(Event.TRIGGERED, onSelectBoxType);
				_boxesSettings.addChild(button);
			}
		}
		
		private function fillNewObjectSprite():void 
		{
			var texture:Texture = Texture.fromBitmapData(new BitmapData(640, 480, false, 0x0000FF));
			var back:Image = new Image(texture);
			back.alpha = 0.5;
			back.name = "Back";
			_newObjectSprite.addChild(back);
			
			_newObjectSprite.addChild(createButton("Player", 10, 10));
			_newObjectSprite.addChild(createButton("Key1", 75, 10));
			_newObjectSprite.addChild(createButton("Key2", 100, 10));
			_newObjectSprite.addChild(createButton("Key3", 125, 10));
			_newObjectSprite.addChild(createButton("Key4", 150, 10));
			_newObjectSprite.addChild(createButton("Key5", 175, 10));
			_newObjectSprite.addChild(createButton("Key", 75, 40));
			_newObjectSprite.addChild(createButton("StarBlinking0001", 200, 10));
			_newObjectSprite.addChild(createButton("FullButton1", 530, 10));
			_newObjectSprite.addChild(createButton("FullButton2", 560, 10));
			_newObjectSprite.addChild(createButton("FullButton3", 590, 10));
			_newObjectSprite.addChild(createButton("Platform", 530, 40));
			_newObjectSprite.addChild(createButton("Door1", 250, 10));
			_newObjectSprite.addChild(createButton("Door2", 275, 10));
			_newObjectSprite.addChild(createButton("Door3", 300, 10));
			_newObjectSprite.addChild(createButton("Cannon1", 350, 10));
			_newObjectSprite.addChild(createButton("Cannon2", 400, 10));
			_newObjectSprite.addChild(createButton("Cannon3", 450, 10));
			// Environment
			_newObjectSprite.addChild(createButton("Tree1", 0, 250, 0.5));
			_newObjectSprite.addChild(createButton("Tree2", 0, 360, 0.5));
			_newObjectSprite.addChild(createButton("Tree3", 80, 250, 0.5));
			_newObjectSprite.addChild(createButton("Tree4", 80, 360, 0.5));
			_newObjectSprite.addChild(createButton("Tree5", 150, 250, 0.5));
			_newObjectSprite.addChild(createButton("Tree6", 150, 350, 0.5));
			_newObjectSprite.addChild(createButton("Tree7", 200, 250, 0.5));
			_newObjectSprite.addChild(createButton("Tree8", 200, 350, 0.5));
			_newObjectSprite.addChild(createButton("Bush1", 250, 250));
			_newObjectSprite.addChild(createButton("Bush2", 250, 300));
			_newObjectSprite.addChild(createButton("Bush3", 250, 350));
			_newObjectSprite.addChild(createButton("Apple1", 250, 380));
			_newObjectSprite.addChild(createButton("Apple2", 250, 410));
			_newObjectSprite.addChild(createButton("Apple3", 250, 440));
			_newObjectSprite.addChild(createButton("Back01", 510, 150));
			_newObjectSprite.addChild(createButton("Back02", 420, 260));
			_newObjectSprite.addChild(createButton("Back06", 480, 270));
			_newObjectSprite.addChild(createButton("Back03", 560, 270));
			_newObjectSprite.addChild(createButton("Back04", 430, 380));
			_newObjectSprite.addChild(createButton("Back14", 330, 340));
			_newObjectSprite.addChild(createButton("Back11", 350, 240));
			_newObjectSprite.addChild(createButton("Back08", 420, 190));
			_newObjectSprite.addChild(createButton("Back15", 570, 130));
			_newObjectSprite.addChild(createButton("Back13", 270, 120));
			_newObjectSprite.addChild(createButton("Back05", 510, 120));
			_newObjectSprite.addChild(createButton("Back07", 450, 150));
			_newObjectSprite.addChild(createButton("Back09", 480, 150));
			_newObjectSprite.addChild(createButton("Back10", 410, 120));
			_newObjectSprite.addChild(createButton("Back12", 450, 120));
			_newObjectSprite.addChild(createButton("Back16", 480, 120));
			_newObjectSprite.addChild(createButton("Mushroom1", 10, 200));
			_newObjectSprite.addChild(createButton("Mushroom2", 40, 200));
			_newObjectSprite.addChild(createButton("Mushroom3", 70, 200));
			_newObjectSprite.addChild(createButton("Lantern", 610, 20));
			_newObjectSprite.addChild(createButton("Skeleton", 600, 60));
			_newObjectSprite.addChild(createButton("Ivy01", 0, 80, 0.5));
			_newObjectSprite.addChild(createButton("Ivy02", 50, 80, 0.5));
			_newObjectSprite.addChild(createButton("Ivy03", 100, 80, 0.5));
			_newObjectSprite.addChild(createButton("Ivy04", 0, 120, 0.5));
			_newObjectSprite.addChild(createButton("Ivy05", 50, 120, 0.5));
			_newObjectSprite.addChild(createButton("Ivy06", 100, 120, 0.5));
			_newObjectSprite.addChild(createButton("Ivy07", 150, 80, 0.5));
			_newObjectSprite.addChild(createButton("Ivy08", 150, 120, 0.5));
			_newObjectSprite.addChild(createButton("Ivy09", 150, 180, 0.5));
			//_newObjectSprite.addChild(createButton("Cloud01", 0, 120));
			//_newObjectSprite.addChild(createButton("Cloud02", 50, 120));
			//_newObjectSprite.addChild(createButton("Cloud03", 100, 120));
			//_newObjectSprite.addChild(createButton("Cloud04", 200, 120));
			//_newObjectSprite.addChild(createButton("Cloud05", 300, 120));
			//_newObjectSprite.addChild(createButton("Cloud06", 400, 120));
			//_newObjectSprite.addChild(createButton("Cloud07", 0, 200));
			//_newObjectSprite.addChild(createButton("Cloud08", 100, 200));
			//_newObjectSprite.addChild(createButton("Cloud09", 200, 200));
			//_newObjectSprite.addChild(createButton("Cloud10", 300, 200));
			//_newObjectSprite.addChild(createButton("Cloud11", 400, 200));
			//_newObjectSprite.addChild(createButton("Cloud12", 500, 200));
			//_newObjectSprite.addChild(createButton("Cloud13", 600, 200));
		}
		
		private function createButton(key:String, X:Number, Y:Number, scale:Number = 1):Button
		{
			var button:Button = new Button(Assets.getAtlasTexture(key), "", Assets.getAtlasTexture(key));
			button.x = X;
			button.y = Y;
			button.scaleX = scale;
			button.scaleY = scale;
			button.name = key;
			button.addEventListener(Event.TRIGGERED, onCreateObject);
			
			return button;
		}
		
		private function createBoxButton(key:String, X:Number, Y:Number, scale:Number = 1):Button
		{
			var button:Button = new Button(Assets.getAtlasTexture(key), "", Assets.getAtlasTexture(key));
			button.x = X;
			button.y = Y;
			button.scaleX = scale;
			button.scaleY = scale;
			button.name = key;
			button.addEventListener(Event.TRIGGERED, onSelectBoxType);
			
			return button;
		}
		
		private function onSelectBoxType(e:Event):void 
		{
			var index:int;
			if ((e.target as Button).x == 190)
			{
				index = 0;
				_boxFrame1.x = (e.target as Button).x - 5;
				_boxFrame1.y = (e.target as Button).y - 5;
			}
			else if ((e.target as Button).x == 290)
			{
				index = 1;
				_boxFrame2.x = (e.target as Button).x - 5;
				_boxFrame2.y = (e.target as Button).y - 5;
			}
			else
			{
				index = 2;
				_boxFrame3.x = (e.target as Button).x - 5;
				_boxFrame3.y = (e.target as Button).y - 5;
			}
			
			if ((e.target as Button).y == 50)
			{
				_startingBoxes[index] = Box.USUAL;
			}
			else if ((e.target as Button).y == 150)
			{
				_startingBoxes[index] = Box.JUMPING;
			}
			else if ((e.target as Button).y == 250)
			{
				_startingBoxes[index] = Box.FLYING;
			}
			else
			{
				_startingBoxes[index] = 0;
			}
		}
		
		private function onCreateObject(e:Event):void 
		{
			var img:Image = new Image(Assets.getAtlasTexture((e.target as Button).name));
			img.x = 300;
			img.y = 200;
			img.name = (e.target as Button).name;
			if (img.name.search("Door") != -1)
			{
				img.pivotX += 17.5;
				img.pivotY += 70;
			}
			if (img.name.search("Platform") != -1)
			{
				img.pivotX += 17;
				img.pivotY += 6;
			}
			if (img.name.search("FullButton") != -1)
			{
				img.pivotX += 17;
				img.pivotY += 14;
			}
			if ((e.target as Button).y > 100)
				_environmentBack.addChild(img);
			else
				_objects.addChild(img);
		}
		
		private function fillSelectSprite():void
		{
			var texture:Texture = Texture.fromBitmapData(new BitmapData(640, 480, false, 0x0000FF));
			var back:Image = new Image(texture);
			back.alpha = 0.5;
			back.name = "Back";
			_tileSelectSprite.addChild(back);
			var tile:Image;
			var arr:Array = [
			["0332A", "0332B"],
			["0232A", "0232C", "0232B"],
			["0231A", "0231B"],
			["0120A", "0120B"],
			["0131A", "0131B"],
			["0210A", "0210B"],
			["0220A", "0220B"],
			["0110A", "0110B", "0110C"],
			["1133A"]];
			for (var i:int = 0; i < arr.length; ++i)
			{
				for (var j:int = 0; j < arr[i].length; ++j)
				{
					tile = new Image(Assets.getAtlasTexture(arr[i][j]));
					tile.x = 105 - 35 * j;
					tile.y = 35 + 35 * i;
					tile.name = arr[i][j];
					_tileSelectSprite.addChild(tile);
				}
			}
			arr = [
			["3302A", "3302B"], 
			["3202A", "3202C", "3202B"],
			["3201A", "3201B"],
			["2100A", "2100B"], 
			["3101A", "3101B"],
			["1200A", "1200B"],
			["2200A", "2200B"], 
			["1100A", "1100B", "1100C"],
			["3113A"]];
			for (i = 0; i < arr.length; ++i)
			{
				for (j = 0; j < arr[i].length; ++j)
				{
					tile = new Image(Assets.getAtlasTexture(arr[i][j]));
					tile.x = 350 + 35 * j;
					tile.y = 35 + 35 * i;
					tile.name = arr[i][j];
					_tileSelectSprite.addChild(tile);
				}
			}
			arr = [
			["3333A", "3333B", "3333C", "3333D"], 
			["2320A", "2320B", "2320C"],
			["1310A", "1310B", "1310C"], 
			["1320A", "1320B", "2310A"], 
			];
			for (i = 0; i < arr.length; ++i)
			{
				for (j = 0; j < arr[i].length; ++j)
				{
					tile = new Image(Assets.getAtlasTexture(arr[i][j]));
					tile.x = 175 + 35 * j;
					tile.y = 35 + 35 * i;
					tile.name = arr[i][j];
					_tileSelectSprite.addChild(tile);
				}
			}
			arr = [
			["0132A", "2233A", "3223A", "3102A"], 
			["2023A", "2332A", "3322A"], 
			];
			for (i = 0; i < arr.length; ++i)
			{
				for (j = 0; j < arr[i].length; ++j)
				{
					tile = new Image(Assets.getAtlasTexture(arr[i][j]));
					tile.x = 175 + 35 * j;
					tile.y = 315 + 35 * i;
					tile.name = arr[i][j];
					_tileSelectSprite.addChild(tile);
				}
			}
			arr = [["0404A", "0404B", "0404C"], ["0214A", "0224A", "1204A", "2204A"], ["1314A", "2324A"]];
			for (i = 0; i < arr.length; ++i)
			{
				for (j = 0; j < arr[i].length; ++j)
				{
					tile = new Image(Assets.getAtlasTexture(arr[i][j]));
					tile.x = 175 + 35 * j;
					tile.y = 210 + 35 * i;
					tile.name = arr[i][j];
					_tileSelectSprite.addChild(tile);
				}
			}
			arr = [
			["G21", "G19", "G18", "G20", "G22"],
			["G08", "G09", "G10", "G11"],
			["G01", "G02", "G03", "G16", "G17"],
			["G04", "G05", "G06", "G12"],
			["G07", "G13", "G14", "G15", "G23"]];
			for (i = 0; i < arr.length; ++i)
			{
				for (j = 0; j < arr[i].length; ++j)
				{
					tile = new Image(Assets.getAtlasTexture(arr[i][j]));
					tile.x = 455 + 35 * j;
					tile.y = 35 + 35 * i;
					tile.name = arr[i][j];
					_tileSelectSprite.addChild(tile);
				}
			}
			arr = [
			["R01", "R02", "R03", "R04", "R05"],
			["R06", "R07", "R08", "R09"]];
			for (i = 0; i < arr.length; ++i)
			{
				for (j = 0; j < arr[i].length; ++j)
				{
					tile = new Image(Assets.getAtlasTexture(arr[i][j]));
					tile.x = 455 + 35 * j;
					tile.y = 210 + 35 * i;
					tile.name = arr[i][j];
					_tileSelectSprite.addChild(tile);
				}
			}
			arr = [
			["S16", "S08", "S04", "S01", "S02", "S03"],
			["S13", "S05", "S12", "S09", "S10", "S11"],
			["S14", "S06", "A18", "A19", "S21", "S23"],
			["S15", "S07", "A17", "A20", "S22", "S24"]];
			for (i = 0; i < arr.length; ++i)
			{
				for (j = 0; j < arr[i].length; ++j)
				{
					tile = new Image(Assets.getAtlasTexture(arr[i][j]));
					tile.x = 420 + 35 * j;
					tile.y = 315 + 35 * i;
					tile.name = arr[i][j];
					_tileSelectSprite.addChild(tile);
				}
			}
			arr = [
			["1331A", "1331B", "3311A", "3311B"]];
			for (i = 0; i < arr.length; ++i)
			{
				for (j = 0; j < arr[i].length; ++j)
				{
					tile = new Image(Assets.getAtlasTexture(arr[i][j]));
					tile.x = 175 + 35 * j;
					tile.y = 175 + 35 * i;
					tile.name = arr[i][j];
					_tileSelectSprite.addChild(tile);
				}
			}
			arr = [
			["BackTile03", "BackTile01", "BackTile02", "BackTile04", "BackTile05", "BackTile06", "BackTile07"]];
			for (i = 0; i < arr.length; ++i)
			{
				for (j = 0; j < arr[i].length; ++j)
				{
					tile = new Image(Assets.getAtlasTexture(arr[i][j]));
					tile.x = 35 + 35 * j;
					tile.y = 385 + 35 * i;
					tile.name = arr[i][j];
					_tileSelectSprite.addChild(tile);
				}
			}
			
			// White grid
			var rTexture:RenderTexture = new RenderTexture(640, 480);
			_grid = new Image(rTexture);
			var line:Image = new Image(Texture.fromBitmapData(new BitmapData(2, 480, false, 0xFFFFFF)));
			line.scaleX = 0.5;
			var line2:Image = new Image(Texture.fromBitmapData(new BitmapData(640, 2, false, 0xFFFFFF)));
			line2.scaleY = 0.5;
			for (i = 0; i < 20; i++)
			{
				rTexture.draw(line);
				line.x = 35 * i;
				if (i < 78)
				{
					rTexture.draw(line2);
					line2.y = 35 * i;
				}
			}
			_grid.alpha = 0.4;
			_grid.touchable = false;
			_tileSelectSprite.addChild(_grid);
			
			texture = Texture.fromBitmapData(new BitmapData(35, 35, false, 0xFFFFFF));
			_frame = new Image(texture);
			_frame.alpha = 0.7;
			_frame.touchable = false;
			_tileSelectSprite.addChild(_frame);
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
				case Keyboard.DELETE: 
				{
					if (_selection)
					{
						if (_objects.contains(_selection))
							_objects.removeChild(_selection, true);
						else
							_environmentBack.removeChild(_selection, true);
						_selection = null;
					}
					break;
				}
				case Keyboard.SPACE: 
				{
					//for (var i:int = 0; i < _array.length; ++i)
					//{
					//trace("[", _array[i], "],");
					//}
					if (_tileSelectSprite.visible)
					{
						_tileSelectSprite.visible = false;
					}
					else
					{
						_newObjectSprite.visible = false;
						_tileSelectSprite.visible = true;
						_boxesSettings.visible = false;
					}
					break;
				}
				case Keyboard.S:
				{
					levelToXML();
					_levelSaveLoad.saveLevel(_levelXML);
					break;
				}
				case Keyboard.L:
				{
					addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
					_levelSaveLoad.loadLevel();
					break;
				}
				case Keyboard.ENTER:
				{
					if (_testGame)
					{
						removeChild(_testGame, true);
						_testGame = null;
						stage.addEventListener(TouchEvent.TOUCH, onTouch);
						PhysicWorld.world.DrawDebugData();
					}
					else
					{
						_selection = null;
						stage.removeEventListener(TouchEvent.TOUCH, onTouch);
						_testGame = new Game();
						levelToXML();
						addChild(_testGame);
						_testGame.loadLevel(_levelXML, 0);
						
					}
					break;
				}
				case Keyboard.N:
				{
					if (_newObjectSprite.visible)
					{
						_newObjectSprite.visible = false;
					}
					else
					{
						_newObjectSprite.visible = true;
						_tileSelectSprite.visible = false;
						_boxesSettings.visible = false;
						_tutorial.visible = false;
					}
					break;
				}
				case Keyboard.U:
				{
					if (_selection)
					{
						_selection.parent.addChild(_selection);
					}
					break;
				}
				case Keyboard.LEFT:
				{
					if (_selection)
					{
						_selection.x -= 1;
					}
					break;
				}
				case Keyboard.RIGHT:
				{
					if (_selection)
					{
						_selection.x += 1;
					}
					break;
				}
				case Keyboard.UP:
				{
					if (_selection)
					{
						_selection.y -= 1;
					}
					break;
				}
				case Keyboard.DOWN:
				{
					if (_selection)
					{
						_selection.y += 1;
					}
					break;
				}
				case Keyboard.X:
				{
					if (_selection)
					{
						_selection.rotation += Math.PI / 2;
					}
					break;
				}
				case Keyboard.Z:
				{
					if (_selection)
					{
						_selection.rotation -= Math.PI / 2;
					}
					break;
				}
				case Keyboard.B:
				{
					if (_boxesSettings.visible)
					{
						_boxesSettings.visible = false;
					}
					else
					{
						_boxesSettings.visible = true;
						_tileSelectSprite.visible = false;
						_newObjectSprite.visible = false;
						_tutorial.visible = false;
					}
					break;
				}
				case Keyboard.T:
				{
					if (_tutorial.visible)
					{
						_tutorial.visible = false;
					}
					else
					{
						_boxesSettings.visible = false;
						_tileSelectSprite.visible = false;
						_newObjectSprite.visible = false;
						_tutorial.visible = true;
					}
					break;
				}
			}
		}
		
		private function onEnterFrame(e:EnterFrameEvent):void
		{
			if (_levelSaveLoad.loaded)
			{
				_levelXML = _levelSaveLoad.loadedXML;
				_levelSaveLoad.loaded = false;
				removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
				_tileManager.clearTiles();
				//trace(_levelXML);
				xmlToLevel();
			}
		}
		
		private function xmlToLevel():void
		{
			// Tiles
			for each (var _tile:XML in _levelXML.tiles.tile)
			{
				_tileManager.addTile(_tile.@key, int(_tile.@y / 35), int(_tile.@x / 35));
			}
			// Environment
			var img:Image;
			for each(var _object:XML in _levelXML.environmentFront.object)
			{
				img = new Image(Assets.getAtlasTexture(_object.@key));
				img.x = _object.@x;
				img.y = _object.@y;
				img.name = _object.@key;
				_environmentFront.addChild(img);
			}
			for each(_object in _levelXML.environmentBack.object)
			{
				img = new Image(Assets.getAtlasTexture(_object.@key));
				img.x = _object.@x;
				img.y = _object.@y;
				img.name = _object.@key;
				_environmentBack.addChild(img);
			}
			for each(_object in _levelXML.objects.object)
			{
				var str:String = _object.@key;
				trace(str);
				img = new Image(Assets.getAtlasTexture(str));
				if (str.search("Door") != -1 || str.search("Platform") != -1)
				{
					img.pivotX += img.width * 0.5;
					img.pivotY += img.height * 0.5;
					img.rotation = _object.@rotation;
				}
				else if (str.search("FullButton") != -1)
				{
					img.pivotX += 17;
					img.pivotY += 10;
					img.rotation = _object.@rotation;
				}
				img.x = _object.@x;
				img.y = _object.@y;
				img.name = _object.@key;
				_objects.addChild(img);
			}
			var i:int = 0;
			for each(var _box:XML in _levelXML.boxes.box)
			{
				str = _box.@kind;
				_startingBoxes[i] = int(str);
				++i;
			}
			_boxFrame1.y = 50 + _startingBoxes[0] * 100 - 5;
			_boxFrame2.y = 50 + _startingBoxes[1] * 100 - 5;
			_boxFrame3.y = 50 + _startingBoxes[2] * 100 - 5;
		}
		
		private function levelToXML():void
		{
			_levelXML =	 <body></body>;
			_levelXML.appendChild(new XML("<tiles></tiles>"));
			_levelXML.appendChild(new XML("<environmentFront></environmentFront>"));
			_levelXML.appendChild(new XML("<environmentBack></environmentBack>"));
			_levelXML.appendChild(new XML("<objects></objects>"));
			_levelXML.appendChild(new XML("<boxes></boxes>"));
			//_array = _tileManager.tiles;
			for (var i:int = 0; i < _array.length; ++i)
			{
				for (var j:int = 0; j < _array[i].length; ++j)
				{
					if (_array[i][j] != 0)
					{
						var xml:XML =  <tile key = {_array[i][j]} x={j * 35} y={i * 35}></tile>;
						_levelXML.tiles = _levelXML.tiles.appendChild(xml);
					}
				}
			}
			var img:Image;
			for (i = 0; i < _environmentFront.numChildren; ++i)
			{
				img = _environmentFront.getChildAt(i) as Image;
				var xml2:XML = <object key = {img.name} x = {img.x} y = {img.y}></object>;
				_levelXML.environmentFront = _levelXML.environmentFront.appendChild(xml2);
			}
			for (i = 0; i < _environmentBack.numChildren; ++i)
			{
				img = _environmentBack.getChildAt(i) as Image;
				var xml3:XML = <object key = {img.name} x = {img.x} y = {img.y}></object>;
				_levelXML.environmentBack = _levelXML.environmentBack.appendChild(xml3);
			}
			for (i = 0; i < _objects.numChildren; ++i)
			{
				img = _objects.getChildAt(i) as Image;
				var xml4:XML = <object key = {img.name} x = {img.x} y = {img.y} rotation = {img.rotation}></object>;
				_levelXML.objects = _levelXML.objects.appendChild(xml4);
			}
			for (i = 0; i < 3; ++i)
			{
				var xml5:XML = <box kind = {_startingBoxes[i]}></box>;
				_levelXML.boxes = _levelXML.boxes.appendChild(xml5);
			}
		}
		
		private function onTouch(e:TouchEvent):void
		{
			_touch = e.getTouch(stage);
			
			if (_touch.phase == TouchPhase.BEGAN)
			{
				trace(_touch.target, _touch.target.parent);
				// Selecting tile
				if (_tileSelectSprite.visible)
				{
					if (_touch.target is Image)
					{
						trace(_touch.target.name);
						_newTileKey = _touch.target.name;
						_frame.x = _touch.target.x;
						_frame.y = _touch.target.y;
						if (_newTileKey.charAt(0) == "G" || _newTileKey.charAt(0) == "R" || _newTileKey.charAt(0) == "B")
						{
							_isEnvironment = true;
							if (_newTileKey.charAt(0) == "G")
							{
								_tempSprite = _environmentFront;
							}
							else
							{
								_tempSprite = _environmentBack;
								_tileManager.touchable = false;
							}
						}
						else
						{
							_isEnvironment = false;
							_tileManager.touchable = true;
						}
					}
				}
				// Selecting new object
				else if (_newObjectSprite.visible)
				{
					
				}
				else if (_boxesSettings.visible)
				{
					
				}
				else if (_tutorial.visible)
				{
					
				}
				// Replacing objects, editing tiles
				else
				{
					var i:int = Math.round((_touch.globalY - 18) / 35);
					var j:int = Math.round((_touch.globalX - 18) / 35);
					if (_objects.contains(_touch.target) || (_environmentBack.contains(_touch.target) && _touch.target.name.search("BackTile") == -1))
					{
						_selection = _touch.target as Image;
						trace(_selection.name);
						_diffX = _selection.x - _touch.globalX;
						_diffY = _selection.y - _touch.globalY;
					}
					else
					{
						_selection = null;
						if (_isEnvironment)
						{
							if (_touch.target.parent == _tempSprite)
							{
								_tempSprite.removeChild(_touch.target, true);
							}
							else
							{
								var img:Image = new Image(Assets.getAtlasTexture(_newTileKey));
								img.x = j * 35;
								img.y = i * 35;
								img.name = _newTileKey;
								_tempSprite.addChild(img);
							}
						}
						else
						{
							if (!_tileManager.removeTile(i, j))
							{
								_tileManager.addTile(_newTileKey, i, j);
							}
						}
					}
				}
			}
			if (_touch.phase == TouchPhase.MOVED)
			{
				if (_selection && _selection.name.search("BackTile") == -1)
				{
					_selection.x = _touch.globalX + _diffX;
					if (e.ctrlKey)
					{
						_selection.y = Math.round((_touch.globalY + _diffY + _selection.height) / 35) * 35 - _selection.height;
					}
					else
					{
						_selection.y = _touch.globalY + _diffY;
					}
				}
			}
		}
		
		private function drawIcons():void
		{
			//_interface = new Sprite();
			//addChild(_interface);
			
			//_playerIcon = new Image(Assets.getAtlasTexture("Player"));
			//_playerIcon.x = 50;
			//_playerIcon.y = 25;
			//_playerIcon.scaleX = 0.5;
			//_playerIcon.scaleY = 0.5;
			//_playerIcon.name = "Player";
			//_interface.addChild(_playerIcon);
			//
			//_princessIcon = new Image(Assets.getAtlasTexture("Princess"));
			//_princessIcon.x = 120;
			//_princessIcon.y = 5;
			//_princessIcon.scaleX = 0.5;
			//_princessIcon.scaleY = 0.5;
			//_princessIcon.name = "Princess";
			//_interface.addChild(_princessIcon);
			//
			//_doorIcon = new Image(Assets.getAtlasTexture("Door"));
			//_doorIcon.x = 200;
			//_doorIcon.y = 5;
			//_doorIcon.scaleX = 0.5;
			//_doorIcon.scaleY = 0.5;
			//_doorIcon.name = "Door";
			//_interface.addChild(_doorIcon);
			//
			//_starIcon = new Image(Assets.getAtlasTexture("Star"));
			//_starIcon.x = 230;
			//_starIcon.y = 5;
			//_starIcon.name = "Star";
			//_interface.addChild(_starIcon);
			//
			//_btnIcon = new Image(Assets.getAtlasTexture("Btn"));
			//_btnIcon.x = 320;
			//_btnIcon.y = 30;
			//_btnIcon.name = "Btn";
			//_interface.addChild(_btnIcon);
		}
		
		private function drawBackground():void
		{
			_background = new Image(Assets.getAtlasTexture("Back1"));
			addChild(_background);
			
			// White grid
			var rTexture:RenderTexture = new RenderTexture(640, 480);
			_grid = new Image(rTexture);
			var line:Image = new Image(Texture.fromBitmapData(new BitmapData(2, 480, false, 0xFFFFFF)));
			line.scaleX = 0.5;
			var line2:Image = new Image(Texture.fromBitmapData(new BitmapData(640, 2, false, 0xFFFFFF)));
			line2.scaleY = 0.5;
			for (var i:int = 0; i < 20; i++)
			{
				rTexture.draw(line);
				line.x = 35 * i;
				if (i < 78)
				{
					rTexture.draw(line2);
					line2.y = 35 * i;
				}
			}
			_grid.alpha = 0.3;
			addChild(_grid);
		}
	}

}