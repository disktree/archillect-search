package archillect.web;

import js.html.DivElement;
import js.html.FormElement;
import js.html.InputElement;
import js.html.OListElement;
import js.html.SelectElement;
import om.FetchTools;

class App {

    //static inline var HOST = 'localhost';
    static inline var HOST = '195.201.41.121';
    static inline var PORT = 7777;

    static var data : Array<ImageMetaData>;

    static var images : OListElement;
    static var form : FormElement;
    static var term : InputElement;
    static var precision : InputElement;
    static var limit : InputElement;
    //static var sort : SelectElement;
    static var info : DivElement;

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

    static function submit() {

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

                    //TODO sort
                    //var sort = cast document.querySelector( 'form select[name=sort]' );

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

    static function main() {

		window.onload = function(){

			//trace(window.location.search);

            images = cast document.querySelector( 'ol.images' );
            form = cast document.querySelector( 'form' );
            term = cast document.querySelector( 'form input[name=search]' );
            precision = cast document.querySelector( 'form input[name=precision]' );
            limit = cast document.querySelector( 'form input[name=limit]' );
            info = cast document.querySelector( '.info' );

            term.focus();

			window.onkeydown = function(e) {
				switch e.keyCode {
				case 13: // Enter
                    submit();
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
