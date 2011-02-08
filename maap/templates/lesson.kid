<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:py="http://purl.org/kid/ns#" py:extends="'master.kid'">
	<head>
		<meta content="text/html; charset=utf-8" http-equiv="Content-Type" py:replace="''" />
		<title>
			MAAP | Lesson Plan 
		</title>
		<link rel="stylesheet" href="/static/css/home_style.css" media="screen" type="text/css" />
	</head>
	<body>
	
		<div id="nav-actions">
			<div id="nav-actions-inner">
				<div id="detailactions">
					<div class="detailaction">
						&#171; <a href="/module/${parent_module.id}">Back to the "${parent_module.title}" Module </a>
					</div>
				</div>
				<h2>
					Lesson Plan Detail
				</h2>
			</div>
		</div>
		
		<div id="left" style="float: left; width: 480px;">
			<h3>
				${lesson.title} 
			</h3>
			<h3 class="snazzytitle">
				Goals: 
			</h3>
			${XML(lesson.goals)} 
			<h3 class="snazzytitle">
				Essential Questions: 
			</h3>
			${XML(lesson.essential_questions)} 
			
			<div>&#160;</div>
		</div>
		
		<div id="right" style="margin-left: 500px;">
		
		
			<div class="duotone">
				<div class="content">
					<div class="t">
					</div>
					<h1>
						Download Lesson Plan  
					</h1>
					<h2>
						&#160; 
					</h2>
					<table border="0" cellspacing="0">
						<tr>
							<td width="50" style="background: transparent; border: 0;">
								<a href="${lesson.lesson_url}">
									<img src="/static/images/icon_pdf.gif" />
								</a>
							</td>
							<td style="background: transparent; border: 0;">
								<div class="specialtitle">
								<a href="${lesson.lesson_url}">
										${lesson.title}  
								</a>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div class="b">
					<div>
					</div>
				</div>
			</div>
		
			<br />
			
			<div py:if="related_places">
				<div class="duotone">
					<div class="content" style="height: 300px;">
						<div class="t">
						</div>
						<h1>
							Related Places 
						</h1>
						<h2>
							&#160; 
						</h2>
						<table border="0" cellspacing="0">
							<tr py:for="i,place in enumerate(related_places)" class="${i%2 and 'odd' or 'even'}">
								<td style="background: transparent; border: 0;">
									<a href="/place/${str(place.id)}">
										<img src="/static/images/icon_place.gif" />
									</a>
								</td>
								<td style="background: transparent; border: 0;">
								<div class="specialtitle">
									<a href="/place/${str(place.id)}">
											${place.title}
									</a>
								</div>	
								</td>
							</tr>
						</table>
					</div>
					<div class="b">
						<div>
						</div>
					</div>
				</div>
			</div>
		</div>
		
	</body>
</html>
