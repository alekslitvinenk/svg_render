package ru.alexli.misc.svg
{
	import flash.display.Sprite;
	import flash.geom.Point;

	import ru.alexli.misc.svg.utils.XmlUtils;

	public class SVGDocument extends Sprite
	{
		private static const SVG_INSTRUCTIONS:Vector.<String> = new <String>["path", "rect", "circle", "ellipse", "line", "polyline", "polygon"];

		//lastCX and lastCY should remain uninitialized at this point;
		private var lastX:Number;
		private var lastY:Number;

		private var lastCX:Number = 0;
		private var lastCY:Number = 0;

		private var startX:Number = 0;
		private var startY:Number = 0;

		private var pathStarted:Boolean;

		private var xml:XML;

		public function SVGDocument(xml:XML)
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

			//graphics.lineStyle(1, 0);

			var drawCommand:Object;

			for (var i:uint = 0; i < instructions.length; i++)
			{
				drawCommand = instructions[i];

				if(drawCommand.hasOwnProperty("fill"))
				{
					setFill(drawCommand.fill);
				}

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

		private function setFill(value:String):void
		{
			value = value.substr(1);

			graphics.beginFill(parseInt(value, 16));
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
			trace("drawEllipse is not implemented yet");
		}

		private function drawLine(obj:Object):void
		{
			trace("drawLine is not implemented yet");
		}

		private function drawPolyline(obj:Object):void
		{
			trace("drawPolyline is not implemented yet");
		}

		private function drawPolygon(obj:Object):void
		{
			trace("drawPolygon is not implemented yet");
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

		private function resetLastCP():void
		{
			lastCX = Number.NaN;
			lastCY = Number.NaN;
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

			resetLastCP();
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

			resetLastCP();
		}

		private function _L(x:Number, y:Number):void
		{
			lastX = x;
			lastY = y;

			graphics.lineTo(lastX, lastY);

			resetLastCP();
		}

		private function _l(x:Number, y:Number):void
		{
			lastX += x;
			lastY += y;

			graphics.lineTo(lastX, lastY);

			resetLastCP();
		}

		private function _H(x:Number):void
		{
			lastX = x;

			graphics.lineTo(lastX, lastY);

			resetLastCP();
		}

		private function _h(x:Number):void
		{
			lastX += x;

			graphics.lineTo(lastX, lastY);

			resetLastCP();
		}

		private function _V(y:Number):void
		{
			lastY = y;

			graphics.lineTo(lastX, lastY);

			resetLastCP();
		}

		private function _v(y:Number):void
		{
			lastY += y;

			graphics.lineTo(lastX, lastY);

			resetLastCP();
		}

		private function _C(x1:Number, y1:Number, x2:Number, y2:Number, x:Number, y:Number):void
		{
			lastX = x;
			lastY = y;

			lastCX = x2;
			lastCY = y2;

			graphics.cubicCurveTo(x1, y1, x2, y2, x, y);
		}

		private function _c(x1:Number, y1:Number, x2:Number, y2:Number, x:Number, y:Number):void
		{
			lastCX = lastX + x2;
			lastCY = lastY + y2;

			graphics.cubicCurveTo(lastX + x1, lastY + y1, lastCX, lastCY, lastX + x, lastY + y);

			lastX += x;
			lastY += y;
		}

		private function _Z(...rest):void
		{
			graphics.lineTo(startX, startY);
			resetLastCP();
		}

		private function _z(...rest):void
		{
			graphics.lineTo(startX, startY);
			resetLastCP();
		}

		//TODO: implement
		private function _S(cx:Number, cy:Number, x:Number, y:Number):void
		{
			var lastCP:Point;

			if(isNaN(lastCX) || isNaN(lastCY))
			{
				lastCX = cx;
				lastCY = cy;
			}

			lastCP = new Point(lastCX, lastCY);
			var lastP:Point = new Point(lastX, lastY);

			//TODO: refine this code so that don't use Point object
			var newCP:Point = Point.interpolate(lastCP, lastP, 2);

			lastCX = cx;
			lastCY = cy;

			lastX = x;
			lastY = y;

			graphics.cubicCurveTo(newCP.x, newCP.y, cx, cy, x, y);
		}

		private function _s(cx:Number, cy:Number, x:Number, y:Number):void
		{
			var lastCP:Point;

			if(isNaN(lastCX) || isNaN(lastCY))
			{
				lastCX = lastX + cx;
				lastCY = lastY + cy;
			}

			lastCP = new Point(lastCX, lastCY);
			var lastP:Point = new Point(lastX, lastY);

			//TODO: refine this code so that don't use Point object
			var newCP:Point = Point.interpolate(lastCP, lastP, 2);

			lastCX = lastX + cx;
			lastCY = lastY + cy;

			lastX += x;
			lastY += y;

			graphics.cubicCurveTo(newCP.x, newCP.y, lastX + cx, lastY + cy, lastX, lastY);
		}

		private function _Q(...rest):void
		{
			trace("Q is not implemented yet");
		}

		private function _q(...rest):void
		{
			trace("q is not implemented yet");
		}

		private function _T(...rest):void
		{
			trace("T is not implemented yet");
		}

		private function _t(...rest):void
		{
			trace("t is not implemented yet");
		}

		private function _A(...rest):void
		{
			trace("A is not implemented yet");
		}

		private function _a(...rest):void
		{
			trace("a is not implemented yet");
		}
	}
}
