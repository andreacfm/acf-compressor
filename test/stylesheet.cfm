<cfsilent>
<!---
Railo CFStylesheet implementation - custom tag conversion
http://www.railo.ch/blog/index.cfm/2010/3/17/Beta-Railo-Extensions-CFJAVASCRIPT--CFSTYLESHEET
--->
<cfif NOT structKeyExists(variables, "thisTag")>
	<cfexit method="exittemplate" />
</cfif>

<cfparam name="attributes.src" type="any" default="" />
<cfparam name="attributes.path" type="String" default="" />
<cfparam name="attributes.urlpath" type="String" default="" />
<cfparam name="attributes.filename" type="String" default="" />
<cfparam name="attributes.cache" type="boolean" default="true" />
<cfparam name="attributes.debug" type="boolean" default="false" />
<cfparam name="attributes.lineBreak" type="numeric" default="800" />

<!---
merge (was "compress" - internal railo function!)
 --->
<cffunction name="merge" returntype="void" output="false">
	<cfargument name="key" required="true" type="String" />

	<cfset var compressor = getCompressor() />
	<cfset var files = attributes.src />
	<cfset var i = "" />
	<cfset var thistemp = "" />
	<cfset var temp = getTempDirectory() />
	<cfset var content = "/*Generated : #now()#*/" />
	<cfset var jsTemp = "" />
	<cfset var finalPath = expandPath('#attributes.path#/#key#.css') />

	<cfloop array="#files#" index="f">
		<cfset thistemp = temp & hash(f) />
		<cfset compressor.compress(f,thistemp) />
	</cfloop>

	<cfloop array="#files#" index="f">
		<cfset thistemp = temp & hash(f) />
		<cffile action="read" file="#thistemp#" variable="jsTemp" />
		<cfset content = content & jsTemp />
	</cfloop>

	<cffile action="write" file="#finalPath#" output="#content#" />

</cffunction>

<!---
getCompressor
Return the compressor instance.
 --->
<cffunction name="getCompressor" returntype="any" output="true">
	<cfreturn createObject("java", "railo.extension.io.text.YuiCssCompressor").init(attributes.lineBreak) />
</cffunction>

<!---
doInclude
 --->
<cffunction name="doInclude" returntype="void" output="true">
	<cfargument name="key" required="true" type="String" />

	<cfset var path = attributes.urlpath & key />

	<cfoutput>
		<link rel="stylesheet" type="text/css" href="#path#.css" />
	</cfoutput>

</cffunction>

<!---
doIncludeSource
 --->
<cffunction name="doIncludeSource" returntype="void" output="true">

	<cfset var files = attributes.src />

	<cfoutput>
	<cfloop array="#files#" index="f">
		<link rel="stylesheet" type="text/css" href="#f#" />
	</cfloop>
	</cfoutput>

</cffunction>

<!---
getKey
 --->
<cffunction name="getKey" returntype="String" output="false">

	<cfif structkeyExists(attributes,'filename') and len(attributes.filename)>
		<cfreturn attributes.filename />
	</cfif>

	<cfreturn hash(attributes.src.toString()) />

</cffunction>

<!---
cacheExists
 --->
<cffunction name="cacheExists" returntype="Boolean" output="false">
	<cfargument name="key" required="true" type="String" />

	<cfset var path = attributes.path & key & '.css' />
	<cfif fileExists(expandPath(path)) >
		<cfreturn true />
	</cfif>

	<cfreturn false />

</cffunction>

<!---
normalizePath
 --->
<cffunction name="normalizePath" returntype="String" output="false">
	<cfargument name="str" type="String" required="true" />

	<cfif right(arguments.str,1) neq '/'>
		<cfset arguments.str = arguments.str & '/' />
	</cfif>

	<cfreturn arguments.str>
</cffunction>

</cfsilent>
<cfif thisTag.executionMode EQ "start">

	<!---
	If debug is true files are outputted as originally are.
	url.cfjavascript_debug=true or attribute debug=true
	--->
	<cfif structKeyExists(url,'_cfstylesheet_debug')>
		<cfset attributes.debug = true />
	</cfif>
	<cfif attributes.debug >
		<cfset doIncludeSource() />
	<cfelse>

		<!---
		If the path has not been passed set to default.
		If not exists create that.
		If is custom make sure path ends with /
		--->
		<cfif not len(attributes.path) >
			<cfset attributes.path = '/_cfstylesheet/' />
		<cfelse>
			<cfset attributes.path = normalizePath(attributes.path) />
		</cfif>

		<cfif not directoryExists(attributes.path)>
			<cfdirectory action="create" directory="#attributes.path#">
		</cfif>

		<!---
		If src is simple value wrap into an array to normalize data.
		--->
		<cfif isSimpleValue( attributes.src )>
			<cfset attributes.src = [attributes.src] >
		</cfif>

		<!---
		Let's see if we have a cache available.
		Also check for force reload attributes in url scope. If exists file will be recompressed also if exists.
		The key is the filename or the generated hash.
		--->
		<cfif structKeyExists(url,'_cfstylesheet_nocache')>
			<cfset attributes.cache = false />
		</cfif>

		<cfset key = getKey() />

		<cfif attributes.cache and cacheExists(key) >
			<cfset doInclude(key) />
		<cfelse>
			<cfset merge(key) />
			<cfset doInclude(key) />
		</cfif>

	</cfif>
<cfelse>
	<cfexit method="exittag" />
</cfif>