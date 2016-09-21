(function(){
	var $body = $("body");
	var $apps = $("#apps");
	var $worktip = $("#worktip");
	var $notice = $("#notice");
	var $quick = $("#quick");

	var $moreapps = $("#moreapps");
	var $appsbody = $(".body", $apps);
	var $worktipbody = $(".body", $worktip);
	var $noticebody = $(".body", $notice);
	var $quickbody = $(".body", $quick);
	var $noticediv = $(">div:not(.space)", $noticebody);
	var as = $("a", $appsbody);
	
	function resize(){
		var height = $body.height() - 40;
		var width = $body.width() - 280;
		var height1top = Math.ceil((1000 * (height - 20)) / 1618);
		var height1bottom = height - 20 - height1top;
		var width1left = Math.ceil((width - 20) / 2);
		var width2right = width - 20 - width1left;
		
		$apps.height(height);
		$worktip.height(height1top);
		$notice.height(height1bottom);
		$quick.height(height1bottom);
		$worktip.width(width);
		$notice.width(width1left);
		$quick.width(width2right);
		
		$notice.css("top", height1top + 40);
		$quick.css("left", width1left + 280);
		$quick.css("top", height1top + 40);

		$appsbody.height(height - 40);
		$worktipbody.height(height1top - 40);
		$noticebody.height(height1bottom - 40);
		$quickbody.height(height1bottom - 40);
		
		var m = Math.floor(($body.height() - 80) / 110); // 一列排多少个
		var n = Math.ceil(as.length / m); // 需要排多少列
		if(n <= 2){ // 少于两列直接横向排列
			$appsbody.width(110*2).empty().append(as);
			$moreapps.hide();
		}else{ // 纵向排列，使收起状态无空缺
			$appsbody.width(110*n).empty();
			for(var i = 0; i < as.length; i++){
				if(i % m == 0) div = $("<div></div>").appendTo($appsbody);
				div.append(as[i]);
			}
			$moreapps.show();
		}
		
		// 数据较多时给予滑动条
		$noticediv.height();
		if($noticediv.height() / (height1bottom - 40) > 3) $noticebody.css("overflow-y", "scroll");
		else $noticebody.css("overflow-y", "hidden");
	}
	
	$apps.bind("mouseover", function(){
		$apps.width($appsbody.width());
		$moreapps.text("收起");
	}).bind("mouseleave", col);
	$moreapps.bind("click", col);
	function col(){
		$apps.width(220);
		$moreapps.text("更多");
	}
	
	var curObj = null;
	window.initTab = function(obj){
		if(!obj || obj == curObj) return false;
		$(curObj).removeClass("click");
		curObj = obj;
		$(curObj).addClass("click");
		$("iframe", $worktipbody).hide();
		
		var frameId = "TabFrameName_"+obj.id;
		var frame = document.getElementById(frameId);
		if(frame){
			$(frame).show();
			return false;
		}
		
		$("<iframe id='"+frameId+"' name='"+frameId+"' width='100%' height='100%' frameborder='0'></iframe>").appendTo($worktipbody);
		return true;
	};
	
	resize();
	$(window).resize(resize);

	var time = null;
	function notice(){
		var top = $noticebody.scrollTop();
		$noticebody.scrollTop($noticebody.scrollTop() + 1);
		if(top == $noticebody.scrollTop()){
			$noticebody.scrollTop(0);
		}
		time = setTimeout(notice, 25);
	}
	
	if($("a", $noticebody).length > 0){
		notice();
		$noticediv.bind("mouseover", function(){
			clearTimeout(time);
		}).bind("mouseleave", notice);
	}
})();