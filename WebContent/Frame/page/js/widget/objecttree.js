





$.fn.objectTree = function(model){
	/* 描绘 */
	this.draw = draw;
	/* 参数：HTMLElement */
	this.getNode = getNode;
	/* 获取当前点击节点 */
	this.getClick = getClick;
	/* 获取当前定位节点 */
	this.getHover = getHover;
	this.getRoot = getRoot;
	/* 参数：将勾选的节点 */
	this.check = check;
	/* 参数：将去除勾选的节点 */
	this.uncheck = uncheck;
	/* 参数：是否包括半选节点 */
	this.getChecked = getChecked;
	/* 参数：搜索节点显示文字text的片段 */
	//this.searchNodes = searchNodes;
	/* 参数为：父节点parent，数据data */
	this.addChild = addChild;
	this.addBefore = addBefore;
	this.addAfter = addAfter;
	/* 参数：删除的节点 */
	this.removeNode = removeNode;
	
	this.showSearch = showSearch;
	
	this.isMultiselect = isMultiselect;
	
	var beUnChecked = 0, beHalfChecked = 1, beChecked = 2;
	var cls = {
			"tree" : "objecttree",
			"search" : "search",
			"search_title" : "search_title",
			"title" : "title",
			"body" : "body",
			"node" : "node",
			"page" : "page",
			"folder" : "folder",
			"collapse" : "collapse",
			"hover" : "hover",
			"click" : "click",
			"index" : "index",
			"arrow" : model["Icon"]==true?"arrow":"arrow2",
			"deficon" : "deficon",
			"check" : "check",
			"checked" : "checked",
			"halfchecked" : "halfchecked"
	};
	var $tree = this;
	var clickNode = null;
	var hoverNode = null;
	var root = new TreeNode(model);
	var nodes = new Array();
	var expands = init();
	function getRoot(){
		return root;
	}
	function draw(){
		$tree.empty().addClass(cls["tree"]);
		var height = $tree.height();
		$tree.each(function(){
			root["dom"] = this;
			this.node = root;
		});
		for(var i = 0; i < root.getChildren().length; i++){
			_addNode(root.getChildren()[i]);
		}
		if(expands) for(var i = 0; i < expands.length; i++){
			expands[i].expand();
		}
		if(clickNode) clickNode.click();
	}
	function removeNode(node){
		if(!node) return;
		var parent = node.getParent();
		if(parent){
			// 删除数据
			if(node.getData() && node.getParent().getData()){
				var datas = node.getParent().getData()["Storys"];
				datas.splice(datas.indexOf(node.getData()), 1);
			}
			// 删除父节点存储节点
			var children = node.getParent().getChildren();
			children.splice(children.indexOf(node), 1);
		}
		// 删除全局存储节点
		clear(node);
		// 删除HTMLElement
		if(node["dom"]) $(node["dom"]).remove();
		
		// 清理
		function clear(node){
			if(node == clickNode) clickNode = null;
			if(node == hoverNode) hoverNode = null;
			for(var i = 0; i < node.getChildren().length; i++){
				clear(node.getChildren()[i]);
			}
			nodes.splice(nodes.indexOf(node), 1);
		}
		
		// 父节点界面元素样式更改
		if(parent && parent != root){
			if(parent.getChildren().length < 1)
				$(parent.getDom()).removeClass(cls["folder"]).addClass(cls["page"]);
			if(isMultiselect()) packCheck(parent);
		}
	}
	function getChecked(flag){
		var datas = new Array();
		if(!isMultiselect()) return datas;
		packChecked(datas, root, flag);
		return datas;
	}
	function packChecked(target, node, flag){
		for(var i = 0; i < node.getChildren().length; i++){
			if(!node.getChildren()[i].getData()["Check"]) continue;
			if(flag == true || node.getChildren()[i].getData()["Check"] == beChecked) target.push(node.getChildren()[i]);
			packChecked(target, node.getChildren()[i], flag);
		}
	}
	function isMultiselect(){
		return model["Multiselect"] == true;
	}
	function _addNode(node, inner){
		if(!node || node["dom"] || !node.getData()) return false;
		var parent = node.getParent();
		if(!parent) return false;
		var pdom = parent.getDom();
		if(!pdom) return false;
		var index = parent.getChildren().indexOf(node);
		if(index < 0) return false;
		var data = node.getData();
		
		var li = $("<li class='"+cls["collapse"]+" "+cls[node.getChildren().length>0?"folder":"page"]+"'></li>");
		if(index < parent.getChildren().length - 1 && !(!parent.getChildren()[index+1]["dom"])){
			li.insertBefore(parent.getChildren()[index+1]["dom"]);
		}else{
			var ul = $(">ul:first", pdom);
			if(ul.length != 1){
				ul = $("<ul "+(parent==getRoot()?"":"style='display:none;'")+"></ul>").appendTo(pdom);
				if(typeof $tree.NodeAfterDrag=="function"){
					ul.disableSelection();
					ul.sortable({/*start:function(e, ui){
						ui.item.each(function(){
							this.node.collapse();
						});
					},containment : $tree,*/ connectWith : "."+cls["tree"]+" ul", /*axis:"y",*/ delay : 1000, stop:function(e, ui){
						var node = null;
						ui.item.each(function(){
							node = this.node;
						});
						var curParent = getNode(ui.item.parent());
						if(!curParent) return;
						
						var parent = node.getParent();
						var index = parent.getChildren().indexOf(node);
						
						var next = null;
						ui.item.next().each(function(){
							next = this.node;
						});
						// 位置不变，不走后续程序
						if(parent == curParent){
							var curIndex = curParent.getChildren().length-1;
							if(next) curIndex = curParent.getChildren().indexOf(next)-1;
							//alert(index + " " + curIndex);
							if(index == curIndex) return;
						}
						
						// 删除原结构
						parent.getChildren().splice(index, 1);
						parent.getData()["Storys"].splice(index, 1);
						
						if(!next){
							curParent.getChildren().push(node);
							curParent.getData()["Storys"].push(node.getData());
						}else{
							// if(parent==curParent)curIndex会有改变
							var indexn = curParent.getChildren().indexOf(next);
							curParent.getChildren().splice(indexn, 0, node);
							curParent.getData()["Storys"].splice(indexn, 0, node.getData());
						}
						node._setParent(curParent);
						var indexs = $(">."+cls["node"]+" >."+cls["index"], ui.item);
						var ilength = indexs.length;
						var plength = $(">."+cls["node"]+" >."+cls["index"], curParent.getDom()).length;
						if(ilength > plength + 1){
							var n = 0;
							indexs.each(function(i){
								if(this.className != cls["index"]) return;
								if(i < ilength - plength - 1) n++;
							});
							$("."+cls["node"], ui.item).each(function(){
								$(">."+cls["index"], this).each(function(i){
									if(i < n) $(this).remove();
								});
							});
						}
						else $("."+cls["node"], ui.item).each(function(){
							for(var i = 0; i < plength + 1 - ilength; i++){
								$(this).prepend("<span class='"+cls["index"]+"'>&nbsp;</span>");
							}
						});
						// 父节点界面元素样式更改
						if(parent != root){
							if(parent.getChildren().length < 1)
								$(parent.getDom()).removeClass(cls["folder"]).addClass(cls["page"]);
							if(isMultiselect()) packCheck(parent);
						}
						if(isMultiselect()) packCheck(curParent);
						
						$tree.NodeAfterDrag(node, parent, index);
					},revert:true});
				}
			}
			li.appendTo(ul);
		}
		if(!$(pdom).hasClass(cls["folder"]))
			$(pdom).removeClass(cls["page"]).addClass(cls["folder"]);
		
		li.each(function(){
			node["dom"] = this;
			this.node = node;
		});
		var tips = data["Tips"];
		if(!tips) tips = "";
		var span = $("<span class='"+cls["node"]+"' title='"+tips+"'>"+data["Text"]+model["AppendHtml"]+"</span>").appendTo(li).dblclick(function(){
			if($tree.NodeOnDblclick) $tree.NodeOnDblclick(node);
		}).click(click).mouseover(hover);
		
		var leave = $(">."+cls["node"]+" >."+cls["index"], pdom).length;

		if(model["Multiselect"] == true){
			leave -= 1;
			$("<span class='"+cls["index"]+" "+cls["check"]+"'>&nbsp;</span>").prependTo(span).click(function(e){
				if($(this).hasClass(cls["checked"])){
					$tree.uncheck(node);
				}
				else{
					$tree.check(node);
				}
				AsLink.stopEvent(e);
			}).each(function(){
				if(data["Check"]==beChecked) $(this).addClass(cls["checked"]);
				else if(data["Check"]==beHalfChecked) $(this).addClass(cls["halfchecked"]);
			});
		}
		
		if(model["Icon"]==true){
			leave--;
			var icon = data["Icon"];
			if(!icon) icon = cls["deficon"];
			$("<span class='"+cls["index"]+" "+icon+"'>&nbsp;</span>").prependTo(span);
		}
		
		$("<a href='javascript:void(0);' hidefocus style='outline:none;' class='"+cls["index"]+" "+cls["arrow"]+"'>&nbsp;</a>").prependTo(span).click(function(e){
			if(li.hasClass(cls["folder"])){
				toggle();
				AsLink.stopEvent(e);
				return false;
			}
		});
		
		for(var i = 0; i < leave; i++)
			$("<span class='"+cls["index"]+"'>&nbsp;</span>").prependTo(span);
		
		function click(){
			focus();
			if($tree.NodeOnClick && $tree.NodeOnClick(node) == false)
				return;
			if(clickNode){
				clickNode.getData()["Beclick"] = false;
				$("."+cls["node"], clickNode["dom"]).removeClass(cls["click"]);
			}
			span.addClass(cls["click"]);
			clickNode = node;
			clickNode.getData()["Beclick"] = true;
		}
		function hover(mouse){
			if(hoverNode) $(">."+cls["node"], hoverNode["dom"]).removeClass(cls["hover"]);
			li.parents("."+cls["tree"]+" li").removeClass(cls["collapse"]).find(">ul").css("display", "");
			span.addClass(cls["hover"]);
			hoverNode = node;
		}
		function focus(){
			hover();
			$(">a:first", span).focus();
		}
		function toggle(){
			if(li.hasClass(cls["collapse"])){
				expand();
			}else{
				collapse();
			}
		}
		function expand(){
			if(initChildren()){
				data["Expand"] = true;
				li.removeClass(cls["collapse"]).find(">ul").slideDown();
			}
		}
		function collapse(){
			$(">ul", li).slideUp(function(){
				li.addClass(cls["collapse"]);
				data["Expand"] = false;
			});
		}
		function getUp(){
			var up = null;
			li.prev().each(function(){
				up = this;
			});
			if(!up){
				var node = getNode(li.parent());
				if(node) up = node["dom"];
			}else{
				while($(up).hasClass(cls["folder"]) && !$(up).hasClass(cls["collapse"])){
					var dom = null;
					$(">ul >li:last", up).each(function(){
						dom = this;
					});
					if(!dom) break;
					up = dom;
				}
			}
			if(!up) return;
			return up.node;
		}
		function getDown(){
			var down = null;
			if(li.hasClass(cls["page"]) || li.hasClass(cls["collapse"])){
				var dom = li;
				do{
					$(dom).next().each(function(){
						down = this;
					});
					if(down) break;
					var parent = getNode($(dom).parent());
					if(!parent) break;
					dom = parent.getDom();
				}while(true);
			}else{
				$(">ul >li:first", li).each(function(){
					down = this;
				});
				if(!down){
					li.addClass(cls["collapse"]);
					down = getDown();
				}
			}
			if(!down) return;
			return down.node;
		}
		var hasInit = false;
		function initChildren(){
			if(hasInit) return true;
			for(var i = 0; i < node.getChildren().length; i++){
				_addNode(node.getChildren()[i]);
			}
			return hasInit = true;
		}
		li.each(function(){
			this.click = click;
			this.hover = hover;
			this.focus = focus;
			this.toggle = toggle;
			this.expand = expand;
			this.collapse = collapse;
			this.getUp = getUp;
			this.getDown = getDown;
			this._initChildren = initChildren;
		});
		return true;
	}
	function addChild(parent, data){
		if(!data || !parent) return;
		
		var node = new TreeNode(parent, data);
		parent.getData()["Storys"].push(data);
		parent.getChildren().push(node);
		nodes.push(node);
		// 整理新增节点
		initNode(node);
		// 生成界面元素
		node.getDom();
		packCheck(parent);
		return node;
	}
	function addBefore(next, data){
		if(!data || !next) return;
		var parent = next.getParent();
		var index1 = parent.getData()["Storys"].indexOf(next.getData());
		if(index1 < 0) return;
		var index2 = parent.getChildren().indexOf(next);
		if(index2 < 0) return;
		var index3 = nodes.indexOf(next);
		if(index3 < 0) return;
		
		var node = new TreeNode(next.getParent(), data);
		parent.getData()["Storys"].splice(index1, 0, data);
		parent.getChildren().splice(index2, 0, node);
		nodes.splice(index3, 0, node);
		// 整理新增节点
		initNode(node);
		// 生成界面元素
		node.getDom();
		packCheck(parent);
		return node;
	}
	function addAfter(prev, data){
		if(!data || !prev) return;
		var parent = prev.getParent();
		var index1 = parent.getData()["Storys"].indexOf(prev.getData());
		if(index1 < 0) return;
		var index2 = parent.getChildren().indexOf(prev);
		if(index2 < 0) return;
		var index3 = nodes.indexOf(prev);
		if(index3 < 0) return;
		
		var node = new TreeNode(prev.getParent(), data);
		parent.getData()["Storys"].splice(index1+1, 0, data);
		parent.getChildren().splice(index2+1, 0, node);
		nodes.splice(index3+1, 0, node);
		// 整理新增节点
		initNode(node);
		// 生成界面元素
		node.getDom();
		packCheck(parent);
		return node;
	}






	function TreeNode(parent, data){
		var node = this;
		var children = new Array();
		





		this.getChildren = function(){
			return children;
		};





		this.getData = null;




		this.getParent = null;
		if(!data){
			this.getData = function(){
				return parent;
			};
			this.getParent = function(){};
		}else{
			this.getData = function(){
				return data;
			};
			this.getParent = function(){
				return parent;
			};
			this._setParent = function(nParent){
				parent = nParent;
			};
		}






		this.getAttribute = function(sKey){
			if(typeof sKey != "string") return;
			var data = this.getData();
			if(!data) return;
			var sValue = data["Attributes"][sKey];
			if(sValue) return sValue;
			sKey = sKey.toUpperCase();
			for(var o in data["Attributes"]){
				if(sKey == o.toUpperCase()){
					return data["Attributes"][o];
				}
			}
		};
		




		this.click = function(){return run("click", arguments);};




		this.hover = function(){return run("hover", arguments);};




		this.focus = function(){return run("focus", arguments);};




		this.toggle = function(){return run("toggle", arguments);};




		this.expand = function(){return run("expand", arguments);};




		this.collapse = function(){return run("collapse", arguments);};





		this.getUp = function(){return run("getUp", arguments);};





		this.getDown = function(){return run("getDown", arguments);};




		this._initChildren = function(){return run("_initChildren", arguments);};





		this.getDom = function(){return getDom();};
		
		function run(event, args){
			var dom = getDom();
			if(!dom || typeof dom[event] != "function") return;
			return dom[event].apply(dom, args);
		}
		function getDom(){
			if(!node.dom) parent._initChildren();
			if(!node.dom) _addNode(node);
			return node.dom;
		};
	}
	function mustInitChildren(data){
		var datas = data["Storys"];
		for(var i = 0; i < datas.length; i++){
			if(datas[i]["Beclick"]==true) return true;
			if(isMultiselect() && data["check"] != beChecked && datas[i]["Check"] == beChecked) return true;
			if(mustInitChildren(datas[i])) return true;
		}
		return false;
	}
	function check(node, beinit){
		if(!isMultiselect() || !node || !node["dom"]) return;
		if(typeof $tree.NodeOnCheck == "function"){
			if($tree.NodeOnCheck(node, beinit) == false) return;
			function runCheck(node){
				for(var i = 0; i < node.getChildren().length; i++){
					if(node.getChildren()[i].getData()["Check"] == beChecked) continue;
					if($tree.NodeOnCheck(node.getChildren()[i], beinit) == false || runCheck(node.getChildren()[i]) == false)
						return false;
				}
			}
			if(runCheck(node) == false) return;
		}
		$("."+cls["check"], node["dom"]).addClass(cls["checked"]);
		setCheck(node.getData(), true);
		packCheck(node.getParent());
	}
	function uncheck(node){
		if(!isMultiselect() || !node || !node["dom"]) return;
		if(typeof $tree.NodeOnUncheck == "function"){
			if($tree.NodeOnUncheck(node) == false) return;
			function runUncheck(node){
				for(var i = 0; i < node.getChildren().length; i++){
					if(node.getChildren()[i].getData()["Check"] == beUnChecked) continue;
					if($tree.NodeOnUncheck(node.getChildren()[i]) == false || runUncheck(node.getChildren()[i]) == false)
						return false;
				}
			}
			if(runUncheck(node) == false) return;
		}
		
		$("."+cls["check"], node["dom"]).removeClass(cls["checked"]).removeClass(cls["halfchecked"]);
		setCheck(node.getData(), false);
		packCheck(node.getParent());
	}
	function setCheck(data, flag){
		if(!flag) data["Check"] = beUnChecked;
		else data["Check"] = beChecked;
		for(var i = 0; i < data["Storys"].length; i++)
			setCheck(data["Storys"][i], flag);
	}
	function packCheck(node){
		if(!isMultiselect() || !node || node == getRoot() || !node["dom"] || !node.getData()) return;
		var check = $(">."+cls["node"]+" >."+cls["check"], node["dom"]);
		if(!node.getData()["Storys"] || node.getData()["Storys"].length < 1){
			if(check.hasClass(cls["checked"])) return;
			if(!check.hasClass(cls["halfchecked"])) return;
			check.removeClass(cls["halfchecked"]);
			node.getData()["Check"] = beUnChecked;
			return;
		}
		
		var n1 = 0, n2 = 0, n3 = 0;
		for(var i = 0; i < node.getData()["Storys"].length; i++){
			if(node.getData()["Storys"][i]["Check"] == beChecked) n3 += 1;
			else if(node.getData()["Storys"][i]["Check"] == beHalfChecked) n2 += 1;
			else n1 += 1;
		}
		//alert(n1 + " " + n2 + " " + n3);
		if(n1 == 0 && n2 == 0){
			if(check.hasClass(cls["checked"])) return;
			check.addClass(cls["checked"]);
			node.getData()["Check"] = beChecked;
		}else if(n3 > 0 || n2 > 0){
			if(!check.hasClass(cls["checked"]) && check.hasClass(cls["halfchecked"])) return;
			check.removeClass(cls["checked"]).addClass(cls["halfchecked"]);
			node.getData()["Check"] = beHalfChecked;
		}else{
			if(!check.hasClass(cls["checked"]) && !check.hasClass(cls["halfchecked"])) return;
			check.removeClass(cls["checked"]).removeClass(cls["halfchecked"]);
			node.getData()["Check"] = beUnChecked;
		}
		packCheck(node.getParent());
	}
	
	var $search = null;
	var $input = null;
	var $btn = null;
	var searchFun = null;
	function showSearch(fun, attrKey){
		if(typeof fun != "function") return;
		searchFun = fun;
		if($search){
			if($search.is(":hidden")){
				$search.show();
				$input.focus();
				return
			}else{
				$search.hide();
				return
			}
		}
		
		var p = $tree.position();
		$search = $("<div class='"+cls["search"]+"'></div>").appendTo($tree.parent()).css({
			"left" : p.left + 20,
			"top" : p.top + 20
		});
		$("<div class='"+cls["search_title"]+"'>查询"+(!model["Name"]?"":"["+model["Name"]+"]")+"</div>").appendTo($search).mousedown(function(e){
			var x = e.clientX;
			var y = e.clientY;
			$(document).bind("mousemove", move).bind("mouseup", up);
			
			var p = $search.position();
			function move(e){
				$search.css({
					"left" : p.left + e.clientX - x,
					"top" : p.top + e.clientY - y
				});
			}
			function up(){
				$(document).unbind("mousemove", move).unbind("mouseup", up);
			}
		});
		var $table = $("<table width='100%'></table>").appendTo($search);
		$input = $("<input style='width:100%;' />").appendTo($("<td></td>").appendTo($("<tr></tr>").appendTo($table))).keydown(function(e){
			AsLink.stopEvent(e);
			if(e.keyCode==13) search(this);
		});
		var sNodes = null;	
		var index = 0;
		var text = null;
		$("<button>重置</button>").click(function(){
			reset();
		}).insertAfter($("<button>取消</button>").insertAfter($btn = $("<button>确定</button>").insertAfter($("<span style='margin-right:5px;'></span>").insertAfter($("<input style='width:40px;display:none;text-align:right;' />").appendTo($("<td align='center' nowrap></td>").appendTo($("<tr></tr>").appendTo($table))).keydown(function(e){
			AsLink.stopEvent(e);
			if(e.keyCode==13) search(this);
		}))).click(function(){
			search(this);
		})).click(function(){
			reset();
			$search.hide();
		}));
		$input.focus();
		function search(obj){
			if(text != $input.val()){
				reset(true);
				sNodes = searchNodes(text = $input.val(), attrKey);
				$btn.prev().text("/"+sNodes.length);
			}
			if(!sNodes || sNodes.length < 1) return;
			$btn.prev().prev().show().each(function(){
				var index0 = parseInt($(this).val(), 10);
				if(isNaN(index0) || index0 == index) index += 1;
				else if(index0 < 1) index = 1;
				else if(index0 > sNodes.length) index = sNodes.length;
				else index = index0;
				if(index > sNodes.length) index = 1;
				$(this).val(index);
			});
			var node = sNodes[index-1];
			if(nodes.indexOf(node) < 0){
				var tmp = text;
				reset();
				$input.val(tmp);
				return search(obj);
			}
			searchFun(sNodes[index-1]);
			$(obj).focus();
		}
		function reset(flag){
			if(!flag){
				$input.val("");
				text = "";
			}
			index = 0;
			$btn.prev().text("").prev().val("").hide();
			sNodes = null;
		}
	}
	function searchNodes(text, attrKey){
		var getValue;
		if(!attrKey){
			getValue = function(node){
				return node.getData()["Text"];
			};
		}else{
			getValue = function(node){
				return node.getAttribute(attrKey);
			};
		}
		
		if(!text) text = "";
		text = text.split(" ");
		var _nodes = new Array();
		for(var i = 0; i < nodes.length; i++){
			var n = 0;
			var value = ""+getValue(nodes[i]); // 保证为string
			for(var j = 0; j < text.length; j++){
				if(value.indexOf(text[j]) > -1)
					n++;
			}
			if(n == text.length) _nodes.push(nodes[i]);
		}
		return _nodes;
	}
	function getNode(obj){
		var dom = null;
		$(obj).each(function(){
			dom = this;
		});
		if(!dom) return;
		if($(dom).hasClass(cls["tree"]) || $(dom).is("li:has(."+cls["node"]+")")){
			return dom.node;
		}
		return getNode($(dom).parent());
	}
	function init(){
		if(!Array.indexOf) Array.prototype.indexOf = function(e, i){
			if(isNaN(i)) i = 0;
			if(i < 0) return this.indexOf(e, i+this.length);
			for(; i < this.length; i++){
				if(this[i] == e) return i;
			}
			return -1;
		};
		return initNode(root);
	}
	function initNode(parent){
		function initN(parent, expands){
			if(parent.getData()["Storys"].length==0){
				return parent.getData()["Check"];
			}
			var n1 = 0, n2 = 0;
			for(var i = 0; i < parent.getData()["Storys"].length; i++){
				var data = parent.getData()["Storys"][i];
				var node = new TreeNode(parent, data);
				parent.getChildren().push(node);
				nodes.push(node);
				if(data["Expand"]==true) expands.push(node);
				if(data["Beclick"]==true) clickNode = node;
				if(parent.getData()["Check"]==beChecked) data["Check"] = beChecked;
				var flag = initN(node, expands);
				if(flag==beChecked) n1++;
				else if(flag==beHalfChecked) n2++;
			}
			if(n1==parent.getData()["Storys"].length) parent.getData()["Check"] = beChecked;
			else if(!(n1 == 0 && n2 == 0)) parent.getData()["Check"] = beHalfChecked;
			return parent.getData()["Check"];
		}
		
		var expands = new Array();
		initN(parent, expands);
		return expands;
	}
	function getClick(){
		return clickNode;
	}
	function getHover(){
		return hoverNode;
	}
	function tt(){
		alert($search);
		alert($input);
		alert($btn);
		alert(searchFun);
		alert(expands);
	}
	
	return this;
};







