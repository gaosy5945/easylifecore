<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
/*
	ҳ��˵��: ʾ�������������ҳ��
 */
%><%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">
	mytoptd.height=320;
	OpenList();
	
	function OpenList(){
		AsControl.OpenView("/AppConfig/BoardManage/BoardInfo.jsp","","rightup","");
	}
	
	function OpenInfo(sDocNo){
		AsControl.OpenView("/AppConfig/Document/AttachmentFrame.jsp", "DocNo="+sDocNo, "rightdown");
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>