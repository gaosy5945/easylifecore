<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sTempletNo = "TransferSimpleInfo";//ģ���
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow("");
	dwTemp.replaceColumn("Customers","<iframe type='iframe' name=\"frame_list\" width=\"100%\" height=\"400\" frameborder=\"0\" src=\""+sWebRootPath+"/CustomerManage/TransferManage/TransferCustomerList.jsp?CompClientID="+sCompClientID+"&TransferType=10\"></iframe>", CurPage.getObjectWindowOutput());
	String sButtons[][] = {
			{"true","All","Button","ȷ��","���������޸�","doSure()","","","",""},
			{"true","All","Button","ȡ��","�����б�","top.close()","","","",""}
			};
	sButtonPosition = "south";
%>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">

	/*~[Describe=ȷ��;InputParam=��;OutPutParam=��;]~*/
	function doSure(){
		if(!iV_all("0")) return; 
		var userID = getItemValue(0,getRow(),"RECEIVEUSERID");
		if(userID=="<%=CurUser.getUserID()%>"){
			alert("�����û�����ѡ�Լ���");
			return;
		}
		var rightType = getItemValue(0,getRow(),"RightType");
		var maintainTime = getItemValue(0,getRow(),"MAINTAINTIME");
		if(rightType=="20"&& (typeof(maintainTime)=="undefine" || maintainTime.length==0)){
			alert("��ѡ��ά��Ȩ���ޣ�");
			return;
		}
		//��ȡ��ѡ�ͻ�
		var customers = window.frames["frame_list"].returnCustomers();
		if(typeof(customers)=="undefined" || customers.length==0){
			alert("������ѡ��һ���ͻ���¼��");
			return;
		}
		if(customers == "error") return;
		var orgID = getItemValue(0,getRow(),"RECEIVEORGID");
		var afrightFlag = getItemValue(0,getRow(),"AfrightFlag");
		var maintainTime = getItemValue(0,getRow(),"MAINTAINTIME");
		var param = "customerID="+customers+",userID=<%=CurUser.getUserID()%>,orgID=<%=CurUser.getOrgID()%>,receiveUserID="+userID
					+",receiveOrgID="+orgID+",rightType="+rightType+",afrightFlag="+afrightFlag+",manaTime="+maintainTime;
		var result = RunJavaMethodTrans("com.amarsoft.app.als.customer.transfer.action.TransferAction","saveTransferOut",param);
		if(result == "true"){
			alert("ת������ɹ���");
			self.close();
		}
	}

	/*~[Describe=ѡ���û���Ϣ;InputParam=��;OutPutParam=��;]~*/
	function selectUser(){
		var result = setObjectValue("SelectAllUser","","",0,0,"");
		if(typeof(result)=="undefined" || result.length==0) return;
		if(result == "_CLEAR_"){
			setItemValue(0,getRow(),"RECEIVEUSERID","");//�����û���
			setItemValue(0,getRow(),"UserName","");//�û�����
			setItemValue(0,getRow(),"RECEIVEORGID","");//���ջ�����
			setItemValue(0,getRow(),"OrgName","");//��������
		}else{
			var params = result.split("@");
			setItemValue(0,getRow(),"RECEIVEUSERID",params[0]);//�����û���
			setItemValue(0,getRow(),"UserName",params[1]);//�û�����
			setItemValue(0,getRow(),"RECEIVEORGID",params[2]);//���ջ�����
			setItemValue(0,getRow(),"OrgName",params[3]);//��������
		}
	}
	/*~[Describe=ת��Ȩ�ޱ��;InputParam=��;OutPutParam=��;]~*/
	function rightChange(){
		var rightType = getItemValue(0,getRow(),"RightType");
		if(rightType == "10"){//�ܻ�Ȩ
			//�ܻ�Ȩʱ,��ʾ'�Ƿ�ת��ҵ��ܻ�Ȩ'�ֶΣ�����ά��Ȩ�����ֶ�
			hideItem(0,"MAINTAINTIME");
			setItemValue(0,getRow(),"MAINTAINTIME","");
			setItemValue(0,getRow(),"AFRIGHTFLAG","2");
			hideItem(0,"AFRIGHTFLAG");
		}else if(rightType == "20"){//ά��Ȩ
			//ά��Ȩʱ,����'�Ƿ�ת��ҵ��ܻ�Ȩ'�ֶΣ���ʾά��Ȩ�����ֶ�
			hideItem(0,"AFRIGHTFLAG");
			setItemValue(0,getRow(),"AFRIGHTFLAG","");
			showItem(0,"MAINTAINTIME");
		}
	}
	rightChange();
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
