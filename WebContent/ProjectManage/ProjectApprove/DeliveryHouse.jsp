<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
/* 	ASObjectModel doTemp = new ASObjectModel("DeliveryHouse");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(""); */
	
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("DeliveryHouse",BusinessObject.createBusinessObject(),CurPage);
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List(doTemp, CurPage, request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "0";	 //ֻ��ģʽ
	dwTemp.setPageSize(100);
	dwTemp.setParameter("InputOrgID", CurUser.getOrgID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","add()","","","","",""},
			{"true","All","Button","����","����","saveRecord()","","","","",""},
			{"true","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0)","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		as_add("myiframe0");
		setItemValue(0,getRow(),"STATUS","1");
		setItemValue(0,getRow(),"INPUTUSERID","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(),"INPUTORGID","<%=CurUser.getOrgID()%>");
		setItemValue(0,getRow(),"INPUTDATE","<%=com.amarsoft.app.base.util.DateHelper.getBusinessDate()%>");
	}
	function saveRecord(){
		setItemValue(0,getRow(),"UpdateUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(),"UPDATEORGID","<%=CurUser.getOrgID()%>");
		setItemValue(0,getRow(),"UpdateDATE","<%=com.amarsoft.app.base.util.DateHelper.getBusinessDate()%>");
		as_save("myiframe0");
	}
	function SelectAllOrg(){
		AsCredit.setTreeValue("SelectLevelDownOrg", "CurOrgID,<%=CurUser.getOrgID()%>", "","0",getRow(0),"OrgID","OrgName","FolderSelectFlag=Y");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
