xquery version "1.0-ml";
(xdmp:set-response-content-type("text/html"),
 '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">',
<html>
<head></head>
<body>
<h1>Postcode Search</h1>
<form id="searchform" method="POST" action="/v4/postcoder.xqy">
    <input type="text" name="postcode" />
    <button type="submit" title="Run Search">Go</button>
</form>
</body>
</html>)