<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%		
	//获取参数
	String partnerType = CurPage.getParameter("PartnerType");

	ASObjectModel doTemp = new ASObjectModel("PartnerList");
    doTemp.setHtmlEvent("", "ondblclick", "viewAndEdit");//添加双击查看详情功能

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(partnerType +"," + CurUser.getUserID());
	
	String sButtons[][] = {
			 {"true","","Button","合作方注册","合作方注册","newRecord()","","","","btn_icon_add"},
			 {"true","","Button","查看详情","查看详情","viewAndEdit()","","","","btn_icon_detail"},
			 {"true","","Button","移除合作方客户","移除合作方客户","roMove()","","","","btn_icon_delete"},
			 {"false","","Button","客户信息查询","客户信息查询","selectCust()","","","","btn_icon_detail"},
		};
%> 
<script type="text/javascript">

	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord(){	
		var size = "resizable=yes;dialogWidth=26;dialogHeight=23;center:yes;status:no;statusbar:no";
		var returnValue = AsControl.PopComp("/CustomerManage/PartnerManage/PartnerCusInfo.jsp","PartnerType=<%=partnerType%>","dialogWidth=450px;dialogHeight=350px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(returnValue)=="undefined" || returnValue == "_CALCEL_"){
			return ;	
		}
		reloadSelf();
	}
	
	 /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
   	function viewAndEdit(){
   		var customerID = getItemValue(0,getRow(),"CustomerID");
		if (typeof(customerID) == "undefined" || customerID.length == 0){
		    alert(getHtmlMessage('1'));//请选择一条信息！
		    return;
		}
    	AsCredit.openFunction("CustomerDetail","CustomerID="+customerID+"&PG_CONTENT_TITLE=show","");
   		//openObject("Customer",customerID,"001");
   		OpenPage("/CustomerManage/PartnerManage/PartnerCusList.jsp?PartnerType=<%=partnerType%>","_self");
    }

 	//客户查询
    function selectCust(){
    	popComp("SelectCustInfo","/CustomerManage/SelectCustInfo.jsp","","dialogWidth=40;dialogHeight=20;");
    } 
    
    /*~[Describe=移除客户信息;InputParam=CustomerID,ObjectType=;OutPutParam=无;]~*/
    function roMove(){	
        var customerID = getItemValue(0,getRow(),"CustomerID");
        if (typeof(customerID) == "undefined" || customerID.length == 0){
		    alert(getHtmlMessage('1'));//请选择一条信息！
		    return;
		}
        
        if(confirm(getHtmlMessage('2'))){ //您真的想删除该信息吗？
	    	var returnValue = RunJavaMethod("com.amarsoft.app.als.customer.partner.action.CustomerOperate","removePartner","customerID="+customerID);
	    	if(returnValue=="1"){
				alert("移除客户成功");
		    	reloadSelf();
	        }else if(returnValue =="2"){
	        	alert("此合作方客户存在项目信息不能移除");
	        	return;
	        }
        }
     }		
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
