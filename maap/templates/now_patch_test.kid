<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:py="http://purl.org/kid/ns#" py:extends="'master.kid'">

	<head>
	
		<meta content="text/html; charset=utf-8" http-equiv="Content-Type" py:replace="''" />
		
		<title>
			MAAP | Place Detail: ${place.title} 
		</title>
		
		<link rel="stylesheet" href="/static/css/style.css" media="screen" type="text/css" />
		<link rel="stylesheet" href="/static/css/home_style.css" media="screen" type="text/css" />
		<link rel="stylesheet" href="/static/css/print.css" media="print" type="text/css" />
		
		<script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=${tg.gmap_key}" type="text/javascript"></script> 
		<script type="text/javascript" src="/static/javascript/gmap_common.js"></script> 
		<script type="text/javascript" src="/static/javascript/gmap_patch.js"></script> 
		<script type="text/javascript" src="/static/javascript/MochiKit/DragAndDrop.js"></script> 
		<script type="text/javascript" src="/static/javascript/panzoom/panzoom.js"></script> 
		<script type="text/javascript" src="/static/javascript/maap-panzoom.js"></script> 
		<script src="/static/javascript/view_selector/view_selector.js" type="text/javascript"></script> 
		<script type="text/javascript" src="/static/javascript/swfobject.js"></script> 
		<script type="text/javascript">
		//<![CDATA[
		loadPlace(${place.latitude}, ${place.longitude}, '${place.getMarkerColor()}');
		//]]>
		</script> 
		
	</head>

	<body>
	<div id="nav-actions">
		<div id="nav-actions-inner">
		
			<div id="detailactions">
			
				<div class="detailaction">
					<a href="/place/"><img src="/static/images/icon_navigator_small.gif" align="top" /></a>
					<a href="/place/">Back to MAAP Navigator</a>
				</div>

				<div class="detailaction">
					Jump to 
					<form id="detailactionform">
						<select class="detailactionformselect" onchange="location = this.options[this.selectedIndex].value;"> 
							<option value="/place/${str(place.id)}">Choose Place</option>
							<option py:for="p in places" value="/place/${str(p.id)}">${p.title}</option>
						</select>
					</form> 
				</div>

				<div class="detailaction">
					<a href="#"><img src="/static/images/icon_print_small.gif" align="top" /></a>
					<a href="JavaScript:window.print();">Print This View</a>
				</div>
				
			</div>
			
			<h2>Place Detail</h2>
		    
		</div>
	</div>

							<div id="map_canvas" style="width: 270px; height: 207px;">
							</div>

</body>
</html>