
import haxe.Json;
import haxe.io.Bytes;

using om.StringTools;

#if js
import js.Promise;
#if nodejs
import js.Node.console;
import js.node.Fs;
#else
import js.Browser.console;
import js.Browser.document;
import js.Browser.window;
#end
#end

#if (sys||nodejs)
import Sys.print;
import Sys.println;
import sys.FileSystem;
import sys.io.File;
#end
