<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@page import="com.amarsoft.app.base.util.SystemHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	///* ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("CLGroupLimitList",BusinessObject.createBusinessObject());
	//ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List(doTemp, CurPage, request); */
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List("CLGroupLimitList", SystemHelper.getPageComponentParameters(CurPage), CurPage, request);
	ASDataObject doTemp=dwTemp.getDataObject();
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(100);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","add()","","","","",""},
			{"true","","Button","����","����","edit()","","","","",""},
			{"true","","Button","ɾ��","ɾ��","del()","","","","",""},
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
		    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
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
		    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		    return;
		}
		if(confirm('ȷʵҪɾ����?'))as_delete("myiframe0");
	} 
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
