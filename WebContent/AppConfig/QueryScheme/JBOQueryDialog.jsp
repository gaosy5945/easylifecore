<%@page import="com.amarsoft.app.awe.config.query.GenerateQuerySql"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf"%>
<body>
<head>
<title>JBOQL查询语句</title>
<style>
.tdr{text-align: right; width:80px; padding:1px;vertical-align: middle;}
.tdl{text-align: left; padding:5px;vertical-align: middle;}
.input{text-align: left; width:150px; padding:2px;vertical-align: middle;}

table.mdftbl{margin:0;border-collapse:collapse;width:90%; }
table.mdftbl td{font-size:12px;border:1px solid #bebebe; padding:4px; color:#222222}
tr.alce{ text-align:center; background:#dcdcdc}
tr.alce b{ font-size:14px; color:#435868}
table.mdftbl a{color:red; float:right}
</style>
</head>
	<div style="margin-top: 6px;" align="left">
		<table>
			<tr valign=top>
                <td>
                	<span>
					主对象：&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="text" id="MajorObjClass" value="" style="cursor: pointer;width: 250px;" ondblclick="selectMajorObjClass(this)">
					<input type="hidden" id="Parameters" value="" />
					&nbsp;&nbsp;
					<input type="checkbox" checked id="rowLimitCheckbox">
					限制行数<input type="text" id="rowLimit" value="100" style="width: 50px;text-align: right;">
					</span>
					<%=new Button("查询","查询","doQuery()").getHtmlText()%>
					<%=new Button("导出Excel","导出Excel","exportPage()").getHtmlText()%>
                </td>
			</tr>
			<tr valign="top">
				<td>
				查询语句： 
				<textarea cols="110" rows="6" id="queryString" onchange="getParamList();" style="overflow: auto;">1=1</textarea>
				</td>
			</tr>
		</table>
	</div>
	<div>
		<table>
			<tr id="paramContainer" style="display: block;"></tr>
		</table>
	</div>
	<div id="resultDiv" style="overflow: auto;width: 100%;height: 400px;"></div>
	<form name=formexport method=post action="<%=request.getContextPath()%>/servlet/view/stream?CompClientID=<%=sCompClientID%>" target=iframehide >
		<div style="display:none">
			<input name=stream value="">
			<input name=viewtype value=save>
			<input name=contenttype value="text/html">
			<input name=encodingfrom value="GBK">
			<input name=encodingto value="GBK">
			<input name=filename value="">
		</div>
	</form>
	<iframe name="iframehide" src="<%=com.amarsoft.awe.util.Escape.getBlankHtml(sWebRootPath)%>" style="display:none" width=0 height=0 frameborder=0></iframe>
</body>
<script type="text/javascript">
	var checkFlag = true;
	var paramArray = new Array();
	
	$(document).ready(function(){
		$("#resultDiv").hide(); //初始化时隐藏结果区
		getParamList();
	});
	function SelectBizObjectClass(){
		return AsControl.PopView("/AppConfig/QueryScheme/SelectBizObjectClass.jsp", "", "");
	}
	function selectMajorObjClass(ObjName){
		var sReturn = SelectBizObjectClass();
		if(typeof(sReturn)!="undefined" && sReturn != "_CLEAR"){
			$(ObjName).val(sReturn.split("@")[0]);
		}else if(sReturn == "_CLEAR"){
			$(ObjName).val("");
		}
	}
	function exportPage(){
		var sContent = $("#resultDiv").html();
		formexport.filename.value = $("#MajorObjClass").val() + "<%="-"+StringFunction.replace(StringFunction.getTodayNow(),"/","")+".xls" %>";
		formexport.stream.value=sContent;
		formexport.submit();
	}
	function doQuery(){
		$("#resultDiv").hide();
		var rowLimitChecked = $("#rowLimitCheckbox").is(":checked").toString();
		var rowLimit = $("#rowLimit").val();
		
		//查询前，先将隐藏域Parameters的值置为空
		$("#Parameters").val("");
		
		//取输入框内的主对象、查询语句
		var majorObjClass = $("#MajorObjClass").val();
		var queryString = $("#queryString").val();
		if(!majorObjClass){
			$("#MajorObjClass").focus();
			return;
		}
		if(iV_all()){
			//用正则表达式替换掉回车换行符
			queryString = queryString.replace(/\r/ig,"").replace(/\n/ig,"");
			var parametersValue = $("#Parameters").val();
			var paraString = "MajorObjClass="+majorObjClass+"&JBOQL="+queryString+"&Parameters="+parametersValue+"&RowLimitChecked="+rowLimitChecked+"&RowLimit="+rowLimit;
			$.ajax({
				type: "GET",
				url: '<%=sWebRootPath%>/AppConfig/QueryScheme/QueryResultAjax.jsp?CompClientID=<%=CurComp.getClientID()%>&'+paraString,
				async: true,
				success: function(msg){
					$('#resultDiv').html(msg); //填充结果区resultDiv
					$("#resultDiv").show();  //展示结果区
			    }
			});
		}
	}
	
	function checkRequired(paramid,messageid){
		var value = $("#"+paramid).val();
	    if(typeof(value) == "undefined" || value.length == 0){
	    	$("#"+messageid).show();
	    	$("#"+messageid).html("请输入参数"+paramid+"！");
			checkFlag = false;
		}else{
			$("#"+messageid).hide();
			$("#"+messageid).html("");
			
			//有输入值，则保存回隐藏域Parameters
			var parametersValue = $("#Parameters").val() + "," +paramid+"@"+value;
			$("#Parameters").val(parametersValue);
			checkFlag = true;
		}
	    return checkFlag;
	}
	
	function iV_all(){
		var checkFlag = true;
		for(var i=0;i<paramArray.length;i++){
			var sParameter = paramArray[i];
			var sReturn = checkRequired(sParameter,'msg'+sParameter);
			checkFlag = checkFlag && sReturn;
		}
		return checkFlag;

	}
	/*~[Describe=获取参数列表;InputParam=无;OutPutParam=无;]~*/
	function getParamList(){
		paramArray = []; //获取前先清空
		var majorObjClass = $("#MajorObjClass").val();
		var queryString = $("#queryString").val();
		if(majorObjClass.length == 0  || queryString.length == 0) return;
		queryString = queryString.replace(/\r/ig,"").replace(/\n/ig,"");
		$.ajax({
			type: "POST",
			url: '<%=sWebRootPath%>/AppConfig/QueryScheme/LoadParameterAjax.jsp?CompClientID=<%=CurComp.getClientID()%>&MajorObjClass='+majorObjClass+'&JBOQL='+queryString,
			async: true,
			success: function(msg){
				var list = $.parseJSON(msg);
				if(list.length > 0) $('#paramContainer').html("<font style='font-size: 9pt;'>参数赋值：</font>");
				else $('#paramContainer').html("");
				$('#paramContainer').nextAll('.no').remove();//清空
				for(var j=list.length-1;j>=0;j--){
					var obj = list[j];
					var sParameter = obj.Parameter;
					paramArray[j] = sParameter;  //将参数放入全局数组
					//填充paramContainer
					$('#paramContainer').after(addItem(sParameter));
				}
		    }
		});
	}
	
	function addItem(sParameter){
		var item = "<tr class=\"no\"><td class=\"tdr\">"+sParameter+" &nbsp;<font color=\"red\">*</font></td>"+
				"<td class=\"tdl\"><input class=\"input\" type=\"text\" id=\""+sParameter+"\" onblur=\"javascript:checkRequired('"+sParameter+"','msg"+sParameter+"')\"/>"+
				"<label id=\"msg"+sParameter+"\" style=\"color:red\"></label></td></tr>";
		return item;
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>