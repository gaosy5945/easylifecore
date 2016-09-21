<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	//定义变量
	String sCurBranchOrg=""; //当前用户所在分行
	String sUserID =CurUser.getUserID();
	String sOrgID=CurUser.getOrgID();
	String sCurBranchSortNo = ""; //当前用户所在分行的SortNo
	String sTempletNo = "GroupCustomerList";//模板
	String sRight="ReadOnly";
	String sRoleID="";

	//获得组件参数    ：客户类型
	String sCustomerType = CurComp.getParameter("CustomerType");
	if(sCustomerType == null) sCustomerType = "";
    	
   	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
    doTemp.setHtmlEvent("", "ondblclick", "viewGroupInfo");//添加双击查看详情功能

	
    doTemp.setJboWhere("CI.CustomerType='0210' and CI.CustomerID=O.GroupID");
    //000：系统管理员，036：总行集团家谱查询岗
    //080: 总行客户经理,280：分行客户经理，480：支行客户经理 
    //236: 分行集团家谱查询岗，436：支行集团家谱查询岗
   	if(CurUser.hasRole("000")|| CurUser.hasRole("036")){
   		//查看全行集团
   	}else if(CurUser.hasRole("080")|| CurUser.hasRole("280")|| CurUser.hasRole("480")){
   		doTemp.appendJboWhere(" and O.MgtOrgID=:orgID and O.MgtUserID=:userID");//查看管辖内集团
   	}else if(CurUser.hasRole("236")|| CurUser.hasRole("436")){
   		doTemp.appendJboWhere(" and O.InputOrgID=:orgID");//查看机构下集团
   	}
    
    //产生DataWindow
    ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
    dwTemp.setPageSize(20); //设置在datawindows中显示的行数
    dwTemp.Style="1"; //设置DW风格 1:Grid 2:Freeform
    dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    
    //生成HTMLDataWindow
	dwTemp.genHTMLObjectWindow(sOrgID+","+sUserID);  

    String sButtons[][] = {
	    {"true","","Button","集团详情","集团详情","viewGroupInfo()","","","",""},
    };
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script language=javascript>
    /*~[Describe=集团概况;InputParam=无;OutPutParam=无;]~*/
	function viewGroupInfo(){
      	var sGroupID = getItemValue(0,getRow(),"GroupID");
      	if (typeof(sGroupID)=="undefined" || sGroupID.length==0){
      	    alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		//打开集团详情页面
		AsCredit.openFunction("CustomerDetail","CustomerID="+sGroupID+"&RightType=ReadOnly","");
	    reloadSelf();	
	}  

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>