function ObjectTree(id, model){
	var $tree = null;
	$("#"+id).each(function(){
		$tree = $(this);
		return false;
	});
	if(!$tree) return;
	
	var tree = this;
	$tree.objectTree(model);
	
	/* 暴露出去的方法 */







	this.NodeOnClick = null;







	this.NodeOnDblclick = null;







	this.NodeOnCheck = null;







	this.NodeOnUncheck = null;
	/* FIXME 暂时未引入jquery-ui.js或jquery.ui.draggable.js，不能使用拖拽
	 * 
	 * 节点拖拽后触发的事件，若有赋具体的方法对象，那么可以拖拽，否则树图不能拖拽
	 * 在调用ObjectTree.draw绘制之前定义
	 * @text 暴露出去的方法
	 * @param TreeNode 拖拽的节点
	 * @param TreeNode oldParent拖拽前的父节点
	 * @param oldIndex 拖拽前所在父节点的位置
	 * @belong ObjectTree
	 */
	this.NodeAfterDrag = null;
	// ==获取==





	this.getNode = $tree.getNode;





	this.getClick = $tree.getClick;





	this.getHover = $tree.getHover;





	this.getRoot = $tree.getRoot;





	this.isMultiselect = $tree.isMultiselect;






	this.getChecked = $tree.getChecked;
	// ==新增==






	this.addChild = $tree.addChild; 






	this.addBefore = $tree.addBefore; 






	this.addAfter = $tree.addAfter;
	// ==删除==





	this.removeNode = $tree.removeNode;
	// ==勾选==





	this.check = $tree.check; 





	this.uncheck = $tree.uncheck; 
	// ==查询==





	this.showSearch = $tree.showSearch; 
	// ==绘制==




	this.draw = function(){
		if(typeof tree.NodeOnClick == "function") $tree.NodeOnClick = tree.NodeOnClick;
		if(typeof tree.NodeOnDblclick == "function") $tree.NodeOnDblclick = tree.NodeOnDblclick;
		if(typeof tree.NodeOnCheck == "function") $tree.NodeOnCheck = tree.NodeOnCheck;
		if(typeof tree.NodeOnUncheck == "function") $tree.NodeOnUncheck = tree.NodeOnUncheck;
		if(typeof tree.NodeAfterDrag == "function") $tree.NodeAfterDrag = tree.NodeAfterDrag;
		$tree.draw();
	};
}