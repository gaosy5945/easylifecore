(function(){
	// 定义寻找元素
	var body = $("body");
	var pageTop = $(".page_top");
	var firstMenu = $(".first_menu");
	var prev = $(">span:first", firstMenu);
	var next = $(">span:last", firstMenu);
	var userInfo = $(".user_info");		
	var showaction = $(".showaction");
	var action = $(".action");

	var curA = null;
	
	// 画一级菜单
	for(var i = 0; i < menus.length; i++){
		drawFirstMenu(menus[i]);
	}
	
	if(!sMenuId){
		body.addClass("no_follow");
		AsControl.OpenComp("/AppMain/Welcome.jsp", "", "FunctionPage");
	}
	
	showaction.mouseover(function(){
		showaction.addClass("showaction_down");
		action.show();
	});
	
	userInfo.mouseleave(function(){
		showaction.removeClass("showaction_down");
		action.hide();
	});
	
	// 计算元素大小宽度
	var height0 = pageTop.height();
	resize();
	$(window).resize(resize);

	prev.mouseover(function(){
		$(">span", this).show();
	}).mouseleave(function(){
		$(">span", this).hide();
	});
	next.mouseover(function(){
		$(">span", this).show();
	}).mouseleave(function(){
		$(">span", this).hide();
	});
	
	function drawFirstMenu(menu){
		var a = $("<a hidefocus href='javascript:void(0);' onclick='return false;'>"+menu["name"]+"</a>").appendTo($(">span", prev)).click(function(){
			var as = prev.nextAll("a");
			var index0 = as.index(this)+1;
			var index1 = as.length - index0;
			if(!index0 || isNaN(index0)) index0 = 1;
			if(!index1 || isNaN(index1)) index1 = 0;
			AsControl.OpenComp("/Main.jsp", "ToDestroyAllComponent=Y&MenuId="+menu["id"]+"&Title="+menu["name"]+"&Index0="+index0+"&Index1="+index1, "_self");
		});
		if(sMenuId&&menu["id"] == sMenuId){
			curA = a;
			a.addClass("click");
			var sParas =menu["param"]+ "&_SYSTEM_MENU_FALG=0";
			sParas = sParas.replace("ToDestroyAllComponent=Y", "");
			AsControl.OpenComp(menu["url"], sParas, "FunctionPage");
		}
	}

	// 窗口变化计算
	function resize(){
		var height = body.height();
		var width = body.width() - 4;
		pageTop.next().height(height - height0);
		
		var menuWidth = width - 110 - 134;
		firstMenu.width(menuWidth);
		
		prev.after(prev.find(">span a").addClass("InLine"));
		next.before(next.find(">span a").addClass("InLine"));
		var a = curA;
		if(!a) a = prev.next("a")[0];
		var $a = $(a);
		var $na = $(a).next();
		var mWidth = 99;
		prev.hide();
		next.hide();
		var i0 = index0, i1 = index1;
		//alert(i0+" "+i1);
		while($a.is("a") || $na.is("a")){
			if((i0-- > 0 || i1 <= 0) && $a.is("a")){
				mWidth += $a.outerWidth(true);
				//alert(1+" "+mWidth + " "+menuWidth + " "+$a.outerWidth(true)+" "+$a.text());
				var a = $a;
				$a = $a.prev();
				if(mWidth > menuWidth){
					prev.show().find(">span").prepend(a.removeClass("InLine"));
				}
			}
			if((i1-- > 0 || i0 <= 0) && $na.is("a")){
				mWidth += $na.outerWidth(true);
				//alert(2+" "+mWidth + " "+menuWidth + " "+$na.outerWidth(true)+" "+$na.text());
				var a = $na;
				$na = $na.next();
				if(mWidth > menuWidth){
					next.show().find(">span").append(a.removeClass("InLine"));
				}
			}
		}
	}
})();
