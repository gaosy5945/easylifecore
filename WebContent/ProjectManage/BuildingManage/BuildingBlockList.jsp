<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String buildingSerialNo = CurPage.getParameter("BuildingSerialNo");
	if(buildingSerialNo == null) buildingSerialNo = "";
	String ReadFlag = CurPage.getParameter("ReadFlag");
	if(ReadFlag == null) ReadFlag = "";
	ASObjectModel doTemp = new ASObjectModel("BuildingBlockList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("BuildingSerialNo", buildingSerialNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"ReadOnly".equals(ReadFlag)?"flase":"true","All","Button","����","����","add()","","","","",""},
			{"true","","Button","����","����","edit()","","","","",""},
			{"ReadOnly".equals(ReadFlag)?"flase":"true","All","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0)","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		var buildingSerialNo = "<%=buildingSerialNo%>";
		AsControl.OpenView("/ProjectManage/BuildingManage/BuildingBlockInfo.jsp","SerialNo=&BuildingSerialNo="+buildingSerialNo,"_self","");
		reloadSelf();
	}
	function edit(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var buildingSerialNo = "<%=buildingSerialNo%>";
		if (typeof(serialNo) == "undefined" || serialNo.length == 0){
		    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		    return;
		}
		AsControl.OpenView("/ProjectManage/BuildingManage/BuildingBlockInfo.jsp","SerialNo="+serialNo+"&BuildingSerialNo="+buildingSerialNo,"_self","");
		reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
