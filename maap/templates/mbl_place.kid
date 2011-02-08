<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:py="http://purl.org/kid/ns#">

<body>

<div id="${place.id}">
   <div class="toolbar">
   <h1>Places</h1>
   <a class="button back" href="#" onClick="document.getElementById('audio${place.id}').pause();">Back</a>
   <a class="button slideup" href="#mapit" onclick="map_initialize('${place.latitude}','${place.longitude}','${place.id}')" >Map</a>
 </div>
 <div>
    <h1 id="t${place.id}">${XML(place.title)}</h1>
 </div>
 <ul class="individual">
   <li><a class="slideup" href="#then${place.id}">Then</a></li>
   <li><a class="slideup" href="#now${place.id}">Now</a></li>
 </ul>


  <div style="margin:0px 8px 0px 20px;">
    <audio id="audio${place.id}" controls="true" onclick="this.play()">
  <source src="http://ccnmtl.columbia.edu/podcasts/projects/maap/${place.name}.mp3" /></audio> 
</div>	
<div>
    <p>${XML(place.body)}</p>
  </div>

      <div class="info" py:if="place.featured_video">
      <div id="expert-commentary"> 
      <p style="margin:0px;">Expert Commentary:</p>
      <video width="90" height="60" controls="true" onclick="this.play();" poster="/static/mbl/images/button_maap_audio.png" src="${place.featured_video.audio_url}">
         <b>Your browser does not support the audio tag.</b> </video>
       <video width="90" height="60" controls="true" onclick="this.play();" poster="/static/mbl/images/button_maap_video.png" src="${place.featured_video.download_url}">
	<b>Your browser does not support the audio tag.</b> </video>
       </div>
    </div>
   
</div>

 <div id="then${place.id}">
  <div class="toolbar">
     <h1>Then</h1>
    <a class="button back" href="#${place.id}">Close</a>
    <a class="button flip" href="#now${place.id}">Now</a>
   </div>
   <div class="placepics">
      <h1>${XML(place.title)}</h1>
      <p style="text-align: center;" id="img${place.id}"><img src="${place.then_image.src_url}" /> </p>
      <p id="caption${place.id}">${place.then_image.caption}</p>
      <p>${XML(place.then_text)}</p>
      <p style="font-size:90%">${place.then_image.rights}</p>
      <a style="margin:10px 20px;" href="#" class="whiteButton goback">Close</a>
   </div>
</div>



  <div id="now${place.id}">
  <div class="toolbar">
     <h1>Now</h1>
    <a class="button back" href="#${place.id}">Close</a>
    <a class="button flip" href="#then${place.id}">Then</a>

   </div>
   <div class="placepics">
      <h1>${XML(place.title)}</h1>
      <p>${place.now_image.caption}</p>
      <p style="text-align: center;"><img src="${place.now_image.src_url}" /> </p>
      <p>${XML(place.now_text)}</p>
      <p style="font-size:90%">${place.now_image.rights}</p>
      <a style="margin:10px 20px;" href="#" class="whiteButton goback">Close</a>
   </div>
  </div>

</body>
</html> 

        
    
 
