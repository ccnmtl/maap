<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">  

<html xmlns="http://www.w3.org/1999/xhtml" xmlns:py="http://purl.org/kid/ns#">

<head>
    <meta name="apple-mobile-web-app-status-bar-style" content="black" />    
    <meta name="apple-mobile-web-app-capable" content="yes" />

    <link type="text/css" rel="stylesheet" media="screen"      
          href="http://ccnmtl.columbia.edu/remote/jqtouch/jqtouch/jqtouch.css" />
    <link type="text/css" rel="stylesheet" media="screen" 
          href="http://ccnmtl.columbia.edu/remote/jqtouch/themes/maap/theme.css" />
    <link rel="apple-touch-startup-image" 
          href="http://ccnmtl.columbia.edu/remote/jqtouch/themes/maap/img/loading.png" />
    <link rel="apple-touch-icon" 
          href="http://ccnmtl.columbia.edu/remote/jqtouch/themes/maap/img/homeicon.png" />
    <link rel="apple-touch-icon-precomposed"
          href="http://ccnmtl.columbia.edu/remote/jqtouch/themes/maap/img/homeicon.png" />

    <script type="text/javascript"
          src="http://ccnmtl.columbia.edu/remote/jquery/jquery.js"></script>
   <script type="text/javascript"
          src="http://maps.google.com/maps/api/js?sensor=true"></script>
  
    <script type="text/javascript"  
          src="http://ccnmtl.columbia.edu/remote/jqtouch/jqtouch/jqtouch.js"></script>
    <script src="http://ccnmtl.columbia.edu/remote/jqtouch/extensions/jqt.location.js" type="application/x-javascript" charset="utf-8"></script>

    <script type="text/javascript" src="/static/javascript/mobile_map.js"></script> 
    <script type="text/javascript">
     <![CDATA[     
      var places = [
      ]]>
     <span py:strip="True" py:for="i,place in enumerate(places)">
       ["${place.title}", ${place.latitude}, ${place.longitude}, "${place.id}"],
     </span>
     <![CDATA[     
     ];
     // var map_all;
     // $(document).ready(map_initialize_all(40.71019, -74.004448, 14, 'New York'));
     ]]>
     </script>

    <style>
    <![CDATA[
    #jqt.fullscreen #home .infob { display: none; }

      #jqt.landscape div.placepics img
      { width: 440px !important; } 
      #jqt.profile div.placepics img
      { width: 280px !important; }
    ]]>
    </style>

     
  <title>MAAPm</title>
  
</head>

