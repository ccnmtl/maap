<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:py="http://purl.org/kid/ns#" py:extends="'master.kid'">
	<head>
		<meta content="text/html; charset=utf-8" http-equiv="Content-Type" py:replace="''" />
		<title>
			MAAP | Image View
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
			${image.title}
		</h2>
		</div>
	</div>

		<div style="margin: 20px 0px 20px 0px;" align="center">
			<image style="max-width: 770px; border: 1px solid #ccc; padding: 15px; background-color: #fff;" src="${image.big_url}" />
		</div>
		<div id="imagedetail-metadata">
			<h3>
				${image.title} 
			</h3>
			
			<p py:if="image.caption">
			${image.caption}
			</p>
			
			<p py:if="image.creator">
			Creator: ${image.creator}
			</p>
			
			<p py:if="image.source">
			Source: ${XML(image.source)}
			</p>
			
			<p py:if="image.rights">
			Rights: ${image.rights}
			</p>
			
		</div>
	</body>
</html>
