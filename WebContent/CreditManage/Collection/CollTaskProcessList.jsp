<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%	
	String taskSerialNo = CurPage.getParameter("SerialNo");
	String objectNo = CurPage.getParameter("ObjectNo");
	String customerID = CurPage.getParameter("CustomerID");
	String DoFlag= CurPage.getParameter("DoFlag");
	String RightType=CurPage.getParameter("RightType");
	if(RightType==null) RightType="All";
	if(DoFlag==null) DoFlag="";
	
	//ȡ�õ�ǰ�ĺ�ͬ��
	String sContrctSerialNo=Sqlca.getString("select contractserialno from business_duebill where serialNo='"+objectNo+"'");
	if(sContrctSerialNo==null) sContrctSerialNo="";
	//ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("CollTaskProcessList",BusinessObject.createBusinessObject(),CurPage);
	//ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List(doTemp, CurPage, request);
	ASObjectModel doTemp = new ASObjectModel("CollTaskProcessList");
	doTemp.setHtmlEvent("CONTACTMETHOD", "onChange", "operateDescription");
	//����Ƿ��д����嵥�򿪵Ĵ���������棬��ô������ϢΪ����
	if("check".equals(DoFlag)){
		doTemp.setReadOnly("CONTACTORTYPE,CONTACTTELNO,CONTACTMETHOD,EXPLANATIONCODE,CONTACTRESULT", true);
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.ReadOnly = "0";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("TaskSerialNo", taskSerialNo);
	dwTemp.setParameter("SerialNo", objectNo);
	dwTemp.genHTMLObjectWindow(taskSerialNo+","+objectNo);
	dwTemp.replaceColumn("collinfo", "<iframe type='iframe' id=\"GroupList\" name=\"frame_list\" width=\"100%\" height=\"300\" frameborder=\"0\" src=\""+sWebRootPath+"/Blank.jsp\"></iframe>", CurPage.getObjectWindowOutput());

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			//{"true","All","Button","����","����","add()","","","","",""},
			{!"check".equals(DoFlag)?"true":"false","All","Button","����","����","save()","","","","",""},
			//{"true","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0)","","","","",""},
			{"true","All","Button","���յ绰��","���յ绰��","tel()","","","","",""},
			//{"true","All","Button","Ƿ����ϸ","Ƿ����ϸ","pay()","","","","",""},
			{"true","All","Button","��ŵ����ƻ�","��ŵ����ƻ�","addcrs()","","","","",""},
			{"false","All","Button","ԤԼ��������","ԤԼ��������","todo()","","","","",""},
			{"false","All","Button","������������","������������","message()","","","","",""},
			{"false","All","Button","�˹���Ԥ","�˹���Ԥ","manual()","","","","",""},
			{"false","All","Button","���","���","finish()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	ObjectNo="<%=objectNo%>";
	
	function save(){
		initSerialNo();
		as_save(0,"AfterInsert()");
		self.reloadSelf();
	}
	function AfterInsert(){
		var serialNo = "<%=taskSerialNo%>";
		var CONTACTMETHOD=getItemValue(0,getRow(),"CONTACTMETHOD");
		var CONTACTRESULT=getItemValue(0,getRow(),"CONTACTRESULT");
		var EXPLANATIONCODE=getItemValue(0,getRow(),"EXPLANATIONCODE");
		var PROCESSUSERID=getItemValue(0,getRow(),"PROCESSUSERID");
		AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.colltask.action.InsertCollTask", "updateCollTask", "CONTACTMETHOD="+CONTACTMETHOD+",CONTACTRESULT="+CONTACTRESULT+",EXPLANATIONCODE="+EXPLANATIONCODE+",SerialNo="+serialNo+",PROCESSUSERID="+PROCESSUSERID);
		var taskSerialNo = "<%=taskSerialNo%>";
		var objectNo = "<%=objectNo%>";
		var customerID ="<%=customerID%>";
		AsControl.OpenPage("/CreditManage/Collection/CollTaskProcessList.jsp","SerialNo="+taskSerialNo+"&CustomerID="+customerID+"&ObjectNo="+ObjectNo,"_self");

		//reloadSelf();
	}
	
	function message(){
		var CustomerID = "<%=customerID%>";
		var serialNo = "<%=objectNo%>";
		AsControl.PopView("/CreditManage/Collection/PubMessageInfo.jsp","CustomerID="+CustomerID+"&SerialNo="+serialNo,"");
	}
	function pay(){
		var objectNo = "<%=objectNo%>";
		AsControl.PopView("/CreditManage/Collection/AcctPaymentLogList.jsp", "ObjectNo="+objectNo);
	}
	function add(){
		as_add("myiframe0");
		setItemValue(0,getRow(),"TASKSERIALNO","<%=taskSerialNo%>");
		setItemValue(0,getRow(),"PROCESSDATE","<%=com.amarsoft.app.base.util.DateHelper.getBusinessDate()%>");
		setItemValue(0,getRow(),"PROCESSUSERID","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(),"PROCESSORGID","<%=CurUser.getOrgID()%>");
		setItemValue(0,getRow(),"INPUTUSERID", "<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(),"INPUTORGID", "<%=CurUser.getOrgID()%>");
		setItemValue(0,getRow(),"INPUTDATE", "<%=com.amarsoft.app.base.util.DateHelper.getBusinessDate()%>");
	}
	function tel(){
		var customerID = "<%=customerID%>";
		var serialNo = "<%=objectNo%>";
		var DoFlag="<%=DoFlag%>";
		AsControl.PopView("/CreditManage/Collection/ALCustomerTelList.jsp","CustomerID="+customerID+"&DoFlag="+DoFlag+"&SerialNo="+serialNo,"");
	}
	function addcrs(){
		var taskSerialNo = getItemValue(0,getRow(0),'TaskSerialNo');
		var objectNo = "<%=objectNo%>";
	 	if(typeof(taskSerialNo)=="undefined" || taskSerialNo.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
	 	}
	 	DoFlag="<%=DoFlag%>";
	 	var RightType="";
	 	if(DoFlag=="check"){
	 		RightType="ReadOnly";
	 	}else{
	 		RightType="All";
	 	}
		//AsCredit.openFunction("CollRepaymentList","TaskSerialNo="+taskSerialNo+"&ObjectNo="+objectNo);
		AsControl.PopView("/CreditManage/Collection/ALBkankInfo.jsp","TaskSerialNo="+taskSerialNo+"&RightType="+RightType+"&ObjectNo="+objectNo,"");

		reloadSelf();
	}
	function manual(){
		var taskSerialNo = getItemValue(0,getRow(0),"TaskSerialNo");
		if(typeof(taskSerialNo)=="undefined" || taskSerialNo.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
	 	}
		PopPage("/CreditManage/Collection/CollTaskManualInfo.jsp", "SerialNo="+taskSerialNo,"dialogWidth:450px;dialogHeight:240px;");
	}
	function todo(){
		AsControl.PopView("/CreditManage/Collection/PubTaskInfo.jsp","","dialogWidth:700px;dialogHeight:500px;");
	}
	function finish(){
		var serialNo = "<%=taskSerialNo%>";
		AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.colltask.action.InsertCollTask", "finishCollTask", "SerialNo="+serialNo);
		if(!confirm("�Ƿ������һ�ʴ��������ִ�У�")){
			top.close();
			return returnValue = "false";
		}else{
			top.close();
			return returnValue = "true";
		}
	}
	function selectCustomerTel(){
		var CUSTOMERID = "<%=customerID%>";
		var CONTACTORTYPE =getItemValue(0,getRow(),"CONTACTORTYPE");
		var selectSource = "";
		if(typeof(CONTACTORTYPE)=="undefined"||CONTACTORTYPE==''||CONTACTORTYPE.length==0){
			alert("����ѡ����ն�������");
			return;
		}
		if(CONTACTORTYPE == "0101"){
			selectSource = "CustomerTEL1";//����˱���
			setGridValuePretreat(selectSource,'<%=customerID%>','CONTACTTELNO=TelePhone','');
		}else if(CONTACTORTYPE == "0103"){
		    var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.urge.CollSelectTel", "CheckTelphone", "CustomerID="+CUSTOMERID+",ContactorType="+CONTACTORTYPE);
		    if("yes"==sReturn){
		    	selectSource = "CustomerTEL3";//����˵�����
		    	setGridValuePretreat(selectSource,CUSTOMERID+","+CONTACTORTYPE,"CONTACTTELNO=TelePhone","");
		    }else{
		    	selectSource = "CustomerTEL2";//����˵�����
		    	setGridValuePretreat(selectSource,'<%=sContrctSerialNo%>','CONTACTTELNO=TelePhone','');
		    }
			
		}else{
			 var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.urge.CollSelectTel", "CheckTelphone", "CustomerID="+CUSTOMERID+",ContactorType="+CONTACTORTYPE);
			 if("yes"==sReturn){
			    selectSource = "CustomerTEL3";//����˹�ϵ��
			    setGridValuePretreat(selectSource,CUSTOMERID+","+CONTACTORTYPE,"CONTACTTELNO=TelePhone","");
			 }else{
			    selectSource = "CustomerTEL";//����˹�ϵ��
			    setGridValuePretreat(selectSource,'<%=customerID%>','CONTACTTELNO=TelePhone','');
			 }
			
		}
	}
	
	function init(){
		setItemValue(0,getRow(),"CUSTOMERID","<%=customerID%>");
		setItemValue(0,getRow(),"TASKSERIALNO","<%=taskSerialNo%>");
		setItemValue(0,getRow(),"PROCESSDATE","<%=com.amarsoft.app.base.util.DateHelper.getBusinessDate()%>");
		setItemValue(0,getRow(),"PROCESSUSERID","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(),"PROCESSORGID","<%=CurUser.getOrgID()%>");
		setItemValue(0,getRow(),"INPUTUSERID", "<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(),"PROCESSUSERNAME","<%=CurUser.getUserName()%>");
		setItemValue(0,getRow(),"INPUTORGID", "<%=CurUser.getOrgID()%>");
		setItemValue(0,getRow(),"INPUTDATE", "<%=com.amarsoft.app.base.util.DateHelper.getBusinessDate()%>");
	}
	
	function initSerialNo(){
		
		var sTableName = "COLL_TASK_PROCESS";//����
		var sColumnName = "SERIALNO";//�ֶ���
		var sPrefix = "";//ǰ׺
		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);		
		return sSerialNo;
	}
	
	function operateDescription(){

		var ContactMethod=getItemValue(0,getRow(),"CONTACTMETHOD");
		if(ContactMethod=="1" ||ContactMethod=="2"||ContactMethod=="3"||ContactMethod=="4"||ContactMethod=="5"){
			showItem(0,'CONTACTRESULT');
		  $("[name=CONTACTRESULT]").each(function(){
		 	$(this).parent().hide();
		 	if(ContactMethod=="1"){
		 		setItemRequired("myiframe0","CONTACTTELNO",true);
				if(this.value=="0101" || this.value=="0102"){
					$(this).parent().show();
				}
		 	}else if(ContactMethod=="2"){
		 		setItemRequired("myiframe0","CONTACTTELNO",true);
		 		if(this.value=="0201" || this.value=="0202"|| this.value=="0203"|| this.value=="0204"|| this.value=="0205"
				  || this.value=="0206"|| this.value=="0207"|| this.value=="0208"|| this.value=="0209"|| this.value=="0210"|| this.value=="0299"){
					$(this).parent().show();
				}
		 	}else if(ContactMethod=="3"){
		 		setItemRequired("myiframe0","CONTACTTELNO",false);
		 		if(this.value=="0301" || this.value=="0302"|| this.value=="0303"|| this.value=="0304"
					  || this.value=="0305"|| this.value=="0306"|| this.value=="0399"){
					$(this).parent().show();
				}
			}else if(ContactMethod=="4"){
				setItemRequired("myiframe0","CONTACTTELNO",false);
				 if(this.value=="0401" || this.value=="0402"|| this.value=="0403"|| this.value=="0404"|| this.value=="0405"
					  || this.value=="0406"|| this.value=="0407"|| this.value=="0408"|| this.value=="0409"
					  || this.value=="0410"|| this.value=="0411"|| this.value=="0412"|| this.value=="0413"){
					$(this).parent().show();
				}
			}else if(ContactMethod=="5"){
				setItemRequired("myiframe0","CONTACTTELNO",false);
				if(this.value=="0900"){
					$(this).parent().show();
				}
			}    
		  }); 
		}else{
			hideItem(0,'CONTACTRESULT');
		}
	}

	$(document).ready(function(){
		init();
		operateDescription();
		AsControl.OpenPage("/CreditManage/Collection/CLCollTaskInfo.jsp","ObjectNo="+ObjectNo+"&ObjectType=jbo.acct.ACCT_LOAN","frame_list");
	});
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
