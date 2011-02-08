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
		    <h2>Administer Places</h2>
		</div>
	</div>


	<table border="0" cellspacing="0">
	
		<colgroup span="5" id="administerplacestable01">
			<col id="thumb"></col>
			<col id="title"></col>
			<col id="filename"></col>
			<col id="edit"></col>
			<col id="delete"></col>
		</colgroup>
		
		<tr>
			<th>Thumb</th>
			<th>Title</th>
			<th>Filename</th>
			<th>Edit</th>
			<th>Delete</th>
		</tr>
		
		<tr py:for="i,map in enumerate(maps)" class="${i%2 and 'odd' or 'even'}">
		    <td>
				<a href="/place/then#map=${map.name}"><img src="${map.thumb_url}" /></a>
		    </td>
		    <td>
				${map.title}
				  &nbsp;
		    </td>
		    <td>
			<a href="/map/${map.id}">${map.name}</a>
				  &nbsp;
		    </td>
		    <td>
			<a href="/admin/map/${map.id}/;edit_form">Edit</a>
				  &nbsp;
		    </td>
		    <td>
			<a href="/admin/map/${map.id}/;edit_form">X</a>
				  &nbsp;
		    </td>
		 </tr>
		 
	</table>

</body>
</html>
