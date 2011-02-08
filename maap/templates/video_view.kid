<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:py="http://purl.org/kid/ns#" py:extends="'master.kid'">
<script type="text/javascript" src="/static/javascript/swfobject.js"></script> 
<head>
	<meta content="text/html; charset=utf-8" http-equiv="Content-Type" py:replace="''" />
	<title>
		MAAP | Video View 
	</title>
</head>
<body>
	<div id="nav-actions">
		<div id="nav-actions-inner">
			<div id="detailactions">
				<div class="detailaction">
					&#171; <a href="javascript:history.back(1)">Back</a>
				</div>
			</div>
			<h2>
				${video.title} 
			</h2>
		</div>
	</div>

	<div style="margin-top: 20px;" align="center">
	
		<p id="player1"><a href="http://www.macromedia.com/go/getflashplayer">Get the Flash Player</a> to see this video.</p>
			
		<script type="text/javascript">
			var so = new SWFObject('/static/flash/flvplayer.swf','mpl','425','339','8');
			so.addParam('allowscriptaccess','always');
			so.addParam('allowfullscreen','true');
			so.addVariable('height','339');
			so.addVariable('width','425');
			so.addVariable('file','${video.stream_url}');
			so.addVariable('image','${video.thumb_url}');
			so.addVariable('id','video');
			so.write('player1');
		</script>

	</div>
	<div id="videodetail-metadata">
		<h3>
			${video.title} 
		</h3>
		
		<p py:if="video.caption">
				${video.caption}
		</p>
		
		<p py:if="video.source">
				Source:
			${XML(video.source)}
		</p>
		
		<p py:if="video.rights">
				Rights:
			${video.rights}
		</p>
		<p py:if="video.download_url">
		  <a href="${video.download_url}">Download this Video</a>
		</p>
	</div>
</body>
</html>
