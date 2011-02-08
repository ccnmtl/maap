<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:py="http://purl.org/kid/ns#" py:extends="'master.kid'">
	<head>
		<meta content="text/html; charset=utf-8" http-equiv="Content-Type" py:replace="''" />
		<title>
			MAAP | Lessons 
		</title>
	</head>
	<body>
		<div id="nav-actions">
			<div id="nav-actions-inner">
				<h2>
					Lessons 
				</h2>
			</div>
		</div>
		<h3>
			Lesson Plans 
		</h3>
		<h3>
			Desired Results 
		</h3>
		<h3>
			Established Goals: 
		</h3>
		<table border="0" cellspacing="0">
			<colgroup span="2" id="browselessonplanstable">
				<col id="place">
				</col>
				<col id="title">
				</col>
			</colgroup>
			<tr>
				<th>
					Place 
				</th>
				<th>
					Title 
				</th>
			</tr>
			<tr py:for="i,lesson in enumerate(lessons)" class="${i%2 and 'odd' or 'even'}">
				<td>
					<a href="/lesson/${lesson.id}">
						${lesson.name} 
					</a>
					&nbsp; 
				</td>
				<td>
					${lesson.title} &nbsp; 
				</td>
			</tr>
		</table>
	</body>
</html>
