<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	String ContractSerialNo = "";
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select * from contract_relative where objectno=:objectNo and objecttype = 'jbo.app.BUSINESS_CONTRACT'").setParameter("objectNo",serialNo));
	while(rs.next()){
		String Temp = rs.getString("ContractSerialNo");
		ContractSerialNo += Temp+"@";
	}
	rs.getStatement().close();
	
	ASObjectModel doTemp = new ASObjectModel("CLBsList");
	
	doTemp.appendJboWhere(" and O.SerialNo in('"+ContractSerialNo.replaceAll("@", "','")+"')");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(20);
	dwTemp.setParameter("SerialNo", serialNo);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","额度详情","额度详情","view()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
function view(){
	var SerialNo = getItemValue(0,getRow(0),"SerialNo");
	if(typeof(SerialNo)=="undefined" || SerialNo.length==0)  {
		alert(getHtmlMessage('1'));//请选择一条信息！
		return ;
	}
	var BusinessType = getItemValue(0,getRow(0),"BusinessType");
	var RightType = "ReadOnly";
	var ApplySerialNo = getItemValue(0,getRow(0),"ApplySerialNo");
	AsCredit.openFunction("CLViewMainInfo","SerialNo="+SerialNo+"&BusinessType="+BusinessType+"&ObjectNo="+ApplySerialNo+"&ObjectType=jbo.app.BUSINESS_APPLY"+"&RightType="+RightType);
}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
