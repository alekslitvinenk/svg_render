package
{
	public class XmlUtils
	{
		/**
		 * Читает атрибуты узла XML и его значения и записывает их в объект
		 *
		 * @param node Узел XML чьи аттрибуты необходимо прочитать
		 * @param out Объект, в который записываются прочитанные значения
		 * @return Объект содержащий пары имя аттрибута - значение
		 *
		 */
		public static function readAttributes(node:XML, out:Object = null):Object
		{
			if(!out){
				out = {};
			}

			var atributes:XMLList = node.@*;

			var key:String;
			var val:*;

			for(var i:uint = 0; i < atributes.length(); i++)
			{
				key = atributes[i].name();
				val = atributes[i].toString();

				if(val === "false" || val === "true"){
					val = (val === "true") ? true : false;
				}

				out[key] = val;
			}

			return out;
		}

		/**
		 * Представляет простые дочерние текстовые узлы XML как пары имя узла - значение
		 *
		 * @param node Узел XML, занчения детей которого необходимо прочитать
		 * @param out Объект, в который записываются прочитанные значения
		 * @return Объект содержащий пары имя дочернего элемента - значение
		 *
		 */
		public static function readSimpleChildren(node:XML, out:Object = null):Object
		{
			if(!out){
				out = {};
			}

			var children:XMLList = node.children();
			var child:XML;

			var key:String;
			var val:*;

			for(var i:uint = 0; i < children.length(); i++)
			{
				child = children[i];

				if(child.hasSimpleContent()){

					key = child.name();
					val = child.toString();

					if(val === "false" || val === "true"){
						val = (val === "true") ? true : false;
					}

					out[key] = val;
				}
			}

			return out;
		}
	}
}
