<html>
<head>
<style type="text/css">
.ConditonMapTR{
	background:url("Frame/page/resources/images/strip/tit-bg.gif") repeat-x bottom;
}
.ConditonMapSpan{
	cursor: pointer;width: 15px;height: 15px;
	display: inline-block;
	background: url("Frame/page/resources/images/strip/expand.gif") no-repeat center;
}
.ConditonMapSpan.collapse{
	background: url("Frame/page/resources/images/strip/collapse.gif") no-repeat center;
}
</style>
</head>
<body class=pagebackground leftmargin="0" topmargin="0" style="overflow-y:auto;overflow-x:hidden;" >
<div id="Layer1" style="position:absolute;width:99.9%; height:99.9%; z-index:1; overflow: auto">
<table align='center' width='100%'  cellspacing="0" cellpadding="0">
  <tr height=1 id="ButtonTR">
		<td id="ListButtonArea" class="ListButtonArea" valign=top>
			<%@ include file="/Frame/resources/include/ui/include_buttonset_dw.jspf"%>
	    </td>
  </tr>
  <tr height=5></tr>
<%for(int i=0;i<sStrips.length;i++){
	if(sStrips[i][0]==null || !sStrips[i][0].equals("true")) continue;
%>
  <tr> 
    <td> 
      <table cellspacing=0 cellpadding=0 width='100%'>
		<tr>
		<td>
		  <table border=0 cellpadding=0  cellspacing=0 style='cursor: pointer;' width='100%'>
			<tr id=ConditonMap<%=i%>Tab valign=center height='30' class="ConditonMapTR">
			  <td align=right valign='middle'>
			  	<span id="ConditonMap<%=i%>Tab3" onclick="showHideContent(this,'ConditonMap<%=i%>','<%=i%>');" class="ConditonMapSpan"></span> 
			  </td>
			  <td align=left width='85%' valign='middle' onclick="javascript:document.getElementById('ConditonMap<%=i%>Tab3').click();"> 
				<font color=#000000 id="ConditonMap<%=i%>Tab2"><%=sStrips[i][1]%></font>
			  </td>
			  <td align="right" valign="middle"> 
				<a href="javascript:refreshCompInStrip(<%=i%>)">&nbsp;&nbsp;刷新&nbsp;&nbsp;|</a>
			  	<a href="javascript:newCompInStrip(<%=i%>)">&nbsp;&nbsp;新窗口&nbsp;&nbsp;</a>
			  </td>
			</tr>
		  </table>
		</td>
	  	</tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td colspan="4"> 
      <div id="ConditonMap<%=i%>Content" style="width: 100%;display:none"> 
		<table class='conditionmap' align='left' cellspacing='0' style="border:1px solid #eee;width: 100%;">
		<tr>
			<td>
				<iframe name="StripFrame<%=i%>" scrolling="no" src="<%=com.amarsoft.awe.util.Escape.getBlankJsp(sWebRootPath,"正在打开页面，请稍候...")%>" width=100% height=<%=sStrips[i][2]%> frameborder=0></iframe>
			</td>
		</tr>
		</table>
      </div>
    </td>
  </tr>
<%}%>
</table>
</div>
</body>
</html>
<script type="text/javascript">
	var sStripsCondition =  new Array(<%=sStrips.length%>);
	function setSelectedStrip(iStrip){
		document.getElementById("ConditonMap"+iStrip+"Tab3").click();
	}

	function showHideContent(obj,id,iStrip){
		var bOn = false;
		var oTab    = document.getElementById(id+"Tab");
		var oTab2   = document.getElementById(id+"Tab2");
		var oImage   = document.getElementById(id+"Tab3");
		var oContent = document.getElementById(id+"Content");

		if (!oTab || !oTab2 || !oImage || !oContent) 	return;
		if (obj){
			bOn = (oContent.style.display.toLowerCase() == "none");
		}

		if (bOn == false){
			$(oContent).slideUp(function(){
				oImage.className = "ConditonMapSpan";
			});
		}else{
			openCompInStrip(iStrip);
			oImage.className = "ConditonMapSpan collapse";
			$(oContent).slideDown();
		}
	}
	
	function openCompInStrip(iStrip){
	<%	for(int i=0;i<sStrips.length;i++){	%>
			if(iStrip==<%=i%>){
				if(sStripsCondition[<%=i%>]!="opened"){
					AsControl.OpenView("<%=sStrips[i][4]%>","<%=sStrips[i][5]%>","StripFrame<%=i%>","");
					sStripsCondition[<%=i%>]="opened";
				}
				try{
					<%=sStrips[i][6]%>
				}catch(e){
					alert("执行代码出错！\n"+e);
				}
			}
	<%	}	%>
	}
	
	function refreshCompInStrip(iStrip){
	<%	for(int i=0;i<sStrips.length;i++){	%>
			if(iStrip==<%=i%>){
				AsControl.OpenView("<%=sStrips[i][4]%>","<%=sStrips[i][5]%>","StripFrame<%=i%>","");
			}
	<%	}	%>
	}
	
	function newCompInStrip(iStrip){
	<%	for(int i=0;i<sStrips.length;i++){	%>
			if(iStrip==<%=i%>){
				AsControl.OpenView("<%=sStrips[i][4]%>","<%=sStrips[i][5]%>","_blank","");
				refreshCompInStrip(iStrip);
			}
	<%	}	%>
	}
</script>