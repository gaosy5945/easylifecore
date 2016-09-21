<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow_Info.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow_List.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow.js"></script>
<%	
	String objectNo = CurPage.getParameter("ObjectNo");
	String objectType = CurPage.getParameter("ObjectType");//ģ���
	BusinessObject inputParameters= BusinessObject.createBusinessObject();
	String parentSerialNo = Sqlca.getString(new SqlObject("select SerialNo from CL_INFO where ObjectType=:ObjectType and ObjectNo=:ObjectNo and (parentSerialNo is null or parentSerialNo = '')")
												.setParameter("ObjectType", objectType).setParameter("ObjectNo", objectNo));
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List("ScaleContractCLProduct",inputParameters,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "0";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("ParentSerialNo", parentSerialNo);
	dwTemp.genHTMLObjectWindow(parentSerialNo);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","add()","","","","",""},
			{"true","All","Button","����","����","saveRecord()","","","","",""},
			{"true","All","Button","ɾ��","ɾ��","del()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function add(){
		ALSObjectWindowFunctions.addRow(0,"","addAfterEvent()");
	}
	function addAfterEvent(){
		setItemValue(0,getRow(0),"DIVIDETYPE","10");
		setItemValue(0,getRow(0),"ParentSerialNo","<%=parentSerialNo%>");
		setItemValue(0,getRow(0),"ObjectType","<%=objectType%>");
		setItemValue(0,getRow(0),"ObjectNo","<%=objectNo%>");
		setItemValue(0,getRow(0),"INPUTUSERID","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(0),"INPUTORGID","<%=CurUser.getOrgID()%>");
	}
	function saveRecord(){
		as_save("myiframe0");
	}
	function del(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(serialNo) == "undefined" || serialNo.length == 0){
		    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		    return;
		}
		if(confirm('ȷʵҪɾ����?')){
			ALSObjectWindowFunctions.deleteSelectRow(0);
		}
    }
	function selectBusinessType(){
		var inputParameters={"ProductType1":"01","Status":"1"};
		var returnVaule = AsCredit.selectJavaMethodTree("com.amarsoft.app.als.prd.web.ui.ProductTreeFor555",inputParameters);
		if(returnVaule["ID"] != "_NONE_" && returnVaule["ID"] != "_CANCEL_"){
			setItemValue(0,getRow(0),"BusinessType",returnVaule["ID"]);
			setItemValue(0,getRow(0),"BusinessTypeName",returnVaule["Name"]);
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
