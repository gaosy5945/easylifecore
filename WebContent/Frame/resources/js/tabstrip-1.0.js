

















function TabStripItem(_id,_name,_script){ 
	this.id = _id;						//编号
	this.name = _name;					//名称
	this._actionScript = _script;		//执行脚本
	this._cache = true;					//默认可缓存
	this._canClose = true;				//是否有关闭按钮，默认有
}




TabStripItem.prototype.getID = function(){
	return this.id;
};




TabStripItem.prototype.getName = function(){
	return this.name;
};





TabStripItem.prototype.setCanClose = function(b){
	this._canClose = b;
};



TabStripItem.prototype.getCanClose = function(){
	return this._canClose;
};





TabStripItem.prototype.setCache = function(b){
	this._cache = b;
};




TabStripItem.prototype.getCache = function(){
	return this._cache;
};




TabStripItem.prototype.getActionScript = function(){
	return escape(this._actionScript);
};





TabStripItem.prototype.setActionScript = function(s){
	this._actionScript = s;
};










function TabStrip(id,name,view,container){
	this._id = id;							//ID
	this._name = name;						//名称
	this._selectedItem = "";				//初始化打开项
	this._view = view;						//展现方式：tab,strip
	this._tabs = new Array();				//子标签项容器
	this._container = $(container);			//组件存放容器
	this._isCache 	= true;					//是否缓存，如果缓存了，则Tab切换时，不再刷新页面
	this._canClose = true;					//元素是否可关闭，如果缓存了，则Tab切换时，不再刷新页面
	this._closeCallback = "";				//设置关闭按钮的回调函数
	this._isDialogTitle = false;			//是否设置DialogTitle，主在要对象打开时，会有用，其它地方没效果
	this._debugListenStatu = false;			//是否输出调试情况下监听状态
	this._isAddButton = false;				//设置是否有新增功能按钮
	this._addCallback = "";					//设置新增功能按钮的回调函数
	//类型参数容错处理
	if(this._view != "tab" && this._view != "strip"){
		this._view = "tab";
	}
}





TabStrip.prototype.setID = function(_id){
	this._id = _id;
};





TabStrip.prototype.getID = function(){
	return this._id;
};





TabStrip.prototype.setName = function(_name){
	this._name = _name;
};





TabStrip.prototype.getName = function(_name){
	return this._name;
};





TabStrip.prototype.setSelectedItem = function(_id){
	this._selectedItem = _id;
};




TabStrip.prototype.getSelectedItem = function(){
	return this._selectedItem;
};





TabStrip.prototype.getIframePrefix = function(){
	var preFix;
	if(this._view == "tab"){
		preFix = "tab"+this.getID();
	}else{
		preFix = "strip"+this.getID();
	}
	return preFix;
};






TabStrip.prototype.setIsCache = function(b){
	this._isCache = b;
};





TabStrip.prototype.getIsCache = function(){
	return this._isCache;
};



TabStrip.prototype.getCanClose = function(){
	return this._canClose;
};



TabStrip.prototype.setCanClose = function(b){
	this._canClose = b;
};





TabStrip.prototype.setCloseCallback = function(s){
	this._closeCallback = s;
};




TabStrip.prototype.getCloseCallback = function(){
	return this._closeCallback;
};





TabStrip.prototype.setIsDialogTitle = function(b){
	this._isDialogTitle = b;
};



TabStrip.prototype.getIsDialogTitle = function(){
	return this._isDialogTitle;
};





TabStrip.prototype.setIsAddButton = function(b){
	this._isAddButton = b;
};





TabStrip.prototype.getIsAddButton = function(){
	return this._isAddButton;
};





TabStrip.prototype.setAddCallback = function(s){
	this._addCallback = s;
};





TabStrip.prototype.getAddCallback = function(){
	return this._addCallback;
};





TabStrip.prototype.setDebugListenStatu = function(b){
	this._debugListenStatu = b;
};





TabStrip.prototype.getDebugListenStatu = function(b){
	return this._debugListenStatu;
};
TabStrip.prototype.genHTML = function(){
	if(this._view == "tab"){
		return this.genTabHTML();
	}else{
		return this.genStripHTML();
	}
};





TabStrip.prototype.getItemNumber = function(){
	var count = 0;
	for(var i=0;i<this._tabs.length;i++){
		if(this._tabs[i] != null){
			count ++;
		}
	}
	return count;
};










