package
{
	import flash.display.Sprite;

	public class SVGSprite extends Sprite
	{
		private static const SVG_INSTRUCTIONS:Vector.<String> = new <String>["path", "rect", "circle", "ellipse", "line", "polyline", "polygon"];

		private var lastX:Number = 0;
		private var lastY:Number = 0;

		private var startX:Number = 0;
		private var startY:Number = 0;

		private var pathStarted:Boolean;

		private var xml:XML;

		public function SVGSprite(xml:XML)
		{
			this.xml = xml;

			var instructions:Vector.<Object> = new <Object>[];

			var list:XMLList = xml.descendants("*");

			for each (var e:XML in list)
			{
				if(SVG_INSTRUCTIONS.indexOf(e.localName()) != -1)
				{
					instructions.push(XmlUtils.readAttributes(e, {command: e.localName()}));
				}
			}

			graphics.lineStyle(1, 0);

			var drawCommand:Object;

			for (var i:uint = 0; i < instructions.length; i++)
			{
				drawCommand = instructions[i];

				switch (drawCommand.command)
				{
					case "rect":
						drawRect(drawCommand);
						break;

					case "circle":
						drawCircle(drawCommand);
						break;

					case "ellipse":
						drawEllipse(drawCommand);
						break;

					case "line":
						drawLine(drawCommand);
						break;

					case "polyline":
						drawLine(drawCommand);
						break;

					case "polygon":
						drawLine(drawCommand);
						break;

					case "path":
						drawPath(drawCommand);
						break;

					default:
						break;
				}
			}
		}

		private function drawRect(obj:Object):void
		{
			graphics.drawRect(obj.x, obj.y, obj.width, obj. height);
		}


		private function drawCircle(obj:Object):void
		{
			graphics.drawCircle(obj.cx, obj.cy, obj.r);
		}

		private function drawEllipse(obj:Object):void
		{

		}

		private function drawLine(obj:Object):void
		{

		}

		private function drawPolyline(obj:Object):void
		{

		}

		private function drawPolygon(obj:Object):void
		{

		}

		private function drawPath(obj:Object):void
		{
			pathStarted = true;

			var rawCommands:Array = obj.d.match(/([a-z][^a-z]*)/ig);

			var cmdAndData:String;
			var pathCmd:String;
			var pathData:Array;

			for(var i:uint = 0; i < rawCommands.length; i++)
			{
				cmdAndData = rawCommands[i];
				pathCmd = cmdAndData.substr(0, 1);
				pathData = cmdAndData.substr(1).match(/-?\d+(\.\d+)?/g);

				this["_" + pathCmd].apply(this, pathData);
			}
		}

		//path drawing functions
		private function _M(x:Number, y:Number):void
		{
			lastX = x;
			lastY = y;

			if(pathStarted)
			{
				startX = lastX;
				startY = lastY;

				pathStarted = false;
			}

			graphics.moveTo(lastX, lastY);
		}

		private function _m(x:Number, y:Number):void
		{
			lastX += x;
			lastY += y;

			if(pathStarted)
			{
				startX = lastX;
				startY = lastY;

				pathStarted = false;
			}

			graphics.moveTo(lastX, lastY);
		}

		private function _L(x:Number, y:Number):void
		{
			lastX = x;
			lastY = y;

			graphics.lineTo(lastX, lastY);
		}

		private function _l(x:Number, y:Number):void
		{
			lastX += x;
			lastY += y;

			graphics.lineTo(lastX, lastY);
		}

		private function _H(x:Number):void
		{
			lastX = x;

			graphics.lineTo(lastX, lastY);
		}

		private function _h(x:Number):void
		{
			lastX += x;

			graphics.lineTo(lastX, lastY);
		}

		private function _V(y:Number):void
		{
			lastY = y;

			graphics.lineTo(lastX, lastY);
		}

		private function _v(y:Number):void
		{
			lastY += y;

			graphics.lineTo(lastX, lastY);
		}

		private function _C(x1:Number, y1:Number, x2:Number, y2:Number, x:Number, y:Number):void
		{
			lastX = x;
			lastY = y;

			graphics.cubicCurveTo(x1, y1, x2, y2, x, y);
		}

		private function _c(x1:Number, y1:Number, x2:Number, y2:Number, x:Number, y:Number):void
		{
			graphics.cubicCurveTo(lastX + x1, lastY + y1, lastX + x2, lastY + y2, lastX + x, lastY + y);

			lastX += x;
			lastY += y;
		}

		private function _Z(...rest):void
		{
			graphics.lineTo(startX, startY);
		}

		private function _z(...rest):void
		{
			graphics.lineTo(startX, startY);
		}

		//TODO: implement
		private function _S(...rest):void
		{

		}

		private function _s(...rest):void
		{

		}

		private function _Q(...rest):void
		{

		}

		private function _q(...rest):void
		{

		}

		private function _T(...rest):void
		{

		}

		private function _t(...rest):void
		{

		}

		private function _A(...rest):void
		{

		}

		private function _a(...rest):void
		{

		}
	}
}
