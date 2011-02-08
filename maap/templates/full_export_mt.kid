<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xmlns:py="http://purl.org/kid/ns#">

<head>

	<meta content="text/html; charset=utf-8" http-equiv="Content-Type" py:replace="''"/>
	
	<title>MAAP | Places Full Export</title>
	
</head>

<body>

<pre>	
<span py:for="i,place in enumerate(places)" class="${i%2 and 'odd' or 'even'}">
AUTHOR: 
TITLE: ${place.title}
BASENAME: ${place.name}
STATUS: Publish
ALLOW COMMENTS: 1
CONVERT BREAKS: textile_2
ALLOW PINGS: 1
PRIMARY CATEGORY: Places
CATEGORY: Places
DATE: 11/30/2009 02:39:02 PM
-----
BODY:
${place.body}
-----
EXTENDED BODY:
googlemap=
lat=${place.latitude}
lon=${place.longitude}
desc_audio=http://ccnmtl.columbia.edu/podcasts/projects/maap/${place.name}.mp3
<span py:if="place.featured_video">commentary_audio1=${place.featured_video.audio_url}
commentary_video1=${place.featured_video.download_url}</span>
<span py:if="place.then_image">image_then=${place.then_image.big_url}
image_then_title=${place.then_image.title}
image_then_source=${place.then_image.source}
image_then_caption=${place.then_image.caption}</span>
<span py:if="place.now_image">image_now=${place.now_image.big_url}
image_now_title=${place.now_image.title}
image_now_source=${place.now_image.source}
image_now_caption=${place.now_image.caption}</span>
-----
EXCERPT:

-----
KEYWORDS:

-----


--------
</span>
</pre>		 
</body>

</html>
