<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	//���ղ���
	//String projectStatus = DataConvert.toString(CurPage.getParameter("ProjectStatus"));//��Ŀ״̬
 	//String isPack = DataConvert.toString(CurPage.getParameter("isPack"));//�Ƿ��ѷ��
	//String isPool = DataConvert.toString(CurPage.getParameter("isPool"));//�Ƿ������ 
    
	ASObjectModel doTemp = null;
	doTemp = new ASObjectModel("ProjectTransferList1");
	doTemp.setJboWhereWhenNoFilter(" and 1=2");
	//doTemp.setJboWhere("O.ProjectType like '02%'");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	/*
	if("true".equals(isPack)||"true".equals(isPool)){
		dwTemp.MultiSelect = true;
	}else{
		dwTemp.MultiSelect = false;
	}*/
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(CurUser.getOrgID());
	
	String sButtons[][] = {
		{"true","","Button","��Ŀ����","��Ŀ����","check()","","","","btn_icon_detail",""},
	};
%> 
<script type="text/javascript">

	//��Ŀ����
	function check(){
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		var sProjectType=getItemValue(0,getRow(),"ProjectType");
		var sProjectStatus=getItemValue(0,getRow(),"Status");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert("��ѡ��һ����¼��");
			return;
		}
		AsCredit.openFunction("ProjectAssetDetail1","RightType=ReadOnly&SerialNo="+sSerialNo+"&RightType=ReadOnly&ProjectStatus="+sProjectStatus+"&ProjectType="+sProjectType);
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
