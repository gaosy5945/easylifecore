 <%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("CLCustomerList");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	//dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("SerialNo");
	
	String sButtons[][] = {
			{"true","","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","����","����","saveRecord()","","","","btn_icon_add",""},
			{"true","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0,'alert(getRowCount(0))')","","","","btn_icon_delete",""},
		};
%> 
<script type="text/javascript">
	function add(){
		 var sParaString = "UserID"+","+"<%=CurUser.getUserID()%>"+","+"CustomerType"+",01";
		 subSelectCustomer("SelectApplyCustomer3",sParaString);
		
	}

	/*~[Describe=��ȡ�ͻ���ź�����;InputParam=�������ͣ�������λ��;OutPutParam=��;]~*/
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
 