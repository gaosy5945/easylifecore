<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
 <%@ page import="com.amarsoft.app.als.assetTransfer.util.AssetProjectCodeConstant"%>
<%
	//�ʲ��������ʲ�׷��
	//���ղ���
	String sObjectNo = DataConvert.toString(CurComp.getParameter("ObjectNo"));//��Ŀ��ˮ��
	String sAssetProjectType = DataConvert.toString(CurPage.getParameter("AssetProjectType"));//��Ŀ����
	String sIsAppend = DataConvert.toString(CurPage.getParameter("isAppend"));//�Ƿ��ʲ�׷��
	
	ASObjectModel doTemp = new ASObjectModel("ProjectAssetRelaList");
	doTemp.setJboWhere("PROJECTNO='"+sObjectNo+"' and status = '010'");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.MultiSelect = true;
	dwTemp.Style="1";      	     //����ΪGrid���
	//dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
	{"true","All","Button","�ʲ�����","�ʲ�����","assetImport()","","","","",""},
	{"true","All","Button","�ʲ�ɸѡ","�ʲ�ɸѡ","assetFilter()","","","","",""},
	{"true".equals(sIsAppend)?"false":"true","All","Button","ɾ��","ɾ��","del()","","","","",""},
	{"true".equals(sIsAppend)?"false":"true","All","Button","���","���","ransom()","","","","",""},
	{"true".equals(sIsAppend)?"false":"true","All","Button","�ʲ���ز���","�ʲ���ز���","ransomCal()","","","","",""},
	
	
		};
