<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
        
<?python import sitetemplate ?>

<html xmlns="http://www.w3.org/1999/xhtml" xmlns:py="http://purl.org/kid/ns#" py:extends="sitetemplate">

	<head py:match="item.tag=='{http://www.w3.org/1999/xhtml}head'" py:attrs="item.items()">
	
		<title py:replace="''">MAAP</title> 
		
		<link rel="stylesheet" href="/static/css/style.css" media="screen" type="text/css" />
		<link rel="stylesheet" href="/static/css/print.css" media="print" type="text/css" />


		<link rel="shortcut icon" href="/static/images/favicon.ico" />
		
		<script type="text/javascript" language="javascript" src="/static/javascript/MochiKit/MochiKit.js"></script>
		<script type="text/javascript" language="javascript" src="/static/javascript/navigation.js"></script>
		
		<meta content="text/html; charset=UTF-8" http-equiv="content-type" py:replace="''"/>
		<!--Keep this on the bottom: this is where head-tag items from the specific template get added -->
		<meta py:replace="item[:]"/>
		
		<link rel="stylesheet" href="http://ccnmtl.columbia.edu/remote/alerts/mobile/css/mobilesupport.css" type="text/css" media="all" />
		<script type="text/javascript">mobileurl="http://maap.columbia.edu/mbl_index.html";</script>
		<script src="http://ccnmtl.columbia.edu/remote/alerts/mobile/mdetectlite.js" type="text/javascript"></script>

		<!--[if IE 6]>
		<link rel="stylesheet" href="/static/css/IE6_fixes.css" media="screen" type="text/css" />
		<![endif]-->		
		
		<!--[if IE 7]>
		<link rel="stylesheet" href="/static/css/IE7_fixes.css" media="screen" type="text/css" />
		<![endif]-->		
	</head>
	
	<body py:match="item.tag=='{http://www.w3.org/1999/xhtml}body'" py:attrs="item.items()">
	
	        <div id="mobilebutton"></div>
		<div id="container-main">
		
			<div id="nav-top">
				<div id="nav-top-inner">

				<div id="searchbar">
				<!-- Google CSE Search Box Begins  -->
				<form action="/search_results" id="searchbox_006361347561183875331:eck6wjevvtu">
				  <input type="hidden" name="cx" value="006361347561183875331:eck6wjevvtu" />
				  <input type="hidden" name="cof" value="FORID:11" />
				  <input id="searchfield" type="text" name="q" size="25" />
				  <input id="searchbutton" type="submit" name="sa" value="Go" />
				</form>
				<!-- make sure to remove the lang=en from this js src, as kid templates don't appreciate this -->
				<script type="text/javascript" src="http://www.google.com/coop/cse/brand?form=searchbox_006361347561183875331%3Aeck6wjevvtu"></script>
				<!-- Google CSE Search Box Ends -->
				</div>
					<ul class="nav">
						<li id="admin">
							<a href="/admin">
								Administration</a>&nbsp;|
						</li>
						<li>
							<a href="/about">
								About</a>
						</li>
						<li>
							|
						</li>
						<li>
							<a href="/partners">
								Partners</a>
						</li>
						<li>
							|
						</li>
						<li>
							<a href="/help">
								Help</a>
						</li>
						<li>
							|
						</li>
						<li>
							<a href="/contact">
								Contact</a>
						</li>						
						<li>
							|
						</li>
						<li>
							<a href="/podcast">Podcast</a>
						</li>
						<!--
						<li>
							<a title="iTunes" href="#" ><img src="/static/images/icon_itunes.gif" alt="iTunes" /></a>
						</li>
						<li>
							<a title="Podcast" href="#" ><img src="/static/images/icon_podcast.gif" alt="Podcast" /></a>
						</li>
						-->
					</ul>
				</div>
			</div>
			
			<div id="masthead">
				<h1>
					<a onclick="this.blur()" href="/welcome">MAAP | Mapping the African American Past</a>
				</h1>
				
				<div id="nav-tabs">
					<ul class="nav">
						<li>
							<a onclick="this.blur()" id="library" href="/maap_library/">
								Library</a>
						</li>
						<li>
							<a onclick="this.blur()" id="lesson" href="/module/">
								Lesson Plans</a>
						</li>
						<li>
							<a onclick="this.blur()" id="places" href="/place/">
								Places</a>
						</li>
						<li>
							<a onclick="this.blur()" id="home"  href="/">
								Home</a>
						</li>
					</ul>
				</div>
				
			</div>
			
			<!--
			<div id="nav-actions">
				<div id="nav-actions-inner">
				  <div py:match="item.tag=='{http://www.w3.org/1999/xhtml}title'" >
				    NAV ACTIONS HERE!!!!
				  </div>
				</div>
			</div>
			-->
			
			<div id="container-content">
				<div id="container-content-inner">
				
					  <div py:if="tg_flash" class="flash" py:content="tg_flash">Error Message-type stuff HERE!!!!</div>
					  
					  <div py:replace="[item.text]+item[:]">
						BODY HERE!!!!!!
					  </div>

				</div>
			</div>
			<br clear="all" />
			<div id="footer">
				<div id="footer-inner">
					<img src="/static/images/partners.png" width="680" height="40" alt="Partners" usemap="#partners" />
					<map name="partners" id="partners">
						<area shape="rect" coords="587,1,678,39" href="http://www.cciny.net/" target="_blank" title="CCI" alt="CCI" />
						<area shape="rect" coords="362,10,567,33" href="http://www.tc.edu/" target="_blank" title="Teachers College" alt="Teachers College" />
						<area shape="rect" coords="162,7,330,34" href="http://www.jpmorganchase.com/cm/cs?pagename=Chase/Href&amp;urlname=jpmc/community/grants/educ" target="_blank" title="JPMorganChase" alt="JPMorganChase" />
						<area shape="rect" coords="6,3,132,33" href="http://ccnmtl.columbia.edu/" target="_blank" title="CCNMTL" alt="CCNMTL" />
					</map>
				</div>
			</div>
		</div>
		<span class="partnertext">Produced by CCNMTL, Chase, Teachers College, and CCI</span>
		<!-- Google tag (gtag.js) -->
		<script async src="https://www.googletagmanager.com/gtag/js?id=G-E7CV705Y7C"></script>
		<script>
		  window.dataLayer = window.dataLayer || [];
		  function gtag(){dataLayer.push(arguments);}
		  gtag('js', new Date());
		
		  gtag('config', 'G-E7CV705Y7C', { 'anonymize_ip': true });
		</script>
		<!-- Google Analytics -->

	</body>
</html>
