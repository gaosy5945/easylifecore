<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String sObjectNo = DataConvert.toString(CurPage.getParameter("ObjectNo"));//��Ŀ���
	String sObjectType = DataConvert.toString(CurPage.getParameter("ObjectType"));//��Ŀ����
	
	ASObjectModel doTemp = new ASObjectModel("AcctAccountsList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	//dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(sObjectNo+","+sObjectType);
	
	String sButtons[][] = {
			{"true","","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
			{"true","","Button","ɾ��","ɾ��","del()","","","","btn_icon_delete",""},
		};
%> 
<script type="text/javascript">
	function add(){
		var sObjectNo = '<%=sObjectNo%>';
		var sObjectType = '<%=sObjectType%>';
		var sUrl = "/AssetTransfer/AcctAccountsInfo.jsp";
		OpenPage(sUrl+'?ObjectNo='+sObjectNo+'&ObjectType='+sObjectType,'_self','');
	}
	
	function edit(){
	 	var sUrl = "/AssetTransfer/AcctAccountsInfo.jsp";
	 	var serialNo = getItemValue(0,getRow(),"SERIALNO");
		if(typeof(serialNo) == 'undefined' || serialNo.length == 0){
			alert("����ѡ��һ����¼");
			return;
		}
		
		OpenPage(sUrl+'?SerialNo='+serialNo,'_self','');
	}
	
	function del(){
		var serialNo = getItemValue(0,getRow(),"SERIALNO");
		if(typeof(serialNo) == 'undefined' || serialNo.length == 0){
			alert("����ѡ��һ����¼");
			return;
		}
		
		if(confirm('ȷʵҪɾ����?')){
			as_delete(0);
		}
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
