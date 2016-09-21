<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";

	String sTempletNo = "PTProjectBailInfo";//模板号
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(serialNo);
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","saveRecord()","","","",""},
	};
//	sButtonPosition = "south";
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">

	/**保存数据	 */
	function saveRecord(){
		as_save(0);
	}
	/**按是否需要缴纳保证金来判断是否需要录入账号信息*/
	function  selectFlag(){
		if(getItemValue(0,0,"BailFlag") == "1"){
			setItemRequired(0,"BailAccount",true);
			setItemRequired(0,"BailAccountOwner",true);
		}else{
			setItemRequired(0,"BailAccountOwner",false);
			setItemRequired(0,"BailAccount",false);
		}
	}
	//初始化账户是否必输
	selectFlag();
	AsControl.OpenView("/CustomerManage/PartnerManage/ProjectBailList.jsp","ProjectNo=<%=serialNo%>","rightdown","");
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>