<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow_Info.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow_List.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow.js"></script>
<%	
	String objectNo = CurPage.getParameter("ObjectNo");
	String objectType = CurPage.getParameter("ObjectType");//模板号
	BusinessObject inputParameters= BusinessObject.createBusinessObject();
	String parentSerialNo = Sqlca.getString(new SqlObject("select SerialNo from CL_INFO where ObjectType=:ObjectType and ObjectNo=:ObjectNo and (parentSerialNo is null or parentSerialNo = '')")
												.setParameter("ObjectType", objectType).setParameter("ObjectNo", objectNo));
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List("ScaleContractCLProduct",inputParameters,CurPage,request);
	ASObjectModel doTemp = (ASObjectModel)dwTemp.getDataObject();
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "0";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("ParentSerialNo", parentSerialNo);
	dwTemp.genHTMLObjectWindow(parentSerialNo);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增","新增","add()","","","","",""},
			{"true","All","Button","保存","保存","saveRecord()","","","","",""},
			{"true","All","Button","删除","删除","del()","","","","",""},
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
		    alert(getHtmlMessage('1'));//请选择一条信息！
		    return;
		}
		if(confirm('确实要删除吗?')){
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
