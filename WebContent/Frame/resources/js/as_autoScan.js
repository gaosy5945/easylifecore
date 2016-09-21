





function autoRiskScan(scenarioID,bizArgs,subTypeNo){
	var sReturn = false;
	
	if(typeof(scenarioID) == "undefined" || scenarioID.length == 0){
		alert("风险探测，需要场景号，请传入场景号参数！");
		return sReturn;
	}
	if(typeof(bizArgs) == "undefined" || bizArgs.length == 0){
		alert("风险探测，需要业务数据，请传入业务数据参数！");
		return sReturn;
	}
	if(typeof(subTypeNo) == "undefined" || subTypeNo.length == 0){
		subTypeNo = "";
	}
	
	sceCompUrl="/AppConfig/AutoRiskDetect/ScenarioAlarm.jsp";
	sceCompArgs = "ScenarioNo="+scenarioID+"&SubTypeNo="+subTypeNo+"&BizArg="+encodeURI(bizArgs.replace(/&/gi,","));
	sceStyle = "dialogWidth=900px;dialogHeight=540px;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no";
	sReturn = PopPage(sceCompUrl+"?"+sceCompArgs,"",sceStyle);
	return sReturn;
}




(function($){
    $.fn.riskScan = function(options) {
        var defaults = {
       		modelInvoker:"./AlarmModelInvoker.jsp",
       		scenarioSerial:""
        };
        var options = $.extend(defaults, options);  //应用参数

        return this.each(function() {
        	//定义的功能函数
	    	$.fn.isComplete = function(){
        		for(var i=0;i<group.size();i++){
        			var done = group.eq(i).attr("done");
        			if(!done||done!="true")return false;
        		}
        		return true;
	    	};
        	$.fn.isPass = function(){
        		for(var i=0;i<group.size();i++){
        			var p = group.eq(i).attr("pass");
        			if(!p||p!="true")return false;
        		}
        		return true;
        	};
        	//全局变量
        	var context = $(this);
        	var modelItems = $(".ck_item",context);
        	var group = $(".r_group",context);
        	//初始化操作
        	context.data("complete","false");
        	init(context);
        	//生成执行函数队列
        	var funArray = new Array();
        	for(var i=0;i<modelItems.size();i++){
        		var modelItem = modelItems.eq(i);
        		funArray[i] = function(item){
        			var mItem = item;
        			return function(){
        				runModelItem(options,mItem,function(){
        					var scenarioMessage = $("#scenario-message");
        					var bComplete = context.isComplete(),bPass = context.isPass();
        					if(bComplete&&bPass){
        						scenarioMessage.addClass("scenario-message-pass");
        						scenarioMessage.html("最终结果：检查通过!");
        					}else if(bComplete&&!bPass){
        						scenarioMessage.addClass("scenario-message-nopass");
        					}
        					context.dequeue("scanAction");
        				});
        			};
        		}(modelItem);
        	}
        	context.queue("scanAction",funArray);
        	
        	context.dequeue("scanAction");	//开始出队
        });
    };
    function init(context){
    	var context= null;
    	var scenarioMessage = $("#scenario-message");
    	scenarioMessage.html("");
    	scenarioMessage.attr("idx",0);
    	scenarioMessage[0].Spaned=undefined;
    	$(".r_group",context).each(function(){
    		$(this)[0]["done"]=undefined;
    		$(this)[0]["pass"]=undefined;
    		$(this).removeClass();
    		$(this).addClass("r_group");
    	});
    	$(".ck_item",context).each(function(){
    		$(this)[0]["done"]=undefined;
    		$(this)[0]["pass"]=undefined;
    		$(this).removeClass();
    		$(this).addClass("ck_item default");
    	});
    }
    function appendNoPassSummary(groupID,groupName){
    	var scenarioMessage = $("#scenario-message");
    	var bSpan = scenarioMessage.attr("Spaned");
    	var idx = scenarioMessage.attr("idx");
    	if(!idx)idx=0;
    	idx = parseInt(idx);
   		var anchor = $("<span><a href='#Group"+groupID+"'>"+(++idx)+"."+groupName+"</a></span>");
    	if(!bSpan)scenarioMessage.append("<span>最终结果：未通过</span>");
    	scenarioMessage.append(anchor);
    	scenarioMessage.attr("idx",idx);
    	scenarioMessage.attr("Spaned","true");
    }
    function groupCheck(item){
    	var group = item.parents(".r_group");
    	var modelItems = $(".ck_item",group);//检查分组的子项是否运行完成
    	
    	var bGroupDone = true;
    	var bGroupPass = true;
   		for(var i=0;i<modelItems.size();i++){	//检查明细项是否完成
   			var done = modelItems.eq(i).attr("done");
   			if(!done||done!="true"){bGroupDone = false;break;}
   		}
   		if(bGroupDone){							//检查明细项是否通过
	   		for(var i=0;i<modelItems.size();i++){
	   			var p = modelItems.eq(i).attr("pass");
	   			if(!p||p!="true"){bGroupPass = false;break;}
	   		}
   		}
   		//更新标志
   		group.attr("done","false");
   		if(bGroupDone){
   			try{scrollTo(0,group.offset().top-200);}catch(e){};
   			group.attr("done","true");
   			var gResult = $(".group_result",group);
   			gResult.hide();
   			gResult.fadeIn(1000);
   			if(bGroupPass){
   				group.attr("pass","true");
   				gResult.addClass("r_green").text("通过");
   			}else{
   				group.attr("pass","false");
   				gResult.addClass("r_red").text("未通过");
   				appendNoPassSummary(group.attr("groupID"),group.attr("groupName"));
   			}
   		}
    }
	function runModelItem(options,item,callback){
		var context = item;
		var groupID = context.attr("groupID");
		var itemID = context.attr("itemID");
		var noPassDeal = context.attr("noPassDeal");	//10 禁止办理,20 提示
		$("td.message",context).html("运行中...");  
		var postData = new Array("GroupID="+groupID
				,"ItemID="+itemID
				,"SerializableScenario="+options.scenarioSerial
				);
		var errMsg = "检查项[GroupID="+groupID+",ItemID="+itemID+"]运行出错，请联系系统管理员！";
		$.ajax({
		   type: "POST",
		   cache: false,
		   async: true,
		   dataType:"json",
		   url: options.modelInvoker,
		   data: postData.join("&"),
		   success: function(msg){
				oReturn = msg;
				if(msg&&oReturn){
					var status = oReturn["status"];
					var message = oReturn["message"];
				   	//1.标识是否通过
				   	context.removeClass("default");
				   	if(status=="true"||status==true){
				   		context.addClass("pass");
				   		context.attr("pass","true");
				   	}else{
				   		if(noPassDeal=="20"){
				   			context.addClass("nopass_prompt");
				   			context.attr("pass","true");
				   		}else{
				   			context.addClass("nopass_forbid");
				   			context.attr("pass","false");
				   		}
				   		$("td.viewer span.label",context).show();
				   		$("td.viewer span.label a",context).unbind("click");
				   		$("td.viewer span.label a",context).click(function(){
				   			var tdContext = $(this).parents("td");
				   			var scriptText = $("span.script",tdContext).text();
				   			if(scriptText)eval(scriptText);
				   		});
				   	}
				   	context.attr("done","true");
				   	//2.输出消息
				   	$("td.message",context).html(formatMessage(message));
				   	//3.分组检查
				   	groupCheck(item);
				   	//4.调用回调方法
				   	if(callback&&$.isFunction(callback))callback.call();
				}else{
					alert(errMsg);
				}
				context = gc(context);
				options = gc(options);
				callback = gc(callback);
		   },
		   error:function(){
			 context = gc(context);
			 options = gc(options);
			 callback = gc(callback);
		     alert(errMsg);
		   }
		});
	};
	function gc(x){
		delete x;
		x = null;
		return x;
	}




	function formatMessage(str){
		var msg = str.split(/\[\~\`\~\]/g);
		var message = "";
		for(var i=0;i<msg.length&&msg.length != 1;i++){
			if(msg[i].length <= 0) continue;
			message += ((i+1)+"."+msg[i]+"<br/>");
		}
		if(msg.length == 1)message = msg[0];
		if(message.length == 0) message = "&nbsp;";
		return message;
	}
})(jQuery);