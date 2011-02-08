<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:py="http://purl.org/kid/ns#" py:extends="'master.kid'">
	<head>
		<meta content="text/html; charset=utf-8" http-equiv="Content-Type" py:replace="''" />
		<title>
			MAAP | Library 
		</title>
		<style type="text/css">
		th, td {padding: 8px;}
		</style>
	</head>
	<body>
		<div id="nav-actions">
			<div id="nav-actions-inner">
				<div id="detailactions">
					<div class="detailaction">
						Jump to 
						<form id="detailactionform">
							<select class="detailactionformselect" onchange="location = this.options[this.selectedIndex].value;">
								<option value="/maap_library/images">
									Choose Sub-Library
								</option>
								<option value="/maap_library/images">
									Images
								</option>
								<option value="/maap_library/videos">
									Videos
								</option>
								<option value="/maap_library/maps">
									Maps
								</option>
							</select>
						</form>
					</div>
				</div>
				<h2>
					Library: <span style="text-transform: capitalize;">${type}</span> 
				</h2>
			</div>
		</div>

		<table cellspacing="0">
			<colgroup span="3" id="librarytable">
				<col id="thumbnail">
				</col>
				<col id="name">
				</col>
				<col id="source">
				</col>
			</colgroup>
			<tr>
				<th style="text-align: center;">
					Thumbnail
				</th>
				<th>
					Name
				</th>
				<th>
					Source
				</th>
			</tr>
			<tr py:for="a in assets">
				<td style="text-align: center;">
					<a href="${str(a.view_url)}">
						<img src="${a.thumb_url}" alt="thumb of ${a.record.name}" />
					</a>
				</td>
				<td>
					${a.record.title}
				</td>
				<td>
					<span py:if="a.record.source">
						${XML(a.record.source)} 
					</span>
				</td>
			</tr>
		</table>
	</body>
</html>
