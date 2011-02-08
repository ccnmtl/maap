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
	<script language="javascript" type="text/javascript" src="/static/javascript/tiny_mce/tiny_mce.js"></script>
	<script language="javascript" type="text/javascript" src="/static/javascript/tiny_mce_init.js"></script>
	
	<title>MAAP | Edit</title>
	
</head>

<body>

	<div id="nav-actions">
		<div id="nav-actions-inner">
		    <h2>Edit</h2>
		</div>
	</div>

	<p py:if="tg_errors">Form Error!</p>
	
	<div py:if="not record.patch.parent_map" style="float:right">
	<a href="/admin/patch/${record.patch.id}/;edit_form">Create a Patch</a>
	</div>
	
	<div py:if="record.patch and record.patch.parent_map" class="patch" style="float:right">
	
		<a href="/admin/patch/${record.patch.id}/;edit_form">Edit Patch</a>
		
		<div class="panzoom_container">
			<img id="panzoom1" 
			class="panzoom" 
			src="${hasattr(record.patch.parent_map, 'src_url') and record.patch.parent_map.src_url or ''}"
			alt="${hasattr(record.patch.parent_map, 'title') and record.patch.parent_map.title or ''}" />
		</div>
		
		<a id="panzoom1_permalink" href="/map/${record.patch.parent_map.id}/?${record.patch.src_url}">Link</a>
	
	</div>
	
	<p>
	${form(value=record_dict, submit_text="Save", form_attrs=[('id',"%s_%s" % (form.name,record.id) )] )}
	</p>
	
	<p>
	<a href="/admin/place">Back to List Places</a>
	</p>

</body>
</html>

