#!/bin/bash


convert icon-1024.jpg icon-1024.png

 
# 29x29 at @2x and @3x
convert icon-1024.png -resize 58x58 -gravity center -extent 58x58 icon-29x29@2x.png
convert icon-1024.png -resize 87x87 -gravity center -extent 87x87 icon-29x29@3x.png

# 20 at @2x and @3x
convert icon-1024.png -resize 40x40 -gravity center -extent 40x40 icon-20x20@2x.png
convert icon-1024.png -resize 60x60 -gravity center -extent 60x60 icon-20x20@3x.png

# 40 at @2x and @3x
convert icon-1024.png -resize 80x80 -gravity center -extent 80x80 icon-40x40@2x.png
convert icon-1024.png -resize 120x120 -gravity center -extent 120x120 icon-40x40@3x.png

# 60 at @2x and @3x
convert icon-1024.png -resize 120x120 -gravity center -extent 120x120 icon-60x60@2x.png
convert icon-1024.png -resize 180x180 -gravity center -extent 180x180 icon-60x60@3x.png

# 20 at @1x and @2x
convert icon-1024.png -resize 20x20 -gravity center -extent 20x20 icon-20x20@1x.png
convert icon-1024.png -resize 40x40 -gravity center -extent 40x40 icon-20x20@2x-1.png

# 29 at @1x and @2x
convert icon-1024.png -resize 29x29 -gravity center -extent 29x29 icon-29x29@1x.png
convert icon-1024.png -resize 58x58 -gravity center -extent 58x58 icon-29x29@2x-1.png

# 40 at @1x and @2x
convert icon-1024.png -resize 40x40 -gravity center -extent 40x40 icon-40x40@1x.png
convert icon-1024.png -resize 80x80 -gravity center -extent 80x80 icon-40x40@2x-1.png

# 76 at @1x and @2x
convert icon-1024.png -resize 76x76 -gravity center -extent 76x76 icon-76x76@1x.png
convert icon-1024.png -resize 152x152 -gravity center -extent 152x152 icon-76x76@2x.png

# 83.5 at @2x
convert icon-1024.png -resize 167x167 -gravity center -extent 167x167 icon-83.5x83.5@2x.png



cp icon*{1x,2x,3x}*.png "../storydice3d/Assets.xcassets/AppIcon.appiconset/"


