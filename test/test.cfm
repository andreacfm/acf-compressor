<cfset src = ArrayNew(1)>
<cfset src[1] = ExpandPath("/acf-compressor/test/css/core.css")>
<cfset src[2] = ExpandPath("/acf-compressor/test/css/core.css")>

<cf_stylesheet 
	src="#src#"
	path="" /><!--- ui/style/ --->
Generated stylesheet file in path "webroot/_cfstylesheet/"<br>


<cfset src = ArrayNew(1)>
<cfset src[1] = ExpandPath("/acf-compressor/test/js/jquery.js")>
<cfset src[2] = ExpandPath("/acf-compressor/test/js/jquery.js")>

<cf_javascript 
	src="#src#" 
	path="" /><!--- js/ --->
Generated javascript file in path "webroot/_cfjavascript/"