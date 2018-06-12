package archillect.web;

import js.html.DivElement;
import js.html.FormElement;
import js.html.ImageElement;
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

    static function submitSearch() {

        var str = term.value.trim();
        if( str.length >= 2 ) {

            str = str.toLowerCase();
            images.innerHTML = '';
            info.textContent = 'searching ...';

            var precisionValue = Std.parseFloat( precision.value );
            var limitValue = Std.parseInt( limit.value );

            search( str, precisionValue, limitValue ).then( handleSearchResult );
        }
    }

    static function handleSearchResult( found : Array<ImageMetaData> ) {

        data = found;

        if( data.length == 0 ) {
            window.alert( '0 items found' );
        } else {

            info.textContent = data.length+' items found';

            //trace( data.length+' items found' );
            //trace( data );

            //TODO sort
            //var sort = cast document.querySelector( 'form select[name=sort]' );

            var ol = document.createElement('ol');
            ol.classList.add( 'images' );
            document.body.appendChild( ol );

            for( i in 0...data.length ) {

                var meta = found[i];

                var li = document.createLIElement();

                var a = document.createAnchorElement();
                a.target = '_blank';
                a.href = 'http://archillect.com/'+meta.index;
                li.appendChild( a );

                var img = document.createImageElement();
                img.src = meta.url;
                img.title = 'Index: '+meta.index+'\n';
                for( c in meta.classification ) {
                    img.title += '\t'+c.name+': '+c.precision+'\n';
                }
                //img.onload = function(){  }
                a.appendChild( img );
                images.appendChild( li );

                //img.style.opacity = '1';
            }

            /*
            function loadNextImage( i : Int ) {
                var meta = data[i];
                var img : ImageElement = cast images.children[i].firstChild.firstChild;
                trace( meta );
                trace( img );
                img.src = meta.url;
                if( i < data.length-1 ) {
                    img.onload = function(){
                        loadNextImage( ++i );
                    }
                }
            }(0);
            */
        }
    }

    static function main() {

		window.onload = function(){

			//trace(window.location.search);

            form = cast document.querySelector( 'form' );
            term = cast document.querySelector( 'form input[name=term]' );
            precision = cast document.querySelector( 'form input[name=precision]' );
            limit = cast document.querySelector( 'form input[name=limit]' );
            info = cast document.querySelector( '.info' );

            images = cast document.querySelector( 'ol.images' );

            term.focus();
            //term.value = 'bikini';
            //submitSearch();

            /*
            var words : Array<Dynamic> = Json.parse( haxe.Resource.getString( 'words' ) );
            trace(words.length);
            var datalist = document.getElementById( 'terms_list' );
            for( word in words ) {
                var e = document.createOptionElement();
                e.value = word;
                datalist.appendChild( e );
            }
            */

            /*
            var storage = js.Browser.getLocalStorage();
            var settings = Json.parse( storage.getItem( 'archillect' ) );
            if( settings != null ) {
                precision.value = Std.string( settings.precision );
                limit.value = Std.string( settings.limit );
                term.value = Std.string( settings.term );
            }
            */

			window.onkeydown = function(e) {
                //trace(e.keyCode);
				switch e.keyCode {
                //case 83: // S
                    //term.focus();
                    //e.preventDefault();
                    //term.select();
				case 13: // Enter
                    submitSearch();
				}
			}

            /*
            window.onbeforeunload = function(e){
                storage.setItem( 'archillect', Json.stringify( {
                    precision: Std.parseFloat( precision.value ),
                    limit: Std.parseInt( limit.value ),
                    term: term.value
                } ) );
                return null;
            }
            */

            /*
            window.onblur = function(e) {
                form.classList.add( 'hidden' );
                //form.style.opacity = '0';
            }
            window.onfocus = function(e) {
                form.classList.remove( 'hidden' );
                //form.style.opacity = '1';
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
