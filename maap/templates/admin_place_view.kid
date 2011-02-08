<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:py="http://purl.org/kid/ns#" py:extends="'master.kid'">

<head>

	<meta content="text/html; charset=utf-8" http-equiv="Content-Type" py:replace="''"/>
	
	<title>MAAP | Administer Place</title>
	
	<link rel="stylesheet" href="/static/css/nowthen.css" media="screen" type="text/css" />
	<link rel="stylesheet" href="/static/css/nowthen.css" media="print" type="text/css" />
	
	<script type="text/javascript" src="/static/javascript/MochiKit/DragAndDrop.js"></script>
	<script type="text/javascript" src="/static/javascript/panzoom/panzoom.js"></script>
	<script type="text/javascript" src="/static/javascript/maap-panzoom.js"></script>

	<script type="text/javascript" src="/static/javascript/swfobject.js"></script>

</head>

<body>

	<div id="nav-actions">
		<div id="nav-actions-inner">
		    <h2>Administer Place</h2>
		</div>
	</div>

	<h3>Place Data (<a href="/admin/place/${place.id}/;edit_form">Edit</a>)</h3>
	
	<div>
	<colgroup span="2" id="placedatatable">
		<col id="name"></col>
		<col id="place"></col>
	</colgroup>
	
	<table>
		<tr>
			<th>Name</th>
			<th>Place</th>
		</tr>
	
		<tr py:for="c in columns">
			<td><strong>${c}</strong></td>
			<td>${getattr(place,c,None)}</td>
		</tr>
		<tr>
		  <td><strong>color</strong></td>
		  <td>${place.getMarkerColor()}</td>
		</tr>
	</table>
	</div>

	
	<div py:if="not place.patch.parent_map">
	  <h3>Associated Map Patch</h3>

	   No patch has been defined for this place.
	</div>
	
	<div py:if="place.patch.parent_map" class="patch">
	  <div style="float:right;position:relative;bottom:280px;">

	        <h3>Associated Map Patch</h3>
		<div class="panzoom_container">
			<img id="panzoom1" 
			class="panzoom" 
			src="${hasattr(place.patch.parent_map, 'src_url') and place.patch.parent_map.src_url or ''}"
			alt="${hasattr(place.patch.parent_map, 'title') and place.patch.parent_map.title or ''}" />
			<a id="panzoom1_permalink" href="/map/${place.patch.parent_map.id}/?${place.patch.src_url}">link</a>
		</div>
	  </div>	
	</div>

	
	<div>
	<h3>Related Images</h3>
	<table border="0" cellspacing="0">
	
	<colgroup span="3" id="relatedimagestable">
		<col id="name"></col>
		<col id="sourceurl"></col>
		<col id="edit"></col>
	</colgroup>
	
	<tr>
		<th>Name</th>
		<th>Source URL</th>
		<th>Edit</th>
	</tr>
	
	<tr py:for="i,image in enumerate(place.images)" class="${i%2 and 'odd' or 'even'}">
		<td>
		  <b>name:</b> <a href="/image/view/${str(image.id)}">${image.name}</a><br/>
		  <b>title:</b> ${image.title}<br/>
		  <b>source:</b> ${image.source}<br/>
		  <b>creator:</b> ${image.creator}<br/>
		  <b>caption:</b> ${image.caption}<br/>
		  <b>rights:</b> ${image.rights}<br/>
		  <b>subject:</b> ${image.subject}<br/>
		</td>
		<td><a href="/image/view/${str(image.id)}"><img src="${image.thumb_url}" /></a>&nbsp;</td>
	<td><a href="/admin/place/${str(place.id)}/image/${str(image.id)}/;edit_form">Edit</a></td>
	</tr>
	
	</table>
	
	<p>
	<a href="/admin/place/${str(place.id)}/image/;add_form">Associate a new Image with this Place</a>
	</p>			
	</div>
	<div>
	<h3>Associated Videos</h3>
	
	<table border="0" cellspacing="0">
	
	<colgroup span="4" id="associatedvideostable">
		<col id="name"></col>
		<col id="thumbnail"></col>
		<col id="streamurl"></col>
		<col id="edit"></col>
	</colgroup>
	
		<tr>
			<th>Name</th>
			<th>Thumbnail</th>
			<th>Edit</th>
		</tr>
		
		<tr py:for="i,video in enumerate(place.videos)" class="${i%2 and 'odd' or 'even'}">
			<td>
			  <b>name:</b> <a href="/video/${str(video.id)}">${video.name}</a>&nbsp;<br/>
			  <b>title:</b> ${video.title}<br/>
			  <b>source:</b> ${XML(video.source)}<br/>
			  <b>caption:</b> ${video.caption}<br/>
			  <b>rights:</b> ${video.rights}<br/>
			  <b>subject:</b> ${video.subject}<br/>
			  <b>download_url:</b> ${video.download_url}<br/>
			</td>
		    	<td>
			    <div>
			      <p id="player_${video.id}"><a href="http://www.macromedia.com/go/getflashplayer">Get the Flash Player</a> to see this player.</p>
			      <script type="text/javascript">
	  
				var s1 = new SWFObject("/static/flash/flvplayer.swf","single","300","170","7");
				s1.addParam("allowfullscreen","true");
				s1.addVariable("file","${video.stream_url}");
				s1.addVariable("image","${video.thumb_url}");
				s1.write("player_${video.id}");
			      </script>
			    </div>
			</td>
			<td><a href="/admin/place/${str(place.id)}/video/${str(video.id)}/;edit_form">Edit</a></td>
		</tr>
	
	</table>
	
	<p>
	<a href="/admin/place/${str(place.id)}/video/;add_form">Associate a new Video with this Place</a>
	</p>

	</div>
	
	<div py:if="place.lessons">
	
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
		
		<tr py:for="i,lesson in enumerate(place.lessons)" class="${i%2 and 'odd' or 'even'}">
			<td><a href="/lesson/${str(lesson.id)}">${lesson.title}</a>&nbsp;</td>
			<td><a href="/admin/lesson/${str(lesson.id)}/;edit_form">Edit</a>&nbsp;</td>
		</tr>
		
		</table>
	
	</div>
	
	<p>
	<a href="/admin/place">Back to List Places</a>
	</p>

</body>

</html>
