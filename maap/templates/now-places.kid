<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:py="http://purl.org/kid/ns#" py:extends="'master.kid'">

	<head>
	
		<meta content="text/html; charset=utf-8" http-equiv="Content-Type" py:replace="''" />
		
		<title>
			MAAP | Places: Now
		</title>
		
		<link rel="stylesheet" href="/static/css/nowthen.css" media="screen" type="text/css" />
		<link rel="stylesheet" href="/static/css/nowthen.css" media="print" type="text/css" />
		
               <script type="text/javascript" src="//maps.googleapis.com/maps/api/js?key=${tg.gmap_key}&amp;sensor=false"></script>
               <script type="text/javascript" src="/static/javascript/gmap_common.js"></script> 
		<script type="text/javascript" src="/static/javascript/gmap_places.js"></script> 
		<script type="text/javascript" src="/place/json"></script> 
		
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
		
		    <h2 style="padding-left: 50px">Places: Now</h2>
		</div>
	</div>

		<div id="navigator-container">
		
			<div id="navigator-tabs">
				<div id="navigator-tabs-inner">
				
					<div id="large-mapwidgettabs">
						
						<a id="now-large-selected" href="#">
						<div class="innertube">
							Now 
							<br />
							<span style="font-size: 10px;">
								Modern Map (Pins for All Places)
							</span>
						</div>
						</a>
						
						<a id="then-large" href="then">
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
				<div id="navigator-top-inner ">
				
					<!--div id="navigator-top-left" style="float: left; width: 120px; height: 130px;">
						<div id="navigator-top-left-inner" style="padding: 6px;">
						  <div style="background-color: #fff; width: 120px; height: 120px; margin-right: 6px;">
								Small Map Goes Here 
						  </div>
						  <div style="clear: both;">
						  </div>
						</div>
					</div-->
					
					<div id="navigator-top-right">
						<div id="navigator-top-right-inner" style="padding: 6px;">
						
							<div id="hideshow_options" style="background-color: #e1d3c2; height: 191px;">
								<div id="hideshow_options-inner" style="padding: 1px 0 0 10px ; font-size: 12px; font-weight: bold;">
								
									<p>
										Show places connected to the date range(s): 
									</p>
									
									<form action="javascript:void()">
									
										<div style="margin-top: 6px;">
											<input id="gold" type="checkbox" name="gold" checked="checked" />
											<img src="/static/images/markers/goldpin.gif" alt="gold pin for 17th c." />
											1632-1699 
											<br />
											
										</div>
										
										<div style="margin-top: 6px;">
											<input id="purple" type="checkbox" name="purple" checked="checked" />
											<img src="/static/images/markers/purplepin.gif" alt="purple pin for 19th c." />
											1800-1899 
											<br />
											
										</div>
										
										<div style="margin-top: 6px;">
											<input id="blue" type="checkbox" name="blue" checked="checked" />
											<img src="/static/images/markers/bluepin.gif" alt="blue pin for 18th c." />
											1700-1799
											<br />
											
										</div>
										
										<div style="margin-top: 6px;">
											<input id="red" type="checkbox" name="red" checked="checked" />
											<img src="/static/images/markers/redpin.gif" alt=" red pin for 20th c." />
											1900-Present 
											<br />
											
										</div>
										<div style="clear: both;">
										</div>
										
									</form>
									
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
						
							<div id="map_canvas" class="bigmap">
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
								
								<div id="place_list" style="height: 370px; width: 180px; overflow: auto; background-color: #e1d3c2; text-align: center;">
									<div id="place_list-inner" style="padding: 6px;">
										
										<div id="place_${place.id}" py:for="i,place in enumerate(places)" class="${i%2 and 'odd' or 'even'}">
											<br />
											<br />
											<a href="/place/${place.id}">${place.title}</a>
											<br />
											<a href="/place/${place.id}"><img class="place_thumb" py:if="getattr(place,'then_image',False)" src="${place.then_image.thumb_url}" alt="" /></a>
											<a href="/place/${place.id}"><img class="place_thumb" py:if="not getattr(place,'then_image',False) and len(place.images)>0" src="${place.images[0].thumb_url}" alt="" /></a>
											<!--:${place.name}-->
											<p class="place_description">
												${XML(place.body_snippet)}. ... 
												<a href="/place/${place.id}">
													More
												</a>
											</p>
										</div>
										
									</div>
								</div>
								
							</div>
							<div style="clear: both;">
							</div>
							
						</div>
					</div>
					
				</div>
			</div>
			
		</div>
		
		<!--
		<table border="0" cellspacing="0">
		
		<colgroup span="2" id="nowplacestable">
		<col id="place"></col>
		<col id="title"></col>
		</colgroup>
		
		<tr>
		<th>Place</th>
		<th>Title</th>
		</tr>
		
		<tr py:for="i,place in enumerate(places)" class="${i%2 and 'odd' or 'even'}">
		<td>
		<a href="/place/${place.id}">${place.name}</a>
		&nbsp;
		</td>
		<td>
		${place.title}
		&nbsp;
		</td>
		</tr>
		
		</table>
		-->
		
	</body>

</html>
