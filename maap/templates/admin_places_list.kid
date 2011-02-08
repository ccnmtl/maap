<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xmlns:py="http://purl.org/kid/ns#" py:extends="'master.kid'">

<head>

	<meta content="text/html; charset=utf-8" http-equiv="Content-Type" py:replace="''"/>
	
	<title>MAAP | Administer Places</title>
	
</head>

<body>

	<div id="nav-actions">
		<div id="nav-actions-inner">
		    <h2>Administer Place</h2>s
		</div>
	</div>


	<table border="0" cellspacing="0" cellpadding="0" class="browsertable">
	
		<colgroup span="4" id="administerplacestable02">
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
	
		<tr py:for="i,place in enumerate(places)" class="${i%2 and 'odd' or 'even'}">
		    <td>
				${place.title}
				  &nbsp;
		    </td>
		    <td>
			<a href="/admin/place/${place.id}">${place.name}</a>
				  &nbsp;
		    </td>
		    <td>
			<a href="/admin/place/${place.id}/;edit_form">Edit</a>
				  &nbsp;
		    </td>
		    <td>
			<a href="/admin/place/${place.id}/;edit_form">X</a>
				  &nbsp;
		    </td>
		 </tr>
		 
	</table>

	<p>
	  <a href="/admin/">Back to Admin Main</a>
	</p>

</body>

</html>
