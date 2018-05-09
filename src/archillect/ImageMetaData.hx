package archillect;

typedef ImageMetaData = {
	var index : Int;
	var url : String;
	@:optional var type : String;
	@:optional var size : Int;
	@:optional var width : Int;
	@:optional var height : Int;
	@:optional var brightness : Int;
	@:optional var classification : Array<Dynamic>;
	@:optional var face : Dynamic; //FaceData;
}
