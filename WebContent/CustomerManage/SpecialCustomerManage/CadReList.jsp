<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String listType = CurPage.getParameter("ListType");
	if(listType == null) listType = "";
	String importTemplet = CurPage.getParameter("ImportTemplet");
	if(importTemplet == null) importTemplet = "";

	ASObjectModel doTemp = new ASObjectModel("CadReList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.MultiSelect = true; //�����ѡ
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(listType);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","All","Button","����","����","viewAndEdit()","","","","",""},
			{"true","All","Button","��������","��������","importData()","","","","",""},
			{"true","All","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0,'')","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script><script type="text/javascript">
	function add(){
		var listType = "<%=listType%>";
    	OpenPage("/CustomerManage/SpecialCustomerManage/CadReInfo.jsp?listType="+listType,"_self","");
		reloadSelf();
	}
	function viewAndEdit(){
		var serialNo = getItemValue(0,getRow(0),"SERIALNO");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert("��ѡ��һ����Ϣ��");
			return;
		}
		OpenPage("/CustomerManage/SpecialCustomerManage/CadReInfo.jsp?SerialNo="+serialNo,"_self","");
		reloadSelf();
	}
	
	function importData(){
	    var pageURL = "/AppConfig/FileImport/FileSelector.jsp";
	    var parameter = "clazz=jbo.import.excel.CADRE_IMPORT";
	    var dialogStyle = "dialogWidth=650px;dialogHeight=350px;resizable=1;scrollbars=0;status:y;maximize:0;help:0;";
	    var sReturn = AsControl.PopComp(pageURL, parameter, dialogStyle);
	    reloadSelf();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
