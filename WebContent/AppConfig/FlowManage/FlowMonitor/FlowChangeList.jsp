<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%
	/*
		Describe: ��ת��¼�б�
		Input Param:
			ObjectNo��  	����ҵ�������
			ObjectType:	���̶�������
	 */
	//��ò���	
  	String sObjectNo =  CurPage.getParameter("ObjectNo");
	String sObjectType =  CurPage.getParameter("ObjectType");
  	String sFlowStatus =  CurPage.getParameter("FlowStatus");
	if(sFlowStatus == null) sFlowStatus = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";

	ASObjectModel doTemp = new ASObjectModel("FlowChangeList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(sObjectNo+","+sObjectType);
	
	String sButtons[][] = {
		{"true","","Button","���̵���","���̵���","FlowAdjust()","","","",""}
	};

	if(sFlowStatus.equals("02")){
		sButtons[0][0] = "false";
	}
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	setDialogTitle("��ת��¼");
	function FlowAdjust(){
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sObjectNo   = getItemValue(0,getRow(),"ObjectNo");
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sPhaseName = getItemValue(0,getRow(),"PhaseName");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ����Ҫ�������Ľ׶Σ�");//��ѡ��һ����Ϣ��
		}else{
			var sCurPhaseName = RunMethod("WorkFlowEngine","GetMaxPhaseName",sSerialNo);
			if(sPhaseName == sCurPhaseName){
				alert("����������"+sPhaseName+"��������ѡ��");
			}else{
				if(confirm("��ȷ��Ҫ�����̵�����"+sPhaseName+"��?")){
					sReturn = RunMethod("WorkFlowEngine","ChangeFlowPhase",sSerialNo+","+sObjectNo+","+sObjectType);
					if(typeof(sReturn) != "undefined" && sReturn == "success"){
						alert("���̵����ɹ���");
					}else{
						alert("���̵���ʧ�ܣ�");
					}
					reloadSelf();
				}
			}
		}
	}
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>