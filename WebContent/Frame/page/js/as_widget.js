


var Layout = {
		_map : {},






		getRegionName : function(areaName){
			if(this._map[areaName]) return this._map[areaName];
			if(self != parent){
				return parent.Layout.getRegionName(areaName);
			}
			return areaName;
		},








		initRegionName : function(areaName, upTarget, defaultRegionName){
			if(defaultRegionName) return this._map[areaName] = defaultRegionName;
			if(typeof(upTarget)=="undefined" || upTarget=="_self")  return this._map[areaName] = areaName + "_self";
			else 	return this._map[areaName] = areaName + "_"+upTarget;
		}
};




var AsLink = {






		setShortcut : function(key, fun){
			if(!key || typeof fun != "function") return;
			var keys = key.split("+");
			var shift = false, ctrl = false, alt = false, code = null;
			for(var i = 0; i < keys.length; i++){
				if(keys[i]=="Shift")
					shift = true;
				else if(keys[i]=="Ctrl")
					ctrl = true;
				else if(keys[i]=="Alt")
					alt = true;
				else{
					if(!code){
						code = this.getKeyCode(keys[i]);
						if(!code) return; // 不存在的快捷键
						else break; // 只一个快捷字母
					}
				}
			}
			//alert(shift + " " + ctrl + " " + alt + " " + code);
			$(document).bind("keydown", function(e){
				if(!shift && !ctrl && !alt && !code) return;
				if(shift && !e.shiftKey) return;
				if(!shift && e.shiftKey) return;
				if(ctrl && !e.ctrlKey) return;
				if(!ctrl && e.ctrlKey) return;
				if(alt && !e.altKey) return;
				if(!alt && e.altKey) return;
				if(code && e.keyCode != code) return;
				fun();
				return false;
			});
		},
		/*
		 * 允许的快捷键对应编码，JSON对象
		 */
		keyCode : {
			// 字母
			A:65, B:66, C:67, D:68, E:69, F:70, G:71,
			H:72, I:73, J:74, K:75, L:76, M:77, N:78,
			O:79, P:80, Q:81,       R:82, S:83, T:84,
			U:85, V:86, W:87,       X:88, Y:89, Z:90,
			// 数字
			7:55, 8:56, 9:57,
			4:52, 5:53, 6:54,
			1:49, 2:50, 3:51,
			0:48,
			// 帮助键
			F1:112, F2 :113, F3 :114, F4 :115,
			F5:116, F6 :117, F7 :118, F8 :119,
			F9:120, F10:121, F11:122, F12:123,
			// 上下左右
			        UP:38,
			LEFT:37,      RIGHT:39,
			       DOWN:40,
			// 特殊键
			BACKSPACE:8,  DEL:46,
			ENTER:13, DELETE:46
		},






		getKeyCode : function(char){
			return this.keyCode[char.toUpperCase()];
		},





		stopEvent : function(e){
			if(!e) return;
			if(e.stopPropagation)
				e.stopPropagation();
			else e.cancelBubble=true;
		},
		moveBoxOnDown : function(e, box){
			var x0 = e.clientX;
			var y0 = e.clientY;
			var position = $(box).position();
			$(document).bind("mousemove", move).bind("mouseup", up);
			function move(e){
				$(box).css({
					"top" : position.top + e.clientY - y0,
					"left" : position.left + e.clientX - x0
				});
			}
			function up(e){
				$(document).unbind("mousemove", move).unbind("mouseup", up);
			}
		},
		opacityBoxOnOver : function(box){
			$(box).removeClass("list_search_nohover").mouseleave(function(){
				$(box).addClass("list_search_nohover");
			});
		}
};

