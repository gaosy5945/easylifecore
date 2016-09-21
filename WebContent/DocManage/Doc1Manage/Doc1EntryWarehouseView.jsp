<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String sAISerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AISerialNo"));
	if(null==sAISerialNo) sAISerialNo="";
	String [] sAISerialNoList = sAISerialNo.split("@");
	String sButtons[][] = {
			//{"true","All","Button","打印","打印","printList()","","","",""},
			{"true","All","Button","打印设置","打印设置","WebBrowser1.ExecWB(8,1)","","","",""},
			{"true","All","Button","打印预览","打印预览","WebBrowser1.ExecWB(7,1)","","","",""},
			{"true","All","Button","打印","打印","WebBrowser1.ExecWB(6,1)","","","",""},
			{"true","All","Button","关闭","关闭","WebBrowser1.ExecWB(45,1)","","","",""},
		};
/* 	<div id=div1 style="display:block" >
	<input type=button value='打印设置' onclick="WebBrowser1.ExecWB(8,1)">
	<input type=button value='打印预览' onclick="WebBrowser1.ExecWB(7,1)">
	<input type=button value='打印' onclick="WebBrowser1.ExecWB(6,1)">
	<input type=button value='关闭' onclick="WebBrowser1.ExecWB(45,1)">
	</div>
 */
	//sButtonPosition = "north";
%>
<object ID='WebBrowser1' WIDTH=0 HEIGHT=0 border=1  style="display:none" CLASSID='CLSID:8856F961-340A-11D0-A96B-00C04FD705A2' > </object>
	
<tr height="1"><td><%@ include file="/Frame/resources/include/ui/include_buttonset_dw.jspf"%></td></tr>
<div >
<div width="100%"  height="2" align="left">&nbsp;&nbsp;&nbsp;&nbsp;</div>
<%
 for(int i=0;i<sAISerialNoList.length;i++){
	 String sAISerialNo1 = sAISerialNoList[i];
	 String sAssetTxt = "押品:" + (i+1);
%>	
<div width="100%"  align="left">&nbsp;&nbsp;&nbsp;&nbsp;<%=sAssetTxt %></div>
<iframe id="info<%=(i+1)%>"  width="100%"   frameborder="0" src='' onload="this.height=this.contentWindow.document.documentElement.scrollHeight">
</iframe>
<div height="1"  width="100%"   ></div>
<script type="text/javascript">
	document.getElementById("info<%=(i+1)%>").src = "<%=sWebRootPath%>"+"/DocManage/Doc1Manage/Doc1EntryWarehouseInfo.jsp?AISerialNo="+"<%=sAISerialNoList[i] %>"+"&AssetTxt="+"<%=sAssetTxt %>"+"&CompClientID="+"<%=sCompClientID %>";
</script>
<%
 }
%>
</div>
<%@ include file="/IncludeEnd.jsp"%>