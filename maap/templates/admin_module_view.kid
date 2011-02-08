<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:py="http://purl.org/kid/ns#" py:extends="'master.kid'">

<head>

	<meta content="text/html; charset=utf-8" http-equiv="Content-Type" py:replace="''"/>
	
	<title>MAAP | Administer Module</title>
	
</head>

<body>

	<div id="nav-actions">
		<div id="nav-actions-inner">
		   <h2> Administer Module</h2>
		</div>
	</div>

	<h3>Module Data (<a href="/admin/module/${maap_module.id}/;edit_form">Edit</a>)</h3>
	
	<table>
	<tr py:for="c in columns">
	<td><strong>${c}</strong></td>
	<td>${getattr(maap_module,c,None)}</td>
	</tr>
	</table>

	<a name="lessons"></a>
	
	<h3>Related Lessons</h3>
	
	<table border="0" cellspacing="0">
	
		<colgroup span="2" id="relatedlessonstable">
			<col id="title"></col>
			<col id="edit"></col>
		</colgroup>
		
		<tr>
		<th>Title</th>
		<th>Edit</th>
		</tr>
		
		<tr py:for="i,lesson in enumerate(maap_module.lessons)" class="${i%2 and 'odd' or 'even'}">
		<td><a href="/lesson/${str(lesson.id)}">${lesson.title}</a>&nbsp;</td>
		<td><a href="/admin/module/${str(maap_module.id)}/lesson/${str(lesson.id)}/;edit_form">Edit</a>&nbsp;</td>
		</tr>
		
	</table>
	
	<p>
	<a href="/admin/module/${str(maap_module.id)}/lesson/;add_form">Associate a new Lesson with this Module</a>
	</p>
	
	<p>
	<a href="/admin/module">Back to List Modules</a>
	</p>
	
</body>

</html>
