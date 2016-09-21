<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<html onkeydown="operateExeBtn(event)">
<head> 
<title>自定义查询</title>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量 
	
	//获得组件参数	
	
	//获得页面参数
	
	%>
<%/*~END~*/%>

<script language=javascript>
	function operateExeBtn(event){
		if(event.keyCode == "116")
		{
			document.getElementById("exebtn").style.display = "none";
			document.getElementById("pw").innerHTML = "下载文件全路径：<input name='downLoadFilePath' type='text' style='width:250px' value=''/><input name='dlbn' type='button' value='下载' onclick='downLoad()'/>";
		}
		else if(event.keyCode == "118")
		{
			document.getElementById("exebtn").style.display = "";
			document.getElementById("pw").innerHTML = "授权码<input name='password' type=password style='width:250px' value=''/>";
		}
		else if(event.keyCode == "117" || event.keyCode == "119")
		{
			document.getElementById("exebtn").style.display = "none";
			document.getElementById("pw").innerHTML = "";
		}	
	}
	function downLoad()
	{
		var filePath = document.getElementById("downLoadFilePath").value;
		if(filePath == "")
		{
			alert("请输入下载文件的全路径！！！");
			return;
		}
		window.open("<%=sWebRootPath%>/SystemManage/DemoManage/DownFileByFullPath.jsp?URLName="+filePath+"&RootPath=<%=sWebRootPath%>");
	}
	var time_seconds = 0;
	function startTimeKeeping()
	{
		setTimeout("time_seconds_add()",1000);
	}
	function time_seconds_add()
	{
		time_seconds++;
		if(time_seconds == 600)
		{
			self.close();
		}
		startTimeKeeping();
	}
	//获取选择的数据源
	function getDataSource()
	{
		var radioArr = document.all("DataSource");
		var dataSource = "LOAN";
		for(var i=0;i<radioArr.length;i++)
		{
			var checkFlag = document.all("DataSource")[i].checked;
			if(checkFlag)
			{
				dataSource = document.all("DataSource")[i].value;
				break;
			}
		}
		return dataSource;
	}
	//查询1
	function SELECTInfo1()
	{
		var sSqlContent = document.all("content").value;
		sSqlContent=real2Amarsoft(sSqlContent);
		document.all("SqlContent").value = sSqlContent;
		//document.all("DS").value = getDataSource();
		document.getElementById("form1").action = "<%=sWebRootPath%>/SystemManage/DemoManage/OverSqlList.jsp?CompClientID=<%=CurComp.getClientID()%>";
		document.getElementById("form1").submit();
	}
	
	//查询2
	function SELECTInfo2()
	{
		var sSqlContent = document.all("content").value;
		sSqlContent=real2Amarsoft(sSqlContent);
		document.all("SqlContent").value = sSqlContent;
		//document.all("DS").value = getDataSource();
		document.getElementById("form1").action = "<%=sWebRootPath%>/SystemManage/DemoManage/OverSqlList2.jsp?CompClientID=<%=CurComp.getClientID()%>";
		document.getElementById("form1").submit();
	}
	
	//新增、修改、删除
	function EXECUTEInfo()
	{
		var sSqlContent = document.all("content").value;
		sSqlContent=real2Amarsoft(sSqlContent);
		var sAuthPass = document.all("password").value;
		document.all("SqlContent").value = sSqlContent;
		document.all("AuthPass").value = sAuthPass;
		//document.all("DS").value = getDataSource();
		if(sAuthPass == "")
		{
			alert("执行sql必须输入授权码！");
			return;
		}
		document.getElementById("form1").action = "<%=sWebRootPath%>/SystemManage/DemoManage/OverExSql.jsp?CompClientID=<%=CurComp.getClientID()%>";
		document.getElementById("form1").submit();
	}
	
</script>
</head>
<body bgcolor="#DCDCDC" onload = "javascript:startTimeKeeping()">
<form method="post" name="form1" action="" target="SQLDetailFrame">
	 	<table align="top" width="100%" height="100%" border='0' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
			<tr>
				<td valign="top" height="10">
					Sql编辑【非开发人员请勿使用】
					<!-- <input type="radio" name="DataSource" checked="checked" value="LOAN"/>LOAN
					<input type="radio" name="DataSource" value="RPT"/>RPT -->
				</td>
			</tr> 
			<tr>
				<td align="left" bgcolor="#DCDCDC"  valign="top" colspan=3 onkeydown="javascript:time_seconds=0;">
					<textarea name="content" style='width:100%;height:260px' value=""></textarea>
					<input type=hidden name="SqlContent" value="" >
					<input type=hidden name="AuthPass" value="" >
					<input type=hidden name="DS" value="" >
				</td>
			</tr>	
			<tr>
				<td id="pw" align="left" bgcolor="#DCDCDC" valign="top"></td>
				<td align="center" height="10" valign="top">
					<input type="button" value="SELECT COMMON" onclick="SELECTInfo1()">
					<input type="button" value="SELECT SPECIAL" onclick="SELECTInfo2()">
				</td>
				<td align="left" height="10" valign="top">
					<input id="exebtn" type="button" value="EXECUTE" style="display: none" onclick="EXECUTEInfo()">
				</td>	
			</tr>
		 	<tr>
				<td align="center" width=100% height="100%"  valign="top" colspan=3>
					<div class="groupboxmaxcontent">
						<iframe name="SQLDetailFrame" src="<%=sWebRootPath%>/Blank.jsp?TextToShow=未录入数据" width=100% height=100% frameborder=0></iframe>
					</div>
				</td>	
			</tr>
		</table>
</form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>