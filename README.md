
# |  |  | ARCHILLECT-SEARCH

>  [Archillect](http://archillect.com/) image classification and search experiment.
>  http://archillect.disktree.net/search/

![](https://pbs.twimg.com/media/DfbIqw3XkAgv5IJ.jpg:large)


### API/Service

Example request to get meta data for the term **cat** with at least recognition precision of **0.5** and limit the results to **10**:
http://195.201.41.121:7777/?term=cat&precision=0.5&limit=10

Static image meta data files can be accessed by index like:
http://195.201.41.121/archillect/meta/1.json


#### Meta data fields

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


#### Classification wordlist

https://gist.github.com/tong/b0e4570fa1a7f8142ff90100fbb84521#file-archillect-words-txt
