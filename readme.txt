INSTALLATION
--------------------------------

Copy the jar files 

/lib/YuiCompGateway.jar
/lib/yuicompressor.jar

into:

/WEB-INF/cfusion/lib/updates
( treating this as an update prevent us from any classloading matter ).

JS
-----------------------------

//get the compressor
jscompressor = createObject('java','railo.extension.io.text.YuiJsCompressor').init(lineBreak:int, munge:boolean, verbose:boolean, preserveAllSemiColons:boolean, disableOptimizations:boolean);

//run the compression
source = expandPath('/acf-compressor/test/js/jquery.js');
destination = expandPath('/acf-compressor/test/js/jquery.min.js');

jscompressor.compress(source,destination);


CSS
----------------------------

//invoke the compressor
csscompressor = createObject('java','railo.extension.io.text.YuiCssCompressor').init(lineBreak:int);

//run the compression
source = expandPath('/acf-compressor/test/css/core.css');
destination = expandPath('/acf-compressor/test/css/core.min.css');
csscompressor.compress(source,destination);


IMPORTANT:
---------------------------
The gateway is now container and engine indipendent.
The path passed as source and destination MUST BE ABSOLUTE.