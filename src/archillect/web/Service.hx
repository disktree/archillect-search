package archillect.web;

import js.node.Http;

class Service {

    static var data : Array<ImageMetaData>;

    static function search( term : String, ?precision : Float, ?limit : Int ) {
        println( 'Searching: [$term, $precision, $limit]' );
        var found = new Array<ImageMetaData>();
        for( i in 0...data.length ) {
            var meta = data[i];
            if( meta.classification == null )
                continue;
            for( cl in meta.classification ) {
                if( cl.name == term ) {
                    if( precision != null && cl.precision >= precision )
                        found.push( meta );
                }
                if( limit != null && i >= limit )
                    break;
            }
        }
        return found;
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
            }).listen( port, host );
        });
    }

}
