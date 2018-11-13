
# ARCHILLECT-SEARCH

>  [Archillect](http://archillect.com/) image classification and search experiment.
>  http://archillect.disktree.net/search/

![](https://pbs.twimg.com/media/DfbIqw3XkAgv5IJ.jpg:large)


### Data service

Request meta data like [index:0-170000]:
http://rrr.disktree.net/archillect/meta/1.json


#### Available fields

 - `index` Image index
 - `url` Image url
 - `width` Image width
 - `height` Image height
 - `type` Image files type (jpg,png,gif)
 - `size` Image file size (bytes)
 - `color` Dominant image color
 	- `r` Red
  	- `g` Green
  	- `b` Blue
  	- `a` Alpha
 - `brightness` Total image brightness
 - `classification` Image recognition classification list
 	- `name` Classification word
 	- `precision` Classification precision (0.0-1.0)


### Classification wordlist

https://gist.github.com/tong/b0e4570fa1a7f8142ff90100fbb84521#file-archillect-words-txt
