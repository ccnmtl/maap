<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:py="http://purl.org/kid/ns#" py:extends="'master.kid'">
	<head>
		<meta content="text/html; charset=utf-8" http-equiv="Content-Type" py:replace="''" />
		<title>
			MAAP | Module 
		</title>
		<link rel="stylesheet" href="/static/css/home_style.css" media="screen" type="text/css" />
	</head>
	<body>
		<div id="nav-actions">
			<div id="nav-actions-inner">
				<div id="detailactions">
					<div class="detailaction">
						&#171; <a href="/module/">Back to Lesson Plans</a>
					</div>
				</div>
				<h2>
					Module Detail 
				</h2>
			</div>
		</div>
		<div id="left" style="float: left; width: 470px;">
			<h3>
				${maap_module.title} 
			</h3>

			<h3 class="snazzytitle">
				Understandings: 
			</h3>
			${XML(maap_module.understandings)} 
			<h3 class="snazzytitle">
				Essential Questions: 
			</h3>
			${XML(maap_module.essential_questions)} 
			
			<p>&#160;</p>
			
		</div>
		<div id="right" style="margin-left: 500px;">
			<div py:if="not lessons">
				<a name="lessons"></a>
				<div class="duotone">
					<div class="content" style="height: 600px;">
						<div class="t">
						</div>
						<h1>
							Related Lessons 
						</h1>
						<h3></h3>
						<table border="0" cellspacing="0">
						<tr>
							<td width="50" align="center" valign="middle" style="text-align: center; border: 0; background-color: transparent;">
							<img src="/static/images/icon_plan.gif" border="0" /></td>
							<td align="left" valign="middle" style="border: 0; background-color: transparent;">
								<div class="specialtitle">
								There are no lessons associated with this module yet.
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
			<div py:if="lessons">
				<a name="lessons"></a>
				<div class="duotone">
					<div class="content" style="height: 600px;">
						<div class="t">
						</div>
						<h1>
							Related Lessons 
						</h1>
						<h3></h3>
						<table border="0" cellspacing="0">
							<tr py:for="i,lesson in enumerate(lessons)" class="${i%2 and 'odd' or 'even'}">
								<td align="center" valign="middle" style="text-align: center; border: 0; background-color: transparent;">
									<a href="../lesson/${str(lesson.id)}">
										<img src="/static/images/icon_plan.gif" border="0" />
									</a>
								</td>
								<td align="left" valign="middle" style="border: 0; background-color: transparent;">
								<div class="specialtitle">
									<a href="../lesson/${str(lesson.id)}">
										${lesson.name} 
									</a>
								</div>
									
									<!--<br />
									${lesson.title} -->
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
		<br clear="all" />
	</body>
</html>
