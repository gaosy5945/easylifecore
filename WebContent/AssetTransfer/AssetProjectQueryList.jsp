<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%@ page import="com.amarsoft.app.als.assetTransfer.util.AssetProjectCodeConstant"%>

<%
	//�ʽ���Ŀ��ز�ѯ�б�
	//���ղ���
	String sAssetProjectType = DataConvert.toString(CurPage.getParameter("AssetProjectType"));//��Ŀ����
	

	ASObjectModel doTemp = new ASObjectModel("AssetTransferList");
	doTemp.setJboWhere("projectType='"+sAssetProjectType+"' and status in('010','030','040')");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	//dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("SerialNo");
	
	String sButtons[][] = {
	{"true","All","Button","����","����","view()","","","","btn_icon_detail",""},
	{"true","All","Button","�ʲ�������������","�ʲ�������������","repaymentAndRisk()","","","","",""},
	{AssetProjectCodeConstant.AssetProjectType_010.equals(sAssetProjectType)?"true":"false","All","Button","����������嵥","����������嵥","costList()","","","","",""},
	{AssetProjectCodeConstant.AssetProjectType_010.equals(sAssetProjectType)?"true":"false","All","Button","��Ŀ�ع��嵥","��Ŀ�ع��嵥","buyBackList()","","","","",""},
	{AssetProjectCodeConstant.AssetProjectType_020.equals(sAssetProjectType)?"true":"false","All","Button","֧��������嵥","֧��������嵥","costList()","","","","",""},
	{AssetProjectCodeConstant.AssetProjectType_020.equals(sAssetProjectType)?"true":"false","All","Button","��Ŀ�����嵥","��Ŀ�����嵥","buyBackList()","","","","",""},
		};
%> 
<script type="text/javascript">
	
	//����,ֻ��
	function view(){
		var serialNo = getItemValue(0,getRow(),"serialNo");
		var sAssetProjectType = getItemValue(0,getRow(),"PROJECTTYPE");
    	if(typeof(serialNo) == "undefined" || serialNo.length == 0){
   			alert("����ѡ��һ����¼");
   			return ;
        }
        
    	var viewID = "002";
        paramString = "ObjectNo=" + serialNo + "&ObjectType=AssetProject&AssetProjectType="+sAssetProjectType+"&ViewID="+viewID; 
   	 
    	AsControl.OpenObjectTab(paramString);
    	reloadSelf();
    	return ;
	}
	
	//�ʲ�������������
	function repaymentAndRisk(){
		var serialNo = getItemValue(0,getRow(),"serialNo");
		AsControl.OpenView("/AssetTransfer/AssetRepaymentRiskDetail.jsp","ObjectNo="+serialNo,"_blank");
	}
	
	//����������嵥 or ֧��������嵥
	function costList(){
		var serialNo = getItemValue(0,getRow(),"serialNo");
		AsControl.OpenView("/AssetTransfer/AcctFeeLogList.jsp","isQuery=true&ObjectNo="+serialNo,"_blank");
	}
	
	//��Ŀ�ع��嵥 or ��Ŀ�����嵥
	function buyBackList(){
		var serialNo = getItemValue(0,getRow(),"serialNo");
		AsControl.OpenView("/AssetTransfer/BuyBackList.jsp","ObjectNo="+serialNo,"_blank");
	}
	
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
