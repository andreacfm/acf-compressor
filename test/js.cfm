<cfscript>
//params
linebreak = 800;
munge = false;
verbose = false;
preserveAllSemiColons = false;	
disableOptimizations = true;

//get the compressor
jscompressor = createObject('java','railo.extension.io.text.YuiJsCompressor').init(lineBreak, munge, verbose, preserveAllSemiColons, disableOptimizations);

writedump(jscompressor);

//run the compression
source = expandPath('/acf-compressor/test/js/jquery.js');
destination = expandPath('/acf-compressor/test/js/jquery.min.js');
jscompressor.compress(source,destination);
</cfscript>