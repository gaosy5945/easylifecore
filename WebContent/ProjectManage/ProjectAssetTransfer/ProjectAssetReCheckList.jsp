<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%@ page import="com.amarsoft.app.als.assetTransfer.util.AssetProjectCodeConstant"%>

<%
	//���ղ���
	String projectStatus = DataConvert.toString(CurPage.getParameter("ProjectStatus"));//��Ŀ״̬
	String periodStatus = DataConvert.toString(CurPage.getParameter("PeriodStatus"));//����״̬
	String isCal = DataConvert.toString(CurPage.getParameter("isCal"));//�Ƿ�Ϊ����
	
	String isReCheck = DataConvert.toString(CurPage.getParameter("isReCheck"));//�Ƿ�Ϊɸѡ����
	String projectAssetStatus = DataConvert.toString(CurPage.getParameter("ProjectAssetStatus"));//�Ƿ�Ϊɸѡ������
	 
	ASObjectModel doTemp = null;
	doTemp = new ASObjectModel("ProjectAssetReCheckList");

	//doTemp.setJboWhere("PROJECTTYPE='010' and status='"+projectStatus+"'");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	//dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.MultiSelect = true;
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(projectAssetStatus);
	
	String sButtons[][] = {
		{"true".equals(isReCheck)?"true":"false","","Button","�ʲ�����","�ʲ�����","assetDetail()","","","","",""},
		{(AssetProjectCodeConstant.AssetProjectStatus_020.equals(projectStatus))&&(("01".equals(projectAssetStatus)))?"true":"false","","Button","ǩ�����","ǩ�����","signAdvice()","","","","",""},
		{(AssetProjectCodeConstant.AssetProjectStatus_020.equals(projectStatus))&&(("01".equals(projectAssetStatus)))?"true":"false","","Button","����ͨ��","����ͨ��","checkSubmit()","","","","",""},
		{"true".equals(isCal)?"true":"false","","Button","��Ŀ����","��Ŀ����","projectCal()","","","","",""},
	};
%> 
<script type="text/javascript">
	
	//�ύ
	function submit(){
		var sProjectNo = getItemValue(0,getRow(),"SERIALNO");
		var sProjectType = getItemValue(0,getRow(),"PROJECTTYPE");
		var status = '<%=AssetProjectCodeConstant.AssetProjectStatus_020%>';
		if(typeof(sProjectNo) == 'undefined' || sProjectNo.length == 0){
			alert("����ѡ��һ����¼");
			return;
		}
			AsControl.PopView("/ProjectManage/ProjectAssetTransfer/SubmitProjectDialog.jsp","SerialNo="+sProjectNo,"resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
			//RunJavaMethodTrans("com.amarsoft.app.als.assetTransfer.action.AssetTransferAction","changeProjectStatus","projectNo="+sProjectNo+",status="+status+",assetProjectType="+sProjectType);
			reloadSelf();
	}
	
	
	//ǩ�����
	function signAdvice(){
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.PopView("/ProjectManage/ProjectAssetTransfer/ProjectReCheckSignAdviceInfo.jsp","SerialNo="+sSerialNo,"resizable=yes;dialogWidth=25;dialogHeight=25;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	
	//����ͨ��
	function checkSubmit(){
		var sProjectNo = getItemValue(0,getRow(),"SERIALNO");
		var sProjectType = getItemValue(0,getRow(),"PROJECTTYPE");
		var status = '<%=AssetProjectCodeConstant.AssetProjectStatus_030%>';
		var approveOpinion = getItemValue(0,getRow(),"APPROVEOPINION");
		if(typeof(approveOpinion) == 'undefined' || approveOpinion.length == 0){
			alert("�ñ�ҵ����δǩ��������������ύ��");
			return;
		}
		if(typeof(sProjectNo) == 'undefined' || sProjectNo.length == 0){
			alert("����ѡ��һ����¼");
			return;
		}
		if(confirm('ȷ��Ҫ���д˲�����?')){
			RunJavaMethodTrans("com.amarsoft.app.als.assetTransfer.action.AssetTransferAction","changeProjectStatus","projectNo="+sProjectNo+",status="+status+",assetProjectType="+sProjectType);
			reloadSelf();
		}
	}

	//�ʲ�����
	function assetDetail(){
		sSerialNo=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/ProjectManage/ProjectAssetTransfer/AssetDebtDetailInfo.jsp","SerialNo="+sSerialNo,"_blank");
		reloadSelf();
	}
	
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
