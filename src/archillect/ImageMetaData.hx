package archillect;

typedef Color = {
	var r : Int;
	var g : Int;
	var b : Int;
	var a : Float;
}

typedef Classification = {
	var name : String;
	var precision : Float;
}

typedef ImageMetaData = {

	/** Index **/
	var index : Int;

	/****/
	var url : String;

	/** File type **/
	var type : String;

	/** File size **/
	var size : Null<Int>;

	/****/
	var width : Null<Int>;

	/****/
	var height : Null<Int>;

	/****/
	var colorSpace : String;

	/** Dominant color **/
	var color : Color;

	/** Brightness **/
	//var brightness : Int;
	var brightness : Float;

	/***/
	var classification : Array<Classification>;

	//var face : Dynamic; //FaceData;
}
