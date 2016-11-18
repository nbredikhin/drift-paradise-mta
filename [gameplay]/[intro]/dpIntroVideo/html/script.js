var video = document.getElementById('dpVideo');
video.addEventListener('ended',function () {
	mta.triggerEvent("_dpIntroVideo.ended");
},false);
