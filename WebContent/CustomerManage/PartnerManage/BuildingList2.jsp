<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	
	ASObjectModel doTemp = new ASObjectModel("BuildingList2");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	//dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(serialNo);
	
	String sButtons[][] = {
			{"true","ALL","Button","����","����","importBuilding()","","","","btn_icon_detail",""},
			{"true","ALL","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{"true","ALL","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0)","","","","btn_icon_delete",""},
		};
%> 
<script type="text/javascript">

	/*����¥��*/
	function importBuilding(){
		var returnValue = setObjectValue("selectAllBuilding","","",0,0);
		if(typeof(returnValue) == "undefined" || returnValue.length == 0){
			return;
		}
		returnValue = returnValue.split("@");
		//alert(returnValue);
		var param = "objectNo=<%=serialNo%>,accessoryNo=" + returnValue[0] +",accessoryType=Building,accessoryName="+returnValue[1];
		returnValue = RunJavaMethodTrans("com.amarsoft.app.als.customer.partner.action.BuildingRelativeAction","initRelative",param);
		if(returnValue == "true"){
			//alert("����ɹ�");
			reloadSelf();
		}else if(returnValue == "error"){
			alert("�����쳣");
		}else if(returnValue == "false"){
			alert("�Ѿ�����Ŀ�������¥����ȷ��");
			return;
		}
	}
	
	/*����*/
	function add(){
		 var sUrl = "/CustomerManage/PartnerManage/BuildingInfo.jsp?ProjectNo=<%=serialNo%>";
		 OpenPage(sUrl,'_self','');
	}
	function edit(){
		var serialNo = getItemValue(0,getRow(0),"SerialNo");
		if(typeof(serialNo) == "undefined" || serialNo.lentgh == 0){
			alert("��ѡ��һ����¼");
			return;
		}
		 var sUrl = "/CustomerManage/PartnerManage/BuildingInfo.jsp?ProjectNo=<%=serialNo%>&SerialNo=" + serialNo;
		 OpenPage(sUrl,'_self','');
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
