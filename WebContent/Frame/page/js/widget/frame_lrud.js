(function(){
	var firstFrameName = Layout.initRegionName("FirstFrame", self.name);
	var secondFrameName = Layout.initRegionName("SecondFrame", self.name);

	var curscale = 1;
	var body = $(".body").bind("selectstart", function(){return false;});
	var first = $("#FirstFrame").append("<iframe name=\""+firstFrameName+"\" width=\"100%\" height=\"100%\" frameborder=\"0\" allowtransparency >");
	var second = $("#SecondFrame").append("<iframe name=\""+secondFrameName+"\" width=\"100%\" height=\"100%\" frameborder=\"0\" allowtransparency >");
	var board = $("#Board");
	var iborder = $("#IBorder");
	var border = $("#Border").mousedown(function(e){
		board.show();
		iborder.show();
		$(document).bind("mousemove", move).bind("mouseup", up);
		var bLeftRight = body.hasClass("leftright");
		var length = bLeftRight ? (first.is(":hidden")?0:first.width()) - e.clientX : (first.is(":hidden")?0:first.height()) - e.clientY;
		move(e); // ≥ı ºŒª÷√
		
		function move(e){
			iborder.css({
				"left" : bLeftRight ? length + e.clientX : 0,
				"top": bLeftRight ? 0 : length + e.clientY,
				"width" : bLeftRight ? 10 : "100%",
				"height" : bLeftRight ? "100%" : 10
			});
		}
		function up(e){
			$(document).unbind("mousemove", move).unbind("mouseup", up);
			if(first.is(":hidden")) first.show().width(0);
			if(second.is(":hidden")) second.show().width(0);
			length = length + (bLeftRight ? e.clientX : e.clientY);
			var scale = bLeftRight ? length/(body.width()-length) : length/(body.height()-length);
			if(length <= 10) first.hide();
			else if(scale <= 0 || scale > 100 || isNaN(scale)) second.hide();
			//alert(first.is(":hidden")+" "+second.is(":hidden")+" "+scale);
			changeLayout(bLeftRight, scale);
			board.hide();
			iborder.hide();
		}
	});
	var borderWidth = border.width();
	
	var btn = $("<a class=\"centera\" hidefocus href=\"javascript:void(0);\">&nbsp;</a>").click(function(){
		changeLayout(!isLeftRight());
	}).hide();
	$("<span></span>").appendTo(border).append($("<a class=\"firsta\" hidefocus href=\"javascript:void(0);\">&nbsp;</a>").click(function(){
		if(second.is(":hidden")){
			second.show();
			changeLayout();
		}else{
			first.hide();
			changeLayout();
		}
	})).append(btn).append($("<a class=\"seconda\" hidefocus href=\"javascript:void(0);\">&nbsp;</a>").click(function(){
		if(first.is(":hidden")){
			first.show();
			changeLayout();
		}else{
			second.hide();
			changeLayout();
		}
	})).mousedown(AsLink.stopEvent);
	
	var leftRight = false;





	window.changeLayout = changeLayout;



	window.isLeftRight = function(){
		return leftRight;
	};



	window.showChangeBtn = function(){
		btn.show();
	};
	var firstTitle = null, secondTitle = null;
	window.setTitle = function(title, isFirst){
		if(leftRight) border.addClass("RightContentDiv");
		else border.removeClass("RightContentDiv");
		if(isFirst == true){
			if(!firstTitle){
				firstTitle = $("<span class=\"pt9white\"></span>").appendTo($("<span class=\"title left_content_title\"></span>").prependTo(first));
				changeLayout();
			}
			firstTitle.html(title);
		}else{
			second.addClass("RightContentDiv");
			if(!secondTitle){
				secondTitle = $("<span class=\"pt9white\"></span>").appendTo($("<span class=\"title\"></span>").prependTo(second));
				changeLayout();
			}
			secondTitle.html(title);
		}
	};
	$(function(){
		$(window).resize(function(){
			changeLayout();
		});
	});
	changeLayout();
	
	function changeLayout(bLeftRight, scale){
		//alert(scale);
		if(bLeftRight!=true&&bLeftRight!=false){
			if(body.hasClass("leftright")){
				bLeftRight = true;
			}else{
				bLeftRight = false;
			}
		}
		if(isNaN(scale)){
			if(!isNaN(curscale)){
				scale = curscale;
			}else{
				scale = 1;
			}
		}
		
		if(bLeftRight){
			body.removeClass("updown").addClass("leftright");
			border.height("100%").width(borderWidth);

			var width = body.innerWidth();
			if(!border.is(":hidden")) width -= border.outerWidth();
			if(first.is(":hidden")){
				second.outerWidth(width);
			}else if(second.is(":hidden")){
				first.outerWidth(width);
			}else{
				var width1 = parseInt(width / (1 + scale), 10);
				first.outerWidth(width-width1);
				second.outerWidth(width1);
				curscale = scale;
			}
			first.add(second).add(border).height(body.height());
		}else{
			body.removeClass("leftright").addClass("updown");
			first.width("100%");
			second.width("100%");
			border.width("100%").height(borderWidth);

			var height = body.innerHeight() - border.outerHeight();
			if(first.is(":hidden")){
				second.outerHeight(height);
			}else if(second.is(":hidden")){
				first.outerHeight(height);
			}else{
				var height1 = height / (1 + scale);
				first.outerHeight(height-height1);
				second.outerHeight(height1);
				curscale = scale;
			}
		}
		if(firstTitle) $("iframe", first).height(first.height()-30);
		if(secondTitle) $("iframe", second).height(second.height()-30);
		leftRight = bLeftRight;
	}
})();