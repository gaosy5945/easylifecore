<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String sAISerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AISerialNo"));
	if(null==sAISerialNo) sAISerialNo="";
	String [] sAISerialNoList = sAISerialNo.split("@");
	String sButtons[][] = {
			//{"true","All","Button","��ӡ","��ӡ","printList()","","","",""},
			{"true","All","Button","��ӡ����","��ӡ����","WebBrowser1.ExecWB(8,1)","","","",""},
			{"true","All","Button","��ӡԤ��","��ӡԤ��","WebBrowser1.ExecWB(7,1)","","","",""},
			{"true","All","Button","��ӡ","��ӡ","WebBrowser1.ExecWB(6,1)","","","",""},
			{"true","All","Button","�ر�","�ر�","WebBrowser1.ExecWB(45,1)","","","",""},
		};
/* 	<div id=div1 style="display:block" >
	<input type=button value='��ӡ����' onclick="WebBrowser1.ExecWB(8,1)">
	<input type=button value='��ӡԤ��' onclick="WebBrowser1.ExecWB(7,1)">
	<input type=button value='��ӡ' onclick="WebBrowser1.ExecWB(6,1)">
	<input type=button value='�ر�' onclick="WebBrowser1.ExecWB(45,1)">
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
	 String sAssetTxt = "ѺƷ:" + (i+1);
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