<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:py="http://purl.org/kid/ns#" py:extends="'master.kid'">

	<head>
	
		<meta content="text/html; charset=utf-8" http-equiv="Content-Type" py:replace="''" />
		
		<title>
			MAAP | Places: Then
		</title>
		
		<link rel="stylesheet" href="/static/css/nowthen.css" media="screen" type="text/css" />
		<link rel="stylesheet" href="/static/css/nowthen.css" media="print" type="text/css" />
		<script type="text/javascript" src="/static/javascript/view_selector/view_selector.js"></script> 
		<script type="text/javascript" src="/static/javascript/MochiKit/DragAndDrop.js"></script> 
		<script type="text/javascript" src="/static/javascript/panzoom/panzoom.js"></script> 
		<script type="text/javascript" src="/static/javascript/maap-panzoom.js"></script> 
		<script type="text/javascript" src="/place/maps"></script> 
		
	</head>
	
	<body>

	<div id="nav-actions">
		<div id="icon-navigator2"></div>
		<div id="nav-actions-inner">
		
		         <div id="detailactions">
				<div class="detailaction">
					Jump to 
					<form id="detailactionform">
						<select class="detailactionformselect"
							onchange="location = this.options[this.selectedIndex].value;"> 
							<option value="/place">Choose Place</option>
							<option py:for="p in places" value="/place/${str(p.id)}">${p.title}</option>
						</select>
					</form> 
				</div>
			</div>
		
		    <h2 style="padding-left: 50px">Places: Then</h2>
		    
		</div>
	</div>

		<div id="navigator-container">
		
			<div id="navigator-tabs">
				<div id="navigator-tabs-inner">
				
					<div id="large-mapwidgettabs">
					
						<a id="now-large" href="/place">
						<div class="innertube">
							Now 
							<br />
							<span style="font-size: 10px;">
								Modern Map (Pins for All Places) 
							</span>
						</div>
						</a>
						
						<a id="then-large-selected" href="#">
						<div class="innertube">
							Then 
							<br />
							<span style="font-size: 10px;">
								21 Historic Maps (Show Only Selected Places - No Pins) 
							</span>
						</div>
						</a>
						
					</div>
				</div>
				
			</div>
			
			<div id="navigator-top">
				<div id="navigator-top-inner">
				
					<div id="navigator-top-left" style="float: left; border: 7px solid #603813; background-color: #603813; width: 205px; height: 176px;">
						<div id="navigator-top-left-inner">
						
							<!-- ******************
							Overview window
							******************
							-->
							
							<div class="overview_border ccnmtl">
								
								<div id="panzoom1_overview" class="panzoom_overview" style="position: relative; left: 5px; top: 6px; margin: -9px 0 0 -10px; font-size: 14px; width: 208px; height: 161px;" >
									<img id="panzoom1_overview_image" class="overviewimage" />
									<div class="overviewSelector" style="width:0;height:0"></div>
								</div>
							</div>

							<div style="clear: both;">
							</div>
							
						</div>
					</div>
					
					<div id="navigator-top-right" style="height: 177px;">
						<div id="navigator-top-right-inner">
						
							<div id="maplist" class="selectable_view">
								<!-- ******************
								View Selector
								******************
								-->
								<div id="viewcontroller" class="viewlist">
									<div id="view3">
										<div class="maplist_option maplist_selector_bigmapthumbs">
											L
										</div>
									</div>
									<div id="view2">
										<div class="maplist_option maplist_selector_smallmapthumbs">
											M
										</div>
									</div>
									<div id="view1">
										<div class="maplist_option maplist_option_on maplist_selector_map_marks">
											S
										</div>
									</div>
									<div id="viewtitle">
										<div class="maplist_option maplist_selector_bigmapthumbs">
											View
										</div>
									</div>
								</div>
								
								<!-- ****** Move Left/Right ****** -->
								<div id="move_map_left" class="listcontroller">
								</div>
								
								<div id="move_map_right" class="listcontroller">
								</div>
								
								<!-- ****** Timeline ****** -->
								<div id="map_marks" class="maplist_view maplist_show" style="height: 162px;">
									<div id="timelinegraphic"><img src="/static/images/small_timeline.png" /></div>
									<div py:for="i,m in enumerate(maps)">
										<div style="left:${m.yearpos*6}px; bottom:${map_vert[i]*11}px; margin-bottom: 51px;" class="mapmark mapmeta_option mapmeta_selector_${m.name}"></div>
									</div>
								</div>
								
								<!-- ****** Small Thumbs ****** -->
								<div id="smallmapthumbs" class="maplist_view">
									<table style="margin: 0; padding: 0;">
										<tr>
											<td py:for="m in maps" style="text-align: center; vertical-align: middle; height: 146px; padding: 0 2px 0 2px;">
												<!--img class="mapmeta_option mapmeta_selector_${m.name}" src="${m.smallthumb_url}" title="${m.title}" alt="Map thumb of ${m.title}" /-->
												<div style="display: inline; text-align: center;">
													<img class="mapmeta_option mapmeta_selector_${m.name}" title="${m.title}" alt="Map thumb of ${m.title}" />
												</div>
											</td>
										</tr>
										<tr>
											<td py:for="i,m in enumerate(maps)" style="font-size: 10px; font-weight: bold; padding: 2px; text-align: center; white-space:nowrap">
												${m.year} 
												<div style="position:relative">
													<div class="yearmarker" py:if="i==0 or (m.year/100 > maps[i-1].year/100)">
														${m.year/100}00 
													</div>
												</div>
											</td>
											<!--<td>now</td>-->
										</tr>
										<tr>
											<td class="timelinerow" colspan="${len(maps)}"></td>
										</tr>
									</table>
								</div>
								
								<!-- ****** Big Thumbs ****** -->
								<div id="bigmapthumbs" class="maplist_view">
									<table style="margin: 0; padding: 0; border: 1px solid: #603813;">
										<tr>
											<td py:for="m in maps" style="text-align: center; vertical-align: middle; height: 160px; padding: 0 5px 0 5px;">
												<!--<div style="display: inline; text-align: center;"><img class="mapmeta_option mapmeta_selector_${m.name}" title="${m.title}" alt="Map thumb of ${m.title}" /></div>	-->
										
												<div style=" height: 170px; margin-top: -10px; padding 0px;">
		
													<div align="center" class="map_info_bubble_inner" style="height: 170px; border: none; background-color: #333;">
			
														<div align="center" style="height: 160px; padding: 10px 0 0 0;">
															<img style="display: inline;" class="mapmeta_option mapmeta_selector_${m.name}" src="" />
														</div>
				
														<div class="mapdetails">
															<div class="bubbletext" style="padding: 5px; font-size: 10px; font-weight: bold;">
																<span>${m.year} </span>
																<br />
																<span>${m.title} </span>				
															</div>
														</div>
														</div>		
													</div>	
											</td>
										</tr>
										
										
										<tr>
											<td py:for="i,m in enumerate(maps)" style="font-size: 10px; font-weight: bold; padding: 0px; text-align: center; white-space:nowrap">
											<!--	${m.year} ${m.title} -->
												<div style="position:relative;">
													<div class="yearmarker" py:if="i==0 or (m.year/100 > maps[i-1].year/100)">
														${m.year/100}00 
													</div>
												</div>
											</td>
											
										</tr>
										
										
										<tr>
											<td class="timelinerow" colspan="${len(maps)}"></td>
										</tr>
										
										
									</table>
								</div>
								
							</div>
							<div style="clear: both;">
							</div>
						</div>
					</div>
					<div style="clear: both;">
					</div>
				</div>
			</div>
			<div style="clear: both;">
			</div>
			
			
			<div id="navigator-bottom">
				<div id="navigator-bottom-inner">
				
					<div id="navigator-bottom-left" style="float: left; width: 70%;">
						<div id="navigator-bottom-left-inner" style="padding: 6px 3px 6px 6px;">
						
							<!-- ******************
							Big Map View
							******************
							-->
							<div id="oldmap">
								<div id="controls" class="controls">
									<!-- keep these ids for the magic onclick connection, but you can move them anywhere in the document and style as desired -->
									<div id="panzoom1_zoomIn" class="zoomIn panzoom_control" title="Zoom in">
									</div>
									<div id="panzoom1_zoomOut" class="zoomOut panzoom_control" title="Zoom out">
									</div>
									<div id="panzoom1_left" class="panzoom_control" onclick="PanZoomers['panzoom1'].translate(-0.3)" title="Pan left">
									</div>
									<div id="panzoom1_right" class="panzoom_control" onclick="PanZoomers['panzoom1'].translate(0.3)" title="Pan right">
									</div>
									<div id="panzoom1_up" class="panzoom_control" onclick="PanZoomers['panzoom1'].translate(0,-0.3)" title="Pan up">
									</div>
									<div id="panzoom1_down" class="panzoom_control" onclick="PanZoomers['panzoom1'].translate(0,0.3)" title="Pan down">
									</div>
									<div id="panzoom1_recenter" class="panzoom_control" onclick="PanZoomers['panzoom1'].recenter()" title="Jump to center">
									</div>
									<div id="panzoom1_fit" class="panzoom_control" onclick="PanZoomers['panzoom1'].fitToContainer()" title="View whole map">
									</div>
								</div>
								<div id="map_canvas" class="panzoom_container bigmap">
									<div id="panzoom1" class="panzoom">
										<img style="width:100%;height:100%;" />
									</div>
								</div>
							</div>
							<!--id=oldmap-->
							<div id="mapmeta" class="selectable_view">
								<div id="mapmeta-inner">
								
									<div py:for="m in maps" id="${m.name}" class="mapmeta_view">
										<b>${m.title}</b>  
										<br />
										Source: ${XML(m.source_html)} 
										<br />
										Publisher: ${m.publisher} 
										<br />
										Cartographer: ${m.cartographer} 
									</div>
									<div style="float: right; margin-top: -13px; font-size: 10px; font-weight: bold;">
										<!--put this link anywhere in the page, and it will still work-->
										<a id="panzoom1_permalink" href="">Sharable Link</a>
										<!--| 
										<a href="#">Download Original (0000 KB)</a-->
									</div>
									
								</div>
							</div>
							<div style="clear: both;">
							</div>
							
						</div>
					</div>
					
					<div id="navigator-bottom-right" style="background-color: #603813; text-align: center;">
						<div id="navigator-bottom-right-inner" style="padding: 6px 6px 6px 3px;">
						
							<div style="float: right;">
								<div id="placetitle" style="height: 30px; background-color: #b3906f; color: #fff; font-weight: bold;">
									<div id="placetitle-inner" style="padding: 6px;">
										Visit Places on this Map 
									</div>
								</div>
								<div id="place_list" style="height: 440px; width: 180px; overflow: auto; background-color: #e1d3c2; text-align: center;">
									<div id="place_list-inner" style="padding: 6px;">
									
										<div id="place_${place.id}" py:for="i,place in enumerate(places)" class="place_link ${i%2 and 'odd' or 'even'} ${place.patch and place.patch.parent_map and place.patch.parent_map.name+'_map_patch' or ''}" style="display:none">
											<br />
											<br />
											<a href="/place/${place.id}">${place.title}</a> 
											<br />
											<!-- href attribute instead of src so we can do post-fetching to speed up load time -->
											<a href="/place/${place.id}"><img class="place_thumb ${place.patch and place.patch.parent_map and place.patch.parent_map.name+'_map_patch_thumb' or ''}" py:if="getattr(place,'then_image',False)" href="${place.then_image.thumb_url}" py:attrs="{'alt':place.then_image.title}" /></a>
											<a href="/place/${place.id}"><img class="place_thumb ${place.patch and place.patch.parent_map and place.patch.parent_map.name+'_map_patch_thumb' or ''}" py:if="not getattr(place,'then_image',False) and len(place.images)>0" href="${place.images[0].thumb_url}" py:attrs="{'alt':place.images[0].title}" /></a>
											<!--:${place.name}-->
										</div>
										
										
									</div>
								</div>
							</div>
							<div style="clear: both;"></div>
							
						</div>
						
					</div>
				</div>
				
			</div>
		</div>
		

		<div id="map_info_bubble" style="display:none; height: 190px; margin-top: -7px;">
		
			<div align="center" class="map_info_bubble_inner" style="height: 180px; border: 2px solid #603813; background-color: #fff;">
			
				<div align="center" style="height: 160px; padding: 10px;">
					<img style="display: inline;" class="bubble_image" src="" />
				</div>
				
				<div id="bubbletextbox">
					<div class="bubbletext">
						<span id="bubbledate">0000</span>
						<br />
						<span id="bubbletitle">Title of Map</span>
					</div>
				</div>
				
			</div>
			
			<div class="bubblepointer" style="background-image: url(/static/images/pointer.png); background-repeat: no-repeat; background-position: top right; width: 110px ; height: 10px;"></div>
			
		</div>

	</body>
</html>
