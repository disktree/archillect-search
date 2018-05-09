package archillect.web;

class Service {

    static var data : Array<ImageMetaData>;

    static function search( term : String, ?precision : Float, ?limit : Int ) {
        term = term.toLowerCase();
        println( 'Searching: $term (precision:$precision,limit:$limit)' );
        var result = new Array<ImageMetaData>();
        for( i in 0...data.length ) {
            var meta = data[i];
            if( meta.classification == null )
                continue;
            for( cl in meta.classification ) {
                if( cl.name.toLowerCase() == term ) {
                    if( precision != null && precision > 0 && cl.precision < precision )
                        continue;
                    result.push( meta );
                }
            }
            if( limit != null && limit > 0 && result.length >= limit )
                break;
        }
        return result;
    }

    static function main() {

        var host = 'localhost';
        var port = 7777;
        var file = 'archillect.json';

        var argsHandler : Dynamic;
        argsHandler = hxargs.Args.generate([
            @doc("Host name") ["-host"] => (name:String) -> host = name,
            @doc("Port number") ["-port"] => (number:Int) -> port = number,
            @doc("Meta data file") ["-meta"] => (path:String) -> file = path,
            _ => (arg:String) -> {
                println( 'Unknown command: $arg' );
                println( argsHandler.getDoc() );
                Sys.exit(1);
	        }
        ]);
        argsHandler.parse( Sys.args() );

        Fs.readFile( file, (e,r) -> {

            if( e != null ) {
                println( 'file not found: $file' );
                Sys.exit(1);
            }

            data = Json.parse( r.toString() );
            println( data.length + ' items loaded into memory' );

            Http.createServer( (req,res) -> {
                var url = Url.parse( req.url, true );
                var query : Dynamic = url.query;
                var term = query.term;
                if( term == null ) {
                    res.writeHead( 404, { "Content-Type": "text/plain" } );
                    res.end();
                } else {
                    var precision = (query.precision != null) ? Std.parseInt( query.precision ) : 0;
                    var limit = (query.limit != null) ? Std.parseInt( query.limit ) : 0;
                    var found = search( query.term, precision, limit );
                    //TODO sort by precision
                    trace( 'Found: '+found.length );
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
