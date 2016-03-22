package
{
	import flash.display.Sprite;

	public class Main extends Sprite
	{
		[Embed(source="/../assets/svg.xml", mimeType="application/octet-stream")]
		private var xmlClass:Class;

		public function Main()
		{
			XML.ignoreComments = true;
			XML.ignoreWhitespace = true;
			XML.ignoreProcessingInstructions = true;
			XML.prettyIndent = 1;

			var xml:XML = XML(new xmlClass());

			addChild(new SVGSprite(xml));
		}
	}
}