<body>
 <div id="jqt">

    <div id="home">
      <div class="toolbar">
	<h1>MAAP</h1>

	   
            <a class="button cube" href="#about">About</a>
      </div>
      <div class="info">Mapping the African American Past</div>

      <ul>
        <li class="arrow"><a href="#places">All Places</a><small class="counter">                                                                    <span py:replace="region_counts['all']"></span></small></li>
        <li class="arrow"><a href="#lowm">Lower Manhattan</a><small class="counter">   <span py:replace="region_counts['lowm']"></span></small></li>

        <li class="arrow"><a href="#midm">Mid Manhattan</a><small class="counter">   <span py:replace="region_counts['midm']"></span></small></li>
        <li class="arrow"><a href="#uppm">Upper Manhattan</a><small class="counter">   <span py:replace="region_counts['uppm']"></span></small></li>
        <li class="arrow"><a href="#brooklyn">Brooklyn</a><small class="counter">   <span py:replace="region_counts['brooklyn']"></span></small></li>
        <li class="arrow"><a href="#queens">Queens</a><small class="counter">   <span py:replace="region_counts['queens']"></span></small></li>

        <li class="arrow"><a href="#staten">Staten Island</a><small class="counter">   <span py:replace="region_counts['staten']"></span></small></li>
        <li class="arrow"><a href="#longisland">Western Long Island</a><small class="counter">   <span py:replace="region_counts['longisland']"></span></small></li>
        <li class="arrow"><a href="#easternli">Eastern Long Island</a><small class="counter"><span py:replace="region_counts['easternli']"></span></small></li>

      </ul>

        <div class="infob">
          <p>Use the "Add To Home Screen" option to convert this into an App.</p>
        </div>
    </div>


    <div id="mapit" style="min-height: 400px; height: 100%; width: 100%">
	<div class="toolbar">
	  <h1 style="font-size:16px;" id="maptitle"></h1>

          <a class="button back" href="#">Back</a>
	</div>
        <div class="ajax-results" style="height: 100%; width: 100%">
         <div id="map_canvas" style="height: 100%; width: 100%"></div>
        </div>
    </div>
	

  <div id="about">
    <div class="toolbar">

      <h1>About MAAPm</h1>
        <a class="button back" href="#">Back</a>
        <a class="button cube" href="#credits">Credits</a>
    </div>
    <div class="abouttext">
        <p style="text-align:center;"><a href="http://maap.columbia.edu" target="_blank">Main MAAP Site</a></p>
        <p><i>[MAAP] showcases historic sites and people in the city, ranging from the familiar (the African Burial Ground) to the rarely acknowledged.</i><br/> -- New York Times, March 2008</p>

        <p>Mapping the African American Past (MAAP) aims to enhance the appreciation and study of significant sites and moments in the history of African Americans in New York from the early 17th-century through the recent past. Visitors can browse a multitude of locations in New York and read encyclopedic profiles of historical people and events associated with these locations. The site is further enhanced by selected film and music clips; digitized photographs, documents, and maps from Columbia University's libraries; and commentary from Columbia faculty and other specialists.</p>

         <div align="center"><h2>Introduction to MAAP</h2>
	 <?python
         src_url = 'http://www.youtube.com/v/fkmt02VhKdA&hl=en_US&fs=1&'
	 ?>
         <object width="240" height="199"><param name="movie" value="${src_url}" /><param name="allowFullScreen" value="true" /><param name="allowscriptaccess" value="always" /><embed src="${src_url}" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="240" height="199" /></object>
        </div>
        <p><b>Mobile version notes:</b>: MAAPm is an abridged version of the main MAAP site. MAAPm includes all locations found on the main site. Each entry includes a textual description, a reading of the description by NYC high school students, audio and video expert commentary on most entries, "then" and "now" images, and a place locator map, enough information to allow for informative walking trips.</p>
	<p>This project was developed by CCNMTL in partnership with Columbia University's Teachers College and Curriculum Concepts International (CCI) and funded with generous support of the <a href="http://www.jpmorganchase.com/cm/cs?pagename=Chase/Href&amp;urlname=jpmc/community/grants/educ" target="_blank">JPMorgan Chase Foundation</a>.</p>

       </div>
    </div>

       <div id="places">
      <div class="toolbar">
	<h1>Places</h1>
	   <a class="button back" href="#">Back</a>
      </div>

      <ul class="edgetoedge">
        
        <li py:for="i,place in enumerate(places)" class="arrow">
	  <a href="mbl_place/${place.id}">${place.title}</a>
	</li>

	
      </ul>
    </div>



     <div id="lowm">

      <div class="toolbar">
	<h1 style="font-size:18px;">Lower Manhattan</h1>
	   <a class="button back" href="#">Back</a>
           <a class="button slideup" href="#mapit" onclick="map_initialize_all(40.71019,-74.004448,14, 'Lower Manhattan')">Area Map</a>
     </div>
      <div class="info">Places south of Broome Street in downtown Manhattan</div>
      <ul class="edgetoedge">

        
        <li py:for="i,place in enumerate(places)" py:if="place.region == 'lowm'" class="arrow">
	  <a href="mbl_place/${place.id}">${place.title}</a>
	</li>


      </ul>
    </div>

     <div id="midm">
      <div class="toolbar">

	<h1 style="font-size:18px;">Mid Manhattan</h1>
	   <a class="button back" href="#">Back</a>
           <a class="button slideup" href="#mapit" onclick="map_initialize_all(40.747302,-73.98043,13, 'Mid Manhattan')">Area Map</a>
      </div>
      <div class="info">Places north of Broome Street and south of 110th Street in Manhattan</div>
      <ul class="edgetoedge">
        
        <li py:for="i,place in enumerate(places)" py:if="place.region == 'midm'" class="arrow">
	  <a href="mbl_place/${place.id}">${place.title}</a>
	</li>

      </ul>

    </div>

     <div id="uppm">
      <div class="toolbar">
	<h1 style="font-size:18px;">Upper Manhattan</h1>
	   <a class="button back" href="#">Back</a>
          <a class="button slideup" href="#mapit" onclick="map_initialize_all(40.816429,-73.940407,13, 'Upper Manhattan')">Area Map</a>
      </div>

      <div class="info">Places north of 110th Street in Manhattan</div>
      <ul class="edgetoedge">
        
        <li py:for="i,place in enumerate(places)" py:if="place.region == 'uppm'" class="arrow">
	  <a href="mbl_place/${place.id}">${place.title}</a>
	</li>
	
      </ul>
    </div>

     <div id="brooklyn">
      <div class="toolbar">
	<h1 style="font-size:18px;">Brooklyn</h1>
	   <a class="button back" href="#">Back</a>
          <a class="button slideup" href="#mapit" onclick="map_initialize_all(40.664239,-73.957343,12, 'Brooklyn')">Area Map</a>
      </div>

      <ul class="edgetoedge">

        <li py:for="i,place in enumerate(places)" py:if="place.region == 'brooklyn'" class="arrow">
	  <a href="mbl_place/${place.id}">${place.title}</a>
	</li>
        
      </ul>
    </div>

    <div id="queens">
      <div class="toolbar">
	<h1 style="font-size:18px;">Queens</h1>
	   <a class="button back" href="#">Back</a>

          <a class="button slideup" href="#mapit" onclick="map_initialize_all(40.754915, -73.861557,12, 'Queens')">Area Map</a>
      </div>

      <ul class="edgetoedge">
       
         <li py:for="i,place in enumerate(places)" py:if="place.region == 'queens'" class="arrow">
	  <a href="mbl_place/${place.id}">${place.title}</a>
	</li>

	
      </ul>
    </div>

    <div id="longisland">
      <div class="toolbar">
	<h1 style="font-size:18px;">Western L.I.</h1>
	   <a class="button back" href="#">Back</a>
          <a class="button slideup" href="#mapit" onclick="map_initialize_all(40.77519, -73.499884,10, 'Western L.I.')">Area Map</a>

      </div>

      <ul class="edgetoedge">
        
        <li py:for="i,place in enumerate(places)" py:if="place.region == 'longisland'" class="arrow">
	  <a href="mbl_place/${place.id}">${place.title}</a>
	</li>

      </ul>
    </div>

   <div id="easternli">
      <div class="toolbar">
	<h1 style="font-size:18px;">Eastern L. I.</h1>

	   <a class="button back" href="#">Back</a>
          <a class="button slideup" href="#mapit" onclick="map_initialize_all(40.77519, -72.55015,9, 'Eastern L.I.')">Area Map</a>
      </div>

      <ul class="edgetoedge">
        
        <li py:for="i,place in enumerate(places)" py:if="place.region == 'easternli'" class="arrow">
	  <a href="mbl_place/${place.id}">${place.title}</a>
	</li>

      </ul>
    </div>

    <div id="staten">
      <div class="toolbar">
	<h1 style="font-size:18px;">Staten Island</h1>

	   <a class="button back" href="#">Back</a>
          <a class="button slideup" href="#mapit" onclick="map_initialize_all(40.541164, -74.216653,12, 'Staten Island')">Area Map</a>
      </div>

      <ul class="edgetoedge">
        
        <li py:for="i,place in enumerate(places)" py:if="place.region == 'staten'" class="arrow">
	  <a href="mbl_place/${place.id}">${place.title}</a>
	</li>

	
      </ul>
    </div>

  <div id="credits">
    <div class="toolbar">
      <h1>MAAP Credits</h1>
        <a class="button back" href="#">Back</a>
    </div>
    <div class="abouttext">
