<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	//�������ͣ�1-���е绰���գ�2-���д��գ�3-�������
	String sCollType = CurPage.getParameter("CollType");
	if(sCollType=="null" || sCollType == null) sCollType = "";
	String sSerialNo = CurPage.getParameter("SerialNo");
	if(sSerialNo=="null" || sSerialNo == null) sSerialNo = "";
	String sOperateOrgId = CurPage.getParameter("OperateOrgId");
	if(sOperateOrgId=="null" || sOperateOrgId == null) sOperateOrgId = "";
	String sTempNo = "";
	String sWhereSql = "";
	if("3".equals(sCollType) || "3" == sCollType){
		sTempNo = "OutsourcingCollectionList";//������������б�ģ��
		sWhereSql = " and O.TASKBATCHNO='"+sSerialNo+"'  AND (O.Status <> '2' or O.status is null) ";
	}else{
		sTempNo = "ALCollTaskList";//���С����д��������б�ģ��
		sWhereSql = " AND O.OBJECTTYPE='jbo.app.BUSINESS_DUEBILL' and  (O.Status <> '5' or O.status is null) AND O.OBJECTNO=BD.SERIALNO and BD.OperateOrgId = '"+sOperateOrgId+"'";// " and O.SERIALNO = '"+sSerialNo+"'   AND (O.Status <> '2' or O.status is null) ";
	}
	String sRoleInfo []={"PLBS0014"};
	String sHaveRoleFlag="";
	if(CurUser.hasRole(sRoleInfo)){
		sHaveRoleFlag="yes";
	}else{
		sHaveRoleFlag="no";
	}
	BusinessObject inputParameter =BusinessObject.createBusinessObject();
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel(sTempNo,inputParameter,CurPage);
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	//ASObjectModel doTemp = new ASObjectModel("OutSourcCollMonitorList");
	//ASObjectModel doTemp = new ASObjectModel(sTempNo);
	doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql );
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","","Button","��������","��������","edit()","","","","btn_icon_detail",""},
			{"false","All","Button","�������","�������","collChangeAll()","","","","btn_icon_detail",""},
			{"false","All","Button","�ر�����","�ر�����","closeColl()","","","","btn_icon_delete",""},
			{"true","All","Button","���ݵ���","���ݵ���","dataOut()","","","","btn_icon_detail",""},
			{"false","All","Button","����߰�","����߰�","collDoAgain()","","","","btn_icon_detail",""},
			{"false","","Button","����","����","goBack()","","","","btn_icon_detail",""},
		};
	sButtons[0][5] = "edit"+sCollType+"()";
	//sButtons[1][5] = "collChange"+sCollType+"()";
%>
<div>
  <table align="center" id="s1" style="display:none">
	<tr>
		<td class="black9pt" align="left"><font size="2">��ѡ�񵼳��ļ�����:</font>
		</td>
	</tr>
	<tr>
		<td>
		<input type="button" style="width: 80px" name="txt" value="����txt"
			onclick="javascript:setChoose(1)">
		<input type="button" style="width: 80px" name="html" value="����html"
			onclick="javascript:setChoose(2)">
		<input type="button" style="width: 80px" name="excel" value="����excel"
			onclick="javascript:setChoose(3)">
		<input type="button" style="width: 80px" name="pdf" value="����pdf"
			onclick="javascript:setChoose(4)">
		<!-- <input type="button" style="width: 80px" name="word" value="����word" onclick="javascript:setChoose(5)"> -->
		</td>
	</tr>
