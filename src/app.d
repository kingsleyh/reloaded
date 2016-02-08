import std.algorithm;
import std.file;
import std.datetime;
import std.process;
import core.thread;
import std.json;
import std.conv;

import sdlang;
import io.text;

void main()
{
  string content, projectName;
  
  if (exists("dub.json"))
  {
    content = to!string(read("dub.json"));
    JSONValue doc = parseJSON(content).object;
    projectName = doc.object["name"].str;
  }
  else if (exists("dub.sdl"))
  {
    content = to!string(read("dub.sdl"));
    Tag root = parseSource(content);
    projectName = to!string(root.tags["name"][0].values[0]);
  }

  println("found dub project: ",projectName);

  bool reload = false;
  while(true)
  {

    try
    {
      foreach(file ; dirEntries(".","*.{d,dt}",SpanMode.depth))
      {
        if(file.timeLastModified > Clock.currTime() - 3.seconds){
          reload = true;
          break;
        }

        if (reload)
        {
          println("reloading");

          spawnShell("killall " ~ projectName ~ " ; dub build && ./" ~ projectName ~ " &");

          Thread.sleep( dur!("seconds")( 7 ) );

          reload = false;
          println("done reloading");
        }
      }
    }
    catch(Exception e)
    {
      println("oops");
    }
  }
}
