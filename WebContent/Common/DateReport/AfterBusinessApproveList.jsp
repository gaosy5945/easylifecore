<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>

<%
	//接收参数
	String tempNo = DataConvert.toString(CurPage.getParameter("TemplateNo"));//模板号
	String InspectType = DataConvert.toString(CurPage.getParameter("InspectType"));//检查类型
	if(InspectType==null) InspectType="";
	//tempNo="LoanBillCheckReport";
	ASObjectModel doTemp = new ASObjectModel(tempNo);
	doTemp.getCustomProperties().setProperty("JboWhereWhenNoFilter"," and 1=2 ");
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	
	String objectType = "";
	
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject(" select CL.ITEMDESCRIBE from CODE_LIBRARY CL where CL.CODENO = 'InspectObjectType' AND CL.ITEMNO =:ITEMNO").setParameter("ITEMNO", InspectType));
    
	if(rs.next())
    {
		objectType = rs.getString("ITEMDESCRIBE");
    }
    rs.close();
    
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.setParameter("InspectType", InspectType);
	dwTemp.setParameter("OrgID", CurUser.getOrgID());
	dwTemp.setParameter("ObjectType", objectType);
	dwTemp.setPageSize(15);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","详情","详情","view()","","","","",""},
			{"true","","Button","导出","导出Excel","Export()","","","",""},
			//{"true","","Button","历史签署意见","历史签署意见","opinionLast()","","","","",""},
		};
%> 

<script type="text/javascript">

function Export(){
	if(s_r_c[0] > 1000){
		alert("导出数据量过大，请控制在1000笔内。");
		return;
	}
	as_defaultExport();
}

function view(){
	 var serialNo = getItemValue(0,getRow(0),'SERIALNO');
	 var duebillSerialNo = getItemValue(0,getRow(0),'OBJECTNO');
	 var contractSerialNo = getItemValue(0,getRow(0),'CONTRACTSERIALNO');
	 var putOutDate = getItemValue(0,getRow(0),'PUTOUTDATE');
	 var creditInspectType = "<%=InspectType%>";
	
	 var sRightType="ReadOnly";
	 
	 var customerID = getItemValue(0, getRow(0), 'CustomerID');

	 if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
		alert("参数不能为空！");
		return ;
	 }
	 if(creditInspectType == "02"){
		 AsCredit.openFunction("FundPurposeInfo","CreditInspectType="+creditInspectType+"&CustomerID="+customerID+"&SerialNo="+serialNo+"&DuebillSerialNo="+duebillSerialNo+"&ContractSerialNo="+contractSerialNo+"&RightType="+sRightType);
		 reloadSelf();
		 return;
	 }else if(creditInspectType == "03"){
		 AsCredit.openFunction("RunDirectionInfo","CreditInspectType="+creditInspectType+"&CustomerID="+customerID+"&SerialNo="+serialNo+"&DuebillSerialNo="+duebillSerialNo+"&ContractSerialNo="+contractSerialNo+"&RightType="+sRightType);
		 reloadSelf();
		 return;
	 }else if(creditInspectType == "05"){
		 var projectType = getItemValue(0, getRow(0), 'ProjectType');
		 var objectType = "jbo.prj.PRJ_BASIC_INFO";
		 AsCredit.openFunction("HandDirectionInfo","ProjectType="+projectType+"&CreditInspectType="+creditInspectType+"&CustomerID="+customerID+"&SerialNo="+serialNo+"&ObjectNo="+duebillSerialNo+"&ObjectType="+objectType+"&RightType="+sRightType);
		 reloadSelf();
		 return;
	 }else {
		 var objectType = "jbo.prj.PRJ_BASIC_INFO";
		 AsCredit.openFunction("PrjCusCheckList","CreditInspectType="+creditInspectType+"&CustomerID="+customerID+"&SerialNo="+serialNo+"&ObjectNo="+duebillSerialNo+"&ObjectType="+objectType+"&RightType="+sRightType);
		 reloadSelf();
		 return;
	 }
}

</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%@include file="/Frame/resources/include/include_end.jspf"%>
