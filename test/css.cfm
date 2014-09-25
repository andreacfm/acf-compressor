<cfscript>
//params
linebreak = 800;

//get the compressor
csscompressor = createObject('java','railo.extension.io.text.YuiCssCompressor').init(lineBreak);

writedump(csscompressor);

//run the compression
source = expandPath('/acf-compressor/test/css/core.css');
destination = expandPath('/acf-compressor/test/css/core.min.css');
csscompressor.compress(source,destination);
</cfscript>