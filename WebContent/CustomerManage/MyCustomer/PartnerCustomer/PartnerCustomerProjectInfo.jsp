<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String customerID = CurPage.getParameter("CustomerID");
	if(customerID == null) customerID = "";
	
	ASObjectModel doTemp = new ASObjectModel("PCProjectInfo");
	//项下贷款数量处理逻辑待定
	//String LoanCount = Sqlca.getString(new SqlObject("select count(1) as LoanCount from contract_relative where ObjectType='jbo.guaranty.GUARANTY_CONTRACT' and ObjectNo=:ObjectNo").setParameter("ObjectNo",serialNo));
	//doTemp.setJboWhere(doTemp.getJboWhere()+" and exists(select 1 from jbo.sys.ORG_BELONG OB where OB.BelongOrgID='"+CurOrg.getOrgID()+"' and O.ParticipateOrg like '%%')");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(customerID);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"false","All","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"true","","Button","详情","详情","viewProject()","","","","btn_icon_detail",""},
			{"false","","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0,'alert(getRowCount(0))')","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
function viewProject(){
	var serialNo =  getItemValue(0,getRow(0),"SERIALNO");
	var customerID =  getItemValue(0,getRow(0),"CUSTOMERID");
	if(typeof(serialNo) == "undefined" || serialNo.length == 0){
		alert("请选择一条信息！");
		return;
	}
    AsCredit.openFunction("ProjectInfoTab", "SerialNo="+serialNo+"&RightType="+"ReadOnly"+"&CustomerID="+customerID);
}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
