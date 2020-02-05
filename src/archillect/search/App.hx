package archillect.search;

#if (js&&!nodejs)

import js.html.ButtonElement;
import js.html.DivElement;
import js.html.FormElement;
import js.html.ImageElement;
import js.html.InputElement;
import js.html.OListElement;
import js.html.SelectElement;
import js.html.URLSearchParams;
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
    static var images : OListElement;
    
    @:expose("search")
	public static function search( term : String, ?precision : Float, ?limit : Int ) : Promise<Array<ImageMetaData>> {
		var path = '?term=$term';
		if( precision != null ) path += '&precision=$precision';
        if( limit != null ) path += '&limit=$limit';
		window.history.replaceState( '', '', path );
		return FetchTools.fetchJson( 'http://$HOST:$PORT/$path' );
    }

    @:expose("clear")
    public static function clear() {
        document.body.classList.remove('result');
        term.value = '';
        info.textContent = '';
        images.innerHTML = '';
        term.focus();
    }

    static function submitSearch() {
        var str = term.value.trim();
        if( str.length > 2 ) {
            str = str.toLowerCase();
            document.body.classList.remove('result');
            info.textContent = 'searching ...';
            search( str, Std.parseFloat( precision.value ), Std.parseInt( limit.value ) )
                .then( handleSearchResult );
        }
    }

    static function handleSearchResult( data : Array<ImageMetaData> ) {

        info.textContent = data.length+' items found';

        if( data.length > 0 ) {

            for( i in 0...data.length ) {

                var meta = data[i];
                //trace(meta);

                var li = document.createLIElement();
                //li.style.width = Std.string( meta.width )+'px';
                //li.style.height = Std.string( meta.height )+'px';
				images.appendChild( li );

                var a = document.createAnchorElement();
                a.target = '_blank';
                a.href = 'http://archillect.com/'+meta.index;
                li.appendChild( a );

                //TODO placeholder while loading

                var img = document.createImageElement();
                img.src = meta.url;
                img.title = 'Index: '+meta.index+'\n';
                for( c in meta.classification ) {
                    img.title += '  '+c.name+': '+c.precision+'\n';
                }
                //img.onload = function(e){}
                a.appendChild( img );
            }

            document.body.classList.add('result');

        } else {
			window.alert( '0 items found' );
            button.blur();
		}
    }

    static function updateInput() {
        var str = term.value.trim();
        if( str.length > 2 ) {
            button.removeAttribute('disabled');
        } else if( str.length == 0 ) {
            clear();
            button.setAttribute('disabled','');
        } else {
            button.setAttribute('disabled','');
        }
    }

    static function main() {

        console.log( '%cARCHILLECT-SEARCH', 'color:#fff;background:#000;' );

		window.onload = function(){

            var body = document.body;

			info = cast body.querySelector( '.info' );
			images = cast body.querySelector( 'ol.images' );

            form = cast body.querySelector( 'form' );
            term = cast form.querySelector( 'input[name=term]' );
            precision = cast form.querySelector( 'input[name=precision]' );
            limit = cast form.querySelector( 'input[name=limit]' );
            button = cast form.querySelector( 'button[name=submit]' );

            term.addEventListener( 'input', function(e){
                updateInput();
            });
            
            /*
            term.addEventListener( 'click', function(e){
                e.preventDefault();
				e.stopPropagation();
				term.select();
            });
            */

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
               //trace(e);
				switch e.keyCode {
                //case 83: // S
                    //e.preventDefault();
                    //term.focus();
                    //term.select();
                case 13: // Enter
                    submitSearch();
                case 67: // C
                    if( e.ctrlKey ) clear();
				}
            }
            
            window.onmessage == function(e){
                trace("TODO",e,e.data);
                switch e.data {
                case "clear": clear();
                case "search":
                    //TODO
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

            term.focus();
            
            var params = new URLSearchParams( window.location.search );
			if( params.has( 'precision' ) ) precision.value = params.get( 'precision' );
			if( params.has( 'limit' ) ) limit.value = params.get( 'limit' );
			if( params.has( 'term' ) ) {
                term.value = params.get( 'term' );
                updateInput();
				submitSearch();
			}
		}
    }

}

#end
