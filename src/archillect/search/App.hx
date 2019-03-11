package archillect.search;

#if (js&&!nodejs)

import js.html.ButtonElement;
import js.html.DivElement;
import js.html.FormElement;
import js.html.ImageElement;
import js.html.InputElement;
import js.html.OListElement;
import js.html.SelectElement;
import om.FetchTools;

class App {

	static inline var HOST = '195.201.41.121';
    static inline var PORT = 7777;

    static var form : FormElement;
    static var term : InputElement;
    static var precision : InputElement;
    static var limit : InputElement;
    static var button : ButtonElement;
    static var info : DivElement;
	//static var sort : SelectElement;
	static var images : OListElement;

    static function submitSearch() {
        var str = term.value.trim();
        if( str.length >= 2 ) {
            str = str.toLowerCase();
            search( str, Std.parseFloat( precision.value ), Std.parseInt( limit.value ) ).then( handleSearchResult );
			images.innerHTML = '';
			info.textContent = 'searching ...';
        }
    }

	static function search( term : String, ?precision : Float, ?limit : Int ) : Promise<Array<ImageMetaData>> {
        var url = 'http://$HOST:$PORT/?term=$term';
        if( precision != null ) url += '&precision=$precision';
        if( limit != null ) url += '&limit=$limit';
        return cast FetchTools.fetchJson( url );
    }

    static function handleSearchResult( data : Array<ImageMetaData> ) {

        info.textContent = data.length+' items found';

        if( data.length > 0 ) {

            for( i in 0...data.length ) {

                var meta = data[i];

                var li = document.createLIElement();
				images.appendChild( li );

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
                a.appendChild( img );
            }
        } else {
			window.alert( '0 items found' );
            button.blur();
		}
    }

    static function main() {

		window.onload = function(){

			info = cast document.querySelector( '.info' );
			images = cast document.querySelector( 'ol.images' );

            form = cast document.querySelector( 'form' );
            term = cast form.querySelector( 'input[name=term]' );
            precision = cast form.querySelector( 'input[name=precision]' );
            limit = cast form.querySelector( 'input[name=limit]' );
            button = cast form.querySelector( 'button[name=submit]' );

			var params = new js.html.URLSearchParams( window.location.search );
			if( params.has( 'precision' ) ) precision.value = params.get( 'precision' );
			if( params.has( 'limit' ) ) limit.value = params.get( 'limit' );
			if( params.has( 'term' ) ) {
				term.value = params.get( 'term' );
				submitSearch();
			}
            
			term.focus();

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

            button.onclick = function(e){
                submitSearch();
            }

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

#end
