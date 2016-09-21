<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sObjectNo = DataConvert.toString(CurPage.getParameter("ObjectNo"));//项目编号
	String sObjectType = DataConvert.toString(CurPage.getParameter("ObjectType"));//项目类型
	
	ASObjectModel doTemp = new ASObjectModel("JoinOrgsList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	//dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(sObjectNo+","+sObjectType);
	
	String sButtons[][] = {
			{"true","","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"true","","Button","删除","删除","del()","","","","btn_icon_delete",""},
		};
%> 
<script type="text/javascript">
	function add(){
		var sObjectNo = '<%=sObjectNo%>';
		var sObjectType = '<%=sObjectType%>';
		var selValue = AsDialog.OpenSelector( "SelectAllOrgMulti", "", "" );//选择机构
		//alert(selValue);
		
		if(selValue == '_CLEAR_' || selValue == '_CANCEL_'){
			return;
		}
		
		var sJavaClass = "com.amarsoft.app.als.assetTransfer.action.AssetTransferAction";
		var sJavaMethod = "addJoinOrgs";
		var sParamString = "objectNo="+sObjectNo+",objectType="+sObjectType+",orgs="+selValue;
		
		var sReturn = RunJavaMethodTrans(sJavaClass,sJavaMethod,sParamString);
		if("true" == sReturn){
			reloadSelf();
		}
	}
	
	
	function del(){
		var serialNo = getItemValue(0,getRow(),"SERIALNO");
		if(typeof(serialNo) == 'undefined' || serialNo.length == 0){
			alert("请先选择一条记录");
			return;
		}
		
		if(confirm('确实要删除吗?')){
			as_delete(0);
		}
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