TabStrip.prototype.addDataItem = function(_id,_name,_script,_isCache,_isClose, px){
	//寻找ID是否重复
	if(this.getItemIndexById(_id) > -1) return null;
	
	var tabItem = new TabStripItem(_id,_name,_script);
	//设置是否缓存，如果容器允许缓存，元素缓存才能生效
	if(this.getIsCache() == true){
		tabItem.setCache(_isCache);
	}else{
		tabItem.setCache(false);
	}
	//设置是否能关闭，容器设置优先
	if(this.getCanClose() == true){
		tabItem.setCanClose(_isClose);
	}else{
		tabItem.setCanClose(false);
	}
	tabItem.px = px;
	this._tabs.push(tabItem);
	return tabItem;
};










TabStrip.prototype.addItem = function(_id,_name,_script,_cache,_isClose,_isOpen){
	var item = this.addDataItem(_id,_name,_script,_cache,_isClose);
	var b = false;
	if(item != null){
		//操作DOM
		if(this._view == "tab"){
			b = this.addTabItem(item,_isOpen);
		}else{
			b = this.addStripItem(item,_isOpen);
		}
	}else{
		$("#handle_"+_id).click();
	}
	return b;
};





TabStrip.prototype.deleteItem = function(_id){
	var n = this.getItemIndexById(_id);
	if(n < 0) return;
	//移除此数据项
	this._tabs[n] = null;
	if(this._view == "tab"){
		this.deleteTabItem(_id);
	}
};
// 根据编号id获取对象所在位置
TabStrip.prototype.getItemIndexById = function(_id){
	for(var i=0;i<this._tabs.length;i++){
		var item = this._tabs[i];
		if(item != null && item.getID() == _id){
			 return i;
		}
	}
	return -1;
};



TabStrip.prototype.init = function(){
	if(this._view == "tab"){
		this.initTab();
	}else{
		this.initStrip();
	}
};






