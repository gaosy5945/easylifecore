<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<!-- 
	��ҳ������һ��ҵ�����Ϲ����е� ������ģ�����ز���
	    1.��ҳ����ʾ����TABҳ������� �� �����
	    2.�ڴ����Tabҳ���б���ʾ����״̬Ϊ"�����"��ҵ����Ϣ
	    	> ����ҳ��������ťʱ�����ſ�ɹ���һ��ҵ�����ϵ���Ϣ������״̬���Ϊ "�����"
	       
	    3.�������Tabҳ���б�����ʾ2��������ҵ��������Ϣ

 -->
<%	
	String sEntryType = CurComp.getParameter("EntryType");
	if(sEntryType==null) sEntryType ="";
	String sWhereSql = "";
	ASObjectModel doTemp = new ASObjectModel("Doc1EntryWarehouseList");
 	//ҵ������״̬ ��STATUS 01�������   02���ѷ�������  03�������   yjhou  2015.02.26
	if("0010".equals(sEntryType)){//�����
		 sWhereSql =  " and O.STATUS='02'"+
		              " and exists (select OB.belongorgid from jbo.sys.ORG_BELONG OB where OB.orgid = '"+CurOrg.getOrgID()+"' and OB.belongorgid = O.manageorgid)"+
				 	  " and O.INPUTUSERID='"+CurUser.getUserID()+"'";
		 doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql);	
	}else if("0030".equals(sEntryType)){//�����
		sWhereSql =  " and O.STATUS='03' and O.INPUTUSERID='"+CurUser.getUserID()+"'";
		doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql);	
	}
 	//modify by liuzq 20150320
	else if("0040".equals(sEntryType)){//�ѳ���
		sWhereSql =  " and O.STATUS='04' and O.INPUTUSERID='"+CurUser.getUserID()+"'";
		doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql);	
	}
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.MultiSelect = true; //�����ѡ
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(15);
	if(sEntryType=="0030" || "0030".equals(sEntryType)){//�����
		dwTemp.MultiSelect = false; //�����ѡ
	}
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"false","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{"false","All","Button","ȡ��","ɾ��","deleteRecord()","","","","btn_icon_delete",""},
			{"false","","Button","�嵥��ӡ","�嵥��ӡ","printList()","","","","btn_icon_detail",""},
			{"false","All","Button","�ύ","���","entryWarehouse()","","","","btn_icon_detail",""},
			{"false","All","Button","����","����","OutOfWarehouse()","","","","btn_icon_detail",""},//modify by liuzq 20150320
			{"false","All","Button","Ӱ��ɨ��","Ӱ��ɨ��","imageScanning()","","","","btn_icon_detail",""},
		};
	
	if(sEntryType=="0010" || "0010".equals(sEntryType)){//�����
		sButtons[0][0] = "true";
		sButtons[2][0] = "true";
		sButtons[3][0] = "true";
		sButtons[4][0] = "true";
		//sButtons[6][0] = "true";
	}else	if(sEntryType=="0030" || "0030".equals(sEntryType)){//�����
		sButtons[5][0] = "true";//modify by liuzq 20150320
	}
	
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	//�����ѵ�Ѻ�������ѺƷ��Ϣ
	function add(){
		 var sUrl = "/DocManage/Doc1Manage/Doc1EntryWarehouseRelativeList.jsp";
		 var dialogStyle = "dialogWidth=700px;dialogHeight=800px;";
		 AsControl.PopComp(sUrl,' ',''); 
		  reloadSelf();
	}
	//�鿴ѺƷ����
	function edit(){//����ѺƷ����
		/*  var arr = new Array();
		 arr = getCheckedRows(0);
		 if(arr.length < 1){
			 alert("��û�й�ѡ�κ��У�");
			 return;
		 }else if(arr.length > 1){
			 alert("��ѡ��һ�����ݣ�");
			 return;
		 }else{ */
			var serialNo=getItemValue(0,getRow(),"OBJECTNO");	
			var assetType=getItemValue(0,getRow(),"AssetType");	
			var templateNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.CollateralTemplate", "getTemplate", "ItemNo="+assetType);
			templateNo = templateNo.split("@");
			if(templateNo[0]=="false"){
				alert("δ����"+returnValue[1]+"��ģ�壡");
				return;
			}
			var assetSerialNo=getItemValue(0,getRow(),"AssetSerialNo");
			<%-- AsControl.PopComp("/CreditManage/CreditApply/GuarantyCollateralInfo.jsp", "SerialNo="+serialNo+"&AssetSerialNo="+assetSerialNo+"&VouchType=<%=vouchType%>&TemplateNo="+templateNo[1], ""); --%>
			AsCredit.openFunction("CollateralRegisterHandle", "SerialNo="+serialNo+"&AssetSerialNo="+assetSerialNo+"&TemplateNo="+templateNo[1]+"&Mode=1&DocFlag=DocType");
		 //}
	}
	//ȡ���������ѵ�Ѻ�������ѺƷ��Ϣ
	function deleteRecord(){
		var arr = new Array();
		 arr = getCheckedRows(0);
		 if(arr.length < 1){
			 alert("��û�й�ѡ�κ��У�");
		 }else{ 
			if(confirm('ȷʵҪɾ����?')){
						//ִ��ɾ��������ɾ��doc_file_package���ж�Ӧ��������Ϣ
						 for(var i=0;i<arr.length;i++){
							 //��ȡҪɾ���Ķ����ţ���doc_file_package���е�ObjectNo
							 var sDFPSerialNo = getItemValue(0,arr[i],'OBJECTNO');
							 if(sDFPSerialNo == null) sDFPSerialNo = "";
								var sSql = "delete doc_file_package dfp where dfp.objectno='"+sDFPSerialNo+"'";
								var sReturnValue =  RunMethod("PublicMethod","RunSql",sSql);
						 }
						as_delete(0);
						if(sReturnValue > -1){ 
							sMsg = "ɾ���ɹ���";
						}else {
							sMsg = "ɾ��ʧ�ܣ�";
						}
			}
		}
		 reloadSelf();//ִ����ɺ����¼��ص�ǰҳ��
	}
	
	//�嵥��ӡ
	function printList(){
		 var arr = new Array();
		 arr = getCheckedRows(0);
		 if(arr.length < 1){
			 alert("��û�й�ѡ�κ��У�");
			 return;
		 }else if(arr.length > 1){
			 alert("��ѡ��һ�����ݣ�");
			 return;
		 }else{
			 var sAissetSerialNo = getItemValue(0,getRow(),"ASSETSERIALNO");
			 var sContractSerialNo = getItemValue(0,getRow(),"CONTRACTSERIALNO");
			 if(typeof(sAissetSerialNo)=="undefined" || sAissetSerialNo.length==0 ){
					alert("��ѡ��һ�����ݣ�");
					return ;
			 }
			 var sUrl = "/DocManage/Doc2Manage/Doc2BPManage/Doc1MaterialList.jsp";
			 AsControl.PopComp(sUrl,"SerialNo="+sAissetSerialNo+"&ContractSerialNo="+sContractSerialNo,"");
	     }
	} 
	
	//������
	function entryWarehouse(){
		 var sAISerialNoList = "";
		 var arr = new Array();
		 arr = getCheckedRows(0);
		 if(arr.length < 1){
			 alert("��û�й�ѡ�κ��У�");
		 }else{
			if(confirm('�Ƿ�ȷ����� ?')){ 
				 for(var i=0;i<arr.length;i++){
					 var sAISerialNo =  getItemValue(0,arr[i],'ASSETSERIALNO') ;
					 var sObjectNo =  getItemValue(0,arr[i],'OBJECTNO');//��ȡ�����ţ�������ͬ������ˮ��
					 var sObjectType =  "jbo.guaranty.GUARANTY_RELATIVE"; 
					 //sAISerialNoList += sAISerialNo + "@";
					 var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.docmanage.action.Doc1EntryWarehouseAdd", "EntryWarehouseAdd", "AISerialNo="+sAISerialNo+",ObjectType="+sObjectType+",ObjectNo="+sObjectNo+",UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>,DataDate=<%=StringFunction.getToday()%>");
				 }
				 
					 <%-- var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.docmanage.action.Doc1EntryWarehouseAdd", "EntryWarehouseAdd",  "AISerialNoList="+sAISerialNoList+",ObjectType="+sObjectType+",ObjectNo="+sObjectNo+",UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>,DataDate=<%=StringFunction.getToday()%>"); --%>
				 if(sReturn == "true"){
						 alert("���ɹ���");
				 }else {
						 alert("���ʧ��!");
					     return;
			    }  
			 }
		}
		 reloadSelf();
	}
	
	//modify by liuzq 20150320 
	function OutOfWarehouse(){
		var sDfpSerialNo = getItemValue(0, getRow(), "SERIALNO");
		var sAISerialNo = getItemValue(0,getRow(0),"ASSETSERIALNO");
		if(typeof(sDfpSerialNo)=="undefined" || sDfpSerialNo.length==0 ){
				alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
				return ;
		}
		<%-- var sPara = "DFPSerialNo="+sDfpSerialNo+",DOSerialNo="+sDOSerialNo+",OutType=01,TransCode=0020,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>";
		var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.docmanage.action.DocOutManageAction", "doOutWarehouse", sPara);
		if(typeof(returnValue) != "undefined" && returnValue.length != 0 && returnValue != '_CANCEL_'){
			sDOSerialNo = returnValue;
		 	AsControl.PopComp("/DocManage/Doc1Manage/Doc1OutOfWarehouseView.jsp","DOSerialNo="+sDOSerialNo+"&AISerialNo="+sAISerialNo+"&ApplyType=0010&RightType=All","");
			reloadSelf();
		} --%>
		//modify by lzq 20150331 һ��ҵ�����ϳ���
		var sNextDOSerialNo =  getItemValue(0, getRow(), "PACKAGEID");//��һ��DOSerialNo
		//var sDOSerialNo =  getSerialNo("DOC_OPeration","SerialNo","");
		var sPara = "RightType=All";
		sPara = "&DOSerialNo="+sNextDOSerialNo+"&AISerialNo="+sAISerialNo+"&ApplyType=0010&DFPSerialNo="+sDfpSerialNo;
	 	AsControl.PopComp("/DocManage/Doc1Manage/Doc1OutOfWarehouseView.jsp",sPara,"");
		reloadSelf();
	}
	//Ӱ��ɨ��
	function imageScanning(){
		var CONTRACTSERIALNO = getItemValue(0,getRow(),"CONTRACTSERIALNO");
		if(typeof(CONTRACTSERIALNO)=="undefined" || CONTRACTSERIALNO.length==0 ){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		
		AsCredit.openFunction("ImageDoc1Info","ContractSerialNo="+CONTRACTSERIALNO);
		reloadSelf();
	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
