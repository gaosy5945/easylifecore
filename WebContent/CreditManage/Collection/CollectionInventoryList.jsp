<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	//��ȡǰ�˴���Ĳ���
    String sStatus = DataConvert.toString(CurPage.getParameter("Status"));//ģ���
    
	//ASObjectModel doTemp = new ASObjectModel("CollSelectList1");    
    
   
    
	//ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	
/* 	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_Info("CollSelectList1",inputParameter,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject(); */
	
	
	BusinessObject inputParameter =BusinessObject.createBusinessObject();
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("CollSelectList1",inputParameter,CurPage);
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	String sRoleInfo []={"PLBS0014"};
	String sWhereSql = "";
	String sHaveRoleFlag="";
	if(CurUser.hasRole(sRoleInfo)){
		sHaveRoleFlag="yes";
		sWhereSql=" and exists (select 1 from v.org_belong where v.belongorgid=BD.OperateOrgID and v.OrgID='"+CurUser.getOrgID()+"') ";
	}else{
		sHaveRoleFlag="no";
		sWhereSql=" and BD.OperateUserID='"+CurUser.getUserID()+"' ";
	}
	String sUserRole[] = {"PLBS0001","PLBS0002"};//�ͻ�����
	if("1".equals(sStatus)){
		sWhereSql+=" and BD.OverDueDays>=1 and BD.OverDueDays<=10 ";
	}else{
		sWhereSql=sWhereSql;
	}
	
	
	sWhereSql+=" and (v.nvl(BD.OVERDUEBALANCE,0)+v.nvl(BD.INTERESTBALANCE1,0)+v.nvl(BD.INTERESTBALANCE2,0)+v.nvl(BD.FINEBALANCE1,0)+v.nvl(BD.FINEBALANCE2,0))>0 ";
	    
    doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql); 
    //����HTMLDataWindow
	
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(15);
	dwTemp.MultiSelect = true;
	dwTemp.genHTMLObjectWindow("");
 
	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"1".equals(sStatus)?"false":"true","","Button","�������","�������","Assignments()","","","","",""},
			{"true","","Button","��������","��������","CollectionInfo()","","","","",""},
			{"1".equals(sStatus)?"true":"false","","Button","���񵼳�","���񵼳�","ExportTask()","","","","",""},
			{"1".equals(sStatus)?"true":"false","","Button","���ս������","���ս������","ImportTask()","","","","",""},
			//{"true","","Button","���յǼ�","���յǼ�","CollectionReport()","","","","",""}
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>


<script type="text/javascript">
function Assignments(){
	 //�������
	 var sUrl = "/CreditManage/Collection/RiskAssign.jsp";
	 //��ȡ��ˮ��
	 var sCTSerialNoList = "";//
	 var sHaveRoleFlag="<%=sHaveRoleFlag%>";
	 var arr = new Array();
	 arr = getCheckedRows(0);
	 var sBDOperateOrgID="";
	 if(arr.length < 1){
		 alert("��ѡ������һ����Ϣ��");
		 return;
	 }else{
		 var sFlag = true;
		 for(var i=0;i<arr.length;i++){
			 var sCTSerialNo = getItemValue(0,arr[i],'SERIALNO');
			 var sOperateUserId = getItemValue(0,arr[i],'OPERATEUSERID');
			 if(i==0){
				 sBDOperateOrgID= getItemValue(0,arr[i],'BDOPERATEORGID');
			 }else{
				 if(sBDOperateOrgID!=getItemValue(0,arr[i],'BDOPERATEORGID')){
					 alert("���ͬһ��������µ�������з���");
					 return;
				 }
			 }
			 if("undefine"==sOperateUserId || "null"==sOperateUserId || null ==sOperateUserId || sOperateUserId.length==0 || sOperateUserId.length == ""){
				 sCTSerialNoList += sCTSerialNo + "@";
			 }else{
				 if(sHaveRoleFlag=="yes"){
					 sCTSerialNoList += sCTSerialNo + "@";
				 }else{
					 alert("�ý�ݣ���ݺţ�"+getItemValue(0,arr[i],'OBJECTNO')+")�Ѿ�������ˣ�������ѡ��");
					 sFlag = false;
					 return;	 
				 }
			 }
		 }   
		 if(sFlag){
			 AsControl.PopView(sUrl,"BDOPerateOrgID="+sBDOperateOrgID+"&CTSerialNoList=" +sCTSerialNoList,'dialogWidth:460px;dialogHeight:350px;resizable:yes;scrollbars:no;status:no;help:no');
			 reloadSelf();
		 }else{
			 alert("����ѡ�������ѷ��������������ѡ��");
			 return;
		 }
	 }

}

function CollectionInfo(){
	 //var sUrl = "/CreditManage/Collection/CollectionReport.jsp";
	// var varia=getItemValue(0,getRow(0),'SerialNo');
	 //AsControl.PopComp(sUrl,'','');
	var serialNo = getItemValue(0,getRow(0),'SerialNo');
 	var duebillSerialNo = getItemValue(0,getRow(0),'ObjectNo');
	var contractSerialNo = getItemValue(0,getRow(0),'ContractSerialNo');
 	var customerID = getItemValue(0, getRow(0), 'CUSTOMERID');
 	if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
		alert("��������Ϊ�գ�");
		return ;
 	}
 	var sRightType="ReadOnly";
 	var DoFlag="check";
	var returnValue = AsCredit.openFunction("CollTaskInfo","DoFlag="+DoFlag+"&ObjcetNo="+duebillSerialNo+"&SerialNo="+serialNo+"&CustomerID="+customerID+"&DuebillSerialNo="+duebillSerialNo+"&ContractSerialNo="+contractSerialNo);
	if(returnValue == "true"){
		reloadSelf();
		edit();
	}else reloadSelf();

}
	
function ExportTask(){
	if(confirm("�Ƿ񵼳���ǰ���ε�ǰ������Ϣ��")){
		exportPage('<%=sWebRootPath%>',0,'excel','<%=dwTemp.getArgsValue()%>'); 
	}
}
function ImportTask(){
	//���м��е绰���ս������
	var pageURL = "/CreditManage/Collection/CollExcelImport.jsp";
    var parameter = "clazz=jbo.import.excel.TEL_COLL_IMPORT&InputUserId=<%=CurUser.getUserID()%>";
    var dialogStyle = "dialogWidth=650px;dialogHeight=350px;resizable=1;scrollbars=0;status:y;maximize:0;help:0;";
    var sReturn = AsControl.PopComp(pageURL, parameter, dialogStyle);
    reloadSelf();
}
</script>

<%@ include file="/Frame/resources/include/include_end.jspf"%>
