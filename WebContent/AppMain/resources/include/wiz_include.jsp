<%@page import="com.amarsoft.app.als.sys.widget.Wizard"%>

<%@ page contentType="text/html; charset=GBK"%>
<html>
<head> 
<style type="text/css">
body{
 overflow: auto;
}

/* td {
padding-right: 4px;
} */
.wiz_normal{
font-style: normal; 
font-size:12px;
cursor: pointer;
}
a.wiz_normal{color:#17294e;}
a:hover.wiz_normal{
	text-decoration: none;
	color:#17294e;
}

.wiz_select{
font-size:14px;
font-weight:bold;
color:#000;
cursor: pointer;
}

.wizTitle{

 width: 100%;
	padding-top:10px;
	height: 5%;
	overflow: hidden;
	
	/* font: 20px red; */
}

.wizContent{
	height:90%;
	border:1px solid #9fb1c1;
	border-top:none;
	padding:10px;
	padding-top:0;
}
.wizButton{
	margin-top:5px;
	height:10px;
	text-align: right;
}

#title_decribe{
width:25%;
text-align:right;
font-size: 12px;
color: #172941;
}
.wiz_tr{
	background:#e3eef5;
	/*border:1px solid #9fb1c1;*/
}
#forwardStep{
	padding-left:10px;
	height:30px;
	
}
.wiz_tbl{
	border-collapse: collapse;
	border:1px solid #9fb1c1
}
.wiz_td{
padding-top: 2px;
padding-bottom: 3px;
border-bottom:1px solid #9fb1c1
}
</style>
</head>
<body>


 <%
  Button lastButton = new Button("上一步", "上一步", "openLastWiz()", "", "", "");
 Button nextButton = new Button("下一步", "下一步", "openNextWiz() ", "", "", "");
 Button finishButton = new Button("完成", "完成", "closeSelf() ", "", "", "");
out.print(wiz.getHtml());
 
 %>

 
		  <div id='wizButton' class='wizButton'>
	 <%=lastButton.getHtmlText() %>	 
	<!-- <input type="button" onclick="openLastWiz()" id="laststep" value=" 上一步 " title="上一步"> -->
	<span>
	<%@ include file="/Frame/resources/include/ui/include_buttonset_dw.jspf"%>
	 <%=nextButton.getHtmlText()%> 
	 </span>
	 <%=finishButton.getHtmlText()%> 
	<!-- <input type="button" onclick="openNextWiz()" id="nextstep" value=" 下一步 " title="下一步" >
	<input type="button" onclick="closeSelf()" id="close" value=" 完成 " title="完成" style="display: none"> -->
	&nbsp;&nbsp;&nbsp;&nbsp;
	
	</div>
	

<script type="text/javascript">
var curWizId="<%=wiz.getDefaulClickId()%>";
var clickFlag=false;
var currentItem;
function setDefaultButton(currentItem){
	if(currentItem.attr("lastid")== currentItem.attr("id")){//最后一步
		$("#<%=finishButton.getButtonID()%>").hide();
		$("#<%=nextButton.getButtonID()%>").show();
		$("#<%=lastButton.getButtonID()%>").hide();
	}else if(currentItem.attr("nextid")== currentItem.attr("id")){
		$("#<%=nextButton.getButtonID()%>").hide();
		$("#<%=lastButton.getButtonID()%>").show();
		$("#<%=finishButton.getButtonID()%>").show();
	}else{
		$("#<%=nextButton.getButtonID()%>").show();
		$("#<%=finishButton.getButtonID()%>").hide();
		$("#<%=lastButton.getButtonID()%>").show();
	}
}

function openMyWiz(id){
	
	if(curWizId==id && clickFlag) return ;
 	$(".wiz_select").each(function(){
 		$(this).removeClass("wiz_select");
 	});
 	clickFlag=true;
 	curWizId=id;
 	currentItem = $("#"+id);
 	currentItem.addClass("wiz_select");
 	//窗口缩小，空间不足，描述部分与前面的元素隔几个空格
 	 $("#title_decribe").html("&nbsp;&nbsp;&nbsp;"+currentItem.attr("describe") + "&nbsp;&nbsp;&nbsp;"); 

	url=currentItem.attr("url");
	param=currentItem.attr("param");
	if(window.beforeCheck){
		beforeCheck(curWizId);
	}	
	AsControl.OpenPage(url,param,"wizFrame");
	
	//控制第一步和最后一步的按钮显示
	setDefaultButton(currentItem);
	if(window.afterOpen){
		 window.afterOpen(currentItem);
	}
}



$(function(){
	openMyWiz(curWizId);
});
function getCurWizFrame(){
	return window.frames["wizFrame"];
	
}

function importGroup(){
	curFrame = getCurWizFrame();
	curFrame.importGroup();
}

function openNextWiz(){
	curFrame=getCurWizFrame();
	if(typeof(curFrame)!="undefined" && curFrame.saveRecord){
		curFrame.saveRecord();
	}
	if(typeof(curFrame)!="undefined" && curFrame.getSaveFlag){
			bsave=curFrame.getSaveFlag();
			if(!bsave) {
				alert("请先保存！");
				return ;
			}
	}
	nextid=$("#"+curWizId).attr("nextid");
	openMyWiz(nextid);
}

function openLastWiz(){
	nextid=$("#"+curWizId).attr("lastid");
	openMyWiz(nextid);
}

function closeSelf(){
	top.close();
}

</script>
</body>
</html>