var AsButton = {
		unable : function(sIdOrText){
			if(!sIdOrText || typeof sIdOrText != "string") return;
			var btn = this.getBtn(sIdOrText);
			if(!btn) return;
			$(btn).addClass("unable");
		},
		able : function(sIdOrText){
			if(!sIdOrText || typeof sIdOrText != "string") return;
			var btn = this.getBtn(sIdOrText);
			if(!btn) return;
			$(btn).removeClass("unable");
		},
		getBtn : function(sIdOrText){
			if(/^B[0-9]{1,}$/.test(sIdOrText)){
				return document.getElementById(sIdOrText);
			}else {
				var buttons = $("a.inline_button");
				for(var i = 0; i < buttons.length; i++){
					if($(".btn_text", buttons[i]).text() != sIdOrText) continue;
					return buttons[i];
				}
			}
			return null;
		},
		run : function(btn, fun, e){
			//if(top.inaction == true) return;
			//top.inaction = true;
			btn = $(btn);
			if(btn.hasClass('unable')) return;
			btn.addClass('unable');
			fun();
			btn.removeClass('unable');
			AsLink.stopEvent(e);
			//top.inaction = false;
		}
};




var AsForm = {
		/*
		 * 定义行内样式
		 */
		CSS : {
			FlatSelect : {"position":"absolute","border":"solid #aaa","border-width":"0 1px 1px","overflow-y":"auto","background":"#fff","padding-bottom":"2px"},
			FlatSelectA : {"display":"block","width":"100%","height":"20px","line-height":"20px","white-space":"nowrap","overflow-x":"hidden","border-bottom":"1px dotted #ccc","font-size":"12px","text-decoration":"none"},
			FlatSelectHoverA : {"background-color":"#316ac5","color":"#fff"},
			FlatSelectLeaveA : {"background-color":"","color":"#333"}
		},









		FlatSelect : function(input, data, maxheight, changeFun, doc){
			if(!data) data = {};
			if(!doc) doc = document;
			var select = $(input, doc);
			if(!select.is("input")) return;
			
			var flatSelect = select.data("FlatSelect"); // 获取数据缓存
			var input, slide;
			if(!flatSelect){
				input = select.clone().val("").removeAttr("id").removeAttr("name").attr("onchange", "").bind("change", search).insertBefore(select).show();
				slide = $("<div></div>", doc).appendTo($("body", doc)).css(AsForm.CSS.FlatSelect).hide();
				select.hide();
				// 填充数据缓存，包括显示text表单、下拉面板、设置真实值方法
				select.data("FlatSelect", {"input":input,"slide":slide,"setValue":set});
			}else{
				input = flatSelect["input"].unbind(".FlatSelect");
				slide = flatSelect["slide"].unbind(".FlatSelect").empty();
			}
			var change = select.attr("onchange");
			
			for(var o in data){
				appendA(o);
			}
			var curA = null;
			var flag = false;
			slide.bind("mousedown.FlatSelect", function(){
				flag = true;
			});
			input.bind("focus.FlatSelect", focus).bind("blur.FlatSelect", function(){
				if(select.prop("readonly")) return;
				if(flag) return;
				var val = input.val();
				if(!val){
					set();
					return;
				}
				setVal(val);
			}).bind("keydown.FlatSelect", function(e){
				if(select.prop("readonly")) return;
				if(slide.is("hidden")) return;
				if(e.keyCode==40){ // 按箭头下
					nextA();
					return;
				}
				if(e.keyCode==38){ // 按箭头上
					prevA();
					return;
				}
				if(e.keyCode==13){ // 回车
					$(curA).click();
					return;
				}
				if(e.keyCode==27) return false; // ESC防止文本内容回退
			}).bind("keyup.FlatSelect", function(e){
				if(e.keyCode==40||e.keyCode==38||e.keyCode==13||e.keyCode==27) return;
				focus();
			}).bind("dblclick.FlatSelect", function(){
				if(select.prop("readonly")) return;
				set();
				focus();
			});
			
			var val = select.val();
			if(!flatSelect) select.val("");
			set(val);
			
			function focus(){
				if(select.prop("readonly")) return;
				input.removeProp("readonly");
				
				var offset = input.offset();
				
				slide.css({
					"left" : offset.left,
					"top" : $("body", doc).scrollTop() + offset.top + input.height()+7,
					"width" : input.width()+7
				}).show();
				search();
				flag = false;
			}
			
			function search(){
				var val = input.val();
				var as = $("a", slide);
				var first = true;
				if(!val){
					as.show();
					setCurA(as[0]);
				}else as.each(function(){
					if($(this).text().indexOf(val) < 0) $(this).hide();
					else{
						$(this).show();
						if(first){
							setCurA(this);
							first = false;
						}
					}
				});
				slide.height("auto");
				if(!isNaN(maxheight) && slide.height() > maxheight) slide.height(maxheight);
			}
			
			function prevA(){
				var a = null;
				if(!curA){
					a = $("a:visible:last", slide)[0];
				}else{
					var temp = $(curA).prev();
					while(temp.length>0){
						if(temp.is(":visible")) break;
						temp = temp.prev();
					}
					a = temp[0];
				}
				if(!a) return;
				setCurA(a);
			}
			
			function nextA(){
				var a = null;
				if(!curA){
					a = $("a:visible:first", slide)[0];
				}else{
					var temp = $(curA).next();
					while(temp.length>0){
						if(temp.is(":visible")) break;
						temp = temp.next();
					}
					a = temp[0];
				}
				if(!a) return;
				setCurA(a);
			}
			
			function setCurA(a){
				$(curA).css(AsForm.CSS.FlatSelectLeaveA);
				curA = a;
				$(curA).css(AsForm.CSS.FlatSelectHoverA);
				if(curA && !isNaN(maxheight)){
					var top = $(curA).position().top;
					if(top+21 > maxheight) slide.scrollTop(slide.scrollTop()+top+21-maxheight);
					else if(top < 0) slide.scrollTop(slide.scrollTop()+top);
				}
			}
			
			function setVal(val){
				if(!val) return;
				for(var o in data){
					if(data[o]==val){
						set(o);
						return;
					}
				}
				set();
			}
			
			function set(key){
				if(!key) key = "";
				var val = data[key];
				if(!val){
					key = "";
					val = "";
				}
				var oldKey = select.val();
				select.val(key);
				input.val(val);
				slide.hide();
				//if(!window.div) window.div = $("<div style='position:absolute;left:20px;top:20px;'></div>").appendTo("body");
				//window.div.append("|"+oldKey+"|"+key+"|<br>");
				if(oldKey != key){
					if(typeof changeFun == "function") changeFun(key);
					if(change) eval(change.replace("this.value", "\""+key+"\""));
				}
			}
			
			function appendA(key){
				$("<a title=\""+data[key]+"\" ><span>&nbsp;&nbsp;"+data[key]+"</span></a>", doc).appendTo(slide).css(AsForm.CSS.FlatSelectA).css(AsForm.CSS.FlatSelectLeaveA).click(function(){
					set(key);
				}).mouseover(function(){
					setCurA(this);
				});
			}
		}
};






