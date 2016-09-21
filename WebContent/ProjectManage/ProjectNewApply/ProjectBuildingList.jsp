<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String ProjectSerialNo = CurPage.getParameter("SerialNo");
	if(ProjectSerialNo == null) ProjectSerialNo = "";
	String ReadFlag = CurPage.getParameter("ReadFlag");
	if(ReadFlag == null) ReadFlag = "";
	String ProjectType = CurPage.getParameter("ProjectType");
	if(ProjectType == null) ProjectType = "";
	String CustomerID = CurPage.getParameter("CustomerID");
	if(CustomerID == null) CustomerID = "";
	
	BusinessObject inputParameter =BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("ProjectSerialNo", ProjectSerialNo);
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("BuildingList",inputParameter,CurPage);
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	
	dwTemp.setParameter("ProjectSerialNo", ProjectSerialNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{"true","All","Button","ɾ��","ɾ��","del()","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/ProjectManage/js/ProjectManage.js"></script>
<script type="text/javascript">
	function add(){	
		var ProjectSerialNo = "<%=ProjectSerialNo%>";
		var buildingSerialNo = getSerialNo("BUILDING_INFO","SerialNo","");
		AsControl.OpenView("/ProjectManage/ProjectNewApply/ProjectBuildingInfo.jsp","SerialNo=&ProjectSerialNo="+ProjectSerialNo+"&BuildingSerialNo="+buildingSerialNo+"&ProjectType=<%=ProjectType%>"+"&CustomerID=<%=CustomerID%>"+"&ReadFlag="+"<%=ReadFlag%>","_self");
		//reloadSelf();
	}
	
	function edit(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var ProjectSerialNo = "<%=ProjectSerialNo%>";
		var buildingSerialNo = getItemValue(0,getRow(),"BISerialNo");
		if (typeof(serialNo) == "undefined" || serialNo.length == 0){
		    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		    return;
		}
		AsControl.OpenView("/ProjectManage/ProjectNewApply/ProjectBuildingInfo.jsp","SerialNo="+serialNo+"&BuildingSerialNo="+buildingSerialNo+"&ProjectSerialNo="+ProjectSerialNo+"&ReadFlag="+"<%=ReadFlag%>","_self");
		//reloadSelf();
	}
	function del(){
		var BuildingSerialNo = getItemValue(0,getRow(0),"BISerialNo");
		if (typeof(BuildingSerialNo) == "undefined" || BuildingSerialNo.length == 0){
		    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		    return;
		}
		if(confirm('ȷʵҪɾ����¥����?')){
			var sReturn = ProjectManage.deleteProjectBuilding(BuildingSerialNo);
			if(sReturn == "SUCCEED"){
				alert("ɾ���ɹ���");
			}
			reloadSelf();
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
