import std.stdio;
import std.algorithm;
import std.file;
import std.datetime;
import std.process;
import core.thread;
import std.json;
import std.conv;

void main()
{

auto content = to!string(read("dub.json"));
JSONValue doc = parseJSON(content).object;
string projectName = doc.object["name"].str;
writeln("found dub project: ",projectName);

  bool reload = false;
    while(true){

try{

  foreach(file ; dirEntries(".","*.{d,dt}",SpanMode.depth)){
       if(file.timeLastModified > Clock.currTime() - 3.seconds){
         reload = true;
         break;
       }

       if(reload){
         writeln("reloading");

spawnShell("killall " ~ projectName ~ " ; dub build && ./" ~ projectName ~ " &");

Thread.sleep( dur!("seconds")( 7 ) );

         reload = false;
         writeln("done reloading");
       }
  }} catch(Exception e){
        writeln("oops");
       }
 }
}
