package  
{
	import assets.Assets;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.utils.Dictionary;
	import helper.Category;
	import physics.PhysicWorld;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.RenderTexture;
	
	/**
	 * ...
	 * @author Oleg Savchenko
	 */
	public class TileManager extends Sprite 
	{
		private var _tiles:Array;
		private var _bodies:Array;
		private var _tile:Image;
		private var _isEditor:Boolean;
		private var _physicsDict:Dictionary = new Dictionary();
		
		public function TileManager(isEditor:Boolean) 
		{
			_isEditor = isEditor;
			fillArray();
			makeTilePhysics();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		public function addTile(key:String, i:int, j:int, physicsNeeded:Boolean = true):void
		{
			//trace(key);
			_tile = new Image(Assets.getAtlasTexture(key));
			_tile.x = j * 21;
			_tile.y = i * 21;
			addChild(_tile);
			//trace(i, j, key);
			_tiles[i][j] = key;
			
			if (!_isEditor && physicsNeeded)
				createTileBody(key, j * 21, i * 21);
		}
		
		public function removeTile(i:int, j:int):Boolean
		{
			for (var k:int = 0; k < numChildren; ++k)
			{
				if (getChildAt(k).x == j * 21 && getChildAt(k).y == i * 21)
				{
					_tiles[i][j] = 0;
					removeChildAt(k, true);
					if (!_isEditor)
						PhysicWorld.world.DestroyBody(_bodies[i][j]);
					return true;
				}
			}
			
			return false;
		}
		
		private function createTileBody(key:String, X:Number, Y:Number):void
		{
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_staticBody;
			bodyDef.position.Set(X / PhysicWorld.SCALE, Y / PhysicWorld.SCALE);
			bodyDef.userData = key;
			
			var body:b2Body = PhysicWorld.world.CreateBody(bodyDef);
			body.SetSleepingAllowed(true);
			body.SetAwake(false);
			//trace(key);
			var arr:Array = _physicsDict[key];
			for (var i:int = 0; i < arr.length; ++i)
			{
				var shape:b2PolygonShape = new b2PolygonShape();
				shape.SetAsArray(arr[i], arr[i].length);
				
				var fixtureDef:b2FixtureDef = new b2FixtureDef();
				fixtureDef.density = 1;
				fixtureDef.friction = 0.2;
				fixtureDef.restitution = 0.0;
				fixtureDef.shape = shape;
				fixtureDef.filter.categoryBits = Category.PLATFORM;
				//fixtureDef.filter.maskBits
				body.CreateFixture(fixtureDef);
			}
			
			_bodies[int(Y / 21)][int(X / 21)] = body;
		}
		
		public function clearTiles():void
		{
			for (var i:int = numChildren - 1; i >= 0; --i)
			{
				removeChild(getChildAt(i) as Image, true);
			}
			for (i = 0; i < _bodies.length; ++i)
			{
				for (var j:int = 0; j < _bodies[i].length; ++j)
				{
					if (_bodies[i][j])
						PhysicWorld.world.DestroyBody(_bodies[i][j]);
				}
			}
		}
		
		private function fillArray():void 
		{
			_bodies = [];
			_tiles = [];
			for (var i:int = 0; i < 384 / 21; ++i)
			{
				_bodies[i] = [];
				_tiles[i] = [];
				for (var j:int = 0; j < 568 / 21; ++j)
				{
					_tiles[i][j] = 0;
				}
			}
		}
		
		private function makeTilePhysics():void 
		{
			//var ptm_ratio:Number = PhysicWorld.SCALE;
			var ptm_ratio:Number = 50;
			_physicsDict["0210A"] = [[   new b2Vec2(10/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 10/ptm_ratio)  ,  new b2Vec2(29/ptm_ratio, 17/ptm_ratio)  ,  new b2Vec2(24/ptm_ratio, 17/ptm_ratio)  ,  new b2Vec2(10/ptm_ratio, 10/ptm_ratio)  ] ];
			_physicsDict["0210B"] = [[   new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 8/ptm_ratio)  ,  new b2Vec2(29/ptm_ratio, 21/ptm_ratio)  ,  new b2Vec2(25/ptm_ratio, 21/ptm_ratio)  ,  new b2Vec2(13/ptm_ratio, 8/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 0/ptm_ratio)  ] ];
			_physicsDict["1200A"] = [ [   new b2Vec2(8/ptm_ratio, 18/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 9/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(14/ptm_ratio, 9/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 18/ptm_ratio)  ] ,
									[   new b2Vec2(26/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(21/ptm_ratio, 7/ptm_ratio)  ,  new b2Vec2(14/ptm_ratio, 9/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ]];
			_physicsDict["1200B"] = [ [   new b2Vec2(21/ptm_ratio, 13/ptm_ratio)  ,  new b2Vec2(17/ptm_ratio, 14/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 9/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 0/ptm_ratio)  ] ,
									[   new b2Vec2(0/ptm_ratio, 9/ptm_ratio)  ,  new b2Vec2(17/ptm_ratio, 14/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 19/ptm_ratio)  ,  new b2Vec2(7/ptm_ratio, 20/ptm_ratio)  ]];
			_physicsDict["1310A"] = [[   new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(6/ptm_ratio, 10/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 10/ptm_ratio)  ] ,
									[   new b2Vec2(26/ptm_ratio, 13/ptm_ratio)  ,  new b2Vec2(6/ptm_ratio, 10/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 9/ptm_ratio)  ,  new b2Vec2(33/ptm_ratio, 13/ptm_ratio)  ] ,
									[   new b2Vec2(17/ptm_ratio, 17/ptm_ratio)  ,  new b2Vec2(6/ptm_ratio, 10/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 13/ptm_ratio)  ,  new b2Vec2(23/ptm_ratio, 17/ptm_ratio)  ]];
			_physicsDict["1310B"] = [[   new b2Vec2(17/ptm_ratio, 29/ptm_ratio)  ,  new b2Vec2(14/ptm_ratio, 26/ptm_ratio)  ,  new b2Vec2(14/ptm_ratio, 22/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 24/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 31/ptm_ratio)  ] ,
									[   new b2Vec2(10/ptm_ratio, 16/ptm_ratio)  ,  new b2Vec2(32/ptm_ratio, 12/ptm_ratio)  ,  new b2Vec2(33/ptm_ratio, 17/ptm_ratio)  ,  new b2Vec2(14/ptm_ratio, 22/ptm_ratio)  ,  new b2Vec2(10/ptm_ratio, 22/ptm_ratio)  ] ,
									[   new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 11/ptm_ratio)  ,  new b2Vec2(32/ptm_ratio, 12/ptm_ratio)  ,  new b2Vec2(7/ptm_ratio, 11/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 10/ptm_ratio)  ] ,
									[   new b2Vec2(7/ptm_ratio, 11/ptm_ratio)  ,  new b2Vec2(32/ptm_ratio, 12/ptm_ratio)  ,  new b2Vec2(10/ptm_ratio, 16/ptm_ratio)  ,  new b2Vec2(7/ptm_ratio, 14/ptm_ratio)  ] ,
									[   new b2Vec2(14/ptm_ratio, 22/ptm_ratio)  ,  new b2Vec2(33/ptm_ratio, 17/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 24/ptm_ratio)  ]];
			_physicsDict["1310C"] = [[   new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 11/ptm_ratio)  ,  new b2Vec2(10/ptm_ratio, 14/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 13/ptm_ratio)  ] ,
                                    [   new b2Vec2(25/ptm_ratio, 10/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 12/ptm_ratio)  ,  new b2Vec2(32/ptm_ratio, 14/ptm_ratio)  ,  new b2Vec2(25/ptm_ratio, 13/ptm_ratio)  ] ,
                                    [   new b2Vec2(21/ptm_ratio, 7/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(25/ptm_ratio, 10/ptm_ratio)  ] ,
                                    [   new b2Vec2(21/ptm_ratio, 7/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ] ,
                                    [   new b2Vec2(16/ptm_ratio, 10/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 11/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(21/ptm_ratio, 7/ptm_ratio)  ]];
			_physicsDict["1320A"] = [[   new b2Vec2(35/ptm_ratio, 27/ptm_ratio)  ,  new b2Vec2(21/ptm_ratio, 25/ptm_ratio)  ,  new b2Vec2(13/ptm_ratio, 20/ptm_ratio)  ,  new b2Vec2(4/ptm_ratio, 12/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ] ,
                                    [   new b2Vec2(21/ptm_ratio, 25/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 27/ptm_ratio)  ,  new b2Vec2(30/ptm_ratio, 31/ptm_ratio)  ,  new b2Vec2(24/ptm_ratio, 31/ptm_ratio)  ,  new b2Vec2(21/ptm_ratio, 29/ptm_ratio)  ] ,
                                    [   new b2Vec2(4/ptm_ratio, 12/ptm_ratio)  ,  new b2Vec2(13/ptm_ratio, 20/ptm_ratio)  ,  new b2Vec2(7/ptm_ratio, 20/ptm_ratio)  ,  new b2Vec2(4/ptm_ratio, 18/ptm_ratio)  ] ,
                                    [   new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(4/ptm_ratio, 12/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 10/ptm_ratio)  ] ,
                                    [   new b2Vec2(13/ptm_ratio, 20/ptm_ratio)  ,  new b2Vec2(21/ptm_ratio, 25/ptm_ratio)  ,  new b2Vec2(15/ptm_ratio, 23/ptm_ratio)  ]];
			_physicsDict["1320B"] = [[   new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(17/ptm_ratio, 7/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 12/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 11/ptm_ratio)  ] ,
                                    [   new b2Vec2(25/ptm_ratio, 13/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 27/ptm_ratio)  ,  new b2Vec2(27/ptm_ratio, 26/ptm_ratio)  ,  new b2Vec2(22/ptm_ratio, 22/ptm_ratio)  ] ,
                                    [   new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(17/ptm_ratio, 7/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ] ,
                                    [   new b2Vec2(17/ptm_ratio, 7/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(23/ptm_ratio, 11/ptm_ratio)  ,  new b2Vec2(20/ptm_ratio, 11/ptm_ratio)  ] ,
                                    [   new b2Vec2(23/ptm_ratio, 11/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(25/ptm_ratio, 13/ptm_ratio)  ]];
			_physicsDict["2310A"] = [[   new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(21/ptm_ratio, 16/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 26/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 30/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ] ,
                                    [   new b2Vec2(21/ptm_ratio, 16/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 9/ptm_ratio)  ,  new b2Vec2(32/ptm_ratio, 16/ptm_ratio)  ] ,
                                    [   new b2Vec2(11/ptm_ratio, 26/ptm_ratio)  ,  new b2Vec2(21/ptm_ratio, 16/ptm_ratio)  ,  new b2Vec2(20/ptm_ratio, 22/ptm_ratio)  ,  new b2Vec2(16/ptm_ratio, 26/ptm_ratio)  ] ,
                                    [   new b2Vec2(0/ptm_ratio, 30/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 26/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 28/ptm_ratio)  ,  new b2Vec2(7/ptm_ratio, 31/ptm_ratio)  ]];
			_physicsDict["2310B"] = [[   new b2Vec2(26/ptm_ratio, 13/ptm_ratio)  ,  new b2Vec2(22/ptm_ratio, 7/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(34/ptm_ratio, 13/ptm_ratio)  ] ,
                                    [   new b2Vec2(11/ptm_ratio, 24/ptm_ratio)  ,  new b2Vec2(8/ptm_ratio, 24/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(16/ptm_ratio, 10/ptm_ratio)  ,  new b2Vec2(16/ptm_ratio, 18/ptm_ratio)  ] ,
                                    [   new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(8/ptm_ratio, 24/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 27/ptm_ratio)  ] ,
                                    [   new b2Vec2(22/ptm_ratio, 7/ptm_ratio)  ,  new b2Vec2(19/ptm_ratio, 8/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ] ,
                                    [   new b2Vec2(0 / ptm_ratio, 0 / ptm_ratio)  ,  new b2Vec2(19 / ptm_ratio, 8 / ptm_ratio)  ,  new b2Vec2(16 / ptm_ratio, 10 / ptm_ratio)  ]];
			_physicsDict["2320A"] = [[   new b2Vec2(35/ptm_ratio, 27/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 27/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ]];
			_physicsDict["2320B"] = [[   new b2Vec2(27/ptm_ratio, 11/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(30/ptm_ratio, 15/ptm_ratio)  ,  new b2Vec2(27/ptm_ratio, 14/ptm_ratio)  ] ,
                                    [   new b2Vec2(5/ptm_ratio, 15/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(9/ptm_ratio, 11/ptm_ratio)  ,  new b2Vec2(8/ptm_ratio, 14/ptm_ratio)  ] ,
                                    [   new b2Vec2(0/ptm_ratio, 27/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(5/ptm_ratio, 15/ptm_ratio)  ,  new b2Vec2(5/ptm_ratio, 23/ptm_ratio)  ] ,
                                    [   new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(27/ptm_ratio, 11/ptm_ratio)  ,  new b2Vec2(9/ptm_ratio, 11/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ] ,
                                    [   new b2Vec2(35/ptm_ratio, 27/ptm_ratio)  ,  new b2Vec2(32/ptm_ratio, 26/ptm_ratio)  ,  new b2Vec2(30/ptm_ratio, 15/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ]];
			_physicsDict["2320C"] = [[   new b2Vec2(35/ptm_ratio, 27/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 28/ptm_ratio)  ,  new b2Vec2(4/ptm_ratio, 27/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ] ,
                                    [   new b2Vec2(10/ptm_ratio, 31/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 28/ptm_ratio)  ,  new b2Vec2(25/ptm_ratio, 32/ptm_ratio)  ,  new b2Vec2(23/ptm_ratio, 34/ptm_ratio)  ,  new b2Vec2(13/ptm_ratio, 34/ptm_ratio)  ] ,
                                    [   new b2Vec2(4/ptm_ratio, 27/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 28/ptm_ratio)  ,  new b2Vec2(10/ptm_ratio, 31/ptm_ratio)  ,  new b2Vec2(7/ptm_ratio, 30/ptm_ratio)  ] ,
                                    [   new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(4/ptm_ratio, 27/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 27/ptm_ratio)  ]];
			_physicsDict["3333A"] = [[   new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ]];
			_physicsDict["3333B"] = [[   new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ]];
			_physicsDict["3333C"] = [[   new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ]];
			_physicsDict["3333D"] = [[   new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ]];
			_physicsDict["0110A"] = [[   new b2Vec2(35/ptm_ratio, 13/ptm_ratio)  ,  new b2Vec2(32/ptm_ratio, 16/ptm_ratio)  ,  new b2Vec2(25/ptm_ratio, 11/ptm_ratio)  ,  new b2Vec2(22/ptm_ratio, 4/ptm_ratio)  ,  new b2Vec2(24/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ]];
			_physicsDict["0110B"] = [[   new b2Vec2(28/ptm_ratio, 7/ptm_ratio)  ,  new b2Vec2(24/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 9/ptm_ratio)  ]];
			_physicsDict["0110C"] = [[   new b2Vec2(35/ptm_ratio, 11/ptm_ratio)  ,  new b2Vec2(32/ptm_ratio, 14/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 14/ptm_ratio)  ,  new b2Vec2(23/ptm_ratio, 9/ptm_ratio)  ,  new b2Vec2(23/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ]];
			_physicsDict["0120A"] = [[   new b2Vec2(21/ptm_ratio, 2/ptm_ratio)  ,  new b2Vec2(24/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(25/ptm_ratio, 11/ptm_ratio)  ,  new b2Vec2(21/ptm_ratio, 8/ptm_ratio)  ] ,
                                    [   new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(29/ptm_ratio, 15/ptm_ratio)  ,  new b2Vec2(27/ptm_ratio, 14/ptm_ratio)  ,  new b2Vec2(25/ptm_ratio, 11/ptm_ratio)  ] ,
                                    [   new b2Vec2(31/ptm_ratio, 17/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 27/ptm_ratio)  ,  new b2Vec2(32/ptm_ratio, 22/ptm_ratio)  ] ,
                                    [   new b2Vec2(29/ptm_ratio, 15/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(31/ptm_ratio, 17/ptm_ratio)  ]];
			_physicsDict["0120B"] = [[   new b2Vec2(35/ptm_ratio, 27/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 14/ptm_ratio)  ,  new b2Vec2(22/ptm_ratio, 7/ptm_ratio)  ,  new b2Vec2(24/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ] ,
                                    [   new b2Vec2(26/ptm_ratio, 14/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 27/ptm_ratio)  ,  new b2Vec2(31/ptm_ratio, 27/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 22/ptm_ratio)  ] ,
                                    [   new b2Vec2(24/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(22/ptm_ratio, 7/ptm_ratio)  ,  new b2Vec2(22/ptm_ratio, 3/ptm_ratio)  ]];
			_physicsDict["0131A"] = [[   new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(31/ptm_ratio, 14/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 9/ptm_ratio)  ,  new b2Vec2(24/ptm_ratio, 0/ptm_ratio)  ] ,
                                    [   new b2Vec2(26/ptm_ratio, 28/ptm_ratio)  ,  new b2Vec2(30/ptm_ratio, 26/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(24/ptm_ratio, 35/ptm_ratio)  ] ,
                                    [   new b2Vec2(31/ptm_ratio, 14/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(30/ptm_ratio, 26/ptm_ratio)  ]];
			_physicsDict["0131B"] = [[   new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(25/ptm_ratio, 30/ptm_ratio)  ,  new b2Vec2(24/ptm_ratio, 26/ptm_ratio)  ,  new b2Vec2(23/ptm_ratio, 8/ptm_ratio)  ,  new b2Vec2(24/ptm_ratio, 0/ptm_ratio)  ] ,
                                    [   new b2Vec2(25/ptm_ratio, 30/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(24/ptm_ratio, 35/ptm_ratio)  ] ,
                                    [   new b2Vec2(19/ptm_ratio, 12/ptm_ratio)  ,  new b2Vec2(23/ptm_ratio, 8/ptm_ratio)  ,  new b2Vec2(24/ptm_ratio, 26/ptm_ratio)  ,  new b2Vec2(19/ptm_ratio, 21/ptm_ratio)  ]];
			_physicsDict["0220A"] = [[   new b2Vec2(35/ptm_ratio, 28/ptm_ratio)  ,  new b2Vec2(31/ptm_ratio, 26/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 3/ptm_ratio)  ,  new b2Vec2(10/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ] ,
                                    [   new b2Vec2(13/ptm_ratio, 12/ptm_ratio)  ,  new b2Vec2(20/ptm_ratio, 21/ptm_ratio)  ,  new b2Vec2(13/ptm_ratio, 20/ptm_ratio)  ] ,
                                    [   new b2Vec2(20/ptm_ratio, 21/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 3/ptm_ratio)  ,  new b2Vec2(31/ptm_ratio, 26/ptm_ratio)  ,  new b2Vec2(24/ptm_ratio, 28/ptm_ratio)  ] ,
                                    [   new b2Vec2(12/ptm_ratio, 3/ptm_ratio)  ,  new b2Vec2(20/ptm_ratio, 21/ptm_ratio)  ,  new b2Vec2(13/ptm_ratio, 12/ptm_ratio)  ,  new b2Vec2(10/ptm_ratio, 6/ptm_ratio)  ]];
			_physicsDict["0220B"] = [[   new b2Vec2(35/ptm_ratio, 27/ptm_ratio)  ,  new b2Vec2(31/ptm_ratio, 27/ptm_ratio)  ,  new b2Vec2(24/ptm_ratio, 19/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ] ,
                                    [   new b2Vec2(11/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(24/ptm_ratio, 19/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 6/ptm_ratio)  ]];
			_physicsDict["0231A"] = [[   new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(15/ptm_ratio, 7/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ] ,
                                    [   new b2Vec2(15/ptm_ratio, 7/ptm_ratio)  ,  new b2Vec2(19/ptm_ratio, 16/ptm_ratio)  ,  new b2Vec2(15/ptm_ratio, 12/ptm_ratio)  ] ,
                                    [   new b2Vec2(24/ptm_ratio, 32/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(24/ptm_ratio, 35/ptm_ratio)  ] ,
                                    [   new b2Vec2(19/ptm_ratio, 16/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(24/ptm_ratio, 32/ptm_ratio)  ,  new b2Vec2(21/ptm_ratio, 31/ptm_ratio)  ] ,
                                    [   new b2Vec2(15/ptm_ratio, 7/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(19/ptm_ratio, 16/ptm_ratio)  ]];
			_physicsDict["0231B"] = [[   new b2Vec2(23/ptm_ratio, 17/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(27/ptm_ratio, 27/ptm_ratio)  ,  new b2Vec2(23/ptm_ratio, 25/ptm_ratio)  ] ,
                                    [   new b2Vec2(27/ptm_ratio, 32/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(24/ptm_ratio, 35/ptm_ratio)  ] ,
                                    [   new b2Vec2(27/ptm_ratio, 27/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(27/ptm_ratio, 32/ptm_ratio)  ] ,
                                    [   new b2Vec2(14/ptm_ratio, 9/ptm_ratio)  ,  new b2Vec2(14/ptm_ratio, 4/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(23/ptm_ratio, 17/ptm_ratio)  ] ,
                                    [   new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(14/ptm_ratio, 4/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 0/ptm_ratio)  ]];
			_physicsDict["0232A"] = [[   new b2Vec2(10/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(8/ptm_ratio, 26/ptm_ratio)  ,  new b2Vec2(7/ptm_ratio, 20/ptm_ratio)  ,  new b2Vec2(6/ptm_ratio, 8/ptm_ratio)  ,  new b2Vec2(10/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ] ,
                                    [   new b2Vec2(8/ptm_ratio, 26/ptm_ratio)  ,  new b2Vec2(10/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(7/ptm_ratio, 32/ptm_ratio)  ]];
			_physicsDict["0232B"] = [[   new b2Vec2(13/ptm_ratio, 3/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 13/ptm_ratio)  ,  new b2Vec2(13/ptm_ratio, 10/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 8/ptm_ratio)  ] ,
                                    [   new b2Vec2(20/ptm_ratio, 31/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 35/ptm_ratio)  ] ,
                                    [   new b2Vec2(20/ptm_ratio, 31/ptm_ratio)  ,  new b2Vec2(19/ptm_ratio, 27/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 13/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ] ,
                                    [   new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(13/ptm_ratio, 3/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 0/ptm_ratio)  ]];
			_physicsDict["0232C"] = [[   new b2Vec2(6/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(1/ptm_ratio, 19/ptm_ratio)  ,  new b2Vec2(3/ptm_ratio, 6/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ] ,
                                    [   new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(8/ptm_ratio, 5/ptm_ratio)  ,  new b2Vec2(8/ptm_ratio, 0/ptm_ratio)  ]];
			_physicsDict["0332A"] = [[   new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(6/ptm_ratio, 12/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ] ,
                                    [   new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(6/ptm_ratio, 12/ptm_ratio)  ,  new b2Vec2(2/ptm_ratio, 10/ptm_ratio)  ] ,
                                    [   new b2Vec2(12/ptm_ratio, 29/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 35/ptm_ratio)  ] ,
                                    [   new b2Vec2(9/ptm_ratio, 20/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 29/ptm_ratio)  ] ,
                                    [   new b2Vec2(6/ptm_ratio, 12/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(9/ptm_ratio, 20/ptm_ratio)  ]];
			_physicsDict["0332B"] = [[   new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(8/ptm_ratio, 10/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ] ,
                                    [   new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(8/ptm_ratio, 10/ptm_ratio)  ,  new b2Vec2(3/ptm_ratio, 10/ptm_ratio)  ] ,
                                    [   new b2Vec2(14/ptm_ratio, 26/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 30/ptm_ratio)  ] ,
                                    [   new b2Vec2(8/ptm_ratio, 10/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 19/ptm_ratio)  ,  new b2Vec2(8/ptm_ratio, 15/ptm_ratio)  ] ,
                                    [   new b2Vec2(11/ptm_ratio, 19/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(14/ptm_ratio, 26/ptm_ratio)  ,  new b2Vec2(10/ptm_ratio, 21/ptm_ratio)  ]];
			_physicsDict["1100A"] = [[   new b2Vec2(13/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(15/ptm_ratio, 5/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 11/ptm_ratio)  ,  new b2Vec2(3/ptm_ratio, 12/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 10/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ]];
			_physicsDict["1100B"] = [[   new b2Vec2(13/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(14/ptm_ratio, 6/ptm_ratio)  ,  new b2Vec2(4/ptm_ratio, 14/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 13/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ] ,
                                    [   new b2Vec2(4/ptm_ratio, 14/ptm_ratio)  ,  new b2Vec2(14/ptm_ratio, 6/ptm_ratio)  ,  new b2Vec2(9/ptm_ratio, 18/ptm_ratio)  ,  new b2Vec2(4/ptm_ratio, 17/ptm_ratio)  ]];
			_physicsDict["1100C"] = [[   new b2Vec2(4/ptm_ratio, 10/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 10/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 0/ptm_ratio)  ]];
			_physicsDict["2100A"] = [[   new b2Vec2(12/ptm_ratio, 8/ptm_ratio)  ,  new b2Vec2(8/ptm_ratio, 11/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 0/ptm_ratio)  ] ,
                                    [   new b2Vec2(8/ptm_ratio, 11/ptm_ratio)  ,  new b2Vec2(8/ptm_ratio, 15/ptm_ratio)  ,  new b2Vec2(5/ptm_ratio, 24/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 27/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ]];
			_physicsDict["2100B"] = [[   new b2Vec2(13/ptm_ratio, 9/ptm_ratio)  ,  new b2Vec2(3/ptm_ratio, 28/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 28/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(13/ptm_ratio, 0/ptm_ratio)  ] ,
                                    [   new b2Vec2(4/ptm_ratio, 31/ptm_ratio)  ,  new b2Vec2(3/ptm_ratio, 28/ptm_ratio)  ,  new b2Vec2(13/ptm_ratio, 9/ptm_ratio)  ,  new b2Vec2(15/ptm_ratio, 15/ptm_ratio)  ,  new b2Vec2(15/ptm_ratio, 21/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 27/ptm_ratio)  ,  new b2Vec2(9/ptm_ratio, 31/ptm_ratio)  ]];
			_physicsDict["2200A"] = [[   new b2Vec2(26/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(22/ptm_ratio, 11/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 22/ptm_ratio)  ,  new b2Vec2(8/ptm_ratio, 26/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 27/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ] ,
                                    [   new b2Vec2(20/ptm_ratio, 18/ptm_ratio)  ,  new b2Vec2(17/ptm_ratio, 19/ptm_ratio)  ,  new b2Vec2(22/ptm_ratio, 11/ptm_ratio)  ,  new b2Vec2(23/ptm_ratio, 15/ptm_ratio)  ] ,
                                    [   new b2Vec2(12/ptm_ratio, 22/ptm_ratio)  ,  new b2Vec2(22/ptm_ratio, 11/ptm_ratio)  ,  new b2Vec2(15/ptm_ratio, 22/ptm_ratio)  ]];
			_physicsDict["2200B"] = [[   new b2Vec2(27/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(19/ptm_ratio, 10/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 28/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ] ,
                                    [   new b2Vec2(3/ptm_ratio, 31/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 27/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 31/ptm_ratio)  ] ,
                                    [   new b2Vec2(3/ptm_ratio, 31/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 28/ptm_ratio)  ,  new b2Vec2(15/ptm_ratio, 16/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 27/ptm_ratio)  ] ,
                                    [   new b2Vec2(19/ptm_ratio, 10/ptm_ratio)  ,  new b2Vec2(27/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(24/ptm_ratio, 8/ptm_ratio)  ] ,
                                    [   new b2Vec2(0/ptm_ratio, 28/ptm_ratio)  ,  new b2Vec2(19/ptm_ratio, 10/ptm_ratio)  ,  new b2Vec2(15/ptm_ratio, 16/ptm_ratio)  ]];
			_physicsDict["3101A"] = [[   new b2Vec2(13/ptm_ratio, 7/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(13/ptm_ratio, 0/ptm_ratio)  ] ,
                                    [   new b2Vec2(19/ptm_ratio, 16/ptm_ratio)  ,  new b2Vec2(15/ptm_ratio, 27/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 32/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(13/ptm_ratio, 7/ptm_ratio)  ,  new b2Vec2(17/ptm_ratio, 9/ptm_ratio)  ] ,
                                    [   new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 32/ptm_ratio)  ,  new b2Vec2(13/ptm_ratio, 35/ptm_ratio)  ] ,
                                    [   new b2Vec2(15/ptm_ratio, 27/ptm_ratio)  ,  new b2Vec2(19/ptm_ratio, 16/ptm_ratio)  ,  new b2Vec2(18/ptm_ratio, 23/ptm_ratio)  ]];
			_physicsDict["3101B"] = [[   new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(7/ptm_ratio, 27/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 29/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 35/ptm_ratio)  ] ,
                                    [   new b2Vec2(11/ptm_ratio, 4/ptm_ratio)  ,  new b2Vec2(6/ptm_ratio, 7/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 0/ptm_ratio)  ] ,
                                    [   new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(5/ptm_ratio, 23/ptm_ratio)  ,  new b2Vec2(7/ptm_ratio, 27/ptm_ratio)  ] ,
                                    [   new b2Vec2(5/ptm_ratio, 23/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(6/ptm_ratio, 7/ptm_ratio)  ]];
			_physicsDict["3201A"] = [[   new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(8/ptm_ratio, 28/ptm_ratio)  ,  new b2Vec2(13/ptm_ratio, 35/ptm_ratio)  ] ,
                                    [   new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(9/ptm_ratio, 11/ptm_ratio)  ,  new b2Vec2(8/ptm_ratio, 28/ptm_ratio)  ] ,
                                    [   new b2Vec2(14/ptm_ratio, 5/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(21/ptm_ratio, 4/ptm_ratio)  ] ,
                                    [   new b2Vec2(14/ptm_ratio, 5/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 9/ptm_ratio)  ,  new b2Vec2(9/ptm_ratio, 11/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ]];
			_physicsDict["3201B"] = [[   new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(10/ptm_ratio, 25/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 35/ptm_ratio)  ] ,
                                    [   new b2Vec2(21/ptm_ratio, 9/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(25/ptm_ratio, 7/ptm_ratio)  ] ,
                                    [   new b2Vec2(10/ptm_ratio, 25/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 15/ptm_ratio)  ,  new b2Vec2(13/ptm_ratio, 22/ptm_ratio)  ] ,
                                    [   new b2Vec2(21/ptm_ratio, 9/ptm_ratio)  ,  new b2Vec2(18/ptm_ratio, 13/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 15/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ]];
			_physicsDict["3202A"] = [[   new b2Vec2(26/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ] ,
                                    [   new b2Vec2(33/ptm_ratio, 22/ptm_ratio)  ,  new b2Vec2(29/ptm_ratio, 32/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 33/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(33/ptm_ratio, 12/ptm_ratio)  ]];
			_physicsDict["3202B"] = [[   new b2Vec2(11/ptm_ratio, 26/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(14/ptm_ratio, 13/ptm_ratio)  ,  new b2Vec2(16/ptm_ratio, 18/ptm_ratio)  ] ,
                                    [   new b2Vec2(15/ptm_ratio, 9/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 3/ptm_ratio)  ,  new b2Vec2(21/ptm_ratio, 8/ptm_ratio)  ] ,
                                    [   new b2Vec2(26/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 26/ptm_ratio)  ,  new b2Vec2(25/ptm_ratio, 30/ptm_ratio)  ] ,
                                    [   new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(15/ptm_ratio, 9/ptm_ratio)  ,  new b2Vec2(14/ptm_ratio, 13/ptm_ratio)  ]];
			_physicsDict["3202C"] = [[   new b2Vec2(26/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(28/ptm_ratio, 8/ptm_ratio)  ,  new b2Vec2(25/ptm_ratio, 15/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ] ,
                                    [   new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(25/ptm_ratio, 22/ptm_ratio)  ,  new b2Vec2(28/ptm_ratio, 25/ptm_ratio)  ,  new b2Vec2(25/ptm_ratio, 35/ptm_ratio)  ] ,
                                    [   new b2Vec2(25/ptm_ratio, 22/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(25/ptm_ratio, 15/ptm_ratio)  ]];
			_physicsDict["3302A"] = [[   new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(27/ptm_ratio, 9/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ] ,
                                    [   new b2Vec2(27/ptm_ratio, 9/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(33/ptm_ratio, 7/ptm_ratio)  ] ,
                                    [   new b2Vec2(21/ptm_ratio, 17/ptm_ratio)  ,  new b2Vec2(27/ptm_ratio, 9/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 14/ptm_ratio)  ] ,
                                    [   new b2Vec2(26/ptm_ratio, 24/ptm_ratio)  ,  new b2Vec2(21/ptm_ratio, 31/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(21/ptm_ratio, 17/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 21/ptm_ratio)  ] ,
                                    [   new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(21/ptm_ratio, 31/ptm_ratio)  ,  new b2Vec2(25/ptm_ratio, 35/ptm_ratio)  ] ,
                                    [   new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(27/ptm_ratio, 9/ptm_ratio)  ,  new b2Vec2(21/ptm_ratio, 17/ptm_ratio)  ]];
			_physicsDict["3302B"] = [[   new b2Vec2(23/ptm_ratio, 12/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 6/ptm_ratio)  ,  new b2Vec2(27/ptm_ratio, 10/ptm_ratio)  ] ,
                                    [   new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(23/ptm_ratio, 28/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ] ,
                                    [   new b2Vec2(23/ptm_ratio, 28/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(23/ptm_ratio, 22/ptm_ratio)  ] ,
                                    [   new b2Vec2(26/ptm_ratio, 6/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 3/ptm_ratio)  ] ,
                                    [   new b2Vec2(20/ptm_ratio, 19/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(23/ptm_ratio, 12/ptm_ratio)  ,  new b2Vec2(23/ptm_ratio, 15/ptm_ratio)  ]];
			_physicsDict["0224A"] = [[   new b2Vec2(11/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(10/ptm_ratio, 11/ptm_ratio)  ,  new b2Vec2(21/ptm_ratio, 25/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 35/ptm_ratio)  ] ,
                                    [   new b2Vec2(35/ptm_ratio, 27/ptm_ratio)  ,  new b2Vec2(25/ptm_ratio, 19/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 4/ptm_ratio)  ,  new b2Vec2(10/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ] ,
                                    [   new b2Vec2(10/ptm_ratio, 11/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 4/ptm_ratio)  ,  new b2Vec2(22/ptm_ratio, 18/ptm_ratio)  ,  new b2Vec2(21/ptm_ratio, 25/ptm_ratio)  ] ,
                                    [   new b2Vec2(25/ptm_ratio, 19/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 27/ptm_ratio)  ,  new b2Vec2(28/ptm_ratio, 24/ptm_ratio)  ] ,
                                    [   new b2Vec2(12/ptm_ratio, 4/ptm_ratio)  ,  new b2Vec2(25/ptm_ratio, 19/ptm_ratio)  ,  new b2Vec2(22/ptm_ratio, 18/ptm_ratio)  ]];
			_physicsDict["0214A"] = [[   new b2Vec2(12/ptm_ratio, 26/ptm_ratio)  ,  new b2Vec2(23/ptm_ratio, 31/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 35/ptm_ratio)  ] ,
                                    [   new b2Vec2(26/ptm_ratio, 14/ptm_ratio)  ,  new b2Vec2(10/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 9/ptm_ratio)  ] ,
                                    [   new b2Vec2(13/ptm_ratio, 5/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 23/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 15/ptm_ratio)  ,  new b2Vec2(10/ptm_ratio, 8/ptm_ratio)  ] ,
                                    [   new b2Vec2(12/ptm_ratio, 15/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 23/ptm_ratio)  ,  new b2Vec2(23/ptm_ratio, 31/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 26/ptm_ratio)  ,  new b2Vec2(10/ptm_ratio, 22/ptm_ratio)  ] ,
                                    [   new b2Vec2(26/ptm_ratio, 23/ptm_ratio)  ,  new b2Vec2(13/ptm_ratio, 5/ptm_ratio)  ,  new b2Vec2(10/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 14/ptm_ratio)  ]];
			_physicsDict["0404A"] = [[   new b2Vec2(9/ptm_ratio, 24/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 21/ptm_ratio)  ,  new b2Vec2(25/ptm_ratio, 31/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 35/ptm_ratio)  ] ,
                                    [   new b2Vec2(25/ptm_ratio, 31/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 21/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 23/ptm_ratio)  ,  new b2Vec2(28/ptm_ratio, 27/ptm_ratio)  ] ,
                                    [   new b2Vec2(27/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(27/ptm_ratio, 7/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 21/ptm_ratio)  ,  new b2Vec2(7/ptm_ratio, 10/ptm_ratio)  ,  new b2Vec2(10/ptm_ratio, 0/ptm_ratio)  ] ,
                                    [   new b2Vec2(31/ptm_ratio, 18/ptm_ratio)  ,  new b2Vec2(29/ptm_ratio, 22/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 23/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 21/ptm_ratio)  ,  new b2Vec2(28/ptm_ratio, 11/ptm_ratio)  ,  new b2Vec2(31/ptm_ratio, 12/ptm_ratio)  ] ,
                                    [   new b2Vec2(28/ptm_ratio, 11/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 21/ptm_ratio)  ,  new b2Vec2(27/ptm_ratio, 7/ptm_ratio)  ]];
			_physicsDict["0404B"] = [[   new b2Vec2(12/ptm_ratio, 29/ptm_ratio)  ,  new b2Vec2(25/ptm_ratio, 30/ptm_ratio)  ,  new b2Vec2(27/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(10/ptm_ratio, 35/ptm_ratio)  ] ,
                                    [   new b2Vec2(12/ptm_ratio, 29/ptm_ratio)  ,  new b2Vec2(10/ptm_ratio, 27/ptm_ratio)  ,  new b2Vec2(25/ptm_ratio, 3/ptm_ratio)  ,  new b2Vec2(28/ptm_ratio, 11/ptm_ratio)  ,  new b2Vec2(25/ptm_ratio, 30/ptm_ratio)  ] ,
                                    [   new b2Vec2(26/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(13/ptm_ratio, 3/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 0/ptm_ratio)  ] ,
                                    [   new b2Vec2(26/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(25/ptm_ratio, 3/ptm_ratio)  ,  new b2Vec2(10/ptm_ratio, 27/ptm_ratio)  ,  new b2Vec2(9/ptm_ratio, 11/ptm_ratio)  ,  new b2Vec2(13/ptm_ratio, 3/ptm_ratio)  ]];
			_physicsDict["0404C"] = [[   new b2Vec2(26/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(25/ptm_ratio, 11/ptm_ratio)  ,  new b2Vec2(23/ptm_ratio, 18/ptm_ratio)  ,  new b2Vec2(15/ptm_ratio, 16/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 0/ptm_ratio)  ] ,
                                    [   new b2Vec2(11/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(15/ptm_ratio, 16/ptm_ratio)  ,  new b2Vec2(23/ptm_ratio, 18/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 35/ptm_ratio)  ]];
			_physicsDict["1204A"] = [[   new b2Vec2(11/ptm_ratio, 16/ptm_ratio)  ,  new b2Vec2(23/ptm_ratio, 30/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 35/ptm_ratio)  ] ,
                                    [   new b2Vec2(4/ptm_ratio, 10/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(23/ptm_ratio, 6/ptm_ratio)  ,  new b2Vec2(9/ptm_ratio, 12/ptm_ratio)  ,  new b2Vec2(6/ptm_ratio, 12/ptm_ratio)  ] ,
                                    [   new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(4/ptm_ratio, 10/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 10/ptm_ratio)  ] ,
                                    [   new b2Vec2(27/ptm_ratio, 14/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 26/ptm_ratio)  ,  new b2Vec2(23/ptm_ratio, 30/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 16/ptm_ratio)  ,  new b2Vec2(9/ptm_ratio, 12/ptm_ratio)  ,  new b2Vec2(23/ptm_ratio, 6/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 9/ptm_ratio)  ]];
			_physicsDict["1314A"] = [[   new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 10/ptm_ratio)  ,  new b2Vec2(7/ptm_ratio, 11/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 10/ptm_ratio)  ] ,
                                    [   new b2Vec2(9/ptm_ratio, 25/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 21/ptm_ratio)  ,  new b2Vec2(25/ptm_ratio, 31/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 35/ptm_ratio)  ] ,
                                    [   new b2Vec2(25/ptm_ratio, 31/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 21/ptm_ratio)  ,  new b2Vec2(25/ptm_ratio, 23/ptm_ratio)  ,  new b2Vec2(27/ptm_ratio, 25/ptm_ratio)  ] ,
                                    [   new b2Vec2(28/ptm_ratio, 23/ptm_ratio)  ,  new b2Vec2(25/ptm_ratio, 23/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 21/ptm_ratio)  ,  new b2Vec2(32/ptm_ratio, 13/ptm_ratio)  ,  new b2Vec2(33/ptm_ratio, 16/ptm_ratio)  ] ,
                                    [   new b2Vec2(35/ptm_ratio, 10/ptm_ratio)  ,  new b2Vec2(10/ptm_ratio, 16/ptm_ratio)  ,  new b2Vec2(7/ptm_ratio, 11/ptm_ratio)  ] ,
                                    [   new b2Vec2(35/ptm_ratio, 10/ptm_ratio)  ,  new b2Vec2(32/ptm_ratio, 13/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 21/ptm_ratio)  ,  new b2Vec2(10/ptm_ratio, 16/ptm_ratio)  ]];
			_physicsDict["2204A"] = [[   new b2Vec2(27/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(28/ptm_ratio, 7/ptm_ratio)  ,  new b2Vec2(25/ptm_ratio, 11/ptm_ratio)  ,  new b2Vec2(9/ptm_ratio, 26/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 27/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ] ,
                                    [   new b2Vec2(24/ptm_ratio, 21/ptm_ratio)  ,  new b2Vec2(9/ptm_ratio, 26/ptm_ratio)  ,  new b2Vec2(25/ptm_ratio, 11/ptm_ratio)  ,  new b2Vec2(28/ptm_ratio, 17/ptm_ratio)  ] ,
                                    [   new b2Vec2(9/ptm_ratio, 26/ptm_ratio)  ,  new b2Vec2(24/ptm_ratio, 21/ptm_ratio)  ,  new b2Vec2(28/ptm_ratio, 30/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(8/ptm_ratio, 31/ptm_ratio)  ]];
			_physicsDict["2324A"] = [[   new b2Vec2(35/ptm_ratio, 27/ptm_ratio)  ,  new b2Vec2(30/ptm_ratio, 27/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ] ,
                                    [   new b2Vec2(26/ptm_ratio, 32/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(30/ptm_ratio, 27/ptm_ratio)  ,  new b2Vec2(30/ptm_ratio, 30/ptm_ratio)  ] ,
                                    [   new b2Vec2(9/ptm_ratio, 30/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 32/ptm_ratio)  ,  new b2Vec2(25/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 35/ptm_ratio)  ] ,
                                    [   new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(9/ptm_ratio, 30/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 27/ptm_ratio)  ]];
			_physicsDict["1331A"] = [[   new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(21/ptm_ratio, 12/ptm_ratio)  ,  new b2Vec2(9/ptm_ratio, 11/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 9/ptm_ratio)  ] ,
                                    [   new b2Vec2(21 / ptm_ratio, 12 / ptm_ratio)  ,  new b2Vec2(35 / ptm_ratio, 0 / ptm_ratio)  ,  new b2Vec2(35 / ptm_ratio, 35 / ptm_ratio)  ,  new b2Vec2(24 / ptm_ratio, 35 / ptm_ratio)  ]];
			_physicsDict["1331B"] = [[   new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(24/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(13/ptm_ratio, 29/ptm_ratio)  ,  new b2Vec2(7/ptm_ratio, 22/ptm_ratio)  ,  new b2Vec2(1/ptm_ratio, 14/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ]];
			_physicsDict["1133A"] = [[   new b2Vec2(12/ptm_ratio, 24/ptm_ratio)  ,  new b2Vec2(21/ptm_ratio, 24/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 26/ptm_ratio)  ] ,
                                    [   new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 14/ptm_ratio)  ,  new b2Vec2(22/ptm_ratio, 3/ptm_ratio)  ,  new b2Vec2(24/ptm_ratio, 1/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ] ,
                                    [   new b2Vec2(26/ptm_ratio, 21/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(21/ptm_ratio, 24/ptm_ratio)  ] ,
                                    [   new b2Vec2(26/ptm_ratio, 14/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 21/ptm_ratio)  ]];
			_physicsDict["3113A"] = [[   new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(14/ptm_ratio, 24/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 24/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 26/ptm_ratio)  ] ,
                                    [   new b2Vec2(14/ptm_ratio, 6/ptm_ratio)  ,  new b2Vec2(14/ptm_ratio, 24/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 0/ptm_ratio)  ] ,
                                    [   new b2Vec2(14/ptm_ratio, 24/ptm_ratio)  ,  new b2Vec2(14/ptm_ratio, 14/ptm_ratio)  ,  new b2Vec2(16/ptm_ratio, 18/ptm_ratio)  ]];
			_physicsDict["3311A"] = [[   new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 8/ptm_ratio)  ,  new b2Vec2(28/ptm_ratio, 20/ptm_ratio)  ,  new b2Vec2(22/ptm_ratio, 29/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ]];
			_physicsDict["3311B"] = [[   new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 15/ptm_ratio)  ,  new b2Vec2(14/ptm_ratio, 25/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 35/ptm_ratio)  ] ,
                                    [   new b2Vec2(22/ptm_ratio, 10/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 9/ptm_ratio)  ] ,
                                    [   new b2Vec2(12/ptm_ratio, 15/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(22/ptm_ratio, 10/ptm_ratio)  ]];
			_physicsDict["0132A"] = [[   new b2Vec2(13/ptm_ratio, 19/ptm_ratio)  ,  new b2Vec2(19/ptm_ratio, 11/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 35/ptm_ratio)  ] ,
                                    [   new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(19/ptm_ratio, 11/ptm_ratio)  ,  new b2Vec2(25/ptm_ratio, 0/ptm_ratio)  ]];
			_physicsDict["2023A"] = [[   new b2Vec2(13/ptm_ratio, 21/ptm_ratio)  ,  new b2Vec2(14/ptm_ratio, 24/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(3/ptm_ratio, 26/ptm_ratio)  ,  new b2Vec2(5/ptm_ratio, 21/ptm_ratio)  ] ,
                                    [   new b2Vec2(32/ptm_ratio, 26/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(19/ptm_ratio, 24/ptm_ratio)  ,  new b2Vec2(19/ptm_ratio, 21/ptm_ratio)  ,  new b2Vec2(30/ptm_ratio, 21/ptm_ratio)  ] ,
                                    [   new b2Vec2(3/ptm_ratio, 26/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 26/ptm_ratio)  ] ,
                                    [   new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(32/ptm_ratio, 26/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 26/ptm_ratio)  ] ,
                                    [   new b2Vec2(14/ptm_ratio, 24/ptm_ratio)  ,  new b2Vec2(19/ptm_ratio, 24/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ]];
			_physicsDict["2233A"] = [[   new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 9/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ] ,
                                    [   new b2Vec2(12/ptm_ratio, 9/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 9/ptm_ratio)  ] ,
                                    [   new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 9/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 0/ptm_ratio)  ]];
			_physicsDict["2332A"] = [[   new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(8/ptm_ratio, 27/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ] ,
                                    [   new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(8/ptm_ratio, 27/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 27/ptm_ratio)  ]];
			_physicsDict["3102A"] = [[   new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 7/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ] ,
                                    [   new b2Vec2(11/ptm_ratio, 7/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 0/ptm_ratio)  ] ,
                                    [   new b2Vec2(26/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(16/ptm_ratio, 16/ptm_ratio)  ,  new b2Vec2(23/ptm_ratio, 20/ptm_ratio)  ]];
			_physicsDict["3223A"] = [[   new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(24/ptm_ratio, 8/ptm_ratio)  ,  new b2Vec2(30/ptm_ratio, 13/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ] ,
                                    [   new b2Vec2(24/ptm_ratio, 8/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 0/ptm_ratio)  ] ,
                                    [   new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(30/ptm_ratio, 13/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 9/ptm_ratio)  ]];
			_physicsDict["3322A"] = [[   new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(30/ptm_ratio, 26/ptm_ratio)  ,  new b2Vec2(25/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ] ,
                                    [   new b2Vec2(30/ptm_ratio, 26/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 26/ptm_ratio)  ]];
			//_physicsDict[""] = [];
			_physicsDict["S01"] = [[   new b2Vec2(35/ptm_ratio, 24/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(24/ptm_ratio, 30/ptm_ratio)  ,  new b2Vec2(29/ptm_ratio, 11/ptm_ratio)  ,  new b2Vec2(31/ptm_ratio, 11/ptm_ratio)  ] ,
                                   [   new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 31/ptm_ratio)  ,  new b2Vec2(24/ptm_ratio, 30/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ] ,
                                   [   new b2Vec2(12/ptm_ratio, 31/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(2/ptm_ratio, 11/ptm_ratio)  ,  new b2Vec2(4/ptm_ratio, 11/ptm_ratio)  ] ,
                                   [   new b2Vec2(17/ptm_ratio, 6/ptm_ratio)  ,  new b2Vec2(19/ptm_ratio, 6/ptm_ratio)  ,  new b2Vec2(24/ptm_ratio, 30/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 31/ptm_ratio)  ]];
			_physicsDict["S02"] = [[   new b2Vec2(25/ptm_ratio, 32/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 32/ptm_ratio)  ,  new b2Vec2(18/ptm_ratio, 20/ptm_ratio)  ] ,
                                   [   new b2Vec2(11/ptm_ratio, 32/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 22/ptm_ratio)  ,  new b2Vec2(5/ptm_ratio, 7/ptm_ratio)  ] ,
                                   [   new b2Vec2(35/ptm_ratio, 24/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(25/ptm_ratio, 32/ptm_ratio)  ,  new b2Vec2(27/ptm_ratio, 12/ptm_ratio)  ,  new b2Vec2(29/ptm_ratio, 7/ptm_ratio)  ] ,
                                   [   new b2Vec2(11/ptm_ratio, 32/ptm_ratio)  ,  new b2Vec2(25/ptm_ratio, 32/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ]];
			_physicsDict["S03"] = [[   new b2Vec2(0/ptm_ratio, 22/ptm_ratio)  ,  new b2Vec2(4/ptm_ratio, 17/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ]];
			_physicsDict["S04"] = [[   new b2Vec2(24/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(30/ptm_ratio, 17/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 23/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ]];
			_physicsDict["S05"] = [[   new b2Vec2(5/ptm_ratio, 8/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(21/ptm_ratio, 4/ptm_ratio)  ] ,
                                   [   new b2Vec2(14/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(5/ptm_ratio, 25/ptm_ratio)  ,  new b2Vec2(24/ptm_ratio, 30/ptm_ratio)  ] ,
                                   [   new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(5/ptm_ratio, 8/ptm_ratio)  ,  new b2Vec2(5/ptm_ratio, 25/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ] ,
                                   [   new b2Vec2(5/ptm_ratio, 10/ptm_ratio)  ,  new b2Vec2(29/ptm_ratio, 16/ptm_ratio)  ,  new b2Vec2(29/ptm_ratio, 18/ptm_ratio)  ,  new b2Vec2(5/ptm_ratio, 25/ptm_ratio)  ]];
			_physicsDict["S06"] = [[   new b2Vec2(3/ptm_ratio, 25/ptm_ratio)  ,  new b2Vec2(3/ptm_ratio, 9/ptm_ratio)  ,  new b2Vec2(17/ptm_ratio, 16/ptm_ratio)  ] ,
                                   [   new b2Vec2(3/ptm_ratio, 9/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(15/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(30/ptm_ratio, 4/ptm_ratio)  ] ,
                                   [   new b2Vec2(16/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(3/ptm_ratio, 25/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 30/ptm_ratio)  ] ,
                                   [   new b2Vec2(3/ptm_ratio, 25/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(3/ptm_ratio, 9/ptm_ratio)  ]];
			_physicsDict["S07"] = [[   new b2Vec2(16/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(18/ptm_ratio, 3/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 10/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ]];
			_physicsDict["S08"] = [[   new b2Vec2(0/ptm_ratio, 26/ptm_ratio)  ,  new b2Vec2(19/ptm_ratio, 29/ptm_ratio)  ,  new b2Vec2(14/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ]];
			_physicsDict["S09"] = [[   new b2Vec2(0/ptm_ratio, 13/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 4/ptm_ratio)  ,  new b2Vec2(3/ptm_ratio, 23/ptm_ratio)  ] ,
                                   [   new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(24/ptm_ratio, 5/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 4/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ] ,
                                   [   new b2Vec2(31/ptm_ratio, 24/ptm_ratio)  ,  new b2Vec2(29/ptm_ratio, 24/ptm_ratio)  ,  new b2Vec2(24/ptm_ratio, 5/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 13/ptm_ratio)  ] ,
                                   [   new b2Vec2(24/ptm_ratio, 5/ptm_ratio)  ,  new b2Vec2(19/ptm_ratio, 29/ptm_ratio)  ,  new b2Vec2(17/ptm_ratio, 29/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 4/ptm_ratio)  ]];
			_physicsDict["S10"] = [[   new b2Vec2(12/ptm_ratio, 3/ptm_ratio)  ,  new b2Vec2(25/ptm_ratio, 3/ptm_ratio)  ,  new b2Vec2(17/ptm_ratio, 15/ptm_ratio)  ] ,
                                   [   new b2Vec2(0/ptm_ratio, 13/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 3/ptm_ratio)  ,  new b2Vec2(4/ptm_ratio, 28/ptm_ratio)  ] ,
                                   [   new b2Vec2(28/ptm_ratio, 28/ptm_ratio)  ,  new b2Vec2(25/ptm_ratio, 3/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 13/ptm_ratio)  ,  new b2Vec2(31/ptm_ratio, 27/ptm_ratio)  ] ,
                                   [   new b2Vec2(12/ptm_ratio, 3/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(25/ptm_ratio, 3/ptm_ratio)  ]];
			_physicsDict["S11"] = [[   new b2Vec2(12/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(4/ptm_ratio, 17/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 10/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ]];
			_physicsDict["S12"] = [[   new b2Vec2(35/ptm_ratio, 12/ptm_ratio)  ,  new b2Vec2(30/ptm_ratio, 18/ptm_ratio)  ,  new b2Vec2(24/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ]];
			_physicsDict["S13"] = [[   new b2Vec2(21/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(30/ptm_ratio, 8/ptm_ratio)  ,  new b2Vec2(15/ptm_ratio, 4/ptm_ratio)  ] ,
                                   [   new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(30/ptm_ratio, 25/ptm_ratio)  ,  new b2Vec2(30/ptm_ratio, 8/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ] ,
                                   [   new b2Vec2(11/ptm_ratio, 30/ptm_ratio)  ,  new b2Vec2(30/ptm_ratio, 25/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(19/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 32/ptm_ratio)  ] ,
                                   [   new b2Vec2(30/ptm_ratio, 10/ptm_ratio)  ,  new b2Vec2(30/ptm_ratio, 25/ptm_ratio)  ,  new b2Vec2(6/ptm_ratio, 18/ptm_ratio)  ,  new b2Vec2(6/ptm_ratio, 16/ptm_ratio)  ]];
			_physicsDict["S14"] = [[   new b2Vec2(20/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(32/ptm_ratio, 10/ptm_ratio)  ,  new b2Vec2(6/ptm_ratio, 4/ptm_ratio)  ] ,
                                   [   new b2Vec2(32/ptm_ratio, 10/ptm_ratio)  ,  new b2Vec2(32/ptm_ratio, 26/ptm_ratio)  ,  new b2Vec2(20/ptm_ratio, 20/ptm_ratio)  ,  new b2Vec2(18/ptm_ratio, 16/ptm_ratio)  ] ,
                                   [   new b2Vec2(8/ptm_ratio, 30/ptm_ratio)  ,  new b2Vec2(32/ptm_ratio, 26/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(19/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(9/ptm_ratio, 32/ptm_ratio)  ] ,
                                   [   new b2Vec2(32/ptm_ratio, 10/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(32/ptm_ratio, 26/ptm_ratio)  ]];
			_physicsDict["S15"] = [[   new b2Vec2(18/ptm_ratio, 4/ptm_ratio)  ,  new b2Vec2(19/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 10/ptm_ratio)  ]];
			_physicsDict["S16"] = [[   new b2Vec2(21/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(16/ptm_ratio, 29/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 26/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ]];
			_physicsDict["A17"] = [[   new b2Vec2(27/ptm_ratio, 6/ptm_ratio)  ,  new b2Vec2(24/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 9/ptm_ratio)  ]];
			_physicsDict["A18"] = [[   new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(24/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(26/ptm_ratio, 30/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 26/ptm_ratio)  ]];
			_physicsDict["A19"] = [[   new b2Vec2(9/ptm_ratio, 28/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 26/ptm_ratio)  ]];
			_physicsDict["A20"] = [[   new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(12/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(11/ptm_ratio, 5/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 9/ptm_ratio)  ]];
			_physicsDict["S21"] = [[   new b2Vec2(35/ptm_ratio, 25/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(24/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(21/ptm_ratio, 22/ptm_ratio)  ]];
			_physicsDict["S22"] = [[   new b2Vec2(24/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(35/ptm_ratio, 10/ptm_ratio)  ,  new b2Vec2(21/ptm_ratio, 13/ptm_ratio)  ]];
			_physicsDict["S23"] = [[   new b2Vec2(13/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 35/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 25/ptm_ratio)  ,  new b2Vec2(15/ptm_ratio, 21/ptm_ratio)  ]];
			_physicsDict["S24"] = [[   new b2Vec2(0/ptm_ratio, 10/ptm_ratio)  ,  new b2Vec2(0/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(13/ptm_ratio, 0/ptm_ratio)  ,  new b2Vec2(15/ptm_ratio, 14/ptm_ratio)  ]];
		}
		
		public function get tiles():Array
		{
			return _tiles;
		}
	}
}