<p>Mapping the African American Past (MAAP) was made possible by a grant from the JPMorgan Chase Foundation and was produced by the Columbia Center for New Media Teaching and Learning (CCNMTL) in partnership with Teachers College and Creative Curriculum Initiatives (CCI).</p>

<p>The MAAP Mobile (MAAPm) was produced by CCNMTL. </p>

<h2>Columbia University Faculty</h2>

<p>Ken Jackson, Jacques Barzun Professor in History and the Social Sciences<br />
Kellie Jones, Associate Professor of Art History and Archaeology</p>

<h2>MAAPm Production</h2>

<p>Executive Producers: Frank Moretti and Maurice Matiz<br />

Mobile site: Maurice Matiz<br />
Graphics: Marc Raymond<br />
Integration: Jonah Bossewitch
</p>

<p>MAAPm is based on the jQTouch framework</p>

<h2>NYC High School Student Readers</h2>

<p>Gabriel Abinante, Mwanzaa Brown, Yin Chang, Jessica Dean, Chris Deelia, Molly Grant Kallins, Ama Mensah, Tiel Reardon, Caroline Rodriguez, Samantha Verini</p>

<h2>Original Site Credits</h2>

<p><b>Columbia Center for New Media Teaching and Learning</b></p>

<p>Executive Producers: Frank Moretti and Maurice Matiz<br />
Associate Producer: Ryan Kelsey<br />
Producer: Mark Phillipson<br />
Project Manager: John Frankfurt<br />
Lead Developer: Jonah Bossewitch<br />
Developer: Schuyler Duveen<br />
Lead Interface Designer: Elizabeth Day<br />

Interface Designer: Marc Raymond<br />
Video Production Lead: Stephanie Ogden<br />
Video Production: Michael R. Deleon<br />
Podcast Production and Flash Development: Brian O'Hagan<br />
Content Developer: Edward Sammons<br />
Grants Officer: Elizabeth Manning<br />
Quality Assurance: Briana Ferrigno and Maria Janelli<br />
</p>

<p><b>Creative Curriculum Initiatives</b></p>

<p>Executive Content Producer: Reggie Powe<br />
Content Manager: Helen Breen<br />
Content Developer: Elspeth Leacock</p>

<p><b>The Center for Public Archaelology at Hofstra University</b></p>

<p>Executive Director: Christopher Matthews<br />
Director of Research and Outreach: Jenna Wallace Coplin<br />
Content Developer: Allison Manfra McGovern<br />
Consultants: Geri Solomon, Long Island Studies Institute,<br />

 Lynda Day, Associate Professor, Africana Studies, Brooklyn College, <br />
 Thelma Jackson-Abidally, Friends of the Booker T. Washington House, <br />
</p>



    </div>
 </div>
</div>
</body>
</html>
