<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("BuildingRepairedList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	//dwTemp.ReadOnly = "0";	 //�༭ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(CurUser.getOrgID());
	
	String sButtons[][] = {
			{"true","","Button","����¥��","����","add()","","","","btn_icon_add",""},
			{"true","","Button","¥������","����","edit()","","","","btn_icon_detail",""},
			{"true","","Button","����¥��","ɾ��","deleteRecord()","","","","btn_icon_delete",""},
			{"true","","Button","ͣ��","ͣ��","stop()","","","","btn_icon_delete",""},
			{"true","","Button","����","����","start()","","","","btn_icon_delete",""},
			
		};
%> 
<script type="text/javascript">
	/*~[Describe=����¥��;InputParam=��;OutPutParam=��;]~*/
	function add(){
		var size ="resizable=yes;dialogWidth=30;dialogHeight=11;center:yes;status:no;statusbar:no";
		var serialNo = AsControl.PopView("/CustomerManage/PartnerManage/InitBuildIngInfo.jsp", "", size );
    	if(typeof(serialNo) == "undefined" || serialNo.length == 0 || serialNo == '_CANCEL_'){
			return;
		}
    	popComp("","/CustomerManage/PartnerManage/BuildingInfo.jsp","SerialNo="+serialNo,"");
    	reloadSelf();
	}
	/*~[Describe=�鿴����;InputParam=��;OutPutParam=��;]~*/
	function edit(){
		var serialNo = getItemValue(0,getRow(0),"SerialNo");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		popComp("","/CustomerManage/PartnerManage/BuildingInfo.jsp","SerialNo="+serialNo,"");
    	reloadSelf();
	}
	/*~[Describe=����¥��;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord(){
		
		var serialNo = getItemValue(0,getRow(0),"SerialNo");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		var status = getItemValue(0,getRow(0),"status");
		if(status=="1"){
			alert("����״̬����Ŀ��������");
			return;
		}
		
		if(confirm('¥���������¥����Ϣ���ᱻ����,ȷʵҪ������?')){
			var returnValue = RunJavaMethodTrans("com.amarsoft.app.als.customer.partner.action.BuildingAction","remove","serialNo=" + serialNo);
			if(returnValue == "1"){
				//alert("����ɹ�");
				reloadSelf();
			}else if(returnValue == "3"){
				alert("��¥���ѱ���Ŀ���ò�������");
			}else{
				alert("����ʧ��");
				return;
			}
			
		}
	}
	
	/*~[Describe=�޸�״̬;InputParam=��;OutPutParam=��;]~*/
	function stop()
	{
		var serialNo = getItemValue(0,getRow(0),"SerialNo");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		var status = getItemValue(0,getRow(0),"status");
		if(status=="2"){
			alert("��Ŀ�Ѿ���ͣ��״̬");
			return;
		}
		var returnValue = RunJavaMethod("com.amarsoft.app.als.customer.partner.action.BuildingAction","updateStatus","serialNo=" + serialNo +",status=2");
		if(returnValue == "1"){
			//alert("ͣ�óɹ�");
			reloadSelf();
		}else if(returnValue == "3"){
			alert("��¥���ѱ���Ŀ���ò���ͣ��");
		}else if(returnValue == "2"){
			alert("ͣ��ʧ��");
		}
	}
	
	function start()
	{
		var serialNo = getItemValue(0,getRow(0),"SerialNo");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		var status = getItemValue(0,getRow(0),"status");
		if(status=="1"){
			alert("��Ŀ�Ѿ�������״̬");
			return;
		}
		var returnValue = RunJavaMethod("com.amarsoft.app.als.customer.partner.action.BuildingAction","updateStatus","serialNo=" + serialNo +",status=1");
		if(returnValue == "1"){
			alert("���óɹ�");
			reloadSelf();
		}else{
			alert("����ʧ��");
		}
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
