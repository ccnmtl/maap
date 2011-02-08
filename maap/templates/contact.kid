<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:py="http://purl.org/kid/ns#" py:extends="'master.kid'">

<head>

	<meta content="text/html; charset=utf-8" http-equiv="Content-Type" py:replace="''"/>
     
     <title>MAAP | Contact</title>
     
	<script type="text/javascript" language="javascript">
	//<![CDATA[
		    var environ = "public";
		    var pagetype = "home";
	//]]>
	</script>
	
</head>

<body>

     <div id="nav-actions">
          <div id="nav-actions-inner">
               <h2>Contact</h2>
          </div>
     </div>
	
	<h3>What do you think?</h3>

	<p>
	Problems? Suggestions? Is there anything you would like to share with the MAAP team?
	</p>
	
	<p>
	To contact MAAP administrators, please fill out the following form.
	</p>
	
	<form method="post" action="http://www.columbia.edu/cgi-bin/generic-inbox.pl">
	
		<input type="hidden" name="mail_dest" value="ccnmtl-maap@columbia.edu" />
		<input type="hidden" name="subject" value="MAAP Feedback" />
		<input type="hidden" name="ack_link" value="http://maap.columbia.edu/contactconfirm.html" />
		<input type="hidden" name="timestamp" value="true" />
		<input type="hidden" name="reqfields" value="name,rmail" />
		
		<div class="formitem">
		<label for="name">
		<div class="labeltext">Your Name</div>
		<input id="name" type="text" name="name" size="37" />
		</label>
		</div>
		
		<div class="formitem">
		<label for="email">
		<div class="labeltext">Your E-mail Address</div>
		<input id="email" type="text" name="rmail" size="37" />
		</label>
		</div>
		
		<div class="formitem">
		<label for="message">
		<div class="labeltext">Your Message</div>
		<textarea id="messge" name="Mail_Text" rows="8" cols="35"></textarea>
		</label>
		</div>
		
		<div class="formitem">
		<label for="send">
		<div class="labeltext">&#160;</div>
		<input id="send" type="submit" name="submit" value="Send" />
		</label>
		</div>
	
	</form>
	
</body>

</html>
