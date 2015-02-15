# reloaded
Dub reload script to recompile project if any of the d or dt files change

This script is aimed at making development with vibe.d easier so that I don't have to keep manually restarting vibe.d after
making changes.

## Install

* dub build
* cp reloaded to/the/root/folder/of/your/dub/project

## Usage

* ./reloaded (run in the root folder of your dub project)

It will find the name of the project from the dub.json and then listen for changes in the filesystem where the files
are either ending in d or dt. It will then killall name_of_your_dub_project and then dub build it and then execute 
name_of_your_dub+project binary file that the build created.

Seems to work pretty well for me on OSX - no idea if it works on any platform or project type.