TabStrip.prototype.convertScript = function(s,itemid){
	var exeScript = s;
	var ItemID = itemid;
	exeScript = exeScript.replace("TabContentFrame",this.getIframePrefix()+ItemID);	//兼容老版本配置
	//Tab中打开页面时，如果有主菜单，则应去除其主菜单，特殊处理该参数
	if(exeScript.indexOf("OpenComp(")==0 ||exeScript.indexOf("openComp(")==0){
		//a.去除两端括号,双引号,单引号
		exeScript = exeScript.replace(/(O|o)penComp\(/,"");
		exeScript = exeScript.replace(/\)/,"").replace(/\"/g,"").replace(/\'/g,"");
		part = exeScript.split(",");
		try{
			compID = part[0];
			url = part[1];
			parameter = part[2];
			target = this.getIframePrefix()+ItemID;	//这里换为相应frame的name
			if(isNull(parameter)){
				parameter = "_SYSTEM_MENU_FALG=0";		//tab或strip中打开的内容不显示主菜单
			}else{
				parameter += "&_SYSTEM_MENU_FALG=0";
			}
			exeScript = 'AsControl.OpenComp("'+url+'","'+parameter+'","'+target+'")';
		}catch(e){
			//防止数组下标越界报错
		}
	}
	return exeScript;
};









TabStrip.prototype.genTabHTML = function(){
	var html = '<div class="tabs" id="'+this.getID()+'">';
	html +='<div class="tabs_button" id="tabs_button_'+this.getID()+'">';
	html +='<ul>';
	for(var i=0;i<this._tabs.length;i++){
		html += '<li class="handle" id="handle_'+this._tabs[i].getID()+'" _action="'+this._tabs[i].getActionScript()+'" _isclose="'+this._tabs[i].getCanClose()+'" _iscache="'+this._tabs[i].getCache()+'">';
		html += 	'<span class="tab_inactive_left"></span>';
		html += 	'<span class="tab_inactive_center"><a hidefocus onclick="return false;" href="#">'+this._tabs[i].name+'</a></span>';
		html += 	'<span class="tab_inactive_control"></span>'; 
		html += 	'<span class="tab_inactive_right"></span>'; 
		html += '</li>';
	}
	html += '<li id="divine_handle_'+this.getID()+'" _action=""></li>';
	//新增Tab功能按钮
	if(this.getIsAddButton()){
		html += '<li class="handle" id="addtab_handle_'+this.getID()+'" _action="">';
		html += 	'<span class="addtab_inactive_left"></span>';
		html += 	'<span class="addtab_inactive_center"><a hidefocus onclick="return false;" href="#"></a></span>';
		html += 	'<span class="addtab_inactive_control"></span>'; 
		html += 	'<span class="addtab_inactive_right"></span>'; 
		html += '</li>';
	}
	html +='</ul>';
	html +='</div>';
	html +='<div class="tabs_content" id="tabs_content_'+this._id+'">';
	for(var j=0;j<this._tabs.length;j++){
		html +='<div id="tab_'+this._tabs[j].id+'">';
		html +='<iframe id="'+this.getIframePrefix()+this._tabs[j].id+'" frameborder="0" name="'+this.getIframePrefix()+this._tabs[j].id+'" src="about:blank"></iframe>';
		html +='</div>';
	}
	html +='</div>';
	html +='</div>';
	return html;
};



TabStrip.prototype.initTab = function(){
	_selfobj = this;
	tabID = _selfobj.getID();
	//添加至容器
	$(this._container).html(this.genHTML());
	$("#"+tabID+">div>ul").children("li").each(function(){
		if($(this).attr("id")=="divine_handle_"+tabID) return;
		//鼠标移入，移出
		_selfobj.bindTabHover($(this));
		//单击
		_selfobj.bindTabClick($(this));
		//双击，关闭:如果没有关闭按钮，则不允许关闭
		_selfobj.bindTabDbClick($(this));
	});
	//设置默认项，防止没有报错，用try...catch包裹
	try{
		$("#handle_"+_selfobj.getSelectedItem()).click();
	}catch(e){
		alert("打开第"+_selfobj.getSelectedItem()+"个Tab异常");
	};
};






TabStrip.prototype.showTabStatus = function(obj,s){
	var prefix = "tab_";
	if(this.isNewTabButton(obj)){	//新建按钮和一般按钮使用不同样式
		prefix = "addtab_";
	}
	obj.find("span:eq(0)").removeClass();
	obj.find("span:eq(1)").removeClass();
	obj.find("span:eq(2)").removeClass();
	obj.find("span:eq(3)").removeClass();
	obj.find("span:eq(0)").addClass(prefix+s+"_left");
	obj.find("span:eq(1)").addClass(prefix+s+"_center");
	obj.find("span:eq(2)").addClass(prefix+s+"_control");
	obj.find("span:eq(3)").addClass(prefix+s+"_right");
};





TabStrip.prototype.bindTabHover = function(obj){
	//鼠标移上，移出
	obj.hover(function(){
		//鼠标移动，对于已激活按钮无效
		if($(this).data("_active") != "1"){
			_selfobj.showTabStatus($(this),"over");
			//关闭按钮,只有允许关闭的情况下，才绑定关闭按钮
			if($(this).attr("_isclose") == "true" && $(this).data("_tab_close") != "1"){
				//添加关闭按钮
				$(this).find("span:eq(2)").append("<div></div>");
				$(this).find("span:eq(2)").find("div").addClass("tab_close");
				$(this).data("_tab_close","1");
				//为关闭按钮绑定事件
				_li = $(this);
				$(this).find("span:eq(2)").find("div").click(function(){
					_li.dblclick();
				});
			}
		}
	},function(){
		//鼠标移动，对于已激活按钮无效
		if($(this).data("_active") != "1"){
			_selfobj.showTabStatus($(this),"inactive");
			//移除关闭按钮
			if($(this).attr("_isclose") == "true" && $(this).data("_tab_close") == "1"){
				$(this).find("span:eq(2)").find("div").remove();
				$(this).data("_tab_close","0");
			}
		}
	});
};






TabStrip.prototype.bindTabClick = function(obj){
	_selfobj = this;
	if(this.isNewTabButton(obj)){
		obj.click(function(){
			exeScript= _selfobj.getAddCallback();
			exeScript = unescape(exeScript);
			if(!isNull(exeScript)){
				try{
					eval(exeScript);
				}catch(e){
					return;
				}
				return false;
			}
		});
	}else{
		obj.click(function(){
			ItemID = $(this).attr("id").replace(/^handle_/,"");
			$(this).parent("ul").children("li").each(function(i){
				//1.清除当前已激活的
				if($(this).data("_active") == "1"){
					_selfobj.showTabStatus($(this),"inactive");
					$(this).data("_active","0");
					//如果有关闭按钮，则清除关闭按钮
					if($(this).attr("_isclose") == "true" && $(this).data("_tab_close") == "1"){
						$(this).find("span:eq(2)").find("div").remove();
						$(this).data("_tab_close","0");
					}
				}
				//如果有元素设置了不缓存，则清除它
				if($(this).attr("_iscache") != "true" && $(this).data("_loaded") == "1" ){
					resetItemID = $(this).attr("id").replace(/^handle_/,"");
					iframe = '<iframe id="'+_selfobj.getIframePrefix()+resetItemID+'" frameborder="0" name="'+_selfobj.getIframePrefix()+resetItemID+'" src="about:blank"></iframe>';
					$("#tab_"+resetItemID).empty();
					$("#tab_"+resetItemID).append(iframe);	//重新建立iframe
					$(this).data("_loaded","0");
				}
			});
			
			//2.把当前项设置为激活
			_selfobj.showTabStatus($(this),"active");
			$(this).data("_active","1");
			//关闭按钮
			if($(this).attr("_isclose") == "true" && $(this).data("_tab_close") != "1"){
				$(this).find("span:eq(2)").append("<div></div>");
				$(this).find("span:eq(2)").find("div").addClass("tab_close");
				$(this).data("_tab_close","1");
				//为关闭按钮绑定事件
				_li = $(this);
				$(this).find("span:eq(2)").find("div").click(function(){
					_li.dblclick();
				});
			}
			
			//3.隐藏所有窗口
			$(this).parents("div.tabs").children("div:eq(1)").children("div").each(function(){
				$(this).css("display","none"); 
			});
			
			//4.显示当前窗口
			$("#tab_"+ItemID).css("display","block");
			
			//5.加载页面
			//try{setDialogTitle("&nbsp;&nbsp;");}catch(e){}			//先清除标题
			if($(this).data("_loaded") != "1"){		//如果已经加载过了，则不用再加载了
				//3.取执行脚本
				exeScript=$(this).attr("_action");
				exeScript = unescape(exeScript);
				exeScript = _selfobj.convertScript(exeScript,ItemID);
				try{
					// firefox下frame还未初始化完成就打开页面异常
					setTimeout(function(){
						eval(exeScript);
					},100);
				}catch(e){
					alert("选项卡["+$(this).text()+"]执行脚本为["+exeScript+"]，该脚本执行异常");
					return;
				}
				$(this).data("_loaded","1");		//记下加载状态
			}
				
			//6.2 设置标题
			//记录下title，由于tab切换时，不再重新加载，因此需要记录下原来的title
			//这里需要特别注意，由于页面是在iframe中打开，所以不会阻塞，在页面打开以前，就执行到这里了
			//监听
			oLi = this;
			//6.3 设置对话框标题，主要用在打开对象时
			listenNum = 0;
			if(_selfobj.getIsDialogTitle()){
				timeoutID = setInterval(function(){
					if(_selfobj.getDebugListenStatu()){
						$("#"+tabID).before(listenNum+++"-加载中,监听...<br/>");
					}
					if(isNull($(oLi).data("_title")) || unescape($(oLi).data("_title")) == "&nbsp;&nbsp;"){
						dialogTitle = "";
						try{dialogTitle = getDialogTitle();}catch(e){};
						$(oLi).data("_title", escape(dialogTitle));
					}else{
						//try{setDialogTitle(unescape($(oLi).data("_title")));}catch(e){};
						clearInterval(timeoutID);						//设置成功后，清除定时器
					}
				},10);
			}
		//单击事件后推号结束
		});
	}
};






TabStrip.prototype.bindTabDbClick = function(obj){
	_selfobj = this;
	if(this.isNewTabButton(obj)){
		return false;
	}else{
		obj.dblclick(function(e){
			if($(this).attr("_isclose") != "true") return false;
			try{
				var ItemID = $(this).attr("id").replace(/^handle_/,"");
				_closeCallback = _selfobj.getCloseCallback();	//触发回调函数
				var _flag = true;
				if(typeof _closeCallback == "function"){
					var n = _selfobj.getItemIndexById(ItemID);
					if(n > -1) _flag = _closeCallback(_selfobj._tabs[n].id, _selfobj.getIframePrefix()+ItemID);
				}else if(typeof _closeCallback == "string"){
					_flag = eval(_closeCallback);
				}
				// 从DOM模型中移除数据
				if(_flag != false)
					_selfobj.deleteItem(ItemID);
			}catch(e){
			}
			return false;
		});
	}
};






TabStrip.prototype.addTabItem = function(item,_isOpen){
	
	htmlLi = '';
	htmlDiv = '';
	//按钮
	htmlLi += '<li class="handle" id="handle_'+item.getID()+'" _action="'+item.getActionScript()+'" _isclose="'+item.getCanClose()+'" _iscache="'+item.getCache()+'">';
	htmlLi += 	'<span class="tab_inactive_left"></span>';
	htmlLi += 	'<span class="tab_inactive_center"><a hidefocus onclick="return false;" href="#">'+item.getName()+'</a></span>';
	htmlLi += 	'<span class="tab_inactive_control"></span>'; 
	htmlLi += 	'<span class="tab_inactive_right"></span>'; 
	htmlLi += '</li>';
	//内容容器
	htmlDiv +='<div id="tab_'+item.getID()+'">';
	htmlDiv +='<iframe id="'+this.getIframePrefix()+item.getID()+'" frameborder="0" name="'+this.getIframePrefix()+item.getID()+'" src="about:blank"></iframe>';
	htmlDiv +='</div>';
	$("#divine_handle_"+this.getID()).before(htmlLi);
	//找到内容容器，添加内容
	$("#tabs_content_"+_selfobj.getID()).append(htmlDiv);
	//绑定事件
	this.bindTabHover($("#handle_"+item.getID()));
	this.bindTabClick($("#handle_"+item.getID()));
	this.bindTabDbClick($("#handle_"+item.getID()));
	if(_isOpen){	//是否打开添加项
		$("#handle_"+item.getID()).click();
	}
	return true;
};






TabStrip.prototype.deleteTabItem = function(id){
	//1.打开前一个Tab
	try{
		//找完前面，找后面
		if($("#handle_"+id).prev("li").html() != null){
			$("#handle_"+id).prev("li").click();
		}else if($("#handle_"+id).next("li").html() != null){
			$("#handle_"+id).next("li").click();
		}
		//2.删除标签
		$("#handle_"+id).remove();
		//3.删除内容
		$("#tab_"+id).remove();
	}catch(e){};
};





TabStrip.prototype.isNewTabButton = function(obj){
	var id = obj.attr("id");
	var b = false;
	if(isNull(id)){
		id = "";
	}
	if(id.indexOf("addtab_handle_")>-1){
		b = true;
	}
	return b;
};





TabStrip.prototype.initStrip = function(){
	_selfobj = this;
	tabID = _selfobj.getID();
	//添加至容器
	$(this._container).html(this.genHTML());
	$("#"+tabID+">div").find("h3").each(function(){
		//鼠标移入，移出
		_selfobj.bindStripHover($(this));
		//单击
		_selfobj.bindStripClick($(this));
	});	
	
	//设置默认项，防止没有报错，用try...catch包裹
	try{
		$("#strip_hand_"+_selfobj.getSelectedItem()).click();
	}catch(e){
	};
};






TabStrip.prototype.addStripItem = function(item,_isOpen){
	var style = '';
	if(!isNaN(item.px)) style = 'style="height:'+parseInt(item.px, 10)+'px;"';
	var htmlItem = '';
	//1.组装
	htmlItem += '<div id="strip_item_'+item.getID()+'" class="strip_item">';
	htmlItem += 	'<h3 id="strip_hand_'+item.getID()+'" _action="'+item.getActionScript()+'" _iscache="'+item.getCache()+'">';
	htmlItem += 		'<span class="strip_hand_inactive">';
	htmlItem += 			'<span class="arrow_inactive"></span>';
	htmlItem += 			'<span>'+item.getName()+'</span>';
	htmlItem += 			'<span style="float:right;">';
	htmlItem += 			'<a href="javascript:void(0);" style="margin-right:10px;">刷新</a>';
	htmlItem += 			'<a href="javascript:void(0);" style="margin-right:10px;">新窗口</a>';
	htmlItem += 			'</span>';
	htmlItem += 		'</span>';
	htmlItem += 	'</h3>';
	htmlItem += 	'<div id="strip_item_container_'+item.getID()+'" '+style+'>';
	htmlItem += 		'<iframe id="'+this.getIframePrefix()+item.getID()+'" frameborder="0" name="'+this.getIframePrefix()+item.getID()+'" src="about:blank"></iframe>';
	htmlItem += 	'</div>';
	htmlItem += '</div>';
	//2.添加到容器
	$("#"+this.getID()).append(htmlItem);
	//3.绑定事件
	this.bindStripHover($("#strip_hand_"+item.getID()));
	this.bindStripClick($("#strip_hand_"+item.getID()));
	//4.添加后，是否立即打开
	if(_isOpen){
		$("#strip_hand_"+item.getID()).click();
	}
	return true;
};




TabStrip.prototype.genStripHTML = function(){
	var html = '';
	html += '<div id="'+this.getID()+'" class="strip_main_content">';
	for(var i=0;i<this._tabs.length;i++){
		var style = "";
		if(!isNaN(this._tabs[i].px)) style = 'style="height:'+parseInt(this._tabs[i].px, 10)+'px"';
		html += '<div id="strip_item_'+this._tabs[i].getID()+'" class="strip_item">';
		html += 	'<h3 id="strip_hand_'+this._tabs[i].getID()+'" _action="'+this._tabs[i].getActionScript()+'" _iscache="'+this._tabs[i].getCache()+'">';
		html += 		'<span class="strip_hand_inactive">';
		html += 			'<span class="arrow_inactive"></span>';
		html += 			'<span>'+this._tabs[i].getName()+'</span>';
		html += 			'<span style="float:right;">';
		html += 			'<a href="javascript:void(0);" style="margin-right:10px;">刷新</a>';
		html += 			'<a href="javascript:void(0);" style="margin-right:10px;">新窗口</a>';
		html += 			'</span>';
		html += 		'</span>';
		html += 	'</h3>';
		html += 	'<div id="strip_item_container_'+this._tabs[i].getID()+'" '+style+'>';
		html += 		'<iframe id="'+this.getIframePrefix()+this._tabs[i].getID()+'" frameborder="0" name="'+this.getIframePrefix()+this._tabs[i].getID()+'" src="about:blank"></iframe>';
		html += 	'</div>';
		html += '</div>';
	}
	html +='</div>';
	return html;
};





TabStrip.prototype.bindStripHover = function(obj){
	obj.hover(function(){
		$(this).find("span:eq(0)").removeClass();
		$(this).find("span:eq(0)").addClass("strip_hand_over");
	},function(){
		if($(this).data("_active") != "1"){					//如果该项已激活，则hover移出无效
			$(this).find("span:eq(0)").removeClass();
			$(this).find("span:eq(0)").addClass("strip_hand_inactive");
		}
	});
};





TabStrip.prototype.bindStripClick = function(obj){
	_selfobj = this;
	obj.click(function(){
		ItemID = $(this).attr("id").replace(/^strip_hand_/,"");
		if($(this).data("_active") != "1"){
			//1.设置外观
			$(this).find("span:eq(0)").removeClass();
			$(this).find("span:eq(0)").addClass("strip_hand_over");
			//2.取出标识号
			//3.执行打开
			if($(this).data("_loaded") != "1"){
				exeScript=$(this).attr("_action");
				exeScript = _selfobj.convertScript(exeScript,ItemID);	//脚本兼容性转转
				exeScript = unescape(exeScript);
				eval(exeScript);
				$(this).data("_loaded","1");
			}
			//4.显示
			$(this).find("span:first").find("span:first").removeClass();
			$(this).find("span:first").find("span:first").addClass("arrow_active");
			$("#strip_item_container_"+ItemID).slideDown();
			$(this).data("_active","1");
		}else{
			$(this).find("span:first").find("span:first").removeClass();
			$(this).find("span:first").find("span:first").addClass("arrow_inactive");
			$("#strip_item_container_"+ItemID).slideUp();
			$(this).data("_active","0");
		}
	}).find("a").each(function(i){
		$(this).click(function(e){
			AsLink.stopEvent(e);
			if(i == 1){
				var sItemID = obj.attr("id").replace(/^strip_hand_/,"");
				var sExeScript = obj.attr("_action");
				var exeScript = _selfobj.convertScript(sExeScript, sItemID);
				eval(unescape(exeScript.replace("OpenComp", "PopComp").replace(_selfobj.getIframePrefix()+sItemID, "")));
			}
			$(obj).removeData("_loaded");
			$(obj).removeData("_active");
			obj.click();
			return false;
		});
	});
};