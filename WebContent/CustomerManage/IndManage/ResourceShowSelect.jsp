<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "水电信息总览图形展现"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String sTextToShow=java.net.URLEncoder.encode("请选择上面的信息","UTF-8");
	//定义变量
	String sSql = "";
	ASResultSet rs =null;
	//获得组件参数：对象类型、对象编号
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	//将空值转化为空字符串
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";	
	
	String hValue1 ="",vValue1 ="",sAddValue1 = "",hValue2 ="",vValue2 ="",sAddValue2 = "",sResourceType = "";
	sSql = "select ResourceType,ConsumeAmount,AccountMonth from SME_CONSINFO "+
		" where ObjectType=:ObjectType and ObjectNo=:ObjectNo and ResourceType in('010','020') order by ResourceType,AccountMonth";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType",sObjectType).setParameter("ObjectNo",sObjectNo));
	while(rs.next()){
		sResourceType = rs.getString("ResourceType");
		if(sResourceType.equals("010")){	//水费
			hValue1 += rs.getString("AccountMonth")+"@";
			vValue1 += rs.getDouble("ConsumeAmount")+"@";
		}
		else if(sResourceType.equals("020")){//电费
			hValue2 += rs.getString("AccountMonth")+"@";
			vValue2 += rs.getDouble("ConsumeAmount")+"@";
		}
	}
	rs.getStatement().close();
%>
<HEAD>
	<title><%=PG_TITLE%></title>
</HEAD>
<body class="ReportPage" leftmargin="0" topmargin="0" onload="" style="overflow:auto" oncontextmenu="return true">
<form name="form0">
<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0" >
	<tr height="1%" valign=top id=mytop >
		<td>
			<table width="100%" >
			<tr>
				<td align=left>
						选取图形展现方式：
						<select name="GraphType">
							<option value=0 >柱状图</option>
							<option value=6 >折线图</option>
						</select>
				</td>
				<td align=left>
						展现内容：
					<select name="ResourceType">
						<%=HTMLControls.generateDropDownSelect(Sqlca," select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'ResourceType' and ItemNo in('010','020') and IsInUse = '1' order by SortNo ",1,2,"")%> 
				    </select>
				</td>
				<td align=left>
					<%=new Button("图形展现","图形展现","graphShow()","","").getHtmlText()%>
				</td>
				<td>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				</td>
			</tr>
			</table>
		</td>
	</tr>
	<tr id=mydown> 
	    <td> 
			<div id=divDrag title='展现信息' ondrag="dragFrame(event);"><span class="imgDrag" style="display:inline-block;">&nbsp;</span></div>
			<iframe name="rightdown" scrolling="no"  src="<%=sWebRootPath%>/Blank.jsp?TextToShow=<%=sTextToShow%>" width=100% height=100% frameborder=0></iframe> 
	    </td>
	</tr>
</table>
</form>
</body>
<script type="text/javascript">
	mytop.height=1;
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function dragFrame(event) {
		if(event.y>100 && event.y<800) { 
			mytop.height=event.y-10;
		}
		if(event.y<100) {
			window.event.returnValue = false;
		}
	}
    /*~[Describe=打开图形显示;InputParam=后续事件;OutPutParam=无;]~*/
    function graphShow(){
		sGraphType = form0.GraphType.value;
		sResourceType = form0.ResourceType.value;
		if(sResourceType=="010"){
			sItemName = "水费";
			sCaption = "吨";
			hValue = "<%=hValue1%>";
			vValue = "<%=vValue1%>";
		}else if(sResourceType=="020"){
			sItemName = "电费";
			sCaption = "千瓦时/度";
			hValue = "<%=hValue2%>";
			vValue = "<%=vValue2%>";
		}
		if (typeof(hValue)=="undefined" || hValue.length==0){
			alert("数据不完整，无法展现！");
			return;
		}
		hValue = hValue.substr(0,hValue.length-1);
		vValue = vValue.substr(0,vValue.length-1);
		sScreenWidth = screen.availWidth-40;
		sScreenHeight = screen.availHeight-120;
		//alert("sItemName:"+sItemName+"  hValue:"+hValue+"  vValue:"+vValue+"  sGraphType:"+sGraphType);
    	OpenPage("/CustomerManage/IndManage/ResourceGraph.jsp?GraphType="+sGraphType+"&ItemName="+sItemName+"&Caption="+sCaption+"&vValue="+vValue+"&hValue="+hValue+"&ScreenWidth="+sScreenWidth+"&ScreenHeight="+sScreenHeight+"&rand="+randomNumber(),"rightdown","");
    }
</script>
<%@	include file="/IncludeEnd.jsp"%>