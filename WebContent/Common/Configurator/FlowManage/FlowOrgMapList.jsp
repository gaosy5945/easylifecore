<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String flowOrgMapType = CurPage.getParameter("FlowOrgMapType");
	if(flowOrgMapType == null || flowOrgMapType == "undefined") flowOrgMapType = "";
	ASObjectModel doTemp = new ASObjectModel("FlowOrgMapList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(flowOrgMapType);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","add()","","","","",""},
			{"true","","Button","����","����","edit()","","","","",""},
			{"true","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0)","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		AsControl.PopView("/Common/Configurator/FlowManage/FlowOrgMapInfo.jsp","FlowOrgMapType=<%=flowOrgMapType%>","_self");
		reloadSelf();
	}
	function edit(){
		 var serialNo = getItemValue(0,getRow(0),'SerialNo');
		 if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
		 }
		 AsControl.PopView("/Common/Configurator/FlowManage/FlowOrgMapInfo.jsp","SerialNo="+serialNo,"_self");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
