<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	
<?python import sitetemplate ?>

<html xmlns="http://www.w3.org/1999/xhtml" xmlns:py="http://purl.org/kid/ns#" py:extends="master.kid">

<head>

	<meta content="text/html; charset=utf-8" http-equiv="Content-Type" py:replace="''"/>
	
	<link rel="stylesheet" href="/static/css/nowthen.css" media="screen" type="text/css" />
	<link rel="stylesheet" href="/static/css/nowthen.css" media="print" type="text/css" />

	<script type="text/javascript" src="/static/javascript/MochiKit/DragAndDrop.js"></script>
	<script type="text/javascript" src="/static/javascript/panzoom/panzoom.js"></script>
	<script type="text/javascript" src="/static/javascript/maap-panzoom.js"></script>
	<script type="text/javascript" src="/place/maps"></script>
	
	<title>MAAP | Edit</title>

</head>

<body>

	<div id="nav-actions">
		<div id="nav-actions-inner">
		    <h2>Edit</h2>
		</div>
	</div>

	<p py:if="tg_errors">Form Error!</p>
	
	${form(value=record_dict, submit_text="Save", form_attrs=[('id',"%s_%s" % (form.name,record.id) )] )}
	
	<div id="patchmaker" >
	  <div id="controls" class="controls">
	
		<div id="panzoom1_zoomIn" class="panzoom_control zoomIn panzoom1_zoomIn">+</div>
		
		<div id="panzoom1_zoomOut" class="panzoom_control zoomOut panzoom1_zoomOut">-</div>
		
		<!--a id="panzoom1_permalink" class="panzoom1_permalink" href="">Link</a-->
	  </div>
	</div>
	
	<div class="panzoom_container">
	
		<div id="panzoom1" class="panzoom">
		  <img style="width:100%;height:100%;" />
		</div>
	</div>
	
</body>

</html>

