<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%	
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	String listType = CurPage.getParameter("ListType");
	if(listType == null) listType = "";
	
	String sTempletNo = "CadReInfo";//--模板号--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	doTemp.setDefaultValue("LISTTYPE", listType);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	doTemp.setDefaultValue("INPUTUSERName", CurUser.getUserName());
	dwTemp.Style = "2";//freeform
	dwTemp.setParameter("SerialNo", serialNo);
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","保存","保存","as_save(0)","","","","",""},
			{"true","","Button","返回","返回","goBack()","","","","",""},
		};
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">

function initRow(){
	setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
	setItemValue(0,0,"BEGINDATE","<%=StringFunction.getToday()%>");
	setItemValue(0,0,"INPUTORGID","<%=CurOrg.getOrgID()%>");
	setItemValue(0,0,"INPUTDATE","<%=StringFunction.getToday()%>");
}
function goBack(){
	OpenPage("/CustomerManage/SpecialCustomerManage/CadReList.jsp","_self","");
}
initRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
