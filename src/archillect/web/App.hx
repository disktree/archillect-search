package archillect.web;

import js.html.DivElement;
import js.html.FormElement;
import js.html.InputElement;
import om.FetchTools;

class App {

    //static inline var HOST = 'localhost';
    static inline var HOST = '195.201.41.121';
    static inline var PORT = 7777;

    static var data : Array<ImageMetaData>;

    static function search( term : String, ?precision : Float, ?limit : Int ) : Promise<Array<ImageMetaData>> {

        var url = 'http://$HOST:$PORT/?term=$term';
        if( precision != null ) url += '&precision=$precision';
        if( limit != null ) url += '&limit=$limit';

        return FetchTools.fetchJson( url, {
            //
        }).then( function(found:Array<ImageMetaData>){
            return found;
        });

        /*
        return FetchTools.fetchJson( 'http://$HOST:$PORT', {
            method: "POST",
            body: Json.stringify( {
                term: term,
                precision: precision,
                limit: limit
            } )
        } ).then( function(found:Array<ImageMetaData>){
            return found;
        });
        */
    }

    static function main() {

		window.onload = function(){

			var images = document.querySelector( 'ol.images' );
			var form : FormElement = cast document.querySelector( 'form' );
			var term : InputElement = cast document.querySelector( 'form input[name=search]' );
			var precision : InputElement = cast document.querySelector( 'form input[name=precision]' );
			var limit : InputElement = cast document.querySelector( 'form input[name=limit]' );
			var info : DivElement = cast document.querySelector( '.info' );

			//trace(window.location.search);

			window.onkeydown = function(e) {
				switch e.keyCode {
				case 13:
					var str = term.value.trim();
					if( str.length >= 2 ) {
                        str = str.toLowerCase();
						images.innerHTML = '';
						info.textContent = 'searching [$str]';
						var precisionValue = Std.parseFloat( precision.value );
						var limitValue = Std.parseInt( limit.value );
						search( str, precisionValue, limitValue ).then( function(found:Array<ImageMetaData>){
							data = found;
							if( data.length == 0 ) {
								window.alert( '0 items found' );
							} else {
								info.textContent = data.length+' items found';
								trace( data.length+' items found' );
								for( i in 0...data.length ) {
									var meta = found[i];
									var li = document.createLIElement();
									var a = document.createAnchorElement();
									a.target = '_blank';
									a.href = 'http://archillect.com/'+meta.index;
									var img = document.createImageElement();
									img.src = meta.url;
                                    img.title = 'Index: '+meta.index+'\n';
                                    for( c in meta.classification ) {
                                        img.title += '\t'+c.name+': '+c.precision+'\n';
                                    }
                                    //img.onload = function(){ //TODO check if all images are loaded }
									a.appendChild( img );
									li.appendChild( a );
									images.appendChild( li );
								//	if( i > limitValue )
								//		break;
								}
							}
						});
					}
				}
			}

			/*
			window.onblur = function(e) {
				form.style.opacity = '0';
			}
			window.onfocus = function(e) {
				form.style.opacity = '1';
			}
			*/

			/*
				var words = document.querySelector( '.words' );
				FetchTools.fetchJson('words.json').then( function(data:Array<String>){
				trace(data);
				for( name in data ) {
					var e = document.createDivElement();
					e.textContent = name;
					words.appendChild( e );
				}
			});
			*/
		}
    }

}