$.fn.wizard = function(model, defId){
	var wizard = this;
	var curItem = null;
	var curSpan = null;
	model.sort(function(item1, item2){
		if(item1["sort"] > item2["sort"]) return 1;
		if(item1["sort"] < item2["sort"]) return -1;
		return 0;
	});
	if(typeof defId != "string" && model.length > 0) defId = model[0]["id"];
	
	for(var i = 0; i < model.length; i++){
		append(model[i]);
	}
	function append(item){
		var span = $("<span class=\"wizard_dom_cell\" ><span class=\"wizard_dom_panel\">"+item["name"]+"</span><span class=\"wizard_dom_span wizard_dom_arrow\"></span></span>").appendTo(wizard).click(click);
		
		function click(){
			if(curSpan == span) return;
			if(typeof WizardCellOnClick == "function" && WizardCellOnClick(curItem, item) != true) return;
			if(curSpan){
				curSpan.removeClass("wizard_dom_select").prev().find(".wizard_dom_span").removeClass("wizard_dom_before_arrow");
				var parent = curSpan.parent();
				curSpan.prev().insertBefore(parent);
				curSpan.insertBefore(parent);
				parent.remove();
			}
			curSpan = span;
			curItem = item;
			$(curSpan).addClass("wizard_dom_select").prev().find(".wizard_dom_span").addClass("wizard_dom_before_arrow");
			$("<span></span>").insertAfter(curSpan).append(curSpan.prev()).append(curSpan);
		};
		if(item["id"] == defId) click();
	}
};