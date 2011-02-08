<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:py="http://purl.org/kid/ns#" py:extends="'master.kid'">

<head>

	<meta content="text/html; charset=utf-8" http-equiv="Content-Type" py:replace="''"/>
	
	<title>MAAP | Administration Main Page</title>
	
</head>

<body>

	<div id="nav-actions">
		<div id="nav-actions-inner">
		    <h2>Administration Main Page</h2>
		</div>
	</div>


	<ul>
		<li><a href="/admin/place">List Places</a></li>
		<li><a href="/admin/module">List Modules</a></li>
		<li><a href="/admin/map">List Maps</a></li>
	</ul>
	
	<ul>
		<li><a href="/admin/place/;add_form">New Place</a></li>
		<li><a href="/admin/module/;add_form">New Module</a></li>
		<li><a href="/admin/map/;add_form">New Map</a></li>
	</ul>

	<ul>
	        <li><a href="/full_export_mt">Full Export</a> (MT Format)</li>
	</ul>

</body>
</html>
