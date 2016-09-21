<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%@ page import="com.amarsoft.app.als.assetTransfer.util.AssetProjectCodeConstant"%>

<%
	//接收参数
	String tempNo = CurPage.getParameter("TempNo");//模板号
	ASObjectModel doTemp = null;
	doTemp = new ASObjectModel(tempNo);
	//doTemp.setJboWhereWhenNoFilter(" and 1=2 ");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	//dwTemp.setParameter(name, value)
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.setPageSize(20);
	dwTemp.setParameter("OrgID", CurUser.getOrgID());
	dwTemp.genHTMLObjectWindow("");
	
	
	
	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","详情","详情","view()","","","","",""}
		};
%> 

<script type="text/javascript">

function view(){
	 //var sUrl = "/CreditManage/Collection/CollectionReport.jsp";
	// var varia=getItemValue(0,getRow(0),'SerialNo');
	 //AsControl.PopComp(sUrl,'','');
	var serialNo = getItemValue(0,getRow(0),'SERIALNO');
 	var duebillSerialNo = getItemValue(0,getRow(0),'OBJECTNO');
	var contractSerialNo = getItemValue(0,getRow(0),'CONTRACTSERIALNO');
 	var customerID = getItemValue(0, getRow(0), 'CUSTOMERID');
 	if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
		alert("参数不能为空！");
		return ;
 	}
	var returnValue = AsCredit.openFunction("CollTaskInfo","ObjcetNo="+duebillSerialNo+"&SerialNo="+serialNo+"&DoFlag=check&CustomerID="+customerID+"&DuebillSerialNo="+duebillSerialNo+"&ContractSerialNo="+contractSerialNo);
	if(returnValue == "true"){
		reloadSelf();
		edit();
	}else reloadSelf();

}

</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%@include file="/Frame/resources/include/include_end.jspf"%>
