<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	

	String sTempletNo = CurPage.getParameter("DoNoTemplet"); //模版编号
	
	ASDataObject doTemp = new ASDataObject(sTempletNo);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置为Grid风格
	//dwTemp.ReadOnly = "1";//只读模式
	String orgID = CurUser.getOrgID();
	Vector vTemp = dwTemp.genHTMLDataWindow(orgID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

  String sButtons[][] = {
          {"true","All","Button","新增","新增","newIndustryInfo()","","","",""},
          {"true","All","Button","修改","修改","modifyInfo()","","","",""}
      };
      
%>
<%@ include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">

	/*~[Describe=新增;InputParam=无;OutPutParam=无;]~*/
	function newIndustryInfo(){
		OpenPage("/CustomerManage/SpecialCustomerManage/IndustryInfo.jsp", "_self","");
		reloadSelf();
	}
	
	/*~[Describe=产业详情;InputParam=无;OutPutParam=无;]~*/
	function modifyInfo(){
		var itemNo = getItemValue(0,getRow(),"ITEMNO");
		if (typeof(itemNo)=="undefined" || itemNo.length==0) 
		{
			alert("请选择一个产业！");
			return;
		}else{
			OpenPage("/CustomerManage/SpecialCustomerManage/IndustryInfo.jsp?ItemNo="+ itemNo, "_self","");
			reloadSelf();
		}
	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