</table>
 </div>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function setChoose(ChooseType) {
		var sReturn =  ChooseType;
		if(sReturn=="1"){
			//����Txt","����Txt","
			exportPage('<%=sWebRootPath%>',0,'txt','<%=dwTemp.getArgsValue()%>');	
		}else if(sReturn=="2"){
			//����Html","����Html","
			exportPage('<%=sWebRootPath%>',0,'html','<%=dwTemp.getArgsValue()%>');	
		}else if(sReturn=="3"){
			//����Excel","����Excel","
			exportPage('<%=sWebRootPath%>',0,'excel','<%=dwTemp.getArgsValue()%>');
		}else if(sReturn=="4"){
			//����Pdf","����pdf","
			exportPage('<%=sWebRootPath%>',0,'pdf','<%=dwTemp.getArgsValue()%>');	
		//}else if(sReturn=="5"){
			//����word
		//	ExportToWord();
			//exportPage('<%=sWebRootPath%>',0,'word','<%=dwTemp.getArgsValue()%>');	
		}else{
			alert("��δѡ�񵼳����ͣ���ѡ�񡭡�");
		}
	}
	function switchItem(tag){
		var s1 = document.getElementById('s1');
		if(tag==''){
		    s1.style.display = '';
		}else{
		    s1.style.display = 'none';
		}
	}
	
	function deleteRecord(){
		if(confirm('ȷʵҪɾ����?'))as_delete(0,'alert(getRowCount(0))');
	}
	function goBack(){
		self.close();
	}
	function edit3(){
		//�����������
		var sResUrl = "/CreditManage/Collection/OutCollRegistrateInfo.jsp";
		var sPTISerialNo = "";
		var sCTSerialNo = "";
		sPTISerialNo=getItemValue(0,getRow(0),'TASKBATCHNO');
		sCTSerialNo=getItemValue(0,getRow(0),'SERIALNO');
			//�ж���ˮ���Ƿ�Ϊ��
		if (typeof(sPTISerialNo)=="undefined" || sPTISerialNo.length==0 || typeof(sCTSerialNo)=="undefined" || sCTSerialNo.length==0){
			alert('��ѡ��һ����¼');
			return;
		}
		AsControl.PopComp(sResUrl,'PTISerialNo=' +sPTISerialNo+'&CTSerialNo=' +sCTSerialNo+'&RightType=ReadOnly','');
	}
	function edit2(){
		edit1();
	}
	function edit1(){
		var serialNo = getItemValue(0,getRow(0),'SerialNo');
	 	var duebillSerialNo = getItemValue(0,getRow(0),'ObjectNo');
		var contractSerialNo = getItemValue(0,getRow(0),'ContractSerialNo');
	 	var customerID = getItemValue(0, getRow(0), 'CustomerID');
	 	if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
	 	}
		var returnValue = AsCredit.openFunction("CollTaskInfo","ObjcetNo="+duebillSerialNo+"&SerialNo="+serialNo+"&CustomerID="+customerID+"&DuebillSerialNo="+duebillSerialNo+"&ContractSerialNo="+contractSerialNo+"&DoFlag=check");
		reloadSelf();
	}
	
	function collChangeAll(){
		//�������
		var sUrl = "/CreditManage/Collection/RiskAssign.jsp";
		var sCTSerialNo = getItemValue(0,getRow(),'SERIALNO');
		var sOperateUserId = getItemValue(0,getRow(),'OPERATEUSERID');
		var sHaveRoleFlag="<%=sHaveRoleFlag%>";
		var sBDOperateOrgID="";
		//�ж��Ƿ�ѡ���˴�����Ϣ
		if (typeof(sCTSerialNo)=="undefined" || sCTSerialNo.length==0){
			alert('��ѡ��һ�ʴ�����Ϣ��');
			return;
		}else{
			if("undefine"==sOperateUserId || "null"==sOperateUserId || null ==sOperateUserId || sOperateUserId.length==0 || sOperateUserId.length == ""){
				sCTSerialNoList = sCTSerialNo ;
				sBDOperateOrgID= getItemValue(0,getRow(),'BDOPERATEORGID');
			}else{
				 if(sHaveRoleFlag=="yes"){
					 sCTSerialNoList = sCTSerialNo;
					 sBDOperateOrgID= getItemValue(0,getRow(),'BDOPERATEORGID');
				 }else{
					 alert("�ý���Ѿ�������ˣ�������ѡ��");	
					 return;	 
				 }
			}
		    AsControl.PopComp(sUrl,"BDOPerateOrgID="+sBDOperateOrgID+"&CTSerialNoList=" +sCTSerialNoList,"");
		 }
	}
	function collChange1(){
		//���е绰����
		var sCTSerialNoList = getItemValue(0,getRow(0),'SerialNo');
		//�ж��Ƿ�ѡ���˴�����Ϣ
		if (typeof(sCTSerialNoList)=="undefined" || sCTSerialNoList.length==0){
		        alert('��ѡ��һ�ʴ�����Ϣ��');
		        return;
		}
		var operateuserid=SelectGridValue();//ѡ�������ص�ִ����Ա��userid
		//�ж�ִ����Ա�Ƿ�Ϊ��
	    if (typeof(operateuserid)=="undefined" || operateuserid.length==0){
	        alert('��ѡ��һλִ����Ա��');
	        return;
		}
		//����java���� 
	    var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.urge.CollSelectListAction", "CollChange", "OperateUserId="+operateuserid+",OperateOrgId=,CTSerialNoList="+sCTSerialNoList+",TaskName= "+",UserId=<%=CurUser.getUserID()%>"+",OrgId=<%=CurUser.getOrgID()%>");
		if(sReturn == "true"){
	    	 alert("��������ɹ���");
	    }else{
	    	 alert("�������ʧ�ܣ������½������������");
	    }
		reloadSelf();
	}
	function collChange2(){
		//���д���
		collChange1();
	}
	function collChange3(){
		//�������
		var sPTISerialNoList = getItemValue(0,getRow(0),'TASKBATCHNO');
		//�ж��Ƿ�ѡ����������Ϣ
		if (typeof(sPTISerialNoList)=="undefined" || sPTISerialNoList.length==0){
		        alert('��ѡ��һ��������Ϣ��');
		        return;
		}
		if(confirm("ȷ��Ҫ���ĵ�ǰ���εĴ���ִ������")){
			var operateuserid = Customer_Partner();   //ѡ�������صĺ��������
		    if (typeof(operateuserid)=="undefined" || operateuserid.length==0){
		        alert('����ǰѡ����Ҫ�����������������Ϣ����ѡ��һ����������̣�');
		        return;
			}
			//����java���� 
		    var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.urge.CollSelectListAction", "outCollChange", "OperateUserId="+operateuserid+",OperateOrgId=,PTISerialNoList="+sPTISerialNoList+",UserId=<%=CurUser.getUserID()%>"+",OrgId=<%=CurUser.getOrgID()%>");
			if(sReturn == "true"){
		    	alert('�������ɹ���');
		    }else{
		    	alert("�������ʧ�ܣ������½���������䣡");
		    }
		}
		reloadSelf();
	}
	//ѡ��ִ����Ա
	function SelectGridValue(){
	    //ģ��ΪExcute_USER_INFO��ѡ����������USERID@USERNAME
		var sReturn = AsDialog.SelectGridValue("Excute_USER_INFO", "", "USERID@USERNAME", "", true);
		if(!sReturn) return;
		var sIds = "";//ִ����Ա���
		var sNames = "";//ִ����Ա����
		//��ò���ȡ����ֵ
		if(sReturn != "_CLEAR_"){
			var aReturn = sReturn.split("~");
			for(var i = 0; i < aReturn.length; i++){
				var aIdName = aReturn[i].split("@");
				sIds += ","+aIdName[0];
				sNames += ","+aIdName[1];
			}
			if(sIds != "") sIds = sIds.substring(1);
			if(sNames != "") sNames = sNames.substring(1);
		}
		//��ִ����Ա�Ǹ�text��ʾ���ص�ִ����Ա����
		return sIds;
	}
	//ѡ�����������
	function Customer_Partner(){
		//ģ��ΪExcute_USER_INFO��ѡ����������CUSTOMERID@CUSTOMERNAME
		var sReturn = AsDialog.SelectGridValue("CHOISE_PARTNER", "", "CUSTOMERID@CUSTOMERNAME", "", true);
		if(!sReturn) return;
		var sPIds = "";	   
	    var sPNames = "";//����������
		if(sReturn != "_CLEAR_"){
			var aReturn = sReturn.split("~");
			for(var i = 0; i < aReturn.length; i++){
				var aIdName = aReturn[i].split("@");
				sPIds += ","+aIdName[0];
				sPNames += ","+aIdName[1];
			}
			if(sPIds != "") sPIds = sPIds.substring(1);
			if(sPNames != "") sPNames = sPNames.substring(1);
		}
		//�ں�����ѡ���Ǹ�text��ʾ���صĺ���������
		return sPIds;
	}
	
	function collChange (){
		alert("�������Ͳ���ȷ��");
	}
	
	function closeColl(){
		//�������
		var sSerialNoList = getItemValue(0,getRow(0),'SERIALNO');
		//�ж��Ƿ�ѡ����������Ϣ
		if (typeof(sSerialNoList)=="undefined" || sSerialNoList.length==0){
		        alert('��ѡ��һ�ʴ�����Ϣ��');
		        return;
		}

		var sMessage = "";
	 	var sBusinessSum = getItemValue(0,getRow(0),'OVERDUEBALANCE');
	 	if(parseFloat(sBusinessSum)>0){
	 		sMessage = "�ô����˻��´���δִ����ϵ�����򻹿��ŵ��ȷ��Ҫ�رո��˻�ֹͣ����ִ����";
	 	}
		if((""==sMessage)? true:confirm(sMessage)){
			//����java���� 
		    var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.urge.CollSelectListAction", "closeColl", "OperateUserId= ,OperateOrgId=,SerialNoList="+sSerialNoList+",CloseType=<%=sCollType%>,UserId=<%=CurUser.getUserID()%>"+",OrgId=<%=CurUser.getOrgID()%>");
			if(sReturn == "true"){
		    	alert('����رճɹ���');
		    }else{
		    	alert("����ر�ʧ�ܣ������½�������رգ�");
		    }
		}
		reloadSelf();
		
	}
	
	function dataOut(){
		<%-- var s1 = document.getElementById('s1');
		s1.style.display = ''; --%>
		if(confirm("�Ƿ񵼳���ǰ���ε�ǰ������Ϣ��")){
			//var sReturn = AsControl.PopComp("/CreditManage/Collection/DataExportTypeChoose.jsp","","resizable=yes;dialogWidth=500px;dialogHeight=150px;center:yes;status:no;statusbar:no");
			exportPage('<%=sWebRootPath%>',0,'excel','<%=dwTemp.getArgsValue()%>');
		}
	}

	function ExportToWord(){   
		var oApplication=new ActiveXObject("Word.Application");
		oApplication.Visible=true;   // ������뿴��Word����Ͱ����ȥ��
		var oDoc = oApplication.Documents.Open("<%=sWebRootPath%>");
			oDoc.SaveAs('<%=sWebRootPath%>', 16);
			oApplication.Quit(false); 
		}
	function collDoAgain(){
		var sOperateUserId =  getItemValue(0,getRow(0),'OPERATEUSERID');
		if (typeof(sOperateUserId)=="undefined" || sOperateUserId.length==0){
	        alert('��ѡ��һ�ʴ�����Ϣ��');
	        return;
		}
		var sBDSerialNo = getItemValue(0,getRow(0),'OBJECTNO');
		if (typeof(sBDSerialNo)=="undefined" || sBDSerialNo.length==0){
	        alert('��ѡ��һ�ʴ�����Ϣ��');
	        return;
		}
		var sCollType = "<%=sCollType%>";
		//����java����  com.amarsoft.app.urge.CollSendMail  collChange  com.amarsoft.app.urge.CollSendMail
	    var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.urge.CollSendMail", "collChange", "OperateUserId="+sOperateUserId+" ,OperateOrgId=,BDSerialNo="+sBDSerialNo+",CollType="+sCollType+",UserId=<%=CurUser.getUserID()%>,OrgId="+"<%=CurUser.getOrgID()%>");
		var sReturnValue = sReturn.split("@");
		sReturn = sReturnValue[0];
		if(sReturn == "true"){
	    	alert('����߰��ѳɹ����ʹ߰��ʼ���');
	    }else{
	    	alert("����߰췢�ʹ߰��ʼ�ʧ�ܣ��������½�������߰죡");
	    }
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
