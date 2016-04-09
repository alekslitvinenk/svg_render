package test
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;

	import ru.alexli.misc.svg.SVGDocument;

	[SWF(backgroundColor="0xFFFFFF", width="800", height="600", frameRate="32")]
	public class Main extends Sprite
	{
		private var svgContainer:Sprite;

		private var filerLoader:FileReference;

		private var panel:Sprite;
		private var btnContainer:Sprite;

		public function Main()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align 	= StageAlign.TOP_LEFT;

			addChild(svgContainer = new Sprite());

			panel = new Sprite();
			panel.graphics.beginFill(0xCCCCCC, 0.3);
			panel.graphics.drawRect(0, 0, stage.stageWidth, 100);
			panel.graphics.endFill();
			addChild(panel);

			addChild(btnContainer = new Sprite());

			var loadBtn:SimpleButton = new load_btn();
			loadBtn.y = panel.height/2 - loadBtn.height/2;
			loadBtn.addEventListener(MouseEvent.CLICK, onLoadBtn);
			btnContainer.addChild(loadBtn);

			var cleanBtn:SimpleButton = new clean_btn();
			cleanBtn.x = cleanBtn.width * 2 + 20;
			cleanBtn.y = loadBtn.y;
			cleanBtn.addEventListener(MouseEvent.CLICK, onCleanBtn);
			btnContainer.addChild(cleanBtn);

			stage.addEventListener(Event.RESIZE, onStageResize);
			onStageResize();
		}
		
		//events
		private function onStageResize(event:Event = null):void
		{
			panel.width = stage.stageWidth;
			btnContainer.x = stage.stageWidth/2 - btnContainer.width/2;
		}

		private function onLoadBtn(event:MouseEvent):void
		{
			filerLoader = new FileReference();
			filerLoader.addEventListener(Event.SELECT, onFileSelected, false, 0, true);
			filerLoader.browse([new FileFilter("Svg files", "*.svg")]);
		}

		private function onFileSelected(event:Event):void
		{
			filerLoader.addEventListener(Event.COMPLETE, onFileLoaded, false, 0, true);
			filerLoader.load();
		}

		private function onFileLoaded(event:Event):void
		{
			var bytes:ByteArray = filerLoader.data;
			svgContainer.addChild(new SVGDocument(new XML(bytes.readUTFBytes(bytes.bytesAvailable))));
		}
		
		private function onCleanBtn(event:MouseEvent):void
		{
			svgContainer.removeChildren();
		}
	}
}
