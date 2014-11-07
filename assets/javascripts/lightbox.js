$(document).ready(function() {
	var lightbox_options = {
			prevEffect		: 'none',
			nextEffect		: 'none',
			openSpeed		:	400, 
			closeSpeed		:	200
		};
	
	var pdf_options = {
			prevEffect		: 'none',
			nextEffect		: 'none',
    		openSpeed		:	400, 
    		closeSpeed		:	200,
			width			: '100%',
			height			: '100%',
			autoSize		: true,
			iframe          : {
					preload: false
				}
		};
		
	$("div.attachments div.thumbnails a").attr("rel", "attachments");

	$("div.attachments a.lightbox, div.attachments a.swf, div.attachments a.image, " +
	  "div.attachments a.attachment_preview, ul.details a.swf, ul.details a.image, " +
      "ul.details a.attachment_preview, div.attachments div.thumbnails a").fancybox(lightbox_options);

	$("div.attachments a.pdf, ul.details a.pdf, div.attachments a.attachment_preview, ul.details a.attachment_preview").fancybox(pdf_options);

});