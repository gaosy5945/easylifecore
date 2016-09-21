<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.base.util.SystemHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	///* ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("CLGroupLimitList",BusinessObject.createBusinessObject());
	//ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List(doTemp, CurPage, request); */
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List("CLGroupLimitList", SystemHelper.getPageComponentParameters(CurPage), CurPage, request);
	ASDataObject doTemp=dwTemp.getDataObject();
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(100);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增","新增","add()","","","","",""},
			{"true","","Button","详情","详情","edit()","","","","",""},
			{"true","","Button","删除","删除","del()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		AsControl.PopView("/CreditManage/CreditLimit/CLGroupLimitInfo.jsp",'','_self','');
		reloadSelf();
	}
	function edit(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(serialNo) == "undefined" || serialNo.length == 0){
		    alert(getHtmlMessage('1'));//请选择一条信息！
		    return;
		}
		AsControl.PopView("/CreditManage/CreditLimit/CLGroupLimitInfo.jsp",'SerialNo='+serialNo ,'dialogWidth=800px;dialogHeight=400px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;','');
	}
	function saveRecord(){
		setItemValue(0,getRow(0),"UpdateUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(0),"UPDATEORGID","<%=CurUser.getOrgID()%>");
		setItemValue(0,getRow(0),"UpdateDATE","<%=com.amarsoft.app.base.util.DateHelper.getBusinessDate()%>");
		as_save("reloadSelf()");
	}
	function SelectAllOrg(){
		//AsCredit.setMultipleTreeValue("SelectAllOrg", "", "","","0",getRow(0),"OrgID","OrgName");
		AsCredit.setTreeValue("SelectAllOrg", "", "","0",getRow(0),"OrgID","OrgName","FolderSelectFlag=Y");
	}
	function SelectBusinessType(){
		AsCredit.setMultipleTreeValue("SelectAllBusinessType", "", "", "","0",getRow(0),"PARAMETERID1","PARAMETERVALUE1");
	}
	function del(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(serialNo) == "undefined" || serialNo.length == 0){
		    alert(getHtmlMessage('1'));//请选择一条信息！
		    return;
		}
		if(confirm('确实要删除吗?'))as_delete("myiframe0");
	} 
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
