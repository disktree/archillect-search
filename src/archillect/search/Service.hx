package archillect.search;

class Service {

    static var data : Array<ImageMetaData>;

    static function search( term : String, ?precision : Float, ?limit : Int ) {

        term = term.toLowerCase();
        //println( 'Searching: $term (precision:$precision,limit:$limit)' );

        var result = new Array<ImageMetaData>();

        for( i in 0...data.length ) {

            var meta = data[i];

            if( meta.classification == null )
                continue;

            for( cl in meta.classification ) {

                var clName = cl.name.toLowerCase();

                if( precision != null && precision > 0 && cl.precision < precision )
                    continue;

                var clWords : Array<String> = clName.split( ' ' );
                var added = false;
                for( word in clWords ) {
                    if( word == term ) {
                        result.push( meta );
                        added = true;
                        break;
                    }
                }
                if( added ) break;
            }

            if( limit != null && limit > 0 && result.length >= limit )
                break;

        }
        return result;
    }

	static function exit( ?msg : Dynamic, code = 0 ) {
		if( msg != null ) println( msg );
		Sys.exit( code );
	}

    static function main() {

        var host : String = null;
        var port = 7777;
        var file = 'archillect.json';

        var argsHandler : Dynamic;
        argsHandler = hxargs.Args.generate([
            @doc("Host name") ["-host"] => (name:String) -> host = name,
            @doc("Port number") ["-port"] => (number:Int) -> port = number,
            @doc("Meta data file") ["-meta"] => (path:String) -> file = path,
            _ => (arg:String) -> {
                exit( 'Unknown command: $arg\n'+argsHandler.getDoc(), 1 );
	        }
        ]);
        argsHandler.parse( Sys.args() );

		switch host {
		case null,'auto':
			host = om.Network.getLocalIP()[0];
			if( host == null ) exit( 'failed to resolve host name', 1 );
		default:
		}

        Fs.readFile( file, (e,r) -> {

            if( e != null ) {
                println( 'file not found: $file' );
                Sys.exit(1);
            }

            data = Json.parse( r.toString() );
            println( data.length + ' items loaded into memory' );

            println( 'Starting service $host:$port' );

            Http.createServer( (req,res) -> {
                var url = Url.parse( req.url, true );
                var query : Dynamic = url.query;
                var term = query.q;
                if( term == null ) {
                    res.writeHead( 404, { "Content-Type": "text/plain" } );
                    res.end();
                } else {
                    var precision = (query.precision != null) ? Std.parseFloat( query.precision ) : 0;
                    var limit = (query.limit != null) ? Std.parseInt( query.limit ) : 0;
					var term = query.q.toLowerCase();
					print( '${req.socket.remoteAddress} $term $precision $limit' );
                    var found = search( term, precision, limit );
					println( ' : '+found.length );
                    //println( 'Found: '+found.length );
                    res.writeHead( 200, {
                        'Access-Control-Allow-Origin': '*',
                        'Content-Type': 'application/json'
                    } );
                    res.end( Json.stringify( found ) );
                }

                /*
                if( req.method == 'POST' ) {
                    var str = '';
                    req.on( 'data', chunk -> str += chunk );
                    req.on( 'end', function(){
                        var json = Json.parse( str );
                        trace(json);
                        var found = search( json.term, json.precision, json.limit );
                        trace( 'Found: '+found.length );
                        res.writeHead( 200, {
                            'Access-Control-Allow-Origin': '*',
                            'Content-Type': 'application/json'
                        } );
                        res.end( Json.stringify( found ) );
                    });
                }
                */

            }).listen( port, host );
        });
    }

}
