<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:py="http://purl.org/kid/ns#" py:extends="'master.kid'">

<head>

	<meta content="text/html; charset=utf-8" http-equiv="Content-Type" py:replace="''"/>

	<title>MAAP | Add</title>

	<script language="javascript" type="text/javascript" src="/static/javascript/tiny_mce/tiny_mce.js"></script>
	
	<script language="javascript" type="text/javascript" src="/static/javascript/tiny_mce_init.js"></script>

</head>

<body>

	<div id="nav-actions">
		<div id="nav-actions-inner">
		    <h2>Add</h2>
		</div>
	</div>

	<div class="flash" py:if="tg_flash" py:content="tg_flash"></div>
	
	<div class="errors" py:if="tg_errors">Form Error!</div>
	
	${form(submit_text="Save", form_attrs=[('id',form.name)])}
  
</body>

</html>
