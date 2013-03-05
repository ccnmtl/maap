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
		
		<script src="/static/javascript/view_selector/view_selector.js" type="text/javascript"></script> 
               <script type="text/javascript" src="//maps.googleapis.com/maps/api/js?key=${tg.gmap_key}&amp;sensor=false"></script>
		<script type="text/javascript" src="/static/javascript/gmap_common.js"></script> 
		<script type="text/javascript" src="/static/javascript/gmap_patch.js"></script> 
		<script type="text/javascript" src="/static/javascript/MochiKit/DragAndDrop.js"></script> 
		<script type="text/javascript" src="/static/javascript/panzoom/panzoom.js"></script> 
		<script type="text/javascript" src="/static/javascript/maap-panzoom.js"></script> 

		<script type="text/javascript" src="/static/javascript/swfobject.js"></script> 
		<script type="text/javascript">
		//<![CDATA[
		loadPlace(${place.latitude}, ${place.longitude}, '${place.getMarkerColor()}');
		//]]>
		</script> 
		
	</head>
	
	<body>


	<!--BEGIN SUBNAV ITEMS-->
	
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
	
	<!--END SUBNAV ITEMS-->
	
	<!--BEGIN TWO COLUMN LAYOUT-->
	
	<!-- BEGIN RIGHT COLUMN -->
	
		<div id="two-column-right">
			<div id="two-column-right-inner">
			
				<!--BEGIN FEATURED CONTENT-->				
				<div py:if="place.isVideoFeatured()" id="videowidget">
					<div class="video">
					
					<p id="player1"><a href="http://www.macromedia.com/go/getflashplayer">Get the Flash Player</a> to see this video.</p>
						
					<script type="text/javascript">
						var so = new SWFObject('/static/flash/flvplayer.swf','mpl','320','260','8');
						so.addParam('allowscriptaccess','always');
						so.addParam('allowfullscreen','true');
						so.addVariable('height','260');
						so.addVariable('width','320');
						so.addVariable('file','${featured_video.stream_url}');
						so.addVariable('image','${featured_video.thumb_url}');
						so.addVariable('id','video');
						so.write('player1');
					</script>
					
					</div>
					<div class="videocaption">
						<div class="title">
						${featured_video.title}
						</div>
						${featured_video.caption}
					</div>
				</div>

				<div py:if="place.isImageFeatured()">
					 <img style="width: 310px; border: 1px solid #ccc;" src="${featured_image.thennow_url}" alt="${featured_image.title}"/>
				         <div style="text-align: left; margin: 10px 0px 10px 0px;">
						<div class="title">
						 ${featured_image.title}
						</div>
						<span class="imagecaption">${featured_image.caption}</span>
					</div>				  
				</div>
				<!--END FEATURED CONTENT-->
				
				<!-- BEGIN THEN/NOW BOX -->
				
				<!-- BEGIN TABS -->
				<div id="then_now_tabber" class="selectable_view">
					<div class="tabbox">
						<div id="then" class="then_now_tabber_option then_now_tabber_option_on then_now_tabber_selector_view_then">
							Then 
						</div>
						<div id="now" class="then_now_tabber_option then_now_tabber_selector_view_now">
							Now 
						</div>
					</div>
				</div>
				<!-- END TABS -->
				
				<!-- BEGIN THEN/NOW CONTENT -->
				
				<div id="mapwidget">
					<div id="mapwidget-inner">
					
					<!-- BEGIN THEN CONTENT -->
					
						<div id="view_then" class="then_now_tabber_view then_now_tabber_show">
						
							<!-- BEGIN THEN OVERVIEW TEXT -->
							
							<p class="maptext">
								${XML(place.rendered_then_text())} 
							</p>
							
							<!-- END THEN OVERVIEW TEXT -->
							
							<!--BEGIN THEN IMAGE-->
							
							<div id="then_imagebox" style="border: 1px solid #ccc; padding: 7px; background-color: #fff;">
								<img py:if="then_image" src="${then_image.thennow_url}" alt="${then_image.title}" width="258" border="0" />
							</div>
							
							<div class="mapcaption" style="height: 40px; padding: 5px;">
								<a py:if="then_image" style="float: right;" href="/image/view/${str(then_image.id)}"><img src="/static/images/icon_zoom.gif" /></a>
								<!-- Then Image Caption --> 
							</div>
							
							<!--END THEN IMAGE-->
							
							<!-- BEGIN THEN PATCH -->
							
							<div id="thenpatch" style="border: 1px solid #ccc; padding: 7px; background-color: #fff;">
								<a href="/place/then#map=${patch.parent_map.name}&amp;${patch.src_url}">
									<img src="${patch.img_url}" />
								</a>
							</div>
							
							<div id="thenpatch_caption" class="mapcaption" style="height: 40px; padding: 5px;">
								<a style="float: right;" href="/place/then#map=${patch.parent_map.name}&amp;${patch.src_url}"><img src="/static/images/icon_zoom.gif" /></a>
								<!-- Then Patch Caption  -->
							</div>
							
							
						</div>
						<!--END THEN CONTENT-->
						
						<!-- BEGIN NOW CONTENT -->
						
						<div id="view_now" class="then_now_tabber_view">
						
							<!-- BEGIN NOW OVERVIEW TEXT -->
							
							<p class="maptext">
								${XML(place.rendered_now_text())} 
							</p>
							
							<!-- END NOW OVERVIEW TEXT -->
							
							<!--BEGIN NOW IMAGE-->
							
							<div id="now_imagebox" style="border: 1px solid #ccc; padding: 7px; background-color: #fff;">
								<img py:if="getattr(place,'now_image',False)" src="${place.now_image.thennow_url}" alt="${place.now_image.title}" width="258" border="0" />

							</div>
							
							<div class="mapcaption" style="height: 40px; padding: 5px;">
								<a py:if="now_image" style="float: right;" href="/image/view/${str(now_image.id)}"><img src="/static/images/icon_zoom.gif" /></a>
								<!-- Now Image Caption -->  
							</div>
							
							<!--END NOW IMAGE-->
							
							<!-- BEGIN NOW PATCH -->
							
							<div id="map_canvas" style="width: 270px; height: 207px;">
							</div>

							<div id="nowpatch_caption" class="mapcaption" style="height: 40px; padding: 5px;">
								<a style="float: right;" href="/place/#lat=${place.latitude}&amp;lng=${place.longitude}&amp;zoom=15"><img src="/static/images/icon_zoom.gif" /></a>
								<!-- Now Patch Caption  -->
							</div>
							
							
						</div>
						<!--END NOW CONTENT-->
						
					</div>
				</div>
				<!-- END THEN/NOW CONTENT -->
				
				<!-- END - THEN/NOW BOX -->
				
			</div>
		</div>
		
		<!-- END - RIGHT COLUMN -->
		
		<!-- BEGIN LEFT COLUMN -->
		
		<div id="two-column-left">
			<div id="two-column-left-inner">
				
				<h3 style="padding-top: 30px;">${place.title}</h3>

				${XML(place.rendered_body())} 
				
				<p py:if="place.attribution"><i>This entry contributed by ${XML(place.rendered_attribution())}</i></p>
				<!-- BEGIN RELATED BOX -->
				<div style="margin-top: 20px;">
					<div id="bottomleft">

						<div class="duotone">
							<div class="content">
								<div class="t"></div>
								
								<h1>
									Related Media 
								</h1>
									
								<br />
								

								<div py:if="videos" class="suppmediatitle">Video</div>
								
								<table cellspacing="0" style="border: 0;">
								
									<tr py:for="i,video in enumerate(videos)" class="${i%2 and 'odd' or 'even'}">
									
										<td width="120" align="center" valign="top" style="text-align: center; border: 0; background-color: transparent; padding-bottom: 20px; padding-right: 15px;">
											<a href="/video/view/${str(video.id)}"><img style="padding: 5px; background-color: #fff;" src="${video.tiny_url}" /></a>
										</td>
										
										<td align="left" valign="top" style="border: 0; background-color: transparent; padding-bottom: 20px;">
											<div class="specialtitle"><a href="../video/${str(video.id)}">${video.title}</a></div> 
											<div class="specialtitlecaption">${video.caption}</div>
										</td>
										
									</tr>
									
								</table>
								
								<br />

								<div class="suppmediatitle">Images</div>
								
								<table cellspacing="0" style="border: 0;">
								
									<tr py:for="i,image in enumerate(images)" class="${i%2 and 'odd' or 'even'}">
									
										<td width="120" align="center" valign="top" style="text-align: center; border: 0; background-color: transparent; padding-bottom: 20px; padding-right: 15px;">
											<a href="/image/view/${str(image.id)}"><img style="padding: 5px; background-color: #fff;" src="${image.thumb_url}" /></a>
										</td>
										
										<td align="left" valign="top" style="border: 0; background-color: transparent; padding-bottom: 20px;">
											<div class="specialtitle"><a href="/image/view/${str(image.id)}">${image.title}</a></div>
											<div class="specialtitlecaption">${image.caption}</div>
										</td>
										
									</tr>
									
								</table>
								
								

								<div class="b"></div>
							</div>
						</div>
						
						<br />
					
						<div  py:if="related_lessons" class="duotone">
							<div class="content">
								<div class="t"></div>
								<h1>
									Lesson Plans
								</h1>
								<br />

								<table cellspacing="0" style="border: 0;">
								
									<tr py:for="i,lesson in enumerate(related_lessons)" class="${i%2 and 'odd' or 'even'}">
									
										<td width="40" align="center" valign="middle" style="text-align: center; border: 0; background-color: transparent; padding-bottom: 20px; padding-right: 15px;">
											<a href="../lesson/${str(lesson.id)}"><img src="/static/images/icon_plan.gif" /></a>
										</td>
										
										<td align="left" valign="middle" style="border: 0; background-color: transparent; padding-bottom: 20px;">
											<div class="specialtitle"><a href="../lesson/${str(lesson.id)}">${lesson.title}</a></div> 
										</td>
									</tr>
									
								</table>
									
								<div class="b"></div>
							</div>
						</div>


					</div>
				</div>
				
				<!-- END - LEFT COLUMN -->
				
				<!-- END - TWO COLUMN LAYOUT -->
				
			</div>
		</div>
		
		<br clear="all" />
		
	</body>
	
</html>
