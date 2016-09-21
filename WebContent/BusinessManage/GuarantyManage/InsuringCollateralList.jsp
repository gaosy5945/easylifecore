 <%@page import="com.amarsoft.app.als.guaranty.model.GuarantyFunctions"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String PG_TITLE = "待续保押品列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	ASObjectModel doTemp = new ASObjectModel("InsuringCollateralList");
	doTemp.getCustomProperties().setProperty("JboWhereWhenNoFilter"," and 1=2 ");//
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("InputOrgID", CurUser.getOrgID());
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			{"true","All","Button","押品详情","押品详情","view()","","","",""},
	};

%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function view(){
		/* var assetType = getItemValue(0,getRow(),"AssetType");
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var templateNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.CollateralTemplate", "getTemplate", "ItemNo="+assetType);
		templateNo = templateNo.split("@");
		if(templateNo[0]=="false"){
			alert("未配置押品类型"+assetType+"的模板！");
			return;
		}
		AsControl.OpenPage("/CreditManage/CreditApply/GuarantyCollateralInfo.jsp","TempletNo="+templateNo[1]+"&SerialNo=&VouchType=020","");
		 */
	}

	function mySelectRow(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0)  return ;

		AsControl.OpenPage("/BusinessManage/GuarantyManage/AssetInsuranceList.jsp","AssetSerialNo="+serialNo,"rightdown","");

	}
	
	mySelectRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
 