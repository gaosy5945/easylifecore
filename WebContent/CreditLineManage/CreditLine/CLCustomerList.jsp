 <%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("CLCustomerList");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	//dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("SerialNo");
	
	String sButtons[][] = {
			{"true","","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"true","","Button","保存","保存","saveRecord()","","","","btn_icon_add",""},
			{"true","","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0,'alert(getRowCount(0))')","","","","btn_icon_delete",""},
		};
%> 
<script type="text/javascript">
	function add(){
		 var sParaString = "UserID"+","+"<%=CurUser.getUserID()%>"+","+"CustomerType"+",01";
		 subSelectCustomer("SelectApplyCustomer3",sParaString);
		
	}

	/*~[Describe=获取客户编号和名称;InputParam=对象类型，返回列位置;OutPutParam=无;]~*/
	function subSelectCustomer(selectName,sParaString){
		try{
			o = setObjectValue(selectName,sParaString,"",0,0,"");
			oArray = o.split("@");
			if(oArray[0]=="_CLEAR_"){
				setItemValue(0,getRow(),"CustomerID","");
				setItemValue(0,getRow(),"CustomerName","");
				return;
			}
			 as_add(0);
			setItemValue(0,getRow(),"CustomerID",oArray[0]);
			setItemValue(0,getRow(),"CustomerName",oArray[1]);
		}catch(e){
			return;
		}
	}	

	function saveRecord(){
		var irowCount=getRowCount(0);
		alert(irowCount);
		var mapValue=[];
		var clCustomer=[];
		for(var irow=0;irow<irowCount;irow++){
			var customerId=getItemValoue(0,irow,"CustomerID");
			var limitSum=getItemValoue(0,irow,"LIMITSUM");
			var exposureSum=getItemValoue(0,irow,"EXPOSURESUM");
			customer={"CustomerID":customerId,"limitSum":limitSum,"exposureSum":exposureSum};
			clCustomer.push(clCustomer);
		}
		mapValue[]
	}
	
	function edit(){
		 var sUrl = "";
		 OpenPage(sUrl+'?SerialNo=' + getItemValue(0,getRow(0),'SerialNo'),'_self','');
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
 