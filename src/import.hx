
import haxe.io.Bytes;
import om.Json;

using om.StringTools;

#if js
import om.Promise;
#if nodejs
import js.Node.console;
import js.node.Fs;
import js.node.Http;
import js.node.Url;
#else
import om.Browser;
import om.Browser.console;
import om.Browser.document;
import om.Browser.navigator;
import om.Browser.window;
#end
#end

#if (sys||nodejs)
import Sys.print;
import Sys.println;
import sys.FileSystem;
import sys.io.File;
#end
