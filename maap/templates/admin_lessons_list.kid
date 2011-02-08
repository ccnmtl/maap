<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xmlns:py="http://purl.org/kid/ns#" py:extends="'master.kid'">

<head>

	<meta content="text/html; charset=utf-8" http-equiv="Content-Type" py:replace="''"/>
	
	<title>MAAP | Administer Maps</title>
	
</head>

<body>

	<div id="nav-actions">
		<div id="nav-actions-inner">
			<h2>Administer Maps</h2>
		</div>
	</div>


		
	<table border="0" cellspacing="0">
	
		<colgroup span="4" id="administermapstable">
			<col id="placetitle"></col>
			<col id="view"></col>
			<col id="edit"></col>
			<col id="delete"></col>
		</colgroup>
		
		<tr>
			<th>Place Title</th>
			<th>View</th>
			<th>Edit</th>
			<th>Delete</th>
		</tr>
		
		<tr py:for="i,lesson in enumerate(lessons)" class="${i%2 and 'odd' or 'even'}">
			<td>
			${lesson.title}
			&nbsp;
			</td>
			<td>
			<a href="/admin/lesson/${lesson.id}">${lesson.name}</a>
			&nbsp;
			</td>
			<td>
			<a href="/admin/lesson/${lesson.id}/;edit_form">Edit</a>
			&nbsp;
			</td>
			<td>
			<a href="/admin/lesson/${lesson.id}/;edit_form">X</a>
			&nbsp;
			</td>
		</tr>
	
	</table>

</body>

</html>