%> 
<script type="text/javascript">
	//�ʲ�����
	function assetImport(){
		alert("����δ��ȷ����δʵ��");
	}
	
	//�ʲ�ɸѡ
	function assetFilter(){
		//TODO �˴���ѯ�������ȡ�����ٲ�ѯ��ģ�飬���Ż�
		var sProjectNo = "<%=sObjectNo%>";
		var sReturn = AsDialog.OpenSelector("SelectUnfinishBD","","");//��ѯδ����Ľ�ݣ����ؽ����ˮ��
		if(typeof(sReturn) == "undefined" || sReturn == "_CANCEL_") return ;
		
		var sJavaClass = "com.amarsoft.app.als.assetTransfer.action.AssetFilterAction";
		var sJavaMethod = "filter";
		var sParams = "projectNo="+sProjectNo+",serialNos="+sReturn;
		
		var sResult = RunJavaMethodTrans(sJavaClass,sJavaMethod,sParams);
		
		if(sResult.length != 0){
			alert(sResult);
		}
		
		reloadSelf();
	}
	
	//ɾ��
	function del(){
		var recordArray = getCheckedRows(0);//��ȡ��ѡ����
		var relaSerialNos = '';
		if(typeof(recordArray) != 'undefined' && recordArray.length >= 1) {
			if(confirm('ȷʵҪɾ����?')){
				for(var i = 1;i <= recordArray.length;i++){
					var serialNo = getItemValue(0,recordArray[i-1],"serialNo");
					relaSerialNos += serialNo+"@";
				}
				alert(relaSerialNos);
				var sJavaClass = "com.amarsoft.app.als.assetTransfer.action.AssetFilterAction";
				var sJavaMethod = "del";
				var sParams = "serialNos="+relaSerialNos;
				
				var sResult = RunJavaMethodTrans(sJavaClass,sJavaMethod,sParams);
				if('true' == sResult){
					alert("ɾ���ɹ�");
					reloadSelf();
				}else{
					alert("ɾ��ʧ��");
				}
			}
		}else{
			alert("����ѡ��һ����¼");
		}
	}
	
	//ת����������
	function setOutRate(){
		var recordArray = getCheckedRows(0);//��ȡ��ѡ����
		var relaSerialNos = '';
		if(typeof(recordArray) != 'undefined' && recordArray.length >= 1) {
			for(var i = 1;i <= recordArray.length;i++){
				var serialNo = getItemValue(0,recordArray[i-1],"serialNo");
				relaSerialNos += serialNo+"@";
			}
		}else{
			alert("����ѡ��һ����¼");
			return;
		}
		
		var sReturn = PopPage("/AssetTransfer/SetRateInfo.jsp?relaSerialNos="+relaSerialNos,"","resizable=yes;dialogWidth=400px;dialogHeight=110px;center:yes;status:no;statusbar:no");
		if('true' == sReturn){
			alert("���óɹ�");
			reloadSelf();
		}
	}
	
	//ת��������������
	function batchSetOutRate(){
		if(confirm('�������ý��Ե�ǰ��Ŀ�µ������ʲ���������,�Ƿ�ȷ�ϴ˲���?')){
			var sProjectNo = '<%=sObjectNo%>';
			var sReturn = PopPage("/AssetTransfer/SetRateInfo.jsp?isBatch=true&ProjectNo="+sProjectNo,"","resizable=yes;dialogWidth=400px;dialogHeight=110px;center:yes;status:no;statusbar:no");
			if('true' == sReturn){
				alert("���óɹ�");
				reloadSelf();
			}
		}
	}
	
	//�ʲ����
	function ransom(){
		var recordArray = getCheckedRows(0);//��ȡ��ѡ����
		var projectNo = '<%=sObjectNo%>';
		var relaSerialNos = '';
		if(typeof(recordArray) != 'undefined' && recordArray.length >= 1) {
			for(var i = 1;i <= recordArray.length;i++){
				var serialNo = getItemValue(0,recordArray[i-1],"serialNo");
				relaSerialNos += serialNo+"@";
			}
		}else{
			alert("����ѡ��һ����¼");
			return;
		}
		//�� �ʲ������Ϣ����
		var serialNo = getSerialNo("ASSET_RANSOM","SERIALNO");
		AsControl.PopComp("/AssetTransfer/AssetRansomInfo.jsp","relaSerialNos="+relaSerialNos+"&SerialNo="+serialNo+"&ProjectNo="+projectNo,"","resizable=yes;dialogWidth=800px;dialogHeight=600px;center:yes;status:no;statusbar:no");
	}
	
	//�ʲ���ز���
	function ransomCal(){
		AsControl.OpenView("/AssetTransfer/AssetRansomCalInfo.jsp","","","resizable=yes;dialogWidth=800px;dialogHeight=600px;center:yes;status:no;statusbar:no");
	}
	
	//�ʲ��ַ�
	function assetDistribute(){
		var recordArray = getCheckedRows(0);//��ȡ��ѡ����
		var sProjectNo = '<%=sObjectNo%>';
		var relaSerialNos = '';
		if(typeof(recordArray) != 'undefined' && recordArray.length >= 1) {
			for(var i = 1;i <= recordArray.length;i++){
				var serialNo = getItemValue(0,recordArray[i-1],"serialNo");
				relaSerialNos += serialNo+"@";
			}
		}else{
			alert("����ѡ��һ����¼");
			return;
		}
		
		//�� �ʲ��ַ�����
		var sReturn = PopPage("/AssetTransfer/AssetDistributeInfo.jsp?isBatch=true&ProjectNo="+sProjectNo,"","resizable=yes;dialogWidth=400px;dialogHeight=110px;center:yes;status:no;statusbar:no");
		
		if(typeof(sReturn) != 'undefined' && sReturn.length >= 1){
			var sManageOrgId = sReturn.split("@")[0];
			var sManageUserId = sReturn.split("@")[1];
			
			var sJavaClass = "com.amarsoft.app.als.assetTransfer.action.AssetTransferAction";
			var sJavaMethod = "assetDistribute";
			var sParams = "serialNos="+relaSerialNos+",manageOrgId="+sManageOrgId+",manageUserId="+sManageUserId;
			
			var sResult = RunJavaMethodTrans(sJavaClass,sJavaMethod,sParams);
			if('true' == sResult){
				alert("�ʲ��ַ��ɹ�");
				reloadSelf();
			}else{
				alert("�ʲ��ַ�ʧ��");
			}
		}
		
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
