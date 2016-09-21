(function(){
	var menuBar = $(".pf_menu_ul").show();
	var moreBar = $(".pf_menu_more");
	var moreBtn = $(".pf_menu_mbtn");
	var outter = menuBar.parent();
	
	moreBtn.each(function(){
		var time = null;
		moreBtn.mouseover(function(){
			clearTimeout(time);
			moreBtn.unbind("mouseleave").bind("mouseleave", function(){
				time = setTimeout(function(){
					moreBar.hide();
				}, 1500);
			});
			moreBar.show().unbind("mouseover").bind("mouseover", function(){
				clearTimeout(time);
			});
		});
	});
	moreBar.bind("mouseleave", function(){
		moreBar.hide();
	});
	
	$(">li >a", menuBar).mouseover(function(){
		var ul = $(this).next();
		if(ul.find(">li").length == 1){
			ul.width(322);
		}
		
		ul.show().bgiframe({conditional:/MSIE/.test(navigator.userAgent)});
		$(this).parent().mouseleave(function(){
			ul.hide();
		});
	});

	$("a", menuBar).click(function(){
		var sUrl = this.getAttribute("url");
		if(!sUrl || sUrl == "null"){
			var ul = $(this).next();
			if(!ul.is(":hidden") || ul.length == 0) return;
			var sMenuIds = "";
			ul.find(">li >a").each(function(i){
				if(i != 0) sMenuIds += "@";
				sMenuIds += this.getAttribute("menuid");
			});
			AsControl.OpenComp("/AppMain/FourMenu.jsp", "ToDestroyAllComponent=Y&IsMenuItem=Y&MenuIds="+sMenuIds, "_top");
			return;
		}
		
		var sParam = this.getAttribute("param");
		if(!sParam) sParam = "";
		openMenu($(this).text(), sUrl, sParam, this.getAttribute("AccessType"));
	});
	
	var lineHeight = null;
	$(window).resize(function(){
		if(!lineHeight){
			lineHeight = outter.height();
			$(".pf_menu").css("line-height", lineHeight+"px");
		}
		
		var maxWidth = outter.width();
		var width = 20;
		moreBtn.hide();
		$(">li", moreBar).appendTo(menuBar);
		$(">li", menuBar).each(function(){
			width += $(this).width();
			if(width > maxWidth){
				moreBtn.show();
				moreBar.append(this);
			}
		});
	}).resize();
})();